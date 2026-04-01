# Relatório de Alterações: Doom Emacs vs Neovim

Este relatório descreve o estado real da configuração atual do Doom Emacs, mapeando equivalentes do ecossistema Neovim e acompanhando o progresso das melhorias.

## 1. Tabela De/Para (Neovim -> Doom)

| Plugin / Conceito Neovim | Equivalente no Doom Emacs | Estado atual |
| :--- | :--- | :--- |
| **LSPConfig / Mason** | `:tools (lsp +peek)` + `:lang <lang> +lsp` | Implementado |
| **nvim-cmp / blink.cmp** | `:completion (corfu +icons +terminal +orderless)` | Implementado |
| **Telescope / fzf-lua** | `vertico` + `consult-fd` | Implementado |
| **Oil.nvim** | `grease` (local em `lisp/grease/`) | Implementado (Local) |
| **Harpoon.nvim** | `harpoon` | Implementado |
| **Conform.nvim / null-ls** | `:editor (format +onsave)` | Implementado |
| **Toggleterm.nvim** | `vterm` (com toggle `SPC t v`) | Implementado |
| **Gitsigns / mini.diff** | `:ui (vc-gutter +pretty)` | Implementado |
| **Trouble.nvim** | `consult-lsp-diagnostics` + `flycheck-list-errors` | Implementado (Painel Bottom) |
| **Nvim-tree / Neo-tree** | `treemacs` | Consolidado |
| **Copilot.lua** | `copilot.el` | Implementado |
| **Treesitter** | `:tools tree-sitter` | Implementado |

## 2. Status das Implementações (Checklist)

### 🟢 Alta Prioridade (Bugs & Core)
- [x] **Declarar `consult-lsp` em `packages.el`**: Garante que `SPC x` funcione em instalações limpas.
- [x] **Substituir `counsel-fzf` por `consult-fd`**: Remove dependência quebrada do Ivy/Counsel e usa o stack Vertico correto.
- [x] **Corrigir dependência do `grease`**: Agora aponta corretamente para `:local-repo "lisp/grease"`.

### 🟡 Média Prioridade (Limpeza & Consistência)
- [x] **Remover redundância `gcmh`**: Removido de `packages.el` (Doom já possui), mantendo apenas tuning no `config.el`.
- [x] **Desativar `neotree`**: Removido do `init.el` para evitar conflitos com Treemacs e Grease.
- [x] **Limpeza de Keybindings**: Removidos atalhos do Neotree e referências ao Counsel.

### 🔵 Baixa Prioridade (UX & Paridade)
- [x] **Toggle de Terminal**: Adicionado `SPC t v` para `+vterm/toggle` (Toggleterm vibe).
- [x] **Documentação de Requisitos**: Adicionado comentário no início do `config.el` com comandos `npm` necessários.

## 3. Próximos Passos Sugeridos
- [x] **Remover `simpleclip.el`** (código morto — ver seção 4).
- [x] **Investigar workaround do `transient`**: Código comentado em `config.el` para testar se o problema persiste.
- [ ] Validar performance do `emacs-lsp-booster` em diferentes linguagens.
- [x] **Adicionar painel persistente de diagnósticos**: Regra `set-popup-rule!` adicionada para `*Flycheck errors*` (bottom, 25%, persistente).
- [x] **Kotlin Syntax**: Grammar source explicitamente adicionada ao `config.el`.

## 4. Sugestões da Análise de Código

Achados da revisão estática dos arquivos `.el`:

### 🟢 Alta Prioridade
- [x] **Remover `simpleclip.el`**: Arquivo removido (código morto).

### 🟡 Média Prioridade
- [x] **Revisar bloco `js2-mode`**: Bloco comentado em `config.el` (redundante com `tree-sitter` habilitado).
- [x] **Investigar workaround do `transient`**: Bloco comentado em `config.el` para validação.

### 🔵 Baixa Prioridade
- [x] **Padronizar prefixo de funções customizadas**: Funções `leo/` renomeadas para `+leo/` para seguir convenção do Doom.

## 5. Kotlin: LSP e Syntax Highlighting

### Problema Reportado
- Arquivos `.kt` abrem sem syntax highlighting/cores
- Buffer do kotlin-ls mostra erro SLF4J

### Diagnóstico

**Erro SLF4J — Benigno (não causa perda de highlights)**
```
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
```
O `kotlin-language-server` foi compilado sem implementação de logger concreta.
O LSP funciona normalmente — apenas sem arquivo de log. Pode ser ignorado.

**Causa real: grammar tree-sitter de Kotlin não instalada**
- `init.el` habilita `(kotlin +lsp +tree-sitter)` corretamente
- O módulo Doom registra a grammar via `set-tree-sitter!` mas **não a instala automaticamente**
- Sem a grammar compilada, Emacs usa `kotlin-mode` (highlighting mínimo)
- Com a grammar: modo remapeado para `kotlin-ts-mode` (highlighting completo)

### Correção Aplicada (config.el)

- Adicionada fonte explícita da grammar em `config.el`:
  ```elisp
  (after! treesit
    (add-to-list 'treesit-language-source-alist
                 '(kotlin "https://github.com/fwcd/tree-sitter-kotlin")))
  ```
- **Ação necessária do usuário:**
  - Execute `M-x treesit-install-language-grammar RET kotlin RET` para baixar/compilar.
  - Reinicie o Emacs.

### Verificação
- `M-x describe-mode` em um `.kt` → deve mostrar `kotlin-ts-mode`
- `M-x +tree-sitter/doctor` → verifica status da grammar
- Highlights completos de tipos, funções, strings devem aparecer

## 6. Doom Doctor

Resultado de `doom doctor` — 3 warnings encontrados.

### Warning: Shell não-POSIX (/bin/fish)
**Status: Já corrigido** — `config.el` linhas 4-6:
```elisp
(setq shell-file-name (executable-find "bash"))     ; Doom usa bash internamente
(setq-default vterm-shell "/bin/fish")              ; vterm continua com fish
(setq-default explicit-shell-file-name "/bin/fish")
```

### Warnings: Go — Ferramentas não instaladas
**Status: Ação necessária do usuário**

`:lang go` habilitado em `init.el` (linha 140) mas faltam:

| Ferramenta | Propósito | Instalar |
| :--- | :--- | :--- |
| `gopls` | Language server (LSP) | `go install golang.org/x/tools/gopls@latest` |
| `gomodifytags` | Manipulação de struct tags | `go install github.com/fatih/gomodifytags@latest` |
| `gore` | REPL | `go install github.com/x-motemen/gore/cmd/gore@latest` |

Após instalar, garantir que `$(go env GOPATH)/bin` está no `$PATH`.

---

## 7. Instalação no Windows (Alternativas)

### Métodos de Instalação Windows

| Método | Comando |
|--------|--------|
| **Wget** | `winget install --id Pacote` |
| **Scoop** | `scoop install <pacote>` |
| **Chocolatey** | `choco install <pacote>` |

### Tabela de Equivalências (Arch → Windows)

| Pacote Arch (pacman) | Scoop | Chocolatey | Winget | Observação |
|---------------------|-------|------------|--------|------------|
| **Go** | `go` | `golang` | `GoLang.Go` | |
| **gopls** | `gopls` (via go install) | (via go install) | - | `go install golang.org/x/tools/gopls@latest` |
| **gomodifytags** | (via go install) | (via go install) | - | `go install github.com/fatih/gomodifytags@latest` |
| **gore** | (via go install) | (via go install) | - | `go install github.com/x-motemen/gore/cmd/gore@latest` |
| **gotests** | (via go install) | (via go install) | - | `go install github.com/cweill/gotests@latest` |
| **ghc** | `ghc` | `ghc` | `Python.GHC` | Haskell compiler |
| **cabal-install** | (manual) | (manual) | - | Haskell package manager |
| **haskell-language-server** | (manual) | (manual) | - | Via cabal/hackage |
| **hoogle** | (manual) | (manual) | - | Via cabal |
| **ktlint** | (manual) | (manual) | - | Via SDKMAN ou download |
| **marked** | (npm) | (npm) | - | `npm i -g marked` |
| **maim** | (WSL) | (WSL) | - | Usa alternativa Windows |
| **scrot** | (WSL) | (WSL) | - | Usa alternativa Windows |
| **graphviz** | `graphviz` | `graphviz` | `Graphviz.Graphviz` | |
| **python-black** | `black` | `python-black` | - | `pip install black` |
| **python-pyflakes** | `pyflakes` | `python-pyflakes` | - | `pip install pyflakes` |
| **python-isort** | `isort` | `python-isort` | - | `pip install isort` |
| **python-pytest** | `pytest` | `python-pytest` | - | `pip install pytest` |
| **python-pipenv** | `pipenv` | `python-pipenv` | - | `pip install pipenv` |
| **python-nose** | `nose` | `python-nose` | - | `pip install nose` |
| **tidy** | `tidy` | `tidy` | `XMLLINT.Tidy` | HTML validator |
| **stylelint** | (npm) | (npm) | - | `npm i -g stylelint` |
| **js-beautify** | (npm) | (npm) | - | `npm i -g js-beautify` |
| **ttf-symbola** | (manual) | (manual) | - | Download manual |
| **shellcheck** | `shellcheck` | `shellcheck` | `koalaman.shellcheck` | |
| **shfmt** | (go install) | (go install) | - | `go install mvdan.cc/sh/v3/cmd/shfmt@latest` |
| **ripgrep** | `ripgrep` | `ripgrep` | `BurntSushi.ripgrep` | |
| **fd** | `fd` | (go install) | - | `cargo install fd-find` |

### Install Script (PowerShell)

```powershell
# Install via Scoop (recomendado)
scoop install go ghc cabal graphviz fd ripgrep shellcheck

# Install via Chocolatey
choco install golang ghc graphviz ripgrep shellcheck tidy

# NPM globals
npm i -g typescript typescript-language-server vscode-langservers-extracted
npm i -g pyright bash-language-server dockerfile-language-server-nodejs
npm i -g yaml-language-server prettier eslint stylelint js-beautify marked

# Go tools
go install golang.org/x/tools/gopls@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/x-motemen/gore/cmd/gore@latest
go install github.com/cweill/gotests@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Python tools (via pip)
pip install black pyflakes isort pytest pipenv nose ruff
```

---
*Última atualização: 08 de Março de 2026*
