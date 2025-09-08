#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/pause.sh"

# \brief Provides a pause in script execution, waiting for the user to press
#        Enter, unless skipping behavior is explicitly requested or the script
#        is not running in an interactive terminal.
#
# \details  1. No arguments: Displays Press enter to continue and waits for user input.
#           2. One argument
#              - "true" : Skips pausing, outputs "Press enter to continue skipped by parameter".
#              - "false": Waits for input with default text.
#              - string : Uses that as the display text, then waits for input.
#           3. Two arguments
#              - First is display text.
#              - Second, if "true", forces skipping.
#           4. Non-interactive shell (no TTY): Does not pause, but prints a
#              skip message (with or without custom text).
#
#           The tests for -t check whether the terminal is interactive.
#           If you pipe something into your script, it is not interactive.
#           In Visual Studio Code, you can use "Bash Debug" for debugging,
#           but without the following setting, you cannot interact with the debugger: 
#           "configurations": [ { ... , "terminalKind": "integrated" } ]
#
# \param $1 - (optional)
#           - If "true" or "false" -> controls whether the pause should be
#             skipped (skip flag).
#           - Otherwise -> treated as custom text to display before pausing.
#             Default text is "Press enter to continue".
# \param $2 - (optional)
#           - If "true" -> overrides and forces skipping.
#           - Only relevant if first parameter was treated as custom text.
Helpers_Pause () {

    local text="Press enter to continue"
    local skip="false"
    local param=""

    if [ $# -eq 0 ] ; then
        :;
    elif [ $# -eq 1 ] ; then
        param="${1,,}"
        if [ "false" = "${param}" ] || [ "true" = "${param}" ] ; then
            skip="${param}"
        else
            text="$1"
        fi
    else
        text="$1"
        param="${2,,}"
        if [ "true" = "${param}" ] ; then
            skip="${param}"
        fi
    fi

    if [ "true" = "${skip}" ]; then
        if [ -z "${text}" ]; then
            echo "skipped by parameter"
        else
            echo "${text} skipped by parameter"
        fi
    else
        if [ -t 0 ] ; then
            if [ -n "${text}" ]; then
                echo -n "${text}"
            fi
            read -r
        else
            if [ -z "${text}" ]; then
                echo "skipped because terminal is not interactive"
            else
                echo "${text} skipped because terminal is not interactive"
            fi
        fi
    fi
}
