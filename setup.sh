#!/bin/bash

set -e

my_python_version="3.9.14"
distro_pm="yum"
dotfiles="$HOME/projects/dotfiles"
 
mkdir -p $HOME/bin
    
# ZSH runtime config
ln -sf $dotfiles/.zshrc $HOME

# Terminal Emulator
# TODO(kkelso): this is not valid bash syntax lol
# if [! -d $HOME/.config/alacritty/ ]; then
#     mkdir -p $HOME/.config/alacritty
#     ln -sf $dotfiles/alacritty.yml $HOME/.config/alacritty/alacritty.yml
#     # We use Alacritty's default Linux config directory as our storage location here.
#     mkdir -p ~/.config/alacritty/themes
#     git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
# fi

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
    sudo $distro_pm install zsh -y
    # Oh my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # pure theme TODO(kkelso): move pure to custom zsh plugins
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
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

# Fun packages
if !(which exa); then
    sudo $distro_pm install exa -y
fi

if !(which bat); then
    sudo $distro_pm install bat -y
fi
