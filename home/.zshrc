# Ensure ~/bin is in PATH early
if [[ -o interactive ]]; then
  case ":$PATH:" in
    *":$HOME/bin:"*) ;;
    *) export PATH="$HOME/bin:$PATH" ;;
  esac
fi
