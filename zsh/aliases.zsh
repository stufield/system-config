# Add yourself some shortcuts to projects you often work on

# ls
alias l="ls -lAh"
alias ll='ls -lAh'
alias lt='ls -lArth'
alias lss='ls -aCF'

# R
alias R='R --quiet --no-save --no-restore-data'
alias Rv='R --vanilla'
alias Rs='Rscript --vanilla'
alias RCMD='R --vanilla CMD'

# basic
alias broken_syms='find $1 -type l -xtype l'
alias bashvi='vim ~/.bash_functions'
alias bashreload='source ~/.bash_functions'
alias cp='cp -i'				  # ask are you sure y/n?
alias mv='mv -i'				  # ask are you sure y/n?
alias trash='gvfs-trash'  # safer rm to ~/.local/share/Trash/files
alias dush='du -sh'
alias ds='dirs -v'

# zsh
alias zshconfig='vi ~/.zshrc'
alias zshreload='source ~/.zshrc'

# misc
alias vinowrap="vi -c 'set nowrap'"

#dockers
#alias containerclean="docker ps -a -q | xargs docker rm"
#alias imageclean="docker images --filter dangling=true -q | xargs docker rmi"
#alias dmenv='eval "$(docker-machine env dev)"'

#alias showhidden="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
#alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"

#alias k=kubectl
#alias g=gcloud
#alias dm=docker-machine
#alias d=docker
#alias dev=switch-env development
#alias sand=switch-env sandbox
#alias prod=switch-env production
#alias gosrc="cd ~/code/go/src/github.com/unacast"

# scrappys
#alias current-cluster=uc-current-cluster
#alias current-env=uc-current-env
#alias kube-auth=uc-kube-auth
#alias list-clusters=uc-list-clusters
#alias list-db-instances=uc-list-db-instances
#alias list-instances=uc-list-instances
#alias switch-env=uc-switch-env
