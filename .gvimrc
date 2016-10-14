highlight SpecialKey guifg=#343434 guibg=#242424 
highlight NonText guifg=#343434 guibg=#242424   

" タブ設定 "
set guitablabel=%N\ %t%m 
colorscheme solarized

set guioptions-=m 
set guioptions-=T 
set linespace=6 

if has('win32') || has('win64') || has('win') 
	set shell=CMD.exe 
	set shellcmdflag=/c 
	"set guifont=VL_Gothic_Regular:h12
	set guifont=Ricty_Regular:h14
endif 
if has('Mac') 
	set guifont=Osaka-Mono:h14 
	autocmd GUIEnter * winsize 135 46 
endif
if has('unix') 
	set guifont=Ricty\ for\ Powerline\ 14
	set guioptions-=mT 
	" enable right click menu
	set mousemodel=popup_setpos
	" customize Solarized theme
	hi SpecialKey guibg=#002b36 
endif

