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
set laststatus=3 " statusbar
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
" editing
Plug 'tpope/vim-sensible' " sensible defaults
Plug 'tpope/vim-unimpaired' " some simple shortcuts for navigation, e.g. ]g and [g for next/prev in cwindow
Plug 'tpope/vim-repeat' " repeat commands like above w/ .
Plug 'tpope/vim-commentary' " adds shortcuts for commenting/uncommenting lines
Plug 'tpope/vim-surround' " surround ranges with (){}[] etc.
Plug 'Raimondi/delimitMate' " auto-add closing match to (){}[] etc...
Plug 'sheerun/vim-polyglot' " tons of language syntax definitions
Plug 'neoclide/coc.nvim', {'branch': 'release'} " The ultimate auto-complete language server based plugin for vim
Plug 'bfredl/nvim-miniyank' " Allows for a history of yank commands
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" ui improvements
Plug 'mbbill/undotree' " Show a sidebar w/ undo history (incl branches)
Plug 'nvim-tree/nvim-web-devicons'
Plug 'Yggdroot/indentLine' " Shows indent line bars for reference
Plug 'itchyny/lightline.vim' " Colorful and configurable status bar line
Plug 'psliwka/vim-smoothie' " Make paging up and down scroll smoothly
Plug 'christoomey/vim-tmux-navigator' " Use window nav vim shortcuts seamlessly with tmux windows as well
" git
Plug 'tpope/vim-fugitive' " git commands in vim
Plug 'airblade/vim-gitgutter' " Show +-~ in gutter
Plug 'junegunn/gv.vim' " Show and browse git history in a new tab (requires vim-fugitive)
" files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy find in vim (this and below)
Plug 'junegunn/fzf.vim'
Plug 'dbeniamine/todo.txt-vim' " todo.txt shortcuts
Plug 'meanderingprogrammer/render-markdown.nvim' " Instant markdown preview
" ai tools
Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
" Plug 'github/copilot.vim' " Copilot
" Plug 'robitx/gp.nvim' " AI chat plugin
Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }
" theme plugins
Plug 'tinted-theming/base16-vim' " theme
Plug 'mike-hearn/base16-vim-lightline' " theme
Plug 'tribela/transparent.nvim'
Plug 'atelierbram/Base4Tone-nvim' " theme
" Plug 'atelierbram/Base4Tone-vim' " theme
" Plug 'morhetz/gruvbox'
call plug#end()

" colorscheme
set background=dark
colorscheme base4tone_modern_w_dark
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
      \ 'colorscheme': 'base16_bright',
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

" gp.nvim
" lua require'gp'.setup {
"       \ providers = {
"       \   openai = {},
"       \   copilot = { 
"       \		  disable = false, 
"       \		  endpoint = "https://api.githubcopilot.com/chat/completions", 
"       \		  secret = { 
"       \		  	"bash", 
"       \		  	"-c", 
"       \		  	"cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'", 
"       \		  }, 
"       \   },
"       \	}, 
"       \ whisper = {
"       \   disable = true,
"       \ }
"       \ }

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
" nmap <leader>a  <Plug>(coc-codeaction-selected)

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

" avante
autocmd! User avante.nvim lua require('avante_lib').load()
lua << EOF 
require('avante').setup({
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "claude", -- Recommend using Claude
  auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-5-sonnet-20241022",
    temperature = 0,
    max_tokens = 4096,
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
  mappings = {
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    ---@type "right" | "left" | "top" | "bottom"
    position = "right", -- the position of the sidebar
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window, only effective if floating = true.
      border = "rounded",
    },
  },
  highlights = {
    ---@type AvanteConflictHighlights
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
  },
})
EOF

" Run jest for current project
command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

" Run jest for current file
command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])
nnoremap <leader>T :call CocAction('runCommand', 'jest.fileTest', ['%'])<CR>

" Run jest for current test
nnoremap <leader>t :call CocAction('runCommand', 'jest.singleTest')<CR>

" Init jest in current cwd, require global jest command exists
command! JestInit :call CocAction('runCommand', 'jest.init')
