# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
#
# Copyright (c) 2022 Salvydas Lukosius
#
# Preserve caller state while resolving this sourced entrypoint.
() {
  builtin emulate -L zsh

  local -r source_path=${1:a}
  local -r plugin_dir=${source_path:h}

  typeset -g _zsh_eza_plugin_dir="$plugin_dir"

  # https://wiki.zshell.dev/community/zsh_plugin_standard#functions-directory
  typeset -g _zsh_eza_fpath="${plugin_dir}/functions"
  if [[ $PMSPEC != *f* ]]; then
    if (( ! ${fpath[(Ie)${_zsh_eza_fpath}]} )); then
      fpath+=( "${_zsh_eza_fpath}" )
    fi
  fi

  autoload -Uz +X _zsh_eza_init

  # Load plugin
  if (( ${+functions[_zsh_eza_init]} )); then
    () {
      local -i rc
      _zsh_eza_init
      rc=$?
      (( rc )) && print -u 2 -r -- "Error loading zsh-eza plugin, exit code: ${rc}"
      return "$rc"
    } || return $?
  fi

  # https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
  # Zi dispatches ${plugin}_plugin_unload using the literal plugin name, so the
  # hyphen is required for `zi unload z-shell/zsh-eza` to reach this function.
  # zsh-lint disable=plugin/function-namespace -- Zi dispatches ${plugin}_plugin_unload verbatim
  zsh-eza_plugin_unload() {
    builtin emulate -L zsh

    # Restore fpath
    local plugin_functions="${_zsh_eza_fpath:-${_zsh_eza_plugin_dir}/functions}"
    fpath=( "${fpath[@]:#${plugin_functions}}" )
    if (( ${+parameters[ZSH_EZA_FPATH]} )); then
      fpath=( "${fpath[@]:#${ZSH_EZA_FPATH}}" )
    fi

    autoload -Uz add-zsh-hook
    add-zsh-hook -d chpwd zsh-eza-auto-list 2>/dev/null
    add-zsh-hook -d chpwd _zsh_eza_auto_list 2>/dev/null
    unfunction zsh-eza-auto-list _zsh_eza_auto_list _zsh_eza_init .zsh-eza 2>/dev/null

    local alias_name
    local -a alias_names=( ls l ll llm la lx lt tree )
    if (( ${+parameters[_zsh_eza_alias_names]} )); then
      alias_names=( "${_zsh_eza_alias_names[@]}" )
    elif (( ${+parameters[ZSH_EZA_ALIAS_NAMES]} )); then
      alias_names=( "${ZSH_EZA_ALIAS_NAMES[@]}" )
    fi

    for alias_name in "${alias_names[@]}"; do
      # Ownership-aware restoration: restore only if still defined
      if (( ${+aliases[$alias_name]} )); then
        builtin unalias "${alias_name}" 2>/dev/null
      fi

      if (( ${+parameters[_zsh_eza_saved_aliases]} )) && (( ${+_zsh_eza_saved_aliases[$alias_name]} )); then
        aliases[$alias_name]="${_zsh_eza_saved_aliases[$alias_name]}"
      elif (( ${+parameters[ZSH_EZA_SAVED_ALIASES]} )) && (( ${+ZSH_EZA_SAVED_ALIASES[$alias_name]} )); then
        aliases[$alias_name]="${ZSH_EZA_SAVED_ALIASES[$alias_name]}"
      fi
    done

    unset eza_params _zsh_eza_params ZSH_EZA_ALIAS_NAMES _zsh_eza_alias_names \
          ZSH_EZA_SAVED_ALIASES _zsh_eza_saved_aliases ZSH_EZA_FPATH _zsh_eza_fpath \
          _zsh_eza_plugin_dir

    unfunction zsh-eza_plugin_unload
  }
} "${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
