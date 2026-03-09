#!/usr/bin/env bash
set -euo pipefail

ok() { printf '✅ %s\n' "$1"; }
warn() { printf '⚠️  %s\n' "$1"; }
fail() { printf '❌ %s\n' "$1"; }

required_failures=0

check_cmd() {
  local name="$1"
  local level="${2:-required}"
  if command -v "$name" >/dev/null 2>&1; then
    ok "$name"
  else
    case "$level" in
      optional)
        warn "$name missing"
        ;;
      *)
        fail "$name missing"
        required_failures=$((required_failures + 1))
        ;;
    esac
  fi
}

echo '==> Command availability'
for cmd in bash git tmux curl jq rg fd fzf zoxide; do
  check_cmd "$cmd" required
done

for cmd in bat batcat eza node npm pm2 openclaw starship gh tailscale docker flutter sensors trash-put multitail clang-format cmake ctest; do
  check_cmd "$cmd" optional
done

echo
echo '==> Shell startup check'
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT
if bash -ic 'source ~/.bashrc >/dev/null 2>"$1" && type zi >/dev/null && type lt >/dev/null && type plog >/dev/null && type ltree >/dev/null && type glog >/dev/null && type mem >/dev/null && type mem-usage >/dev/null' _ "$tmpfile"; then
  ok '$HOME/.bashrc loads and key aliases/functions resolve'
else
  fail '$HOME/.bashrc did not load cleanly'
  required_failures=$((required_failures + 1))
  cat "$tmpfile" || true
fi

echo
echo '==> Summary'
echo 'Required failures should be fixed before calling this a baseline.'
echo 'Optional warnings are okay if that feature is intentionally absent.'

if [ "$required_failures" -gt 0 ]; then
  exit 1
fi
