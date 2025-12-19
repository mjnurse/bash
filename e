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
fuzzy=n

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
      -f|--fuzzy)
         fuzzy=y
         ;;
      -g|--grep)
         run_grep=y
         ;;
      ?*)
         break
         ;;
   esac 
   shift
done 


tmp=/tmp/e.tmp
tmp2=/tmp/e.tmp2
rm -f $tmp $tmp2
name="${*}"

# Try which

which "$name" | realpath >> $tmp 2>/dev/null

if [[ $fuzzy == y ]]; then
    name="*${name// /*}*"
    echo Searching for: "$name"
fi

if [[ $run_grep == y ]]; then
  grep -ril "${name}" /c/MJN/drive/github/* >> $tmp
  echo "--------------------------------------------------------------------------------" >> $tmp
fi

echo "Searching ./* ..."
find . -iname "$name" -type f -exec realpath {} \; >> $tmp
echo "Searching MJN/* ..."
find "/c/Users/MartinNurse/OneDrive - Quantexa Ltd/MJN" -iname "$name" -type f -exec realpath {} \; >> $tmp
echo "Searching ~/mjnurse"
find ~/mjnurse -iname "$name" -type f -exec realpath {} \; >> $tmp
sort -u $tmp > $tmp2
mv -f $tmp2 $tmp

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
read -p "Enter Number (# or v# - Vim, c# - MS Code): " n

editor="gvim"
if [[ "${n:0:1}" == "v" ]]; then
  editor="gvim"
  n="${n:1}"
elif [[ "${n:0:1}" == "c" ]]; then
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

