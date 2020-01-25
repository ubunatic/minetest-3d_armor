#!/usr/bin/env bash

cd dirname $0
intllib=../../intllib
script=$intllib/tools/xgettext.sh

if test -f $script
then $script ../**/*.lua
else echo "Please download https://github.com/minetest-mods/intllib to $intllib" 1>&2; exit 1
fi
