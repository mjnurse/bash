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

alias ge='bash -c "cd /c/MJN/drive/github/bash; gvim g"'
alias gp='g -p'

if [[ $1 == -p ]]; then
  echo
  echo EDIT ALIASES
  echo ------------
  alias | grep 'alias e.*' | sed "s/^/- /; s/=/ = /" | sort | sed "/grep/d" | \
        egrep --color=auto "alias e[a-z]*"
fi

# ------------------------------------------------------------------------------------------

alias gapi="cd /c/quantexa/q-apis; ls"
alias gbash="cd /c/MJN/drive/github/bash; ls"
alias gbin="cd /c/MJN/drive/bin; ls"
alias gcli="cd /c/MJN/drive/github/cli-builder; ls"
alias gdown="cd /c/Users/MartinNurse/Downloads/; ls"
alias ggd="cd /c/MJN/drive; ls"
alias ggh="cd /c/MJN/drive/github; ls"
alias ggithub="cd /c/MJN/drive/github; ls"
alias gjs="cd /c/MJN/drive/github/javascript; ls"
alias gmjn="cd /c/MJN; ls"
alias gmjns="cd /c/quantexa/mjn-scripts; ls"
alias gpe="cd /c/quantexa/project-example-2.5; ls"
alias gped="cd /c/quantexa/project-example-deployment-2.5; ls"
alias gqu="cd /c/quantexa; ls"
alias gsc="cd /c/MJN/drive/github/scratch; ls"
alias gscratch="cd /c/MJN/drive/github/scratch; ls"
alias gtodo="cd /c/MJN/drive/github/todo-done; ls"
alias gweb="cd /c/MJN/drive/github/mjnurse-github-io; ls"
alias gwin="cd /mnt/c/Users/MartinNurse/; ls"

if [[ $1 == -p ]]; then
  echo
  echo GOTO ALIASES
  echo ------------
  alias | grep 'alias g.*' | sed "s/^/- /; s/=/ = /" | sort | sed "/grep/d; / gvim.exe/d" | \
        grep --color=auto " g[a-z]*"
fi

# ------------------------------------------------------------------------------------------

alias lb="ll /c/MJN/drive/github/bash"
alias lj="ll /c/MJN/drive/github/javascript"

if [[ $1 == -p ]]; then
  echo
  echo LS ALIASES
  echo ----------

  alias | grep 'alias l.*ll.*' | sed "s/^/- /; s/=/ = /" | sort | grep --color=auto " l[a-z]*"
fi

# ------------------------------------------------------------------------------------------

export B=/c/MJN/drive/github/bash
export J=/c/MJN/drive/github/javascript
export W=/c/MJN/drive/github/web
export T=/c/MJN/drive/todo

if [[ $1 == -p ]]; then
  echo
  echo ENV VARS
  echo --------
  export | grep -e ' [A-Z]=' | sed "s/declare -x/- export/; s/=/ = /" | sort | \
         egrep --color=auto " [A-Z]*"

  echo
  echo Use ge - to edit
  echo     gp - to print
  echo
  echo ---------------------------
  echo REMEMBER use source g / . g
  echo ---------------------------
fi
