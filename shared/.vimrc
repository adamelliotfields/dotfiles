filetype plugin indent on " enables indentation based on file type

syntax enable " enables syntax highlighting

colorscheme slate " fd -evim -d1 . $(fd -td colors /usr/share/vim)

set nocompatible " disables vi compatibility
set nowrap " disable wrapping
set number " shows line numbers
set wildmenu " shows tab completions in command mode (after you press `:`)
set ignorecase " ignore case in search patterns
set smartcase " don't ignore case when search pattern contains upper case
set incsearch " show where the search matches while you type
set showmatch " shows the matching bracket
set expandtab " converts tabs to spaces
set endofline " inserts newline at end of file
set mouse=a " enable mouse in all modes
set ttymouse=xterm2 " enable terminal mouse integration
set clipboard^=unnamed,unnamedplus " use system clipboard
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set background=dark " adjusts colors for dark terminal backgrounds
set tabstop=2 " tab indents are 2 spaces
set shiftwidth=2 " show tab indents as 2 spaces
set laststatus=2 " always show the status bar
set complete-=1 " don't complete on first character, use ctrl-n and ctrl-p
set statusline=
set statusline+=%F%m%r " filename[modified][read-only]
set statusline+=\ \ Line:\ %l " line number
set statusline+=\ \ Column:\ %c " column number

" https://vim.fandom.com/wiki/Automatically_wrap_left_and_right
set whichwrap+=<,>,h,l,[,]

" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\e[5 q" " blinking vertical bar
let &t_SR = "\e[3 q" " blinking underline
let &t_EI = "\e[1 q" " blinking block
