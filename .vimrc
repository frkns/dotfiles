autocmd FileType python nnoremap ,r :w<CR>:!clear; python %<CR>
autocmd FileType cpp    nnoremap ,r :w<CR>:!clear; g++ -std=c++23 % && ./a.out && rm ./a.out<CR>

autocmd FileType python nnoremap ,t :w<CR>:!clear; python % < in<CR>
autocmd FileType cpp    nnoremap ,t :w<CR>:!clear; g++ -std=c++23 % && ./a.out < in && rm ./a.out<CR>
