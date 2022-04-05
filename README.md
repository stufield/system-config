
<!-- README.md is generated from README.Rmd. Please edit that file -->

# system\_config

A Stu-specific repository of system level files:

-   ‘dot’ files
-   run command (`rc`) files
-   configuration files

------------------------------------------------------------------------

### Files

| File                | Configure                            | Destination |
|---------------------|--------------------------------------|-------------|
| `.Rprofile`         | Profile for `R` start-up             | `~/`        |
| `.Renviron`         | Config for RStudio global variables  | `~/`        |
| `.zshrc`            | Config for Z-shell                   | `~/`        |
| `.bashrc`           | Config for Bourne Again Shell (BASH) | `~/`        |
| `.bash_functions`   | BASH function utilities              | `~/`        |
| `.vimrc`            | Config for VIM                       | `~/`        |
| `.gitconfig`        | Global config file for Git           | `~/`        |
| `.gitignore_global` | Global Git ignore file               | `~/`        |

### Directories

| Directory   | Configure                                        | Destination            |
|-------------|--------------------------------------------------|------------------------|
| `git-hooks` | `git` related hooks & config                     | `~/.git/hooks/`        |
| `vim`       | VIM specific config `*.vim` files                | `~/.vim/`              |
| `zsh`       | ZSH specific custom config `*.zsh` files         | `~/.oh-my.zsh/custom/` |
| `texmf`     | Config for `pdflatex`; particularly `stuTeX.tex` | `foo`                  |

------------------------------------------------------------------------

# Installation

``` bash
cd $HOME
git clone git@github.com:stufield/system-config.git
```

### Install `.oh-my-zsh`

``` bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install `zsh-autosuggestions`

``` bash
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

------------------------------------------------------------------------

## Reload ZSH

``` bash
source ~/.zshrc
OR
zshreload
```

### dev mode (`.Rprofile`)

Allows for user friendly development mode to alternative `.libPath()`
(toggle):

``` r
devmode()  # ON
devmode()  # OFF
```

### Commit message template

Set up a standard commit message template to standardize the look and
feel of commit messages to SomaLogic Git repositories.

At the moment I recommend configuring inside the local Git repository,
however, if you wish, you can set the template globally to implement in
all your system repositories.

``` bash
git config --local commit.template "~/path/to/sys-config/commit-msg-template"
OR
git config --global commit.template "~/path/to/sys-config/commit-msg-template"
```

------------------------------------------------------------------------

Created on 2022-04-05 by
[Rmarkdown](https://github.com/rstudio/rmarkdown) (v2.8) and R version
4.1.0 (2021-05-18).
