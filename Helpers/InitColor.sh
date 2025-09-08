#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/InitColor.sh"

bold=""
underline=""
standout=""
normal=""
black=""
red=""
green=""
yellow=""
blue=""
magenta=""
cyan=""
white=""

pass=""
info=""
fail=""

if ! declare -F Helpers_IsColorAvailable >/dev/null; then
    echo "Function Helpers_IsColorAvailable is not defined"
    exit 1
fi

Helpers_InitColor () {
    local returnPass=0
    local returnFail=1

    # check if stdout is a terminal
    if Helpers_IsColorAvailable ; then

        # ANSI escape codes
        bold="\033[1m"
        underline="\033[4m"
        standout="\033[0m" 
        normal="\033[0m" 
        black="\033[30m"
        red="\033[1;31m"
        green="\033[1;32m"
        yellow="\033[1;33m"
        blue="\033[1;34m"
        magenta="\033[1;35m"
        cyan="\033[1;36m"
        white="\033[1;37m"
        # \033[38;2;<r>;<g>;<b>m     #Select RGB foreground color
        # \033[48;2;<r>;<g>;<b>m     #Select RGB background color

        pass="${green}"
        info="${yellow}"
        fail="${red}"

        # echo "true"
        return "${returnPass}"

    else
        # echo "false"
        return "${returnFail}"
    fi
}

# black="\033[30;41m"
# echo -e "${bold}Hello World${normal}"
# echo -e "${underline}Hello World${normal}"
# echo -e "${standout}Hello World${normal}"
# echo -e "${normal}Hello World${normal}"
# echo -e "${black}Hello World${normal}"
# echo -e "${red}Hello World${normal}"
# echo -e "${green}Hello World${normal}"
# echo -e "${yellow}Hello World${normal}"
# echo -e "${blue}Hello World${normal}"
# echo -e "${magenta}Hello World${normal}"
# echo -e "${cyan}Hello World${normal}"
# echo -e "${white}Hello World${normal}"
