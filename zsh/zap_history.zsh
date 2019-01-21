# Remove all variables coming from oh.my.zsh
# Allows everything to be set in the .zshrc
# Just to be double sure:
unset HISTFILE
unset HISTSIZE
unset SAVEHIST
unsetopt append_history
unsetopt extended_history
unsetopt hist_expire_dups_first
unsetopt hist_ignore_dups # ignore duplication command history list
unsetopt hist_ignore_space
unsetopt hist_verify
unsetopt inc_append_history
unsetopt share_history # share command history data
