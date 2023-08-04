" config.vim
"- Brandon Moon

set nocompatible " Needed for some plugins to work
set linebreak " Allow linebreaks (I like this)
set noshowmode " Don't show the mode at bottom (it's in lightline)
" Indendation 
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
" UI
set title
set number 
set cursorline
set ruler
set mouse=""
set laststatus=2 " statusbar
" Misc
set ignorecase
set smartcase
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat=%f:%l:%c:%m,%f:%l:%m
set nolist
set formatoptions=tcrq
set updatetime=10
set autoread
set autowriteall " Automatically save buffers when navigating away
set hidden
set signcolumn=yes
set shortmess+=c
set termguicolors
" Re-map jj to act as Esc press in insert mode
inoremap jj <Esc>
" Re-map Ctrl-s to save
nnoremap <silent> <C-s> :write<CR>
" Plugins
" Install vim-plug for vim and neovim
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible' " sensible defaults
Plug 'tpope/vim-commentary' " adds shortcuts for commenting/uncommenting lines
Plug 'tpope/vim-surround' " surround ranges with (){}[] etc.
Plug 'tpope/vim-unimpaired' " some simple shortcuts for navigation, e.g. ]g and [g for next/prev in cwindow
Plug 'tpope/vim-repeat' " repeat commands like above w/ .
Plug 'tpope/vim-fugitive' " git commands in vim
Plug 'sheerun/vim-polyglot' " tons of language syntax definitions
Plug 'jiangmiao/auto-pairs' " auto-add closing match to (){}[] etc...
Plug 'Yggdroot/indentLine' " Shows indent line bars for reference
Plug 'itchyny/lightline.vim' " Colorful and configurable status bar line
Plug 'airblade/vim-gitgutter' " Show +-~ in gutter
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy find in vim (this and below)
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " The ultimate auto-complete language server based plugin for vim
Plug 'mbbill/undotree' " Show a sidebar w/ undo history (incl branches)
Plug 'junegunn/gv.vim' " Show and browse git history in a new tab (requires vim-fugitive)
Plug 'psliwka/vim-smoothie' " Make paging up and down scroll smoothly
Plug 'dbeniamine/todo.txt-vim' " todo.txt shortcuts
Plug 'preservim/nerdtree' | " File browser sidebar
                  \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'bfredl/nvim-miniyank' " Allows for a history of yank commands
Plug 'honza/vim-snippets' " A library of auto-compolete snippets
Plug 'christoomey/vim-tmux-navigator' " Use window nav vim shortcuts seamlessly with tmux windows as well
Plug 'tinted-theming/base16-vim' " theme
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()
" indent line
let g:indentLine_char = '┆'
"lightline
function! LightLineGitBlame() 
  return get(g:, 'coc_git_status', '')
endfunction
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'git' ],
      \             [ 'readonly', 'filename','modified' ] ],
      \   'right': [ ['cocstatus'],
      \              ['filetype', 'percent', 'lineinfo'] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'git': 'LightLineGitBlame',
      \ },
      \ }
" colorscheme
if exists('$BASE16_THEME')
    \ && (!exists('g:colors_name') 
    \ || g:colors_name != 'base16-$BASE16_THEME')
  let base16colorspace=256
  colorscheme base16-$BASE16_THEME
endif
" fzf
nnoremap <silent> P :GFiles<CR>
nnoremap <silent> K :Rg<CR>
" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" let g:NERDTreeMinimalMenu = 1 " workaround for bottom area resize issue
" undo tree
if has("persistent_undo")
  set undofile
endif
" === CoC ===
" List of extensions to install
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ 'coc-marketplace',
      \ 'coc-highlight',
      \ 'coc-syntax',
      \ 'coc-tag',
      \ 'coc-emoji',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-sql',
      \ 'coc-snippets',
      \ 'coc-git',
      \ 'coc-yank',
      \ 'coc-lists',
      \]
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use M to show documentation in preview window.
nnoremap <silent> M :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" coc-snippet mappings
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
imap <C-j> <Plug>(coc-snippets-expand-jump)
xmap <leader>x <Plug>(coc-convert-snippet)
" coc tab autocomplete
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
" === ===
" Todo.txt setup
au filetype todo setlocal omnifunc=todo#Complete
au filetype todo imap <buffer> + +<C+Z><C-O>
au filetype todo imap <buffer> @ @<C+Z><C-O>
" miniyank
map p <Plug>(miniyank-autoput)
map <leader>p <Plug>(miniyank-startput)
map <leader>P <Plug>(miniyank-startPut)
map <leader>n <Plug>(miniyank-cycle)
map <leader>N <Plug>(miniyank-cycleback)
" treesitter
lua require'nvim-treesitter.configs'.setup {
      \highlight = {
      \enable = true,
      \}
      \}
