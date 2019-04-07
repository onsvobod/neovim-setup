#!/bin/bash

# debian neovim and python plugins install
apt-get install neovim python-neovim python3-neovim

# ubuntu neovim and python plugins install
#apt-get install software-properties-common
#add-apt-repository ppa:neovim-ppa/stable
#apt-get update
#apt-get install neovim
#apt-get install python-dev python-pip python3-dev python3-pip
#pip3 install --user --upgrade pynvim
#pip2 install --user --upgrade pynvim

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
