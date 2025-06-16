#!/bin/bash
help_text="
NAME
  app - start/restart/stop/status of a list of services/applications.

USAGE
  app [options] <action> [<service or application name>]

OPTIONS
  -h|--help
    Show help text.

  -l|--list
    List the services / applications covered.

DESCRIPTION
  A convenience script to start, stop or get the status of various services / applications.

AUTHOR
  mjnurse.dev - 2023
"
help_line="start,restart,stop,status of a list of services,applications"
web_desc_line="start,restart,stop,status of a list of services,applications"

try="Try ${0##*/} -h for more information"
tmp="${help_text##*USAGE}"
usage=$(echo "Usage: ${tmp%%OPTIONS*}" | tr -d "\n" | sed "s/  */ /g")

if [[ "$1" == "" ]]; then
  echo "${usage}"
  echo "${try}"
  exit 1
fi

action="none"

function inv_action() {
  echo "Action: \"$action\" is not valid for application/service \"$1\""
  echo "${try}"
  exit 1
}

while [[ "$1" != "" ]]; do
  case $1 in 
    -h|--help) 
      echo "$help_text"
      exit
      ;;
    -l|--list)
      echo "Services/Applications:"
      grep "#SVC$" $(which start) | sed "s/^ */- /; s/).*//"
      exit
      ;;
    start)
      action=start
      ;;
    stop)
      action=stop
      ;;
    status)
      action=status
      ;;
    docker) #SVC
      case $action in
        start|stop|status|restart)
          sudo service docker $action
          ;;
        *)
          inv_action $1
          ;;
      esac
      ;;
    elasticsearch) #SVC
      case $action in
        start|stop|status|restart)
          sudo service elasticsearch $action
          ;;
        *)
          inv_action $1
          ;;
      esac
      ;;
    hadoop) #SVC
      case $action in
        start)
          sudo service ssh restart
          /c/MJN/quantexa/wsl/hadoop-3.2.4/sbin/start-dfs.sh
          /c/MJN/quantexa/wsl/hadoop-3.2.4/sbin/start-yarn.sh
          ;;
        *)
          inv_action $1
          ;;
      esac
      ;;
    postgres) #SVC
      case $action in
        start|stop|status|restart)
          sudo service postgres $action
          ;;
        *)
          inv_action $1
          ;;
      esac
      ;;
    spark-history-server) #SVC
      case $action in
        start)
          $SPARK_HOME/sbin/start-history-server.sh
          ;;
        *)
          inv_action $1
          ;;
      esac
      ;;
    *)
      case $action in
        start|stop|status|restart)
          echo "Error: \"$1\" is not a valid application/service"
          ;;
        *)
          echo "Error: \"$1\" is not a valid action"
          ;;
      esac
      echo "${try}"
      exit 1
      ;;
  esac 
  shift
done 

#case $action in
#esac

