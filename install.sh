#!/bin/bash

apt-get update

apt-get install python-dev python-pip python3-dev python3-pip

# debian neovim and python plugins install
apt-get install neovim
echo "deb http://deb.debian.org/debian unstable main" >> /etc/apt/sources.list
apt-get update

# ubuntu neovim and python plugins install
#apt-get install software-properties-common
#add-apt-repository ppa:neovim-ppa/stable
#apt-get update
#apt-get install neovim

pip2 install --user --upgrade pynvim
pip3 install --user --upgrade pynvim

mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim

#clangd install
apt-get install clang-tools-7
update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-7 100

#python language server
pip install python-language-server
pip3 install python-language-server
pip install 'python-language-server[all]'
pip3 install 'python-language-server[all]'

#plugin manager install
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
