let mapleader = " "

" File navigation
nnoremap <leader>e :Ex<CR>
nnoremap <C-p> :Files<CR>

" Find
nnoremap <leader>f :Rg<Space>

" Buffers
nnoremap <leader>t :edit<space>
nnoremap <leader>p :Buffers<CR>

" Center on next/previous search result
nnoremap n nzzzv
nnoremap N Nzzzv

" Scroll half-page and center cursor
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Line commenting (Ctrl-/)
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR>

" File indentation
nnoremap <leader>i gg=G<C-o><C-o>

" LSP
nnoremap <F2> :LspRename<CR>
nnoremap <leader>. :LspCodeAction<CR>
nnoremap <F12> :LspGotoDefinition<CR>
nnoremap <S-F12> :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap <F8> :LspNextDiagnostic<CR>
nnoremap <S-F8> :LspPreviousDiagnostic<CR>

nnoremap <leader>v :MarkdownPreviewToggle<CR>

" Open terminal
nnoremap <leader>` :terminal<CR>

" Open config
nnoremap <leader>, :!vim ~/.dotfiles<CR>

" Reload .vimrc
nnoremap <F5> :source $MYVIMRC<CR>
