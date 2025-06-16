#!/bin/bash
help_text="
NAME
  h - Extracts and displays the (single line) help lines in bash scripts.

USAGE
  h [<filenames - wildcards allowed>]

OPTIONS
  -m|--matchesonly
    Only display the help lines available, don't report on files missing a help line or with
    a help line 'tbc'.

DESCRIPTION
  Extracts and displays the (single line) help lines.

AUTHOR
  mjnurse.dev - 2020
"

# set -o errexit
# set -o nounset
# set -o pipefail
# if [[ "${TRACE-0}" == "1" ]]; then
    # set -o xtrace
# fi

help_line="Extracts and displays the help_lines"
web_desc_line="Extracts and displays the help_lines"

matches_only_yn=n

case ${1-} in
  -m|--matchesonly)
    matches_only_yn=y
    shift
    ;;
  -h|--help)
    echo "$help_text"
    exit
    ;;
  -*)
    echo "Bad option: $1"
    exit
esac

location="$(which h)"
cd "${location:0:-2}"

files="${*-*}"

if [[ $matches_only_yn == n ]]; then

  # create a file so that the grep command never fails
  echo "x" > /tmp/h.tmp0

  grep --exclude-dir="*" -s -L -e "^help_line=" -e "^-- help_line:" /tmp/h.tmp0 $files \
      | sed '/README.*.md/d; /^h:/d; /tmp0/d' \
      | sort -f > /tmp/h.tmp

  if [[ $(cat /tmp/h.tmp | wc -l) != 0 ]]; then
    echo -------------
    echo No help_line:
    echo -------------
    cat /tmp/h.tmp
  fi

  # create a file so that the grep command never fails
  echo 'help_line="tbc"' > /tmp/h.tmp0

  grep -s -l -e "help_line=.*tbc.*" /tmp/h.tmp0 $files \
      | sed '/README.*.md/d; /^h$/d; /tmp0/d' \
      | sort -f > /tmp/h.tmp

  if [[ $(cat /tmp/h.tmp | wc -l) != 0 ]]; then
    echo --------------
    echo help_line: tbc
    echo --------------
    cat /tmp/h.tmp | sed "/tidy/d"
  fi

  rm -f /tmp/h.tmp0

  echo -----------
  echo help_lines:
  echo -----------
fi

prev_char=""

grep -H -s -e "^help_line=" -e "^-- help_line:" $files  > /tmp/h.tmp
cat /tmp/h.tmp | \
  sed ' 
    /help_line=.*tbc.*/d
    /^h:/d; s/help_line=//; s/-- help_line://; s/"/ /g;
    /tidy:.*echo/d; /^README.*md/d;
    s/:[0-9][0-9]*:/:/;
    ' | \
  sort | while IFS= read -r line ; do 
    curr_char="${line:0:1}"
    if [[ "$curr_char" != "$prev_char" ]]; then
         prev_char="$curr_char"
         echo "$curr_char - $line"
    else
         echo "    $line" 
    fi
  done | sed  '
    s/: /:                        /;
    s/\(.........................\) *\(.*\)/\1\2/; /tidy:.*echo/d' > /tmp/h.out 
cat /tmp/h.out
rm -f /tmp/h.out /tmp/h.tmp
