#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLE_ROOT="$(cd "$ROOT/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.vps-config-backups/$STAMP"

backup_file() {
  local src="$1"
  [ -e "$src" ] || return 0
  mkdir -p "$BACKUP_DIR$(dirname "$src")"
  cp -a "$src" "$BACKUP_DIR$src"
}

install_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
  echo "Installed: $dst"
}

echo "==> Backing up existing shell config to $BACKUP_DIR"
backup_file "$HOME/.bashrc"
backup_file "$HOME/.config/starship.toml"
if [ -d "$HOME/.bashrc.d" ]; then
  mkdir -p "$BACKUP_DIR$HOME"
  cp -a "$HOME/.bashrc.d" "$BACKUP_DIR$HOME/"
fi

echo "==> Installing VPS config bundle"
install_file "$BUNDLE_ROOT/shell/.bashrc" "$HOME/.bashrc"
mkdir -p "$HOME/.bashrc.d"
while IFS= read -r -d '' managed_file; do
  managed_base="$(basename "$managed_file")"
  [ "$managed_base" = 'local.sh' ] && continue
  rm -f "$HOME/.bashrc.d/$managed_base"
done < <(find "$BUNDLE_ROOT/shell/.bashrc.d" -maxdepth 1 -type f -print0)
cp -a "$BUNDLE_ROOT/shell/.bashrc.d/." "$HOME/.bashrc.d/"
echo "Installed: $HOME/.bashrc.d/*"
if [ ! -f "$HOME/.bashrc.d/local.sh" ] && [ -f "$BUNDLE_ROOT/shell/.bashrc.d/local.sh.example" ]; then
  cp -a "$BUNDLE_ROOT/shell/.bashrc.d/local.sh.example" "$HOME/.bashrc.d/local.sh"
  echo "Installed: $HOME/.bashrc.d/local.sh (from example)"
fi
install_file "$BUNDLE_ROOT/shell/.config/starship.toml" "$HOME/.config/starship.toml"

echo
echo "Done."
echo "Open a new shell or run: source ~/.bashrc"
echo "Then verify with: $ROOT/verify.sh"
