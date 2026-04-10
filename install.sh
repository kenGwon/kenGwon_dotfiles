#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    echo "[skip]   $dst (already a symlink)"
    return
  fi

  if [ -e "$dst" ]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    echo "[backup] $dst → $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "[link]   $dst → $src"
}

link "$DOTFILES_DIR/bash/.bash_profile"   "$HOME/.bash_profile"
link "$DOTFILES_DIR/bash/.bashrc"         "$HOME/.bashrc"
link "$DOTFILES_DIR/bash/.bashrc.d"       "$HOME/.bashrc.d"
link "$DOTFILES_DIR/tmux/.tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES_DIR/nvim/.config/nvim"    "$HOME/.config/nvim"

echo ""
echo "Done. Re-login or run: source ~/.bashrc"
