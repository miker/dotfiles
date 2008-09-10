" $Id: python_gnuchlog.vim 19452 2006-08-08 19:58:29Z lpc $
" Vim filetype plugin file extension
" Language:	        python
" Maintainer:       Luis P Caamano <lcaamano@gmail.com>
" Latest Revision:  $Revision: 19452 $ 
" Last Change:      $Date: 2006-08-08 15:58:29 -0400 (Tue, 08 Aug 2006) $
" License:          This file is placed in the public domain.
"
" Description:  Adapts the gnuchlog.vim plugin to use the
"               pythonhelper.vim plugin's tag finding function.

if exists("b:python_gnuchlog_did_ftplugin") | finish | endif
let b:python_gnuchlog_did_ftplugin = 1

if !exists('*PythonGnuChangeLogTagFinder')
    if exists('*TagInStatusLine')
        " use python helper's TagInStatusLine function to get the tag
        function! PythonGnuChangeLogTagFinder()
            let funcname = TagInStatusLine()
            if len(funcname)
                let funcname = split(funcname, ' ')[1]
            endif
            return funcname
        endfunction
    else
        function! PythonGnuChangeLogTagFinder()
            return ''
        endfunction
    endif
endif

" set the gnuchlog.vim's tagfinder function name to our function here
" and it will call it to get the name of the class, method or function
" where the cursor was when the user opened the ChangeLog file.
let b:changelog_tagfinder = function('PythonGnuChangeLogTagFinder')

