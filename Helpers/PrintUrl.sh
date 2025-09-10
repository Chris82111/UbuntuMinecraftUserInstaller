#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/PrintUrl.sh"

# - The function supports one parameter, the URL
# - The function supports two parameters; additional parameters are ignored
#   if they are not specified as switches or parameters
#   - indent as int: number of leading spaces 
#   - url as string: URL
# - The function supports named parameters
#   - --indent as int: number of leading spaces 
#   - --url as string: URL
Helpers_PrintUrl() (
    pass=0
    fail=1

    indent="0"
    url=""

    positional=()  # array to store ordered arguments
    positionalValid=true
    isInvalid=false

    if [ -z "$1" ] ; then
        return "${fail}"
    elif [ 1 -eq $# ] ; then
        url="$1"
    elif [ 1 -lt $# ] ; then
        while [[ ! -z "$1" ]] ; do
        case "$1" in
            --indent) indent="$2" ; shift ; positionalValid=false ; ;;
            --url) url="$2" ; shift ; positionalValid=false ; ;;
            --) shift ; break ; ;;
            --*) isInvalid=true ; ;;
            -*) isInvalid=true ; ;;
            *) positional+=("$1") ; ;;
        esac
        shift 
        done

        # Everything after -- is treated as a position argument.
        while [[ ! -z "$1" ]] ; do
            positional+=("$1")
            shift 
        done

        # Unknown command-line options cause termination
        if [ "true" == "${isInvalid}" ] ; then
            return "${fail}"
        fi

        # After named command-line options are used, positional
        # arguments are no longer taken into account.
        # If none were used, only those specified here were used.
        if [ "true" == "${positionalValid}" ] ; then
            indent="${positional[0]}"
            url="${positional[1]}"
        fi
        
        # Cecks whether all necessary parameters have a value.
        # If an initial value was specified, it was optional when called.
        if [ -z "${indent}" ] || [ -z "${url}" ] ; then
            return "${fail}"
        fi
    else
        return "${fail}"
    fi

    spaces=$(printf "%*s" "${indent}" "")

    # Check for terminal support
    if [[ "${TERM}" =~ "xterm"|"screen"|"tmux"|"rxvt"|"vte" ]]; then
        printf '%s\e]8;;%s\e\\\e[34;4m%s\e[0m\e]8;;\e\\\n' "${spaces}" "${url}" "${url}"
    else
        echo "${spaces}${url}"
    fi

    return "${pass}"
)