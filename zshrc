###############################################################################
# Zsh settings file for Greg Fitzgerald <netzdamon@gmail.com>
#
# Most recent update: Wed Oct  8 15:24:37 2008
###############################################################################

##############################################################################
# Test for an interactive shell. There is no need to set anything
# past this point for scp, and it's important to refrain from
# outputting anything in those cases.
##############################################################################
# by default, we want this to get set.
# Even for non-interactive, non-login shells.
if [ "`id -gn`" = "`id -un`" -a `id -u` -gt 99 ]; then
        umask 002
  else
        umask 022
fi

if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi

# Load zsh configs
ZSH_DIR="${HOME}/.zsh"
ZSH_FILES=(aliases env completion config)
for file in $ZSH_FILES; do
    [[ -f $ZSH_DIR/$file ]] && source $ZSH_DIR/$file
done

# vim: set et fenc=utf-8 ff=unix sts=4 sw=4 ts=4 tw=80 syn=zsh :
