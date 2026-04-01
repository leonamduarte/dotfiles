---
name: test-jest-unit
description: Gera e executa testes unitarios com Jest
compatibility: opencode
when_to_use: Para testar funcoes puras, parsers, calculos e logica de negocio isolada
allowed-tools: ["Read", "Write", "Bash", "Glob"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Gerar e executar testes unitarios com Jest para funcoes puras, validando logica de negocio, parsers e transformacoes de dados.

## When to use

- Funcoes puras sem side effects
- Parsers e formatadores (ex: formatCurrency, parseDate)
- Calculos e totais
- Validacoes e regras de negocio
- Utilitarios e helpers

## Dependencies Check

Primeiro verifique se Jest esta instalado:
- Verifique `package.json` por `jest`
- Se nao estiver, retorne: "Jest nao instalado. Instale com: npm install -D jest @types/jest ts-jest"

## Workflow

1. **Analise a funcao**
   - Entrada: parametros e tipos
   - Saida: retorno esperado
   - Edge cases: null, undefined, vazio, zero, valores extremos

2. **Gere o arquivo de teste**
   - Nome: `{funcao}.test.ts` ou `{modulo}.test.ts`
   - Local: proximo ao arquivo testado ou em `__tests__/`

3. **Casos de teste obrigatorios**
   - Caso basico (happy path)
   - Edge cases tipicos
   - Casos de erro/invalidos

4. **Execute os testes**
   - Rode `npm test -- {arquivo}` ou `jest {arquivo}`
   - Reporte: passaram/falharam

## Exemplo de Output

```typescript
// utils/formatCurrency.test.ts
import { formatBRL } from './formatCurrency';

describe('formatBRL', () => {
  it('formata valor basico corretamente', () => {
    expect(formatBRL(1234.5)).toBe('R$ 1.234,50');
  });

  it('formata zero', () => {
    expect(formatBRL(0)).toBe('R$ 0,00');
  });

  it('formata valores negativos', () => {
    expect(formatBRL(-100)).toBe('-R$ 100,00');
  });

  it('lanca erro para null', () => {
    expect(() => formatBRL(null as any)).toThrow();
  });
});
```

## Expected Input

- Arquivo ou funcao a ser testada
- Exemplos de entrada/saida esperados (opcional)
- Contexto de edge cases conhecidos

## Expected Output

- Arquivo `.test.ts` gerado
- Resultado da execucao (pass/fail)
- Cobertura reportada se disponivel

## Notes

- Sempre verifique dependencias primeiro
- Prefira testes deterministicos (sem random, sem data atual hardcoded)
- Use describe/it para organizar
- Nao teste implementacao interna, apenas comportamento
