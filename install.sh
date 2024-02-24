#!/bin/bash

sudo apt-get update

sudo apt-get install python3-dev python3-pip

sudo pip3 install wheel setuptools

pip3 install --upgrade pynvim

mkdir -p ~/.config/nvim
ln -s init.lua ~/.config/nvim/init.lua

#plugin manager install
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt-get install ack-grep

sudo apt-get install nodejs

# install language servers
sudo apt install clangd
pip install cmake-language-server
sudo npm i -g bash-language-server
sudo npm i -g dockerfile-language-server-nodejs
sudo npm i -g vscode-langservers-extracted
sudo npm i -g pyright
