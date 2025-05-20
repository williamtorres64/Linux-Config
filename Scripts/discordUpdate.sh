#!/bin/sh

# Ensure script is running with root
if ! [ $(id -u) = 0 ]; then
    if [ "$1" ]; then
        echo "Error: root privileges required"
        exit 1
    fi
    sudo sh $0 "1"
    exit $?
fi

# Download, install and clean
wget -O /tmp/discord-installer.deb "https://discord.com/api/download?platform=linux"
dpkg -i /tmp/discord-installer.deb
rm /tmp/discord-installer.deb

# Vencord
#runuser -l night -c sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)
#curl -sSL https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh | sudo -u night bash
sudo -u night bash -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

