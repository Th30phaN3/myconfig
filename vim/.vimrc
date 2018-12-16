"colorscheme badwolf     " awesome colorscheme
syntax enable		" enable syntax processing
set tabstop=4		" number of visual spaces per TAB
set softtabstop=4	" number of spaces in tab when editing
set expandtab		" tab are spaces
set number              " show line numbers
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set backup
set backupdir=~/tmp,/tmp
set backupskip=/tmp/*
set directory=~/tmp,/tmp
set writebackup

"call pathogen#infect()
"call pathogen#runtime_append_all_bundles()