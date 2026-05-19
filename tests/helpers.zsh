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

run_zsh_eza_shell() {
  local script=$1
  local path_value=${2:-${ZSH_EZA_TEST_BIN}:${PATH}}
  local shell_path
  shell_path="$(command -v zsh)"

  run env \
    NO_COLOR=1 \
    TERM=xterm \
    PMSPEC='0fuUpiPsX' \
    PATH="${path_value}" \
    ZSH_EZA_REPO="${ZSH_EZA_REPO}" \
    ZSH_EZA_SCRIPT="${script}" \
    "${shell_path}" -fc 'eval "${ZSH_EZA_SCRIPT}"'
}
