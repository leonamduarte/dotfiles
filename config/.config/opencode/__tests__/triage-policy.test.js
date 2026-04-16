const {
  selectRoute,
  assertRouterActionAllowed
} = require("../lib/triage-policy");

describe("triage policy", () => {
  test("routes planning requests to planner", () => {
    const route = selectRoute("Preciso planejar a arquitetura do modulo");
    expect(route).toMatchObject({ type: "agent", target: "planner" });
  });

  test("routes simple local change to copilot-worker", () => {
    const route = selectRoute("Fazer ajuste simples em arquivo unico");
    expect(route).toMatchObject({ type: "agent", target: "copilot-worker" });
  });

  test("routes jest requests to jest skill", () => {
    const route = selectRoute("Crie teste unitario com Jest para esse helper");
    expect(route).toMatchObject({ type: "skill", target: "30-test-jest-unit" });
  });

  test("allows direct answer for short factual question", () => {
    const route = selectRoute("Qual e o agente padrao?");
    expect(route).toMatchObject({ type: "direct", target: "direct-answer" });
  });

  test("allows triage delegation actions", () => {
    expect(assertRouterActionAllowed("delegate_agent")).toBe(true);
    expect(assertRouterActionAllowed("delegate_skill")).toBe(true);
  });

  test("denies edit and bash actions", () => {
    expect(() => assertRouterActionAllowed("edit_file")).toThrow(/not allowed/i);
    expect(() => assertRouterActionAllowed("run_bash")).toThrow(/not allowed/i);
  });
});
