#!/bin/bash
#
#This script compiles, runs, records output, and diff's student submissions.
#
#We assume that ./organize.sh has been run prior to executing this script (as
#   in the lab folder passed-in has been "organized") 
#
#Authors:
#
#   Schuyler Martin @schuylermartin45
#

#Work through the sym links back to the script's actual running directory 
SOURCE="${BASH_SOURCE[0]}"
while [ -h "${SOURCE}" ]; do 
    DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
    SOURCE="$(readlink "${SOURCE}")"
    [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
done
DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
#load up the common library
source ${DIR}"/.commonLib.sh"

####  CONSTANTS  ####

####    FLAGS    ####
#All flags are = 0 for on

#### GLOBAL VARS ####

####  FUNCTIONS  ####

#[DESCRIPTION]
#@param: 
#        $1
#        $2
#
#@return: 
#        - var1
#        - var2
#
#@global:
#        - var1
#        - var2
function name {
    echo pass
}

####   GETOPTS   ####
while getopts ":q" opt; do
    case $opt in
        q)
            QUIET=0
            ;;
        *)
            echoerr "Usage: "
            ;;
    esac
done

####    MAIN     ####
function main {
    echo "Test dir "$TEST_DIR
    echo "Out "$OUTPUT_DIR
}

main "${@}"
