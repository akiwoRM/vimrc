" ========================= " 
" 初期設定
" ========================= " 
"
" インストールプラグイン
" ・L2R
" ・listMelProc
"
if has("win32")
	let &termencoding = &encoding
endif

"ファイルタイプの認識機能オフ"
filetype off

if &compatible
	set nocomptible
endif

let s:dein_dir = expand('~/.vim/dein/')

set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)

	let s:toml      = '~/.dein.toml'
	let s:lazy_toml = '~/.dein_lazy.toml'
	call dein#load_toml(s:toml, {'lazy':0})
	call dein#load_toml(s:lazy_toml, {'lazy':1})

	call dein#end()
	call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
	call dein#install()
endif

"追加のプラグインパス "
set runtimepath+=$HOME/vimfiles

" 文字コードの自動認識 "
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック "
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
		" iconvがJISX0213に対応しているかをチェック "
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築 "
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分 "
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする "
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識 "
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする "
if exists('&ambiwidth')
	set ambiwidth=double
endif

" UTF-8で開き直す
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
" Eucで開き直す
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
 
"ファイルタイプの認識機能オン"
filetype plugin indent on

"ステータスライン"
"set statusline=%<%t\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%{CountBuffers()}%4v\ %l/%L(%3P)

"挿入モード時、ステータスラインの色を変更"
"let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

"if has('syntax')
"	augroup InsertHook
"		autocmd!
"		autocmd InsertEnter * call s:StatusLine('Enter')
"		autocmd InsertLeave * call s:StatusLine('Leave')
"	augroup END
"endif
"
"let s:slhlcmd = ''
"function! s:StatusLine(mode)
"	if a:mode == 'Enter'
"		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
"		silent exec g:hi_insert
"	else
"		highlight clear StatusLine
"		silent exec s:slhlcmd
"	endif
"endfunction
"
"function! s:GetHighlight(hi)
"	redir => hl
"	exec 'highlight '.a:hi
"	redir END
"	let hl = substitute(hl, '[\r\n]', '', 'g')
"	let hl = substitute(hl, 'xxx', '', '')
"	return hl
"endfunction

" 現在開いているバッファの数を返す "
function! CountBuffers()
	let cnt = 0 
	for nr in range(1, bufnr('$')) 
		if buflisted(nr) 
			let cnt += 1 
		endif 
	endfor 
	return cnt 
endfunction 

if has('unix')
	set runtimepath+=$HOME/vimfiles_linux
endif
 
" タブ幅 "
set tabstop=4
" インデント幅 "
set shiftwidth=4
" 自動インデント "
set cindent
" ステータスラインを常に表示 "
set laststatus=2
" バックスペースで文字を消す "
set backspace=2
set noexpandtab
" コマンドラインに使用される行数 "
set cmdheight=2
" バックアップを作らない "
set nobackup
" スワップファイルを作成しない "
set noswapfile
" 折り返し表示 "
set wrap
" バッファ切替を保存していなくても許す "
set hidden
" vi非互換モード "
" .vimrcがあった時点でnocompatibleになるらしいので下記の宣言に意味は無い
"set nocompatible
" タイトルを表示 "
set title
" ルーラーを表示 "
set ruler
" 対応カッコ表示 "
set showmatch
" 入力コマンドを表示 "
set showcmd 
" インクリメンタルサーチを行う "
set incsearch
" 検索時にハイライトする "
set hlsearch
" 検索時に最初に戻る "
set wrapscan 
" 履歴は100コマンドまで "
set history=100
" 入力中のコマンドを表示 "
set showcmd
" ファイルが更新されたら自動で読み直す "
set autoread
" 自動インデント"
set autoindent
" コマンドライン補完拡張 "
set wildmenu
" コピペにクリップボードを利用 "
" 無名レジスタに入るデータを、*レジスタにも入れる。(for linux)
set clipboard=unnamedplus
" ビジュアルモード時に矩形選択で自由移動"
set virtualedit+=block
" 起動時のeメッセージを表示しない"
set shortmess+=I
" undoファイルを生成しない "
set noundofile
" カラー設定 "
syntax on
colorscheme solarized
" customize Solarized theme
hi SpecialKey guibg=#002b36 
 
" タブ表示設定 "
set list
set lcs=tab:>\ ,eol:\ 
highlight SpecialKey ctermfg=DarkGrey

" 対応
set matchpairs& matchpairs+=<:>

"ビープ音を消す"
set vb t_vb=
 
"YankRing対策"
set viminfo+=!
 
"マウス使用可"
set mouse=a
 
" 行番号を表示 "
set number

" pythonのsys.pathの設定設定
if filereadable('/usr/autodesk/maya2014-x64/devkit/other/pymel/extras/completion/py')
    let $PYTHON_DLL = "/usr/autodesk/maya2014-x64/devkit/other/pymel/extras/completion/py"
endif

function! s:set_python_path()
    let s:python_path = system('python -', 'import sys;sys.stdout.write(",".join(sys.path))')
    python <<EOT
import sys
import vim

python_paths = vim.eval('s:python_path').split(',')
for path in python_paths:
    if not path in sys.path:
        sys.path.insert(0, path)
EOT
endfunction
" }}}

function! s:addPythonPath() abort
    call s:set_python_path()
endfunction

call dein#set_hook('jedi-vim', 'hook_source', function('s:addPythonPath'))

" ファイルタイプによる辞書補完"
if has('autocmd')
	autocmd FileType py setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType cpp set omnifunc=ccomplete#Complete
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
	autocmd FileType python
				\ let &l:path = system('python -', 'import sys;sys.stdout.write(",".join(sys.path))')
	" python の設定設定
	autocmd FileType python setl tabstop=4 expandtab shiftwidth=4 softtabstop=4
endif

""""""""""""""""
" キーバインド "  
""""""""""""""""
imap    <C-j> <esc>
" バッファ操作 "
noremap <C-h> <esc>:bp<CR>
noremap <C-l> <esc>:bn<CR>
nmap <c-q> <ESC>:bd!<CR>
" タブ操作
inoremap <c-t> <esc>:tabnew<CR>
" ウィンドウ操作 "
noremap <M-h> <c-w>h 
noremap <M-l> <c-w>l 
noremap <M-j> <c-w>j 
noremap <M-k> <c-w>k 
" 行補完 "
imap    <C-l> <c-x><c-l>
" カーソル操作 "
nnoremap j gj
nnoremap k gk
nnoremap fs ^
vnoremap fs ^
nnoremap fe $
vnoremap fe $<LEFT>
nnoremap ce c$
nnoremap <tab> %
vnoremap <tab> %
" ブランケット
" doorboy.vimに移行
"inoremap ( ()<LEFT>
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap < <><LEFT>
"inoremap ' ''<LEFT>
"inoremap " ""<LEFT>
" 上書き保存
nmap <c-s> <ESC>:w!<CR>
" 練習
noremap  <Up>    <Nop>
noremap  <Down>  <Nop>
noremap  <Left>  <Nop>
noremap  <Right> <Nop>
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Right> <Nop>
inoremap <Left>  <Nop>
" MEL関数リスト表示 "
command Funclist :vimgrep '.*proc.*' %|cwin
" Python関数リスト表示 "
command Funclistpy :vimgrep '^def.*:$' %|cwin
" 現在のファイル名をカーソル位置に挿入 "
imap    <M-f> <ESC>>:call append(line("."), bufname("%"))<CR>
" 現在のファイル名パスを表示 "
noremap <M-f> :echo bufname("%")<CR>
" 検索のハイライトを消す
nnoremap <ESC><ESC> :nohlsearch<CR>
" 検索後画面の中心に
nnoremap n nzz
nnoremap N Nzz
" カーソル位置の単語をヤンクした単語に変換
nnoremap <silent> cy ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
" \ から / へ置換
vnoremap <silent> <Leader>/ :s/\\/\//g<CR>:nohlsearch<CR>
nnoremap <silent> <Leader>/ :s/\\/\//g<CR>:nohlsearch<CR>

" vimscriptをその場で実行
nmap <silent><buffer> <M-e> "zyy:@z<CR>
vmap <silent><buffer> <M-e> "zy:@z<CR>

" ビルド
noremap <c-c> :!make<CR>
" python実行
noremap <c-p> :!python %<CR>

" visual modeに*の機能を設定 "
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

" 検索時にエスケープ文字を自動でつける "
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" AllMapsコマンド  "
" ================ "
" 現在のキーバインド一覧を作成 "
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args> 

" Captureコマンド "
function! s:cmd_capture(q_args) "{{{ 
	redir => output 
	silent execute a:q_args 
	redir END 
	let output = substitute(output, '^\n\+', '', '') 
	
	belowright new 
	
	silent file `=printf('[Capture: %s]', a:q_args)` 
	setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted 
	call setline(1, split(output, '\n')) 
endfunction "}}} 
command! -nargs=+ -complete=command Capture call s:cmd_capture(<q-args>) 

" 現在のバッファのリネーム
command! -nargs=1 -bang -bar -complete=file Rename sav<bang> <args> | call delete(expand('#:p'))

" タブで補間 "
"
"function InsertTabWrapper()
"  if pumvisible()
"    return "\<c-n>"
"  endif
"  let col = col('.') - 1
"    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
"      return "\<tab>"
"    elseif exists('&omnifunc') && &omnifunc == ''
"      return "\<c-n>"
"    else
"      return "\<c-x>\<c-o>"
"    endif
"endfunction
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" 

" パスを開く "
function ExplorerStart()
  let dir = expand("%:p:h")
  if has('win32')
    let directory=substitute(dir,"/","\\","g")
    let cmd = "start explorer /e,".directory
  elseif has('mac')
    let cmd = "open ".dir
  elseif has('unix')
    let cmd = "nautilus ".dir
  endif

  if has('job')
    let job = job_start(cmd)
  else
    execute "!".cmd
  endif
endfunction
inoremap <c-e> <ESC>:call ExplorerStart()<CR>
noremap  <c-e> <ESC>:call ExplorerStart()<CR>
 
" ￥ - Wで現在のファイルをFirefoxで開く "
function! OpenFirefox()
  let s:fname = expand("%:p")
  if has('Win32')
	execute "!start ".g:internetBrowser." \"".s:fname."\""
  endif
endfunction
noremap <leader>w <ESC>:call OpenFirefox()<CR> 

" 保存するフォルダがなければ自動で生成 "
augroup vimrc-auto-mkdir " {{{ 
  autocmd! 
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang) 
  function! s:auto_mkdir(dir, force) " {{{ 
	  if !isdirectory(a:dir) && (a:force || 
	  \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$') 
		  call mkdir(iconv(a:dir, &encoding, &termencoding), 'p') 
	  endif 
  endfunction " }}} 
augroup END " }}} 

" =================
" vim2Maya.vim Setting
" =================
vmap <c-m> :Vim2Maya<cr>
vmap <c-y> :Vim2MayaPython<cr>
noremap <M-y> :Vim2MayaCurFile<CR>

" =================
" L2R.vim Setting
" =================
vmap <M-m> :L2R<cr>

" ================= "
" 2html.vim setting "
" ================= "
let g:use_xhtml=1 
let g:html_use_css=1 
let g:html_no_pre=1
 
" ========================= "
" neocomplete.vim setting
" ========================= "
" 有効にする
let g:neocomplete#enable_at_startup = 1
" 大文字・小文字を区別しない
let g:neocomplete#enable_smart_case = 1
" 最初の補完候補を自動選択しない "
let g:neocomplete#enable_auto_select= 0
"ポップアップメニューで表示される候補の数。初期値は100
let g:neocomplete#max_list = 5
"手動補完時に補完を行う入力数を制御。値を小さくすると文字の削除時に重くなる
let g:neocomplete#manual_completion_start_length = 3
"バッファや辞書ファイル中で、補完の対象となるキーワードの最小長さ。初期値は4。
let g:neocomplete#min_keyword_length = 4
" 補間の最小文字数
let g:neocomplete#sources#syntax#min_keyword_length = 3
" 自動で補完をしない
let g:neocomplete#disable_auto_complete = 0 
" 辞書ファイル指定
let g:neocomplete#sources#dictionary#dictionaries = {'default':'', 'mel':'~/vimfiles/ftplugin/mel.dict'}

" TABで補完
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" 補完のundo処理
inoremap <expr><C-g> neocomplete#undo_completion()


" ========================= "
" unite.vim setting         "
" ========================= "
let g:unite_source_file_mru_filename_format = ''
"call unite#custom_max_candidates( 'file_mru', 100 )
imap <c-a> <ESC>:Unite file_mru<CR>
imap <c-b> <ESC>:Unite buffer<CR>
imap <c-c> <ESC>:Unite file<CR>

" ========================= "
" neomru.vim setting         "
" ========================= "
let g:neomru#file_mru_path=expand('~/vimfiles/mru_file')
let g:neomru#directory_mru_path=expand('~/vimfiles/mru_dir')

" ========================= "
" vimfiler.vim setting
" ========================= "
" キーマップ
" e  - ファイルを開く
" Q  - 閉じる
" yy - パスをコピー
" K  - 新規ディレクトリ作成
" N  - 新規ファイル作成
" ge - ファイラーでフォルダを開く
" c  - ファイルをコピー
" m  - ファイルを移動
" r  - ファイルをリネーム
" d  - ファイルを削除
"
imap <c-f> <ESC>:VimFilerExplorer<CR>
" vimfilerをデフォルトのファイラーとして使用
let g:vimfiler_as_default_explorer=1
" vimfilerでファイル操作を可能に
let g:vimfiler_safe_mode_by_default=0
" vimfilerで削除を行った場合ゴミ箱に入れる
let g:unite_kind_file_use_trashbox=1
" pycファイルは無視する
let g:vimfiler_ignore_pattern = "\%(\.pyc$\)"

" ========================= "
" vimshell.vim setting      "
" ========================= "
" windows環境ではlsが使えないので以下からunixコマンド一式をDLしてパスを通しておく
" http://gnuwin32.sourceforge.net/packages/coreutils.htm
" ========================= "
" プロンプト表示 "
let g:vimshell_user_prompt = 'getcwd()'
" vimshellを起動 "
nmap <M-x> <Plug>(vimshell_split_switch)
" vimShellに文字列を送信"
vmap <M-c> <ESC>:VimShellSendString<CR>
" pythonインタプリタをvimshellで起動"
nmap <M-p> <ESC>:VimShellInteractive python<CR>
" vimshell-history補完時のactionをexecuteからinsertに変更"
"call unite#custom_default_action("vimshell/history", "insert")

" ========================= "
" ref.vim setting
" ========================= "
function! s:ref_init()
	"let g:lynx_dir='D:/bin/lynx'
	let g:ref_use_vimproc = 1
	"let lynx=g:lynx_dir.'/lynx.exe'
	"let cfg=g:lynx_dir.'/lynx.cfg'

	"let g:ref_alc_cmd = lynx.' -cfg='.cfg.' -dump -nonumbers %s'
	""let g:ref_alc_cmd = 'lynx.exe -cfg='.cfg.' -dump -nonumbers %s'
	"let g:ref_alc_use_cache=1
	"let g:ref_alc_start_linenumber = 39 " 余計な行を読み飛ばす

	let g:ref_alc_encoding = 'Shift-JIS'
	" let g:ref_alc_encoding = 'utf-8'

	if exists('*ref#register_detection')
		" filetypeが分からんならalc
		call ref#register_detection('_', 'alc')
	endif

	"let g:ref_lynx_cmd = lynx.' -cfg='.cfg.' -dump %s'
	"let g:ref_lynx_cmd = g:ref_alc_cmd
	let g:ref_lynx_use_cache = 1
	let g:ref_lynx_encoding = 'Shift-JIS'
	let g:ref_lynx_start_linenumber = 0 " 余計な行を読み飛ばす
	" phpmanualの場所を指定する
	let g:ref_phpmanual_path = 'D:/phpmanual'
endfunction
call s:ref_init()

let g:ref_source_webdict_sites={
\	'wiki': 'http://ja.wikipedia.org/wiki/%s',
\	'mel' : 'http://download.autodesk.com/global/docs/maya2013/ja_JP/Commands/%s.html'
\}
let g:ref_source_webdict_sites.default='wiki'

" ========================= "
" jedi-vim setting
" ========================= "
" 自動で起動 "
let g:jedi#auto_initialization    = 1
let g:jedi#auto_vim_configuration = 0
" 
let g:jedi#rename_command      = "<leader>R"
" ドット挿入時に補完ポップアップを表示しない "
let g:jedi#popup_on_dot        = 0
" ポップアップ表示時に最初の項目を自動選択しない "
let g:jedi#popup_select_first  = 0
" ========================= "
" NERDtree.vim setting
" ========================= "
" NERDtreeをnetrwの代わりとして使わない "
let g:NERDTreeHijackNetrw=0
" pycは無視する
let g:NERDTreeIgnore=['\.pyc$']

" ========================= "
" quickrun.vim setting      "
" ========================= "
"
" ========================= "
" vim-template.vim setting
" ========================= "
let g:template_basedir='~/vimfiles/'
autocmd User plugin-template-loaded call s:template_keywords()
function s:template_keywords()
	silent! %s/<+DATE+>/\=strftime('%b-%d-%Y %H:%M:%S')/g
	silent! %s/<+USER+>/\=$USERNAME/g
endfunction

" テンプレート中に含まれる'<+CURSOR+>'にカーソルを移動
autocmd User plugin-template-loaded
    \   if search('<+CURSOR+>')
    \ |   silent! execute 'normal! "_da>'
    \ | endif

" ========================= "
" tagbar setting
" ========================= "
noremap tt :TagbarToggle<CR>

" ========================= "
" im_control.vim setting
" ========================= "

" ========================= "
" syntastic setting
" ========================= "
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args = '--ignore="E221,E241,E271,E501"'
" ========================= "
" ropevim.vim setting      "
" ========================= "
" リファクタリング
" リネーム
" :RopeRename
" :RopeExtractMethod 
" :RopeUndo

" ========================= "
" airline setting
" ========================= "
" powerline用のフォントを使用
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
" ファイル名のみ表示
let g:airline_section_c = '%t'
" syntasticのメッセージを表示しない
let g:airline#extensions#syntastic#enabled = 0
let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'V',
  \ 'V'  : 'V',
  \ '' : 'V',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ }

" ネットサービス・パスワード関係 "
if filereadable("password.vim")
	source ~/password.vim
endif
