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

echo If you have not compiled the YouCompleteMe vim module before running deploy.sh,
echo please do so.
echo
echo "    cd .vim/bundle/youcompleteme/ && ./install.sh"
echo
echo Optionally, set YCM_CORES to speed up builds.

# Copy over custom fonts
if [[ ${uname} == "Linux" ]]; then
    if [ "$1" = "-no-terminal-updates" ]; then
        echo "[!] Skipping font installation."
    else
        echo "Installing fonts..."
        if [ ! -d ~/.fonts ]; then
            mkdir ~/.fonts
        fi
        cp -R -f .fonts/* ~/.fonts
        fc-cache -f
        echo "... done"
    fi
elif [[ ${uname} == "Darwin" ]]; then
    echo "Don't know how to copy/update fonts here. Please manually install .fonts/"
fi

# Install custom GNOME terminal colors
if [[ ${uname} == "Linux" ]]; then
    if [ "$1" = "-no-terminal-updates" ]; then
        echo [!] Skipping terminal color installation.
    else
        cd gnome-terminal-colors-monokai && ./install.sh ; cd ..
    fi
fi
