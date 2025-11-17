" Tokyonight
set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight

" Lightline
set laststatus=2

let g:lightline = {
            \ 'colorscheme' : 'tokyonight',
            \ 'active': {
                \   'left': [ [ 'mode', 'paste' ],
                \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
                \   'right': [ [ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
                \ },
                \ 'component_function': {
                    \   'gitbranch': 'FugitiveHead',
                    \   'filename': 'LightlineFilename'
                    \ }
                    \ }

function! LightlineFilename()
    return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

" Startify
let g:ascii = [
            \ '                               ___     ',
            \ '      ___        ___          /__/\    ',
            \ '     /__/\      /  /\        |  |::\   ',
            \ '     \  \:\    /  /:/        |  |:|:\  ',
            \ '      \  \:\  /__/::\      __|__|:|\:\ ',
            \ '  ___  \__\:\ \__\/\:\__  /__/::::| \:\',
            \ ' /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/',
            \ ' \  \:\|  |:|     \__\::/  \  \:\      ',
            \ '  \  \:\__|:|     /__/:/    \  \:\     ',
            \ '   \__\::::/      \__\/      \  \:\    ',
            \ '       ~~~~                   \__\/    ',
            \ ]

let g:startify_custom_header =
            \ 'g:ascii'
