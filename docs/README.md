# 📂 zsh-eza

a zsh plugin which replaces GNU/ls with <a target="_self" href="https://github.com/eza-community/eza">eza-community/eza</a>

### Environment variables

| Variable | Description | Default |
| ------------- | -------------- | -------------- |
| _EZA_PARAMS | eza params to be used | `('--git' '--group' '--group-directories-first' '--time-style=long-iso' '--color-scale=all' '--icons')` |
| AUTOCD | enable auto list directories on `cd` | 0 |

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

`eza` should be present to use this plugin. Install `eza` with Cargo:

```shell
cargo install eza
```

or your package manager of choice.

### With [Zi](https://github.com/z-shell/zi)

Add the following to your `~/.zshrc`

```shell
zi light givensuman/zsh-eza
```

### With [Oh My Zsh](https://ohmyz.sh/)

Clone the repository

```shell
git clone https://github.com/givensuman/zsh-eza \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-eza
```

and add `zsh-eza` to the plugins array of your `~/.zshrc`

```sh
plugins=(
  ... 
  zsh-eza
)
```

### With Zplug

Add the following to your `~/.zshrc`

```shell
zplug givensuman/zsh-eza
```
