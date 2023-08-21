#!/bin/bash

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

  # install p10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

  # install zsh plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$HOME/.cfg" ]; then
  # clone dotfiles in $HOME
  git clone --bare git@github.com:jackewing/dotfiles.git --branch bare "$HOME/.cfg"

  function config {
    git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
  }

  if config checkout; then
    echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";

    mkdir -p "$HOME/.config-backup"
    config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv $HOME/{} $HOME/.config-backup/{}
  fi;

  config config status.showUntrackedFiles no
fi

# Packages need for Ubuntu
cat /etc/os-release | grep "NAME=\"Ubuntu\""
if [ $? -eq 0 ]; then
  sudo apt update
  sudo apt install -y ripgrep xsel tmux
fi