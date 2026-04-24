# Ensure ~/bin is in PATH for interactive shells
if [ -n "\$PS1" ] || [ -n "\$BASH_VERSION" ]; then
  case ":$PATH:" in
    *":$HOME/bin:"*) ;;
    *) export PATH="$HOME/bin:$PATH" ;;
  esac
fi
. "$HOME/.cargo/env"
