set nocompatible            
filetype off               

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" you can pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

Plugin 'vim-scripts/indentpython.vim'
Plugin 'tmhedberg/SimpylFold'
Bundle 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plugin 'rhysd/vim-clang-format'

" All of your Plugins must be added before the following line
call vundle#end()            
filetype plugin indent on   

" Set line numbers + set to split windows right
set number
set splitright

" Keymaps to move between windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

set tabstop=4

au BufNewFile,BufRead *.py:
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Encoding
set encoding=utf-8

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Syntax Highlighting
let python_highlight_all=1
syntax on

colorscheme onedark

call togglebg#map("<F5>")

" Hide .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Toggle syntastic
function! ToggleSyntastic()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor
    SyntasticCheck
endfunction

nnoremap <F8> :call ToggleSyntastic()<CR>

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Autoclose errors
autocmd QuitPre * if empty(&bt) | lclose | endif

" Clang format options
let g:clang_format#command = "/usr/bin/clang-format-12"
let g:clang_format#auto_format = 1
let g:clang_format#style_options = {
	\ "AlwaysBreakTemplateDeclarations" : "true",
	\ "AccessModifierOffset" : -4,
	\ "Standard" : "c++14",
   	\ "ColumnLimit": 100,
	\ "AllowShortFunctionsOnASingleLine" : "Empty",
	\ "AllowShortBlocksOnASingleLine" : "Empty",
	\ "BreakBeforeBraces" : "Attach",
	\ "BraceWrapping" : {
	\   "AfterControlStatement" : "Always",
	\   "AfterEnum" : "true",
	\ }, 
	\ "BasedOnStyle": "Google", }

" Map for autoformat
nmap <F3> :ClangFormat<Enter>

" Python run
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!gnome-terminal -- python -i' shellescape(@%, 1)<Enter><CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!gnome-terminal -- python -i' shellescape(@%, 1)<Enter><CR>
