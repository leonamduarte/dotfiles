# Kitty TMUX-Style Keybindings

Este diretório contém configurações para usar o Kitty como substituto do TMUX.

## 📋 Estrutura de Arquivos

```
keybindings/
├── tmux-prefix.conf    # Keybindings estilo TMUX (prefix-based)
├── navigation.conf     # Navegação entre janelas e tabs
└── scrollback.conf     # Scrollback e seleção de texto
```

## ⌨️ Keybindings Principais

Use **Ctrl+Alt** para ações de panes/janelas Kitty e **Ctrl+Shift** para ações de tabs.
Em Kitty, cada split/pane é uma `window` dentro da tab atual.

### Panes / Janelas Kitty

| Atalho | Ação | Equivalente TMUX |
|--------|------|------------------|
| `Ctrl+Shift+Enter` | Nova pane/janela no diretório atual | `prefix + c` |
| `Ctrl+Alt+5` | Criar split horizontal (`hsplit`) | `prefix + %` |
| `Ctrl+Alt+-` | Criar split vertical (`vsplit`) | `prefix + "` |
| `Ctrl+Alt+←/→/↑/↓` | Focar pane à esquerda/direita/acima/abaixo | `prefix + setas` |
| `Ctrl+Alt+h/j/k/l` | Focar pane usando navegação Vim | `prefix + h/j/k/l` |
| `Ctrl+Alt+.` | Próxima pane na tab atual | `prefix + o` |
| `Ctrl+Alt+,` | Pane anterior na tab atual | `prefix + ;` |
| `Ctrl+Alt+1..9` | Selecionar pane por índice | `prefix + q`, depois índice |
| `Ctrl+Alt+p` | Alternar para a última pane ativa | `prefix + ;` |
| `Ctrl+Alt+w` / `Ctrl+Alt+q` | Fechar pane atual | `prefix + x` |
| `Ctrl+Alt+Space` | Ciclar layout | `prefix + Space` |
| `Ctrl+Alt+z` | Maximizar/restaurar pane | `prefix + z` |
| `Ctrl+Alt+o` | Mover pane para a próxima tab | `prefix + !` |

### Tabs

| Atalho | Ação | Equivalente TMUX |
|--------|------|------------------|
| `Ctrl+Alt+Enter` | Nova tab no diretório atual | `prefix + c` em nova janela/sessão |
| `Ctrl+Shift+←` / `Ctrl+Shift+→` | Tab anterior/próxima | `prefix + p` / `prefix + n` |
| `Ctrl+Shift+h` / `Ctrl+Shift+l` | Tab anterior/próxima usando navegação Vim | `prefix + p` / `prefix + n` |
| `Ctrl+Shift+1..9` | Ir para tab 1-9 | `prefix + 1..9` |
| `Ctrl+Shift+p` | Alternar entre a tab atual e a última ativa | `prefix + l` |
| `Ctrl+Shift+t` | Renomear tab atual | `prefix + ,` |
| `Ctrl+Shift+w` | Fechar tab atual | `prefix + &` |

### Exemplos de Uso

```text
# Criar um layout com editor e servidor lado a lado
Ctrl+Shift+Enter        # abre uma nova pane no diretório atual
Ctrl+Alt+5              # cria um split horizontal
Ctrl+Alt+h/l            # alterna o foco entre as panes

# Trabalhar com múltiplas tabs de projeto
Ctrl+Alt+Enter          # abre uma nova tab
Ctrl+Shift+t            # renomeia a tab, por exemplo: api
Ctrl+Shift+1..9         # pula diretamente para uma tab numerada
Ctrl+Shift+p            # volta rapidamente para a última tab ativa

# Navegar panes sem lembrar a posição exata
Ctrl+Alt+.              # próxima pane
Ctrl+Alt+,              # pane anterior
Ctrl+Alt+p              # última pane ativa
```

### Scrollback e Seleção

| Atalho | Ação |
|--------|------|
| `Ctrl+Shift+s` | Iniciar seleção |
| `Ctrl+Shift+c` | Copiar seleção |
| `Ctrl+Shift+v` | Colar |
| `Ctrl+Alt+Shift+l` | Selecionar linha |
| `Ctrl+Shift+w` | Selecionar palavra |
| `Ctrl+Shift+o` | Abrir URL (hints) |
| `Ctrl+Shift+f` | Abrir path (hints) |

### Redimensionar Panes

| Atalho | Ação |
|--------|------|
| `Ctrl+Alt+=` | Aumentar largura |
| `Ctrl+Alt+-` | Diminuir largura |
| `Ctrl+Alt+Shift+=` | Aumentar altura |
| `Ctrl+Alt+Shift+-` | Diminuir altura |
| `Ctrl+Alt+0` | Resetar tamanhos |

### Font Size

| Atalho | Ação |
|--------|------|
| `Ctrl+Shift+=` | Aumentar fonte |
| `Ctrl+Shift+-` | Diminuir fonte |
| `Ctrl+Shift+0` | Resetar fonte |

## 🎯 Layouts Disponíveis

1. **splits** (default) - Splits livres como TMUX
2. **tall** - Janela principal à esquerda
3. **fat** - Janela principal no topo
4. **grid** - Janelas em grade
5. **vertical** - Empilhamento vertical
6. **horizontal** - Empilhamento horizontal
7. **stack** - Todas sobrepostas

## 📝 Scripts

### session-manager.sh

Gerenciador de sessions do Kitty.

```bash
# Criar nova session
kitty-session new dev

# Salvar session atual
kitty-session save dev

# Carregar session
kitty-session load dev

# Listar sessions
kitty-session list

# Deletar session
kitty-session delete dev
```

### broadcast.sh

Envia comando para todas as janelas.

```bash
kitty-broadcast "echo hello"
kitty-broadcast "ls -la"
```

## 🔧 Configuração

Para usar estas keybindings, inclua no seu `kitty.conf`:

```conf
include keybindings/tmux-prefix.conf
include keybindings/navigation.conf
include keybindings/scrollback.conf
```

## 📚 Links Úteis

- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Remote Control](https://sw.kovidgoyal.net/kitty/remote-control/)
- [Kitty Sessions](https://sw.kovidgoyal.net/kitty/sessions/)
- [TMUX Cheat Sheet](https://tmuxcheatsheet.com/)
