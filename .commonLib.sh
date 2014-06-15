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

#Directories created by the organize script
#files to pass in, used to test a student's program; for each lab
TEST_DIR="test_files"
#expected output; used to diff against the student's output; for each lab
EXPECTED_DIR="expected_output"
#stores provided program/class files; for each lab
PROVIDED_DIR="provided_files"
#stores output and diff files; for each student
OUTPUT_DIR="output"

#Marking prefixes
#Mark of failure
MRKFAIL="FAIL_"
#Mark of lateness
MRKLATE="LATE_"

####    FLAGS    ####
#All flags are = 0 for on
#Quiet mode; used in all scripts for the echo functions
QUIET=1

#### GLOBAL VARS ####

####  FUNCTIONS  ####

#Functions for wrapping echo for color and STDERR
function echoerr {
    if [[ ! ${QUIET} = 0 ]]; then
        tput setaf 1
        echo "ERROR: "${@} 1>&2
        tput sgr0
    fi
}

function echowarn {
    if [[ ! ${QUIET} = 0 ]]; then
        tput setaf 3
        echo "WARNING: "${@}
        tput sgr0
    fi
}

function echosucc {
    if [[ ! ${QUIET} = 0 ]]; then
        tput setaf 2
        echo ${@}
        tput sgr0
    fi
}

