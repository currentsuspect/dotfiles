# Path to your Oh My Zsh installation
export ZSH=$HOME/.oh-my-zsh

# Path to powerlevel10k theme
source ~/.config/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Set name of the theme to load
export ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable plugins
plugins=(git sudo zsh-syntax-highlighting zsh-autosuggestions)

# Source the Oh My Zsh configuration
source $ZSH/oh-my-zsh.sh

# Function to handle command not found
command_not_found_handler() {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries
    entries=$(pacman -F --machinereadable -- "/usr/bin/$1" 2>/dev/null)

    if [[ -n "$entries" ]]; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        while IFS= read -r entry; do
            if [[ $entry =~ ^(.+):(.+)$ ]]; then
                local pkg="${BASH_REMATCH[2]}"
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "$pkg"
            fi
        done <<< "$entries"
    fi
    return 127
}

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
    aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
    aurhelper="paru"
fi

# Function to install packages from Arch and AUR
in() {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null ; then
            arch+=("${pkg}")
        else 
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# Initialize zoxide
eval "$(zoxide init --cmd fcd zsh)"

# Source powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Aliases for system update and management
alias up='sudo pacman -Syu'    # Update system
alias srch='sudo pacman -Ss'   # Search for a package
alias inst='sudo pacman -S'    # Install a package
alias remv='sudo pacman -Rns'  # Remove a package
alias cln='sudo pacman -Sc'    # Clean package cache
alias blackarch-update='sudo pacman -Syu blackarch' # Update BlackArch tools

# Directory navigation (ensure directories exist or adjust as needed)
alias ..='fcd ..'
alias ...='fcd ../..'
alias ....='fcd ../../..'
# Ensure that these directories exist or remove/change accordingly
# alias cdp='fcd ~/Projects'
# alias cdd='fcd ~/Downloads'
# alias cddoc='fcd ~/Documents'
alias fcd='fzf_cd'             # Change directory with fzf

# File and directory operations
alias ll='eza -alh --icons --color=auto' # Long list with human-readable sizes
alias la='eza -A --icons --color=auto'   # List all except . and ..
alias l='eza --icons --color=auto'       # Regular list with color
alias mkdir='mkdir -p'          # Create directories, including parent directories
alias rm='rm -i'                # Remove with confirmation
alias mv='mv -i'                # Move with confirmation
alias cp='cp -i'                # Copy with confirmation
alias f='find . -name'          # Find files by name

# Git commands
alias gs='git status'           # Git status
alias ga='git add'              # Git add
alias gc='git commit'           # Git commit
alias gp='git push'             # Git push
alias gl='git pull'             # Git pull
alias gco='git checkout'        # Git checkout
alias gb='git branch'           # Git branch
alias gd='git diff'             # Git diff
alias gcl='git clean -fd'       # Git clean

# Zsh and shell enhancements
alias zr='source ~/.zshrc'      # Reload .zshrc
alias editz='nvim ~/.zshrc'     # Edit .zshrc
alias zshup='sudo pacman -S zsh' # Update zsh
alias tmuxconf='nvim ~/.tmux.conf' # Edit tmux config
alias zshconfig='nvim ~/.zshrc' # Edit zsh config

# Neovim and editor shortcuts
alias vi='nvim'                 # Use neovim for vi
alias vim='nvim'                # Use neovim for vim
alias edit='nvim'               # General edit command using neovim
alias vimdiff='nvim -d'         # Use neovim for diffing files

# Network commands
alias ip='ip -c a'              # Show IP addresses with color
alias ping='ping -c 5'          # Ping with 5 packets
alias ports='sudo netstat -tulnp' # List open ports
alias myip='curl ifconfig.me'   # Get external IP address
alias trace='traceroute'        # Trace route to a host

# BlackArch tools
alias basrch='pacman -Ss blackarch'  # Search BlackArch repository
alias bainst='sudo pacman -S blackarch'  # Install BlackArch tools
alias baremv='sudo pacman -Rns blackarch'  # Remove BlackArch tools

# Miscellaneous aliases
alias cls='clear'               # Clear terminal screen
alias h='history'               # Show command history
alias t='tmux'                  # Start tmux
alias k='kill -9'               # Kill process
alias psaux='ps aux | less'     # List processes
alias path='echo -e ${PATH//:/\\n}'  # Display PATH variable
alias du='du -h --max-depth=1'  # Show disk usage
alias df='df -h'                # Show disk space
alias lsh='ls -sh'              # List files with sizes
alias lsd='ls --almost-all'     # List files including hidden ones

# Custom Functions
backup_file() {
    if [[ -z "$1" ]]; then
        echo "Usage: backup_file filename"
        return 1
    fi
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "$file.bak"
        echo "Backup of $file created as $file.bak"
    else
        echo "$file does not exist."
    fi
}

auto_update() {
    echo "Updating system..."
    sudo pacman -Syu
}

check_disk_usage() {
    local threshold=80
    local usage
    usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if (( usage > threshold )); then
        echo "Warning: Disk usage is at ${usage}%"
    else
        echo "Disk usage is at ${usage}%"
    fi
}

system_status() {
    echo "CPU and Memory Usage:"
    top -bn1 | head -20
}

goto_git_repo() {
    local repo_name="$1"
    local repo_path="$HOME/Projects/$repo_name"
    if [[ -d "$repo_path" ]]; then
        fcd "$repo_path"
    else
        echo "Repository $repo_name does not exist in $HOME/Projects."
    fi
}

# Custom directory change with fzf
fzf_cd() {
    local dir
    dir=$(find . -type d -not -path "*/\.*" | fzf +m) && fcd "$dir"
}

# The Fuck integration
eval $(thefuck --alias)

# Additional Enhancements
# Function to quickly access frequently used directories
alias docs='fcd ~/Documents'
alias down='fcd ~/Downloads'
alias proj='fcd ~/Projects'
alias conf='fcd ~/.config'

# Function to show last command and its exit status
last_command() {
    local status=$?
    echo "Last command exited with status $status: $(history 1)"
}

# Function to search for files using fd
search_files() {
    local query="$1"
    fd "$query"
}

# Function to show system uptime
show_uptime() {
    uptime -p
}

# Function to check battery status
battery_status() {
    upower -i $(upower -e | grep 'BAT') | grep -E 'state|percentage'
}

# Add the current directory to recent directories list when changing directories
precmd() {
    add_recent_dir
}

# Enhanced Prompt Customization
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

# Custom Auto-Completion
_foo() {
    _arguments '1: :'
}
compdef _foo foo

# Custom Key Bindings
bindkey -s '^a' 'echo "Hello, World!"\n'

# Syntax Highlighting Configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[default]='fg=green'

# The Fuck Configuration
export THEFUCK_CUSTOM_ALIAS='fuck'
eval $(thefuck --alias)

# Custom Widgets
greet_user() {
    echo "Hello, $USER!"
}
zle -N greet_user
bindkey '^g' greet_user

# Improved History Management
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# Auto-Suggestions Enhancements
ZSH_AUTOSUGGESTIONS_HIGHLIGHT_STYLE='fg=yellow'

# Use Theme-Specific Plugins
# Example: zsh-navigation-tools

# Change Default Shell Behavior
setopt no_beep
setopt extended_glob

# Custom Command Wrappers
ls() {
    command ls -a "$@"
}

# Color Customizations
autoload -U colors && colors

# Dynamic Path Management
export PATH="$HOME/bin:$PATH"

# Custom Startup Messages
echo "Welcome, $USER!"

# Improve Command-Line Editing
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Automate Common Tasks
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Improve Command Substitution
alias ..='cd ..'
alias ...='cd ../..'

# Set Up Auto-Reload for `.zshrc`
autoload -U add-zsh-hook
load_zshrc() {
    source ~/.zshrc
}
add-zsh-hook precmd load_zshrc

# Configure `zoxide` Integration
eval "$(zoxide init zsh)"

# System Resource Monitoring
function system_status() {
    top -bn1 | head -20
}

# Command History Management
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# Advanced `fzf` Integration
export FZF_DEFAULT_OPTS='--height 40% --border --reverse'

# Setup `nvm` for Node.js Version Management
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Custom Grep and Find Commands
grep() {
    command grep --color=auto "$@"
}
find() {
    command find "$@" -type f
}

# Personalized Startup Tasks
echo "Checking for system updates..."
sudo pacman -Syu --noconfirm

