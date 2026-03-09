#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${1:-all}"

log() { printf '==> %s\n' "$1"; }

cd "$ROOT"

log "Bootstrapping packages (profile: $PROFILE)"
./bootstrap-apt.sh "$PROFILE"

log "Installing shell + prompt bundle"
./install.sh

log "Verifying bundle"
./verify.sh

log "Running doctor"
./vps-doctor

cat <<'EOF'

Done.

Recommended next steps:
  1. Open a new shell (or run: source ~/.bashrc)
  2. If Docker was installed, re-login or run: newgrp docker
  3. Edit ~/.bashrc.d/local.sh for machine-specific overrides

EOF
