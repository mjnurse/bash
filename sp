#!/usr/bin/env bash

help_line="Spell check words using aspell"

if [[ "$#" -eq 0 ]]; then
    echo "usage: sp <word1> <word2> ..."
    exit 1
fi

for w in "$@"; do
    printf "%s: " "$w"
    result=$(echo "$w" | aspell pipe | sed -n 2p)

    case "$result" in
        "*"*|"+"*)
            echo "Correct"
            ;;
        "&"*)
            echo "Incorrect:"
            IFS=',' read -ra sugg <<< "${result#*: }"
            for i in "${!sugg[@]}"; do
                sugg[i]="${sugg[i]# }"
                printf " %d) %s\n" "$((i + 1))" "${sugg[i]}"
            done
            read -rp "Number to copy to clipboard [1]: " n
            n="${n:-1}"
            if [[ "$n" =~ ^[0-9]+$ ]] && (( n >= 1 && n <= ${#sugg[@]} )); then
                printf "%s" "${sugg[n-1]}" | clip.exe
                echo "Copied: ${sugg[n-1]}"
            else
                echo "Invalid selection, nothing copied"
            fi
            ;;
        *)
            echo "Incorrect: no suggestions"
            ;;
    esac
done
