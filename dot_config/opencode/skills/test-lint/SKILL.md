---
name: test-lint
description: Executa ESLint com regras de qualidade especificas
compatibility: opencode
when_to_use: Para garantir qualidade de codigo com linting automatizado
allowed-tools: ["Read", "Write", "Bash", "Glob"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Configurar e executar ESLint com plugins especificos para garantir qualidade consistente de codigo.

## When to use

- Antes de commits
- Em CI/CD
- Para manter consistencia do projeto
- Detectar problemas automaticamente (hooks, imports, anys)
- Refatoracoes em massa (--fix)

## Dependencies Check

Verifique instalacao:
- `eslint` - obrigatorio
- `@typescript-eslint/parser` - para TS
- `@typescript-eslint/eslint-plugin` - regras TS
- Plugins especificos (ver abaixo)

Se faltando: "Instale com: npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin"

## Plugins Recomendados

```json
{
  "devDependencies": {
    "eslint": "^8.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-no-relative-import-paths": "^1.5.0"
  }
}
```

## Regras Especificas

### React Hooks
```js
// Detecta dependencias erradas em hooks
'react-hooks/rules-of-hooks': 'error',
'react-hooks/exhaustive-deps': 'warn'
```

### Imports Organizados
```js
// Forca imports absolutos
'no-relative-import-paths/no-relative-import-paths': [
  'warn',
  { 'allowSameFolder': true }
]
```

### TypeScript Stricto
```js
// Proibe any explicito
'@typescript-eslint/no-explicit-any': 'error',
// Forca tipagem de retorno em funcoes publicas
'@typescript-eslint/explicit-function-return-type': 'warn'
```

## Workflow

1. **Verifique/Configure ESLint**
   - Verifique `.eslintrc.js` ou `eslintConfig` no package.json
   - Se nao existir, gere configuracao basica

2. **Execute lint**
   - `npx eslint . --ext .ts,.tsx`
   - ou: `npm run lint` (se script existir)

3. **Auto-corrigir se possivel**
   - `npx eslint . --ext .ts,.tsx --fix`
   - Reporte o que foi corrigido vs manual

4. **Reporte findings**
   - Erros que precisam correcao manual
   - Warnings para revisao
   - Estatisticas por categoria

## Exemplo de Output

```
ESLint Report
=============

Arquivos analisados: 42
Erros: 3 (requerem correcao)
Warnings: 12 (revisao recomendada)

Erros criticos:

1. src/hooks/useAuth.ts:45
   '@typescript-eslint/no-explicit-any'
   Uso de 'any' na funcao handleError

2. src/components/Button.tsx:23
   'react-hooks/exhaustive-deps'
   Hook useEffect tem dependencia faltando: [userId]

3. src/utils/api.ts:12
   'no-relative-import-paths/no-relative-import-paths'
   Import relativo: import { helper } from '../helpers'
   Sugestao: use '@utils/helpers'

Corrigidos automaticamente (--fix):
- 8 problemas de formatacao
- 3 imports nao usados

Restam 3 erros para correcao manual.
```

## Expected Input

- Projeto a analisar
- Configuracao ESLint existente (se houver)
- Plugins especificos desejados
- Diretorios a incluir/excluir

## Expected Output

- Relatorio de erros/warnings
- Lista do que foi auto-corrigido
- Sugestoes de configuracao
- Comando para reexecutar

## Notes

- Use `--fix` com cautela: revise mudancas antes de commitar
- Adicione ao git hooks (husky) para pre-commit
- CI: falhe build se houver erros (nao warnings)
- Combine com Prettier para formatacao (nao confunda regras)
- Ignore patterns: `node_modules/`, `dist/`, `*.generated.ts`

## Comandos Uteis

```bash
# Basico
npx eslint src/

# Com auto-fix
npx eslint src/ --fix

# So erros (sem warnings)
npx eslint src/ --quiet

# Formato JSON (para CI)
npx eslint src/ --format json --output-file eslint-report.json

# Cache para performance
npx eslint src/ --cache
```
