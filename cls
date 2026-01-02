#!/usr/bin/env bash
help_text="
NAME
  cls - Clear terminal and putty terminal buffer

USAGE
  cls

DESCRIPTION
  Clear terminal and putty terminal buffer.

AUTHOR
  mjnurse.github.io - 2019
"
help_line="Clear terminal and putty terminal buffer"
web_desc_line="Clear terminal and putty terminal buffer"
pack_member="basics,default"

# doesn't always work first time round so twice.
printf '\033[3J'
clear
printf '\033[3J'
clear
