#!/bin/bash
#
# Martin N. 2018
#
usage="usage: bbg <option> [<command or file>]"
#
description="
NAME

   bbg - Beeline BackGround

   $usage

DESCRIPTION

   This script supports a process where Beeline is run as a background process which reads and executes
   sql files writing the results to result files.  This means the statement in the sql file can be run
   without having to wait for Beeline to startup.

   This script is passed one of the following parameter 1 options.  This allows the one script to
   perform a number of operations in support of the background Beeline service.

OPTIONS

   -c, --cmd
      The SQL command passed as parameter 2 is passed to beeline background task for execution.

   -d, --shutdown

   -f, --file
      The SQL in the file specified in parameter 2 is passed to beeline background task for execution.

   -F, --finished
      An INTERNAL option.  Creates a finished flag.  Use by beeline script to signal that the SQL
      execution has finished.

   -k, --kill
      Kills the background beeline task OS process.  An inelegant method to stop the background
      process.  Preferable to use --shutdown

   -u, --startup

   -s, --status

   -w, --wait
"

verboseyn=n

function p {
   echo "$*"
}

function l {
   d=$(date +'%m/%d %H:%M:%S')
   echo "$d: $*" >> $0.log
   if [[ "verboseyn" == "y" ]]; then echo "$d: $*"; fi
}

l "$*"

option=$1
shift
payload="$*"

case $option in
   -h|--help)
      echo "$description"
      ;;
   # --------------------------------------------------------------------------------
   -c|--cmd|-f|--file)
      case $option in
         -c|--cmd)
            echo "$payload" > $0.cmd
            ;;
         -f|--file)
            cat $payload > $0.cmd
            ;;
      esac
      echo "x" > $0.runflag
      $0 --wait $0.finishedflag
      l "Query finshed - results ready"
      cat bbg.results >> $0.log
      cat bbg.results | sed "/^>>> /d"
      rm -f $0.cmd
      ;;
   # --------------------------------------------------------------------------------
   -k|--kill)
      pid=$(ps -edf | grep java.*$0 | grep -v grep | sed "s/^[0-9]\+\s\+\([0-9]\+\).*/\1/")
      kill -9 $pid
      ;;
   # --------------------------------------------------------------------------------
   -d|--shutdown)
      echo "Instructing background beeline session to exit"
      echo "!sh $0 --finished" > $0.cmd
      echo "!quit" >> $0.cmd
echo 1
      echo "x" > $0.runflag
echo 2
      $0 --wait $0.finishedflag
echo 3
      rm -f $0.*
echo 4
      ;;
   # --------------------------------------------------------------------------------
   -s|--status)
      if [[ "$(ps -edf | grep java.*$0 | grep -v grep | wc -l)" == "1" ]]; then
         pid=$(ps -edf | grep java.*$0 | grep -v grep | sed "s/^[0-9]\+\s\+\([0-9]\+\).*/\1/")
         echo "$0: background task running.  PID: $pid"
      else
         echo "$0: background task not running"
      fi
      ;;
   # --------------------------------------------------------------------------------
   -F|--finished)
      echo "x" > $0.finishedflag
      ;;
   # --------------------------------------------------------------------------------
   -w|--wait)
      while [[ ! -e $payload ]]; do
         sleep 0.2
      done
      rm -f $payload
      ;;
   # --------------------------------------------------------------------------------
   # STARTUP:
   # Create a script to run in the background beeline process.  Start beeline as a
   # background process, use nohup.
   -u|--startup)
      c=0
      echo "set hive.cli.errors.ignore=true;" > $0.bgscript
      echo "set hive.resultset.use.unique.column.names=false;" >> $0.bgscript
      echo "set hive.cli.print.header=true;" >> $0.bgscript
      while [[ $c -lt 10000 ]]; do
         echo "!sh bbg --wait bbg.runflag" >> $0.script
         echo "!record bbg.results" >> $0.script
         echo "!run bbg.cmd" >> $0.script
         echo "!record" >> $0.script
         echo "!sh bbg --finished" >> $0.script
         let c=c+1
      done
      echo "Starting background beeline session..."
      nohup beeline --force=true -u "jdbc:hive2://rmalbghnn0002.hdp2.rmgv.royalmailgroup.net:2181,rmalbghnn0003.hdp2.rmgv.royalmailgroup.net:2181,rmalbghnn0001.hdp2.rmgv.royalmailgroup.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2" -f $0.script &
      #beeline -u "jdbc:hive2://rmalbghnn0002.hdp2.rmgv.royalmailgroup.net:2181,rmalbghnn0003.hdp2.rmgv.royalmailgroup.net:2181,rmalbghnn0001.hdp2.rmgv.royalmailgroup.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2" -f $0.script
      echo ""
      echo "Process Started"
      ;;
   # --------------------------------------------------------------------------------
   *)
      echo $usage
      echo "Try 'bbg --help' for more information."
      ;;
esac
