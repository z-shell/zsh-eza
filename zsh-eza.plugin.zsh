# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
#
# Copyright (c) 2022 Salvydas Lukosius
#
# Zsh Plugin Standard
# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
typeset -gA Plugins
Plugins[ZSH_EZA]="${0:h}"

# https://wiki.zshell.dev/community/zsh_plugin_standard#funtions-directory
typeset -g ZSH_EZA_FPATH="${0:h}/functions"
if [[ $PMSPEC != *f* ]]; then
  fpath+=( "${ZSH_EZA_FPATH}" )
fi

autoload -Uz +X .zsh-eza

# Load plugin
(( ${+functions[.zsh-eza]} )) && {
  .zsh-eza
  typeset -i rc=$?
  (( rc )) && {
    print -u2 "Error loading zsh-eza plugin, exit code: ${rc}"
    return ${rc}
  }
}

# https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
zsh-eza_plugin_unload() {
  local alias_name

  fpath=("${fpath[@]:#${ZSH_EZA_FPATH}}")

  autoload -Uz add-zsh-hook
  add-zsh-hook -d chpwd zsh-eza-auto-list 2>/dev/null
  unfunction zsh-eza-auto-list 2>/dev/null
  unfunction .zsh-eza 2>/dev/null

  for alias_name in "${ZSH_EZA_ALIAS_NAMES[@]}"; do
    builtin unalias "${alias_name}" 2>/dev/null

    if (( ${+parameters[ZSH_EZA_SAVED_ALIASES]} )) && (( ${+ZSH_EZA_SAVED_ALIASES[$alias_name]} )); then
      aliases[$alias_name]="${ZSH_EZA_SAVED_ALIASES[$alias_name]}"
    fi
  done

  unset eza_params ZSH_EZA_ALIAS_NAMES ZSH_EZA_SAVED_ALIASES ZSH_EZA_FPATH rc 'Plugins[ZSH_EZA]'

  unfunction zsh-eza_plugin_unload
}
