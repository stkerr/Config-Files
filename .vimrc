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

" I prefer to insert spaces
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

colorscheme pablo

" Map tab commands to "t+<>"
nnoremap tt :tabedit<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap td :tabclose<CR>
nnoremap tn :tabnew<CR>

" Open TList and NERDTree on start up 
let Tlist_Auto_Highlight_Tag=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Display_Prototype=1
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=1

autocmd VimEnter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Copy with mouse and no line numbers
set mouse=a

" No line wrap
set nowrap

" OCaml Modules
filetype plugin indent on
" Vim needs to be built with Python scripting support, and must be
" able to find Merlin's executable on PATH.
if executable('ocamlmerlin') && has('python')
  let s:ocamlmerlin = substitute(system('opam config var share'), '\n$', '', '''') . "/ocamlmerlin"
  execute "set rtp+=".s:ocamlmerlin."/vim"
  execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
endif
autocmd FileType ocaml source substitute(system('opam config var share'), '\n$', '', '''') . "/typerex/ocp-indent/ocp-indent.vim"

" Pathogen modules
call pathogen#infect()

" Set Syntastic configuration
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 0
let g:syntastic_cpp_compiler = "g++"
" let g:syntastic_cpp_compiler_options = " -std=c++11"
let g:syntastic_java_checkers = []
let g:syntastic_error_symbol = "X"
let g:syntastic_style_error_symbol = ">"
let g:syntastic_warning_symbol = "!"
let g:syntastic_style_warning_symbol = ">"
" Disable auto jump, since it might cause you to not be able to open a file if
" included headers aren't correct.
let syntastic_auto_jump = 0
" Disable highlighting, since it is quite slow for large files
let g:syntastic_enable_highlighting = 0 
let g:ycm_register_as_syntastic_checker = 0
