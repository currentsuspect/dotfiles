# ~/.bashrc.d/ai-needs.sh
# Things Resonance needs to work efficiently

# ============================================================
# LOG MANAGEMENT
# ============================================================

# Rotate and compress old logs
log-rotate() {
    local log_dir="${1:-~/.openclaw/logs}"
    local days="${2:-7}"
    
    echo "🔄 Rotating logs older than $days days in $log_dir"
    find "$log_dir" -name "*.log" -mtime +$days -exec gzip {} \; 2>/dev/null
    find "$log_dir" -name "*.gz" -mtime +30 -delete 2>/dev/null
    echo "✅ Log rotation complete"
    du -sh "$log_dir" 2>/dev/null
}

# Clear all logs (with backup option)
log-clear() {
    local log_dir="${1:-~/.openclaw/logs}"
    read -p "⚠️  Clear all logs in $log_dir? [y/N] " confirm
    if [[ $confirm == [yY]* ]]; then
        mkdir -p "$log_dir/backups"
        tar czf "$log_dir/backups/logs-$(date +%s).tar.gz" -C "$log_dir" . 2>/dev/null
        find "$log_dir" -name "*.log" -delete
        pm2 flush 2>/dev/null
        echo "✅ Logs cleared (backup in $log_dir/backups)"
    fi
}

# Check log sizes
log-size() {
    local log_dir="${1:-~/.openclaw/logs}"
    echo "📊 Log sizes in $log_dir:"
    find "$log_dir" -type f -name "*.log*" -exec ls -lh {} \; 2>/dev/null | awk '{print $5, $9}' | sort -hr | head -20
}

# Tail multiple logs at once
log-watch() {
    local pattern="${1:-*.log}"
    local dir="${2:-~/.openclaw/logs}"
    
    # Find matching log files and tail them with labels
    local files=$(find "$dir" -name "$pattern" -type f 2>/dev/null | head -5)
    if [ -z "$files" ]; then
        echo "No logs matching '$pattern' found"
        return 1
    fi
    
    echo "📋 Watching logs:"
    echo "$files" | while read f; do echo "  - $f"; done
    echo ""
    
    # Use multitail if available, else simple tail
    if command -v multitail >/dev/null; then
        multitail $files
    else
        tail -f $files 2>/dev/null | grep --line-buffered -E "^==>|ERROR|WARN|FATAL" 
    fi
}

# ============================================================
# STORAGE MANAGEMENT
# ============================================================

# Full storage audit
storage-audit() {
    echo "📊 STORAGE AUDIT"
    echo "================"
    echo ""
    
    # Overall
    echo "💾 Overall Usage:"
    df -h / | tail -1 | awk '{printf "  Used: %s / %s (%s)\n", $3, $2, $5}'
    echo ""
    
    # Biggest directories
    echo "📁 Largest Directories (top 15):"
    du -h --max-depth=1 ~ 2>/dev/null | sort -hr | head -15 | awk '{printf "  %8s  %s\n", $1, $2}'
    echo ""
    
    # Package caches
    echo "📦 Package Caches:"
    echo "  npm:    $(du -sh ~/.npm 2>/dev/null | cut -f1)"
    echo "  pip:    $(du -sh ~/.cache/pip 2>/dev/null | cut -f1)"
    echo "  cargo:  $(du -sh ~/.cargo/registry 2>/dev/null | cut -f1)"
    echo "  apt:    $(sudo du -sh /var/cache/apt 2>/dev/null | cut -f1)"
    echo ""
    
    # Logs
    echo "📝 Logs:"
    echo "  ~/.openclaw/logs:  $(du -sh ~/.openclaw/logs 2>/dev/null | cut -f1)"
    echo "  /var/log:          $(sudo du -sh /var/log 2>/dev/null | cut -f1)"
    echo ""
    
    # PM2
    echo "🔄 PM2:"
    echo "  ~/.pm2:            $(du -sh ~/.pm2 2>/dev/null | cut -f1)"
    echo ""
}

# Clean package caches
cache-clean() {
    echo "🧹 Cleaning package caches..."
    
    # npm
    if [ -d ~/.npm ]; then
        npm cache clean --force 2>/dev/null
        echo "  ✅ npm cache cleaned"
    fi
    
    # pip
    if [ -d ~/.cache/pip ]; then
        pip cache purge 2>/dev/null
        echo "  ✅ pip cache cleaned"
    fi
    
    # cargo
    if [ -d ~/.cargo ]; then
        cargo cache --autoclean 2>/dev/null
        echo "  ✅ cargo cache cleaned"
    fi
    
    # apt
    sudo apt-get clean 2>/dev/null
    sudo apt-get autoclean 2>/dev/null
    echo "  ✅ apt cache cleaned"
    
    # yarn (if exists)
    yarn cache clean 2>/dev/null && echo "  ✅ yarn cache cleaned"
    
    echo ""
    echo "💾 Space after cleanup:"
    df -h / | tail -1 | awk '{printf "  %s used (%s)\n", $3, $5}'
}

# Find and remove old files
old-files() {
    local days="${1:-30}"
    local dir="${2:-~}"
    
    echo "🔍 Files older than $days days in $dir:"
    find "$dir" -type f -mtime +$days -size +1M 2>/dev/null | while read f; do
        ls -lh "$f" | awk '{printf "  %5s  %s\n", $5, $9}'
    done | head -20
}

# Remove old files interactively
old-files-rm() {
    local days="${1:-30}"
    local dir="${2:-~/.openclaw/logs}"
    
    echo "⚠️  Will delete files older than $days days in $dir"
    read -p "Continue? [y/N] " confirm
    [[ $confirm == [yY]* ]] || return
    
    find "$dir" -type f -mtime +$days -delete 2>/dev/null
    echo "✅ Old files removed"
}

# ============================================================
# BACKUP & RECOVERY
# ============================================================

# Quick backup of important configs
config-backup() {
    local backup_dir="$HOME/.backups/configs-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    echo "💾 Backing up configs to $backup_dir"
    
    cp ~/.bashrc "$backup_dir/"
    cp ~/.bashrc.d/*.sh "$backup_dir/" 2>/dev/null
    cp ~/.tmux.conf "$backup_dir/"
    cp ~/.gitconfig "$backup_dir/"
    cp ~/.ssh/config "$backup_dir/ssh-config"
    cp ~/.config/starship.toml "$backup_dir/"
    cp ~/.openclaw/openclaw.json "$backup_dir/"
    
    tar czf "$backup_dir.tar.gz" -C "$backup_dir" .
    rm -rf "$backup_dir"
    
    echo "✅ Backup created: $backup_dir.tar.gz"
}

# List backups
backups() {
    echo "📦 Available backups:"
    ls -lh ~/.backups/*.tar.gz 2>/dev/null | awk '{printf "  %s  %s\n", $5, $9}' | tail -10
}

# Restore from backup
config-restore() {
    local backup="$1"
    if [ -z "$backup" ]; then
        echo "Available backups:"
        backups
        read -p "Enter backup file to restore: " backup
    fi
    
    [ -f "$backup" ] || { echo "Backup not found: $backup"; return 1; }
    
    read -p "⚠️  This will overwrite current configs. Continue? [y/N] " confirm
    [[ $confirm == [yY]* ]] || return
    
    local tmpdir=$(mktemp -d)
    tar xzf "$backup" -C "$tmpdir"
    
    cp "$tmpdir/.bashrc" ~/
    cp "$tmpdir/"*.sh ~/.bashrc.d/ 2>/dev/null
    cp "$tmpdir/.tmux.conf" ~/
    cp "$tmpdir/.gitconfig" ~/
    cp "$tmpdir/ssh-config" ~/.ssh/config
    cp "$tmpdir/starship.toml" ~/.config/
    cp "$tmpdir/openclaw.json" ~/.openclaw/
    
    rm -rf "$tmpdir"
    echo "✅ Configs restored from $backup"
    echo "Reload with: source ~/.bashrc"
}

# ============================================================
# SAFETY & SANITY CHECKS
# ============================================================

# Check before dangerous operations
safe-rm() {
    local opts=()
    local paths=()
    local arg

    for arg in "$@"; do
        case "$arg" in
            --) opts+=("$arg") ;;
            -*) opts+=("$arg") ;;
            *)  paths+=("$arg") ;;
        esac
    done

    if [ ${#paths[@]} -eq 0 ]; then
        echo "Usage: safe-rm [-r|-f|-rf] <path...>"
        return 1
    fi

    for f in "${paths[@]}"; do
        if [ -d "$f" ]; then
            read -r -p "⚠️  Delete directory '$f'? [y/N] " confirm
            [[ $confirm == [yY]* ]] && /bin/rm "${opts[@]}" "$f"
        elif [ -e "$f" ]; then
            read -r -p "⚠️  Delete file '$f'? [y/N] " confirm
            [[ $confirm == [yY]* ]] && /bin/rm "${opts[@]}" "$f"
        else
            echo "Not found: $f"
        fi
    done
}

# Safer explicit deletion helpers
alias rm-safe='safe-rm'
alias rm-force='/bin/rm'

# Check disk space before big operations
check-space() {
    local needed="${1:-1G}"
    local available=$(df -BG / | tail -1 | awk '{print $4}' | tr -d 'G')
    local needed_num=$(echo "$needed" | tr -d 'GgMmKk')
    
    if [ "$available" -lt "$needed_num" ]; then
        echo "⚠️  Low disk space: ${available}G available, ${needed} needed"
        return 1
    fi
    echo "✅ Space OK: ${available}G available"
}

# ============================================================
# SESSION MANAGEMENT (for AI)
# ============================================================

# Save session state before restart
session-save() {
    local state_file="$HOME/.openclaw/.session-state"
    cat > "$state_file" <<EOF
LAST_PWD=$(pwd)
LAST_CMD=$(history 1 | sed 's/^[ 0-9]*//')
TIMESTAMP=$(date -Iseconds)
EOF
    echo "✅ Session state saved"
}

# Restore session state
session-restore() {
    local state_file="$HOME/.openclaw/.session-state"
    if [ -f "$state_file" ]; then
        echo "📂 Restoring last session:"
        cat "$state_file"
        cd "$(grep LAST_PWD "$state_file" | cut -d= -f2)" 2>/dev/null
    fi
}

# Quick workspace summary
ws-summary() {
    echo "📊 WORKSPACE SUMMARY"
    echo "===================="
    echo ""
    echo "Location: $(pwd)"
    echo "Time: $(date)"
    echo ""
    
    # Git status for all repos
    for dir in ~/.openclaw/workspace/*/; do
        if [ -d "$dir/.git" ]; then
            local name=$(basename "$dir")
            local branch=$(cd "$dir" && git branch --show-current 2>/dev/null)
            local status=$(cd "$dir" && git status --short 2>/dev/null | wc -l)
            
            if [ "$status" -gt 0 ]; then
                echo "🔴 $name ($branch): $status uncommitted changes"
            else
                echo "🟢 $name ($branch): clean"
            fi
        fi
    done
    
    echo ""
    echo "Services:"
    pm2 status | grep -E "online|errored|stopped" | wc -l | xargs echo "  Running processes:"
}

# Auto-cleanup on low disk
auto-cleanup() {
    local threshold="${1:-90}"
    local usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    
    if [ "$usage" -gt "$threshold" ]; then
        echo "⚠️  Disk usage at ${usage}%. Running auto-cleanup..."
        cache-clean
        log-rotate ~/.openclaw/logs 3
        echo "✅ Auto-cleanup complete"
        df -h /
    else
        echo "✅ Disk usage at ${usage}%. No cleanup needed."
    fi
}

# Run cleanup check daily via cron (adds entry if not exists)
setup-auto-cleanup() {
    local cron_job="0 3 * * * /bin/bash -c 'source ~/.bashrc && auto-cleanup 85'"
    
    if ! crontab -l 2>/dev/null | grep -q "auto-cleanup"; then
        (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
        echo "✅ Auto-cleanup scheduled (daily at 3am, threshold 85%)"
    else
        echo "ℹ️  Auto-cleanup already scheduled"
    fi
}
