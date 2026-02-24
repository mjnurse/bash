#!/usr/bin/env bash
help_text="
NAME
    h - Extracts and displays the (single line) help lines in bash scripts.

USAGE
    h [<search_string - wildcards allowed>]

OPTIONS
    -h|--help
        Display this help text.

    -i|--issues
        Display scripts to help_line issues.

    -m|--matchesonly
        Only display the help lines available, don't report on files missing a help line or with
        a help line 'tbc'.

DESCRIPTION
    Extracts and displays the (single line) help lines.
    It searches for lines starting with 'help_line=' or '-- help_line:' in bash scripts.
    If search strings are provided, only files / descriptions matching the search strings are processed.
    Wildcards are allowed in the search strings.

AUTHOR
    mjnurse.github.io - 2020
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
issues_only_yn=n

case ${1-} in
    -h|--help)
        echo "$help_text"
        exit
        ;;
    -i|--issues)
        issues_only_yn=y
        shift
        ;;
    -m|--matchesonly)
        matches_only_yn=y
        shift
        ;;
    -*)
        echo "Bad option: $1"
        exit
esac

location="$(which h)"
cd "${location:0:-2}"

if [[ "$1" != "" ]]; then
    HIGHLIGHT_STR="$1"
else
    # Default highlight string unlikely to be in any help_line
    HIGHLIGHT_STR="-=-=-=-==-="
fi

if [[ $matches_only_yn == n ]]; then

    # Create a file so that the grep command never fails
    echo "x" > /tmp/h.tmp0

    grep --exclude="*.pack" --exclude="*.tmp" --exclude="*.bkp" --exclude-dir="*" \
         -s -L -e "^help_line=" -e "^HELP_LINE=" -e "^-- help_line:" /tmp/h.tmp0 * \
      | sed '/README.*.md/d; /^h:/d; /tmp0/d' \
      | sort -f > /tmp/h.tmp

    if [[ $(cat /tmp/h.tmp | wc -l) != 0 ]]; then
        echo -------------
        echo No help_line:
        echo -------------
        cat /tmp/h.tmp | sed "s/$HIGHLIGHT_STR/\x1b[31m&\x1b[0m/I"
    fi
    # Create a file so that the grep command never fails
    echo 'help_line="tbc"' > /tmp/h.tmp0

    grep -s -l -e "help_line=.*tbc.*" /tmp/h.tmp0 * \
      | sed '/README.*.md/d; /^h$/d; /tmp0/d' \
      | sort -f > /tmp/h.tmp

    if [[ $(cat /tmp/h.tmp | wc -l) != 0 ]]; then
        echo --------------
        echo help_line: tbc
        echo --------------
        cat /tmp/h.tmp | sed "/tidy/d" | sed "s/$HIGHLIGHT_STR/\x1b[31m&\x1b[0m/I"
    fi
    rm -f /tmp/h.tmp0

    if [[ $issues_only_yn == n ]]; then
        echo -----------
        echo help_lines:
        echo -----------
    fi
fi

if [[ $issues_only_yn == y ]]; then
    exit
fi

prev_char=""

grep -H -s -i -e "^help_line=" -e "^-- help_line:" * > /tmp/h.tmp

cat /tmp/h.tmp | \
sed ' 
    /help_line=.*tbc.*/d
    /^h:/d; s/help_line=//I; s/-- help_line://I; s/"/ /g;
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
    s/: /:                          /;
    s/\(...........................\) *\(.*\)/\1\2/; /tidy:.*echo/d' > /tmp/h.out 

cat /tmp/h.out | sed "s/$HIGHLIGHT_STR/\x1b[31m&\x1b[0m/I"
rm -f /tmp/h.out /tmp/h.tmp
