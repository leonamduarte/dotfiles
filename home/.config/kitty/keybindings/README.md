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

### Prefix Style (similar ao TMUX Ctrl+b)

Use **Ctrl+Alt** como tecla modificadora principal:

| Atalho | Ação | Equivalente TMUX |
|--------|------|------------------|
| `Ctrl+Alt+Enter` | Nova janela | `prefix + c` |
| `Ctrl+Alt+5` | Split vertical | `prefix + %` |
| `Ctrl+Alt+-` | Split horizontal | `prefix + "` |
| `Ctrl+Alt+←/→/↑/↓` | Navegar entre panes | `prefix + setas` |
| `Ctrl+Alt+h/j/k/l` | Navegar (vim-style) | - |
| `Ctrl+Alt+w` | Fechar janela | `prefix + x` |
| `Ctrl+Alt+Space` | Ciclar layout | `prefix + Space` |
| `Ctrl+Alt+z` | Maximizar/zoom | `prefix + z` |

### Navegação de Tabs

| Atalho | Ação |
|--------|------|
| `Ctrl+Shift+←/→` | Tab anterior/próxima |
| `Ctrl+Shift+h/l` | Tab anterior/próxima (vim-style) |
| `Ctrl+Shift+1-9` | Ir para tab 1-9 |
| `Ctrl+Shift+p` | Alternar última tab |
| `Ctrl+Shift+t` | Renomear tab |

### Scrollback e Seleção

| Atalho | Ação |
|--------|------|
| `Ctrl+Shift+s` | Iniciar seleção |
| `Ctrl+Shift+c` | Copiar seleção |
| `Ctrl+Shift+v` | Colar |
| `Ctrl+Shift+l` | Selecionar linha |
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
