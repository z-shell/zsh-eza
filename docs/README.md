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
  Zsh plugin which replace GNU/ls with <a target="_self" href="https://github.com/eza-community/eza">eza-community/eza</a>
  </h2>
<h3>
  <a href="https://github.com/orgs/z-shell/discussions/">《❔》Ask a Question </a>
  <a href="https://wiki.zshell.dev/search/">《💡》Search Wiki </a>
  <a href="https://github.com/z-shell/community/issues/new?assignees=&labels=%F0%9F%91%A5+member&template=membership.yml&title=team%3A+">《💜》Join </a>
  <a href="https://digitalclouds.crowdin.com/z-shell/">《🌐》Localize </a>
</h3></td></tr>
<tr>
<td align="center">
  <a target="_self" href="https://github.com/zplugin/zsh-eza/actions/workflows/trunk-check.yml">
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
<tr><td><img align="center" style="width:100%;height:auto" src="https://user-images.githubusercontent.com/59910950/165784269-3a8a8bfe-f291-4a33-aac9-1afa2b7b767f.png" />
</td></tr></table></div>

## Default settings

Sets paramters and aliases for `eza` to replace `ls`, enable auto list directories on `cd` with `export AUTOCD=1`.

### Parameters

```shell
eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')
```

### Aliases

```shell
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'
```

## Install

The `eza` should be present to use this plugin. Install `eza` with Zi:

```shell
zi ice from'gh-r' as'program' sbin'**/eza -> eza' atclone'cp -vf completions/eza.zsh _eza'
zi light eza-community/eza
```

### With [Zi](https://github.com/z-shell/zi)

To install add to the `.zshrc` file:

```shell
zi light zplugin/zsh-eza
```

Install only if eza exists and enable auto list directories:

```shell
zi ice has'eza' atinit'AUTOCD=1'
zi light zplugin/zsh-eza
```

Install only if eza exists and enable auto list directories in turbo mode:

```shell
zi ice wait lucid has'eza' atinit'AUTOCD=1'
zi light zplugin/zsh-eza
```

Install only if eza exists and enable auto list directories in turbo mode with the for syntax:

```shell
zi wait lucid for \
  has'eza' atinit'AUTOCD=1' \
    zplugin/zsh-eza
```

### With [Oh My Zsh](https://ohmyz.sh/)

Clone the repository and add `zsh-eza` to the plugins array of your zshrc file:

```sh
~/.oh-my-zsh/custom/plugins
```

```sh
plugins=(... zsh-eza)
```

### With Zplug

Add `zplug zplugin/zsh-eza` to your `~/.zshrc` and re-open your terminal session.
