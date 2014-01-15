"======================================
"NeoBundle
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif

NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/vimfiler.git'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'vim-scripts/Align.git'
NeoBundle 'glidenote/memolist.vim.git'
NeoBundle 'kien/ctrlp.vim.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'othree/eregex.vim.git'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'open-browser.vim'
NeoBundle 'renamer.vim'
NeoBundle 'violetyk/cake.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'rhysd/clever-f.vim'


NeoBundleCheck
"VimFilerをデフォルトに設定する
let g:vimfiler_as_default_explorer = 1

"NeoBundle 'glidenote/memolist.vim.git'
map <Space>ml :MemoList<CR>
map <Space>mc :MemoNew<CR>
map <Space>mg :MemoGrep<CR>

"scrooloose/syntastic.git setting
    let g:syntastic_enable_signs=1
	let g:syntastic_auto_loc_list=2

"othree/eregex.vim.git setting
	let g:eregex_default_enable = 0

" Lokaltog/vim-easymotion
" http://blog.remora.cx/2012/08/vim-easymotion.html
" ホームポジションに近いキーを使う
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
" 「;」 + 何かにマッピング
let g:EasyMotion_leader_key=";"
" 1 ストローク選択を優先する
let g:EasyMotion_grouping=1
" カラー設定変更
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=blue

filetype plugin on
filetype indent on

" .で.vimrcを開く
nnoremap <silent><Space>. :<C-u>edit $MYVIMRC<CR>

" rでvimrcをリロードする
nnoremap <silent><Space>r :source $MYVIMRC<CR>
" eでファイラ起動
execute 'nnoremap <silent><Space>e :VimFiler ' . expand("%:h"). ' -split -simple -winwidth=50 -no-quit<CR>'
" bでUnite bookmark起動
nnoremap <silent><Space>b :Unite bookmark<CR>
" aでUniteBookmarkAdd
nnoremap <silent><Space>a :UniteBookmarkAdd<CR>

"ディレクトリのデフォルト動作をVimFilerにする
autocmd FileType vimfiler call unite#custom_default_action('directory', 'cd')

"検索するとき、正規表現のエスケープを最低限に very magic
nnoremap / /\v
nnoremap ? ?\v

set nocompatible
if has('gui_running') && !has('unix')
  set encoding=utf-8
endif
scriptencoding utf-8
set encoding=utf-8
set directory=~/tmp

"文字コードと改行コードを表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

set autoindent "オートインデント有効
set number "行番号を表示
set autoread "更新されたら再読み込みする
set list "特殊文字を表示する
set listchars=eol:↲,tab:>\ ,trail:c,extends:c,precedes:c "特殊文字を表示する
highlight SpecialKey term=underline ctermfg=lightgray guifg=lightgray
highlight NonText term=underline ctermfg=lightgray guifg=lightgray
set listchars=eol:↲,tab:>\ ,trail:_,extends:_,precedes:_
"highlight SpecialKey term=underline ctermfg=lightgray guifg=lightgray
"highlight NonText term=underline ctermfg=lightgray guifg=lightgray

set scrolloff=8 "スクロール時視界を確保

set cursorline "カーソル行を表示する
set gdefault "検索時、全件検索がデフォルト
highlight CursorLine cterm=underline ctermfg=NONE guifg=NONE ctermbg=lightgray guibg=lightgray

"カラースキーマ設定
"colorscheme zellner

set showmatch
set browsedir=current "ファイラでカレントディレクトリを表示する
set wildmode=longest:full "補完時に最長一致まで表示する
set tabstop=4 "タブサイズは２文字分
set noexpandtab "タブ文字へ展開はしない
set softtabstop=0 "ソフトタブは使わない
"カレントディレクトリを開いたディレクトリにする
au BufEnter * execute ":silent! lcd " . fnameescape(expand("%:p:h"))
"au BufEnter * execute ":lcd " . fnameescape(expand("%:p:h"))
cd ~

" IMEの状態をカラー表示
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=Green
  highlight CursorIM guifg=NONE guibg=Purple
endif

" タブを表示する
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]d :tabclose<CR>
" td タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

filetype plugin on
filetype indent on
