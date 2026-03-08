# Relatório de Alterações: Doom Emacs vs Neovim

Este relatório descreve o estado real da configuração atual do Doom Emacs, mapeando equivalentes do ecossistema Neovim e apontando o que já está implementado, o que é apenas paridade parcial e o que ainda falta para uma reprodução mais fiel da experiência.

## 1. Tabela De/Para (Neovim -> Doom)

| Plugin / Conceito Neovim | Equivalente no Doom Emacs | Estado atual |
| :--- | :--- | :--- |
| **LSPConfig / Mason** | `:tools (lsp +peek)` + `:lang <lang> +lsp` | Implementado em `init.el` |
| **nvim-cmp / blink.cmp** | `:completion (corfu +icons +terminal +orderless)` | Implementado em `init.el` + `config.el` |
| **Telescope / fzf-lua** | `vertico` + `consult` | Parcial — `SPC s z` usa `counsel-fzf` (stack errada, quebra em install limpa) |
| **Oil.nvim** | `grease` (local em `lisp/grease/`) | Implementado — mas `packages.el` aponta pro GitHub em vez do local |
| **Harpoon.nvim** | `harpoon` | Implementado em `packages.el` + `config.el` |
| **Conform.nvim / null-ls** | `:editor (format +onsave)` + hooks de save | Implementado em `init.el` + `config.el` |
| **Toggleterm.nvim** | `vterm` | Parcial — sem binding de toggle rápido |
| **Gitsigns / mini.diff** | `:ui (vc-gutter +pretty)` | Implementado em `init.el` |
| **Trouble.nvim** | `consult-lsp-diagnostics` + `flycheck-list-errors` | Parcial — `consult-lsp` não está declarado em `packages.el` |
| **Nvim-tree / Neo-tree** | `neotree` + `treemacs` | Redundância — ambos ativos ao mesmo tempo no `init.el` |
| **Copilot.lua** | `copilot.el` | Implementado em `packages.el` + `config.el` |
| **Treesitter** | `:tools tree-sitter` + `treesit-auto` | Implementado em `init.el` + `packages.el` + `config.el` |
| **vim-surround** | `evil-surround` (via módulo `:editor evil`) | Já coberto pelo Doom — não precisa de pacote extra |
| **Comment.nvim** | `evil-nerd-commenter` (via módulo `:editor evil`) | Já coberto pelo Doom — gc/gcc funcionam |
| **which-key.nvim** | `which-key` (incluído no Doom) | Já coberto pelo Doom |
| **Auto-pairs** | `smartparens` (via `:config default +smartparens`) | Já coberto pelo Doom |
| **Session management** | `persp-mode` (via `:ui workspaces`) | Já coberto pelo Doom |

## 2. O que está realmente implementado hoje

### Módulos ativos em `init.el`
- **Completion**: `corfu +icons +terminal +orderless` e `vertico +icons`.
- **UI**: `vc-gutter +pretty`, `neotree`, `treemacs`, `workspaces`, `popup +defaults`, `modeline`, `hl-todo`, `indent-guides`, `ophints`.
- **Editor**: `evil +everywhere`, `fold`, `format +onsave`, `snippets`, `file-templates`.
- **Emacs**: `dired +icons`, `electric`, `undo`, `vc`.
- **Term**: `eshell` e `vterm`.
- **Checkers**: `syntax +flycheck` e `spell +flyspell`.
- **Tools**: `lsp +peek`, `magit`, `tree-sitter`, `lookup +dictionary +offline +docsets`, `eval +overlay`, `debugger`.
- **Lang**: C/C++, CSS, Elm, Emacs Lisp, Go, GraphQL, Haskell, JSON, Java, JavaScript, Kotlin, Lua, Markdown, Org, Python, SQL, Shell, TypeScript, Web, YAML.

### Pacotes extras declarados em `packages.el`
- `copilot`
- `harpoon`
- `grease` (apontando para GitHub — deveria usar `:local-repo "lisp/grease"`)
- `treesit-auto`
- `gcmh` (**redundante** — Doom já inclui gcmh internamente)
- `kdl-mode`
- `org-auto-tangle`
- `org-modern`
- `org-super-agenda`

### Comportamentos e atalhos configurados em `config.el`
- `SPC -` abre `grease-toggle`, equivalente ao Oil.nvim.
- `SPC j` concentra o fluxo do harpoon (`t`, `l`, `1-4`).
- `SPC x` concentra diagnostics com `consult-lsp-diagnostics` (pacote não declarado) e `flycheck-list-errors`.
- `M-j` e `M-k` movem linha ou região.
- `evil-kill-on-visual-paste nil` preserva o registro principal ao colar sobre seleção visual.
- `x` em modo normal deleta para o black hole register.
- `<` e `>` em visual mode reindentam e re-selecionam a região.
- `copilot-mode` está ligado em `prog-mode`, com `<backtab>` para aceitar (sem conflito com corfu).
- LSP tuning com `emacs-lsp-booster`, `read-process-output-max` e completion delegada ao corfu.
- `SPC o n` abre Neotree (redundante com Treemacs).

## 3. Lacunas e bugs confirmados (análise dos arquivos reais)

### BUG — Quebra em instalação limpa

**1. `SPC s z` usa `counsel-fzf` sem ivy/counsel no stack**
- `config.el` (linhas 238–243) usa `counsel-fzf` e configura `after! counsel`
- O stack ativo é `vertico + consult` — `counsel`/`ivy` não estão declarados em nenhum lugar
- Em install limpa esse binding falha silenciosamente ou lança erro
- **Fix:** Substituir por `consult-fd` (já disponível via módulo vertico), remover `after! counsel`

**2. `SPC x x/X` chama `consult-lsp-diagnostics` sem pacote declarado**
- `config.el` (linhas 343–344) usa `consult-lsp-diagnostics`
- `consult-lsp` não está em `packages.el`
- Em install limpa o símbolo não existe
- **Fix:** Adicionar `(package! consult-lsp)` em `packages.el`

### AMBIGUIDADE

**3. `grease` aponta para GitHub, mas versão local existe em `lisp/grease/`**
- `packages.el` (linhas 22–24): a linha `:recipe (:local-repo "lisp/grease")` está comentada
- O arquivo `lisp/grease/grease.el` (2034 linhas) é a versão local customizada
- Usar o GitHub carrega uma versão diferente e possivelmente incompatível
- **Fix:** Descomentar `:local-repo "lisp/grease"`, comentar a recipe do GitHub

### REDUNDÂNCIAS

**4. `gcmh` declarado em `packages.el` quando Doom já o inclui**
- O Doom framework usa gcmh internamente para GC tuning
- Declarar `(package! gcmh)` pode conflitar com a versão interna
- **Fix:** Remover `(package! gcmh)` de `packages.el` — manter o bloco `use-package! gcmh` em `config.el` para sobrescrever apenas os valores (isso funciona com o gcmh do Doom)

**5. `neotree` E `treemacs` ambos ativos em `init.el`**
- Dois file-tree explorers carregados ao mesmo tempo
- Consomem hooks, memória e podem competir por `SPC o p`
- `grease` já cobre navegação Oil.nvim-style
- **Fix:** Remover `:ui neotree` do `init.el` + remover os bindings `SPC o n / o N` do `config.el` — Treemacs já tem `SPC o p` pelo Doom

### LACUNA

**6. Sem toggle rápido de terminal (Toggleterm equiv.)**
- `vterm` existe mas não há binding de toggle rápido
- Doom fornece `+vterm/toggle`
- **Fix:** Adicionar `(map! :leader :desc "Toggle vterm" "t v" #'+vterm/toggle)`

## 4. O que NÃO precisa ser adicionado (já coberto pelo Doom)

Estes itens do ecossistema Neovim já estão cobertos por módulos do Doom e **não devem ser duplicados**:

| Feature | Coberto por |
| :--- | :--- |
| vim-surround | `evil-surround` via módulo `:editor evil` |
| Comment.nvim (gc/gcc) | `evil-nerd-commenter` via `:editor evil` |
| which-key.nvim | Incluído no Doom por padrão |
| Auto-pairs | `smartparens` via `:config default +smartparens` |
| Session/Workspace | `persp-mode` via `:ui workspaces` |
| Git blame | `magit-blame` via `:tools magit` |
| Fold | Módulo `:editor fold` |
| Marks | Marks do Evil (vim nativo) |
| Undo history | Módulo `:emacs undo` |

## 5. Prioridade de implementação

### Alta (bugs que quebram)
1. Declarar `consult-lsp` em `packages.el`
2. Substituir `counsel-fzf` por `consult-fd` em `config.el`

### Média (consistência e limpeza)
3. Corrigir `grease` para usar `:local-repo` em `packages.el`
4. Remover `(package! gcmh)` de `packages.el` (redundância com Doom)
5. Remover `:ui neotree` do `init.el` + bindings associados em `config.el`

### Baixa (paridade de UX)
6. Adicionar toggle rápido para vterm (`SPC t v`)

## 6. Conclusão

A base para uma experiência "Neovim-like" no Doom Emacs está sólida: Evil, LSP, Corfu, Vertico, Harpoon, Grease, Vterm, diagnostics e vários ajustes comportamentais já estão no lugar.

Os dois itens críticos que **quebram em instalação limpa** são o binding `SPC s z` (dependência de `counsel` ausente) e os bindings `SPC x x/X` (dependência de `consult-lsp` não declarada). Os demais problemas são de limpeza e consistência.

O risco de adicionar mais pacotes para cobrir features que o Doom já fornece (surround, comments, which-key, etc.) é maior que o benefício — duplicidade causa conflitos e degrada a performance.
