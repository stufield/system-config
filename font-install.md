# Installing Fonts for Terminal

* Installers install files to the ~/Library/Fonts directory (MacOS)

------------

### Not Sure If Necessary

```bash
sudo sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```


------------

# Install Powerlevel10k

* [powerlevel10k](https://dev.to/abdfnx/oh-my-zsh-powerlevel10k-cool-terminal-1no0)

```bash
echo $ZSH_CUSTOM
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
source ~/.zshrc
Kick start the installation wizard
```


------------

# Install PowerLine fonts

```bash
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
```

# Install Nerd fonts

* [nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
* [nerd](https://nerdfonts.com)

```bash
git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1
cd nerd-fonts
./install.sh Meslo
./install.sh Inconsolata
```

