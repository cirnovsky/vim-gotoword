" This is for label literal calculation
let s:chars = 'abcdefghijklmnopqrstuvwxyz'
function! s:num2tag(num) abort
	let fst = a:num / 26
	let sec = a:num % 26
	return s:chars[fst] . s:chars[sec]
endfunction

augroup HighlightGroup
    autocmd!
    autocmd ColorScheme * call s:SetHighlightGroup()
augroup END

function! s:SetHighlightGroup() abort
    if &background ==# 'dark'
        let default_ctermfg = 'Black'
        let default_ctermbg = 'Yellow'
        let default_guifg = '#000000'
        let default_guibg = '#ffff00'
    else
        let default_ctermfg = 'White'
        let default_ctermbg = 'Red'
        let default_guifg = '#ffffff'
        let default_guibg = '#ff0000'
    endif

    let ctermfg = get(g:, 'gotoword_ctermfg', default_ctermfg)
    let ctermbg = get(g:, 'gotoword_ctermbg', default_ctermbg)
    let guifg = get(g:, 'gotoword_guifg', default_guifg)
    let guibg = get(g:, 'gotoword_guibg', default_guibg)
    let cterm = get(g:, 'gotoword_cterm', 'bold')
    let gui = get(g:, 'gotoword_gui', 'bold')

    " cterm does not accept hex colors; fall back when users set GUI
    " hex values globally and reuse them for terminal options.
    if ctermfg =~? '^#\x\{6}$'
        let ctermfg = default_ctermfg
    endif
    if ctermbg =~? '^#\x\{6}$'
        let ctermbg = default_ctermbg
    endif

    execute 'highlight gotowordHighlight ctermfg=' . ctermfg
                \ . ' ctermbg=' . ctermbg
                \ . ' guifg=' . guifg
                \ . ' guibg=' . guibg
                \ . ' cterm=' . cterm
                \ . ' gui=' . gui
endfunction

function! gotoword#GotoWord() abort
	let tagged = []
	let positions = {}
	let cnt = 0
	let start = line('w0')
	let end = line('w$')
	let nlines = end-start

	let folds = map(range(start, end), 'foldclosed(v:val)')

	for cnm in range(start, end)
		if foldclosed(cnm) != -1 && foldclosed(cnm) != cnm
			call add(tagged, 'cnm')
			continue
		endif
		let line = getline(cnm)
		let new = ''
		let chars = split(line, '\zs')
		let i = 0
		while i < len(chars)
			let char = chars[i]

			if char =~ '\w' && (i == 0 || chars[i-1] !~ '\w')
				let n = 0
				while i+n < len(chars) && chars[i+n] =~ '\w'
					let n += 1
				endwhile
				if n > 1
					let tg = printf('%s', s:num2tag(cnt))
					let cnt += 1
					let positions[tg] = [len(tagged), i+1]
					let new .= tg
					let i += 2
					continue
				endif
			endif
			let new .= char
			let i += 1
		endwhile
		call add(tagged, new)
	endfor

	for i in range(start, end)
		if foldclosed(i) == -1 || foldclosed(i) == i
			call setline(i, tagged[i-start])
		endif
	endfor

	let hl_pos = []
	for pos in values(positions)
		let [line, col] = pos
		let line += line('w0')
		call add(hl_pos, [line, col, 2])
	endfor

	call s:SetHighlightGroup()
	let mid = matchaddpos('gotowordHighlight', hl_pos)

	redraw
	let input = nr2char(getchar()) . nr2char(getchar())

	for i in range(0, nlines)
		if folds[i] == i
			execute folds[i] . 'foldclose'
		endif
	endfor

	call matchdelete(mid)
	
	u
	if has_key(positions, input)
		let [line, col] = positions[input]
		let line += line('w0')
		call cursor(line, col)
	endif

endfunction
