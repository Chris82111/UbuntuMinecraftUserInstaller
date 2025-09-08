#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/ChooseIndexFromArry.sh"

Helpers_ChooseIndexFromArry () {
    local pass=0
    local fail=1

    local text="$1"
    if [ -z "${text}" ] ; then
        text="Select between (0-%d): "
    fi    
    local answer="$2"
    local color="$3"
    local resetColor=""
    if [ -n "${color}" ] ; then
        resetColor="\033[0m"
    fi

    shift 3
    local icons=( "$@" )
    local iconsLength=$(( "${#icons[@]}" - 1 ))
    local width="${#iconsLength}"

    local out="$(printf "${text}" "${iconsLength}")"

    if [[ "${answer}" =~ ^[0-9]+$ ]] && [ "${answer}" -ge 0 ] && [ "${answer}" -le "${iconsLength}" ] ; then
        echo -e "${out}${color}${answer}${resetColor}"
        icon="${icons[${answer}]}"
    else
        for (( i=0; i <= "${iconsLength}"; i++ )); do
            printf "  %${width}d => %s\n" "$i" "${icons[$i]}"
        done

        while :; do
            echo -ne "${out}${color}"
            read -r answer
            echo -ne "${resetColor}"
            
            if [[ "${answer}" =~ ^[0-9]+$ ]] && [ "${answer}" -ge 0 ] && [ "${answer}" -le "${iconsLength}" ] ; then
                icon="${icons[${answer}]}"
                break
            fi
            [ "" != "${resetColor}" ] && echo -ne "\033[1A\033[2KT\r"
        done
    fi

    Helpers_ChooseIndexFromArry_Result="${answer}"
    return "${pass}"
}
