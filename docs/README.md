<div align="center">
  <a href="https://github.com/z-shell/zsh-eza">
    <img
      src="https://raw.githubusercontent.com/z-shell/zi/main/docs/images/logo.svg"
      alt="Z-Shell logo"
      width="72"
      height="72"
    />
  </a>

  <h1>Zsh eza</h1>
  <p>
    Zsh aliases and directory-listing behavior powered by
    <a href="https://github.com/eza-community/eza">eza</a>.
  </p>
  <p>
    <a href="https://github.com/z-shell/zsh-eza/actions/workflows/test-native.yml">
      <img
        src="https://github.com/z-shell/zsh-eza/actions/workflows/test-native.yml/badge.svg?branch=main"
        alt="ZUnit status"
      />
    </a>
    <a href="https://github.com/z-shell/zsh-eza/actions/workflows/trunk-check.yml">
      <img
        src="https://github.com/z-shell/zsh-eza/actions/workflows/trunk-check.yml/badge.svg?branch=main"
        alt="Trunk Code Quality status"
      />
    </a>
    <a href="../LICENSE">
      <img
        src="https://img.shields.io/github/license/z-shell/zsh-eza"
        alt="License"
      />
    </a>
  </p>
</div>

![Screenshot showing `ll`, `ls`, `lx`, and `la` directory-listing examples](https://user-images.githubusercontent.com/59910950/165784269-3a8a8bfe-f291-4a33-aac9-1afa2b7b767f.png)

> Screenshot is manually maintained pending Linear ZSH-18.

## Features

- Eight `eza`-backed aliases for common list, long-list, and tree views.
- Opinionated defaults for Git status, icons, groups, directory ordering,
  timestamps, and color scales.
- Complete replacement or extension of the default `eza` arguments.
- Optional automatic directory listing after `cd`.
- Safe startup failure when `eza` is unavailable.
- Reversible unload that restores aliases captured by the most recent load.

## Requirements

- Zsh
- [`eza`](https://github.com/eza-community/eza) available on `PATH`

Use the upstream
[`eza` installation guide](https://github.com/eza-community/eza/blob/main/INSTALL.md)
to install the executable for your platform.

## Installation

### Zi

```zsh
zi light z-shell/zsh-eza
```

To load only when `eza` exists and enable automatic listing after directory
changes:

```zsh
zi ice has'eza' atinit'AUTOCD=1'
zi light z-shell/zsh-eza
```

### Other plugin managers

The plugin follows the
[Zsh Plugin Standard](https://wiki.zshell.dev/community/zsh_plugin_standard)
and can be sourced by other Zsh plugin managers.

<details>
<summary>Oh My Zsh custom plugin</summary>

```sh
git clone https://github.com/z-shell/zsh-eza \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-eza"
```

Add `zsh-eza` to the plugin list:

```zsh
plugins=(... zsh-eza)
```

</details>

<details>
<summary>Zplug</summary>

```zsh
zplug "z-shell/zsh-eza"
```

</details>

<details>
<summary>Antigen</summary>

```zsh
antigen bundle z-shell/zsh-eza@main
```

</details>

## Configuration

Set configuration before loading the plugin.

| Variable           | Type        | Default | Effect                                           |
| ------------------ | ----------- | ------- | ------------------------------------------------ |
| `eza_user_params`  | Shell words | Unset   | Replaces the complete default argument list.     |
| `eza_extra_params` | Shell words | Unset   | Appends arguments after the selected defaults.   |
| `AUTOCD`           | Integer     | `0`     | Set to `1` to list the new directory after `cd`. |

The default arguments are:

```zsh
eza_params=(
  '--git' '--icons' '--group' '--group-directories-first'
  '--time-style=long-iso' '--color-scale=all'
)
```

For example:

```zsh
eza_extra_params='--classify --hyperlink=auto'
zi light z-shell/zsh-eza
```

## Aliases

| Alias  | Effective command                                            | Purpose                                                 |
| ------ | ------------------------------------------------------------ | ------------------------------------------------------- |
| `ls`   | `eza ${(@)eza_params}`                                       | List with the configured defaults.                      |
| `l`    | `eza --git-ignore ${(@)eza_params}`                          | Hide Git-ignored entries.                               |
| `ll`   | `eza --all --header --long ${(@)eza_params}`                 | Show a detailed list including hidden entries.          |
| `llm`  | `eza --all --header --long --sort=modified ${(@)eza_params}` | Show a detailed list sorted by modification time.       |
| `la`   | `eza -lbhHigUmuSa`                                           | Show an extended long listing.                          |
| `lx`   | `eza -lbhHigUmuSa@`                                          | Show an extended long listing with extended attributes. |
| `lt`   | `eza --tree ${(@)eza_params}`                                | Display a directory tree.                               |
| `tree` | `eza --tree ${(@)eza_params}`                                | Display a directory tree.                               |

## Lifecycle and side effects

- With `TERM=dumb`, the plugin returns successfully without defining aliases.
- If `eza` is missing, loading returns a nonzero status without exiting the
  current shell.
- Each load captures any existing aliases with the same names before
  replacement.
- With `AUTOCD=1`, the plugin registers a `chpwd` hook that lists the new
  directory after `cd`.
- `zsh-eza_plugin_unload` removes that hook and plugin functions, unsets
  plugin-owned state, and restores the aliases captured by the most recent
  load.

## Verification

The repository includes its ZUnit runner. From the repository root:

```bash
export ZSH_EZA_REPO="$PWD"
PATH="$PWD/bin:$PATH" zunit --tap --verbose tests/zsh-eza.zunit
```

The suite uses a fake `eza` executable; a system installation is not required
for tests.

## Documentation and support

- [Z-Shell plugin gallery](https://wiki.zshell.dev/community/gallery/collection/plugins#sc-z-shellzsh-eza)
- [Zsh Plugin Standard](https://wiki.zshell.dev/community/zsh_plugin_standard)
- [Report an issue](https://github.com/z-shell/zsh-eza/issues)

## Release model

`zsh-eza` is consumed directly from Git. `main` is the stable branch and `next`
is the development branch. Maintainers may create semantic version tags to mark
milestones, but merges do not create a package release.

## Contributing and license

Contributions follow the
[Z-Shell organization guidance](https://github.com/z-shell/.github).
This project is distributed under the terms in [LICENSE](../LICENSE).
