#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers/GetDownloadUrl.sh"

# Helpers_GetDownloadUrl "https://download-installer.cdn.mozilla.net/pub/firefox/releases/142.0/linux-x86_64/en-US/firefox-142.0.tar.xz"
# Helpers_GetDownloadUrl "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
Helpers_GetDownloadUrl () (
    pass=0
    fail=1

    urlInput="$1"

    if [ -z "${urlInput}" ] ; then
        return "${fail}"
    fi

    response="$(curl -sIL "$urlInput")"
    exitValue=$?

    # Check the result
    if [ 0 -ne "${exitValue}" ]; then
        return "${fail}"
    fi

    redirect="$(echo "${response}" |
        grep -i "^Location:" |
        tail -1 |
        awk '{print $2}')"
    # Remove none printable characters
    redirect="$(echo "${redirect}" | tr -cd '[:print:]')"

    # type="$(echo "${response}" |
    #     grep -i "^Content-Type:" |
    #     tail -1 |
    #     awk '{print $2}')"
    # type="$(echo "${type}" | tr -cd '[:print:]')"

    # size="$(echo "${response}" |
    #     grep -i "^content-length:" |
    #     tail -1 |
    #     awk '{print $2}')"
    # size="$(echo "${size}" | tr -cd '[:print:]')"

    if [ -z "${redirect}" ] ; then
        url="${urlInput}"
    else
        url="${redirect}"
    fi
    
    echo "${url}"
    return "${pass}"
)
