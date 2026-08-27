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

run_zsh_eza_entrypoint_state() {
  builtin emulate -L zsh

  local option_mode=$1
  local source_mode=$2
  local option_command source_command

  case $option_mode in
    default) option_command=: ;;
    no_function_argzero) option_command='unsetopt function_argzero' ;;
    posix_argzero) option_command='setopt posix_argzero' ;;
    *) return 2 ;;
  esac

  if [[ $source_mode == manager_zero ]]; then
    source_command='ZERO=${ZSH_EZA_REPO}/zsh-eza.plugin.zsh'
  else
    source_command='unset ZERO'
  fi

  run_zsh_eza_shell "
    ${option_command}
    ${source_command}
    caller_zero=\$0
    source \"\${ZSH_EZA_REPO}/zsh-eza.plugin.zsh\"
    rc=\$?
    print -- \"mode=${option_mode}/${source_mode}\"
    print -- \"rc=\${rc}\"
    print -- \"caller-zero-preserved=\$([[ \$0 == \$caller_zero ]] && print yes || print no)\"
    print -- \"plugin-dir=\${Plugins[ZSH_EZA]}\"
    source \"\${ZSH_EZA_REPO}/zsh-eza.plugin.zsh\"
    print -- \"resource-zero-preserved=\$([[ \$0 == \$caller_zero ]] && print yes || print no)\"
  "
}
