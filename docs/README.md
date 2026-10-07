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

## Features

- Eight `eza`-backed aliases for common list, long-list, and tree views.
- Opinionated defaults for Git status, icons, groups, directory ordering,
  timestamps, and color scales.
- Complete replacement or extension of the default `eza` arguments.
- Optional automatic directory listing after `cd`.
- Safe startup failure when `eza` is unavailable.
- Reversible unload that restores aliases present before the plugin loaded.

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
zstyle ':zsh-eza:config' autocd yes
zi ice has'eza'
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

## Usage

After loading the plugin, use the aliases in your shell:

```zsh
ll          # Detailed listing, including hidden entries
llm         # Detailed listing sorted by modification time
lt          # Directory tree
```

Every alias includes your configured `eza` arguments.

### Aliases

| Alias        | Behavior                                      |
| :----------- | :-------------------------------------------- |
| `ls`         | List with your configured defaults.           |
| `l`          | Hide Git-ignored entries.                     |
| `ll`         | Detailed listing, including hidden entries.   |
| `llm`        | Detailed listing sorted by modification time. |
| `la`         | Extended long listing.                        |
| `lx`         | Extended listing with extended attributes.    |
| `lt`, `tree` | Directory tree.                               |

<details>
<summary>Listing examples</summary>

![Screenshot showing `ll`, `ls`, `lx`, and `la` directory-listing examples](https://user-images.githubusercontent.com/59910950/165784269-3a8a8bfe-f291-4a33-aac9-1afa2b7b767f.png)

</details>

<details>
<summary>Exact alias definitions</summary>

These definitions describe the plugin's installed aliases. `_zsh_eza_params` is private runtime state, populated from the styles documented below.

```zsh
alias ls='eza ${(@)_zsh_eza_params}'
alias l='eza --git-ignore ${(@)_zsh_eza_params}'
alias ll='eza --all --header --long ${(@)_zsh_eza_params}'
alias llm='eza --all --header --long --sort=modified ${(@)_zsh_eza_params}'
alias la='eza -lbhHigUmuSa ${(@)_zsh_eza_params}'
alias lx='eza -lbhHigUmuSa@ ${(@)_zsh_eza_params}'
alias lt='eza --tree ${(@)_zsh_eza_params}'
alias tree='eza --tree ${(@)_zsh_eza_params}'
```

</details>

## Configuration

Set styles in the `:zsh-eza:config` context **before loading the plugin**. With no configuration, listings use Git status, icons, groups, directories first, long ISO timestamps, and color scales.

### Add arguments

`extra-params` appends shell words to the selected arguments. It is unset by default.

```zsh
zstyle ':zsh-eza:config' extra-params '--classify --hyperlink=auto'
```

### Replace defaults

`user-params` replaces the complete default argument list. It is unset by default; an empty string clears the defaults. `extra-params` still appends after this replacement.

```zsh
zstyle ':zsh-eza:config' user-params '--group-directories-first --icons'
```

### List after changing directory

`autocd` is off by default. Set it to `yes` to list the new directory after `cd`:

```zsh
zstyle ':zsh-eza:config' autocd yes
zi light z-shell/zsh-eza
```

<details>
<summary>Default arguments</summary>

```text
--git --icons --group --group-directories-first
--time-style=long-iso --color-scale=all
```

</details>

### Migrating older configuration

> [!IMPORTANT]
> Replace `eza_user_params`, `eza_extra_params`, and `AUTOCD` with the `user-params`, `extra-params`, and `autocd` styles above. These global settings were removed; `_zsh_eza_params` is private state, not a configuration entry point.

## Lifecycle and side effects

- With `TERM=dumb`, the plugin returns successfully without defining aliases.
- If `eza` is missing, loading returns a nonzero status without exiting the
  current shell.
- Each load captures any existing aliases with the same names before
  replacement.
- With `autocd` set to a true value, the plugin registers `_zsh_eza_auto_list`
  as a `chpwd` hook.
- `zsh-eza_plugin_unload` removes the hook and plugin functions, removes
  plugin-owned state, and restores aliases captured by the most recent load.
  An alias changed after the plugin loaded is treated as user-owned and is
  left untouched.

## Documentation and support

- [Z-Shell plugin gallery](https://wiki.zshell.dev/community/gallery/collection/plugins#sc-z-shellzsh-eza)
- [Zsh Plugin Standard](https://wiki.zshell.dev/community/zsh_plugin_standard)
- [Zi plugin manager](https://github.com/z-shell/zi)
- [Zsh configuration styles](https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System-Configuration)
- [Report an issue](https://github.com/z-shell/zsh-eza/issues)

## Contributing and license

<details>
<summary>Verify a development checkout</summary>

### Verification

The tests use [ZUnit](https://github.com/z-shell/zunit) 0.8.2, which is not
shipped with the plugin. With `zunit` on `PATH`, from the repository root:

```bash
export ZSH_EZA_REPO="$PWD"
zunit --tap --verbose tests/zsh-eza.zunit
```

The suite uses a fake `eza` executable; a system installation is not required
for tests.

</details>

<details>
<summary>Development and release model</summary>

### Release model

`zsh-eza` is consumed directly from Git and uses trunk-based development on
`main`. Create `feature-<id>`, `bug-<id>`, or `hotfix-<id>` branches from
`main` and target pull requests back to `main`. Merges do not create a package
release.

</details>

Contributions follow the
[Z-Shell organization guidance](https://github.com/z-shell/.github).
This project is distributed under the terms in [LICENSE](../LICENSE).
