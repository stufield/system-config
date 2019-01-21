# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/Library/TeX/texbin:$PATH

export ZSH=$HOME/.oh-my-zsh
export EDITOR=/usr/bin/vim
#export SVN_EDITOR=/usr/bin/vim
#export SVN_PATH=svn://kong.sladmin.com/svn-repository
umask 022

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="cobalt2"
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE="nerdfont-complete"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

export TERM="screen-256color"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode bundler rake textmate lighthouse)

# export MANPATH="/usr/local/man:$MANPATH"

###############################
# source oh-my-zsh now
# this MUST come AFTER the plugins call
###############################
source $ZSH/oh-my-zsh.sh


###############################
# Z-shell history settings
###############################
bindkey '^R' history-incremental-pattern-search-backward    # pattern match
#bindkey '^R' history-incremental-search-backward           # exact match
SAVEHIST=1000000              # Number of entries
HISTSIZE=1000000
HISTFILE=~/.bash_history      # File
BH=$HISTFILE
setopt APPEND_HISTORY         # Don't erase history
#setopt EXTENDED_HISTORY      # Add additional data to history like timestamp
unsetopt EXTENDED_HISTORY     # Don't add data to history -> compatible with .bash_history
setopt INC_APPEND_HISTORY     # Add immediately
setopt HIST_FIND_NO_DUPS      # Don't show duplicates in search
setopt HIST_SAVE_NO_DUPS      # Don't save duplicates in history
setopt HIST_IGNORE_SPACE      # Don't save lines with first character spaces.
setopt NO_HIST_BEEP           # Don't beep
setopt SHARE_HISTORY          # Share history between session/terminals
setopt HIST_EXPIRE_DUPS_FIRST # If entries must be culled from history, lose duplicates first
setopt HIST_VERIFY            # when entering line with history expansion,
                              # don’t execute the line directly; instead, perform history expansion 
                              # and reload the line into the editing buffer



##############
# R Variables
##############
#export JAVA_HOME=/usr/lib/jvm/java-9-oracle/bin/java
export R_SOMA_DEV=$HOME/bitbucket/
export R_LIBS_USER=$HOME/r_libs
export R_HISTSIZE=1000000
export LOCAL_UID=`id -u`
export PYTHONPATH=$HOME/scripts/modules
export JAVA_HOME=/usr/bin/java

####################
# Oracle Variables
####################
export LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib
export TNS_ADMIN=/usr/lib/oracle/12.2/client64
export ORACLE_HOME=/usr/lib/oracle/12.2/client64


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"


if [[ "$OSTYPE" == "linux"* ]]; then
	xrdb ~/.Xdefaults
fi

stty quit ""

source $HOME/.bash_functions

echo Welcome to ZSH $USER
