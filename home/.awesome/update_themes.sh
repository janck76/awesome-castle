#!/bin/bash - 
cd $HOME/.config/awesome || exit 1
git pull
git submodule init
git submodule update
