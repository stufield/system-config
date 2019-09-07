# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/Library/TeX/texbin:$PATH

export ZSH=$HOME/.oh-my-zsh
umask 022

# ------------
# VIM
# ------------
export EDITOR=/usr/bin/vim
# Better searching in command mode
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1



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
plugins=(git vi-mode bundler rake textmate lighthouse zsh-autosuggestions)

#bindkey '^M' autosuggest-execute  # execute suggestion; Shift+Enter
bindkey '^ ' autosuggest-accept     # accept suggestion; Shift+Enter

# export MANPATH="/usr/local/man:$MANPATH"

# -----------------------------
# source oh-my-zsh now this 
# MUST come AFTER the plugins call
# -----------------------------
source $ZSH/oh-my-zsh.sh


# ---------------------------
# Z-shell history settings
# ---------------------------
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

# -------------
# R Variables
# -------------
#export JAVA_HOME=/usr/lib/jvm/java-9-oracle/bin/java
export R_SOMA_DEV=$HOME/bitbucket/
export R_LIBS_USER=$HOME/r_libs
export R_HISTSIZE=1000000
export LOCAL_UID=`id -u`
export PYTHONPATH=$HOME/scripts/modules
export JAVA_HOME=/usr/bin/java

# ------------------
# Oracle Variables
# ------------------
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

echo "\033[32m✔\033[0m Welcome to \033[31mZSH \033[33m... \033[34m$USER\033[0m"
