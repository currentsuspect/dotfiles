# ~/.bashrc.d/aestra-dev.sh
# Aestra DAW development shortcuts

# ============================================================
# AESTRA NAVIGATION
# ============================================================
alias aestra='cd ~/.openclaw/workspace/Aestra'
alias aea='cd ~/.openclaw/workspace/Aestra'
alias ae-core='cd ~/.openclaw/workspace/Aestra/AestraCore'
alias ae-audio='cd ~/.openclaw/workspace/Aestra/AestraAudio'
alias ae-ui='cd ~/.openclaw/workspace/Aestra/AestraUI'
alias ae-tests='cd ~/.openclaw/workspace/Aestra/Tests'

# ============================================================
# BUILD COMMANDS
# ============================================================

# Build presets
alias ae-build='cmake --build build --parallel'
alias ae-build-debug='cmake --build build-debug --parallel'
alias ae-build-release='cmake --build build-release --parallel'

# Configure
alias ae-config='cmake --preset=default'
alias ae-config-debug='cmake --preset=debug'
alias ae-config-release='cmake --preset=release'

# Clean build
ae-clean() {
    echo "🧹 Cleaning Aestra build directories..."
    rm -rf ~/.openclaw/workspace/Aestra/build*
    echo "✅ Clean complete"
}

# Full rebuild
ae-rebuild() {
    echo "🔨 Full Aestra rebuild..."
    (
        cd ~/.openclaw/workspace/Aestra || exit 1
        ae-clean
        ae-config && ae-build
    )
}

# ============================================================
# TEST COMMANDS
# ============================================================

alias ae-test='cd ~/.openclaw/workspace/Aestra && ctest --output-on-failure'
alias ae-test-verbose='cd ~/.openclaw/workspace/Aestra && ctest -V'

# Run specific test
ae-test-run() {
    local test_name="$1"
    [ -z "$test_name" ] && { echo "Usage: ae-test-run <test-name>"; return 1; }
    cd ~/.openclaw/workspace/Aestra && ctest -R "$test_name" -V
}

# ============================================================
# DEVELOPMENT WORKFLOW
# ============================================================

# Aestra-specific dev layout
dev-aestra() {
    local session="aestra"
    local editor_pane right_pane bottom_right_pane

    # Kill existing
    tmux kill-session -t "$session" 2>/dev/null

    # Create session
    tmux new-session -d -s "$session" -c "$HOME/.openclaw/workspace/Aestra" -n editor
    editor_pane=$(tmux display-message -p -t "$session:editor" '#{pane_id}')

    # Layout: main | sidebar
    right_pane=$(tmux split-window -h -P -F '#{pane_id}' -t "$editor_pane" -p 35 -c "$HOME/.openclaw/workspace/Aestra")
    bottom_right_pane=$(tmux split-window -v -P -F '#{pane_id}' -t "$right_pane" -p 50 -c "$HOME/.openclaw/workspace/Aestra")

    # Main pane: ready for vim/editor
    tmux send-keys -t "$editor_pane" 'clear && echo "Aestra Dev — $(git branch --show-current)" && echo "" && ls' C-m

    # Top-right: build log
    tmux send-keys -t "$right_pane" 'watch -n 2 "ls -la build/*.exe build/aestra 2>/dev/null || echo \"Build: No binary yet\""' C-m

    # Bottom-right: git status
    tmux send-keys -t "$bottom_right_pane" 'watch -n 5 "git status -sb && echo \"\" && git log --oneline -3"' C-m

    # Second window: build
    tmux new-window -t "$session" -n build -c "$HOME/.openclaw/workspace/Aestra"
    tmux send-keys -t "$session:build" 'ae-config && ae-build' C-m

    # Third window: tests
    tmux new-window -t "$session" -n tests -c "$HOME/.openclaw/workspace/Aestra"
    tmux send-keys -t "$session:tests" 'echo "Run: ae-test or ae-test-verbose"' C-m

    # Attach to editor
    tmux attach -t "$session:editor"
}

# Quick Aestra status
ae-status() {
    cd ~/.openclaw/workspace/Aestra || return 1
    echo "🎯 AESTRA STATUS"
    echo "================"
    echo ""
    echo "Branch: $(git branch --show-current)"
    echo "Commit: $(git log -1 --format="%h %s")"
    echo ""
    
    # Check for build artifacts
    if [ -d "build" ]; then
        echo "🔨 Build directory:"
        ls -lh build/*.exe build/aestra 2>/dev/null | head -5 | awk '{print "  " $9, $5}'
        echo ""
    fi
    
    # Git status
    local changes=$(git status --short | wc -l)
    if [ "$changes" -gt 0 ]; then
        echo "📁 Uncommitted changes: $changes"
        git status --short | head -5 | sed 's/^/  /'
    else
        echo "✅ Working tree clean"
    fi
    
    # Check CI status (if gh available)
    if command -v gh >/dev/null; then
        echo ""
        echo "🔍 Recent CI:"
        gh run list --limit 3 2>/dev/null | head -4 | sed 's/^/  /'
    fi
}

# ============================================================
# CODE QUALITY
# ============================================================

alias ae-format='cd ~/.openclaw/workspace/Aestra && find . \( -name "*.cpp" -o -name "*.h" \) -print0 | xargs -0 clang-format -i'
alias ae-format-check='cd ~/.openclaw/workspace/Aestra && find . \( -name "*.cpp" -o -name "*.h" \) -print0 | xargs -0 clang-format --dry-run --Werror'

# Check which files need formatting
ae-format-diff() {
    cd ~/.openclaw/workspace/Aestra || return 1
    local files=$(git diff --name-only HEAD | grep -E "\.(cpp|h)$" || git ls-files | grep -E "\.(cpp|h)$")
    for f in $files; do
        if [ -f "$f" ]; then
            clang-format --dry-run "$f" 2>&1 | grep -q "code should be" && echo "Needs format: $f"
        fi
    done
}

# ============================================================
# CI / GITHUB INTEGRATION
# ============================================================

alias ae-ci='cd ~/.openclaw/workspace/Aestra && gh run list --limit 10'
alias ae-ci-watch='cd ~/.openclaw/workspace/Aestra && gh run watch'
alias ae-pr='cd ~/.openclaw/workspace/Aestra && gh pr list'
alias ae-pr-create='cd ~/.openclaw/workspace/Aestra && gh pr create'

# Check CI status of current branch
ae-ci-status() {
    cd ~/.openclaw/workspace/Aestra || return 1
    local branch=$(git branch --show-current)
    echo "🔍 CI status for $branch:"
    gh run list --branch "$branch" --limit 5 2>/dev/null || echo "  (install gh CLI for CI integration)"
}

# ============================================================
# PHASE TRACKING (from MEMORY.md)
# ============================================================

alias ae-phase='cat ~/.openclaw/workspace/Aestra/PHASE.md 2>/dev/null || echo "No PHASE.md found"'

# Show Phase 2 P0 tasks
ae-tasks() {
    echo "🎯 AESTRA PHASE 2 — P0 TASKS"
    echo ""
    echo "E-001: Define canonical command model for undo/redo"
    echo "E-002: Integrate command history across main UX"
    echo "E-003: Transactions/atomic grouping for multi-step edits"
    echo "C-001: Project schema versioning policy"
    echo "D-003: Recovery UX on startup"
    echo ""
    echo "See: https://github.com/currentsuspect/Aestra/issues"
}

# ============================================================
# QUICK COMMANDS
# ============================================================

# Run Aestra (if built)
ae-run() {
    cd ~/.openclaw/workspace/Aestra || return 1
    if [ -x ./build/aestra ]; then
        ./build/aestra 2>/dev/null
    elif [ -x ./build/aestra.exe ]; then
        ./build/aestra.exe 2>/dev/null
    else
        echo "Not built yet — run ae-build"
        return 1
    fi
}

# Open Aestra in file explorer (or list)
alias ae-files='cd ~/.openclaw/workspace/Aestra && ls -la'

# Search in Aestra codebase
ae-search() {
    local pattern="$1"
    [ -z "$pattern" ] && { echo "Usage: ae-search <pattern>"; return 1; }
    cd ~/.openclaw/workspace/Aestra || return 1
    rg "$pattern" --type cpp --type h 2>/dev/null || grep -r "$pattern" --include="*.cpp" --include="*.h" .
}

# Find file in Aestra
ae-find() {
    local pattern="$1"
    [ -z "$pattern" ] && { echo "Usage: ae-find <filename-pattern>"; return 1; }
    cd ~/.openclaw/workspace/Aestra || return 1
    fd "$pattern" --type f 2>/dev/null || find . -name "*$pattern*" -type f
}
