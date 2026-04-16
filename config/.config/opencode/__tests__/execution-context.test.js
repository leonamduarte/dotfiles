const {
  BUDGET_EXHAUSTED_PROMPT,
  ExecutionContext,
  createExecutionContext,
  resolveInitialSteps
} = require("../src/runner/execution-context");

describe("ExecutionContext", () => {
  test("tryConsume decrements until exhaustion", () => {
    const ctx = new ExecutionContext({ initialSteps: 2 });

    expect(ctx.tryConsume()).toBe(true);
    expect(ctx.remainingSteps).toBe(1);
    expect(ctx.tryConsume()).toBe(true);
    expect(ctx.remainingSteps).toBe(0);
    expect(ctx.tryConsume()).toBe(false);
    expect(ctx.budgetExhausted).toBe(true);
    expect(ctx.budget_exhausted).toBe(true);
  });

  test("operationCosts overrides default cost by operation", () => {
    const ctx = new ExecutionContext({
      initialSteps: 5,
      operationCosts: {
        "git.merge": 3
      }
    });

    expect(ctx.tryConsume(1, "git.merge")).toBe(true);
    expect(ctx.remainingSteps).toBe(2);
    expect(ctx.tryConsume(1, "workspace.writeFile")).toBe(true);
    expect(ctx.remainingSteps).toBe(1);
  });

  test("request metadata override applies and caps at maxStepsCap", () => {
    const logger = { warn: jest.fn() };

    const resolved = resolveInitialSteps({
      request: { metadata: { agentSteps: 2000 } },
      agentConfig: { steps: 10, maxSteps: 99 },
      config: { agent: { maxStepsCap: 1000 } },
      logger
    });

    expect(resolved.initialSteps).toBe(1000);
    expect(resolved.warnings.some((w) => w.includes("agent.maxSteps"))).toBe(true);
    expect(
      resolved.warnings.some((w) => w.includes("request.metadata.agentSteps excede o cap"))
    ).toBe(true);
    expect(logger.warn).toHaveBeenCalled();
  });

  test("createExecutionContext returns default 50 steps", () => {
    const { context } = createExecutionContext({ request: {}, agentConfig: {} });
    expect(context.remainingSteps).toBe(50);
    expect(BUDGET_EXHAUSTED_PROMPT).toMatch(/^AVISO:/);
  });

  test("createExecutionContext picks operationCosts from config.agent.operationCosts", () => {
    const { context } = createExecutionContext({
      request: {},
      agentConfig: {},
      config: {
        agent: {
          operationCosts: {
            "shell.exec": 4
          }
        }
      }
    });

    expect(context.tryConsume(1, "shell.exec")).toBe(true);
    expect(context.remainingSteps).toBe(46);
  });
});
