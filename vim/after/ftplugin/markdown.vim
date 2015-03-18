" Created:  Wed 16 Apr 2014
" Modified: Tue 17 Mar 2015
" Author:   Josh Wainwright
" Filename: markdown.vim

exe 'setlocal dict+='.dictfile

"Automatic formating of paragraphs whenever text is inserted
setlocal formatoptions=tcqwan21

setlocal makeprg=md.sh\ %

function! FormatTable()
	let w = winsaveview()

	let tabstart = search("^$", "bW") +1
	let tabhead = tabstart + 1
	let tabend = search("^$", "nW") -1
	exe tabhead."d _"
	if tabstart < tabend
		exe tabstart.",".tabend."EasyAlign *|"
	else
		exe tabend.",".tabstart."EasyAlign *|"
	endif
	call append(tabstart, getline(tabstart))
	exe tabhead."s/[^|]/-/g"

	call winrestview(w)
endfunction

nnoremap <buffer> <cr> :call Goto_file_num()<cr>
function! Goto_file_num()
	" If the cursor is past the first space and the line starts with a digit
	let curr = getline('.') + 0
	if curr > 0 && stridx(getline('.'), " ")+1 > col('.')

		" Match item heading
		"       1 Something
		"       -----------
		" Or toc entry
		"       1. Something
		call search('\v^'.curr.'.*\n---|^'.curr.'\. ', "ws")
		normal zt
	else
		silent! normal gf
	endif
endfunction
