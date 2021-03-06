" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c
"
" -----------------------------------------------------------------------------
"
" echodoc
let g:echodoc#enable_at_startup = 1
"
" -----------------------------------------------------------------------------
"
" lightline
set noshowmode  " disable default mode information

" with lightline-ale
let g:lightline = {
    \   'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
    \     'right': [ [ 'linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings', 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'fileformat', 'fileencoding', 'filetype' ] ],
    \   },
    \   'component_expand': {
    \     'linter_ok': 'lightline#ale#ok',
    \     'linter_checking': 'lightline#ale#checking',
    \     'linter_warnings': 'lightline#ale#warnings',
    \     'linter_errors': 'lightline#ale#errors',
    \   },
    \   'component_function': {
    \     'gitbranch': 'LightLineFugitive',
    \     'fileformat': 'LightLineFileformat',
    \     'filetype': 'LightLineFiletype',
    \   },
    \   'component_type': {
    \     'linter_ok': 'left',
    \     'linter_checking': 'left',
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \   },
    \ }

function! LightLineFugitive()
    let _ = fugitive#head()
    return strlen(_) ? "\uf126 "._ : ""
endfunction

function! LightLineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf00d"
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_ok = "\uf00c"
"
" -----------------------------------------------------------------------------
"
" ale
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_sign_error = "\uf00d"
let g:ale_sign_warning = "\uf071"
let g:ale_fixers = {
\ 'python': ['isort', 'remove_trailing_lines', 'trim_whitespace'],
\ }
let g:ale_fix_on_save = 1
let g:ale_set_highlights = 0
"
" -----------------------------------------------------------------------------
"  neosnippet
let g:neosnippet#disable_runtime_snippets = {
        \   '_' : 1,
        \ }
let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets'
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-j>     <Plug>(neosnippet_expand_or_jump)
smap <C-j>     <Plug>(neosnippet_expand_or_jump)
xmap <C-j>     <Plug>(neosnippet_expand_target)
"
" -----------------------------------------------------------------------------
"
" fzf
let $FZF_DEFAULT_COMMAND = "rg --files --no-ignore --hidden --follow --glob '!*/.git/*'"
noremap <F4> :FZF<CR>
inoremap <F4> <esc>:w<CR>:FZF<CR>

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!*/.git/*" --glob "!tags" --color "always" '.shellescape(<q-args>), 1, <bang>0)
"
" -----------------------------------------------------------------------------
"
" rust.vim
let g:rustfmt_autosave = 1
"
" -----------------------------------------------------------------------------
"
" nerdtree
noremap <F2> :NERDTreeToggle<CR>
"
" -----------------------------------------------------------------------------
"
" LanguageClient-neovim
" Required for operations modifying multiple buffers like rename.
set hidden
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
    \ 'python': ['pyls']
    \ }
let g:LanguageClient_diagnosticsEnable = 0
" disable snippet support for completions
let g:LanguageClient_hasSnippetSupport = 0

function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <silent> <F5> :call LanguageClient_contextMenu()<CR>
    nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <F6> :call LanguageClient_textDocument_rename()<CR>
  endif
endfunction

autocmd FileType * call LC_maps()
