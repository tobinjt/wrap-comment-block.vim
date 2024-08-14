" Returns the line number of first line of the contiguous block containing
" start_line and having syntax ID syn_id throughout.
function! wcb#FindStartOfBlock(start_line, syn_id)
  let l:start_line = a:start_line
  while l:start_line > 0
    let l:len = len(getline(l:start_line))
    let l:curr_syn_id = synID(l:start_line, l:len, 1)
    if l:curr_syn_id != a:syn_id
      " We went one line too far, go back, and exit the loop.
      let l:start_line = l:start_line + 1
      break
    endif
    if l:start_line == 1
      break
    endif
    let l:start_line = l:start_line - 1
  endwhile
  return l:start_line
endfunction

" Returns the line number of last line of the contiguous block containing
" start_line and having syntax ID syn_id throughout.
function! wcb#FindEndOfBlock(start_line, syn_id)
  let l:end_line = a:start_line
  while l:end_line <= line('$')
    let l:len = len(getline(l:end_line))
    let l:curr_syn_id = synID(l:end_line, l:len, 1)
    if l:curr_syn_id != a:syn_id
      " We went one line too far, go back.
      let l:end_line = l:end_line - 1
      break
    endif
    let l:end_line = l:end_line + 1
  endwhile
  return l:end_line
endfunction

" Wraps the comment block that contains the cursor.  The cursor will be left at
" the end of the block.
function! wcb#WrapCommentBlock()
  " Using the syntax under the last character of the line so that this can be
  " called from before the comment character.  col('$') returns the last
  " character plus 1, so subtract 1 to get a valid index into the line.
  let l:syn_id = synID(line('.'), col('$') - 1, 1)
  let l:syn_name = synIDattr(l:syn_id, 'name')
  if match(l:syn_name, '\ccomment') == -1
    echomsg 'syntax does not contain "comment": ' l:syn_id . ' => ' . l:syn_name
    return
  endif

  let l:start_line = wcb#FindStartOfBlock(line('.'), l:syn_id)
  let l:end_line = wcb#FindEndOfBlock(line('.'), l:syn_id)

  call cursor(l:start_line, len(getline(l:start_line)))
  if l:end_line > l:start_line
    " There's no point in wrapping if the comment is a single line.
    execute 'normal! ' . (l:end_line - l:start_line) . 'gqgq'
  endif
endfunction

