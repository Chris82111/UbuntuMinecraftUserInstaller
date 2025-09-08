#!/bin/bash

# This file is an executable script, so set the executable flag:
# chmod +x ./install.sh
# ./install.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load functions
source "${SCRIPT_DIR}/Helpers/ChooseBetweenTwoStrings.sh"
source "${SCRIPT_DIR}/Helpers/ChooseIndexFromArry.sh"
source "${SCRIPT_DIR}/Helpers/GetNoneExistingRandomNameInDir.sh"
source "${SCRIPT_DIR}/Helpers/Extract.sh"
source "${SCRIPT_DIR}/Helpers/GetDownloadUrl.sh"
source "${SCRIPT_DIR}/Helpers/HasRootRight.sh"
source "${SCRIPT_DIR}/Helpers/PrintUrl.sh"
source "${SCRIPT_DIR}/Helpers/Log.sh"
source "${SCRIPT_DIR}/Helpers/IsColorAvailable.sh"
source "${SCRIPT_DIR}/Helpers/InitColor.sh"
source "${SCRIPT_DIR}/Helpers/IsColorValid.sh"

# Init functions
Helpers_InitColor
Helpers_LogSetPrefixString "[${info}verb${normal}] "

# OS/Distribution
applicationDir="${HOME}/.local/share"
iconsDir="${applicationDir}/icons/hicolor"
iconsScalableDir="${applicationDir}/icons/hicolor/scalable/apps"
startMenuDir="${applicationDir}/applications"
publicExecutableDir="${HOME}/.local/bin"
desktopDir="${HOME}/Desktop"

# App
appDownloadInfoUrl="https://www.minecraft.net/en-us/download"
appDownloadUrl="https://launcher.mojang.com/download/Minecraft.tar.gz"

appDirectory="${applicationDir}/minecraft"
appUninstall="${appDirectory}/uninstall.sh"
appExecutable="${appDirectory}/minecraft-launcher"
appIcon="${iconsScalableDir}/minecraft_icon.svg"
appResourceDirectoryDesktop="./Resources"
appDesktopIconName="minecraft.desktop"
appResourceDirectoryIcon="./Resources/Icons"
icons=( \
    "minecraft_2009-2013.svg" \
    "minecraft_2013-2023_1.6-1.19.svg" \
    "minecraft_2013-2023.svg" \
    "minecraft_2016-2023_favicon.svg" \
    "minecraft_2017-2023_bedrock.svg" \
    "minecraft_2019.svg" \
    "minecraft_2020-2023_variant.svg" \
    "minecraft_2021.svg" \
    "minecraft_2023_bedrock.svg" \
    "minecraft_2023_linux.svg" \
    "minecraft_2023.svg" )

if Helpers_HasRootRight ; then
    echo "[${fail}fail${normal}] Do not call the script with 'sudo'!"
    exit 1
fi

_help="false"
_image="-1"
_install="x"
_archive=""
# Script parameters
while [[ ! -z "$1" ]] ; do
  case "${1,,}" in
    -v|--verbose) VERBOSE=true ;;
    --help) _help="true" ;;
    --image) shift ; _image="$1" ;;
    --install) _install="i" ;;
    --uninstall) _install="u" ;;
    --archive) shift ; _archive="$1" ;;
    --version) echo "Git hash: $(git rev-parse --short HEAD 2>/dev/null)" ; exit 0 ;;
    *) echo -e "[${fail}fail${normal}] '$1' unknown an ignored" ;;
  esac
  shift
done

Helpers_Log "Parameters"
Helpers_Log "  --help    = ${_help}"
Helpers_Log "  --image   = ${_image}"
Helpers_Log "  --install = ${_install}"
Helpers_Log "  --archive = ${_archive}"

if [ "true" = "${_help}" ] ; then
    echo "Usage:"
    echo "  install.sh [--verbose] [--install | --uninstall] [--archive <path>]"
    echo "             [--image <index>] [--help] [--version]"
    echo ""
    echo "Description:"
    echo "  This script can be used to install and uninstall Minecraft on a Debian-based"
    echo "  system, such as Ubuntu. The standard executable file from Microsoft is used to"
    echo "  start the program. The script takes care of creating the necessary shortcuts."
    echo "  The installer can be run as a normal user; 'sudo' is not necessary for"
    echo "  execution and is also not permitted. Without parameters, the script is"
    echo "  executed in interactive mode. Parameters can be entered for automation,"
    echo "  eliminating the need for inputs during installation."
    echo "  - All parameters are optional unless explicitly required by your workflow."
    echo ""
    echo "Options:"
    echo "  -v, --verbose     Enable verbose output"
    echo "  --help            Show this help message and exit"
    echo "  --install         Install the application"
    echo "  --uninstall       Uninstall the application"
    echo "  --archive <path>  Specify the archive file path. If an archive is downloaded"
    echo "                    manually and specified here, this file is used and a later"
    echo "                    download is skipped"
    echo "  --image <index>   Select an image index, from 0 to $(( "${#icons[@]}" - 1 ))"
    echo "  --version         Show the application version (from git) and exit"
    echo ""
    echo "Notes:"
    echo "  You can find more information on the GitHub page:"
    Helpers_PrintUrl --indent 2 --url "https://github.com/Chris82111/UbuntuMinecraftUserInstaller"
    echo ""
    exit 0
fi

Helpers_Log "Install or uninstall"
Helpers_ChooseBetweenTwoStrings "Do you want to (i)nstall or (u)ninstall? (i/u): " "u" "i" "${_install}" "${cyan}"
answer="${Helpers_ChooseBetweenTwoStrings_Result}"

if [ "i" == "${answer}" ] ; then

    Helpers_Log "Print information URL"
    if [ -n "${appDownloadInfoUrl}" ] ; then
        echo "  More information at the download page:"
        Helpers_PrintUrl --indent 2 --url "${appDownloadInfoUrl}"
    fi

    Helpers_Log "Ensure app directory"
    mkdir -p "${appDirectory}"

    if [ -f "${_archive}" ] ; then
        Helpers_Log "Use local file"
        filename="$(basename "${_archive}")"
        downloadArchive="${appDirectory}/${filename}"
        cp "${_archive}" "${downloadArchive}"
    else
        Helpers_Log "Download file"
        downloadUrl="$(Helpers_GetDownloadUrl "${appDownloadUrl}")"
        filename="$(basename "${downloadUrl}")"
        downloadArchive="${appDirectory}/${filename}"
        dump="$(wget "${downloadUrl}" -O "${downloadArchive}" 2>&1)"
        if [ ! -f "${downloadArchive}" ] ; then
            echo "File ${downloadArchive} not found!"
            exit 1
        fi
    fi

    Helpers_Log "Extract"
    Helpers_Extract "${downloadArchive}" "${appDirectory}"

    Helpers_Log "Remove downloaded file"
    message="$(rm "${downloadArchive}" 2>&1)"
    [ "" != "${message}" ] && Helpers_Log "${message}"

    Helpers_Log "Ask for icon"
    Helpers_ChooseIndexFromArry "Select a path (0-%d): " "${_image}" "${cyan}" "${icons[@]}"
    icon="${icons[${Helpers_ChooseIndexFromArry_Result}]}"
       
    Helpers_Log "Ensure icon directory"
    mkdir -p "${iconsScalableDir}"

    Helpers_Log "Copy app icon"
    cp "${appResourceDirectoryIcon}/${icon}" "${appIcon}"

    Helpers_Log "Make the executable file known"
    ln -sf "${appExecutable}" "${publicExecutableDir}/$(basename "${appExecutable}")"

    Helpers_Log "Set execution rights"
    chmod 711 "${appResourceDirectoryDesktop}/${appDesktopIconName}"

    Helpers_Log "Copy Desktop and menu Icon"
    cp "${appResourceDirectoryDesktop}/${appDesktopIconName}" "${desktopDir}/${appDesktopIconName}"
    gio set "${desktopDir}/${appDesktopIconName}" metadata::trusted true
    cp "${appResourceDirectoryDesktop}/${appDesktopIconName}" "${startMenuDir%/}/"

    Helpers_Log "Refresh icons"
    touch "${iconsDir}"
    message="$(gtk-update-icon-cache "${iconsDir}" 2>&1)"
    Helpers_Log "${message}"
    update-desktop-database "${startMenuDir%/}"

    Helpers_Log "Create uninstall script"
    echo "#!/bin/bash" > "${appUninstall}"
    echo "rm \"${desktopDir}/${appDesktopIconName}\"" >> "${appUninstall}"
    echo "rm \"${startMenuDir}/${appDesktopIconName}\"" >> "${appUninstall}"
    echo "rm \"${publicExecutableDir}/$(basename "${appExecutable}")\"" >> "${appUninstall}"
    echo "rm \"${appIcon}\"" >> "${appUninstall}"
    echo "rm -fr \"${appDirectory}\"" >> "${appUninstall}"
    echo "echo -e \"[${fail}info${normal}] The user data are not removed, clean it yourself: '${HOME}/.minecraft'\"" >> "${appUninstall}"
    echo "echo -e \"[${pass}pass${normal}] Rest of uninstallation is complete\"" >> "${appUninstall}"
    chmod 711 "${appUninstall}"

    echo -e "[${pass}pass${normal}] Installation is complete"

elif [ "u" == "${answer}" ] ; then

    Helpers_Log "Desktop icon"
    message="$(rm "${desktopDir}/${appDesktopIconName}" 2>&1)"
    [ "" != "${message}" ] && Helpers_Log "${message}"
    
    Helpers_Log "Application desktop icon"
    message="$(rm "${startMenuDir}/${appDesktopIconName}" 2>&1)"
    [ "" != "${message}" ] && Helpers_Log "${message}"
    
    Helpers_Log "Application start menu icon"
    message="$(rm "${publicExecutableDir}/$(basename "${appExecutable}")" 2>&1)"
    [ "" != "${message}" ] && Helpers_Log "${message}"
    
    Helpers_Log "Application pictures"
    message="$(rm "${appIcon}" 2>&1)"
    [ "" != "${message}" ] && Helpers_Log "${message}"
    
    Helpers_Log "Application uninstall file"
    message="$(rm "${appUninstall}" 2>&1)"
    [ "" != "${message}" ] && Helpers_Log "${message}"

    Helpers_Log "Application"
    rm -fr "${appDirectory}"
    
    Helpers_Log "User data"
    echo -e "[${fail}info${normal}] The user data are not removed, clean it yourself: '${HOME}/.minecraft'"

    echo -e "[${pass}pass${normal}] Rest of uninstallation is complete"
fi
