---
name: test-types
description: Analisa cobertura de tipos TypeScript
compatibility: opencode
when_to_use: Para auditar anys implicitos e garantir protecao do TypeScript
allowed-tools: ["Read", "Write", "Bash", "Glob"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Analisar cobertura de tipos TypeScript, identificar anys implicitos e gerar relatorio de protecao de tipos.

## When to use

- Antes de releases importantes
- Quando suspeitar de anys espalhados
- Para melhorar seguranca de tipos
- Depois de migracoes JS -> TS
- Complemento ao Zod para validacao estatica

## Dependencies Check

Verifique instalacao:
- `typescript-coverage-report` - principal
- `typescript` - obrigatorio
- Opcional: `type-coverage` (CLI alternativa)

Se faltando: "Instale com: npm install -D typescript-coverage-report"

## Workflow

1. **Configure tsconfig**
   - Verifique `strict: true` esta ativado
   - `noImplicitAny: true` recomendado

2. **Execute analise**
   - `npx typescript-coverage-report`
   - ou: `npx type-coverage --detail`

3. **Gere relatorio**
   - HTML para visualizacao
   - JSON para CI/automacao
   - Lista priorizada de arquivos com problemas

4. **Reporte findings**
   - Percentual de cobertura
   - Arquivos criticos com anys
   - Sugestoes de correcao

## Exemplo de Output

```
Type Coverage Report
====================

Coverage: 87.34%

Arquivos com anys implicitos (prioridade):

1. src/api/client.ts (3 anys)
   - Linha 45: response.data
   - Linha 67: error.response
   - Linha 89: config.headers
   
2. src/utils/parser.ts (2 anys)
   - Linha 12: JSON.parse(data)
   - Linha 34: return result
   
3. src/components/List.tsx (1 any)
   - Linha 23: items.map((item: any) => ...)

Recomendacoes:
- Defina interfaces para respostas de API
- Use unknown em vez de any para parses
- Ative strictFunctionTypes no tsconfig
```

## Expected Input

- Projeto TypeScript a analisar
- Threshold de cobertura desejado (ex: 90%)
- Diretorios a incluir/excluir

## Expected Output

- Relatorio HTML/JSON de cobertura
- Lista de arquivos com anys
- Sugestoes de tipagem
- Comando para reexecutar

## Notes

- anys implicitos sao mais perigosos que explicitos
- Foque em arquivos de API e parsers primeiro
- Use `unknown` + type guards em vez de `any`
- Integre com CI: falhe build se cobertura < threshold
- Combine com Zod para validacao runtime + estatica

## Comandos Uteis

```bash
# Gerar relatorio HTML
npx typescript-coverage-report

# Apenas percentual
npx type-coverage

# Com threshold (CI)
npx type-coverage --at-least=90 --strict

# Excluir arquivos
npx typescript-coverage-report --excludeFiles='**/*.test.ts'
```
