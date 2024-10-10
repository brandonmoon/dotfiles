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
Plug 'Raimondi/delimitMate' " auto-add closing match to (){}[] etc...
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
Plug 'bfredl/nvim-miniyank' " Allows for a history of yank commands
Plug 'christoomey/vim-tmux-navigator' " Use window nav vim shortcuts seamlessly with tmux windows as well
Plug 'tinted-theming/base16-vim' " theme
Plug 'atelierbram/Base4Tone-nvim' " theme
Plug 'atelierbram/Base4Tone-vim' " theme
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
Plug 'nvim-tree/nvim-web-devicons'
Plug 'suan/vim-instant-markdown' " Instant markdown preview
Plug 'tribela/transparent.nvim'
call plug#end()

" colorscheme
set background=dark
colorscheme Base4Tone_Modern_N_Dark
" if exists('$BASE16_THEME')
"     \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
"   let base16_colorspace=256
"   colorscheme base16-$BASE16_THEME
" endif

"indent line
let g:indentLine_char = '┆'

"lightline
function! LightLineGitBlame() 
  return get(g:, 'coc_git_status', '')
endfunction
function! LightlineMode() abort
    let ftmap = {
                \ 'coc-explorer': 'EXPLORER',
                \ 'fugitive': 'FUGITIVE'
                \ }
    return get(ftmap, &filetype, lightline#mode())
endfunction
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'git' ],
      \             [ 'readonly', 'filename','modified' ] ],
      \   'right': [ ['cocstatus'],
      \              ['codeium'],
      \              ['filetype', 'percent', 'lineinfo'] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'codeium': 'codeium#GetStatusString',
      \   'git': 'LightLineGitBlame',
      \   'mode': 'LightlineMode'
      \ },
      \ 'colorscheme': 'Base4Tone_Modern_N',
      \ }

" fzf
nnoremap <silent> P :GFiles<CR>
nnoremap <silent> K :Rg<CR>

" undo tree
if has("persistent_undo")
  set undofile
endif

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

" ========== CoC ==========
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

" Use M to show documentation in preview window
nnoremap <silent> M :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('M', 'in')
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
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ CheckBackspace() ? "\<TAB>" :
"       \ coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

let g:coc_snippet_next = '<tab>'
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" coc-explorer
nmap <leader>e :CocCommand explorer<CR>
nmap <Leader>er <Cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>
autocmd ColorScheme *
  \ hi CocExplorerNormalFloatBorder guifg=#414347 guibg=#272B34
  \ | hi CocExplorerNormalFloat guibg=#272B34
  \ | hi CocExplorerSelectUI guibg=blue
let g:indentLine_fileTypeExclude=['coc-explorer']

" Run jest for current project
command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

" Run jest for current file
command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])
nnoremap <leader>T :call CocAction('runCommand', 'jest.fileTest', ['%'])<CR>

" Run jest for current test
nnoremap <leader>t :call CocAction('runCommand', 'jest.singleTest')<CR>

" Init jest in current cwd, require global jest command exists
command! JestInit :call CocAction('runCommand', 'jest.init')
