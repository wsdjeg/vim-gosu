" Vim filetype plugin file
" Language:	Gosu
" Maintainer:	vim-gosu community
" URL:		http://github.com/colmcdonagh/vim-gosu/ftplugin/gosu.vim

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

" For filename completion, prefer the .gosu extension over the .class
" extension.
set suffixes+=.class

" Enable gf on import statements.  Convert . in the package
" name to / and append .gosu to the name, then search the path.
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=gosu.
if exists("g:ftplugin_gosu_source_path")
    let &l:path=g:ftplugin_gosu_source_path . ',' . &l:path
endif

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

" Set 'comments' to format dashed lists in comments. Behaves just like C.
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/

setlocal commentstring=//\ %s

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal suffixes< suffixesadd<" .
		\     " formatoptions< comments< commentstring< path< includeexpr<" 

" Restore the saved compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo
