# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

setup() {
  local setup_file="${(%):-%x}"
  setup_file="${setup_file:A}"

  export ZSH_EZA_REPO="${ZSH_EZA_REPO:-${setup_file:h:h}}"
  export ZSH_EZA_TEST_ROOT="${TMPDIR:-/tmp}/zsh-eza-zunit"
  export ZSH_EZA_TEST_BIN="${ZSH_EZA_TEST_ROOT}/bin"
  export ZSH_EZA_TEST_EMPTY_PATH="${ZSH_EZA_TEST_ROOT}/empty-bin"

  rm -rf "${ZSH_EZA_TEST_ROOT:?}"
  mkdir -p "${ZSH_EZA_TEST_BIN}" "${ZSH_EZA_TEST_EMPTY_PATH}"
}

teardown() {
  rm -rf "${ZSH_EZA_TEST_ROOT:?}"
}
