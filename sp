#!/usr/bin/env bash

echo "$1" | aspell pipe | sed "
    1d
    s/^\*/$1: Correct/
    s/^\&.*: //
    s/, /\n/g
"