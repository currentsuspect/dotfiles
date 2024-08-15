
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
    [[ -n "$aurhelper" ]] && $aurhelper -Syu
}

check_disk_usage() {
    local threshold=80
    local usage
    usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
    if (( usage > threshold )); then
        echo "Warning: Disk usage is at ${usage}%"
    else
        echo "Disk usage is at ${usage}%"
    fi
}

alias chdisk='check_disk_usage'

system_status() {
    echo "CPU and Memory Usage:"
    top -bn1 | head -20
}

goto_git_repo() {
    local repo_name="$1"
    local repo_path="$HOME/Projects/$repo_name"
    if [[ -d "$repo_path" ]]; then
        cd "$repo_path"
    else
        echo "Repository $repo_name does not exist in $HOME/Projects."
    fi
} 

fzf_cd() {
    local dir
    dir=$(find . -type d -not -path "*/\.*" | fzf +m) && cd "$dir"
}

last_command() {
    local status=$?
    echo "Last command exited with status $status: $(fc -ln -1)"
}

search_files() {
    local query="$1"
    fd "$query"
}

show_uptime() {
    uptime -p
}

battery_status() {
    upower -i $(upower -e | grep 'BAT') | grep -E 'state|percentage'
}

find_with_fzf() {
    local files
    files=$(find . -type f | fzf) && [ -n "$files" ] && nvim "$files"
}
alias ffind='find_with_fzf'

fzf_vim() {
    local file
    file=$(find . -type f | fzf) && [ -n "$file" ] && nvim "$file"
}
alias fvim='fzf_vim'

mkcd() {
    mkdir -p "$1" && cd "$1"
}

# New Functions

# Function to show free memory
show_free_mem() {
    free -m
}

# Function to show listening ports
list_ports() {
    sudo netstat -tulanp | grep LISTEN
}

# Function to view the last modified files
last_modified_files() {
    find . -type f -printf '%T+ %p\n' | sort -r | head -n 10
}

# Function to get public IP
get_public_ip() {
    curl -s ifconfig.me
}

# Function to view large files
find_large_files() {
    find . -type f -exec du -h {} + | sort -rh | head -n 10
}

# Function to create a Python virtual environment
mkvenv() {
    python3 -m venv "$1" && source "$1/bin/activate"
}

# Function to download a file with progress
download_with_progress() {
    wget --show-progress "$1"
}

# Function to integrate Ctrl+R with fzf
fzf_history_search() {
    local selected_command
    selected_command=$(fc -rl 1 | awk '{$1=""; print substr($0,2)}' | fzf --tac --no-sort +s --query="$LBUFFER" --height 40% --reverse --border --prompt 'History> ' --preview 'echo {}' --preview-window=down:3:wrap)
    if [[ -n $selected_command ]]; then
        LBUFFER="$selected_command"
    fi
    zle reset-prompt
}

# Create a widget from the function
zle -N fzf_history_search

# Bind Ctrl+R to the fzf history search function
bindkey '^R' fzf_history_search

# Function to create a new alias
create_alias() {
    local alias_name alias_command aliases_file="$HOME/.zsh/config/aliases.zsh"

    # Prompt for alias name and command
    echo "Enter alias name:"
    read -r alias_name
    echo "Enter command for alias '$alias_name':"
    read -r alias_command
    
    # Validate inputs
    if [[ -z $alias_name || -z $alias_command ]]; then
        echo "Error: Alias name and command cannot be empty."
        return 1
    fi

    # Check if the alias already exists
    if grep -q "^alias $alias_name=" "$aliases_file"; then
        echo "Error: Alias '$alias_name' already exists."
        return 1
    fi

    # Ensure the aliases directory exists and append the new alias
    mkdir -p "$(dirname "$aliases_file")"
    echo "alias $alias_name='$alias_command'" >> "$aliases_file"

    # Source the aliases file to update the current session
    source "$aliases_file"
    
    echo "Alias '$alias_name' added successfully."
}

# Add the function to your .zshrc or source it in the current session
alias add_alias='create_alias'

# Function to set a timer for x minutes
function timer() {
    local t=$1
    echo "Timer set for $t minutes."
    sleep "${t}m"
    notify-send "Timer" "Time's up!"
}

#function to display git information
function gitinfo() {
    echo "Branch: $(git branch --show-current)"
    echo "Last Commit: $(git log -1 --pretty=format:'%h - %s (%ci)')"
}

#Simple CLI Calculator
function calc() {
    echo "scale=2; $*" | bc
}

#Gets Your Local Ip
function localip() {
    ipconfig getifaddr en0
}

#Pings Google
function pingg() {
    ping -c 5 google.com
}

#Extracts Using all these to ensure its a possible Archive 
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#Previews Markdown Files In Terminal
function mdpreview() {
    glow "$1"
}

# Custom Greeting Message
print_greeting() {
    local current_date
    local username=$(whoami)
    
    # Colors

    current_date=$(command date +"%A, %B %d, %Y")  
    echo "Hello! $username"
    echo "Today is $current_date"
    echo ""
}

# Call the greeting function
print_greeting



