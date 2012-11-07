
call pathogen#infect()

colorscheme wombat

set swapfile
set dir=~/vimTemp

set nocompatible
set guioptions-=T
set guioptions-=r
set guioptions-=L " scrollbar

set number
set cursorline
syntax enable

set tabstop=3
"set expandtab
set shiftwidth=3
set ruler
set mouse=a
set hlsearch
set hidden
set guifont=Monospace\ 9
set backspace=indent,eol,start
set autoindent
set showmatch
set scrolloff=6
set incsearch
set textwidth=120
set completeopt=menu,menuone,longest,preview
filetype indent on
filetype plugin on


set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
let g:Powerline_symbols='fancy'
let g:Powerline_theme='skwp'
let g:Powerline_colorscheme='skwp'


" Toggle Gundo window
nnoremap <F5> :GundoToggle<CR>

" Hilight illegally long lines (120 char)
au BufRead,BufNewFile * highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au BufRead,BufNewFile * syntax match OverLength /\%121v.\+/

au BufRead,BufNewFile * highlight Tab gui=underline guifg=#295929 ctermbg=darkgrey
au BufRead,BufNewFile * syntax match Tab /\t/

au BufRead,BufNewFile *.c,*.cpp,*.h,*.hpp highlight BadBrackets  ctermbg=red ctermfg=white guibg=red
au BufRead,BufNewFile *.c,*.cpp,*.h,*.hpp syntax match BadBrackets /\w.*{\|{.*\w/

au BufRead,BufNewFile * highlight ExtraWhitespace ctermbg=red guibg=#292959
au BufRead,BufNewFile * syntax match ExtraWhitespace /\s\+$/

"autocmd BufWinEnter,InsertLeave * syntax match ExtraWhitespace /\s\+$/
"autocmd InsertEnter * syntax match ExtraWhitespace /\s\+\%#\@<!$/
"autocmd BufWinLeave * call clearmatches()
"au BufRead,BufNewFile *.log hi sql guifg=white guibg=red ctermfg=white ctermbg=red
"au BufRead,BufNewFile *.log syn match sql /"\zssql_\w*\ze"/
"
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>

function! ToggleBadBrackets()
	if !exists('b:bb_show')
		let b:bb_show = 1
	endif
	let b:bb_show = !b:bb_show
	if b:bb_show
		syntax match BadBrackets /\w.*{\|{.*\w/
		syntax match ExtraWhitespace /\s\+$/
		syntax match OverLength /\%121v.\+/
	else
		syntax clear BadBrackets
		syntax clear ExtraWhitespace
		syntax clear OverLength
	endif
endfunction

nnoremap <Leader>bb :call ToggleBadBrackets()<CR>

nnoremap <C-w><C-k> <C-w><C-k><C-w><C-_>
nnoremap <C-w><C-j> <C-w><C-j><C-w><C-_>
nnoremap <C-w><C-h> <C-w><C-h><C-w>120\|
nnoremap <C-w><C-l> <C-w><C-l><C-w>120\|

nnoremap <Leader>= :Tabularize /=<CR>
vnoremap <Leader>= :Tabularize /=<CR>

nnoremap <Tab> :FufBuffer<CR>
nnoremap <S-Tab> :FufFileWithCurrentBufferDir<CR>

let g:vimwiki_browsers=['firefox']

function! InsertRTLink()
	.!echo % | sed 's/.*TicketNo\(.*\)\.wiki/Link: http:\/\/rt\/Ticket\/Display\.html\?id=\1/' 
endfunction

nnoremap <Leader># ggO<Esc>:call InsertRTLink()<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>






"log: fixed exchanges with the first word of the line

" $Id$
" author: Luc Hermitte
let s:k_version = 200
if &cp || (exists('g:loaded_swap_words') 
      \ && (g:loaded_swap_words >= s:k_version)
      \ && !exists('g:force_reload_vim_tip_swap_word'))
  finish 
endif
let g:swap_word_loaded = 1

" ======================================================================
" Tip #329 -> gw
" -> http://vim.wikia.com/wiki/Swapping_characters%2C_words_and_lines

" Swap the current word with the next, without changing cursor position
" nnoremap <silent> gw "_yiw:silent s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr>:PopSearch<cr><c-o>
" "left" would respect the old behaviour, but let's use "follow" instead!
nnoremap <silent> gw :call <sid>SwapWithNext('follow', 'w')<cr>

" nnoremap <silent> gW "_yiw:silent s/\(\w\+\)\(\W\+\)\(\%#\w\+\)/\3\2\1/<cr>:PopSearch<cr><c-o>
nnoremap <silent> gW :call <sid>SwapWithPrev('follow', 'w')<cr>

" Swap the current word with the previous, keeping cursor on current word:
" (This feels like "pushing" the word to the left.) 
" nnoremap <silent> gl "_yiw?\w\+\_W\+\%#<CR>:PopSearch<cr>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:PopSearch<cr><c-o><c-l>
nnoremap <silent> gl :call <sid>SwapWithPrev('left', 'w')<cr>

" Swap the current word with the next, keeping cursor on current word: (This
" feels like "pushing" the word to the right.) (See note.)
" nnoremap <silent> gr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>:PopSearch<cr><c-o>/\w\+\_W\+<CR>:PopSearch<cr>
nnoremap <silent> gr :call <sid>SwapWithNext('right', 'w')<cr>


" the same, but with keywords
" nnoremap <silent> gs "_yiw:silent s/\(\%#\k\+\)\(.\{-}\)\(\k\+\)/\3\2\1/<cr>:PopSearch<cr><c-o>
" nmap     <silent> gS "_yiw?\k?<cr>gs
nnoremap <silent> gs :call <sid>SwapWithNext('follow', 'k')<cr>
nnoremap <silent> gS :call <sid>SwapWithPrev('follow', 'k')<cr>

" Then when you put the cursor on or in a word, press "gw", and 
" the word will be swapped with the next word.  The words may 
" even be separated by punctuation (such as "abc = def"). 
" gW will swap with previous word.

" While we're talking swapping, here's a map for swapping characters: 

nnoremap <silent> gc    xph 

" This hint was formed in a collaboration between 
" Chip Campbell - Arun Easi - Benji Fisher
"
" ======================================================================
" Tip #470 : Piet Delport & Anthony (ad_scriven)
vnoremap <silent> g" <esc>:call <sid>SwapVisualWithCut()<cr>
vnoremap <silent> g' <esc>:call <sid>SwapVisualWithCut2()<cr>

function! s:SwapVisualWithCut()
  normal! `.``
  if line(".")==line("'.") && col(".") < col("'.")
    let c = col('.')
    normal! gvp```]
    let c = col('.') - c
    normal! ``
    :silent call cursor(line("."),col(".")+c)
    normal! P
  else
    normal! gvp``P
  endif
endfunction

function! s:SwapVisualWithCut2()
  let v_s = col("'<")
  let v_e = col("'>")
  if line("'<")==line("'.") && v_s < col("'.")
    let l = line("'.")
    let c = col("'.") - 1
    let deleted = @"
    let line = getline(l)

    let line_2 = (v_s > 1 ? line[ : v_s-1] : '')
	  \. deleted 
	  \. line[v_e : c-1]
	  \. line[v_s : v_e-1]
	  \. line[c : ]
    normal! u
    call setline(l, line_2)
    echomsg "spe"
  else
    normal! `.``
    normal! `.``gvp``P
    echomsg "default"
  endif
endfunction

function! s:SwapVisualWithCut3()
  let deleted = @"

  let v_s = getpos("'<")
  let v_e = getpos("'>")
  let d_s = getpos("'.")

  if d_s[1] == v_s[1] " same line
    let line = getline(d_s[1])
    let c = d_s[2] - 1
  endif
  if line("'<")==line("'.") && v_s < col("'.")
    let l = line("'.")
    let c = col("'.") - 1

    let line_2 = (v_s > 1 ? line[ : v_s[2]-1] : '')
	  \. deleted 
	  \. line[v_e[2] : c-1]
	  \. line[v_s[2] : v_e[2]-1]
	  \. line[c : ]
    normal! u
    call setline(d_s[1], line_2)
    echomsg "same line"
  else
    normal! `.``
    normal! `.``gvp``P
    echomsg "default"
  endif
endfunction

" ======================================================================
" LH, 27th Apr 2010
" Swap functions with no side effect on the search history or on the screen.
" Moreover, when undone, these version put the cursor back to its first
" position

" Function: SwapWithNext(cursor_pos)
" {cursor_pos} values:
" 'keep' : stays at the same position
" 'follow' : stays with the current word, at the same relative offset
" 'right' : put the cursor at the start of the new right word
" 'left' : put the cursor at the start of the new left word
" todo: move to an autoplugin
" todo: support \w or \k ...


let s:k_entity_pattern = {}
let s:k_entity_pattern.w = {}
let s:k_entity_pattern.w.in = '\w'
let s:k_entity_pattern.w.out = '\W'
let s:k_entity_pattern.w.prev_end = '\zs\w\W\+$'
let s:k_entity_pattern.k = {}
let s:k_entity_pattern.k.in = '\k'
let s:k_entity_pattern.k.out = '\k\@!'
let s:k_entity_pattern.k.prev_end = '\k\(\k\@!.\)\+$'


function! s:SwapWithNext(cursor_pos, type)
  let s = getline('.')
  let l = line('.')
  let c = col('.')-1
  let in  = s:k_entity_pattern[a:type].in
  let out = s:k_entity_pattern[a:type].out

  let crt_word_start = match(s[:c], in.'\+$')
  let crt_word_end  = match(s, in.out, crt_word_start)
  if crt_word_end == -1
    throw "No next word to swap the current word with"
  endif
  let next_word_start = match(s, in, crt_word_end+1)
  if next_word_start == -1
    throw "No next word to swap the current word with"
  endif
  let next_word_end  = match(s, in.out, next_word_start)
  let crt_word = s[crt_word_start : crt_word_end]
  let next_word = s[next_word_start : next_word_end]

  " echo  '['.crt_word_start.','.crt_word_end.']='.crt_word 
  " \   .'### ['.next_word_start.','.next_word_end.']='.next_word
  let s2 = (crt_word_start>0 ? s[:crt_word_start-1] : '')
        \ . next_word
        \ . s[crt_word_end+1 : next_word_start-1]
        \ . crt_word 
        \ . (next_word_end==-1 ? '' : s[next_word_end+1 : -1])
  " echo s2
  call setline(l, s2) 
  if     a:cursor_pos == 'keep'   | let c2 = c+1
  elseif a:cursor_pos == 'follow' | let c2 = c + strlen(next_word) + (next_word_start-crt_word_end)
  elseif a:cursor_pos == 'left'   | let c2 = crt_word_start+1
  elseif a:cursor_pos == 'right'  | let c2 = strlen(next_word) + next_word_start - crt_word_end + crt_word_start
  endif
  call cursor(l,c2)
endfunction

" Function: SwapWithPrev(cursor_pos)
" {cursor_pos} values:
" 'keep' : stays at the same position
" 'follow' : stays with the current word, at the same relative offset
" 'right' : put the cursor at the start of the new right word
" 'left' : put the cursor at the start of the new left word
" todo: move to an autoplugin
function! s:SwapWithPrev(cursor_pos, type)
  let s = getline('.')
  let l = line('.')
  let c = col('.')-1
  let in  = s:k_entity_pattern[a:type].in
  let out = s:k_entity_pattern[a:type].out
  let prev_end = s:k_entity_pattern[a:type].prev_end

  let crt_word_start = match(s[:c], in.'\+$')
  if crt_word_start == -1
    throw "No previous word to swap the current word with"
  endif
  let crt_word_end  = match(s, in.out, crt_word_start)
  let crt_word = s[crt_word_start : crt_word_end]

  let prev_word_end = match(s[:crt_word_start-1], prev_end)
  let prev_word_start = match(s[:prev_word_end], in.'\+$')
  if prev_word_end == -1
    throw "No previous word to swap the current word with"
  endif
  let prev_word = s[prev_word_start : prev_word_end]

  " echo  '['.crt_word_start.','.crt_word_end.']='.crt_word 
  " \   .'### ['.prev_word_start.','.prev_word_end.']='.prev_word
  let s2 = (prev_word_start>0 ? s[:prev_word_start-1] : '')
        \ . crt_word 
        \ . s[prev_word_end+1 : crt_word_start-1]
        \ . prev_word
        \ . (crt_word_end==-1 ? '' : s[crt_word_end+1 : -1])
  " echo s2
  call setline(l, s2) 
  if     a:cursor_pos == 'keep'   | let c2 = c+1
  elseif a:cursor_pos == 'follow' | let c2 = prev_word_start + c - crt_word_start + 1 
  elseif a:cursor_pos == 'left'   | let c2 = prev_word_start+1
  elseif a:cursor_pos == 'right'  | let c2 = strlen(crt_word) + crt_word_start - prev_word_end + prev_word_start
  endif
  call cursor(l,c2)
endfunction




let g:clang_use_library = 1
let g:clang_library_path = "/usr/people/daniel-ho/install/lib/clang"
