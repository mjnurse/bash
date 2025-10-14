#!/bin/bash
help_text="
NAME
  e - Search for a file to edit in gvim or VSCode.

USAGE
  e <search words>

OPTIONS
  -g
    Run grep - search content of files instead of filename.

  -h|--help
    Show help text.

DESCRIPTION
  Search for a file to edit in gvim or VSCode.  A list of matching files will
  be shown with the option to select one for edit.

AUTHOR
  mjnurse.github.io - 2020
"
help_line="tbc"
web_desc_line="tbc"

try="Try ${0##*/} -h for more information"
tmp="${help_text##*USAGE}"
usage="$(echo Usage: ${tmp%%OPTIONS*})"
run_grep=n

if [[ "$1" == "" ]]; then
  echo "${usage}"
  echo "${try}"
  exit 1
fi

while [[ "$1" != "" ]]; do
   case $1 in 
      -h|--help)
         echo "$help_text"
         exit
         ;;
      -g)
         run_grep=y
         ;;
      ?*)
         break
         ;;
   esac 
   shift
done 


tmp=/tmp/e.tmp
rm -f $tmp
words="${*}"
words="*${words// /*}*"

if [[ $run_grep == y ]]; then
  grep -ril "${words:1}" /c/MJN/drive/github/* >> $tmp
  echo "--------------------------------------------------------------------------------" >> $tmp
fi
find /c/MJN/drive/github -iname "$words" -print >> $tmp

let c=1
while read line; do
  if [[ ! $line =~ .*index.md && ! $line =~ ./node_modules/.* ]]; then
    echo $c - $line
    let c=c+1
  fi
done < $tmp

if [[ $run_grep == n ]]; then
  echo
  echo "NOTE: No grep run.  Use -g to run a grep"
fi
echo
read -p "Enter Number (# or v# - Vim, m# - MS Code): " n

editor="gvim"
if [[ "${n:0:1}" == "v" ]]; then
  editor="gvim"
  n="${n:1}"
elif [[ "${n:0:1}" == "m" ]]; then
  editor="code"
  n="${n:1}"
fi

let c=1
while read line; do
  if [[ $c == $n ]]; then
    $editor "$line"
  fi
  let c=c+1
done < $tmp

