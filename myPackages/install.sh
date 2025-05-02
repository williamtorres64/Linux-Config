#!/bin/bash

# Define colors
BLUE='\e[1;96m'
NC='\e[0m' # No Color

# Determine distro and install command
if [ -e "/etc/debian_version" ]; then
    DISTRO="debian"
    PKG_INSTALL="sudo apt install -y"
elif [ -e "/etc/arch-release" ]; then
    DISTRO="arch"
    PKG_INSTALL="sudo pacman -S --noconfirm"
else
    echo -e "${BLUE}Unsupported distribution.${NC}"
    exit 1
fi

echo -e "${BLUE}Detected distribution: $DISTRO${NC}"

# Helper: read a file, filter out blanks/comments, join into one space-separated list
gather_pkgs() {
    local file="$1"
    # Skip if missing
    [ -f "$file" ] || return 1
    # Read lines, strip comments and blanks
    grep -E -v '^\s*($|#)' "$file" | tr '\n' ' '
}

# Install all packages from a given list, if any
install_from_file() {
    local label="$1"
    local file="$2"
    echo -e "${BLUE}Processing $label ($file)...${NC}"
    pkgs=$(gather_pkgs "$file")
    if [ -n "$pkgs" ]; then
        echo -e "${BLUE}Installing: $pkgs${NC}"
        $PKG_INSTALL $pkgs
    else
        echo -e "${BLUE}No packages to install in $file.${NC}"
    fi
}

# Base packages
install_from_file "base packages" "$HOME/myPackages/packages.txt"

# Window-manager-specific packages
if [ -n "$DESKTOP_SESSION" ]; then
    install_from_file "WM packages for $DESKTOP_SESSION" \
                      "$HOME/myPackages/$DESKTOP_SESSION/packages.txt"
else
    echo -e "${BLUE}DESKTOP_SESSION not set; skipping WM-specific packages.${NC}"
fi

# Distro-specific packages
install_from_file "$DISTRO-specific packages" \
                  "$HOME/myPackages/$DISTRO/packages.txt"

