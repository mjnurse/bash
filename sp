#!/usr/bin/env bash
help_text="
NAME
    sp - One line description.

USAGE
    sp [options] <parameters>

OPTIONS
    -x
        Description...

    -h|--help
        Show help text.

DESCRIPTION
    Description description description description.

AUTHOR
    mjnurse.github.io - 2026
"
help_line="tbc"
web_desc_line="tbc"

try="Try ${0##*/} -h for more information"
tmp="${help_text##*USAGE}"
usage=$(echo "Usage: ${tmp%%OPTIONS*}" | tr -d "\n" | sed "s/  */ /g")

if [[ "$1" == "" ]]; then
    echo "${usage}"
    echo "${try}"
    exit 1
fi

case $1 in
    -h|--help)
        echo "$help_text"
        exit
        ;;
esac

==> ./sp <==
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
