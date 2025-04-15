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

alias ge='bash -c "cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/bash; gvim g"'
alias gp='g -p'

echo
echo EDIT ALIASES
echo ------------
alias | grep 'alias e.*' | sed "s/^/- /; s/=/ = /" | sort | sed "/grep/d" | \
        egrep --color=auto "alias e[a-z]*"

# ------------------------------------------------------------------------------------------

alias gapi="cd /c/quantexa/q-apis; ls"
alias gbash="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/bash; ls"
alias gbin="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/bin; ls"
alias gcli="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/cli-builder; ls"
alias gdocs="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/Documents; ls"
alias gdown="cd /c/Users/MartinNurse/Downloads/; ls"
alias ges="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/quantexa/es-perf-test; ls"
alias ggd="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/ ls"
alias ggh="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github; ls"
alias ggithub="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github; ls"
alias ghier="cd /c/q-repos/project-hierarchy-management; ls"
alias gjs="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/javascript; ls"
alias gmjn="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN; ls"
alias gmjns="cd /c/quantexa/mjn-scripts; ls"
alias gpe="cd /c/q-repos/project-example-2.5; ls"
alias gped="cd /c/q-repos/project-example-deployment-2.5; ls"
alias gqp="cd /c/q-repos; ls"
alias gqu="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/quantexa; ls"
alias gsc="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/scratch; ls"
alias gscratch="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/scratch; ls"
alias gtmp="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/quantexa/tmp; ls"
alias gtodo="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/todo-done; ls"
alias gweb="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/mjnurse-github-io; ls"
alias gwin="cd /mnt/c/Users/MartinNurse/; ls"
alias gwip="cd /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/code/wip; ls"

echo
echo GOTO ALIASES
echo ------------
alias | grep 'alias g.*' | sed "s/^/- /; s/=/ = /" | sort | sed "/grep/d; / gvim.exe/d" | \
        grep --color=auto " g[a-z]* "

# ------------------------------------------------------------------------------------------

alias lb="ll /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/bash"
alias lj="ll /c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/javascript"

echo
echo LS ALIASES
echo ----------

alias | grep 'alias l.*ll.*' | sed "s/^/- /; s/=/ = /" | sort | grep --color=auto " l[a-z]*"

# ------------------------------------------------------------------------------------------

export B="/c/Users/MartinNurse/OneDrive - Quantexa Ltd/MJN/github/bash"
export J=/c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/javascript
export M=/c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN
export Q=/c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/quantexa
export T=/c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/todo
export W=/c/Users/MartinNurse/OneDrive\ -\ Quantexa\ Ltd/MJN/github/web

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
