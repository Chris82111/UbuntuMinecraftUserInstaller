#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers_GetNoneExistingRandomNameInDir.sh"

Helpers_GetNoneExistingRandomNameInDir () (
    pass=0
    fail=1

    args=( "$@" )

    while :; do
        name="$(head /dev/urandom | tr -dc a-z0-9 | head -c 8)"

        isUnique=true
        for (( i=0; i<${#args[@]}; i++ )) ; do
            candidate="${args[i]%/}/${name}"
            if [ -e "${candidate}" ] ; then
                isUnique=false
            fi
        done

        if [ "true" == "${isUnique}" ] ; then
            break
        fi
    done

    echo "${name}"
    return "${pass}"
)
