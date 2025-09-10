#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/Log.sh"

Helpers_LogPrefixString=""
Helpers_LogPostfixString=""

Helpers_Log () (
    if [ "true" = "${VERBOSE:-false}" ] ; then 
        echo -e "${Helpers_LogPrefixString}$@${Helpers_LogPostfixString}"
    fi
)

Helpers_LogSetPrefixString () {
    Helpers_LogPrefixString="$1"
}

Helpers_LogSetPostfixString () {
    Helpers_LogPostfixString="$1"
}
