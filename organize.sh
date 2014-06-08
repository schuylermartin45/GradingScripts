#!/bin/bash
#
#This script takes any number of .zip files from the myCourses site
#   and organizes the code submissions appropriately.
#
#Authors:
#
#   Schuyler Martin @schuylermartin45
#

####  CONSTANTS  ####
#Mark of failure
MRKFAIL="FAIL_"
#Usage message string
USAGE="Usage: ./organize.sh [-c] [-q] file.zip [file(s) ...]"

####    FLAGS    ####
#quiet mode; 0 for on
QUIET=1
#cleans up top-level zip automatically; 0 for on 
CLEANUP=1

#### GLOBAL VARS ####
#List of zip files passed in
zipList=()
#Localized pathing that aligns with the files passed in
pathList=()

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

#Takes the zip files and makes the appropriate directory structure
#@param: 
#        $1..$N top-level zip files to organize. Each one will be put into
#           a lab folder, then a section. This can be a path to a file.
#           Example: "Lab 10 Download Jun 8, 2014 1110 AM.zip" will go into 
#           lab10/sec_a and then the next file passed in will become sec_b, etc
#
#@return: 
#        - failCntr return the number of failures occured (acts as $?)
#@global:
#        - pathList is set with the local pathings to extracted file structures
function mkZipDirs {
    #starting code to count up letters
    local asciiCode=97
    #folder prefix constants
    local LABNAME="lab"
    local SECNAME="sec_"
    #local naming vars
    local secChar=""
    local labNum=0
    local zip=""
    #counters
    local i=0
    failCntr=0
    for zipPath in "${@}"; do
        #extract just the zip name from a possible directory
        zip=$(basename "${zipPath}")
        labNum=$(echo ${zip} | grep -o -e "Lab [0-9][0-9]*" | sed 's/Lab //')
        secChar=$(printf "\x$(printf %x ${asciiCode})")
        pathList[$i]="${LABNAME}${labNum}/${SECNAME}${secChar}"
        mkdir -p "${pathList[$i]}" 
        #if folder creation is successful, continue with unpacking the zips
        if [[ $? = 0 ]]; then
            #now unzip the file into the newly created folder
            unzip -q "${zipPath}" -d ${pathList[$i]} 
            if [[ $? = 0 ]]; then
                #if cleanup mode is enabled, remove the original zip
                if [[ ${CLEANUP} = 0 ]]; then
                    rm "${zipPath}"
                    if [[ ! $? = 0 ]]; then
                        echoerr "Clean up mode: failed to delete ${zipPath}"
                    fi
                fi
            else
                echoerr "Failed to unpack ${zip}"
                #mark failures to keep list in alignment and for future checks
                pathList[$i]=${MRKFAIL}"${pathList[$i]}"
                let failCntr++
            fi
        else
            echoerr "Failed create folder for ${zip}"
            pathList[$i]=${MRKFAIL}"${pathList[$i]}"
            let failCntr++
        fi
        let asciiCode++
        let i++
    done
    if [[ ${failCntr} = 0 ]]; then
        echosucc "Top-level zip files successfully unpacked!"
    else
        echoerr "${failCntr} failures unpacking the top-level zip files"
    fi
}

#Parses the file name into the proper file name
#@param: 
#        $1 string (original file name) to parse
#
#@return: 
#        - newFileName the new, sanitized file name
#
#@global:
#        
function parseFileName {
    local orgFile="$1"
}

#Groups files into folders by Unique IDs and renames files accordingly
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
function groupByUID {
    echo blah
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
    echo blah
}

####   GETOPTS   ####
#Flags for modes of operation
while getopts ":cq" opt; do
    case $opt in
        c)
            CLEANUP=0
            ;;
        q)
            QUIET=0
            ;;
        *)
            echo "${USAGE}"
            exit 1
            ;;
    esac
done

####    MAIN     ####
function main {
    #shift after reading getopts
    shift $(($OPTIND - 1))
    #record list of file names from command line args
    zipList=("${@}")
    #no args after flags, present usage message
    if [[ ${#zipList[@]} = 0 ]]; then
        echo "${USAGE}"
        exit 1
    fi
    #turn the zips into a local file structure
    mkZipDirs "${zipList[@]}"
}

main "${@}"
