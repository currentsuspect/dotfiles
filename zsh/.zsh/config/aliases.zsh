#Aliases
alias zr='source ~/.zshrc'
alias editz='nvim ~/.zshrc'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias fcd='fzf_cd'
alias c='clear'
alias cls='clear'
alias ll='eza -alh --icons --color=auto'
alias la='eza -A --icons --color=auto'
alias l='ls -l --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias e='exit'
alias h='history'
alias top='htop'
alias ps='ps aux'
alias psg='ps aux | grep'
alias k='kill -9'
alias path='echo -e ${PATH//:/\\n}'
alias killall='killall -9'
alias md='mkdir -p'
alias rd='rmdir'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias vi='nvim'
alias vimdiff='vim -d'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gcl='git clone'
alias gco='git checkout'
alias gbr='git branch'
alias gup='git pull'
alias gdp='git diff'
alias gp='git push'
alias gl='git log'
alias gr='git remote -v'
alias gg='git'
alias gitdiff='git diff'
alias gitlog='git log --oneline --graph --decorate'
alias gitstatus='git status -sb'
alias gitclean='git clean -fd'
alias gitfetch='git fetch --all'
alias gitreset='git reset --hard'
alias gitpull='git pull --rebase'
alias gitpush='git push origin'

# Networking
alias ip='ip address'
alias ifconfig='ifconfig -a'
alias ping='ping -c 5'
alias ssh='ssh -o ControlMaster=auto -o ControlPersist=60m'
alias scp='scp -C'
alias netstat='netstat -tuln'
alias trace='traceroute'
alias wget='wget --continue --show-progress --retry-connrefused --waitretry=2 --timeout=30 --tries=3'

# System Monitoring
alias iostat='iostat -x 5'
alias vmstat='vmstat 5'
alias dmesg='dmesg | less'
alias df='df -h'
alias du='du -h --max-depth=1'
alias dus='du -sh * | sort -rh'
alias logs='journalctl -xe'

# Disk Operations
alias mount='mount -o loop'
alias umount='umount'
alias fsck='fsck -f'
alias blkid='blkid'

# Package Management (Arch-based)
alias up='sudo pacman -Syu'
alias in='sudo pacman -S'
alias rmv='sudo pacman -R'
alias srch='pacman -Ss'
alias pacman-info='pacman -Qi'
alias clean='sudo pacman -Sc'
alias update='sudo pacman -Syu'

# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstop='docker stop'
alias drm='docker rm'
alias di='docker images'
alias dexec='docker exec -it'
alias dbuild='docker build -t'
alias drun='docker run -it'

# Kubernetes
alias k='kubectl'
alias kget='kubectl get'
alias kdesc='kubectl describe'
alias kdel='kubectl delete'
alias kapply='kubectl apply -f'
alias klogs='kubectl logs'
alias kexec='kubectl exec -it'

# SSH
alias sshcopy='ssh-copy-id'
alias sshkeygen='ssh-keygen -t rsa'
alias sshconfig='nano ~/.ssh/config'
alias sshlist='ls ~/.ssh'

# File Operations
alias mkdir='mkdir -p'
alias touch='touch -c'
alias ln='ln -s'
alias tree='tree -C'

# Text Processing
alias sed='sed -i'
alias awk='awk'
alias cut='cut'
alias sort='sort'
alias uniq='uniq'

# Archiving
alias tar='tar -cvzf'
alias untar='tar -xvzf'
alias gz='gzip'
alias gunzip='gunzip'
alias bz2='bzip2'
alias bunzip2='bunzip2'

# Backup
alias backup='rsync -avz'
alias bkup='rsync -avz'
alias sync='rsync -av'

# Miscellaneous
alias weather='curl wttr.in'
alias dict='dict'
alias translate='trans -b'
alias btc='curl -s https://api.coindesk.com/v1/bpi/currentprice/BTC.json | jq .bpi.USD.rate'
alias btcprice='btc'
alias setgituser='git config --global user.name'
alias setgitemail='git config --global user.email'
alias hist='history | less'
alias hgrep='history | grep'
alias chmodx='chmod +x'
alias chownme='sudo chown $USER:$USER'
alias myip='curl ifconfig.me'
alias systeminfo='uname -a; lsb_release -a; df -h; free -h'
alias uptime='uptime -p'
alias packages='dpkg --list'
alias users='who'
alias uname='uname -a'
alias lsb='lsb_release -a'
alias date='date "+%Y-%m-%d %H:%M:%S"'
alias cal='cal -3'
alias whoami='whoami'
alias random='shuf -n 1'
alias gcc='gcc -Wall'
alias g++='g++ -Wall'
alias python='python3'
alias pip='pip3'
alias node='node'
alias npm='npm'
alias ruby='ruby'
alias gem='gem'
alias nano='nano -c'
alias emacs='emacs -nw'
alias tailf='tail -f'
alias serve='python3 -m http.server'
alias nvm='nvm use'
alias awscli='aws configure'
alias s3list='aws s3 ls'
alias s3sync='aws s3 sync'
alias venv='python3 -m venv'
# Ensure deactivate alias is removed to avoid conflicts
unalias deactivate 2>/dev/null

# Define the alias to activate the virtual environment
alias activate='source ~/venv/bin/activate'

alias dockerbuild='docker build -t'
alias dockerimages='docker images'
alias dockerrun='docker run -it'
alias kubectlget='kubectl get'
alias kubectldescribe='kubectl describe'
alias kubectlapply='kubectl apply -f'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown now'
alias hello='echo "Hi!"'
alias token='cd ~/accesstokens && cat dotfiles'
alias aliaszr='nvim ~/.zsh/config/aliases.zsh'
alias functionzr='nvim ~/.zsh/config/functions.zsh'
alias amkr='add_alias'
alias cdp='cd ~/Projects'
alias cdd='cd ~/Downloads'
alias archsearch='~/scripts/system/arch_wiki_search.sh'
alias deauth='sudo python3 ~/scripts/Hacking/deauth.py --deauth'
alias scan='sudo python3 ~/scripts/Hacking/deauth.py --scan'

alias reload='hyprctl reload'
