# Issue #3: Sistema de Navegação TMUX-Style para Kitty

## Visão Geral

Implementar navegação fluida entre panes e tabs do kitty, substituindo a experiência de navegação do TMUX.

**Issue GitLab:** https://gitlab.com/leonamduarte/dotfiles/-/work_items/3  
**Épico Anterior:** #2 - Configuração Base (✅ Concluída)  
**Próxima Issue:** #6 - Sessions

---

## User Stories

### US-001: Navegação Direcional com Setas

**Como** usuário do kitty  
**Quero** navegar entre panes usando Ctrl+Alt+setas  
**Para** alternar rapidamente o foco entre janelas divididas

#### Critérios de Aceite

- [ ] `Ctrl+Alt+Seta_Direita` → focus_right
- [ ] `Ctrl+Alt+Seta_Esquerda` → focus_left
- [ ] `Ctrl+Alt+Seta_Cima` → focus_up
- [ ] `Ctrl+Alt+Seta_Baixo` → focus_down
- [ ] Funciona em todos os layouts

#### Equivalente TMUX

`prefix + setas`

---

### US-002: Navegação Estilo Vim (h j k l)

**Como** usuário avançado  
**Quero** navegar com Ctrl+Alt+h/j/k/l  
**Para** manter mãos na home row

#### Critérios de Aceite

- [ ] `Ctrl+Alt+h` → focus_left
- [ ] `Ctrl+Alt+j` → focus_down
- [ ] `Ctrl+Alt+k` → focus_up
- [ ] `Ctrl+Alt+l` → focus_right

#### Equivalente TMUX

`prefix + h/j/k/l` (configuração customizada)

---

### US-003: Toggle Última Janela Ativa

**Como** usuário  
**Quero** alternar entre janela atual e anterior  
**Para** trocar contexto rapidamente

#### Critérios de Aceite

- [ ] `Ctrl+Alt+p` → focus_visible_window
- [ ] Mantém histórico de últimas 2 janelas
- [ ] Feedback visual claro

#### Equivalente TMUX

`prefix + l` (last window)

---

### US-004: Seleção de Janelas por Índice (1-9)

**Como** usuário  
**Quero** selecionar janelas por índice numérico  
**Para** pular para janela específica

#### Critérios de Aceite

- [ ] `Ctrl+Alt+1-9` → select_window 1-9
- [ ] Funciona apenas com janelas existentes

#### Equivalente TMUX

`prefix + 0-9`

---

### US-005: Navegação entre Tabs

**Como** usuário  
**Quero** navegar entre tabs com atalhos  
**Para** alternar contextos de trabalho

#### Critérios de Aceite

- [ ] `Ctrl+Shift+Seta_Direita` → next_tab
- [ ] `Ctrl+Shift+Seta_Esquerda` → previous_tab
- [ ] `Ctrl+Shift+l` → next_tab
- [ ] `Ctrl+Shift+h` → previous_tab
- [ ] Navegação cíclica

#### Equivalente TMUX

`prefix + n` (next), `prefix + p` (previous)

---

### US-006: Seleção de Tabs por Índice (1-9)

**Como** usuário  
**Quero** ir para tab pelo índice  
**Para** acessar contexto rapidamente

#### Critérios de Aceite

- [ ] `Ctrl+Shift+1-9` → goto_tab 1-9

#### Equivalente TMUX

`prefix + 1-9`

---

### US-007: Toggle Últimas Duas Tabs

**Como** usuário  
**Quero** alternar entre últimas duas tabs  
**Para** trocar entre dois ambientes

#### Critérios de Aceite

- [ ] `Ctrl+Shift+p` → toggle_tab

---

### US-008: Navegação Sequencial de Janelas

**Como** usuário  
**Quero** navegar sequencialmente pelas janelas  
**Para** revisar conteúdo

#### Critérios de Aceite

- [ ] `Ctrl+Alt+.` → next_window
- [ ] `Ctrl+Alt+,` → previous_window
- [ ] Navegação cíclica

---

### US-009: Renomear Tab

**Como** usuário  
**Quero** renomear tab atual  
**Para** manter contexto claro

#### Critérios de Aceite

- [ ] `Ctrl+Shift+t` → set_tab_title
- [ ] Enter confirma, Esc cancela

#### Equivalente TMUX

`prefix + ,`

---

### US-010: Documentar Atalhos no README

**Como** usuário  
**Quero** documentação completa dos atalhos  
**Para** consultar durante uso

#### Critérios de Aceite

- [ ] Tabela com todos os atalhos
- [ ] Organizado por categoria
- [ ] Equivalentes TMUX incluídos

#### Dependências

US-001 a US-009

---

### US-011: Testar em Todos os Layouts

**Como** QA  
**Quero** testar em todos os layouts  
**Para** garantir consistência

#### Critérios de Aceite

- [ ] splits ✅
- [ ] tall ✅
- [ ] fat ✅
- [ ] grid ✅
- [ ] vertical ✅
- [ ] horizontal ✅
- [ ] stack ✅

---

### US-012: Validar Ausência de Conflitos

**Como** QA  
**Quero** garantir zero conflitos  
**Para** evitar comportamento inesperado

#### Critérios de Aceite

- [ ] Sem conflito com SO (WSLg)
- [ ] Sem conflito com shell (bash/zsh)
- [ ] Sem conflito com apps (editor, browser)
- [ ] Lista de conflitos documentada

---

## Ordem de Implementação

```
1. US-001 → Navegação Direcional (base)
2. US-002 → Vim-style (extensão)
3. US-003 → Toggle janela
4. US-004 → Seleção por índice
5. US-005 → Navegação tabs
6. US-006 → Seleção tabs
7. US-007 → Toggle tabs
8. US-008 → Navegação sequencial
9. US-009 → Renomear tab
10. US-010 → Documentação
11. US-011 → Testes layouts
12. US-012 → Validação conflitos
```

---

## Arquivos para Modificar

| Arquivo | Ação |
|---------|------|
| `home/.config/kitty/keybindings/navigation.conf` | Criar/Atualizar |
| `home/.config/kitty/keybindings/README.md` | Atualizar |
| `home/.config/kitty/kitty.conf` | Atualizar (se necessário) |

---

## Quality Gates

```bash
# Verificar sintaxe
kitty @ list-fonts --psnames

# Verificar keybindings
cat home/.config/kitty/kitty.conf | grep -E '^map'

# Verificar conflitos git
git diff --check
```

---

## Como Implementar

### Opção 1: Manualmente

1. Editar `navigation.conf` com os keybindings
2. Testar cada atalho no kitty
3. Atualizar README.md
4. Commit e push

### Opção 2: Com Ralph TUI (não versionado)

```bash
# Criar prd.json temporário (não versionar)
# Executar ralph-tui run --prd prd.json
# Remover arquivos temporários após conclusão
```

---

## Checklist de Conclusão

- [ ] 12 user stories implementadas
- [ ] Quality gates passing
- [ ] Testes manuais completados
- [ ] README atualizado
- [ ] Commit feito
- [ ] Issue #3 fechada no GitLab

---

## Referências

- [Kitty Keybindings Docs](https://sw.kovidgoyal.net/kitty/conf/#keyboard-shortcuts)
- [TMUX Cheat Sheet](https://tmuxcheatsheet.com/)
- [Issue #2](https://gitlab.com/leonamduarte/dotfiles/-/work_items/2) ✅
