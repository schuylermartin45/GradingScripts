#!/bin/bash
#
#cheatCheck diffs files to check for copied work, based on a threshold value
#Note that this will not catch all cheaters, just the most obvious cases
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
USAGE="Usage: ./cheatCheck.sh [-q] [files...]"

####    FLAGS    ####
#All flags are = 0 for on
#Quiet mode
QUIET=1

#### GLOBAL VARS ####

####  FUNCTIONS  ####

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
}

####   GETOPTS   ####
while getopts ":q" opt; do
    case $opt in
        q)
            QUIET=0
            ;;
        *)
            echo ${USAGE}
            exit 1
            ;;
    esac
done

####    MAIN     ####
function main {
    #shift after reading getopts
    shift $(($OPTIND - 1))
    #no args after flags, present usage message
    if [[ ${#@} = 0 ]]; then
        echo ${USAGE}
        exit 1
    fi
}

main "${@}"
