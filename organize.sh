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

####    FLAGS    ####

#### GLOBAL VARS ####
#List of zip files passed in
zipList=()
#Localized pathing that aligns with the files passed in
pathList=()

####  FUNCTIONS  ####

#Functions for wrapping echo for color and STDERR
function echoerr {
    if [[ ! ${CRON} = ${ON} ]]; then
        tput setaf 1
    fi
    echo "ERROR: "${@} 1>&2 
    if [[ ! ${CRON} = ${ON} ]]; then
        tput sgr0
    fi
}

function echowarn {
    if [[ ! ${CRON} = ${ON} ]]; then
        tput setaf 3
    fi
    echo "WARNING: "${@}
    if [[ ! ${CRON} = ${ON} ]]; then
        tput sgr0
    fi
}

function echosucc {

    if [[ ! ${CRON} = ${ON} ]]; then
        tput setaf 2
    fi
    echo ${@}
    if [[ ! ${CRON} = ${ON} ]]; then
        tput sgr0
    fi
}

#Takes the zip files and makes the appropriate directory structure
#@param: 
#        $1..$N top-level zip files to organize. Each one will be put into
#           a lab folder, then a section.
#           Example: "Lab 10 Download Jun 8, 2014 1110 AM.zip" will go into 
#           lab10/sec_a and then the next file passed in will become sec_b, etc
#
#@return: 
#        - newFolderName the new, sanitized folder name
#
#@global:
#
function mkZipDirs {
    #starting code to count up letters
    local asciiCode=97
    #folder prefix constants
    local LABNAME="lab"
    local SECNAME="sec_"
    #local naming vars
    local secChar=""
    local labNum=0
    local i=0
    for zip in "${@}"; do
        labNum=$(echo ${zip} | grep -o -e "Lab [0-9][0-9]*" | sed 's/Lab //')
        secChar=$(printf "\x$(printf %x ${asciiCode})")
        pathList[$i]="${LABNAME}${labNum}/${SECNAME}${secChar}"
        echo mkdir -p "${pathList[$i]}" 
        #if folder creation is successful, continue with unpacking the zips
        if [[ $? = 0 ]]; then
            #now unzip the file into the newly created folder
             
            if [[ ! $? = 0 ]]; then
                echoerr "Failed to unpack ${zip}"
                #mark failures to keep list in alignment and for future checks
                pathList[$i]=${MRKFAIL}"${pathList[$i]}"
            fi
        else
            echoerr "Failed create folder for ${zip}"
            pathList[$i]=${MRKFAIL}"${pathList[$i]}"
        fi
        let asciiCode++
        let i++
    done
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
#May include flags/modes of operation later
#while getopts ":v" opt; do
#  case $opt in
#    v)
#      
#      ;;
#    *)
#      
#      ;;
#  esac
#done

####    MAIN     ####
function main {
    #record list of file names from command line args
    zipList=("${@}")
    mkZipDirs "${zipList[@]}"
}

main "${@}"
