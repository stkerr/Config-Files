#!/bin/bash

# Detect the OS 
uname=$(uname)

# Remove existing vim directory
rm -rf ~/.vim

# Create a .vim directory if necessary 
if [ ! -d ~/.vim ]; then
    mkdir ~/.vim
fi

if [[ ${uname} == "Linux" ]]; then
    # Copy with backups (on Linux only)
    cp -bf .vimrc ~/
    cp -bf .pylintrc ~/
    cp -R -f .vim/* ~/.vim/
elif [[ ${uname} == "Darwin" ]]; then
    # No backups on OS X
    cp -f .vimrc ~/
    cp -f .pylintrc ~/
    cp -R -f .vim/* ~/.vim/
fi

