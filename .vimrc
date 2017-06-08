""======================================
"Dein
filetype off

if !&compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.vim') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

"%拡張
runtime macros/matchit.vim

"常駐化
call singleton#enable()

call unite#custom#profile('default','context',{
			\'vertical_preview' : 1
			\})

"VimFilerをデフォルトに設定する
call vimfiler#custom#profile('default','context', {
	\ 'explorer' : 1,
	\ 'edit_action' : 'open',
	\ 'split_action' : 'tabsplit',
	\})
let g:vimfiler_as_default_explorer=1


"lightlineせってい
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode'
        \ }
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"Neocompleteをデフォルトで有効にする
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#enable_auto_select = 1

"tabで次候補,Shift-tabで前候補
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"jscomplete設定
let g:jscomplete_use = ['dom', 'moz', 'es6th']

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

"クリップボード共有
set clipboard=unnamed

" .で.vimrcを開く
nnoremap <silent><Space>. :<C-u>edit $MYVIMRC<CR>

" rでvimrcをリロードする
nnoremap <silent><Space>r :source $MYVIMRC<CR>
" eでファイラ起動
execute 'nnoremap <silent><Space>e :VimFiler ' . expand("%:h"). ' -split -simple -winwidth=50 -no-quit<CR>'
" bでUnite bookmark起動
nnoremap <silent><Space>b :Unite bookmark -winheight=8<CR>
" aでUniteBookmarkAdd
nnoremap <silent><Space>a :UniteBookmarkAdd<CR>
" gでUniteGrep
nnoremap <silent><Space>g :Unite grep -vertical<CR>
" hで履歴表示
nnoremap <silent><Space>h :Unite file_mru -vertical<CR>
" 
" y
nnoremap <silent><Space>y :Unite register<CR>

"Uniteでカスタムアクション定義。vimfilerを開く
let s:action = {
\   'is_selectable' : 0,
\}

function! s:action.func(candidate)
		execute 'VimFiler ' . a:candidate.word . ' -split -simple -winwidth=50 -no-quit'
endfunction

call unite#custom#action('directory', 'myvimfiler', s:action)
unlet s:action

" tでtagbar開く
nnoremap <silent><Space>t :Tagbar<CR>

"コマンドモード移行は頻度高いのでセミコロンで、ftFT繰り返しはShiftありきでいいや
nnoremap ; :

" <Ctrl + hl> で左右ウィンドウへ移動
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

"Tabで右ウィンドウ、Shift+Tabで左ウィンドウ
"ターミナル経由用に<ESC>[Aを割り当てておく
nnoremap <Tab> <C-w>l
nnoremap <S-Tab> <C-w>h
nnoremap [A <C-w>h

" hでヘッダへ移動
nnoremap <silent><Space>h :<C-u>hide edit %<.h<CR>

" cでCPPへ移動
nnoremap <silent><Space>c :<C-u>hide edit %<.cpp<CR>

"ZQは危険なのでナシで
nnoremap ZQ <Nop>

"ディレクトリのデフォルト動作をVimFilerにする
call unite#custom#default_action('directory' , 'myvimfiler')

"検索するとき、正規表現のエスケープを最低限に very magic
nnoremap / /\v
nnoremap ? ?\v

"coで縦連番自動置換
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let snf=&nf|set nf-=octal|let cl = col('.')|for nc in range(1, <count>?<count>-line('.'):1)|exe 'normal! j'.nc.<q-args>|call cursor('.', cl)|endfor|unlet cl|unlet snf

set nocompatible
scriptencoding utf-8
set encoding=utf-8
set directory=~/tmp
set undodir=~/tmp/undo
set backupdir=~/tmp/backup

if has('win32') || has('win64')
	let $TMP = $HOME . "\\tmp"
endif

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
set wildmode=longest:full,full "補完時に最長一致まで表示する
set tabstop=2 "タブサイズは２文字分
set shiftwidth=2
set noexpandtab "タブ文字へ展開はしない
set softtabstop=0 "ソフトタブは使わない
"カレントディレクトリを開いたディレクトリにする
au BufEnter * execute ":silent! lcd " . fnameescape(expand("%:p:h"))
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
" ;1 で1番左のタブ、;2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent><Space>'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" :c 新しいタブを一番右に作る
nnoremap <silent><Space>c :tablast <bar> tabnew<CR>
" :d タブを閉じる
nnoremap <silent><Space>d :tabclose<CR>
" :n 次のタブ
nnoremap <silent><Space>n :tabnext<CR>
" :p 前のタブ
nnoremap <silent><Space>p :tabprevious<CR>

"ZZで最後のタブなら保存してクリア、それ以外は保存して閉じる
function! s:replace_zz()
	if tabpagenr('$') == 1 && winnr('$') == 1
		"タブページがないので保存してクリア
		if expand("%") == ""
			echo "名前をつけて下さい"
		else 
			write
			enew
			simalt ~n
		end
	else
		"通常のZZ
		if expand("%") == ""
			echo "名前をつけて下さい"
		else 
			write
			quit
		end
	endif
endfunction

if has('win32') || has('win64')
	noremap ZZ :<C-u>call <SID>replace_zz()<CR>
endif

if has('win32') || has('win64')
	" Windowsの場合
	inoremap <silent> <C-j> <C-^><C-r>=IMState('FixMode')<CR>
elseif has('unix')
	" unixでGVimの時だけ「日本語入力固定モード」を有効化する
	if has('gui_running')
		let IM_CtrlMode = 1
		inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
	else
		let IM_CtrlMode = 0
	endif
endif


"fugitiveのコマンドみたくMerginalを使いたい
command! Gbranch :Merginal

"v連打で範囲拡大
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

filetype plugin on
filetype indent on

"タブのラベル名を返す
function! GuiTabLabel()
	let l:label = '' " タブで表示する文字列の初期化
	let l:bufnrlist = tabpagebuflist(v:lnum) " タブに含まれるバッファ情報

	" 表示文字列にバッファ名を追加。ファイル名だけ
	let l:bufname = fnamemodify(bufname(l:bufnrlist[tabpagewinnr(v:lnum) - 1]), ':t')

	" バッファ名がないときは - で省略
	let l:label .= l:bufname == '' ? '-' : l:bufname

	" タブ内にウィンドウが複数あるときにはその数
	let l:wincount = tabpagewinnr(v:lnum, '$')
	if l:wincount > 1
		let l:label .= '[' . l:wincount . ']'
	endif

	" 変更があったら+
	for bufnr in l:bufnrlist
		if getbufvar(bufnr, "&modified")
			let l:label .= ' +'
			break
		endif
	endfor
	return l:label
endfunction

"タブのラベルカスタマイズ
set guitablabel=%N:\ %{GuiTabLabel()}

"独自コマンド集
"2つのファイルをdiffする関数
function! s:run_diff(left,right)
	let wm = "!start "
	let wm .= "\"C:\\Program Files\\WinMerge\\WinMergeU.exe\""
	let wm .= " \"".a:left. "\""
	let wm .= " \"".a:right. "\""
	exec wm
endfunction


"windiffで自分と手前のバッファを比較する
command! Dp call s:run_diff(expand("%:p"), bufname(bufnr("")-1))

"windiffで自分と次のバッファを比較する
command! Dn call s:run_diff(expand("%:p"), bufname(bufnr("")+1))

"hostsを開く
if has('win32') || has ('win64')
	command! Hosts :e C:/windows/system32/Drivers/etc/hosts
else 
	command! Hosts :e /etc/hosts
endif


"Previm open
au BufRead,BufNewFile *.md set filetype=markdown
