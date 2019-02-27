#############################################################
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
#############################################################
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#HISTCONTROL=ignoreboth
export LOCAL_UID=`id -u`
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export R_HISTSIZE=1000000
export R_LIBS_USER=/home/sfield/Apps/R/library
export R_SomaDev=/home/sfield/SomaPackages/
export HISTCONTROL=ignoreboth:erasedups   # no duplicate entries
shopt -s histappend                       # append history file; no overwrite
export PROMPT_COMMAND='history -a; echo -ne "\033]0; ${PWD}\007"'                  # update history & window title with path (title fucks with evince)
#export PROMPT_COMMAND='history -a; history -n; echo -ne "\033]0; ${PWD}\007"'		# update histfile after every command

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
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




# uncomment for a colored prompt, if the terminal has the capability; turned
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



PS1="\[\e[35;1m\]\u@\h\[\e[34;1m\](\[\e[32;1m\]f~\$(/bin/ls | /usr/bin/wc -l | /bin/sed 's: ::g'):h~\$(/bin/ls -A | /bin/grep ^[.] | /usr/bin/wc -l)|\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b|j:\j\[\e[34;1m\])
\[\e[36;1m\]\w/$ \[\e[0m\]"

set -o vi

export PYTHONPATH=$PYTHONPATH:.:/home/sfield/tools/python/modules:/usr/lib/python2.7/site-packages
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/11.1/client64/lib/:/opt/instantclient_11_1/:/usr/lib/R/lib/
export PATH=~/bin:$PATH:/usr/lib/unity
export EDITOR=/usr/bin/vim
#export SVN_EDITOR=/usr/bin/vim
#export SVN_PATH=svn://kong.sladmin.com/svn-repository
#export JAVA_HOME=/usr
umask 022



# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


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


# some more aliases:
alias lt='ls -AFlrth'
alias ll='ls -AFlh'
alias lss='ls -ACF'
alias stack='dirs -v'
alias R='R --quiet'
alias Rv='R --vanilla'
alias Rs='Rscript --vanilla'
alias cp='cp -i'				# ask are you sure y/n?
alias mv='mv -i'				# ask are you sure y/n?
alias trash='gvfs-trash'   # safer rm to ~/.local/share/Trash/files
alias vinowrap="vi -c 'set nowrap'"
alias email='sendemail -s pine -bcc sfield@somalogic.com -f sfield@somalogic.com -t '

# enable programmable completion features (you don't need to enable this, 
# if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#xmodmap ~/.Xmodmap

xrdb ~/.Xdefaults
stty quit ""

source $HOME/.bash_functions

echo Welcome to BASH Linux, $USER