# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

make_fake_eza() {
  cat > "${ZSH_EZA_TEST_BIN}/eza" <<'EOF'
#!/usr/bin/env sh
printf 'fake-eza'
for arg in "$@"; do
  printf ' [%s]' "$arg"
done
printf '\n'
EOF

  chmod u+x "${ZSH_EZA_TEST_BIN}/eza"
}

_run_zsh_eza_isolated_shell() {
  builtin emulate -L zsh

  local term=$1
  local script=$2
  local path_value=$3
  local shell_path
  shell_path="$(command -v zsh)"

  if [[ -z $shell_path ]]; then
    print -u2 -- 'zsh-eza test helper: zsh not found on PATH'
    return 127
  fi

  command env -i \
    HOME="${ZSH_EZA_TEST_ROOT}/home" \
    ZDOTDIR="${ZSH_EZA_TEST_ROOT}/zdotdir" \
    NO_COLOR=1 \
    TERM="${term}" \
    PMSPEC='0uUpiPsX' \
    PATH="${path_value}" \
    ZSH_EZA_REPO="${ZSH_EZA_REPO}" \
    ZSH_EZA_SCRIPT="${script}" \
    "${shell_path}" -fc 'eval "${ZSH_EZA_SCRIPT}"'
}

run_zsh_eza_shell() {
  builtin emulate -L zsh

  local script=$1
  local path_value=${2:-${ZSH_EZA_TEST_BIN}:${PATH}}

  run _run_zsh_eza_isolated_shell xterm "${script}" "${path_value}"
}

run_zsh_eza_dumb_shell() {
  builtin emulate -L zsh

  local script=$1
  local path_value=${2:-${ZSH_EZA_TEST_BIN}:${PATH}}

  run _run_zsh_eza_isolated_shell dumb "${script}" "${path_value}"
}
