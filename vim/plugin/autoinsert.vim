if has("autocmd")
        augroup autoinsert
                au!
                autocmd BufNewFile *.c call s:Template("c")
                autocmd BufNewFile Makefile call s:Template("make")
                autocmd BufNewFile *.rb call s:Template("ruby")
                autocmd BufNewFile *.sh,*.bash call s:Template("sh")
                autocmd BufNewFile *.pl,*.plx call s:Template("perl")

        augroup END
endif

function s:Template(argument)
        if (a:argument == "help")
                echo "Currently available templates:"
                echo " c                - Plain C Template"
                echo " make             - Makefile Template"
                echo " ruby             - Ruby Template"
                echo " perl             - Perl Template"
                echo " sh               - Bash Template"


        else
                " First delete all in the current buffer
                %d

                " The Makefile variants
                if (a:argument == "make")
                        0r ~/.vim/skeletons/template.make
                        set ft=make

                " Stuff for plain C
                elseif (a:argument == "c")
                        0r ~/.vim/skeletons/template.c
                        set ft=c

                " Stuff for plain Ruby
                elseif (a:argument == "ruby")
                        0r ~/.vim/skeletons/template.ruby
                        set ft=ruby

                " Stuff for plain Bash
                elseif (a:argument == "sh")
                        0r ~/.vim/skeletons/template.sh
                        set ft=sh

                " Stuff for plain Perl
                elseif (a:argument == "perl")
                        0r ~/.vim/skeletons/template.perl
                        set ft=perl

                endif

                silent %!~/.vim/do_header %
        endif
endfunction

command! -nargs=1 Template call s:Template(<f-args>)
