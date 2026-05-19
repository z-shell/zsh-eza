<div align="center">
  <table style="width:100%;height:auto">
    <tr><td align="center">
  <h1>
   <a title="❮ Zsh eza ❯" target="_self" href="https://github.com/z-shell/zsh-eza">
  <img style="width:60px;height:60px"
    src="https://raw.githubusercontent.com/z-shell/zi/main/docs/images/logo.svg"
    alt="Logo" /></a>❮ Zsh eza ❯
  </h1>
  <h2>
  Zsh plugin that replaces GNU <code>ls</code> aliases with <a target="_self" href="https://github.com/eza-community/eza">eza-community/eza</a>
  </h2>
<h3>
  <a href="https://github.com/orgs/z-shell/discussions/">《❔》Ask a Question </a>
  <a href="https://wiki.zshell.dev/search/">《💡》Search Wiki </a>
  <a href="https://github.com/z-shell/community/issues/new?assignees=&labels=%F0%9F%91%A5+member&template=membership.yml&title=team%3A+">《💜》Join </a>
  <a href="https://digitalclouds.crowdin.com/z-shell/">《🌐》Localize </a>
</h3></td></tr>
<tr>
<td align="center">
  <a target="_self" href="https://github.com/z-shell/zsh-eza/actions/workflows/trunk-check.yml">
    <img align="center" src="https://github.com/z-shell/zsh-eza/actions/workflows/trunk-check.yml/badge.svg?branch=main" alt="⭕ Trunk Check" />
  </a>
  <a target="_self" href="https://open.vscode.dev/z-shell/zsh-eza/">
    <img
      align="center"
      src="https://img.shields.io/badge/--007ACC?logo=visual%20studio%20code&logoColor=ffffff"
      alt="Visual Studio Code"
    />
  </a>
</td>
</tr>
<tr><td><img align="center" style="width:100%;height:auto" src="https://user-images.githubusercontent.com/59910950/165784269-3a8a8bfe-f291-4a33-aac9-1afa2b7b767f.png" alt="zsh-eza screenshot" />
</td></tr></table></div>

## Default settings

The plugin configures `ls`-style aliases for `eza`. Set `AUTOCD=1` before loading it to list directories automatically after `cd`.

If `eza` is missing, the plugin prints an error and returns without terminating the current Zsh session.

### Variables

| Variable           | Description                                                    | Default |
| ------------------ | -------------------------------------------------------------- | ------- |
| `eza_user_params`  | Replace the default `eza` argument list.                       | unset   |
| `eza_extra_params` | Append additional `eza` arguments after the defaults.          | unset   |
| `AUTOCD`           | Enable automatic directory listing after `cd` when set to `1`. | `0`     |

### Default parameters

```zsh
eza_params=(
  '--git' '--icons' '--group' '--group-directories-first'
  '--time-style=long-iso' '--color-scale=all'
)
```

### Aliases

```zsh
alias ls='eza ${(@)eza_params}'
alias l='eza --git-ignore ${(@)eza_params}'
alias ll='eza --all --header --long ${(@)eza_params}'
alias llm='eza --all --header --long --sort=modified ${(@)eza_params}'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree ${(@)eza_params}'
alias tree='eza --tree ${(@)eza_params}'
```

## Install

The `eza` should be present to use this plugin. Install `eza` with Zi:

```zi
zi ice from'gh-r' as'program' sbin'**/eza -> eza' atclone'cp -vf completions/eza.zsh _eza'
zi light eza-community/eza
```

### With [Zi](https://github.com/z-shell/zi)

To install add to the `.zshrc` file:

```zi
zi light z-shell/zsh-eza
```

Install only if eza exists and enable auto list directories:

```zi
zi ice has'eza' atinit'AUTOCD=1'
zi light z-shell/zsh-eza
```

Install only if eza exists and enable auto list directories in turbo mode:

```zi
zi ice wait lucid has'eza' atinit'AUTOCD=1'
zi light z-shell/zsh-eza
```

Install only if eza exists and enable auto list directories in turbo mode with the for syntax:

```zi
zi wait lucid for \
  has'eza' atinit'AUTOCD=1' \
    z-shell/zsh-eza
```

### With [Oh My Zsh](https://ohmyz.sh/)

Clone the repository and add `zsh-eza` to the plugins array in your `.zshrc` file:

```sh
git clone https://github.com/z-shell/zsh-eza \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-eza
```

```sh
plugins=(... zsh-eza)
```

### With Zplug

Add `zplug z-shell/zsh-eza` to your `~/.zshrc` and re-open your terminal session.
