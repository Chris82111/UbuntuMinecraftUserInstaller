# UbuntuMinecraftUserInstaller

<div align="center">

[![Microsoft_Download_Link](https://img.shields.io/badge/Minecraft-Microsoft_Download_Link-52a335)](https://www.minecraft.net/en-us/download "Link to the official Microsoft Minecraft download page")
[![](https://img.shields.io/badge/Ubuntu--de460c)](https://ubuntu.com/ "Link to Ubuntu")

![](https://img.shields.io/badge/sudo-NO-darkgreen)
![](https://img.shields.io/badge/isolation-NO-darkred)

</div>

This script can be used to install and uninstall Minecraft on Ubuntu (tested on 25.04).
The standard executable file from Microsoft is used to start the program.
The script takes care of creating the necessary shortcuts.
The installer can be run as a normal user; 'sudo' is not necessary for
execution and is also not permitted. Without parameters, the script is
executed in interactive mode. Parameters can be entered for automation,
eliminating the need for inputs during installation.

## Parameter

```bash
install.sh [-v|--verbose] [--install | --uninstall] [--archive <path>] [--image <index>] [-h|--help] [--version]
```

| Parameter                         | Description                                      |
| :-------------------------------- | :----------------------------------------------- |
| -v, <nobr>--verbose       </nobr> | Enable verbose output                            |
| -h, <nobr>--help          </nobr> | Show this help message and exit                  |
|     <nobr>--install       </nobr> | Install the application                          |
|     <nobr>--uninstall     </nobr> | Uninstall the application                        |
|     <nobr>--archive       </path> | Specify the archive file path. If an archive is downloaded manually and specified here, this file is used and a later download is skipped |
|     <nobr>--image <index> </nobr> | Select an image index, from 0 to 10              |
|     <nobr>--version       </nobr> | Show the application version (from git) and exit |

### Desktop Icons

The desktop icon can be one of the following icons:

<picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2009-2013.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2013-2023.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2013-2023_1.6-1.19svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2016-2023_favicon.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2017-2023_bedrock.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2019.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2020-2023_variant.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2021.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2023.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2023_bedrock.svg"
    width="30" />
</picture><picture>
  <img
    alt=""
    src="./Resources/Icons/minecraft_2023_linux.svg"
    width="30" />
</picture>
