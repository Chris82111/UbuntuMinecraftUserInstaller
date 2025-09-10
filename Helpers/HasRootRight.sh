#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helper/HasRoohasRootRighttRights.sh"

Helpers_HasRootRight() (
    pass=0
    fail=1

    if [ "$EUID" -ne 0 ]; then
        # echo "false"
        return "${fail}"
    else
        # echo "true"
        return "${pass}"
    fi
)