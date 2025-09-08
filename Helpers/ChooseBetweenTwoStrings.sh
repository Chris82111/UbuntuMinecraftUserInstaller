#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/ChooseBetweenTwoStrings.sh"

Helpers_ChooseBetweenTwoStrings () {
    local pass=0
    local fail=1

    local text="$1"
    local first="${2,,}"
    local second="${3,,}"
    local answer="${4,,}"
    local color="$5"
    local resetColor=""
    if [ -n "${color}" ] ; then
        resetColor="\033[0m"
    fi

    while :; do
        if [ "${first}" = "${answer}" ] || [ "${second}" = "${answer}" ] ; then
            echo -e "${text}${color}${answer}${resetColor}"
            break
        fi

        echo -ne "${text}${color}"
        read -r answer
        echo -ne "${resetColor}"
        answer="${answer,,}"

        if [ "${first}" = "${answer}" ] ; then
            answer="${first}"
            break
        elif [ "${second}" = "${answer}" ] ; then
            answer="${second}"
            break
        else
            [ "" != "${resetColor}" ] && echo -ne "\033[1A\033[2KT\r"
        fi
    done
    Helpers_ChooseBetweenTwoStrings_Result="${answer}"
    return "${pass}"
}