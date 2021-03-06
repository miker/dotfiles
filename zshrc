#! /bin/zsh -f

ZSH_CONF_DIR=~/.zsh
ZSH_CONF_FILES=(
  modules
  functions
  aliases
  os
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

if [[ -s ${HOME}/.rvm/scripts/rvm ]]; then
  source ${HOME}/.rvm/scripts/rvm
fi
