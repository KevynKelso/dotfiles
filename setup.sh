#!/bin/bash

set -e

my_python_version="3.9.14"
 
# Make directories
mkdir -p $HOME/bin
    
cd $HOME
ln -sf $HOME/projects/dotfiles/.zshrc .zshrc

# Install neovim
if !(which nvim); then
    pushd
    # link nvim configuration
    cd $HOME/.config
    ln -fs $HOME/projects/dotfiles/nvim/ nvim

    # Install nvim from tarball
    curl -fLo nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    tar xzvf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    cd $HOME/bin
    ln -sf $HOME/nvim-linux64/bin/nvim nvim

    # Install vim plug
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    popd
fi

# Install ZSH
if !(which zsh); then
    sudo apt install zsh -y
    # Oh my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # pure theme
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install pyenv
if !(which pyenv); then
    sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
    
    exec "$SHELL"

    pyenv install $my_python_version
    pyenv global $my_python_version
fi
