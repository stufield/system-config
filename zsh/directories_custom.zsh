# Change directory pushd and "cd" behavior
# -----------------------------------------
setopt pushdsilent    # Omit printing directory stack
setopt pushdminus     # Invert meanings of +N and -N arguments to pushd

# reverse the pushd behavior of cd
# don't push the old directory into the stack
#unsetopt autopushd

