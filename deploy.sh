#!/bin/bash

# Remove existing vim directory
rm -rf ~/.vim

# Create a .vim directory if necessary 
if [ ! -d ~/.vim ]; then
    mkdir ~/.vim
fi

# Copy with backups
cp -bf .vimrc ~/
cp -R -f -b .vim/* ~/.vim/
echo If you have not compiled the YouCompleteMe vim module before running deploy.sh,
echo please do so.
echo
echo "    cd .vim/bundle/youcompleteme/ && ./install.sh"
echo
echo Optionally, set YCM_CORES to speed up builds.
