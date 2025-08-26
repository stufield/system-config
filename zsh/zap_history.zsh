# Remove all variables coming from oh.my.zsh
# Allows all settings to set here
# Just to be double sure:
unset HISTFILE
unset HISTSIZE
unset SAVEHIST

unsetopt APPEND_HISTORY
unsetopt EXTENDED_HISTORY
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt HIST_IGNORE_DUPS # ignore duplication command history list
unsetopt HIST_IGNORE_SPACE
unsetopt HIST_VERIFY
unsetopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY    # share command history data

# now set things the way I want
SAVEHIST=1000000              # Number of entries
HISTSIZE=1000000
HISTFILE=$HOME/.bash_history  # File
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
                              # don’t execute the line directly
                              # instead, perform history expansion
                              # and reload the line into the editing buffer

sed -E 's/^: [0-9]+:[0-9]+;//' $BH | awk '!seen[$0]++' > tmp
mv -f tmp $BH
