set number
syntax on
set tabstop=4
set shiftwidth=4
set autoindent
set cindent

" other whitespace and indenting related settings
set softtabstop=4

" multiples of shiftwidth when using >
set shiftround

" insert tabs or spaces depending on active indent
set smarttab

" I preffer to insert spaces
set expandtab

" This is a personal preference, I copy with 'as is' indent, the use '<' or '>' on visual to change it
set copyindent

" don't force preprocessor lines at column 1
set cinkeys-=0# 

" makefiles retain tabs (adding to your autocommand group)
autocmd filetype make setlocal ts=4 sts=4 sw=4 noexpandtab

" remember to ignore C related binaries
set wildignore+=*.o,*.obj,*.a,*.lib,*.elf

filetype on

" for Powerline
set nocompatible
set laststatus=2
set encoding=utf-8
