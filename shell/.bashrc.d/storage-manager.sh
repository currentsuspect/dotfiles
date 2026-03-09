# ~/.bashrc.d/storage-manager.sh
# Storage management tools

# ============================================================
# STORAGE COMMANDS
# ============================================================

alias storage='df -h / | tail -1 | awk "{printf \"💾 Used: %s / %s (%s)\n\", \$3, \$2, \$5}"'
alias big='du -h --max-depth=1 2>/dev/null | sort -hr | head -15'
alias big-files='find . -type f -size +100M 2>/dev/null | xargs ls -lh 2>/dev/null | sort -k5 -hr'

# Full storage report
storage-report() {
    echo "📊 STORAGE REPORT - $(date)"
    echo "========================"
    echo ""
    df -h / | tail -1 | awk '{printf "Overall: %s used / %s total (%s)\n\n", $3, $2, $5}'
    
    echo "📁 Top 10 Directories:"
    du -h ~ 2>/dev/null | sort -hr | head -10 | awk '{printf "  %8s  %s\n", $1, $2}'
    echo ""
    
    echo "📦 Package Caches:"
    du -sh ~/.npm 2>/dev/null | awk '{print "  npm:    " $1}'
    du -sh ~/.cache/pip 2>/dev/null | awk '{print "  pip:    " $1}'
    du -sh ~/.cargo/registry 2>/dev/null | awk '{print "  cargo:  " $1}'
    echo ""
    
    echo "📝 Logs:"
    du -sh ~/.openclaw/logs 2>/dev/null | awk '{print "  OpenClaw: " $1}'
    du -sh ~/.pm2 2>/dev/null | awk '{print "  PM2:      " $1}'
    du -sh /var/log 2>/dev/null | sudo awk '{print "  System:   " $1}'
}

# Quick clean
clean() {
    echo "🧹 Quick clean..."
    
    # NPM
    local npm_before=$(du -sh ~/.npm 2>/dev/null | cut -f1)
    npm cache clean --force 2>/dev/null
    local npm_after=$(du -sh ~/.npm 2>/dev/null | cut -f1)
    [ "$npm_before" != "$npm_after" ] && echo "  npm: $npm_before → $npm_after"
    
    # Pip
    pip cache purge 2>/dev/null && echo "  pip cache cleared"
    
    # Apt
    sudo apt-get clean 2>/dev/null && echo "  apt cache cleared"
    
    # Logs
    pm2 flush 2>/dev/null && echo "  PM2 logs flushed"
    find ~/.openclaw/logs -name "*.log" -mtime +7 -delete 2>/dev/null && echo "  old logs cleaned"
    
    # Temp
    rm -rf /tmp/tmp* /tmp/npm* 2>/dev/null
    
    echo ""
    storage
}

# Deep clean (interactive)
clean-deep() {
    echo "🔍 DEEP CLEAN ANALYSIS"
    echo "======================"
    echo ""
    
    # Find large items
    echo "Large items found:"
    du -sh ~/android-sdk/ndk/* 2>/dev/null | awk '{printf "  NDK: %s\n", $0}'
    find ~ -name "node_modules" -type d -exec du -sh {} \; 2>/dev/null | sort -hr | head -5 | awk '{printf "  node_modules: %s\n", $0}'
    
    echo ""
    read -p "Run deep clean? [y/N] " confirm
    [[ $confirm == [yY]* ]] || return
    
    clean
    
    # Clean node_modules in inactive projects
    echo ""
    echo "Cleaning old node_modules..."
    find ~/.openclaw/workspace -name "node_modules" -type d -mtime +60 -exec rm -rf {} + 2>/dev/null && echo "  old node_modules removed"
    
    storage
}

# Watch disk usage
disk-watch() {
    watch -n 5 'df -h / && echo "" && du -sh ~ 2>/dev/null | head -1'
}

# Alert on low disk
storage-alert() {
    local threshold="${1:-90}"
    local usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    
    if [ "$usage" -gt "$threshold" ]; then
        echo "⚠️  DISK ALERT: ${usage}% used (threshold: ${threshold}%)"
        storage-report
        return 1
    fi
    return 0
}
