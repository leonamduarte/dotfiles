
## Contexto

Você está analisando uma configuração de Emacs Vanilla modularizada.

Objetivo: melhorar qualidade, remover redundâncias e garantir consistência sem alterar o comportamento principal.

A configuração segue estes princípios:

* simplicidade
* previsibilidade
* sem abstrações mágicas
* arquitetura modular (lisp/*.el)
* uso de Elpaca + use-package
* Evil + leader key system
* completion moderna (vertico, orderless, consult, corfu)
* LSP via eglot (não usar lsp-mode)

---

## Regras CRÍTICAS (NÃO QUEBRAR)

1. NÃO adicionar novos pacotes
2. NÃO trocar stack existente
3. NÃO reescrever arquitetura
4. NÃO mudar comportamento esperado
5. NÃO remover funcionalidades em uso
6. NÃO introduzir abstrações complexas
7. NÃO usar general.el

---

## Decisões de arquitetura (OBRIGATÓRIO RESPEITAR)

### Navegação

* dired é o padrão principal
* neotree é secundário (uso ocasional)
* NÃO introduzir treemacs
* NÃO duplicar responsabilidade entre dired e neotree

---

## Objetivos da refatoração

1. Remover redundâncias

   * funções duplicadas
   * keybindings duplicados
   * pacotes com função sobreposta

2. Unificar organização

   * mover funções utilitárias para `lisp/utils.el`
   * centralizar lógica repetida

3. Padronizar keymaps

   * evitar `global-set-key` desnecessário
   * usar apenas leader key quando possível

4. Limpar navegação

   * garantir que dired seja o fluxo principal
   * neotree apenas como visualizador opcional

5. Simplificar configuração

   * remover código morto
   * remover configs não utilizadas
   * reduzir complexidade sem perda de funcionalidade

---

## Tarefas

### 1. Auditoria

Liste:

* pacotes redundantes
* funções duplicadas
* keymaps conflitantes
* partes não utilizadas
* inconsistências entre arquivos

---

### 2. Plano de refatoração

Explique:

* o que será removido
* o que será movido
* o que será unificado
* por quê

---

### 3. Aplicação (IMPORTANTE)

Implemente mudanças de forma cirúrgica:

* mudanças pequenas e seguras
* sem reescrever tudo
* sem quebrar fluxo existente

---

### 4. Estrutura final esperada

Garantir:

* `utils.el` centralizado
* keymaps organizados
* navegação consistente
* ausência de duplicação

---

## Output esperado

1. Diagnóstico claro
2. Lista de mudanças
3. Código atualizado (somente partes alteradas)
4. Explicação curta por mudança

---

## Estilo de resposta

* direto
* técnico
* sem enrolação
* sem teoria desnecessária
* focado em ação

---

## Extra (opcional)

Se identificar melhorias simples que NÃO aumentem complexidade, pode sugerir no final.
