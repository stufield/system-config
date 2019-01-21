# fix for better tab completion at the command line

# Make tab-completion case-sensitive first for letters; then for ".", "_", or "-" partial completion
# http://stackoverflow.com/questions/24226685/have-zsh-return-case-insensitive-auto-complete-matches-but-prefer-exact-matches
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# On first tab, auto-select the first entry in the list
# https://github.com/robbyrussell/oh-my-zsh/issues/14
#zstyle ':completion:*:*:*:*:*' menu yes select
