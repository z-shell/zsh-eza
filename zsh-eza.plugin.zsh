# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
typeset -gA Plugins
Plugins[ZSH_EZA]="${0:h}"

# https://wiki.zshell.dev/community/zsh_plugin_standard#functions-directory
if [[ $PMSPEC != *f* ]]; then
  fpath+=( "${0:h}/functions" )
fi

autoload -Uz .zsh-eza

# Load plugin
(( ${+functions[.zsh-eza]} )) && {
  .zsh-eza; (( $? )) && {
    return # Ran into an error
  }
}

