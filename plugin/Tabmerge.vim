" Tabmerge -- Merge the windows in a tab with the current tab.
"
" Copyright July 17, 2007 Christian J. Robinson <infynity@onewest.net>
"
" Distributed under the terms of the Vim license.  See ":help license".

" Usage:
"  :Tabmerge {tab number} [top|bottom]

if v:version < 700
	echoerr "Tabmerge.vim requires at least Vim version 7"
	finish
endif

command! -nargs=+ Tabmerge call Tabmerge(<f-args>)

function! Tabmerge(tabnr, ...)
	let save_switchbuf = &switchbuf
	let &switchbuf = ''

	if a:tabnr == '$'
		let tabnr = tabpagenr(a:tabnr)
	else
		let tabnr = a:tabnr
	endif

	if a:0 == 1
		if a:1 =~? '^t\(op\)\?$'
			let where = 'top'
		elseif a:1 =~? '^b\(ot\(tom\)\?\)\?$'
			let where = 'bot'
		else
			echohl ErrorMsg
			echo "Invalid location: " . a:1
			echohl None
			return
		endif
	elseif a:0 > 1
		echohl ErrorMsg
		echo "Too many arguments"
		echohl None
		return
	else
		let where = 'top'
	endif

	let tabwindows = tabpagebuflist(tabnr)

	if type(tabwindows) == 0 && tabwindows == 0
		echohl ErrorMsg
		echo "No such tab number: " . tabnr
		echohl None
		return
	elseif tabnr == tabpagenr()
		echohl ErrorMsg
		echo "Can't merge with the current tab"
		echohl None
		return
	endif

	if where == 'top'
		let tabwindows = reverse(tabwindows)
	endif

	for buf in tabwindows
		exe where . ' sbuffer ' . buf
	endfor

	exe 'tabclose ' . tabnr

	let &switchbuf = save_switchbuf
endfunction
