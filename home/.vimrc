" Set to dark/light depending on your preferences
set background=dark

" Setup file encoding to UTF-8
set encoding=utf-8

" Enable syntax highlighting
syntax on

" Setup backspace behavior
set backspace=indent,eol,start

" Restore the cursor position in recent files
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif

" Enable filetype plugin
filetype plugin indent on
