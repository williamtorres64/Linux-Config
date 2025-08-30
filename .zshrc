#------------------------------------------------------------------------------
# Shell Options
#------------------------------------------------------------------------------

# History Configuration
HISTSIZE=100000
SAVEHIST=200000
setopt HIST_IGNORE_DUPS        # Ignore duplicates
setopt HIST_IGNORE_SPACE       # Ignore commands starting with a space
setopt APPEND_HISTORY          # Append to history file
setopt INC_APPEND_HISTORY      # Write to history after each command
setopt SHARE_HISTORY
HISTFILE=~/.zsh_history

# Shell Behavior
setopt GLOB_STAR_SHORT         # Enable ** recursive globbing

#------------------------------------------------------------------------------
# Environment Variables
#------------------------------------------------------------------------------

export PATH="${PATH}:${HOME}/Scripts:${HOME}/AppImages:${HOME}/Applications:/opt/nvim:${HOME}/.local/bin"
export PICO_SDK_PATH="${HOME}/Documents/Raspberry/pico/pico-sdk"
export PICO_EXAMPLES_PATH="${HOME}/Documents/Raspberry/pico/pico-examples"
export PICO_EXTRAS_PATH="${HOME}/Documents/Raspberry/pico/pico-extras"
export PICO_PLAYGROUND_PATH="${HOME}/Documents/Raspberry/pico/pico-playground"

#------------------------------------------------------------------------------
# Aliases
#------------------------------------------------------------------------------

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -lhF'
alias la='ls -AhF'
alias l='ls -CF'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias nv='nvim'

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

# Workspace function
ws() {
    emulate -L zsh
    local base_wsfile_path="/tmp/.ws_workspace_"
    local action="$1"
    local num_arg="$2"
    local ws_num wsfile dir i

    if [[ -z "$action" ]]; then
        action="go"
        num_arg="1"
    elif [[ "$action" =~ ^[0-9]$ ]] && [[ -z "$num_arg" ]]; then
        num_arg="$action"
        action="go"
    fi

    case "$action" in
        set|go)
            if [[ -z "$num_arg" ]]; then
                ws_num=1
            elif [[ "$num_arg" =~ ^[0-9]$ ]]; then
                ws_num="$num_arg"
            else
                echo "Error: Workspace number must be 0-9"
                return 1
            fi
            wsfile="${base_wsfile_path}${ws_num}"
            if [[ "$action" == "set" ]]; then
                local current_dir=$(pwd -P)
                echo "$current_dir" > "$wsfile" && echo "Workspace $ws_num set to $current_dir"
            else
                if [[ -f "$wsfile" ]]; then
                    dir=$(<"$wsfile")
                    [[ -d "$dir" ]] && cd "$dir" || { echo "Invalid workspace path"; return 1; }
                else
                    echo "Workspace $ws_num not set."
                    return 1
                fi
            fi
            ;;
        get)
            [[ "$num_arg" =~ ^[0-9]$ ]] || { echo "Usage: ws get <0-9>"; return 1; }
            wsfile="${base_wsfile_path}${num_arg}"
            [[ -f "$wsfile" ]] && cat "$wsfile" || echo "Not set"
            ;;
        clear)
            if [[ -z "$num_arg" ]]; then
                for i in {0..9}; do
                    wsfile="${base_wsfile_path}${i}"
                    [[ -f "$wsfile" ]] && rm "$wsfile" && echo "Cleared $i"
                done
            elif [[ "$num_arg" =~ ^[0-9]$ ]]; then
                wsfile="${base_wsfile_path}${num_arg}"
                [[ -f "$wsfile" ]] && rm "$wsfile" && echo "Cleared $num_arg"
            else
                echo "Usage: ws clear [0-9]"
                return 1
            fi
            ;;
        *)
            echo "Usage: ws {set|go|get|clear}"
            ;;
    esac
}

mass_replace() {
    emulate -L zsh
    local dir original target
    if [[ $# -eq 2 ]]; then
        dir="."
        original="$1"
        target="$2"
    elif [[ $# -eq 3 ]]; then
        dir="$1"
        original="$2"
        target="$3"
    else
        echo "Usage: mass_replace <original> <target> or mass_replace <dir> <original> <target>"
        return 1
    fi
    find "$dir" -type f -exec sed -i "s|$original|$target|g" {} +
}

pride() {
    emulate -L zsh
    if [[ -z "$1" ]]; then
        if [[ "$PRIDE" == "1" ]]; then
            export PRIDE=0
            clear
        else
            export PRIDE=1
        fi
    elif [[ "$1" == "off" ]]; then
        export PRIDE=0
        echo "PRIDE disabled"
    elif [[ "$1" == "on" ]]; then
        export PRIDE=1
        echo "PRIDE enabled"
    else
        echo "Usage: pride on|off"
        return 1
    fi
}

#------------------------------------------------------------------------------
# External Tools Initialization
#------------------------------------------------------------------------------

export PATH="${PATH}:${HOME}/.pyenv/bin"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
fi

[[ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]] && source "${HOME}/miniconda3/etc/profile.d/conda.sh"
[[ -f "${HOME}/.config/broot/launcher/bash/br" ]] && source "${HOME}/.config/broot/launcher/bash/br"

export PATH="/home/night/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/night/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

export ANDROID_HOME="/home/night/Applications/android-sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export ANDROID_NDK_HOME="/home/night/Applications/android-ndk-r27d"
export PATH="$PATH:$ANDROID_NDK_HOME"

#------------------------------------------------------------------------------
# Prompt Configuration
#------------------------------------------------------------------------------

export myPoshUser=$(whoami | sed "s/^./\U&/")
export PRIDE=0
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh.toml)"


# Load Angular CLI autocompletion.
source <(ng completion script)
