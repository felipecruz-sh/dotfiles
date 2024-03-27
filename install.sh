#!/usr/bin/env bash

# ============================== SOURCES ==============================

source .src/functions.sh
source .install/variables.sh

# ============================== SOURCES ==============================


# ============================== BEGIN ==============================

if command -v pacman >&-; then
    PacmanConf
else
    echo -e "${BoldRed}[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...${Reset}"
    exit 1
fi

InstallPacmanPackages "${PacmanPackages[@]}"

GrubConfig

Plymouth
# ============================== END ==============================