# Load Oh-My-Zsh
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Set EDITOR and VISUAL Environment Variables
export EDITOR=nvim
export VISUAL=nvim

# To make it easy to run your scripts from anywhere
export PATH="$HOME/scripts:$PATH"

 # Start SSH agent and add SSH key
eval "$(ssh-agent -s)"  &>/dev/null
ssh-add ~/.ssh/id_ed25519 &>/dev/null


#source zinit to initialize Plugins
source /usr/share/zinit/zinit.zsh

# Set the theme
export ZSH_THEME="powerlevel10k/powerlevel10k"
source $HOME/.oh-my-zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

# Zinit plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma-continuum/fast-syntax-highlighting

# Source the aliases file
source $HOME/.zsh/config/aliases.zsh

# Source other configurations
source $HOME/.zsh/config/functions.zsh
#source $HOME/.zsh/config/envvars.zsh
#source $HOME/.zsh/config/keybindings.zsh
source $HOME/.zsh/config/completions.zsh
#source $HOME/.zsh/config/startup.zsh

# Initialize zoxide
eval "$(zoxide init --cmd fcd zsh)"

# Source powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# The Fuck integration
eval $(thefuck --alias)

# Custom fzf settings for better organization
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\.*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Command History Management
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# Advanced `fzf` Integration
export FZF_DEFAULT_OPTS='--height 40% --border --reverse'

setopt autocd
setopt correct
setopt extendedglob
setopt prompt_subst
setopt hist_ignore_dups

# Auto-completion settings
autoload -U compinit
compinit

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt hist_expire_dups_first
setopt hist_save_no_dups
setopt inc_append_history
setopt share_history
setopt no_nomatch
setopt interactive_comments
setopt no_beep
setopt auto_list
setopt correct_all
setopt menu_complete
setopt no_prompt_cr
setopt prompt_subst
setopt auto_resume
setopt always_to_end

