#!/bin/bash

sudo apt-get update

sudo apt-get install python3-dev python3-pip

sudo pip3 install wheel setuptools

pip3 install --upgrade pynvim

mkdir -p ~/.config/nvim
ln -s init.lua ~/.config/nvim/init.lua

#plugin manager install
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt-get install fd-find
sudo apt-get install ripgrep

# at least node version 18
sudo apt-get install nodejs

# install language servers
sudo apt install clangd
pip install cmake-language-server
sudo npm i -g bash-language-server
sudo apt install shellcheck
sudo npm i -g dockerfile-language-server-nodejs
sudo npm i -g vscode-langservers-extracted
sudo npm i -g pyright
sudo npm i -g yaml-language-server
