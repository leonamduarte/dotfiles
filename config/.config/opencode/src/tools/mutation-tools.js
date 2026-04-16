function createMutationTools({ runner, adapters = {} } = {}) {
  if (!runner) {
    throw new Error("runner is required");
  }

  return {
    writeFile(payload) {
      return runner.executeMutation("workspace.writeFile", () => adapters.writeFile?.(payload));
    },

    git(payload = {}) {
      const action = typeof payload.action === "string" && payload.action.trim()
        ? payload.action.trim()
        : "operation";
      const opName = `git.${action}`;

      return runner.executeMutation(opName, () => {
        if (typeof adapters.git === "function") {
          return adapters.git(payload);
        }

        return adapters.gitCommit?.(payload);
      });
    },

    gitCommit(payload) {
      return runner.executeMutation("git.commit", () => {
        if (typeof adapters.gitCommit === "function") {
          return adapters.gitCommit(payload);
        }

        return adapters.git?.({ ...payload, action: "commit" });
      });
    },

    gitMerge(payload) {
      return runner.executeMutation("git.merge", () => {
        if (typeof adapters.gitMerge === "function") {
          return adapters.gitMerge(payload);
        }

        return adapters.git?.({ ...payload, action: "merge" });
      });
    },

    spawnSubagent(payload) {
      return runner.executeMutation("agent.spawnSubagent", () => {
        if (typeof adapters.spawnSubagent === "function") {
          return adapters.spawnSubagent(payload, runner.executionContext);
        }

        if (typeof payload?.run === "function") {
          return payload.run(runner.executionContext);
        }

        return null;
      });
    },

    execShell(payload) {
      return runner.executeMutation("shell.exec", () => adapters.execShell?.(payload));
    },

    networkMutatingCall(payload) {
      return runner.executeMutation("network.mutate", () => adapters.networkMutatingCall?.(payload));
    }
  };
}

module.exports = {
  createMutationTools
};
