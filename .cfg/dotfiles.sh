#!/usr/bin/env bash

GIT_REPO_URL="https://github.com/williamtorres64/Linux-Config.git"
CFG_DIR="$HOME/.cfg"
BACKUP_DIR=".dotfiles-backup"

function config {
    git --git-dir="$CFG_DIR/" --work-tree="$HOME" "$@"
}

if [ -d "$CFG_DIR" ]; then
    echo "Clearing existing dotfiles repository at $CFG_DIR..."
    rm -rf "$CFG_DIR"
fi

echo "Cloning the dotfiles repository into $CFG_DIR"
git clone --bare "$GIT_REPO_URL" "$CFG_DIR"

mkdir -p "$BACKUP_DIR"

echo "Attempting to check out dotfiles..."

config checkout || {
    echo "Conflict detected. Moving existing files to $BACKUP_DIR..."
    config checkout 2>&1 | egrep -o "^\s+\S+" | xargs -I {} mv {} "$BACKUP_DIR"/
    echo "Retrying checkout after backup."
    config checkout
}

config config --local status.showUntrackedFiles no

echo "Setup complete!"

