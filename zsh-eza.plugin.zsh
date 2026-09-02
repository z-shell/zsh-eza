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
    fpath=( "${fpath[@]:#${_zsh_eza_fpath:-${_zsh_eza_plugin_dir}/functions}}" )

    autoload -Uz add-zsh-hook
    add-zsh-hook -d chpwd _zsh_eza_auto_list 2>/dev/null
    unfunction _zsh_eza_auto_list _zsh_eza_init 2>/dev/null

    # Ownership-aware restoration: an alias the user changed after load is
    # theirs, so leave it alone. Only a value this plugin still owns is undone.
    local alias_name
    for alias_name in "${(k)_zsh_eza_installed_aliases[@]}"; do
      [[ ${aliases[$alias_name]-} == "${_zsh_eza_installed_aliases[$alias_name]}" ]] || continue

      if (( ${+_zsh_eza_saved_aliases[$alias_name]} )); then
        aliases[$alias_name]="${_zsh_eza_saved_aliases[$alias_name]}"
      else
        builtin unalias "${alias_name}" 2>/dev/null
      fi
    done

    unset _zsh_eza_params _zsh_eza_saved_aliases _zsh_eza_installed_aliases \
          _zsh_eza_fpath _zsh_eza_plugin_dir

    unfunction zsh-eza_plugin_unload
  }
} "${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
