#!/bin/bash
#
#This is a common library of functions and constants used throughout the 
#   grading scripts
#
#Authors:
#
#   Schuyler Martin @schuylermartin45
#

####  CONSTANTS  ####

#folder prefix constants
declare -r LABNAME="lab"
declare -r SECNAME="sec_"

#Directories created by the organize script
#files to pass in, used to test a student's program; for each lab
declare -r TEST_DIR="test_files"
#expected output; used to diff against the student's output; for each lab
declare -r EXPECTED_DIR="expected_output"
#stores provided program/class files; for each lab
declare -r PROVIDED_DIR="provided_files"
#stores output and diff files; for each student
declare -r OUTPUT_DIR="output"
#stores files for cheat-checking
declare -r CHEAT_DIR="cheat_files"
#solution directory (to put solution into)
declare -r SOL_DIR="sol"

#output of batchRun files
declare -r OUT_FILE="out_"
declare -r DIFF_FILE="diff_"
#output of cheatCheck
declare -r CHEAT_FILE="cheat_results.txt"

#Marking prefixes
#Mark of failure
declare -r MRKFAIL="0_FAIL_"
#Mark of lateness
declare -r MRKLATE="0_LATE_"

####    FLAGS    ####
#All flags are = 0 for on
#Quiet mode; used in all scripts for the echo functions
QUIET=1

#### GLOBAL VARS ####

####  FUNCTIONS  ####

#Functions for wrapping echo for color and STDERR
#output is suppressed if the QUIET flag is set
#tput colors are only applied if TERM is set (disabled if run as a cron job)
function echoerr {
    if [[ ! ${QUIET} = 0 ]]; then
        if [[ ! -z ${TERM} ]]; then
            tput setaf 1
        fi
        echo "ERROR: "${@} 1>&2
        if [[ ! -z ${TERM} ]]; then
            tput sgr0
        fi
    fi
}

function echowarn {
    if [[ ! ${QUIET} = 0 ]]; then
        if [[ ! -z ${TERM} ]]; then
            tput setaf 3
        fi
        echo "WARNING: "${@}
        if [[ ! -z ${TERM} ]]; then
            tput sgr0
        fi
    fi
}

function echosucc {
    if [[ ! ${QUIET} = 0 ]]; then
        if [[ ! -z ${TERM} ]]; then
            tput setaf 2
        fi
        echo ${@}
        if [[ ! -z ${TERM} ]]; then
            tput sgr0
        fi
    fi
}

