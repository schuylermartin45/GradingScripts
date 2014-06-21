#!/bin/bash
#
#This script compiles, runs, records output, and diff's student submissions.
#
#We assume that ./organize.sh has been run prior to executing this script (as
#   in the lab folder passed-in has been "organized") and that the provided,
#   test, and expected output files are stored in the correct folders
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
USAGE="Usage: ./runBatch.sh [-q] path_to_lab exec_file"

#file extensions for comparison purposes; does not include dot for pattern 
#   purposes (issue with escaping the character in a variable)
EXT_JAVA="java"
EXT_PY="py"

####    FLAGS    ####
#All flags are = 0 for on

#### GLOBAL VARS ####

#values passed in
#path to lab
labDIR=""
execFile=""

#determined file type for this lab
fileType=""

####  FUNCTIONS  ####

#Determine if this is a Python (CS1) or Java (CS2) lab
#   Exits the script if a file type can't be determined
#@param: 
#
#@return: 
#
#@global:
#        - fileType type of lab this is
function determineFileType {
    local check=""
    #search space is over all submissions given; in case students submit empty
    #zip folders or bad file names; yes it's a bit over-kill but it'll work
    for sec in "${labDIR}/${SECNAME}"*/; do
        #loop over all students in a section; only search directories
        for student in "${sec}"*/; do
            #loop over all student files
            for file in "${student}"*; do
                check=$(echo "${file}" | grep -oe ".*\.${EXT_PY}$")
                if [[ ! -z ${check} ]]; then
                    fileType=${EXT_PY}
                    break
                fi
                check=$(echo "${file}" | grep -oe ".*\.${EXT_JAVA}$")
                if [[ ! -z ${check} ]]; then
                    fileType=${EXT_JAVA}
                    break
                fi
            done
            if [[ ! -z ${fileType} ]]; then
                break
            fi
        done
        if [[ ! -z ${fileType} ]]; then
            break
        fi
    done
    if [[ -z ${fileType} ]]; then
        echoerr "Lab type (Java/Python) could not be determined."
        echoerr "Make sure your directory structure is correct"
        echoerr "Exiting..."
        exit 1
    fi
}

#Copy all provided files into a student's directory
#   This will not stomp over any files with the same name; if students submit
#   modified files they were not supposed to change, their programs will fail 
#   to run initially, but the original will be preserved for partial credit
#   Note: these backups will be hidden and numbered
#@param: 
#        $1 current student directory
#
#@return: 
#
#@global:
#
function cpProvidedFiles {
    local stuDIR="$1"
    local file=""
    #check if the provided_files directory is empty
    if [[ ! -z $(ls "${labDIR}/${PROVIDED_DIR}/") ]]; then
        for file in "${labDIR}/${PROVIDED_DIR}/"*; do
            cp --backup=t "${file}" "${stuDIR}"
        done
    fi
}

#Run a Python program
#@param:
#        $1 Path to student's directory
#@return:
#
#@global:
#
function runPy { 
    local stuDIR="$1"
    python3 "${stuDIR}"
}

#Run a Java program
#@param:
#        $1 Path to student's directory
#@return:
#
#@global:
#
function runJava {
    local stuDIR="$1"
}

#Hanlde running either kind of program
#@param:
#        $1 Path to student's directory
#@return:
#
#@global:
#        - fileType type of lab this is
function runProgram {
    local stuDIR="$1"
    if [[ ${fileType} = ${EXT_PY} ]]; then
        runPy "${stuDIR}"
    else
        runJava "${stuDIR}"
    fi
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
    if [[ ${#@} -le 1 ]]; then
        echo ${USAGE}
        exit 1
    fi
    labDIR=$1
    execFile=$2
    #check what kind of lab this is
    determineFileType
    #loop over all sections in a lab; only folders
    for sec in "${labDIR}/${SECNAME}"*/; do
        #loop over all students in a section; only folders
        for student in "${sec}"*/; do
            cpProvidedFiles "${student}"
            #run the student's program
            runProgram "${student}"
        done
    done
}

main "${@}"
