#!/usr/bin/env bash
set -euo pipefail

ok() { printf '✅ %s\n' "$1"; }
warn() { printf '⚠️  %s\n' "$1"; }
fail() { printf '❌ %s\n' "$1"; }

check_cmd() {
  local name="$1"
  local level="$2"
  if command -v "$name" >/dev/null 2>&1; then
    ok "$name"
  else
    case "$level" in
      required) fail "$name missing" ;;
      optional) warn "$name missing" ;;
    esac
  fi
}

echo '==> Command availability'
for cmd in bash git tmux curl jq rg fd fzf eza zoxide node npm pm2 openclaw starship; do
  check_cmd "$cmd" required
done

if command -v batcat >/dev/null 2>&1 || command -v bat >/dev/null 2>&1; then
  ok 'bat/batcat'
else
  fail 'bat or batcat missing'
fi

for cmd in gh tailscale docker flutter sensors trash-put multitail clang-format cmake ctest; do
  check_cmd "$cmd" optional
done

echo
echo '==> Shell startup check'
if bash -ic 'source ~/.bashrc >/dev/null 2>/tmp/vps-config-verify.err; type zi >/dev/null; type lt >/dev/null; type plog >/dev/null; type ltree >/dev/null; type glog >/dev/null' ; then
  ok '~/.bashrc loads and key aliases/functions resolve'
else
  fail '~/.bashrc did not load cleanly'
  cat /tmp/vps-config-verify.err || true
fi

echo
echo '==> Summary'
echo 'Required failures should be fixed before calling this a baseline.'
echo 'Optional warnings are okay if that feature is intentionally absent.'
