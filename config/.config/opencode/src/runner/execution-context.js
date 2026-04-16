const DEFAULT_STEPS = 50;
const DEFAULT_MAX_STEPS_CAP = 1000;

const BUDGET_EXHAUSTED_PROMPT =
  "AVISO: o limite máximo de ações permitidas nesta execução foi atingido. Pare de executar ações que modificam o workspace. Responda apenas com texto contendo: 1) um resumo conciso do que você já fez (arquivos/commits); 2) lista priorizada de tarefas restantes; 3) comandos exatos/passos para continuar; 4) estimativa de passos adicionais necessários, se possível. Não tente executar mais ações automáticas.";

function toFiniteNumber(value) {
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
}

function clampToCap(value, cap) {
  return Math.max(0, Math.min(value, cap));
}

function normalizeOperationCosts(costs) {
  if (!costs || typeof costs !== "object") {
    return {};
  }

  return Object.entries(costs).reduce((acc, [name, rawCost]) => {
    const parsed = toFiniteNumber(rawCost);
    if (parsed === null) {
      return acc;
    }

    acc[name] = Math.max(1, Math.floor(parsed));
    return acc;
  }, {});
}

function resolveOperationCosts({ config, operationCosts } = {}) {
  if (operationCosts && typeof operationCosts === "object") {
    return normalizeOperationCosts(operationCosts);
  }

  return normalizeOperationCosts(config?.agent?.operationCosts);
}

function resolveInitialSteps({ request, agentConfig, config, logger } = {}) {
  const warnings = [];
  const maxStepsCap =
    toFiniteNumber(config?.agent?.maxStepsCap) ?? DEFAULT_MAX_STEPS_CAP;

  const logWarning = (message) => {
    warnings.push(message);
    if (logger && typeof logger.warn === "function") {
      logger.warn(message);
    }
  };

  if (typeof agentConfig?.maxSteps !== "undefined") {
    logWarning(
      "Config legado detectado: agent.maxSteps foi ignorado; use agent.steps."
    );
  }

  const requestOverride = toFiniteNumber(request?.metadata?.agentSteps);
  if (requestOverride !== null) {
    if (requestOverride > maxStepsCap) {
      logWarning(
        `request.metadata.agentSteps excede o cap (${maxStepsCap}); usando cap.`
      );
      return { initialSteps: maxStepsCap, maxStepsCap, warnings };
    }

    return {
      initialSteps: clampToCap(Math.floor(requestOverride), maxStepsCap),
      maxStepsCap,
      warnings
    };
  }

  const configuredSteps = toFiniteNumber(agentConfig?.steps);
  if (configuredSteps !== null) {
    if (configuredSteps > maxStepsCap) {
      logWarning(`agent.steps excede o cap (${maxStepsCap}); usando cap.`);
    }

    return {
      initialSteps: clampToCap(Math.floor(configuredSteps), maxStepsCap),
      maxStepsCap,
      warnings
    };
  }

  return {
    initialSteps: clampToCap(DEFAULT_STEPS, maxStepsCap),
    maxStepsCap,
    warnings
  };
}

class ExecutionContext {
  constructor({ initialSteps, maxStepsCap, operationCosts } = {}) {
    this.maxStepsCap =
      toFiniteNumber(maxStepsCap) ?? DEFAULT_MAX_STEPS_CAP;
    this.remainingSteps = clampToCap(
      toFiniteNumber(initialSteps) ?? DEFAULT_STEPS,
      this.maxStepsCap
    );
    this.operationCosts = normalizeOperationCosts(operationCosts);
    this.budgetExhausted = false;
    this.budget_exhausted = false;
    this.history = [];
  }

  getCost(opName, fallbackCost = 1) {
    if (opName && Object.prototype.hasOwnProperty.call(this.operationCosts, opName)) {
      return Math.max(1, Math.floor(this.operationCosts[opName]));
    }

    return Math.max(1, Math.floor(toFiniteNumber(fallbackCost) ?? 1));
  }

  tryConsume(cost = 1, opName) {
    const finalCost = this.getCost(opName, cost);

    if (this.remainingSteps < finalCost) {
      this.budgetExhausted = true;
      this.budget_exhausted = true;
      this.history.push({ opName: opName || "unknown", cost: finalCost, consumed: false });
      return false;
    }

    this.remainingSteps -= finalCost;
    this.history.push({ opName: opName || "unknown", cost: finalCost, consumed: true });
    return true;
  }
}

function createExecutionContext({ request, agentConfig, config, operationCosts, logger } = {}) {
  const resolved = resolveInitialSteps({ request, agentConfig, config, logger });
  const resolvedOperationCosts = resolveOperationCosts({ config, operationCosts });
  const context = new ExecutionContext({
    initialSteps: resolved.initialSteps,
    maxStepsCap: resolved.maxStepsCap,
    operationCosts: resolvedOperationCosts
  });

  return {
    context,
    warnings: resolved.warnings,
    initialSteps: resolved.initialSteps,
    maxStepsCap: resolved.maxStepsCap
  };
}

module.exports = {
  DEFAULT_STEPS,
  DEFAULT_MAX_STEPS_CAP,
  BUDGET_EXHAUSTED_PROMPT,
  ExecutionContext,
  createExecutionContext,
  resolveOperationCosts,
  resolveInitialSteps
};
