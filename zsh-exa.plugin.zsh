# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
#
# Copyright (c) 2022 Salvydas Lukosius
#
# Standardized $0 Handling
# https://z.digitalclouds.dev/community/zsh_plugin_standard/#zero-handling

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ ${zsh_loaded_plugins[-1]} != */zsh-exa && -z ${fpath[(r)${0:h}]} ]] {
  fpath+=( "${0:h}" )
}

set_params() {
  if ! (( $+commands[exa] )); then
    print "exa not found. Please install exa before using this plugin." >&2
    return 1
  else
    emulate -L zsh
    setopt extended_glob
    exa_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')

    alias ls='exa ${exa_params}'
    alias l='exa --git-ignore ${exa_params}'
    alias ll='exa --all --header --long ${exa_params}'
    alias llm='exa --all --header --long --sort=modified ${exa_params}'
    alias la='exa -lbhHigUmuSa'
    alias lx='exa -lbhHigUmuSa@'
    alias lt='exa --tree'
    alias tree='exa --tree'
  fi
}

auto-exa() {
  command exa ${exa_params}
}

# Variable to enable cd list directories. Value 0 is the default.
local enable_autocd=0
[[ "$AUTOCD" = <-> ]] && enable_autocd="$AUTOCD"

set_params
if [[ "$enable_autocd" = "1" ]]; then
  [[ ${chpwd_functions[(r)auto-exa]} == auto-exa ]] || chpwd_functions=( auto-exa $chpwd_functions )
fi
