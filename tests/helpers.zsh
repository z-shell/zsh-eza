# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

make_fake_eza() {
  builtin emulate -L zsh

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

  # The script and PATH arrive in parameters, not as arguments: ZUnit's `run`
  # re-evaluates its arguments, which would expand the script too early.
  local term=$1
  local script=$_zsh_eza_test_script
  local path_value=$_zsh_eza_test_path
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

  typeset -g _zsh_eza_test_script=$1
  typeset -g _zsh_eza_test_path=${2:-${ZSH_EZA_TEST_BIN}:${PATH}}

  run _run_zsh_eza_isolated_shell xterm
}

run_zsh_eza_dumb_shell() {
  builtin emulate -L zsh

  typeset -g _zsh_eza_test_script=$1
  typeset -g _zsh_eza_test_path=${2:-${ZSH_EZA_TEST_BIN}:${PATH}}

  run _run_zsh_eza_isolated_shell dumb
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
    print -- \"plugin-dir=\${_zsh_eza_plugin_dir}\"
    source \"\${ZSH_EZA_REPO}/zsh-eza.plugin.zsh\"
    print -- \"resource-zero-preserved=\$([[ \$0 == \$caller_zero ]] && print yes || print no)\"
  "
}
