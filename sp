#!/usr/bin/env bash

help_line="Spell check words using aspell"

if [[ "$#" -eq 0 ]]; then
    echo "usage: sp <word1> <word2> ..."
    exit 1
fi

for w in "$@"; do
    printf "%s: " "$w"
    echo "$w" | aspell pipe | sed "
        1d
        s/^\*/Correct/
        s/^\&.*: /Incorrect: \n - /
        s/, /\n - /g
    "
done