#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/IsColorValid.sh"

Helpers_IsColorValid_Truecolor=false
Helpers_IsColorValid_Sgr=false

Helpers_IsColorValid () {
    local esc=$'\033' # real escape char
    local pass=0
    local fail=1

    local color="$1"

    Helpers_IsColorValid_Truecolor=false
    Helpers_IsColorValid_Sgr=false

    if [ $'\e' = "${color:0:1}" ] ; then
        :;
    elif [ "\e"  = "${color:0:2}" ] ; then
        color="${esc}${color:2}"
    elif [ "\033"  = "${color:0:4}" ] ; then
        color="${esc}${color:4}"
    else
        return "${fail}"
    fi

    # GENERAL: ESC '[' then digits and semicolons, then 'm'
    # use $'...' so \033 becomes the real ESC and \\[ becomes a literal backslash+[
    local re_general=$'^\033\\[[0-9;]{1,40}m$'

    # TRUECOLOR: ESC '[' (38|48) ; 2 ; R ; G ; B m
    local re_truecolor=$'^\033\\[(38|48);2;([0-9]{1,3});([0-9]{1,3});([0-9]{1,3})m$'

    # First try truecolor (so we can validate 0..255 ranges)
    if [[ $color =~ $re_truecolor ]]; then
        local r=${BASH_REMATCH[2]}
        local g=${BASH_REMATCH[3]}
        local b=${BASH_REMATCH[4]}

        # ensure each is numeric and within 0..255
        for v in "$r" "$g" "$b"; do
            [[ $v =~ ^[0-9]{1,3}$ ]] || { return "${fail}"; }
            (( v >= 0 && v <= 255 )) || { return "${fail}"; }
        done

        Helpers_IsColorValid_Truecolor=true
        return "${pass}"
    fi

    # If not truecolor, accept any SGR numeric sequence like ESC[31m or ESC[1;31m etc.
    if [[ $color =~ $re_general ]]; then
        Helpers_IsColorValid_Sgr=true
        return "${pass}"
    fi

    return "${fail}"
}
