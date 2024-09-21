# Path to your Oh My Zsh installation
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load
export ZSH_THEME="powerlevel10k/powerlevel10k"

# Path to powerlevel10k theme
source ~/.config/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

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

# Initialize zoxide
eval "$(zoxide init --cmd fcd zsh)"

# Source powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Source aliases
if [[ -f ~/.zsh/config/aliases.zsh ]]; then
    source ~/.zsh/config/aliases.zsh
else
    echo "Aliases file not found!"
fi

# Source functions
if [[ -f ~/.zsh/config/functions.zsh ]]; then
    source ~/.zsh/config/functions.zsh
else
    echo "Functions file not found!"
fi

# Zoxide intergration
eval "$(zoxide init zsh)"

# The Fuck integration
eval $(thefuck --alias)

# Syntax Highlighting Configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[default]='fg=green'

# Enhanced Prompt Customization
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

# History Management
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# Set up auto suggestions
ZSH_AUTOSUGGESTIONS_HIGHLIGHT_STYLE='fg=yellow'

# Improved Command-Line Editing
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

