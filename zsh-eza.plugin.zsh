# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
#
# Copyright (c) 2022 Salvydas Lukosius
#
# Preserve caller state while resolving this sourced entrypoint.
() {
  builtin emulate -L zsh

  typeset -r source_path="${${(M)1:#/*}:-$PWD/$1}"
  typeset -r plugin_dir=${source_path:h}

# https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
typeset -gA Plugins
Plugins[ZSH_EZA]="$plugin_dir"

# https://wiki.zshell.dev/community/zsh_plugin_standard#funtions-directory
typeset -g ZSH_EZA_FPATH="${plugin_dir}/functions"
if [[ $PMSPEC != *f* ]]; then
  fpath+=( "${ZSH_EZA_FPATH}" )
fi

autoload -Uz +X .zsh-eza

# Load plugin
(( ${+functions[.zsh-eza]} )) && {
  () {
    local -i rc
    .zsh-eza
    rc=$?
    (( rc )) && print -u2 "Error loading zsh-eza plugin, exit code: ${rc}"
    return "$rc"
  } || return $?
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

  unset eza_params ZSH_EZA_ALIAS_NAMES ZSH_EZA_SAVED_ALIASES ZSH_EZA_FPATH 'Plugins[ZSH_EZA]'

  unfunction zsh-eza_plugin_unload
}
} "${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
