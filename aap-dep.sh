#!/bin/bash
#
# Martin Nurse - RMG.  Nov-2017

help_text="
NAME
	aap_dep - AAP (Advanced Analytics Platform) Dependency Tool

USAGE
	aap_dep <action> <this task name> <other task name1> [<other task name 2> .. <other task name 3>]

	action = WAIT|RUN|SUCCESS|FAILED|FORCE-START

DESCRIPTION

	This script creates, manages and acts upon a set of flag files which allow dependences between
	tasks to be specified and acted upon.

	There are 5 different flag files, one for each action:

	WAITING -     This indicates that the corresponding task has been started and is waiting for
                      other tasks to finish.  The name of the task which this task is waiting on is
                      written to the flag file every minute.  aap_dep will run until the wait
                      conditions are met.

	RUNNING -     This indicates that the corresponding task is running. aap_dep will create the
                      flag file and finish.

	SUCCESS -     This indicates that the corresponding task has completed successfully.  Any
                      useful information can be written to this flag file.  aap_dep will create the
                      flag file and finish.

	FAILED -      This indicates that the corresponding task has completed but has not run
                      successfully.  Any useful error details can be written to this flag file.  aap_dep
                      will create the flag file and finish.

	FORCE-START - This flag file is created to force start a task.  Once this flag exists the
                      corresponding task will run next time it checks even if the preceding tasks
                      haven’t finished.

	The flag files will be named as follows:

        	YYYYMMDD-HH24MISS-UniqueProcessName-[WAITING|RUNNING|SUCCESS|FAILED].

	For example:

        	20171011-225311-create_gps_orc_data-WAITING

ENVIRONMENT VARIABLES USED

	AAP_DEP_FLAG_DIR - The location of the directory to which the flag files are written.

	AAP_DEP_SLEEP_SECONDS - The time waited between each check of the flag files.

EXAMPLE USE

        # script_a will run when script_b and script_c finish with success.  script_a will be in the name
        # of the flag file.  aap_dev will not return until the wait conditions are met, this will be
        # indicated by the presence of a script_b and script_c SUCCESS flag file.
        app_dep WAIT script_a script_b script_c

        # This creates a flag file to indicate the script_a has run successfully
        app_dep SUCCESS script_a
"

# If no environment AAP_DEP_FLAG_DIR variable then set the directory where the flags are written
if [ -z "$AAP_DEP_FLAG_DIR" ]; then
        AAP_DEP_FLAG_DIR=./flag
fi

if [ ! -e ${AAP_DEP_FLAG_DIR} ]; then
        echo aap_dep: flag file directory: ${AAP_DEP_FLAG_DIR} does not exist
        echo Try app_dev -help for more information.
        exit;
fi

# If no environment variable then set the sleep time
if [ -z "$AAP_DEP_SLEEP_SECONDS" ]; then
        AAP_DEP_SLEEP_SECONDS=60
fi

# get command line options
op=$1
this_task=$2
other_task=$3

case $op in
        -help|--help|-h|--h)
        echo "$help_text"
        ;;
        ARCHIVE|archive)
        if [ ! -d ${AAP_DEP_FLAG_DIR}/archive ]; then
                echo app_dep: archive directory ${AAP_DEP_FLAG_DIR}/archive missing
                echo Try app_dev -help for more information.
                exit;
        fi
        mv ${AAP_DEP_FLAG_DIR}/2* ${AAP_DEP_FLAG_DIR}/archive 2>/dev/null
        ;;
        WAIT|wait)
        if [ $# -lt 3  ]; then
                echo app_dep: A WAIT process needs 2 tasks.
                echo Try app_dev -help for more information.
                exit;
        fi
        flag_file=${AAP_DEP_FLAG_DIR}/$(date "+%Y%m%d-%H%M%S")-${this_task}-WAITING
        while [ $# -gt 2 ]; do
                other_task=$3
                echo Waiting For: ${other_task} - $(date "+%Y%m%d-%H%M%S") >> ${flag_file}
                while [ ! -e ${AAP_DEP_FLAG_DIR}/*${other_task}-SUCCESS ]  \
                   && [ ! -e ${AAP_DEP_FLAG_DIR}/*${this_task}-FORCE-START ]; do
                        sleep ${AAP_DEP_SLEEP_SECONDS}
                        echo Waiting For: ${other_task} - $(date "+%Y%m%d-%H%M%S") >> ${flag_file}
                done
                shift
        done
        ;;
        RUN|run)
        flag_file=${AAP_DEP_FLAG_DIR}/*-${this_task}
        if [ -e ${flag_file}-SUCCESS ]; then
                echo app_dep: task ${this_task} has already run successfully.
                exit;
        fi
        f=$(ls ${AAP_DEP_FLAG_DIR}/2*${this_task}* 2>/dev/null | sort | tail -n1| grep RUNNING)
        if [ -n "$f" ]; then
                echo app_dep: task ${this_task} is already running.
                exit;
        fi
        flag_file=${AAP_DEP_FLAG_DIR}/$(date "+%Y%m%d-%H%M%S")-${this_task}
        echo "." > ${flag_file}-RUNNING
        ;;
        SUCCESS|success)
        flag_file=${AAP_DEP_FLAG_DIR}/*-${this_task}
        if [ -e ${flag_file}-SUCCESS ]; then
                echo app_dep: task ${this_task} has already run successfully.
                exit;
        fi
        flag_file=${AAP_DEP_FLAG_DIR}/$(date "+%Y%m%d-%H%M%S")-${this_task}-SUCCESS
        echo "." > ${flag_file}
        ;;
        FAILED|failed)
        flag_file=${AAP_DEP_FLAG_DIR}/*-${this_task}
        if [ -e ${flag_file}-SUCCESS ]; then
                echo app_dep: task ${this_task} has already run successfully.
                exit;
        fi
        flag_file=${AAP_DEP_FLAG_DIR}/$(date "+%Y%m%d-%H%M%S")-${this_task}-FAILED
        echo "." > ${flag_file}
        ;;
        FORCE-START|force-start)
        flag_file=${AAP_DEP_FLAG_DIR}/$(date "+%Y%m%d-%H%M%S")-${this_task}-FORCE-START
        echo "." > ${flag_file}
        ;;
        *)
        echo app_dep: error
        echo Try app_dev -help for more information.
        ;;
esac

