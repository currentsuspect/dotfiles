# ~/.bashrc.d/ai-smart.sh
# Smart operations: dashboard, alerts, workflows, error recovery

# ============================================================
# 1. UNIFIED DASHBOARD
# ============================================================

dash() {
    clear
    local width=$(tput cols)
    local line=$(printf '=%.0s' $(seq 1 $width))
    
    # Header
    echo "$line"
    echo "  🎛️  RESONANCE DASHBOARD — $(date '+%a %b %d %H:%M')"
    echo "$line"
    echo ""
    
    # Section 1: System Health (2 columns)
    echo "┌─ 💾 SYSTEM ──────────────────────┐  ┌─ 🔄 SERVICES ───────────────────┐"
    
    # Disk usage with color
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    local disk_color="\033[32m"  # green
    [ "$disk_usage" -gt 70 ] && disk_color="\033[33m"  # yellow
    [ "$disk_usage" -gt 85 ] && disk_color="\033[31m"  # red
    printf "│  Disk: ${disk_color}%3d%%\033[0m %8s / %-8s │  │  " "$disk_usage" \
        "$(df -h / | tail -1 | awk '{print $3}')" \
        "$(df -h / | tail -1 | awk '{print $2}')"
    
    # Services status
    local services_online=$(pm2 status 2>/dev/null | grep -c "online" || echo "0")
    local services_total=$(pm2 status 2>/dev/null | tail -n +4 | grep -c "│" || echo "0")
    printf "Running: %d/%d\n" "$services_online" "$services_total"
    
    # Memory
    printf "│  Memory: %-24s │  │  " "$(free -h | grep Mem | awk '{printf "%s / %s", $3, $2}')"
    
    # Any errored services
    local services_error=$(pm2 status 2>/dev/null | grep -c "errored" || echo "0")
    if [ "$services_error" -gt 0 ]; then
        printf "\033[31m⚠️  %d ERROR\033[0m\n" "$services_error"
    else
        printf "\033[32m✓ All healthy\033[0m\n"
    fi
    
    # Load
    printf "│  Load: %-26s │  │\n" "$(uptime | awk -F'load average:' '{print $2}' | xargs)"
    echo "└──────────────────────────────────┘  └──────────────────────────────────┘"
    echo ""
    
    # Section 2: Git Status (all repos)
    echo "┌─ 📁 GIT STATUS ─────────────────────────────────────────────────────────┐"
    local git_count=0
    for dir in ~/.openclaw/workspace/*/; do
        if [ -d "$dir/.git" ] && [ $git_count -lt 5 ]; then
            local name=$(basename "$dir")
            local branch=$(cd "$dir" && git branch --show-current 2>/dev/null)
            local status=$(cd "$dir" && git status --short 2>/dev/null)
            local ahead=$(cd "$dir" && git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
            
            if [ -n "$status" ]; then
                local changes=$(echo "$status" | wc -l)
                printf "│  🔴 %-12s (%-15s) %d uncommitted\n" "$name" "$branch" "$changes"
            elif [ "$ahead" -gt 0 ]; then
                printf "│  🟡 %-12s (%-15s) ↑%d unpushed\n" "$name" "$branch" "$ahead"
            else
                printf "│  🟢 %-12s (%-15s) clean\n" "$name" "$branch"
            fi
            ((git_count++))
        fi
    done
    [ $git_count -eq 0 ] && echo "│  No git repos found"
    echo "└─────────────────────────────────────────────────────────────────────────┘"
    echo ""
    
    # Section 3: Recent Activity & Quick Stats
    echo "┌─ 📊 ACTIVITY ────────────────────┐  ┌─ ⚡ QUICK ACTIONS ──────────────┐"
    
    # Last commands
    local last_cmd=$(history 2 | head -1 | sed 's/^[ 0-9]*//' | cut -c1-30)
    printf "│  Last: %-26s │  │  \033[36mdash\033[0m    This dashboard\n" "$last_cmd"
    
    # OpenClaw sessions
    local sessions=$(openclaw sessions list 2>/dev/null | grep -c "│" || echo "0")
    printf "│  Sessions: %-22s │  │  \033[36mdev\033[0m     Start dev session\n" "$sessions"
    
    # Disk alert if needed
    if [ "$disk_usage" -gt 85 ]; then
        printf "│  \033[31m⚠️  DISK ALERT: %d%%\033[0m%-17s │  │  \033[36mstatus\033[0m  Service status\n" "$disk_usage" ""
    else
        printf "│  Logs: %-26s │  │  \033[36mclean\033[0m   Clean storage\n" "$(du -sh ~/.openclaw/logs 2>/dev/null | cut -f1)"
    fi
    
    echo "└──────────────────────────────────┘  └──────────────────────────────────┘"
    echo ""
    
    # Footer shortcuts
    echo "  Quick: w wr wa wpd | status logs health | oc-s oc-m | gs-all"
    echo ""
}

# Compact dash for small terminals
dash-mini() {
    echo "🎛️ $(hostname) — $(date +%H:%M) — $(df / | tail -1 | awk '{print $5}') used"
    pm2 status 2>/dev/null | grep -E "App name|online|errored" | head -8
    echo ""
    for dir in ~/.openclaw/workspace/*; do
        [ -d "$dir/.git" ] || continue
        local name=$(basename "$dir")
        local dirty=$(cd "$dir" && git status --short 2>/dev/null | wc -l)
        [ "$dirty" -gt 0 ] && echo "🔴 $name: $dirty changes"
    done
}

# ============================================================
# 2. SMART ALERTS
# ============================================================

# Pre-command hook for smart checks
smart-check() {
    # Check disk space before large operations
    case "$1" in
        npm\ install*|npm\ i*)
            _check_space_before "2G" "npm install"
            ;;
        flutter\ build*|fl\ build*)
            _check_space_before "3G" "Flutter build"
            ;;
        docker\ build*|docker-compose*)
            _check_space_before "5G" "Docker build"
            ;;
        git\ clone*)
            _check_space_before "1G" "Git clone"
            ;;
    esac
}

# Internal: Check space and warn
_check_space_before() {
    local needed="$1"
    local operation="$2"
    local available_mb=$(df -m / | tail -1 | awk '{print $4}')
    local needed_mb
    case "$needed" in
        *G|*g) needed_mb=$(( ${needed%[Gg]} * 1024 )) ;;
        *M|*m) needed_mb=${needed%[Mm]} ;;
        *) needed_mb=$needed ;;
    esac

    if [ "$available_mb" -lt "$needed_mb" ]; then
        echo "⚠️  WARNING: $operation needs ~$needed but only ${available_mb}MB available"
        read -p "Continue anyway? [y/N] " confirm
        [[ $confirm == [yY]* ]] || return 1
    fi
}

# Watch services and alert on changes
watch-services() {
    local last_status=""
    while true; do
        local current=$(pm2 status 2>/dev/null | grep -E "errored|stopped" | wc -l)
        if [ "$current" != "$last_status" ] && [ "$current" -gt 0 ]; then
            echo "⚠️  $(date +%H:%M) — $current service(s) down!"
            pm2 status | grep -E "errored|stopped"
        fi
        last_status="$current"
        sleep 30
    done
}

# Auto-cleanup reminder
autoclean-remind() {
    local usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    if [ "$usage" -gt 80 ]; then
        echo "💡 Tip: Disk at ${usage}%. Run \033[36mclean\033[0m to free space."
    fi
}

# ============================================================
# 3. WORKFLOW SHORTCUTS
# ============================================================

# Main dev workflow
dev() {
    local project="${1:-resonance}"
    local session="dev-${project}"
    
    # Kill existing session if any
    tmux kill-session -t "$session" 2>/dev/null
    
    # Create new session
    tmux new-session -d -s "$session" -c "$HOME/.openclaw/workspace/$project" -n code
    
    # Split layout: left 70% code, right 30% logs/status
    tmux split-window -h -t "$session:code" -p 30 -c "$HOME/.openclaw/workspace/$project"
    
    # Right side: top logs, bottom status
    tmux split-window -v -t "$session:code.right" -p 50
    
    # Left: vim/neovim if available, else just ready for commands
    tmux send-keys -t "$session:code.left" 'clear && ls -la' C-m
    
    # Right-top: project-specific logs
    case "$project" in
        resonance)
            tmux send-keys -t "$session:code.right.top" 'pm2 logs lifeos-api --lines 50' C-m
            ;;
        mspy-dashboard)
            tmux send-keys -t "$session:code.right.top" 'pm2 logs mspy-dashboard --lines 50' C-m
            ;;
        blueprint)
            tmux send-keys -t "$session:code.right.top" 'pm2 logs blueprint --lines 50' C-m
            ;;
        *)
            tmux send-keys -t "$session:code.right.top" 'cd .. && ll' C-m
            ;;
    esac
    
    # Right-bottom: status/dashboard
    tmux send-keys -t "$session:code.right.bottom" 'watch -n 5 "pm2 status | head -15"' C-m
    
    # Attach
    tmux attach -t "$session"
}

# Quick log workflow
logs-flow() {
    local service="${1:-all}"
    tmux new-session -d -s logs -n main
    tmux split-window -h -t logs:main
    tmux split-window -v -t logs:main.left
    
    tmux send-keys -t logs:main.left-top "pm2 logs $service --lines 100" C-m
    tmux send-keys -t logs:main.left-bottom "tail -f ~/.openclaw/logs/openclaw.log" C-m
    tmux send-keys -t logs:main.right "watch -n 2 'pm2 status'" C-m
    
    tmux attach -t logs
}

# Monitor workflow (status + resources)
monitor() {
    tmux new-session -d -s monitor -n system
    tmux split-window -h -t monitor:system
    
    tmux send-keys -t monitor:system.left 'htop' C-m
    tmux send-keys -t monitor:system.right 'watch -n 1 "pm2 status && echo \"\" && df -h /"' C-m
    
    tmux attach -t monitor
}

# Workspace overview
overview() {
    tmux new-session -d -s overview -n ws
    tmux split-window -h -t overview:ws
    tmux split-window -v -t overview:ws.left
    tmux split-window -v -t overview:ws.right
    
    tmux send-keys -t overview:ws.left-top 'watch -n 5 "gs-all | head -20"' C-m
    tmux send-keys -t overview:ws.left-bottom 'storage-report' C-m
    tmux send-keys -t overview:ws.right-top 'pm2 monit' C-m
    tmux send-keys -t overview:ws.right-bottom 'watch -n 10 dash-mini' C-m
    
    tmux attach -t overview
}

# Kill workflow
dev-kill() {
    local session="${1:-dev-resonance}"
    tmux kill-session -t "$session" 2>/dev/null && echo "✅ Killed $session" || echo "Session $session not found"
}

# List dev sessions
dev-ls() {
    tmux ls 2>/dev/null | grep -E "^dev-|^logs|^monitor|^overview" || echo "No workflow sessions"
}

# ============================================================
# 4. ERROR RECOVERY & SUGGESTIONS
# ============================================================

# Smart error handler
smart-error() {
    local last_cmd="$1"
    local exit_code="$2"
    
    case "$exit_code" in
        1)
            # General error - parse stderr
            ;;
        126)
            echo "💡 Command not executable. Try: chmod +x \u003cfile\u003e"
            ;;
        127)
            echo "💡 Command not found. Check PATH or install the tool."
            ;;
        130)
            echo "💡 Interrupted with Ctrl+C"
            ;;
    esac
    
    # Check for common error patterns
    if echo "$last_cmd" | grep -q "port\|listen"; then
        # Port-related errors
        local port=$(echo "$last_cmd" | grep -oE '[0-9]{4,5}' | head -1)
        [ -n "$port" ] && _suggest_port_fix "$port"
    fi
    
    if echo "$last_cmd" | grep -qE "npm|yarn|pnpm"; then
        _suggest_npm_fix "$last_cmd"
    fi
    
    if echo "$last_cmd" | grep -qE "git push|git pull"; then
        _suggest_git_fix "$last_cmd"
    fi
    
    if echo "$last_cmd" | grep -q "flutter"; then
        _suggest_flutter_fix "$last_cmd"
    fi
}

_suggest_port_fix() {
    local port="$1"
    echo ""
    echo "💡 Port $port might be in use. Try:"
    echo "   kill-port $port       # Kill process on port"
    echo "   port-check $port      # See what's using it"
    echo "   lsof -i :$port        # Detailed info"
}

_suggest_npm_fix() {
    echo ""
    echo "💡 NPM troubleshooting:"
    echo "   rm -rf node_modules && npm install    # Clean reinstall"
    echo "   npm cache clean --force               # Clear cache"
    echo "   check-space 1G                        # Verify disk space"
}

_suggest_git_fix() {
    echo ""
    echo "💡 Git troubleshooting:"
    echo "   g-sync           # Pull then push"
    echo "   git stash && git pull && git stash pop  # Stash, pull, unstash"
    echo "   git branch -vv   # Check upstream status"
}

_suggest_flutter_fix() {
    echo ""
    echo "💡 Flutter troubleshooting:"
    echo "   flc && flg      # Clean and get packages"
    echo "   flutter doctor   # Check environment"
    echo "   check-space 3G   # Verify disk for build"
}

# Kill process on port
kill-port() {
    local port="$1"
    [ -z "$port" ] && { echo "Usage: kill-port <port>"; return 1; }
    
    local pid=$(sudo lsof -t -i :$port 2>/dev/null)
    if [ -n "$pid" ]; then
        echo "Killing process $pid on port $port..."
        sudo kill -9 $pid && echo "✅ Port $port freed"
    else
        echo "No process found on port $port"
    fi
}

# Fix common issues
fix() {
    local issue="$1"
    case "$issue" in
        npm|node_modules)
            echo "🧹 Fixing npm..."
            rm -rf node_modules package-lock.json
            npm cache clean --force
            npm install
            ;;
        git|merge)
            echo "🔄 Fixing git..."
            git merge --abort 2>/dev/null
            git rebase --abort 2>/dev/null
            git reset --hard HEAD
            ;;
        port)
            echo "🔌 Available ports:"
            sudo ss -tlnp | grep LISTEN | awk '{print $4}' | cut -d: -f2 | sort -n | uniq
            ;;
        pm2|services)
            echo "🔄 Restarting services..."
            pm2 restart all
            ;;
        *)
            echo "Fix what?"
            echo "  fix npm       # Clean reinstall node_modules"
            echo "  fix git       # Abort merge/rebase, reset"
            echo "  fix port      # Show used ports"
            echo "  fix pm2       # Restart all services"
            ;;
    esac
}

# Command not found handler
command_not_found_handle() {
    local cmd="$1"
    echo "❌ Command not found: $cmd"
    
    # Suggest similar commands
    local similar=$(alias | grep -E "alias $cmd|=.$cmd" | head -3)
    if [ -n "$similar" ]; then
        echo ""
        echo "Did you mean:"
        echo "$similar" | sed 's/^/  /'
    fi
    
    # Check if it's a common tool
    case "$cmd" in
        vim|nvim)
            echo "💡 Try: sudo apt install vim"
            ;;
        docker)
            echo "💡 Docker not installed. See: https://docs.docker.com/engine/install/ubuntu/"
            ;;
        code)
            echo "💡 VS Code not installed. Try: snap install code"
            ;;
    esac
    
    return 127
}

# ============================================================
# AUTO-RUN CHECKS
# ============================================================

# Run autoclean reminder only when explicitly enabled
if [[ $- == *i* ]] && [ "${AUTOCLEAN_REMIND:-0}" = "1" ]; then
    autoclean-remind
fi

# Export for use in PROMPT_COMMAND if desired.
# To preserve an existing PROMPT_COMMAND, append smart-check and then run the
# previous value, for example:
#   PROMPT_COMMAND='smart-check "$BASH_COMMAND"; history -a'
# If you already have a more complex PROMPT_COMMAND, wrap/append carefully so
# $BASH_COMMAND is expanded at prompt time, not when you edit the file.
export -f smart-check 2>/dev/null
