" Vim filetype detection file
" Language:	Paludis Things
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Copyright:	Copyright (c) 2007 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself
"
" Filetype detection for Paludis things.
"

if &compatible || v:version < 700
    finish
endif

au BufNewFile,BufRead environment.conf
    \     set filetype=paludis-environment-conf

au BufNewFile,BufRead keywords.conf
    \     set filetype=paludis-keywords-conf

au BufNewFile,BufRead **/keywords.conf.d/*.conf
    \     set filetype=paludis-keywords-conf

au BufNewFile,BufRead licenses.conf
    \     set filetype=paludis-licenses-conf

au BufNewFile,BufRead **/licenses.conf.d/*.conf
    \     set filetype=paludis-licenses-conf

au BufNewFile,BufRead mirrors.conf
    \     set filetype=paludis-mirrors-conf

au BufNewFile,BufRead **/mirrors.conf.d/*.conf
    \     set filetype=paludis-mirrors-conf

au BufNewFile,BufRead package_mask.conf
    \     set filetype=paludis-package-mask-conf

au BufNewFile,BufRead **/package_mask.conf.d/*.conf
    \     set filetype=paludis-package-mask-conf

au BufNewFile,BufRead package_unmask.conf
    \     set filetype=paludis-package-mask-conf

au BufNewFile,BufRead **/package_unmask.conf.d/*.conf
    \     set filetype=paludis-package-mask-conf

au BufNewFile,BufRead use.conf
    \     set filetype=paludis-use-conf

au BufNewFile,BufRead **/use.conf.d/*.conf
    \     set filetype=paludis-use-conf

au BufNewFile,BufRead repository_defaults.conf
    \     set filetype=paludis-repositories-conf

au BufNewFile,BufRead **/repositories/*.conf
    \     set filetype=paludis-repositories-conf

