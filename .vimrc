if has('gui_running') && !has('unix')
  set encoding=utf-8
endif
scriptencoding utf-8
set directory=~/tmp


"文字コードと改行コードを表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"オートインデント有効
set autoindent

"======================================
"NeoBundle
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/plugin/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif

NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/vimfiler.git'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/vimproc.git'
NeoBundle 'vim-scripts/Align.git'
NeoBundle 'glidenote/memolist.vim.git'
NeoBundle 'kien/ctrlp.vim.git'
NeoBundle 'scrooloose/syntastic.git'
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

filetype plugin on
filetype indent on
