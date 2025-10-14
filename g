#!/bin/bash
help_text="
NAME
   g - Creates a set of alias to 'go' to various directories.

USAGE
   g

DESCRIPTION
   Creates a set of alias to 'go' to various directories.

AUTHOR
  mjnurse.uk 2020
"
help_line="Creates a set of alias to 'go' to various directories"

alias ge='bash -c "cd \"$MJNWINROOT/MJN/github/bash\"; gvim g"'
alias gp='g -p'

# ------------------------------------------------------------------------------------------

alias gbash='cd "$MJNWINROOT/MJN/github/bash"; ls'
alias gbin='cd "$MJNWINROOT/MJN/bin"; ls'
alias gcli='cd "$MJNWINROOT/MJN/github/cli-builder"; ls'
alias gdocs='cd "$MJNWINROOT/Documents"; ls'
alias gdown='cd "$MJNWINROOT/Downloads/"; ls'
alias ggh='cd "$MJNWINROOT/MJN/github"; ls'
alias ggithub='cd "$MJNWINROOT/MJN/github"; ls'
alias gmjn='cd "$MJNWINROOT/MJN"; ls'
alias gpic='cd "$MJNWINROOT/Pictures"; ls'
alias gsc='cd "$MJNWINROOT/MJN/github/scratch"; ls'
alias gscratch='cd "$MJNWINROOT/MJN/github/scratch"; ls'
alias gtodo='cd "$MJNWINROOT/MJN/github/todo-done"; ls'
alias gweb='cd "$MJNWINROOT/MJN/github/mjnurse-github-io"; ls'
alias gwip='cd "$MJNWINROOT/MJN/code/wip"; ls'

echo
echo GOTO ALIASES
echo ------------
alias | grep 'alias g.*' | sed "s/^/- /; s/=/ = /" | sort | sed "/grep/d; / gvim.exe/d" | \
        grep --color=auto " g[a-z]* "

# ------------------------------------------------------------------------------------------

alias edown='explorer.exe "c:\Users\MartinNurse\Downloads"'
alias edocs='explorer.exe "c:\Users\MartinNurse\OneDrive - Quantexa Ltd\Documents"'
alias eimg='explorer.exe "c:\Users\MartinNurse\OneDrive - Quantexa Ltd\Pictures"'
alias epic='explorer.exe "c:\Users\MartinNurse\OneDrive - Quantexa Ltd\Pictures"'
alias ess='explorer.exe "c:\Users\MartinNurse\OneDrive - Quantexa Ltd\Pictures\Screenshots"'

echo
echo EXPLORER OPEN ALIASES
echo ---------------------
alias | grep 'alias e.*' | sed "s/^/- /; s/=/ = /" | sort | sed "/grep/d; / gvim.exe/d" | \
        grep --color=auto " e[a-z]* "

# ------------------------------------------------------------------------------------------

echo
echo LS ALIASES
echo ----------

alias | grep 'alias l.*ll.*' | sed "s/^/- /; s/=/ = /" | sort | grep --color=auto " l[a-z]*"

# ------------------------------------------------------------------------------------------

export B="$MJNWINROOT/MJN/github/bash"
export M="$MJNWINROOT/MJN"
export D="$MJNWINROOT/Documents"
export W="/c/Users/MartinNurse/Downloads"
export P="$MJNWINROOT/Pictures"
export S="$MJNWINROOT/Pictures/Screenshots"

echo
echo ENV VARS
echo --------
export | grep -e ' [A-Z]=' | sed "s/declare -x/- export/; s/=/ = /" | sort | \
         egrep --color=auto " [A-Z]* "

echo
echo Use ge\ -\ to edit
echo     gp\ -\ to print
echo
echo ---------------------------
echo REMEMBER use source g / . g
echo ---------------------------
