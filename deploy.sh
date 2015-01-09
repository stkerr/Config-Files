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
    cp -R -f .vim/* ~/.vim/
elif [[ ${uname} == "Darwin" ]]; then
    # No backups on OS X
    cp -f .vimrc ~/
    cp -R -f .vim/* ~/.vim/
fi

echo If you have not compiled the YouCompleteMe vim module before running deploy.sh,
echo please do so.
echo
echo "    cd .vim/bundle/youcompleteme/ && ./install.sh"
echo
echo Optionally, set YCM_CORES to speed up builds.
