""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup        " keep a backup file
set history=50    " keep 50 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching

" pas de case sensitive pour les recherches et recherche incremental
set ignorecase

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

set list " pour afficher les machins affreux qui sont cacher (les tab et les endl)
set lcs:tab:>-,trail:.  " pour rendre les trucs affiché par list un peu moins moche

" nombre d'espaces par tab
set tabstop=4

" nombre de caractère utilisé pour l'identation:
set shiftwidth=4

" test pour la synthax de python
let python_highlight_all = 1

" pour convertir les tab en espaces
set expandtab

" met en surbrillance tous les charactères dépassant la 80ème colonne
au BufWinEnter *.py let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" rend les recherches coloté avec un fond rouge
hi Search  term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White

" met en surbrillance les espaces et les tabs en trop
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

" numéro de lignes
set nu

" theme de couleur dans mon terminal (!= de gvim)
colorscheme astronaut

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Scripts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" pour mini buffer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" pour utiliser certains plugins
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  " set hlsearch
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

  " pydiction
  autocmd FileType python set complete+=k/home/psycojoker/.vim/plugin/pydiction-0.5

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  set autoindent        " always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis

" statut ligne amélioré
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [Line=%04l]\ [Col=%04v]\ [%p%%]
set laststatus=2

" pour foutre les fichier ~ dans un coin
" marche pas :<
set backupdir=$HOME/.vim/backup
set directory=.,./.backup,/tmp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fonctions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" fonction qui converti tous les tabs en espaces et met les fichier mac et dos
" au format unix
fun CleanText()
    let curcol = col(".")
    let curline = line(".")
    exe ":retab"
$//ge"xe ":%s/
/ /ge"xe ":%s/
    exe ":%s/ \\+$//e"
    call cursor(curline, curcol)
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't use Ex mode, use Q for formatting
map Q gq

" highlight pour le charactères qui dépassent la 80ème colonne"
map <silent> <F3> "<Esc>:match ErrorMsg '\%>80v.\+'<CR>"

" lance le script python sur lequel on bosse
map <silent> <F4> "<Esc>:w!<cr>:!python %<cr>"

" utiliser F5F5 pour switcher search hilight
nnoremap <F5><F5> :set invhls hls?<CR>

" map pour la fonction CleanText
map <F6> :call CleanText()<CR>

" correction orthographique
map <silent> <F7> "<Esc>:silent setlocal spell! spelllang=fr<CR>"
map <silent> <F8> "<Esc>:silent setlocal spell! spelllang=en<CR>"

" Taglist
nnoremap <F9> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Exit_OnlyWindow=1
"map <F4>  :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" pour faire comme D parce que c'est cool
map Y y$
