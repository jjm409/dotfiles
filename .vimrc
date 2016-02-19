" Start pathogen and load plugins
execute pathogen#infect()

let g:NERDTreeDirArrows=0

" Settings for Certain File Types
" autocmd BufRead,BufNewFile *.TRN,*.BPN,*.log set autoread
autocmd BufRead,BufNewFile *.TRN set filetype=TranTrace
" autocmd BufRead,BufNewFile *.TRN,*.BPN,*.log set display+=lastline

" Default Setting Changes
set number
set backspace=2
set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set smarttab
set autoindent
set smartindent
set laststatus=2
set splitbelow
set splitright
set guioptions-=m 
set guioptions-=L
set hidden
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let mapleader = ","
syntax on
filetype plugin on

set clipboard=unnamedplus


" NERDTREE Explorer Shortcut
nmap <Leader>nt :NERDTreeToggle<CR>

" Syntastic Check plugin Shortcuts
nmap <Leader>sc :SyntasticCheck<CR>
nmap <Leader>st :SyntasticToggleMode<CR>


" Shortcut for removing all newline characters from a file
nmap <Leader>nl :%s/\n//g<CR>

" Vimrc Shortcuts
nmap <Leader>sr :source $MYVIMRC<CR>
nmap <Leader>vrc :tabedit $MYVIMRC<CR>

" Window Managment and Movement Shortcusts
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>

" nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Toggle File Toolbar
nnoremap <Leader>tt :if &go=~'m'<bar>set go-=m<bar>else<bar>set go+=m<bar>endif<cr>

" Auto Relaod Document
map <Leader>rf :setlocal autoread <CR>

" Select All Visual
map <Leader>sa ggVG

" Delete without yanking
map <Leader>da "_d 

" EasyMotion shortcuts
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
nmap s <Plug>(easymotion-s)

"Tagbar Shorcut
nmap <Leader>tb :TagbarToggle<CR>

" FormatXML Shorcuts
nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

" Tab/Shift-Tab Visual Increment
vmap <Tab> >gv
vmap <S-Tab> <gv

"NerdComment Shortcuts
map <leader>cc NERDComComment
map <leader>cs NERDComSexyComment
map <leader>cu NERDComUncommentLine

" Automatic Closing Brackets and Parenthesis
inoremap ( ()<Esc>i
inoremap { {<CR><BS>}<Esc>ko

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>

" XML formatter
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')
	
	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()





