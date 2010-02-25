#! /bin/zsh -f

ZSH_CONF_DIR=~/.zsh
ZSH_CONF_FILES=(
  modules
  os
  functions
  aliases
  env
  path
  paludis
  keymap
  prompt
  options
  completion
  rake
  config
)
 
for conf_file in $ZSH_CONF_FILES; do
  source $ZSH_CONF_DIR/$conf_file;
done

if [[ -s /home/gregf/.rvm/scripts/rvm ]] ; then source /home/gregf/.rvm/scripts/rvm ; fi
