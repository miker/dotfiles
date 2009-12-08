#!/bin/sh

cd ${HOME}/.dotfiles/
git pull
echo "a" | rake install

for i in `find ${HOME} -maxdepth 1 -type l `; do 
    [ -e $i ] || rm -rf $i; 
done
