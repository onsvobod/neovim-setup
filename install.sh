#!/bin/bash

sudo apt-get update

sudo apt-get install python-dev python-pip python3-dev python3-pip

sudo pip2 install wheel setuptools
sudo pip3 install wheel setuptools

# debian neovim and python plugins install
#apt-get install neovim

# ubuntu neovim and python plugins install
#apt-get install software-properties-common
#add-apt-repository ppa:neovim-ppa/stable
#apt-get update
#apt-get install neovim

pip2 install --upgrade pynvim
pip3 install --upgrade pynvim

#mkdir -p ~/.config/nvim
#cp init.vim ~/.config/nvim

#clangd install
sudo apt-get install  -t stretch-backports clang-tools-6.0
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-6.0 100

#python language server
pip install python-language-server
pip3 install python-language-server
pip install 'python-language-server[all]'
pip3 install 'python-language-server[all]'

#plugin manager install
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt-get install ack-grep

cp pylintrc ~/.config
