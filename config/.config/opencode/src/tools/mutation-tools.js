function createMutationTools({ runner, adapters = {} } = {}) {
  if (!runner) {
    throw new Error("runner is required");
  }

  return {
    writeFile(payload) {
      return runner.executeMutation("workspace.writeFile", () => adapters.writeFile?.(payload));
    },

    gitCommit(payload) {
      return runner.executeMutation("git.commit", () => adapters.gitCommit?.(payload));
    },

    gitMerge(payload) {
      return runner.executeMutation("git.merge", () => adapters.gitMerge?.(payload));
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
