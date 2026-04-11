" plugin/gotoword.vim
" Vim-Gotoword: A Vim plugin to jump to labelled position on the
" screen just like in Helix.
" Maintainer: Cirnovsky
" Version: 0.1

if exists('g:loaded_gotoword')
	finish
endif
let g:loaded_gotoword = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

command! GotoWord call gotoword#GotoWord()

let &cpoptions = s:save_cpo
unlet s:save_cpo
