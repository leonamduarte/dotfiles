function normalize(text) {
  return String(text || "").toLowerCase();
}

function selectRoute(userMessage) {
  const input = normalize(userMessage);

  if (!input.trim()) {
    return { type: "agent", target: "implementer", reason: "fallback" };
  }

  if (/\b(planejar|planning|arquitetura|trade-?off|analise de repositorio|repository analysis)\b/.test(input)) {
    return { type: "agent", target: "planner", reason: "planning" };
  }

  if (/\b(jest|teste unitario|teste de integracao|unit test|integration test)\b/.test(input)) {
    return { type: "skill", target: "30-test-jest-unit", reason: "jest-tests" };
  }

  if (/\b(ajuste simples|mudanca simples|arquivo unico|one file|typo)\b/.test(input)) {
    return { type: "agent", target: "copilot-worker", reason: "simple-local-change" };
  }

  if (/^(o que|qual|quando|quem|where|what|which|is|are)\b/.test(input)) {
    return { type: "direct", target: "direct-answer", reason: "short-factual" };
  }

  return { type: "agent", target: "implementer", reason: "default-execution" };
}

const ALLOWED_TRIAGE_ACTIONS = new Set([
  "delegate_agent",
  "delegate_skill",
  "answer_direct",
  "read_small_context"
]);

function assertRouterActionAllowed(action) {
  if (!ALLOWED_TRIAGE_ACTIONS.has(action)) {
    throw new Error(`Action not allowed for triage: ${action}`);
  }
  return true;
}

module.exports = {
  selectRoute,
  assertRouterActionAllowed
};
