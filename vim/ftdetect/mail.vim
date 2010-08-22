au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,~/.tmp/mutt/mutt*,/tmp/mutt*,~/.mutt/cache/mutt*
        \ :set ft=mail |
        \ :set spell |
        \ :set tw=72 |
        \ :call HelpFixSpelling() |
