const { AgentRunner } = require("../src/runner/agent-runner");
const { createMutationTools } = require("../src/tools/mutation-tools");

describe("subagent sharing", () => {
  test("subagent consumes from same execution context", () => {
    const runner = new AgentRunner({
      request: {},
      agentConfig: { steps: 3 }
    });
    const tools = createMutationTools({ runner });

    expect(tools.writeFile({ path: "a" }).ok).toBe(true);
    expect(runner.executionContext.remainingSteps).toBe(2);

    const subagentRun = tools.spawnSubagent({
      run: (sharedContext) => {
        const consumed = sharedContext.tryConsume(1, "workspace.writeFile");
        return { consumed, remaining: sharedContext.remainingSteps };
      }
    });

    expect(subagentRun.ok).toBe(true);
    expect(subagentRun.result).toMatchObject({ consumed: true, remaining: 0 });
    expect(runner.executionContext.remainingSteps).toBe(0);
  });
});
