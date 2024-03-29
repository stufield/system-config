# ----------------------------------------------------
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
# ----------------------------------------------------
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#HISTCONTROL=ignoreboth
export LOCAL_UID=`id -u`
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export R_HISTSIZE=1000000
export HISTCONTROL=ignoreboth:erasedups   # no duplicate entries
shopt -s histappend                       # append history file; no overwrite
export PROMPT_COMMAND='history -a; echo -ne "\033]0; ${PWD}\007"'                  # update history & window title with path (title fucks with evince)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac



# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi


if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac



PS1="\[\e[35;1m\]\u@\h\[\e[34;1m\](\[\e[32;1m\]\[\e[36;1m\]\w/$\[\e[0m\]\[\e[34;1m\]): \[\e[0m\]"

set -o vi
umask o+rw

export EDITOR=/usr/bin/vim
export PYTHONPATH=$PYTHONPATH:.:/home/sfield/tools/python/modules:/usr/lib/python2.7/site-packages
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/11.1/client64/lib/:/opt/instantclient_11_1/:/usr/lib/R/lib/
#export JAVA_HOME=/usr

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


# Aliases
alias lt='ls -AFlrth'
alias ll='ls -AFlh'
alias lss='ls -ACF'
alias stack='dirs -v'
alias R='R --quiet'
alias Rv='R --vanilla'
alias cp='cp -i'           # are you sure y/n?
alias mv='mv -i'           # are you sure y/n?

# enable programmable completion features (you don't need to enable this, 
# if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

stty quit ""

source $HOME/.bash_functions

echo Welcome to BASH $USER
