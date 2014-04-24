#!/bin/bash

# Create a .vim directory if necessary 
if [ ! -d ~/.vim ]; then
    mkdir ~/.vim
fi

# Copy with backups
cp -bf .vimrc ~/
cp -R -f -b .vim/* ~/.vim/
