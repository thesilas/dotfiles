" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup            " keep a backup file
endif
set history=700         " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  set ttymouse=xterm2
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent                " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

" set terminal title
set title

" show line numbers
set number

" Also show relative numbers
set relativenumber

" ignore case in search unless searching uppercase letters
set ignorecase smartcase

" cool menu with highlighting
set wildmenu wildmode=list:longest

" shot messages
set shortmess=aoOtTI

" automatically save buffer on :next or the like
set autowrite

" highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+\%#\@<!$/

" faster scrolling with ^e ^y
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" better % command
runtime macros/matchit.vim

" moving between tabs
map <S-Right> :tabn<return>
map <S-Left> :tabprev<return>

" nice leader key to bind custom actions
let mapleader = ","

" :noh with ,n
nmap <silent> <leader>n :silent :nohlsearch<CR>

filetype on
filetype indent on
filetype plugin on

" fix Ruby syntax drawing issues (which usually can be manually fixed with Ctrl-L)
let ruby_minlines = 100

" highlight current line (really bad for performance)
"set cursorline

" highlighting
"set fillchars=stl:-,stlnc:-,vert:\|,fold:-,diff:-
set fillchars=stl:-,stlnc:-,vert:\|,fold:-,diff:-
hi IncSearch cterm=underline,bold
hi IncSearch cterm=underline,bold
hi CursorLine cterm=NONE ctermbg=0
hi StatusLine ctermfg=3 ctermbg=NONE cterm=reverse
hi StatusLineNC ctermfg=3 ctermbg=NONE cterm=bold
hi VertSplit ctermfg=3 ctermbg=NONE cterm=bold
hi LineNr ctermfg=3 ctermbg=0 cterm=bold
hi Visual cterm=NONE ctermbg=black
hi String ctermfg=1 cterm=bold
hi Special ctermbg=NONE ctermfg=1 cterm=NONE
hi TabLineFill cterm=none ctermbg=0
hi TabLine ctermfg=3 ctermbg=0 cterm=bold,none
hi TabLineSel ctermfg=3 ctermbg=0 cterm=underline
hi Folded ctermfg=7 ctermbg=none cterm=none

" persistent undo
if has("persistent_undo")
  set undofile
  set undodir=~/.vim-tmp,~/.tmp,/~/tmp,/tmp
end

set winminheight=0 " minimun window height
set winfixheight " keep window height when windows are opened/closed

" Mark lines > 79 chars
autocmd FileType ruby match ErrorMsg /\%>79v.\+/

" use system clipboard
set clipboard=unnamedplus

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Height of the command bar
set cmdheight=2

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Automatically scroll the text
set sidescroll=10

" Highlight color for visual mode
highlight Visual cterm=reverse ctermbg=NONE

" Keep clipboard content after exit
autocmd VimLeave * call system("echo -n $'" . escape(getreg(), "'") . "' | xsel -ib")

" Colorscheme
colorscheme darkblue

" Search over newlines
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

" Quick save
noremap <Leader>s :update<CR>

" Own customizations begin here

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'

" Initialize plugin system
call plug#end()

" Easy invoke fzf
map ; :Files<CR>

" Fix lightline statusbar
set laststatus=2

“ WSL Copy & Paste
if system('uname -r') =~ "Microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
        augroup END
endif
