#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/IsColorAvailable.sh"

# \brief Determines whether colored output is supported or should be forced.
#
# This function checks if the current terminal session supports ANSI colors or
# if color output should be explicitly forced based on environment conditions
# or user input.
#
# The following conditions enable color support:
# - The script is running inside Visual Studio Code (`TERM_PROGRAM=vscode` or
#   `VSCODE_PID` is set).
# - The user explicitly requests color (`userForcedColor=true`).
# - The output is attached to an interactive terminal (`-t 1`).
#
# @param $1 (optional) A string (`"true"` or `"false"`, default: `"false"`) to
#           force-enable color support regardless of terminal detection.
#
# @retval 0 if color is available (true).
# @retval 1 if color is not available (false).
#
# @note The function does not print anything; it only sets the return code.
#
# @code
# if Helpers_IsColorAvailable ; then
#     echo -e "\033[32mColor is available!\033[0m"
# else
#     echo "No color support"
# fi
# @endcode
#
Helpers_IsColorAvailable () (
    pass=0
    fail=1

    userForcedColor="${1:-false}"

    # Tests to force color
    if [ "${TERM_PROGRAM}" = "vscode" ] || [ -n "${VSCODE_PID}" ] || [ "true" = "${userForcedColor}" ] ; then
        forceColor=true
    fi

    if [ -t 1 ] || [ "true" = "${forceColor:-false}" ] ; then
        # echo "true"
        return "${pass}"
    else
        # echo "false"
        return "${fail}"
    fi
)
