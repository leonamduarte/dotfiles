const { AgentRunner } = require("../src/runner/agent-runner");
const { BUDGET_EXHAUSTED_PROMPT } = require("../src/runner/execution-context");
const { createMutationTools } = require("../src/tools/mutation-tools");

describe("step budget integration", () => {
  test("blocks 4th action when limit is 3 and injects warning prompt", () => {
    const calls = [];
    const runner = new AgentRunner({
      request: {},
      agentConfig: { steps: 3 },
      operationCosts: { "git.merge": 1 }
    });

    const tools = createMutationTools({
      runner,
      adapters: {
        writeFile: () => calls.push("writeFile"),
        gitCommit: () => calls.push("gitCommit"),
        gitMerge: () => calls.push("gitMerge"),
        execShell: () => calls.push("execShell")
      }
    });

    expect(tools.writeFile({}).ok).toBe(true);
    expect(tools.gitCommit({}).ok).toBe(true);
    expect(tools.gitMerge({}).ok).toBe(true);

    const blocked = tools.execShell({});
    expect(blocked.ok).toBe(false);
    expect(blocked.blocked).toBe(true);
    expect(blocked.budget_exhausted).toBe(true);

    expect(calls).toEqual(["writeFile", "gitCommit", "gitMerge"]);
    expect(runner.executionContext.remainingSteps).toBe(0);

    const nextTurn = runner.prepareNextTurn();
    expect(nextTurn.forceTextOnly).toBe(true);
    expect(nextTurn.budget_exhausted).toBe(true);
    expect(nextTurn.systemPrompts).toContain(BUDGET_EXHAUSTED_PROMPT);
  });

  test("supports git.* operations with custom operationCosts", () => {
    const calls = [];
    const runner = new AgentRunner({
      request: {},
      agentConfig: { steps: 3 },
      config: {
        agent: {
          operationCosts: {
            "git.rebase": 2
          }
        }
      }
    });

    const tools = createMutationTools({
      runner,
      adapters: {
        git: ({ action }) => calls.push(`git:${action}`),
        writeFile: () => calls.push("writeFile")
      }
    });

    expect(tools.git({ action: "rebase" }).ok).toBe(true);
    expect(tools.writeFile({}).ok).toBe(true);
    const blocked = tools.git({ action: "cherry-pick" });

    expect(blocked.ok).toBe(false);
    expect(calls).toEqual(["git:rebase", "writeFile"]);
    expect(runner.executionContext.remainingSteps).toBe(0);
  });
});
