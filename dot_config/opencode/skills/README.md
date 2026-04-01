# Advanced Skills for Opencode

This directory contains advanced skills implementing patterns from Claude Code's architecture.

## New Skills Added

### 1. model_router ⭐ (Updated)
**File**: `model_router/SKILL.md`

Route tasks to the correct model and skill based on task type.

**Key Features:**
- ✅ Updated to English
- ✅ Advanced frontmatter (allowed-tools, model, context, effort)
- Routes to: minimax-m2.7 (analysis), codex-5.4-mini (implementation), codex-5.3 (debugging)

**Usage**: Called automatically or explicitly before complex tasks

---

### 2. parallel ⭐ (New)
**File**: `parallel/SKILL.md`

Execute multiple skills/agents in parallel for comprehensive analysis (like Claude Code's `/simplify`).

**Key Features:**
- Spawns multiple skills simultaneously
- 3-way review pattern (audit + simplify + architecture)
- Aggregated results
- Fork execution for isolation

**Usage**:
```
skill: parallel
agents: [audit-code, code-simplifier, architecture-guard]
target: recent changes
```

---

### 3. fork ⭐ (New)
**File**: `fork/SKILL.md`

Execute skills in isolated fork contexts with separate token budgets.

**Key Features:**
- Isolated execution context
- Separate token budgets (effort: 1-5)
- Permission bubbling
- Multiple isolation levels

**Usage**:
```
skill: fork
skill: audit-code
effort: 3
mode: bubble
```

---

### 4. zod-validator (Utility)
**File**: `_utils/zod-validator.md`

Zod validation schemas and helpers for skill inputs.

**Key Features:**
- Pre-built schemas for common inputs
- Validation helper functions
- Error message templates
- Best practices

**Usage**: Reference when creating skills with structured inputs

---

### 5. validate-example (Template)
**File**: `validate-example/SKILL.md`

Example skill demonstrating Zod validation patterns.

**Key Features:**
- Complete validation example
- TypeScript/Zod code samples
- Conditional validation
- Error handling

**Usage**: Template for creating validated skills

---

## Architecture Comparison

### Claude Code vs. Opencode Skills

| Feature | Claude Code | Opencode (Now) |
|---------|-------------|----------------|
| **Frontmatter** | YAML with metadata | ✅ Same format |
| **Multi-agent** | AgentTool + Coordinator | ✅ `parallel` skill |
| **Fork execution** | `context: fork` | ✅ `fork` skill |
| **Validation** | Zod schemas | ✅ `zod-validator` utility |
| **Bundled skills** | TypeScript + registration | ✅ Markdown-based |
| **Permission bubbling** | Built-in | ✅ Via `fork` skill |

---

## Skill Reference

### Available Skills

```
skills/
├── model_router/          ⭐ Updated - Task routing
├── parallel/              ⭐ NEW - Parallel execution
├── fork/                  ⭐ NEW - Isolated execution
├── validate-example/      NEW - Validation template
├── _utils/
│   └── zod-validator.md   NEW - Validation library
│
├── test-jest-unit/        ⭐ NEW - Testes unitarios com Jest
├── test-jest-integration/ ⭐ NEW - Testes de integracao com mocks
├── test-component/        ⭐ NEW - Testes de componentes React Native
├── test-e2e-maestro/      ⭐ NEW - Testes E2E com Maestro
├── test-types/            ⭐ NEW - Analise de cobertura de tipos
├── test-lint/             ⭐ NEW - ESLint com regras de qualidade
│
├── apply-audit-fixes/     Existing
├── architecture-guard/    Existing
├── audit-code/            ✅ Updated - Bug/security focus + optional focus hints
├── code_debug/            ✅ Updated - Smart debug workflow
├── code-simplifier/       ✅ Updated - Refactor helper workflow
├── feature-implement/     ✅ Updated - Implementation with lightweight test focus hints
├── qa-review/             ✅ Updated - Quality/process focus
├── repo_analysis/         ✅ Updated - Now with memory mode
└── SKILL-TEMPLATE.md      Template
```

---

## Skill Consolidation (No Duplicates)

### Changes Made to Eliminate Duplicates:

**1. audit-code + qa-review → Specialized Roles**
- ✅ **audit-code**: Now focuses ONLY on bugs, security, edge cases (technical audit)
- ✅ **qa-review**: Now focuses ONLY on tests, process, merge readiness (quality assurance)
- **Rule**: Use audit-code for technical issues, qa-review for process/readiness

**2. repo_analysis + repo-docs → Unified**
- ❌ **repo-docs**: REMOVED
- ✅ **repo_analysis**: Enhanced with `mode: memory` to generate memory/*.md files
- **Modes**: scan (analysis.md), plan (implementation plan), memory (repo context)

**3. fork + parallel → Clear Separation**
- ✅ **fork**: Low-level isolation primitive (context: fork, agent: worker)
- ✅ **parallel**: User-facing multi-agent orchestration (uses fork internally)
- **Rule**: Use parallel for multi-skill reviews, fork for isolated single-skill execution

**4. Hybrid Upgrade Instead of Skill Sprawl**
- ✅ **code_debug**: Upgraded into a smart debug workflow (reproduce -> isolate -> hypothesize -> fix -> verify)
- ✅ **code-simplifier**: Upgraded into a refactor helper (dedupe, readability, function-size, cleanup, testability)
- ✅ **audit-code / qa-review**: Keep their simple identities, but now accept focus hints for sharper runs
- ✅ **feature-implement**: Keeps implementation simple, but now accepts lightweight testing-oriented hints

**Result**: 13 skills → 11 skills (eliminated 2 duplicates, specialized 2 skills)

---

## Stable Skill Map

This is the intended long-term boundary for the current set:

- **Routing**: `model_router`
- **Repository understanding**: `repo_analysis`
- **Implementation**: `feature-implement`
- **Debugging concrete failures**: `code_debug`
- **Behavior-preserving cleanup**: `code-simplifier`
- **Technical audit**: `audit-code`
- **Quality / merge readiness**: `qa-review`
- **Architecture validation**: `architecture-guard`
- **Apply audit findings**: `apply-audit-fixes`
- **Parallel orchestration**: `parallel`
- **Isolated execution**: `fork`

Rule of thumb:

- If code is **broken**, use `code_debug`
- If code **works but is messy**, use `code-simplifier`
- If code needs a **bug/security sweep**, use `audit-code`
- If code needs a **merge-readiness review**, use `qa-review`
- If code needs to be **built**, use `feature-implement`

---

## Testing Skills (Execution-Focused)

Seis skills especialistas para geração e execução de testes:

### Testes Unitários
- **Skill**: `test-jest-unit`
- **Descrição**: Gera e executa testes unitários com Jest
- **Para**: Funções puras, parsers, cálculos, lógica de negócio
- **Gera**: Arquivos `.test.ts` com casos básicos + edge cases
- **Executa**: `jest` com relatório de cobertura

### Testes de Integração
- **Skill**: `test-jest-integration`
- **Descrição**: Testes de integração com Jest + MSW (mocks)
- **Para**: Fluxos completos com APIs mockadas
- **Gera**: `.integration.test.ts` + setup de mocks
- **Executa**: `jest` com mocks de serviços externos

### Testes de Componente
- **Skill**: `test-component`
- **Descrição**: Testes de componentes React Native
- **Para**: Componentes RN sem emulador (RNTL)
- **Gera**: `.test.tsx` com queries e interações
- **Executa**: `jest` com React Native Testing Library

### Testes E2E
- **Skill**: `test-e2e-maestro`
- **Descrição**: Testes end-to-end com Maestro para Expo
- **Para**: Fluxos de usuário real em devices
- **Gera**: Flows `.yaml` com comandos Maestro
- **Executa**: `maestro test flows/`

### Type Coverage
- **Skill**: `test-types`
- **Descrição**: Análise de cobertura de tipos TypeScript
- **Para**: Auditar `any`s implícitos
- **Gera**: Relatório HTML/JSON de cobertura
- **Executa**: `typescript-coverage-report`

### Lint de Qualidade
- **Skill**: `test-lint`
- **Descrição**: ESLint com plugins específicos
- **Para**: Qualidade automatizada de código
- **Gera**: Configuração ESLint se necessário
- **Executa**: `eslint --fix` com plugins (hooks, imports, no-any)

### Quando usar cada um?

| Etapa | Skill | O que faz |
|-------|-------|-----------|
| Unitário | `test-jest-unit` | Testa funções isoladas |
| Integração | `test-jest-integration` | Testa fluxos com mocks |
| Componente | `test-component` | Testa UI sem emulador |
| E2E | `test-e2e-maestro` | Testa em device real |
| Types | `test-types` | Audita anys |
| Lint | `test-lint` | Qualidade automática |

### Workflow de Testes

```
1. Durante implementação:
   skill: feature-implement focus: generate-tests
   
2. Testes unitários:
   skill: test-jest-unit
   target: src/utils/
   
3. Testes de integração:
   skill: test-jest-integration
   target: src/services/api.ts
   
4. Testes de componente:
   skill: test-component
   target: src/components/Button.tsx
   
5. E2E antes de release:
   skill: test-e2e-maestro
   target: flows/critical/
   
6. Qualidade e tipos:
   skill: parallel
   agents: [test-types, test-lint]
```

---

## Quick Start

### 1. Route a Task

```
skill: model_router
task: "Implement user authentication"
```

Routes to:
- If planning needed → minimax-m2.7 + repo_analysis
- If implementing → codex-5.4-mini + feature-implement (with optional test-focused hints)
- If debugging → codex-5.3 + code_debug (smart debug workflow)

### 2. Parallel Review

```
skill: parallel
agents: [
  "audit-code",
  "code-simplifier", 
  "architecture-guard"
]
target: "src/auth/*"
```

Runs all three in parallel, aggregates results.

### 3. Isolated Execution

```
skill: fork
skill: "audit-code"
effort: 3
isolation: worktree
```

Runs audit in isolated context with separate budget.

---

## Skill Selection Guide

### Code Review: Which to Use?

| Need | Use This | Don't Use |
|------|----------|-----------|
| Find bugs, security issues, edge cases | **audit-code** | qa-review (process focused) |
| Check tests, merge readiness, docs | **qa-review** | audit-code (technical bugs only) |
| Reproduce and fix a concrete failure | **code_debug** | audit-code (broad sweep) |
| Simplify/refactor code safely | **code-simplifier** | code_debug (failure focused) |
| Implement a feature with lightweight validation | **feature-implement** | qa-review (review only) |
| Architecture validation | **architecture-guard** | Either above |
| Apply audit fixes | **apply-audit-fixes** | Any review skill |

### Testing: Which to Use?

| Test Type | Use This | Gera | Executa |
|-----------|----------|------|---------|
| Unit tests (Jest) | **test-jest-unit** | `.test.ts` | `jest` |
| Integration tests | **test-jest-integration** | `.integration.test.ts` + mocks | `jest` |
| Component tests (RN) | **test-component** | `.test.tsx` (RNTL) | `jest` |
| E2E tests (Maestro) | **test-e2e-maestro** | `flows/*.yaml` | `maestro` |
| Type coverage | **test-types** | HTML/JSON report | `typescript-coverage-report` |
| Lint quality | **test-lint** | ESLint config | `eslint --fix` |

### Focus Hints

These skills stay simple, but accept lightweight focus hints when useful:

- `audit-code`: `security`, `edge-cases`, `concurrency`, `data-validation`, `performance`
- `qa-review`: `tests`, `merge-readiness`, `docs`, `observability`, `generate-tests`
- `code_debug`: `stack-trace`, `flaky-test`, `regression`, `data-flow`, `async`
- `code-simplifier`: `dedupe`, `readability`, `function-size`, `cleanup`, `testability`
- `feature-implement`: `minimal`, `tests`, `generate-tests`, `safety`, `integration`

### Repository Context: Which to Use?

| Need | Mode | Command |
|------|------|---------|
| Generate analysis.md | scan | `skill: repo_analysis mode: scan` |
| Create implementation plan | plan | `skill: repo_analysis mode: plan` |
| Update memory files | memory | `skill: repo_analysis mode: memory` |

---

## Advanced Features

### Frontmatter Fields

All new skills support Claude Code-style frontmatter:

```yaml
---
name: skill-name
description: What it does
compatibility: opencode
when_to_use: When to invoke this skill
allowed-tools: ["Read", "Edit", "Bash"]
model: inherit | minimax-m2.7 | codex-5.4-mini | codex-5.3
user-invocable: true | false
context: inline | fork
agent: worker | general | specialized
effort: 1-5
custom_field: any value
---
```

### Execution Contexts

**Inline** (`context: inline`):
- Shares parent conversation
- Fast execution
- Good for quick tasks

**Fork** (`context: fork`):
- Isolated context
- Separate token budget
- Good for heavy work

### Token Budgets (Effort)

```
effort: 1  → ~2K tokens   (Quick checks)
effort: 2  → ~5K tokens   (Simple edits)
effort: 3  → ~10K tokens  (Standard work)
effort: 4  → ~25K tokens  (Complex refactors)
effort: 5  → ~50K tokens  (Deep analysis)
```

---

## Best Practices

1. **Use model_router** before complex tasks
2. **Use parallel** for multi-perspective reviews
3. **Use fork** for isolated/heavy operations
4. **Validate inputs** with Zod schemas
5. **Set appropriate effort** levels
6. **Document** all skills thoroughly

---

## Creating New Skills

1. Copy `SKILL-TEMPLATE.md`
2. Add Zod validation if needed (see `validate-example/`)
3. Use advanced frontmatter fields
4. Test with both inline and fork contexts
5. Document in this README

---

## Integration Examples

### Complex Workflow

```
1. skill: model_router
   task: "Add payment processing"
   
2. → Routes to: repo_analysis (planning)
   
3. skill: parallel
   agents: [
     "architecture-guard",
     "audit-code"
   ]
   target: "payment module"
   
4. skill: fork
   skill: feature-implement
   effort: 4
   mode: bubble
```

This workflow:
- Routes correctly
- Plans architecture
- Reviews from multiple angles
- Implements with approval

---

## Notes

- All skills are in markdown format (not TypeScript like Claude Code)
- Frontmatter provides metadata and configuration
- Skills can invoke other skills (skill: name)
- Parallel execution requires fork context for true isolation
- Zod validation is recommended but optional

---

## Future Enhancements

Potential additions:
- [ ] Coordinator mode (orchestrates workers)
- [ ] MCP server integration
- [ ] Plugin system
- [ ] Custom tool registration
- [ ] Workflow automation
- [ ] Agent triggers

---

**Created**: 2024  
**Last Updated**: 2024 (Eliminated duplicates, specialized skills)  
**Pattern**: Claude Code-inspired  
**Status**: Production Ready  
**Total Skills**: 17 (11 core + 6 testing specialists, no duplicates)
