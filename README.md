
# System Config

A Stu-specific repository of system level files:

- 'dot' files
- run command (`rc`) files
- configuration files

----------


### Files

Set up symlinks according to the schema below via:

```bash
ln -sf ~/system-config/<file> .
ln -sf ~/system-config/<directory> .
```


| File                     | Configure                            | Destination |
|--------------------------|--------------------------------------|-------------|
| `R/.Rprofile`            | Profile for `R` start-up             | `~/`        |
| `R/.Renviron`            | Config for RStudio global variables  | `~/`        |
| `zsh/.zshrc`             | Config for Z-shell                   | `~/`        |
| `bash/.bashrc`           | Config for Bourne Again Shell (BASH) | `~/`        |
| `bash/.bash_functions`   | BASH function utilities              | `~/`        |
| `vim/.vimrc`             | Config for VIM                       | `~/`        |
| `git/.gitconfig`         | Global config file for Git           | `~/`        |
| `git/.gitignore_global`  | Global Git ignore file               | `~/`        |


### Directories

| Directory     | Configure                                        | Destination            |
|---------------|--------------------------------------------------|------------------------|
| `git/hooks/*` | `git` related hooks                              | `~/.git/hooks/`        |
| `vim/*`       | VIM specific config `*.vim` files                | `~/.vim/`              |
| `zsh/*.zsh`   | ZSH specific custom config `*.zsh` files         | `~/.oh-my.zsh/custom/` |
| `texmf/*`     | Config for `pdflatex`; particularly `stuTeX.tex` | `~/`                   |

----------


# Installation

```bash
cd $HOME
git clone https://github.com/stufield/system-config.git
```

### Install `.oh-my-zsh`

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install `zsh-autosuggestions`

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

----------


## Reload ZSH

```bash
source ~/.zshrc
OR
zshreload
```

### dev mode (`.Rprofile`)

Allows for user friendly development mode to alternative `.libPath()`
(toggle):

```r
devmode()  # ON
devmode()  # OFF
```

----------


### Commit message template

Set up a standard commit message template to standardize the look and
feel of commit messages to `Git` repositories.

At the moment I recommend configuring inside the local `Git` repository,
however, if you wish, you can set the template globally to implement in
all your system repositories. 
__note:__ the result of the commands below has
already been incorporated into the `.gitconfig` provided using _my_ 
default paths.

```bash
git config --local commit.template "~/sys-config/git/commit-msg-template"
OR
git config --global commit.template "~/sys-config/git/commit-msg-template"
```

