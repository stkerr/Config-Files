Config-Files
============

Various configuration files

This repository makes use of submodules. You must get the submodules, after
getting this repository. To do so:

* git submodule update --init --recursive

# Installation Instructions

The provided deploy.sh script installs all configuration files and is probably
the easiest way to use this repository. 

The sections below cover installation
instructions for each of the included configuration files.

## Vim installation
Note the Vim submodule, YouCompleteMe, requires additional steps to use.

To do this, you need to run:

> cd .vim/bundle/youcompleteme/ && ./install.sh

Note that you can set the YCM_CORES environment variable to speed this up.

## GNOME Terminal Colors
The gnome-terminal-colors-monokai has a custom GNOME terminal color theme that
has been slightly modified. It can be installed by changing to that directory
and running:

> ./install.sh

and selecting the appropriate termial profile to update.

## Custom fonts
Several custom fonts are installed in the .fonts/ directory of this repository.
To install them on Ubuntu (maybe Debian too? I have tried so far on Ubuntu 14.04)
, run:

> cp -R .fonts/* ~/.fonts/
> fc-cache -f


