#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-all}"

need_sudo() {
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    sudo "$@"
  else
    "$@"
  fi
}

have() { command -v "$1" >/dev/null 2>&1; }
log() { printf '==> %s\n' "$1"; }
warn() { printf '⚠️  %s\n' "$1"; }

BASE_PKGS=(
  bash-completion curl git jq ripgrep fd-find fzf tmux htop zoxide bat
  unzip zip p7zip-full build-essential ca-certificates gnupg lsb-release
)

INFRA_PKGS=(
  docker.io trash-cli lm-sensors multitail
)

CPP_AUDIO_PKGS=(
  clang-format cmake pkg-config
)

# Flutter isn't a clean apt package on Ubuntu 22.04; snap is the sane path.
install_flutter() {
  if have flutter; then
    log 'Flutter already installed'
    return 0
  fi
  if ! have snap; then
    warn 'snap not available; skipping Flutter install'
    return 0
  fi
  log 'Installing Flutter via snap --classic'
  need_sudo snap install flutter --classic
}

apt_install() {
  local pkgs=("$@")
  [ ${#pkgs[@]} -gt 0 ] || return 0
  log "Installing apt packages: ${pkgs[*]}"
  need_sudo apt-get install -y "${pkgs[@]}"
}

ensure_fd_bat_symlinks() {
  mkdir -p "$HOME/.local/bin"
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log 'Linked fdfind -> ~/.local/bin/fd'
  fi
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
    log 'Linked batcat -> ~/.local/bin/bat'
  fi
}

apt_updated=0
ensure_apt_updated() {
  if [ "$apt_updated" -eq 0 ]; then
    log 'Updating apt package lists'
    need_sudo apt-get update
    apt_updated=1
  fi
}

case "$PROFILE" in
  base)
    ensure_apt_updated
    apt_install "${BASE_PKGS[@]}"
    ;;
  infra)
    ensure_apt_updated
    apt_install "${INFRA_PKGS[@]}"
    ;;
  flutter)
    install_flutter
    ;;
  cpp-audio)
    ensure_apt_updated
    apt_install "${CPP_AUDIO_PKGS[@]}"
    ;;
  all)
    ensure_apt_updated
    apt_install "${BASE_PKGS[@]}"
    apt_install "${INFRA_PKGS[@]}"
    apt_install "${CPP_AUDIO_PKGS[@]}"
    install_flutter
    ;;
  *)
    echo "Usage: $0 [base|infra|flutter|cpp-audio|all]"
    exit 1
    ;;
esac

ensure_fd_bat_symlinks

log 'Done'
echo 'Suggested next step: ./verify.sh && ./vps-doctor'
