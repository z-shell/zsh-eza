# AGENTS.md — z-shell/zsh-eza

AI agent orientation for this repository.
For org-level standards see [`z-shell/.github`](https://github.com/z-shell/.github).

## What this repo is

A Zsh plugin that replaces GNU `ls` aliases with [`eza`](https://github.com/eza-community/eza), a modern `ls` alternative. It is consumed directly from Git via Zi or any other Zsh plugin manager.

## Release model

**Class 3 — git-consumed source.** Do not add release automation.

- Development: `next` branch.
- Production: `main` branch.
- Releases: push a semver tag manually if a milestone needs marking.
- Reference: [org release runbook](https://github.com/z-shell/.github/blob/main/runbooks/release.md).

## Branching and commits

- All new work branches from `next`.
- Hotfixes branch from `main`.
- Commit format: [Conventional Commits](https://www.conventionalcommits.org/) — see [decision 0003](https://github.com/z-shell/.github/blob/main/decisions/0003-conventional-commits.md).
- **Never** include a `Co-authored-by` trailer (enforced by CI).

## Plugin structure

| Path                  | Purpose                                                                      |
| --------------------- | ---------------------------------------------------------------------------- |
| `zsh-eza.plugin.zsh`  | Entry point sourced by plugin manager                                        |
| `functions/.zsh-eza`  | Plugin logic: guards, params, aliases, AUTOCD hook                           |
| `tests/zsh-eza.zunit` | ZUnit test suite                                                             |
| `tests/helpers.zsh`   | Test helpers: `make_fake_eza`, `run_zsh_eza_shell`, `run_zsh_eza_dumb_shell` |
| `tests/setup.zsh`     | ZUnit setup/teardown: tmp dir lifecycle                                      |
| `docs/README.md`      | User-facing documentation                                                    |

Plugin follows the [Z-Shell Plugin Standard](https://wiki.zshell.dev/community/zsh_plugin_standard):

- ZERO-handling `$0` resolution.
- `Plugins[ZSH_EZA]` registration.
- `PMSPEC`-aware fpath guard.
- `zsh-eza_plugin_unload` reverses all side effects.

## Public API

| Variable           | Effect                                                           |
| ------------------ | ---------------------------------------------------------------- |
| `eza_user_params`  | Replaces the default `eza_params` array entirely                 |
| `eza_extra_params` | Appended to `eza_params`                                         |
| `AUTOCD=1`         | Registers a `chpwd` hook that lists the new directory after `cd` |

## Running tests

```bash
# From the repo root — ZUnit must be in PATH (see .github/workflows/test-native.yml for install steps)
export ZSH_EZA_REPO="$PWD"
PATH="$PWD/bin:$PATH" zunit --tap --verbose tests/zsh-eza.zunit
```

All tests use a fake `eza` stub. No real `eza` binary required.

## Key org cross-references

- [PATTERNS.md](https://github.com/z-shell/.github/blob/main/PATTERNS.md) — plugin entry-point idioms, fpath guard forms, unload contract
- [z-shell/zsh-fancy-completions](https://github.com/z-shell/zsh-fancy-completions) — sibling plugin; use as consistency reference
- [z-shell/zunit](https://github.com/z-shell/zunit) — test runner used by this repo
- [Linear Tracker](https://linear.app/ss-o/) — track non-trivial deferred work here, not in local notes

## Before starting non-trivial work

1. Check open issues and PRs in this repo.
2. Check the Linear Tracker for related items.
3. Leave an `Agent handoff` comment on the relevant issue when work is unfinished or blocked.
