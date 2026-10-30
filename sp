#!/usr/bin/env bash

help_line="Spell check words using aspell"

# Terminal Colours
cdef="\x1b[39m" # default colour
cbla="\x1b[30m"; cgra="\x1b[90m"; clgra="\x1b[37m"; cwhi="\x1b[97m"
cred="\x1b[31m"; cgre="\x1b[32m"; cyel="\x1b[33m"; cblu="\x1b[34m"; cmag="\x1b[35m"; ccya="\x1b[36m";
clred="\x1b[91m"; clgre="\x1b[92m"; clyel="\x1b[93m"; clblu="\x1b[94m"; clmag="\x1b[95m"; clcya="\x1b[96m"

function cecho {
    if [[ "$1" == "-u" ]]; then ul=true; shift; else ul=false; fi
    color=c$1; shift; echo -e "${!color}$*${cdef}"
    if $ul; then echo -e "${!color}${*//?/-}${cdef}"; fi
}

if [[ "$#" -eq 0 ]]; then
    echo "usage: sp <word1> <word2> ..."
    exit 1
fi

for w in "$@"; do
    printf "%s: " "$w"
    result=$(echo "$w" | aspell pipe | sed -n 2p)

    case "$result" in
        "*"*|"+"*)
            cecho lgre "Correct"
            ;;
        "&"*)
            cecho lmag "Incorrect:"
            IFS=',' read -ra sugg <<< "${result#*: }"
            for i in "${!sugg[@]}"; do
                sugg[i]="${sugg[i]# }"
                printf "${clcya} %d) ${cdef} %s\n" "$((i + 1))" "${sugg[i]}"
            done
            printf "${clcya}Number to copy to clipboard ${cdef}[1]: "
            read -r n
            n="${n:-1}"
            if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= 1 && n <= ${#sugg[@]} )); then
                printf "%s" "${sugg[n-1]}" | clip.exe
                cecho lcya "Copied: ${cdef} ${sugg[n-1]}"
            else
                cecho red "Invalid selection, nothing copied"
            fi
            ;;
        *)
            cecho lmag "Incorrect: no suggestions"
            ;;
    esac
done
