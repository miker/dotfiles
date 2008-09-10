" Vim filetype plugin file
"
" $Id: changelog.vim 19452 2006-08-08 19:58:29Z lpc $
"
" Maintainer:       Luis P Caamano <lcaamano@gmail.com>
" Latest Revision:  $Revision: 19452 $ 
" Last Change:      $Date: 2006-08-08 15:58:29 -0400 (Tue, 08 Aug 2006) $
" Language:         GNU Changelog file
" Credits:          Based on changelog.vim written by
"                   Nikolai Weibull <now@bitwi.se>
"
" License:     Vim License  (see vim's :help license)  because this is
"              based in the original changelog.vim ftplugin distributed
"              with vim under the Vim License.
"
" Local Mappings:
"   <Leader>o -
"       adds a new changelog entry for the current user for the current date.

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

if exists(":NewChangelogEntry") != 2
    map <buffer> <silent> <Leader>o :call AddNewChangeLogEntry()<CR>
    command! -nargs=0 NewChangelogEntry call AddNewChangeLogEntry()
endif

let b:undo_ftplugin = "setl com< fo< et< ai<"

setlocal comments=
setlocal formatoptions+=t
setlocal noexpandtab
setlocal autoindent

if &textwidth == 0 || &textwidth > 78
    setlocal textwidth=78
    let b:undo_ftplugin .= " tw<"
endif

let &cpo = s:cpo_save
unlet s:cpo_save
