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
declare -r DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
#load up the common library
source ${DIR}"/.commonLib.sh"

####  CONSTANTS  ####
declare -r USAGE="Usage: ./cheatCheck.sh [-q] lab file [files...]"

#thresshold values for diff counts
#on a test sample, the average diff count between student files was 
#between 250-350; so that's where these rough numbers come from
#mid/medium chance of cheating
declare -r MID=200
#high chance of cheating
declare -r HIGH=100

####    FLAGS    ####
#All flags are = 0 for on
#Quiet mode
QUIET=1

#### GLOBAL VARS ####

#Two lists for cheaters, depending on number of diffs
midArray=()
highArray=()

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

#Diffs files and records possible cheaters into two lists
#@param: 
#        $1 path to check file
#        $2 path to student file (of same name)
#        $3 student's user name/folder name
#
#@return: 
#
#@global:
#        - [mid|high]Array arrays for checking
function runDiff {
    local checkFile="$1"
    local stuFile="$2"
    local stuName="$3"
    if [[ ! -f "${stuFile}" ]]; then
        echoerr "File ${stuFile} does not exist. User results not recorded."
    else
        local diffCnt="$(diff -U 0 "${checkFile}" "${stuFile}" | grep -v ^@ | wc -l)"
        #generate the result string
        local result="${diffCnt} diffs from ${stuName} -> ${stuFile}"
        #put the result in the appropriate list, if need be
        if [[ ${diffCnt} -le ${HIGH} ]]; then
            highArray+=("${result}")
        else
            if [[ ${diffCnt} -le ${MID} ]]; then
                midArray+=("${result}")
            fi
        fi
    fi
}

#Generates a report file
#@param: 
#
#@return: 
#
#@global:
#        - [mid|high]Array arrays for checking
function generateReport {
    local fileName="${labDIR}/${CHEAT_DIR}/${CHEAT_FILE}"
    #clear/make file
    echo -n "" > ${fileName}
    echo "Medium-risk cheaters (${HIGH} to ${MID} diffs):" >> ${fileName}
    for student in "${midArray[@]}"; do
        echo "    ${student}" >> ${fileName}
    done
    echo "High-risk cheaters (<${HIGH} diffs): " >> ${fileName}
    for student in "${highArray[@]}"; do
        echo "    ${student}" >> ${fileName}
    done
}


####   GETOPTS   ####
while getopts ":q" opt; do
    case $opt in
        q)
            QUIET=0
            ;;
        *)
            echoerr ${USAGE}
            exit 1
            ;;
    esac
done

####    MAIN     ####
function main {
    #shift after reading getopts
    shift $(($OPTIND - 1))
    #no args after flags, present usage message
    if [[ ${#@} -lt 2 ]]; then
        echoerr ${USAGE}
        exit 1
    fi
    labDIR="$1"
    if [[ ! -d "${labDIR}" ]]; then
        echoerr "Could not find lab: ${labDIR}"
        exit 1
    fi
    shift 1
    #check if files exist
    for file in "${@}"; do
        if [[ ! -f ${file} ]]; then
            echoerr "Could not find file: ${file}"
            exit 1
        fi
    done
    #loop over all sections in a lab; only folders
    echosucc "Starting cheat-check..."
    for sec in "${labDIR}/${SECNAME}"*/; do
        echosucc "Working on: $(basename "${sec}")..."
        #loop over all students in a section; only folders
        for student in "${sec}"*/; do
            #diff files provided
            for file in "${@}"; do
                #diff files with same name
                stuDIR="${student}$(basename "${file}")"
                stuName="$(basename "${student}")"
                runDiff "${file}" "${stuDIR}" "${stuName}"
            done
        done
    done
    echo "Cheat-check complete!"
    generateReport
    echosucc "Results have been recorded in: ${CHEAT_DIR}/${CHEAT_FILE}"
}

main "${@}"
