#! /bin/zsh -f
 
ZSH_CONF_DIR=~/.zsh
ZSH_CONF_FILES=(
  modules
  functions
  os
  env
  path
  aliases
  keymap
  prompt
  options
  completion
  config
)
 
for conf_file in $ZSH_CONF_FILES; do
  source $ZSH_CONF_DIR/$conf_file;
done

if [ ! -z ${DISPLAY} ]; then
    setxkbmap -option "ctrl:nocaps"
fi
