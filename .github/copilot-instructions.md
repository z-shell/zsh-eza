# Copilot instructions — z-shell/zsh-eza

This is a Zsh plugin that replaces GNU `ls` aliases with [`eza`](https://github.com/eza-community/eza).
It follows the [Z-Shell Plugin Standard](https://wiki.zshell.dev/community/zsh_plugin_standard) and
the org-wide patterns in [z-shell/.github/PATTERNS.md](https://github.com/z-shell/.github/blob/main/PATTERNS.md).

## Plugin entry point

`zsh-eza.plugin.zsh` is the entry point sourced by the plugin manager. It:

1. Resolves `$0` to an absolute path (ZERO-handling pattern).
2. Registers `Plugins[ZSH_EZA]` with the plugin's directory.
3. Guards `fpath` addition with `if [[ $PMSPEC != *f* ]]` (Zi-aware form — preferred for this repo).
4. Autoloads `functions/.zsh-eza` with `autoload -Uz +X`.
5. Calls `.zsh-eza` and propagates non-zero exit without killing the shell (`return`, never `exit`).
6. Provides `zsh-eza_plugin_unload` that fully reverses all side effects.

## Implementation file

`functions/.zsh-eza` contains the actual logic. Key rules:

- Use `builtin alias` when setting aliases to avoid user-defined alias shadowing.
- Expand array params with `${(@)eza_params}`, not `$eza_params`, to preserve word boundaries.
- Use `add-zsh-hook` (not direct `chpwd_functions` manipulation) to register the AUTOCD hook.
- Early-return guards: `TERM=dumb` → `return 0`; missing `eza` binary → `print -u2 …; return 1`.

## Public API

| Variable           | Type              | Effect                                                               |
| ------------------ | ----------------- | -------------------------------------------------------------------- |
| `eza_user_params`  | scalar or array   | Replaces the built-in default `eza_params` array entirely            |
| `eza_extra_params` | scalar or array   | Appended to `eza_params` after defaults (or after `eza_user_params`) |
| `AUTOCD`           | integer (`0`/`1`) | Set to `1` before loading to register an auto-list hook on `cd`      |

## Coding conventions

- 2-space indent, LF endings, UTF-8.
- Every `.zsh` file starts with the standard modeline:
  ```
  # -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
  # vim: ft=zsh sw=2 ts=2 et
  ```
- Use `print -u2` for error output (stderr), not `echo >&2`.
- No `exit` inside plugin files — use `return`.

## Tests

Test runner: [ZUnit](https://github.com/z-shell/zunit) (see `tests/zsh-eza.zunit`).

```bash
export ZSH_EZA_REPO="$PWD"
PATH="$PWD/bin:$PATH" zunit --tap --verbose tests/zsh-eza.zunit
```

All tests use a fake `eza` stub via `make_fake_eza` in `tests/helpers.zsh`. No real `eza` binary required.

## Branching

- `next` — development branch; all work goes here.
- `main` — production branch; merge from `next` when ready.
- Hotfixes branch from `main`.
- Commit format: [Conventional Commits](https://www.conventionalcommits.org/).
- This repo is **Class 3 (git-consumed)** per the [org release runbook](https://github.com/z-shell/.github/blob/main/runbooks/release.md) — no release automation.

## Consistency references

- Sibling plugin: [`z-shell/zsh-fancy-completions`](https://github.com/z-shell/zsh-fancy-completions)
- Org patterns: [`z-shell/.github/PATTERNS.md`](https://github.com/z-shell/.github/blob/main/PATTERNS.md)
