#!/bin/bash

# This file is not an executable script and therefore
# does not require an execution flag.

# load the function in another script with:
# source "./Helpers_Extract.sh"

if ! declare -F Helpers_GetNoneExistingRandomNameInDir >/dev/null; then
    echo "Function Helpers_GetNoneExistingRandomNameInDir is not defined"
    exit 1
fi

Helpers_Extract () (
    pass=0
    fail=1

    filename="$1"
    finalDestination="$2"

    if [ -z "${filename}" ] ; then
        return "${fail}"
    fi

    if [ -z "${finalDestination}" ] ; then
        finalDestination="."
    fi


    mkdir -p "${finalDestination}"

    randomName1="$(Helpers_GetNoneExistingRandomNameInDir "${finalDestination}")"
    destination="${finalDestination}/${randomName1}"

    if [ ".tar.gz" = "${filename: -7}" ] ; then
        mkdir -p "${destination}"
        tar -xzf "${filename}" -C "${destination}"
        nestedFolder=$(tar -tzf "${filename}" | head -1 | cut -d/ -f1)
    elif [ ".tar.xz" = "${filename: -7}" ] ; then
        mkdir -p "${destination}"
        tar -xJf "${filename}" -C "${destination}"
        nestedFolder=$(tar -tJf "${filename}" | head -1 | cut -d/ -f1)
    elif [ ".tar.bz" = "${filename: -7}" ] ; then
        mkdir -p "${destination}"
        tar -xjf "${filename}" -C "${destination}"
        nestedFolder=$(tar -tjf "${filename}" | head -1 | cut -d/ -f1)
    elif [ ".zip" = "${filename: -4}" ] ; then
        mkdir -p "${destination}"
        unzip -d "${destination}" "${filename}"
        nestedFolder=$(unzip -l "${filename}" | awk 'NR>3 {print $4; exit}' | cut -d/ -f1)
    elif [ ".7z" = "${filename: -3}" ] ; then
        # mkdir -p "${destination}"
        # 7z x "${filename}" -o"${destination}"
        # nestedFolder=$(7z l -ba "${filename}" | awk '{print $6; exit}' | cut -d/ -f1)
        return "${fail}"
    elif [ ".rar" = "${filename: -4}" ] ; then
        # mkdir -p "${destination}"
        # unrar x "${filename}" "${destination}/"
        # nestedFolder=$(unrar lb "${filename}" | head -1 | cut -d/ -f1)
        return "${fail}"
    else
        return "${fail}"
    fi

    folders=""
    mapfile -t folders < <(find "${destination}" -mindepth 1 -maxdepth 1 -type d)

    files=""
    mapfile -t files < <(find "${destination}" -mindepth 1 -maxdepth 1 -type f)

    if [ 1 -eq "${#folders[@]}" ] && [ 0 -eq "${#files[@]}" ] ; then
        onlyFolder="${folders[0]%/}"
        randomName2="$(Helpers_GetNoneExistingRandomNameInDir "${onlyFolder}" "${finalDestination}")"
        mv "${onlyFolder}" "${finalDestination}/${randomName2}"
        rmdir "${destination}"
        mv "${finalDestination}/${randomName2}"/* "${finalDestination}"/
        rmdir "${finalDestination}/${randomName2}"
    else
        mv "${destination}"/* "${finalDestination}"/
        rmdir "${destination}"
    fi

    return "${pass}"
)
