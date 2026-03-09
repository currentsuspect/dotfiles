# ~/.bashrc - VPS Config Bundle
# Safe-ish baseline for Ubuntu VPS + OpenClaw workflows

[[ $- != *i* ]] && return

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------
has() { command -v "$1" >/dev/null 2>&1; }
# shellcheck disable=SC1090
source_if() {
  [ -f "$1" ] || return 0
  . "$1"
}
alias_if() {
  local cmd="$1"
  shift
  if has "$cmd"; then
    alias "$@"
  fi
}

# ------------------------------------------------------------
# PATH / editor / history
# ------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin:$PATH"
export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"

export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
shopt -s histappend cmdhist autocd cdspell dirspell checkwinsize globstar extglob
PROMPT_COMMAND='history -a'

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34'
if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# ------------------------------------------------------------
# Navigation
# ------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias ws='cd ~/.openclaw/workspace'
alias wr='cd ~/.openclaw/workspace/resonance 2>/dev/null || echo "Resonance not found"'
alias wa='cd ~/.openclaw/workspace/Aestra 2>/dev/null || echo "Aestra not found"'
alias wpd='cd ~/.openclaw/workspace/plainsight-digital 2>/dev/null || echo "PlainSight not found"'

# ------------------------------------------------------------
# Modern CLI replacements
# ------------------------------------------------------------
if has eza; then
  alias ls='eza --group-directories-first --icons=auto'
  alias l='eza -lbF --git --group-directories-first --icons=auto'
  alias ll='eza -lbGF --git --group-directories-first --icons=auto'
  alias llm='eza -lbGF --git --sort=modified --group-directories-first --icons=auto'
  alias la='eza -lbhHigmuSa --time-style=long-iso --git --color-scale --group-directories-first --icons=auto'
  alias lx='eza -lbhHigmuSa@ --time-style=long-iso --git --color-scale --group-directories-first --icons=auto'
  alias ltree='eza --tree --level=2 --group-directories-first --icons=auto'
  alias llt='eza --tree --level=2 --long --git --group-directories-first --icons=auto'
fi

if has batcat; then
  alias cat='batcat --paging=never --style=plain'
  alias bat='batcat'
  alias less='batcat --paging=always'
elif has bat; then
  alias cat='bat --paging=never --style=plain'
  alias less='bat --paging=always'
fi

if has fd; then
  alias find='fd'
  alias f='fd --type f'
  alias d='fd --type d'
  alias ff='fd --type f --hidden --no-ignore'
fi

if has rg; then
  alias grep='rg'
  alias rg='rg --smart-case --heading --line-number'
fi

# ------------------------------------------------------------
# Git / tools
# ------------------------------------------------------------
has git && {
  alias g='git'; alias gs='git status -sb'; alias ga='git add'; alias gaa='git add -A'
  alias gc='git commit'; alias gcm='git commit -m'; alias gca='git commit --amend --no-edit'
  alias gp='git push'; alias gpf='git push --force-with-lease'; alias gl='git pull'
  alias glog='git log --oneline --decorate --graph -20'; alias gloga='git log --oneline --decorate --graph --all -20'
  alias gd='git diff'; alias gds='git diff --staged'; alias gco='git checkout'; alias gcb='git checkout -b'
  alias gbd='git branch -d'; alias gbD='git branch -D'; alias gcl='git clone'; alias gst='git stash'; alias gsp='git stash pop'
  alias grb='git rebase'; alias grbc='git rebase --continue'; alias grba='git rebase --abort'
}

has zoxide && {
  eval "$(zoxide init bash)"
  alias zq='zoxide query'
  alias zqi='zoxide query -i'
}

has jq && alias jq='jq -C'
alias du='du -h'
alias df='df -h'
alias ps='ps auxf'
if has htop; then
  alias top='htop'
else
  alias top='top'
fi
alias mkdir='mkdir -p'
alias cp='cp -r'
if has trash-put; then
  alias rm='trash-put'
else
  alias rm='rm -i'
fi
if has tmux; then
  alias t='tmux'
  alias ta='tmux attach'
  alias tls='tmux ls'
fi

# ------------------------------------------------------------
# VPS / OpenClaw
# ------------------------------------------------------------
has pm2 && {
  alias status='pm2 status'
  alias logs='pm2 logs'
  alias restart='pm2 restart all'
}
has sudo && alias reload='sudo systemctl daemon-reload'
has sudo && alias ports='sudo ss -tlnp | grep LISTEN'
has curl && alias myip='curl -s ipinfo.io/ip'
has tailscale && { alias tailscale-status='tailscale status'; alias ts='tailscale'; }
[ -x ~/.openclaw/workspace/service-status.sh ] && alias vps-health='~/.openclaw/workspace/service-status.sh'

has openclaw && {
  alias oc='openclaw'; alias oc-s='openclaw sessions'; alias oc-l='openclaw sessions list --limit 20'
  alias oc-m='openclaw models'; alias oc-ml='openclaw models list'; alias oc-d='openclaw doctor'
  alias oc-c='openclaw config'; alias oc-g='openclaw gateway status'
}

# ------------------------------------------------------------
# Utility functions
# ------------------------------------------------------------
mkcd() {
  mkdir -p "$1" || return 1
  cd "$1" || return 1
}

extract() {
  if [ ! -f "${1:-}" ]; then echo "'$1' is not a valid file"; return 1; fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "Unknown archive format: $1" ;;
  esac
}

fdcd() {
  if ! has fd || ! has fzf; then
    echo 'fdcd needs fd + fzf'
    return 1
  fi
  local dir
  dir=$(fd --type d | fzf) || return 1
  cd "$dir" || return 1
}
fve() {
  if ! has fd || ! has fzf; then
    echo 'fve needs fd + fzf'
    return 1
  fi
  local preview='cat {}'
  if has batcat; then
    preview='batcat --color=always {}'
  elif has bat; then
    preview='bat --color=always {}'
  fi
  local file
  file=$(fd --type f | fzf --preview "$preview") || return 1
  ${EDITOR:-vim} "$file"
}
fgco() {
  if ! has git || ! has fzf; then
    echo 'fgco needs git + fzf'
    return 1
  fi
  local branch
  branch=$(git branch --all | grep -v HEAD | sed 's/^[* ]*//' | fzf) || return 1
  git checkout "$branch"
}
fgc() {
  if ! has git || ! has fzf; then
    echo 'fgc needs git + fzf'
    return 1
  fi
  git status --short | fzf --multi --preview 'git diff --color=always {2}' | awk '{print $2}' | xargs git add
  git status
}
fh() {
  if ! has fzf; then
    echo 'fh needs fzf'
    return 1
  fi
  eval "$(history | fzf +s --tac | sed 's/^[ 0-9]*//')"
}
fkill() {
  if ! has fzf; then
    echo 'fkill needs fzf'
    return 1
  fi
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  [ -n "$pid" ] && echo "$pid" | xargs kill -9
}
genpass() { local length="${1:-20}"; openssl rand -base64 48 | cut -c1-"$length"; }

# ------------------------------------------------------------
# FZF / prompt / completion
# ------------------------------------------------------------
if has fzf && has fd; then
  export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border=rounded --prompt='❯ ' --pointer='▶' --marker='✓' --preview-window='right:50%:wrap' --color=fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7 --color=fg+:#c0caf5,bg+:#292e42,hl+:#7aa2f7 --color=info:#e0af68,prompt:#7aa2f7,pointer:#f7768e --color=marker:#9ece6a,spinner:#9ece6a,header:#7aa2f7"
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  source_if /usr/share/doc/fzf/examples/key-bindings.bash
  source_if /usr/share/doc/fzf/examples/completion.bash
fi

has starship && eval "$(starship init bash)"
if ! shopt -oq posix; then
  source_if /usr/share/bash-completion/bash_completion
  if [ ! -f /usr/share/bash-completion/bash_completion ]; then
    source_if /etc/bash_completion
  fi
fi
complete -cf sudo 2>/dev/null || true
complete -cf man 2>/dev/null || true
complete -cf which 2>/dev/null || true

[[ -t 0 ]] && stty -ixon

# ------------------------------------------------------------
# Extensions
# ------------------------------------------------------------
source_if ~/.bashrc.d/ai-ops.sh
source_if ~/.bashrc.d/ai-needs.sh
source_if ~/.bashrc.d/storage-manager.sh
source_if ~/.bashrc.d/ai-smart.sh
source_if ~/.bashrc.d/aestra-dev.sh
source_if ~/.bashrc.d/local.sh

if has auto-deploy; then
  alias ad='auto-deploy'
  alias ad-kch='auto-deploy ~/.openclaw/workspace/kch-website'
  alias ad-logs='tail -f ~/.openclaw/logs/auto-deploy-*.log'
  alias ad-stop='pkill -f "auto-deploy" 2>/dev/null || echo "No auto-deploy running"'
  ad-status() {
    if pgrep -f "auto-deploy" >/dev/null 2>&1; then
      echo "Auto-deploy running"
    else
      echo "Auto-deploy stopped"
    fi
  }
fi

# ------------------------------------------------------------
# Welcome
# ------------------------------------------------------------
echo ""
echo "  🎛️  Resonance VPS — $(hostname)"
echo "  📍 $(pwd)"
echo "  🕐 $(date '+%a %b %d %H:%M')"
echo ""
echo "  Quick: ws wr wa wpd | status logs health | oc-s oc-m"
echo ""
