const {
  BUDGET_EXHAUSTED_PROMPT,
  createExecutionContext
} = require("./execution-context");

class AgentRunner {
  constructor({ request, agentConfig, config, operationCosts, logger } = {}) {
    const built = createExecutionContext({
      request,
      agentConfig,
      config,
      operationCosts,
      logger
    });

    this.executionContext = built.context;
    this.warnings = built.warnings;
    this.injectedSystemPrompts = [];
    this.forceTextOnly = false;
  }

  ensureBudgetExhaustedPromptQueued() {
    if (!this.injectedSystemPrompts.includes(BUDGET_EXHAUSTED_PROMPT)) {
      this.injectedSystemPrompts.push(BUDGET_EXHAUSTED_PROMPT);
    }
    this.forceTextOnly = true;
  }

  executeMutation(opName, execute, options = {}) {
    const cost = options.cost ?? 1;

    if (!this.executionContext.tryConsume(cost, opName)) {
      this.ensureBudgetExhaustedPromptQueued();
      return {
        ok: false,
        blocked: true,
        reason: "budget_exhausted",
        remainingSteps: this.executionContext.remainingSteps
      };
    }

    const result = execute();
    return {
      ok: true,
      blocked: false,
      result,
      remainingSteps: this.executionContext.remainingSteps
    };
  }

  prepareNextTurn() {
    return {
      systemPrompts: [...this.injectedSystemPrompts],
      forceTextOnly: this.forceTextOnly
    };
  }
}

module.exports = {
  AgentRunner
};
