"======================================
"NeoBundle
filetype off
"NeoBundleのプラグインインストールディレクトリ
let s:neobundle_plugins_dir = expand(exists("$VIM_NEOBUNDLE_PLUGIN_DIR") ? $VIM_NEOBUNDLE_PLUGIN_DIR : '~/.vim/bundle')

"NeoBundleが入ってなかったらインストールする
if !isdirectory(s:neobundle_plugins_dir."/neobundle.vim")
	echo "Please install neobundle.vim."
	function! s:install_neobundle()
		if input("Install neobundle.vim? [Y/N] : ") =="Y"
			if !isdirectory(s:neobundle_plugins_dir)
				call mkdir(s:neobundle_plugins_dir, "p")
			endif

			execute "!git clone git://github.com/Shougo/neobundle.vim "
						\ . s:neobundle_plugins_dir . "/neobundle.vim"
			echo "neobundle installed. Please restart vim."
		else
			echo "Canceled."
		endif
	endfunction
	augroup install-neobundle
		autocmd!
		autocmd VimEnter * call s:install_neobundle()
	augroup END
	finish
endif

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif

"runtimepathには追加しないけど、neobundle.vimで更新する
NeoBundleFetch "Shougo/neobundle.vim"

"NeoBundleで管理してるプラグイン
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
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
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'alpaca-tc/alpaca_powertabline'
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim' }
NeoBundle 'kana/vim-smartinput'
NeoBundle 'cohama/vim-smartinput-endwise'
NeoBundle 'Shougo/vinarise'

"%拡張
runtime macros/matchit.vim

NeoBundleCheck
"VimFilerをデフォルトに設定する
let g:vimfiler_as_default_explorer = 1

if neobundle#tap('vim-smartinput')
  call neobundle#config({
        \   'autoload' : {
        \     'insert' : 1
        \   }
        \ })

  function! neobundle#tapped.hooks.on_post_source(bundle)
    call smartinput_endwise#define_default_rules()
  endfunction

  call neobundle#untap()
endif

if neobundle#tap('vim-smartinput-endwise')
  function! neobundle#tapped.hooks.on_post_source(bundle)
    " neosnippet and neocomplete compatible
    call smartinput#map_to_trigger('i', '<Plug>(vimrc_cr)', '<Enter>', '<Enter>')
    imap <expr><CR> !pumvisible() ? "\<Plug>(vimrc_cr)" :
          \ neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
          \ neocomplete#close_popup()
  endfunction
  call neobundle#untap()
endif


"Neocompleteをデフォルトで有効にする
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif

"Openbrowser設定
let g:netrw_nogx = 1 "netrwのgxマッピングを無効化する
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

"NeoBundle 'glidenote/memolist.vim.git'
map <Space>ml :MemoList<CR>
map <Space>mc :MemoNew<CR>
map <Space>mg :MemoGrep<CR>


"scrooloose/syntastic.git setting
    let g:syntastic_enable_signs=1
	let g:syntastic_auto_loc_list=2

"othree/eregex.vim.git setting
	let g:eregex_default_enable = 0

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
" tでtagbar開く
nnoremap <silent><Space>t :Tagbar<CR>

"コマンドモード移行は頻度高いのでセミコロンで、ftFT繰り返しはShiftありきでいいや
nnoremap ; :

" <Ctrl + hl> で左右ウィンドウへ移動
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"Tabで右ウィンドウ、Ctrl+Tabで左ウィンドウ
"ターミナル経由用に<ESC>[Aを割り当てておく
nnoremap <Tab> <C-w>l
nnoremap <C-Tab> <C-w>h
nnoremap [A <C-w>h

" hでヘッダへ移動
nnoremap <silent><Space>h :<C-u>hide edit %<.h<CR>

" cでCPPへ移動
nnoremap <silent><Space>c :<C-u>hide edit %<.cpp<CR>

"ZQは危険なのでナシで
nnoremap ZQ <Nop>

"ディレクトリのデフォルト動作をVimFilerにする
autocmd FileType vimfiler call unite#custom_default_action('directory', 'cd')

"検索するとき、正規表現のエスケープを最低限に very magic
nnoremap / /\v
nnoremap ? ?\v

"coで縦連番自動置換
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let snf=&nf|set nf-=octal|let cl = col('.')|for nc in range(1, <count>?<count>-line('.'):1)|exe 'normal! j'.nc.<q-args>|call cursor('.', cl)|endfor|unlet cl|unlet snf

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
set tabstop=2 "タブサイズは２文字分
set shiftwidth=2
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
" Tab jump
" :1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent> :'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" :c 新しいタブを一番右に作る
nnoremap <silent> :c :tablast <bar> tabnew<CR>
" :d タブを閉じる
nnoremap <silent> :d :tabclose<CR>
" :n 次のタブ
nnoremap <silent> :n :tabnext<CR>
" :p 前のタブ
nnoremap <silent> :p :tabprevious<CR>

filetype plugin on
filetype indent on
