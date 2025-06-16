#!/bin/bash
help_text="
NAME
  sl - One line description.

USAGE
  sl [options] <parameters>

OPTIONS
  -x
    Description...

  -d|--debug
    Run in debug mode.

  -h|--help
    Show help text.

DESCRIPTION
  Description description description description.

AUTHOR
  mjnurse.dev - 2020
"
help_line="tbc"
web_desc_line="tbc"

try="Try ${0##*/} -h for more information"
tmp="${help_text##*USAGE}"
usage="$(echo Usage: ${tmp%%OPTIONS*})"

if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "?" ]]; then
   echo "$help_text"
   exit
fi

debug_yn=n
spool_file="/dev/null"

function debug() {
  if [[ $debug_yn == y ]]; then
    echo $*
  fi
}

function run() {
  if [[ "$buf" == "" ]]; then
    buf="$line"
  elif [[ "$line" != "" ]]; then
    buf="$buf\n$line"
  fi
  history -s "${buf/;/}"
  echo -e "$buf" | sqlite3 $sl_options $db | tee -a $spool_file
  mode=run
}

while [[ "$1" != "" ]]; do
   case $1 in
      -h|--help)
         echo "$help_text"
         exit
         ;;
      -d|--debug)
         debug_yn=y
         ;;
      ?*)
         break
         ;;
   esac
   shift
done

db="$1"
if [[ "$db" == "" ]]; then
  echo
  echo "No database open.  Use 'o <database name>' to open a database"
  echo
fi

buf=""
mode=null
sl_options="-csv -header"

# OPTIONS include:
#    -ascii               set output mode to 'ascii'
#    -bail                stop after hitting an error
#    -batch               force batch I/O
#    -column              set output mode to 'column'
#    -cmd COMMAND         run "COMMAND" before reading stdin
#    -csv                 set output mode to 'csv'
#    -echo                print commands before execution
#    -init FILENAME       read/process named file
#    -[no]header          turn headers on or off
#    -help                show this message
#    -html                set output mode to HTML
#    -interactive         force interactive I/O
#    -line                set output mode to 'line'
#    -list                set output mode to 'list'
#    -lookaside SIZE N    use N entries of SZ bytes for lookaside memory
#    -mmap N              default mmap size set to N
#    -newline SEP         set output row separator. Default: '\n'
#    -nullvalue TEXT      set text string for NULL values. Default ''
#    -pagecache SIZE N    use N slots of SZ bytes each for page cache memory
#    -quote               set output mode to 'quote'
#    -separator SEP       set output column separator. Default: '|'
#    -stats               print memory stats before each finalize
#    -version             show SQLite version
#    -vfs NAME            use NAME as the default VFS

while [[ 1 ]]; do
  if [[ $mode == ins ]]; then
    prompt="  "
  else
    prompt="> "
  fi
  debug "mode:$mode buff:$buf"
  read -e -p "$prompt" line

  if [[ "$line" == "" ]]; then
    mode=null
  elif [[ $mode == ins ]]; then
    case "$line" in
      \;)
        line=""
        run
        ;;
      *\;)
        line="${line::-1}"
        run
        ;;
      *)
        buf="$buf\n$line"
        ;;
    esac
  else
    case "$line" in
      \;)
        line=""
        run
        ;;
      *\;)
        if [[ $mode == run ]]; then
          buf=""
        fi
        line="${line::-1}"
        run
        ;;
      .*)
        buf=""
        run
        ;;
      @*)
        file="${line:1}"
        if [[ ! -f $file ]]; then
          file="${file}.sql"
        fi
        if [[ ! -f $file ]]; then
          echo "no such file"
        else
          history -s "$line"
          cat $file | sqlite3 $sl_options $db | tee -a $spool_file
        fi
        ;;
      a)
        echo -e "$buf"
        mode=ins
        ;;
      c)
        echo "buffer cleared"
        buf=""
        ;;
      cls)
        cls
        ;;
      g)
        echo "Use 'g <filename>' to load a file to the buffer"
        ;;
      g\ *)
        file="${line:2}"
        if [[ ! -f $file ]]; then
          file="${file}.sql"
        fi
        if [[ ! -f $file ]]; then
          echo "no such file"
        else
          history -s "${line}"
          buf="$(cat $file)"
          echo -e "$buf"
        fi
        ;;
      l)
        echo -e "$buf"
        ;;
      ls)
        ls | sort
        ;;
      ll)
        ls -al
        ;;
      o)
        echo "Use 'o <database name>' to open a database"
        ;;
      o\ *)
        history -s "${line}"
        db="${line:2}"
        if [[ ! -f $db ]]; then
          echo "database:$db does not exist"
          db=""
        else
          echo ".database" | sqlite3 $sl_options $db | tee -a $spool_file
        fi
        ;;
      q|x|quit|exit)
        exit
        ;;
      s\ *|save\ *)
        if [[ "$line" =~ s\ .* ]]; then
          file="${line:2}"
        else
          file="${line:5}"
        fi
        if [[ "$file" == "" ]]; then
          file="buf.sql"
        fi
        echo -e "$buf" > $file
        echo "saved to file: $file"
        ;;
      spool)
        echo "use 'spool <filename>' to spool output to a file"
        ;;
      spool\ *)
        spool_file="${line:6}"
        if [[ ${spool_file,,} == off ]]; then
          spool_file="/dev/null"
          echo "Spooling off"
        else
          echo "Spooling to file: $spool_file"
        fi
        ;;
      *)
        mode=ins
        buf="$line"
        ;;
    esac
  fi
done
