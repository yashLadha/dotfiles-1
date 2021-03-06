" floating window
set wildmode=longest:list,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,node_modules
set pumblend=20

if has("autocmd")
" Highlight TODO, FIXME, NOTE, etc.
autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|BUG\|HACK\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
endif

" Terminal settings

augroup neovim_terminal
	autocmd!

	" Disables number lines on terminal buffers
	autocmd TermOpen * :setl nonumber norelativenumber
augroup END

au TermEnter * setlocal scrolloff=0
au TermEnter * setlocal scrollback=1000
au TermLeave * setlocal scrolloff=5

command! -nargs=+ -complete=dir -bar Grep lua require'grep'.asyncGrep(<q-args>)

function! s:hlyank(operator, regtype, inclusive) abort
    if a:operator !=# 'y' || a:regtype ==# ''
        return
    endif

    let bnr = bufnr('%')
    let ns = nvim_create_namespace('')
    call nvim_buf_clear_namespace(bnr, ns, 0, -1)

    let [_, lin1, col1, off1] = getpos("'[")
    let [lin1, col1] = [lin1 - 1, col1 - 1]
    let [_, lin2, col2, off2] = getpos("']")
    let [lin2, col2] = [lin2 - 1, col2 - (a:inclusive ? 0 : 1)]
    for l in range(lin1, lin1 + (lin2 - lin1))
        let is_first = (l == lin1)
        let is_last = (l == lin2)
        let c1 = is_first || a:regtype[0] ==# "\<C-v>" ? (col1 + off1) : 0
        let c2 = is_last || a:regtype[0] ==# "\<C-v>" ? (col2 + off2) : -1
        call nvim_buf_add_highlight(bnr, ns, 'TextYank', l, c1, c2)
    endfor
    call timer_start(500, {-> nvim_buf_is_valid(bnr) && nvim_buf_clear_namespace(bnr, ns, 0, -1)})
endfunc

highlight default link TextYank IncSearch
autocmd TextYankPost * call s:hlyank(v:event.operator, v:event.regtype, v:event.inclusive)


nnoremap  ]z :call NextClosedFold('j')<cr>
nnoremap  [z :call NextClosedFold('k')<cr>

function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction


function! Osc52Yank()
    let buffer=system('base64 -w0 ', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer)." > ".shellescape($NVIM_TTY)
endfunction
command! Osc52CopyYank call Osc52Yank()
augroup Example
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END

autocmd FileType text,markdown
    \ setlocal spell  |
    \ set spelllang=en_gb |
    \ setl noai nocin nosi inde= |
    \ setl smartindent |
    \ setl conceallevel=0 |
    \ inoremap <C-c> <c-g>u<Esc>[s1z=`]a<c-g>u |

set dir^=$HOME/.config/nvim//storage/swaps//
set undodir^=$HOME/.config/nvim/storage/undos//
set backupdir^=$HOME/.config/nvim//storage/backups//

" folding
autocmd BufWrite * mkview
autocmd BufRead * silent! loadview

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess=actI
set signcolumn=yes


" tab
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
set expandtab
autocmd filetype lua,javascript,vue setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
set shiftround " round indent to a multiple of 'shiftwidth'
set nowrap
set nolinebreak
set textwidth=0 
set wrapmargin=0


autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
cnoremap <c-n> <down>
cnoremap <c-p> <up>

set nofoldenable
set laststatus=2
set showtabline=2
set conceallevel=0
set termguicolors
set complete=.,w,b,u,t,kspell
set encoding=utf8
set ttyfast
set lazyredraw
set synmaxcol=200
set cul!
set noerrorbells
set visualbell
set t_vb=
set tm=500
set autoread
set backspace=indent,eol,start
set shellpipe=>
set ruler
set history=100
set splitbelow splitright
set wildmenu
set ignorecase
set cursorline
set hlsearch
set noincsearch
set so=5
set bg=dark
set relativenumber
set mouse=v
set t_Co=256
set ai
set si
