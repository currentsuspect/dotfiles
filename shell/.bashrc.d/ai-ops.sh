# ~/.bashrc - AI Operations Extensions
# Add these to the end of ~/.bashrc

# ============================================================
# AI / OPENCLAW OPERATIONS
# ============================================================

# Quick session checks
alias oc='openclaw'
alias oc-s='openclaw sessions'
alias oc-l='openclaw sessions list --limit 20'
alias oc-m='openclaw models'
alias oc-ml='openclaw models list'
alias oc-d='openclaw doctor'
alias oc-c='openclaw config'
alias oc-g='openclaw gateway status'

# Session spawning helpers
oc-spawn() {
    local task="$1"
    local label="${2:-$(date +%s)}"
    [ -z "$task" ] && { echo "Usage: oc-spawn 'task description' [label]"; return 1; }
    openclaw sessions spawn --task "$task" --label "$label"
}

# Quick subagent spawn with timeout
oc-agent() {
    local task="$1"
    local timeout="${2:-300}"
    [ -z "$task" ] && { echo "Usage: oc-agent 'task' [timeout_seconds]"; return 1; }
    openclaw sessions spawn --runtime subagent --mode run --task "$task" --timeout "$timeout"
}

# List active agents
oc-agents() {
    openclaw subagents list 2>/dev/null || echo "No subagents active"
}

# Kill an agent by name/pattern
oc-kill() {
    local pattern="$1"
    [ -z "$pattern" ] && { echo "Usage: oc-kill <pattern>"; return 1; }
    openclaw subagents list | grep "$pattern" | awk '{print $1}' | xargs -r openclaw subagents kill
}

# Check session history
oc-history() {
    local session="${1:-main}"
    local limit="${2:-50}"
    openclaw sessions history "$session" --limit "$limit"
}

# Quick status card
oc-status() {
    openclaw session-status 2>/dev/null || openclaw status
}

# Switch model quickly
oc-model() {
    local model="$1"
    [ -z "$model" ] && { 
        echo "Usage: oc-model <model-alias>"
        echo "Aliases: kimi, glm, copilot-opus, copilot-sonnet, codex, groq, gemini"
        return 1
    }
    case "$model" in
        kimi) openclaw session-status --model kimi-coding/k2p5 ;;
        glm) openclaw session-status --model modal/zai-org/GLM-5-FP8 ;;
        copilot-opus) openclaw session-status --model github-copilot/claude-opus-4.6 ;;
        copilot-sonnet) openclaw session-status --model github-copilot/claude-sonnet-4.6 ;;
        codex) openclaw session-status --model openai-codex/gpt-5.3-codex ;;
        groq) openclaw session-status --model groq/llama-3.3-70b-versatile ;;
        gemini) openclaw session-status --model google/gemini-3-pro-preview ;;
        *) openclaw session-status --model "$model" ;;
    esac
}

# ============================================================
# SERVICE MANAGEMENT
# ============================================================

# PM2 shortcuts
alias p2='pm2'
alias p2s='pm2 status'
alias p2l='pm2 logs'
alias p2r='pm2 restart'
alias p2rs='pm2 restart all'
alias p2st='pm2 stop'
alias p2d='pm2 delete'
alias p2m='pm2 monit'
alias p2f='pm2 flush'

# Quick service status
alias status='pm2 status'
alias logs='pm2 logs --lines 100'
alias ltail='pm2 logs --lines 20 --raw'
alias lapi='pm2 logs lifeos-api'
alias lgateway='pm2 logs openclaw-gateway'
alias lblueprint='pm2 logs blueprint'
alias lmspy='pm2 logs mspy-dashboard'

# Service restart with confirmation
restart-api() {
    echo "Restarting Resonance API..."
    pm2 restart lifeos-api && echo "✅ API restarted"
}

restart-gateway() {
    echo "Restarting OpenClaw Gateway..."
    pm2 restart openclaw-gateway && echo "✅ Gateway restarted"
}

restart-all() {
    read -p "Restart ALL services? [y/N] " confirm
    [[ $confirm == [yY]* ]] && pm2 restart all
}

# Health check
health() {
    echo "🎛️  VPS Health Check"
    echo ""
    echo "Services:"
    pm2 status | grep -E "(App name|online|errored|stopped)" | head -20
    echo ""
    echo "Disk:"
    df -h / | tail -1 | awk '{print "  Used: "$3" / "$2" ("$5")"}'
    echo ""
    echo "Memory:"
    free -h | grep Mem | awk '{print "  Used: "$3" / "$2}'
    echo ""
    echo "Load:"
    uptime | awk -F'load average:' '{print "  Load avg:"$2}'
}

# ============================================================
# LOG OPERATIONS
# ============================================================

# Tail logs with context
lt() {
    local service="${1:-all}"
    local lines="${2:-50}"
    pm2 logs "$service" --lines "$lines" --raw
}

# Search logs
plog() {
    local pattern="$1"
    local service="${2:-all}"
    [ -z "$pattern" ] && { echo "Usage: plog <pattern> [service]"; return 1; }
    pm2 logs "$service" --lines 1000 | grep -i "$pattern"
}

# Follow specific log files
follow() {
    local logfile="$1"
    [ -f "$logfile" ] && tail -f "$logfile" || echo "File not found: $logfile"
}

# OpenClaw logs
ocl() {
    tail -f ~/.openclaw/logs/openclaw.log 2>/dev/null || echo "No openclaw.log found"
}

# Gateway logs
gwl() {
    tail -f ~/.openclaw/logs/gateway.log 2>/dev/null || pm2 logs openclaw-gateway
}

# ============================================================
# WORKSPACE OPERATIONS
# ============================================================

# Quick project jumps
alias w='cd ~/.openclaw/workspace'
alias wr='cd ~/.openclaw/workspace/resonance 2>/dev/null || echo "⚠️  Resonance not found"'
alias wa='cd ~/.openclaw/workspace/Aestra 2>/dev/null || echo "⚠️  Aestra not found"'
alias wpd='cd ~/.openclaw/workspace/plainsight-digital 2>/dev/null || echo "⚠️  PlainSight not found"'
alias wm='cd ~/.openclaw/workspace/mspy-clone 2>/dev/null || echo "⚠️  mSpy not found"'
alias wmd='cd ~/.openclaw/workspace/mspy-dashboard 2>/dev/null || echo "⚠️  mSpy Dashboard not found"'
alias wb='cd ~/.openclaw/workspace/blueprint 2>/dev/null || echo "⚠️  Blueprint not found"'
alias we='cd ~/Everything'

# Find in workspace
fw() {
    local pattern="$1"
    [ -z "$pattern" ] && { echo "Usage: fw <pattern>"; return 1; }
    cd ~/.openclaw/workspace && fd "$pattern" | head -20
}

# Search content in workspace
sw() {
    local pattern="$1"
    [ -z "$pattern" ] && { echo "Usage: sw <pattern>"; return 1; }
    rg "$pattern" ~/.openclaw/workspace --type-add 'code:*.{py,js,ts,dart,go,rs,java,c,cpp,h}' -tcode 2>/dev/null | head -30
}

# Find and edit config
conf() {
    local name="$1"
    case "$name" in
        oc|openclaw) $EDITOR ~/.openclaw/openclaw.json ;;
        bash|rc) $EDITOR ~/.bashrc ;;
        git) $EDITOR ~/.gitconfig ;;
        tmux) $EDITOR ~/.tmux.conf ;;
        ssh) $EDITOR ~/.ssh/config ;;
        vim) $EDITOR ~/.vimrc ;;
        starship) $EDITOR ~/.config/starship.toml ;;
        *) echo "Configs: oc, bash, git, tmux, ssh, vim, starship" ;;
    esac
}

# ============================================================
# MEMORY / NOTES OPERATIONS
# ============================================================

# Quick memory read
mem() {
    local file="${1:-MEMORY}"
    case "$file" in
        MEMORY|memory) cat ~/MEMORY.md 2>/dev/null | head -50 ;;
        TODAY|today) cat ~/.openclaw/memory/$(date +%Y-%m-%d).md 2>/dev/null || echo "No entry for today" ;;
        YESTERDAY|yesterday) cat ~/.openclaw/memory/$(date -d yesterday +%Y-%m-%d).md 2>/dev/null || echo "No entry for yesterday" ;;
        HEARTBEAT|heartbeat) cat ~/.openclaw/workspace/HEARTBEAT.md ;;
        TOOLS|tools) cat ~/.openclaw/workspace/TOOLS.md ;;
        SOUL|soul) cat ~/.openclaw/workspace/SOUL.md ;;
        USER|user) cat ~/.openclaw/workspace/USER.md ;;
        *) cat ~/.openclaw/memory/"$file".md 2>/dev/null || cat ~/.openclaw/workspace/"$file".md 2>/dev/null || echo "File not found: $file" ;;
    esac
}

# Quick memory append
note() {
    local content="$1"
    local file="${2:-$(date +%Y-%m-%d)}"
    [ -z "$content" ] && { echo "Usage: note 'content' [filename]"; return 1; }
    mkdir -p ~/.openclaw/memory
    echo "- $(date '+%H:%M') — $content" >> ~/.openclaw/memory/"$file".md
    echo "✅ Note added to $file"
}

# Edit today's memory
mem-today() {
    local today_file="$HOME/.openclaw/memory/$(date +%Y-%m-%d).md"
    mkdir -p ~/.openclaw/memory
    [ -f "$today_file" ] || echo "# $(date '+%Y-%m-%d')" > "$today_file"
    $EDITOR "$today_file"
}

# Search memory
smem() {
    local query="$1"
    [ -z "$query" ] && { echo "Usage: smem <query>"; return 1; }
    rg -i "$query" ~/.openclaw/memory/ ~/MEMORY.md 2>/dev/null | head -20
}

# ============================================================
# GIT OPERATIONS (AI-Optimized)
# ============================================================

# Quick status everywhere
gs-all() {
    for dir in ~/.openclaw/workspace/*/; do
        if [ -d "$dir/.git" ]; then
            echo "📁 $(basename "$dir"):"
            (cd "$dir" && git status -sb 2>/dev/null | head -3)
            echo ""
        fi
    done
}

# Quick commit with auto-message
gc-quick() {
    local msg="${1:-Quick update}"
    git add -A && git commit -m "$msg" && echo "✅ Committed: $msg"
}

# Push current branch
gp-now() {
    local branch=$(git branch --show-current)
    git push -u origin "$branch" 2>/dev/null || git push
}

# Sync (pull then push)
g-sync() {
    git pull && git push
}

# Discard all changes
g-nuke() {
    read -p "⚠️  Discard ALL changes? [y/N] " confirm
    [[ $confirm == [yY]* ]] && git reset --hard HEAD && git clean -fd
}

# Show recent commits across all repos
ghistory() {
    echo "📊 Recent commits (7 days)"
    for dir in ~/.openclaw/workspace/*/; do
        if [ -d "$dir/.git" ]; then
            local commits=$(cd "$dir" && git log --since="7 days ago" --oneline 2>/dev/null | wc -l)
            if [ "$commits" -gt 0 ]; then
                echo ""
                echo "📁 $(basename "$dir") ($commits commits):"
                (cd "$dir" && git log --since="7 days ago" --oneline -5)
            fi
        fi
    done
}

# ============================================================
# NETWORK / INFRASTRUCTURE
# ============================================================

# Quick connection tests
alias pingg='ping -c 3 google.com'
alias myip='curl -s ipinfo.io/ip'
alias myip-full='curl -s ipinfo.io | jq'

# Tailscale shortcuts
alias ts='tailscale'
alias ts-s='tailscale status'
alias ts-up='tailscale up'
alias ts-down='tailscale down'
alias ts-ip='tailscale ip -4'

# Port checks
alias ports='sudo ss -tlnp | grep LISTEN'
alias ports-all='sudo netstat -tulpn 2>/dev/null || sudo ss -tulpn'

# Check service on port
port-check() {
    local port="$1"
    [ -z "$port" ] && { echo "Usage: port-check <port>"; return 1; }
    sudo ss -tlnp | grep ":$port " || echo "Nothing on port $port"
}

# Curl with timing
curl-time() {
    curl -w "\n@curl-format.txt" -o /dev/null -s "$1"
}

# ============================================================
# SYSTEM MONITORING
# ============================================================

# Quick stats
alias cpu='htop -d 1 2>/dev/null || top -bn1 | head -20'
alias mem-usage='free -h'
alias disk='df -h'
alias disk-big='du -h --max-depth=1 2>/dev/null | sort -hr | head -20'
alias temps='sensors 2>/dev/null || echo "sensors not installed"'

# What's using resources?
ps-cpu() {
    ps aux --sort=-%cpu | head -11
}

ps-mem() {
    ps aux --sort=-%mem | head -11
}

# Disk usage by directory
du-sort() {
    local dir="${1:-.}"
    du -sh "$dir"/* 2>/dev/null | sort -hr | head -20
}

# ============================================================
# FILE OPERATIONS
# ============================================================

# Touch and edit
te() {
    touch "$1" && $EDITOR "$1"
}

# Backup file
bak() {
    local file="$1"
    [ -f "$file" ] && cp "$file" "$file.bak.$(date +%s)" && echo "✅ Backed up: $file"
}

# Safe remove (trash if available)
rm-safe() {
    if command -v trash-put >/dev/null; then
        trash-put "$@"
    else
        rm -i "$@"
    fi
}

# Copy with progress
cpv() {
    rsync -ah --info=progress2 "$@"
}

# Make executable
mx() {
    chmod +x "$1"
}

# ============================================================
# JSON / DATA OPERATIONS
# ============================================================

# Pretty print JSON
json() {
    if [ -f "$1" ]; then
        cat "$1" | jq .
    else
        echo "$1" | jq .
    fi
}

# JSON get key
json-get() {
    local file="$1"
    local key="$2"
    jq -r "$key" "$file"
}

# YAML to JSON
yaml2json() {
    python3 -c "import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout, indent=2)"
}

# ============================================================
# DEVELOPMENT HELPERS
# ============================================================

# Python
alias py='python3'
alias py-serve='python3 -m http.server'
alias py-env='source venv/bin/activate 2>/dev/null || source .venv/bin/activate 2>/dev/null || echo "No venv found"'

# Node
alias nr='npm run'
alias ni='npm install'
alias nid='npm install --save-dev'
alias ns='npm start'
alias nb='npm run build'
alias nt='npm test'

# Flutter
alias fl='flutter'
alias flr='flutter run'
alias flb='flutter build'
alias flc='flutter clean'
alias flg='flutter pub get'
alias fld='flutter doctor'

# Docker (if used)
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# ============================================================
# UTILITY FUNCTIONS
# ============================================================

# Repeat command
repeat() {
    local n="$1"
    shift
    for ((i=0; i<n; i++)); do
        "$@"
    done
}

# Timer
timer() {
    local seconds="$1"
    echo "Timer: ${seconds}s"
    sleep "$seconds" && echo -e "\a⏰ Timer done!"
}

# Weather
weather() {
    local loc="${1:-Nairobi}"
    curl -s "wttr.in/$loc?format=3" 2>/dev/null || echo "Weather: curl wttr.in failed"
}

# QR code generator (if qrencode available)
qr() {
    local text="$1"
    [ -z "$text" ] && { echo "Usage: qr '<text>'"; return 1; }
    command -v qrencode >/dev/null && qrencode -t ANSIUTF8 "$text" || echo "qrencode not installed"
}

# Copy to clipboard (if xclip/xsel available)
clip() {
    if command -v xclip >/dev/null; then
        xclip -selection clipboard
    elif command -v xsel >/dev/null; then
        xsel --clipboard --input
    else
        cat > /dev/null
        echo "⚠️  No clipboard tool installed"
    fi
}

# ============================================================
# WELCOME MESSAGE (override the simple one)
# ============================================================
welcome() {
    clear
    echo ""
    echo "  🎛️  Resonance VPS — $(hostname)"
    echo "  📍 $(pwd)"
    echo "  🕐 $(date '+%a %b %d %H:%M')"
    echo "  💾 $(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')"
    echo ""
    echo "  Quick: w wr wa wpd | status logs health | oc-s oc-m"
    echo ""
}

# Uncomment to show on login:
# welcome
