" Title:        Wrap Comment Block
" Description:  Line wraps the comment block the cursor is in.
" Last Change:  2024-08-13
" Maintainer:   John Tobin <https://github.com/tobinjt>

if exists('g:loaded_wrap_comment_block')
    finish
endif
let g:loaded_wrap_comment_block = 1

if get(g:, 'wcb_disable_mappings', 0) == 0
  " The `:` is required to make it an ex command, and the `<CR>` is required to
  " execute it.
  nnoremap <unique> <leader>wc :call wcb#WrapCommentBlock()<CR>
endif
