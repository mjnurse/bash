#!/usr/bin/env bash
help_text="
NAME
    h - Extracts and displays the (single line) help lines in bash scripts.

USAGE
    h [<search_string - wildcards allowed>]

OPTIONS
    -h|--help
        Show help text.

    -i|--issues
        Only display scripts with help_line issues.

    -n|--noissues
        Hide scripts with help_line issues.

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
cdef="\x1b[39m" # default colour
cbla="\x1b[30m"; cgra="\x1b[90m"; clgra="\x1b[37m"; cwhi="\x1b[97m"
cred="\x1b[31m"; cgre="\x1b[32m"; cyel="\x1b[33m"; cblu="\x1b[34m"; cmag="\x1b[35m"; ccya="\x1b[36m";
clred="\x1b[91m"; clgre="\x1b[92m"; clyel="\x1b[93m"; clblu="\x1b[94m"; clmag="\x1b[95m"; clcya="\x1b[96m"

function cecho {
    color=c$1; shift
    echo -e "${!color}$*${cdef}"
}

help_line="Extracts and displays the help_lines"
web_desc_line="Extracts and displays the help_lines"

noissues_yn=n
issues_only_yn=n

case ${1-} in
    -h|--help) # arg: Show help text
        echo "$help_text"
        exit
        ;;
    -i|--issues) # arg: Only display scripts with help_line issues
        issues_only_yn=y
        shift
        ;;
    -n|--noissues) # arg: Hide scripts with help_line issues
        noissues_yn=y
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

find . -maxdepth 1 -type f -executable -printf "%f\n" \
    | xargs grep --exclude="*.pack" --exclude="*.tmp" --exclude="*.bkp" --exclude="*.json" \
        --exclude="*.bac" --exclude="mjn*rc" --exclude-dir="*" \
        -s -L -e "^help_line=" -e "^HELP_LINE=" -e "^-- help_line:" \
    | sed '/README.*.md/d; /^h:/d; /tmp0/d' \
    | sort -f > /tmp/h.tmp

if [[ $noissues_yn == n ]]; then
    if [[ $(cat /tmp/h.tmp | wc -l) != 0 ]]; then
        cecho lmag -------------
        cecho lmag No help_line:
        cecho lmag -------------
        cat /tmp/h.tmp \
           | grep -E --ignore-case "${filter}" \
           | sed "/\.dat$/d; /^vimspell/d;
                 s/${filter//\.\*/}/${cyel}${filter//\.\*/}${cdef}/g;
                 " 
    fi
fi

if [[ $noissues_yn == n ]]; then
    find . -maxdepth 1 -type f -executable -printf "%f\n" \
        | xargs egrep -s -l -e --ignore-case "help_line=.*tbc.*" \
        | grep -E --ignore-case "${filter}" \
        | sed "/README.*.md/d; /^h$/d; /tmp0/d
               s/${filter//\.\*/}/${cyel}${filter//\.\*/}${cdef}/g;
              " \
        | sort -f > /tmp/h.tmp

    # if [[ $(cat /tmp/h.tmp | wc -l) != 0 && "$filter" == ".*" ]]; then
    if [[ $(cat /tmp/h.tmp | wc -l) != 0 ]]; then
        cecho lmag --------------
        cecho lmag help_line: tbc
        cecho lmag --------------
        cat /tmp/h.tmp | sed "/tidy/d"
    fi
fi

if [[ $issues_only_yn == n ]]; then
    if [[ "$filter" == ".*" ]]; then
        fil=""
    else
        fil="(filter: *$filter*)"
        lin=$(echo $fil | sed 's/./-/g; s/$/-/')
    fi
    cecho lmag -----------$lin
    cecho lmag help_lines: $cmag$fil
    cecho lmag -----------$lin
fi

if [[ $issues_only_yn == y ]]; then
    exit
fi

prev_char=""

find . -maxdepth 1 -type f -executable -printf "%f\n" \
    | xargs grep --ignore-case -H -s -i -e "^help_line=" -e "^-- help_line:" | egrep --ignore-case "$filter" > /tmp/h.tmp

# Append any alias descriptions to the help lines
aliases="$(grep -E --ignore-case "^alias " /home/martin/mjnurse/bash/mjn-bashrc)"
while IFS= read -r line; do
    # Extract the script name (text before the first colon)
    script_name=$(echo "$line" | cut -d: -f1)
    # echo SCRIPT: $script_name

    # Check if an alias exists for this script name
    alias_desc=$(alias | grep --ignore-case "$script_name" 2>/dev/null | sed "s/^alias $script_name='\(.*\)'$/\1/")
    alias_desc="$(egrep --ignore-case "alias.*'$script_name'" <<< "$aliases" | sed 's/^alias  *\([^=]*\)=.*/\1/')"
    # echo ALIAS: $alias_desc

    # If an alias exists and is different from the script name itself
    if [ -n "$alias_desc" ] && [ "$alias_desc" != "$script_name" ]; then
        # Append the alias description to the line
        echo "$line(#CGREalias: #CLGRE${alias_desc}#CDEF)"
    else
        # No alias found, print the line as-is
        echo "$line"
    fi
done < /tmp/h.tmp > /tmp/h.tmp2

cp /tmp/h.tmp2 /tmp/h.tmp

if [[ -f /home/martin/mjnurse/bash/mjn-bashrc ]]; then
    grep --ignore-case func: /home/martin/mjnurse/bash/mjn-bashrc | \
        egrep --ignore-case "$filter" | \
        sed 's/ *# *func: *\([^ :]\+\): *\(.*\)$/\1:help_line="\2 #CGRA(bash-function)#CDEF"/' >> /tmp/h.tmp

    grep -E --ignore-case "^alias.*#" /home/martin/mjnurse/bash/mjn-bashrc | \
        egrep --ignore-case "$filter" | \
        sed 's/alias *\([^=]*\)=\(.*\)# help_line:*=* *\(.*\) *$/\1:help_line="\3 #CGRA(alias-only)#CDEF"/' >> /tmp/h.tmp
fi

cat /tmp/h.tmp | \
sed '
    s/\\/\\\\/g;
    /help_line=.*tbc.*/d
    /^h:/d; s/help_line=//I; s/-- help_line://I; s/"/ /g;
    /tidy:.*echo/d;
    /^README.*md/d;
    s/:[0-9][0-9]*:/:/;
    s/ )#CDEF/)#CDEF/;
    s/#CGRE/'${cgre}'/g;
    s/#CLGRE/'${clgre}'/g;
    s/#CGRA/'${cgra}'/g;
    s/#CDEF/'${cdef}'/g;
    ' | \
sort | while IFS= read -r line ; do 
    curr_char="${line:0:1}"
    line="${line/ALIASONLY/${cgra}alias-only:}"
    if [[ "$curr_char" != "$prev_char" ]]; then
         prev_char="$curr_char"
         echo -e "${clmag}${curr_char}${cdef} - ${clcya}$line"
    else
         echo -e "${cdef}${cdef}    ${clcya}$line" 
    fi
done | sed  "
     s/: /:$cdef                                                     /;
     s/\(...............................................\) *\(.*\)/\1\2/;
     s/^\([^:]*\)${filter//\.\*/}/\1${cyel}${filter//\.\*/}${clcya}/g;
     s/^\(.*:.*\)${filter//\.\*/}/\1${cyel}${filter//\.\*/}${cdef}/g;
     /tidy:.*echo/d
     " > /tmp/h.out 

cat /tmp/h.out
rm -f /tmp/h.out /tmp/h.tmp
