syntax on

let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"

set title
set encoding=utf-8
set nohlsearch
set ff=unix
set ffs=unix
set t_Co=256
set ignorecase
set hidden
set wildmenu wildmode=full
set nocompatible
set relativenumber
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile
set incsearch
set splitbelow
set colorcolumn=90
set mouse=a
set autoread
set autowrite
set showcmd

call plug#begin('~/.nvim/plugged')

Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': 'npm install' }
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim'
Plug 'fisadev/fisa-vim-colorscheme'
Plug 'ryanoasis/vim-devicons'
Plug 'tweekmonster/gofmt.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'vuciv/vim-bujo'
Plug 'tpope/vim-dispatch'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'posva/vim-vue'
Plug 'tomtom/tcomment_vim'
Plug 'henrik/vim-qargs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'andymass/vim-matchup'
" Plug 'shmargum/vim-sass-colors'
Plug 'gko/vim-coloresque'
Plug 'ap/vim-buftabline'
Plug 'nicklasos/vimphphtml'
Plug 'turbio/bracey.vim', { 'do': 'npm i --prefix server' }
Plug 'makerj/vim-pdf'
Plug 'tpope/vim-haml'
Plug 'APZelos/blamer.nvim'
Plug 'puremourning/vimspector'
Plug 'akinsho/nvim-toggleterm.lua'
Plug 'lervag/vimtex'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && chmod +x ./install.sh && ./install.sh' }
Plug 'bingaman/vim-sparkup'
" Plug 'pocco81/auto-save.nvim'
call plug#end()

let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-xelatex',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull',
      \]

" let g:clipboard = {
"   \ 'name': 'WslClipboard',
"   \ 'copy': {
"   \   '+': '/mnt/c/Users/guilherme.smethurst/Downloads/win32yank.exe -i --crlf',
"   \   '*': '/mnt/c/Users/guilherme.smethurst/Downloads/win32yank.exe -i --crlf'
"   \ },
"   \ 'paste': {
"   \   '+': '/mnt/c/Users/guilherme.smethurst/Downloads/win32yank.exe -o --lf',
"   \   '*': '/mnt/c/Users/guilherme.smethurst/Downloads/win32yank.exe -o --lf',
"   \ },
"   \ 'cache_enabled': 0
" \}

tnoremap <silent> <C-q> <C-\><C-n>

let g:vimspector_enable_mappings = 'HUMAN'

nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

" customize the UI to add Fkeys
" Set the basic sizes
let g:vimspector_sidebar_width = 80
let g:vimspector_code_minwidth = 85
let g:vimspector_terminal_minwidth = 75

function! s:CustomiseWinBar()
        call win_gotoid( g:vimspector_session_windows.code )
        echo g:vimspector_session_windows.code
        " Clear the existing WinBar created by VimspectorS
        nunmenu WinBar
        nnoremenu WinBar.■\ Stop\(F3\) :call vimspector#Stop( { 'interactive': v:false } )<CR>
        nnoremenu WinBar.▶\ Cont\(F5\) :call vimspector#Continue()<CR>
        nnoremenu WinBar.▷\ Pause\(F6\) :call vimspector#Pause()<CR>
        nnoremenu WinBar.↷\ Next\(F10\) :call vimspector#StepOver()<CR>
        nnoremenu WinBar.→\ Step\(F11\) :call vimspector#StepInto()<CR>
        nnoremenu WinBar.←\ Out\(F12\) :call vimspector#StepOut()<CR>
        nnoremenu WinBar.⟲:\(F4\) :call vimspector#Restart()<CR>
        nnoremenu WinBar.✕ :call vimspector#Reset( { 'interactive': v:false } )<CR>
  " Cretae our own WinBar
endfunction


function s:SetUpTerminal()
        " Customise the terminal window size/position
        " For some reasons terminal buffers in Neovim have line numbers
        call win_gotoid( g:vimspector_session_windows.terminal )
        set number relativenumber
endfunction

augroup MyVimspectorUICustomistaion
        autocmd!
        autocmd User VimspectorUICreated call s:CustomiseWinBar()
        autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
augroup END

let g:bracey_refresh_on_save = 1

let g:livepreview_previewer = 'zathura'

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

function! ToggleEnableBuftabline()
  let x = 1 - g:buftabline_show
  let g:buftabline_show = x
  call buftabline#update(0)
endfunction

" Buftabline
let g:buftabline_show = 1
nnoremap <silent> <Leader>bf :call ToggleEnableBuftabline()<CR>

" JSDoc mapping
" nmap <silent> <M-j> <Plug>(jsdoc)

augroup AUTOSAVE
  au!
  autocmd InsertLeave,TextChanged,FocusLost * silent! write
augroup END

" lua << EOF
" local autosave = require("autosave")
" autosave.setup(
"   {
"       enabled = false,
"       events = {"CursorHold", "FocusGained"},
"       conditions = {
"           exists = true,
"           filetype_is_not = {},
"           modifiable = true
"       },
"       write_all_buffers = false,
"       on_off_commands = true,
"       clean_command_line_interval = 1000,
"       debounce_delay = 300
"   }
" )
" EOF

" auto read buffers for externally modified files
au FocusGained,BufEnter * :checktime

let g:onedark_hide_endofbuffer=1
let g:onedark_termcolors=256
let g:onedark_terminal_italics=1

let g:gruvbox_termcolors=256
let g:gruvbox_invert_selection = 0
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italics=1

set background=dark
colorscheme gruvbox
set termguicolors

highlight Visual guifg=NONE
highlight MatchParen guifg=#2e9fc7 guibg=NONE gui=underline cterm=underline
highlight Comment term=italic cterm=italic gui=italic

let g:apex_backup_folder='/tmp/apex_backup_folder'

" emmet
let g:user_emmet_mode='a'    "only enable insert mode functions.
let g:user_emmet_leader_key='<C-_>'

" vim-vu config
let g:vue_pre_processors = 'detect_on_enter'

let g:airline_theme='gruvbox'
" --- vim go (polyglot) settings.
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1
let mapleader = " "

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_preview_window = ['right:hidden', 'ctrl-/']
let $FZF_DEFAULT_OPTS='--reverse'
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

let g:fzf_branch_actions = {
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'alt-enter',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'create': {
      \   'prompt': 'Create> ',
      \   'execute': 'echo system("{git} checkout -b {input}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-n',
      \   'required': ['input'],
      \   'confirm': v:false,
      \ },
      \ 'delete': {
      \   'prompt': 'Delete> ',
      \   'execute': 'echo system("{git} branch -D {branch}")',
      \   'multiple': v:true,
      \   'keymap': 'ctrl-d',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \ 'merge':{
      \   'prompt': 'Merge> ',
      \   'execute': 'echo system("{git} merge {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-e',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \ 'rebase':{
      \   'prompt': 'Rebase> ',
      \   'execute': 'echo system("{git} rebase {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-r',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \}

let g:fzf_tag_actions = {
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {tag}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['tag'],
      \   'confirm': v:false,
      \ },
      \ 'create': {
      \   'prompt': 'Create> ',
      \   'execute': 'echo system("{git} tag {input}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-n',
      \   'required': ['input'],
      \   'confirm': v:false,
      \ },
      \ 'delete': {
      \   'prompt': 'Delete> ',
      \   'execute': 'echo system("{git} branch -D {tag}")',
      \   'multiple': v:true,
      \   'keymap': 'ctrl-d',
      \   'required': ['tag'],
      \   'confirm': v:true,
      \ },
      \}

" multicursors plugin mappings
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_select_all_word_key = '<M-n>'
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<M-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

nnoremap <leader>gc :GCheckout<CR>
nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>pw :Ag <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ph :Qdo %s/<C-R>=expand("<cword>")<CR>/
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
" nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <Leader>ps :Ag<SPACE>
nnoremap <C-p> :FZF<CR>
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader><CR> :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>rp :resize 100<CR>
nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap X "_d

" mappings
nnoremap <silent> <leader>fzf :<C-u>CocFzfList<CR>
nnoremap <silent> <leader>a       :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent> <leader>dg       :<C-u>CocFzfList diagnostics --current-buf<CR>
nnoremap <silent> <leader>c       :<C-u>CocFzfList commands<CR>
nnoremap <silent> <leader>e       :<C-u>CocFzfList extensions<CR>
nnoremap <silent> <leader>w       :<C-u>CocFzfList location<CR>
nnoremap <silent> <leader>o       :<C-u>CocFzfList outline<CR>
nnoremap <silent> <leader>s       :<C-u>CocFzfList symbols<CR>
nnoremap <silent> <leader>_lr       :<C-u>CocFzfListResume<CR>

" vim TODO
"nmap <Leader>tu <Plug>BujoChecknormal
"nmap <Leader>th <Plug>BujoAddnormal
"let g:bujo#todo_file_path = $HOME . "/.cache/bujo"

" Vim with me
"nnoremap <leader>vwm :colorscheme gruvbox<bar>:set background=dark<CR>
nmap <leader>vtm :highlight Pmenu ctermbg=gray guibg=gray

inoremap <C-c> <esc>

command! -nargs=0 CocPrettier :CocCommand prettier.formatFile
inoremap <silent><expr> <C-space> coc#refresh()

" autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
" autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)

" GoTo code navigation.
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Insert <tab> when previous text is space, refresh completion if not.
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1):
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd :call CocAction('jumpDefinition')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

let g:coc_auto_copen = 0

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

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

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'Editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = " "
let g:airline_symbols.colnr = "\u2102 "
" let g:airline_symbols.colnr = "\u262d "

let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline_powerline_fonts = 1

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Sweet Sweet FuGITive
let g:fugitive_conflict_x=1

nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit -v -q<CR>
nnoremap <leader>ga :Gcommit --amend<CR>
nnoremap <leader>gt :Gcommit -v -q %<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gvd :Gvdiffsplit!<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Git log<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Git merge<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :GBranches<CR>
nnoremap <leader>gps :Git push<CR>
nnoremap <leader>gpl :Git pull<CR>

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr("t:NERDTreeBufName") != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-yaml', 
  \ 'coc-css', 
  \ 'coc-clangd', 
  \ 'coc-rust-analyzer'
  \ ]


nmap <leader>pt :CocPrettier<CR>
" from readme
" if hidden is not set, TextEdit might fail.

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

nmap <C-h> :NERDTreeToggle<CR>
nmap <C-f>h :NERDTreeFind<CR>
" vmap <C-_> <plug>NERDCommenterToggle
" nmap <C-_> <plug>NERDCommenterToggle

" open NERDTree automatically
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree

let g:NERDTreeGitStatusWithFlags = 1
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:NERDTreeGitStatusNodeColorization = 1
"let g:NERDTreeColorMapCustom = {
    "\ "Staged"    : "#0ee375",  
    "\ "Modified"  : "#d9bf91",  
    "\ "Renamed"   : "#51C9FC",  
    "\ "Untracked" : "#FCE77C",  
    "\ "Unmerged"  : "#FC51E6",  
    "\ "Dirty"     : "#FFBD61",  
    "\ "Clean"     : "#87939A",   
    "\ "Ignored"   : "#808080"   
    "\ }                         


let g:NERDTreeIgnore = ['^node_modules$', '^dist$', '.nuxt$']

" nvim toggleterm
lua << EOF
require("toggleterm").setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 10
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'single',
    width = 100,
    height = 10,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal"
    }
  }
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}

  vim.api.nvim_buf_set_keymap(0, 't', '<M-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
EOF

" vim-prettier
" Max line length that prettier will wrap on: a number or 'auto' (use
" textwidth).
" default: 'auto'
let g:prettier#config#print_width = 'auto'

" number of spaces per indentation level: a number or 'auto' (use
" softtabstop)
" default: 'auto'
let g:prettier#config#tab_width = 'auto'

" use tabs instead of spaces: true, false, or auto (use the expandtab setting).
" default: 'auto'
let g:prettier#config#use_tabs = 'auto'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown or empty string
" (let prettier choose).
" default: ''
let g:prettier#config#parser = ''

" cli-override|file-override|prefer-file
" default: 'file-override'
let g:prettier#config#config_precedence = 'file-override'

" always|never|preserve
" default: 'preserve'
let g:prettier#config#prose_wrap = 'preserve'

" css|strict|ignore
" default: 'css'
let g:prettier#config#html_whitespace_sensitivity = 'css'

" false|true
" default: 'false'
let g:prettier#config#require_pragma = 'false'

let g:prettier#config#tab_width = 2
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#trailing_comma = 'none'
let g:prettier#config#print_width = 100
let g:prettier#config#semi = 'false'
let g:prettier#quickfix_enabled = 0
let g:prettier#quickfix_auto_focus = 0
" let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 1
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_config_files = [
  \ 'prettier.config.js',
  \ '.prettierrc',
  \ '.prettierrc.json',
  \ '.prettierrc.js',
  \ '.prettierrc.toml',
  \ ]

" Custom mappings
inoremap <C-H> <C-W>
nmap <C-T> :tabnew <CR> :tablast<CR>
nmap <C-Q> :tabclose <CR>
nnoremap <M-d>d :Gvdiff<CR>
nnoremap <M-d>h :Gvdiff HEAD<CR>
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv
nnoremap <leader>; gv
nnoremap <leader>P li<space><esc>P
nnoremap <C-F>b :NERDTreeFind<CR>

" blamer.nvim
let g:blamer_enabled = 1
nnoremap <Leader>bl :BlamerToggle<CR>

" buftabline
nnoremap <M-/> :bnext<CR>
nnoremap <M-,> :bprev<CR>
nnoremap <C-L> :Buffers<CR>
" nnoremap <Leader>bs :Buffers<CR>
nnoremap <Leader>bd :buffers<CR>:bdelete<Space>
nnoremap <leader>W :MatchupWhereAmI?<CR>
com! -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod

" Search in all currently opened buffers
function! Vimgrepall(pattern)
  call setqflist([])
  exe 'bufdo vimgrepadd ' . a:pattern . ' %'
  exe 'copen'
endfunction

command! -nargs=1 Vim call Vimgrepall(<f-args>)

function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" .  (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
\   'source':  <sid>buffer_lines(),
\   'sink':    function('<sid>line_handler'),
\   'options': '',
\   'down':    '30%'
\})

nnoremap <silent> <Leader>/ :BLines<CR>

autocmd ExitPre * call <sid>TermForceCloseAll()
function! s:TermForceCloseAll() abort
  echo 'exec term force close all'
  let term_bufs = filter(range(1, bufnr('$')), 'getbufvar(v:val, "&buftype") == "terminal"')
  for t in term_bufs
    exec 'bd! '.t
  endfor
endfunction

function! RangeSearch(direction)
  call inputsave()
  let g:srchstr = input(a:direction)
  call inputrestore()
  if strlen(g:srchstr) > 0
    let g:srchstr = '\%>'.(line("'<")-1).'l'.
          \ '\%<'.(line("'>")+1).'l'.
          \ g:srchstr"'"))'>'">'"))
  else
    let g:srchstr = ''
  endif
endfunction

vnoremap <silent> / :<C-U>call RangeSearch('/')<CR>:if strlen(g:srchstr) > 0\|exec '/'.g:srchstr\|endif<CR>
vnoremap <silent> ? :<C-U>call RangeSearch('?')<CR>:if strlen(g:srchstr) > 0\|exec '?'.g:srchstr\|endif<CR>

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

command! -nargs=* -range=% GetSelection :exec 'Ag '.s:get_visual_selection()
command! -nargs=* -range=% GetSelectionFile :exec '/'.s:get_visual_selection()

nnoremap <leader>i :Vim<space>
nnoremap <leader>I :Vim<space><C-R>=expand("<cword>")<CR><CR>
vnoremap <leader>pw :GetSelection<CR>
vnoremap <leader>s :GetSelectionFile<CR>
nnoremap <leader>H :%s/<C-R>=expand("<cword>")<CR>/
vnoremap <leader>H y; :%s/<C-R><C-O>0/

nnoremap <C-A> :%y+<CR>
nnoremap <Leader>vv "+yg_
nnoremap <Leader>V "+yy

" tmux configuration 
tmap <silent> <C-@> <C-Space>
tmap <silent> <M-,> <M-,>
tmap <silent> <M-/> <M-/>
tmap <silent> <M-h> <C-,>
tmap <silent> <M-l> <C-/>

nnoremap <silent> <Leader>@ :echo @%<CR>
nnoremap zh 16zh
nnoremap zl 16zl

function EnterOrIndentTag()
  let line = getline(".")
  let col = getpos(".")[2]
  let before = line[col-2]
  let after = line[col-1]

  if before == ">" && after == "<"
    return "\<CR>\<C-o>O"
  endif
    return "\<CR>"
endfunction

inoremap <expr> <CR> EnterOrIndentTag()

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

set conceallevel=0
set cmdheight=1
