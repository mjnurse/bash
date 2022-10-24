#!/bin/bash

function l {
   d=$(date +'%m/%d %H:%M:%S')
   echo "$d: $*" >> $0.log
}

l "$*"

case $1 in
   # --------------------------------------------------------------------------------
   cmd|file)
      case $1 in
         cmd)
            shift
            echo "$*" > hbg.cmd
            ;;
         file)
            cat $2 > hbg.cmd
            ;;
      esac
      echo " " > nohup.out
      echo "x" > hbg.runflag
      hbg wait hbg.finishedflag
      l "Query finshed - results ready"
      cat nohup.out >> $0.log
      cat nohup.out | sed "/^@*OK/d; /at org.apache.hadoop/d; /at sun.reflect./d; /at java.lang.reflect/d; / at org.apache.hadoop/d"
      rm -f hbg.cmd
      ;;
   # --------------------------------------------------------------------------------
   kill)
      pid=$(ps -edf | grep java.*hbg | grep -v grep | sed "s/^[0-9]\+\s\+\([0-9]\+\).*/\1/")
      kill -9 $pid
      ;;
   # --------------------------------------------------------------------------------
   shutdown)
      echo "Instructing background hive session to exit"
      echo "!hbg finished;" > hbg.cmd
      echo "exit;" >> hbg.cmd
      echo "x" > hbg.runflag
      hbg wait hbg.finishedflag
      rm -f hbg.*
      ;;
   # --------------------------------------------------------------------------------
   status)
      if [[ "$(ps -edf | grep java.*hbg | grep -v grep | wc -l)" == "1" ]]; then
         pid=$(ps -edf | grep java.*hbg | grep -v grep | sed "s/^[0-9]\+\s\+\([0-9]\+\).*/\1/")
         echo "hbg: background task running.  PID: $pid"
      else
         echo "hbg: background task not running"
      fi
      ;;
   # --------------------------------------------------------------------------------
   finished)
      echo "x" > hbg.finishedflag
      ;;
   # --------------------------------------------------------------------------------
   wait)
      while [[ ! -e $2 ]]; do
         sleep 0.1
      done
      rm -f $2
      ;;
   # --------------------------------------------------------------------------------
   startup)
      c=0
      echo "set hive.cli.errors.ignore=true;" > hbg.bgscript
      echo "set hive.resultset.use.unique.column.names=false;" >> hbg.bgscript
      echo "set hive.cli.print.header=true;" >> hbg.bgscript
      while [[ $c -lt 10000 ]]; do
         echo "!hbg wait hbg.runflag;" >> hbg.bgscript
         echo "source hbg.cmd;" >> hbg.bgscript
         echo "!hbg finished;" >> hbg.bgscript
         let c=c+1
      done
      echo "Starting background hive session..."
      nohup hive -S -f hbg.bgscript &
      echo "Started"
      ;;
   # --------------------------------------------------------------------------------
   *)
      echo "usage: hbg <cmd|file|shutdown|startup|status> [<command or file>]"
      ;;
esac
