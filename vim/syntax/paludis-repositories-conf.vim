" Vim syntax file
" Language:	Paludis repositories/*.conf files
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Copyright:	Copyright (c) 2007 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself
"
" Syntax highlighting for Paludis repositories/*.conf files.
"

if &compatible || v:version < 700
    finish
endif

if exists("b:current_syntax")
  finish
endif

syn region PaludisRepositoriesConfComment start=/^\s*#/ end=/$/

syn region PaludisRepositoriesConfKey start=/^\(\s*[^#]\)\@=/ end=/=\@=/
	    \ contains=PaludisRepositoriesConfKnownKey

syn match PaludisRepositoriesConfEquals /=/ skipwhite
	    \ nextgroup=PaludisRepositoriesConfValue

syn region PaludisRepositoriesConfValue contained start=// end=/$/
	    \ contains=PaludisRepositoriesConfString,PaludisRepositoriesConfUnquoted,
	    \    PaludisRepositoriesConfContinuation,PaludisRepositoriesConfVariable
	    \ skipwhite

syn match PaludisRepositoriesConfContinuation contained /\\$/
	    \ skipnl

syn match PaludisRepositoriesConfUnquoted contained /[^ \t$"'\\]\+/ skipwhite

syn region PaludisRepositoriesConfString contained start=/"/ end=/"/
	    \ contains=PaludisRepositoriesConfVariable
	    \ skipwhite

syn keyword PaludisRepositoriesConfKnownKey contained
	    \ location distdir format buildroot library sync root yaml_uri
	    \ master_repository profiles pkgdir setsdir securitydir newsdir
	    \ names_cache sync sync_options eclassdirs cache write_cache
	    \ world provides_cache importance

syn match PaludisRepositoriesConfVariable contained /\$\({[^}]\+}\|[a-zA-Z0-9_]\+\)/ skipwhite

hi def link PaludisRepositoriesConfKnownKey         Keyword
hi def link PaludisRepositoriesConfString           String
hi def link PaludisRepositoriesConfUnquoted         Constant
hi def link PaludisRepositoriesConfVariable         Identifier
hi def link PaludisRepositoriesConfContinuation     Preproc
hi def link PaludisRepositoriesConfComment          Comment

let b:current_syntax = "paludis-repositories-conf"


