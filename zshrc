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
  config
)
 
for conf_file in $ZSH_CONF_FILES; do
  source $ZSH_CONF_DIR/$conf_file;
done
