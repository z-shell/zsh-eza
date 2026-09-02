# AGENTS.md — z-shell/zsh-eza

AI agent orientation for this repository.
For org-level standards see [`z-shell/.github`](https://github.com/z-shell/.github).

## What this repo is

A Zsh plugin that replaces GNU `ls` aliases with [`eza`](https://github.com/eza-community/eza), a modern `ls` alternative. It is consumed directly from Git via Zi or any other Zsh plugin manager.

## Release model

**Class 3 - git-consumed source.** Do not add release automation.

- Development and stable consumable branch: `main`.
- Releases: push a semver tag manually if a milestone needs marking.
- Reference: [org release runbook](https://github.com/z-shell/.github/blob/main/runbooks/release.md).

## Branching and commits

- All work branches from `main`, and pull requests target `main`.
- Use `feature-<id>`, `bug-<id>`, or `hotfix-<id>` branch names.
- Commit format: [Conventional Commits](https://www.conventionalcommits.org/); see [decision 0003](https://github.com/z-shell/.github/blob/main/decisions/0003-conventional-commits.md).
- Branch model: [decision 0019](https://github.com/z-shell/.github/blob/main/decisions/0019-trunk-on-main-default.md).
- A `Co-authored-by` trailer may credit a real human, including the pull-request
  author. Never credit a bot, AI agent, or automation as a co-author. Do not
  claim CI enforcement unless a current repository caller or ruleset proves it.

## Plugin structure

| Path                      | Purpose                                                                      |
| ------------------------- | ---------------------------------------------------------------------------- |
| `zsh-eza.plugin.zsh`      | Entry point sourced by plugin manager                                        |
| `functions/_zsh_eza_init` | Plugin logic: guards, params, aliases, autocd hook                           |
| `tests/zsh-eza.zunit`     | ZUnit test suite                                                             |
| `tests/helpers.zsh`       | Test helpers: `make_fake_eza`, `run_zsh_eza_shell`, `run_zsh_eza_dumb_shell` |
| `tests/setup.zsh`         | ZUnit setup/teardown: tmp dir lifecycle                                      |
| `docs/README.md`          | User-facing documentation                                                    |

Review the plugin against the
[Z-Shell Plugin Standard](https://wiki.zshell.dev/community/zsh_plugin_standard),
while keeping portable behavior separate from optional manager profiles:

- Portable loading accepts a manager-supplied `ZERO` and retains a direct-source
  fallback. For self-location changes, follow the current organization Zsh
  instruction and do not copy retired entry-point snippets from `PATTERNS.md`.
- `PMSPEC` `f` capability guard is an optional manager integration, not a
  portable requirement or Zsh semantics. Direct sourcing must continue to work
  without manager-provided state.
- The repository declares an unload contract through `zsh-eza_plugin_unload`,
  which reverses plugin-owned side effects.

## Public API

All public configuration goes through the `:zsh-eza:config` `zstyle` context.

| Style          | Effect                                                           |
| -------------- | ---------------------------------------------------------------- |
| `user-params`  | Replaces the default `_zsh_eza_params` array entirely            |
| `extra-params` | Appended to `_zsh_eza_params`                                    |
| `autocd`       | Registers a `chpwd` hook that lists the new directory after `cd` |

`_zsh_eza_params`, `_zsh_eza_saved_aliases`, `_zsh_eza_installed_aliases`,
`_zsh_eza_fpath` and `_zsh_eza_plugin_dir` are private runtime state.

## Running tests

```bash
# From the repo root — ZUnit must be in PATH (see .github/workflows/test-native.yml for install steps)
export ZSH_EZA_REPO="$PWD"
PATH="$PWD/bin:$PATH" zunit --tap --verbose tests/zsh-eza.zunit
```

All tests use a fake `eza` stub. No real `eza` binary required.

## Key org cross-references

- [PATTERNS.md](https://github.com/z-shell/.github/blob/main/PATTERNS.md) -
  retired entry-point examples and established cross-repository idioms; do not
  copy retired snippets
- [z-shell/zsh-fancy-completions](https://github.com/z-shell/zsh-fancy-completions) — sibling plugin; use as consistency reference
- [z-shell/zunit](https://github.com/z-shell/zunit) — test runner used by this repo
- [GitHub issues](https://github.com/z-shell/zsh-eza/issues) and
  [pull requests](https://github.com/z-shell/zsh-eza/pulls) - authoritative
  records for active, blocked, and deferred work

## Before starting non-trivial work

1. Check open issues and PRs in this repo.
2. Treat any Project 28 item or Linear mirror only as a view of the owning
   GitHub issue or pull request, not as a separate authority.
3. Leave an `Agent handoff` comment on the relevant issue when work is unfinished or blocked.
