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

# Terminal Colours
cdef="\e[39m" # default colour
cbla="\e[30m"; cgra="\e[90m"; clgra="\e[37m"; cwhi="\e[97m"
cred="\e[31m"; cgre="\e[32m"; cyel="\e[33m"; cblu="\e[34m"; cmag="\e[35m"; ccya="\e[36m";
clred="\e[91m"; clgre="\e[92m"; clyel="\e[93m"; clblu="\e[94m"; clmag="\e[95m"; clcya="\e[96m"

function cecho {
    color=c$1; shift
    echo -e "${!color}$*${cdef}"
}

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
    filter="$1"
else
    # Default highlight string unlikely to be in any help_line
    filter=".*"
fi

if [[ $matches_only_yn == n ]]; then

    # Create a file so that the grep command never fails
    echo "x" > /tmp/h.tmp0

    grep --exclude="*.pack" --exclude="*.tmp" --exclude="*.bkp" --exclude-dir="*" \
         -s -L -e "^help_line=" -e "^HELP_LINE=" -e "^-- help_line:" /tmp/h.tmp0 * \
      | sed '/README.*.md/d; /^h:/d; /tmp0/d' \
      | sort -f > /tmp/h.tmp

    if [[ $(cat /tmp/h.tmp | wc -l) != 0 && "$filter" == ".*" ]]; then
        cecho lmag -------------
        cecho lmag No help_line:
        cecho lmag -------------
        cat /tmp/h.tmp | sed "/\.dat$/d; /^vimspell/d;"
    fi
    # Create a file so that the grep command never fails
    echo 'help_line="tbc"' > /tmp/h.tmp0

    grep -s -l -e "help_line=.*tbc.*" /tmp/h.tmp0 * \
      | sed '/README.*.md/d; /^h$/d; /tmp0/d' \
      | sort -f > /tmp/h.tmp

    if [[ $(cat /tmp/h.tmp | wc -l) != 0 && "$filter" == ".*" ]]; then
        cecho lmag --------------
        cecho lmag help_line: tbc
        cecho lmag --------------
        cat /tmp/h.tmp | sed "/tidy/d"
    fi
    rm -f /tmp/h.tmp0

    if [[ $issues_only_yn == n ]]; then
        cecho lmag -----------
        cecho lmag help_lines:
        cecho lmag -----------
    fi
fi

if [[ $issues_only_yn == y ]]; then
    exit
fi

prev_char=""

grep -H -s -i -e "^help_line=" -e "^-- help_line:" * | egrep "$filter" > /tmp/h.tmp

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
         echo -e "${clmag}${curr_char}${cdef} - ${clcya}$line"
    else
         echo -e "${cdef}${cdef}    ${clcya}$line" 
    fi
done | sed  "
     s/: /:\x1b[37m                                                     /;
     s/\(...............................................\) *\(.*\)/\1\2/; /tidy:.*echo/d" > /tmp/h.out 

cat /tmp/h.out
rm -f /tmp/h.out /tmp/h.tmp
