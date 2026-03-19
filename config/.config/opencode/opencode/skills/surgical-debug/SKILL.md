---
name: surgical-debug
description: Resolve bugs complexos de forma cirurgica, com diagnostico curto e patch minimo
compatibility: opencode
---

## Objetivo

Isolar a causa raiz de um bug especifico e propor a menor correcao segura.

## Quando usar

- Bug dificil de reproduzir ou intermitente.
- Correcao direta falhou mais de uma vez.
- Existe suspeita de causa nao obvia em fluxo critico.

## Regras

- Escopo: um bug por execucao, com foco em causa raiz.
- Nao escopo: auditoria geral de qualidade -> delegar para `audit-code`.
- Nao escopo: correcoes de varios itens do auditor -> delegar para `apply-audit-fixes`.
- Nao escopo: revisao arquitetural ampla -> delegar para `architecture-guard`.
- Arquivos permitidos: apenas os estritamente necessarios para o bug alvo.

### Criterios objetivos (Sim/Nao)

- [ ] Define bug alvo em 1 frase antes da correcao.
- [ ] Explica causa raiz com evidencia verificavel (stacktrace, teste ou caminho de execucao).
- [ ] Aplica patch minimo em no maximo 3 arquivos.
- [ ] Inclui validacao objetiva (teste, comando ou reproducoes antes/depois).
- [ ] Nao altera comportamento fora do bug alvo.

## Input esperado

- Descricao do bug e comportamento esperado.
- Passos de reproducao ou sinais observados.
- Logs, stacktrace ou arquivos suspeitos, se existirem.

## Output esperado

- Diagnostico curto com causa raiz.
- Patch minimo proposto/aplicado e validacao objetiva.
