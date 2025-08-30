# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#------------------------------------------------------------------------------
# Shell Options
#------------------------------------------------------------------------------

# History Configuration
HISTCONTROL=ignoreboth           # Ignore duplicates and space-prefixed commands
shopt -s histappend              # Append to history file
HISTSIZE=100000                  # Increase history size
HISTFILESIZE=200000

# Shell Behavior
shopt -s checkwinsize            # Update window size after commands
shopt -s globstar 2>/dev/null    # Enable ** recursive globbing

#------------------------------------------------------------------------------
# Environment Variables
#------------------------------------------------------------------------------

PATH="${PATH:+"$PATH:"}${HOME}/Scripts:${HOME}/AppImages:${HOME}/Applications:/opt/nvim:${HOME}/.local/bin"

# Pico SDK Configuration
export PICO_SDK_PATH="${HOME}/Documents/Raspberry/pico/pico-sdk"
export PICO_EXAMPLES_PATH="${HOME}/Documents/Raspberry/pico/pico-examples"
export PICO_EXTRAS_PATH="${HOME}/Documents/Raspberry/pico/pico-extras"
export PICO_PLAYGROUND_PATH="${HOME}/Documents/Raspberry/pico/pico-playground"

#------------------------------------------------------------------------------
# Aliases
#------------------------------------------------------------------------------

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Common aliases
alias ll='ls -lhF'
alias la='ls -AhF'
alias l='ls -CF'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias nv='nvim'

#------------------------------------------------------------------------------
# Prompt Configuration
#------------------------------------------------------------------------------

# Determine distro icon
_distro_icon() {
    cat /tmp/_distro_icon 2>/dev/null && return

    local i

    if grep -q "^Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
        i=""
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        case "${ID,,}" in
            debian)      i="" ;;
            mint)        i="󰣭" ;;
            arch)        i="󰣇" ;;
            kali)        i="" ;;
            manjaro)     i="󱘊" ;;
            fedora)      i="" ;;
            parrot)      i="" ;;
            raspbian*)   i="" ;;
            *)           i="" ;;
        esac
    else
        i=""
    fi

    printf "%s" "$i" | tee /tmp/_distro_icon
}

DISTRO_ICON=$(_distro_icon)

# Optimized prompt with right-aligned timestamp
_set_prompt() {
    local last_status=$?
    local user=$(whoami | sed "s/^./\U&/")
    local timestamp="\$(date +%T)"
    
    PS1=""
    
    if [[ $SSH_CLIENT == ::1* ]]; then
        PS1+='\[\e[96m\]🭨\[\e[0;106m\] \[\e[30;106m\]'"${user}"'\[\e[39m\] \[\e[30;42m\] \[\e[0;46m\] \[\e[30;46m\]\w\[\e[0;46m\] \[\e[0;36m\]🭪\n\[\e[96m\] ❱\[\e[0m\] '
    else
        PS1+='\[\e[96m\]\[\e[30;106m\]'"${DISTRO_ICON} ${user}"'\[\e[96;46m\] \[\e[30;46m\]\w\[\e[0;36m\] \[\e[0m\]'"${timestamp}"'\n\[\e[96m\] >\[\e[0m\]' 
    fi
    
      return $last_status
}

PROMPT_COMMAND='_set_prompt'

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

ws() {
    local base_wsfile_path="/tmp/.ws_workspace_"
    local action="$1"
    local num_arg="$2"
    local ws_num # The actual workspace number to use (0-9)
    local wsfile
    local dir
    local i # for loop counter

    # Pre-processing for shorthands:
    # "ws" -> "ws go 1"
    # "ws <n>" -> "ws go <n>"
    if [[ -z "$action" ]]; then
        action="go"
        num_arg="1" # Simulate "ws go 1" by setting num_arg
    elif [[ "$action" =~ ^[0-9]$ ]] && [[ ${#action} -eq 1 ]] && [[ -z "$num_arg" ]]; then
        num_arg="$action" # Move the number <n> to num_arg
        action="go"       # Set action to "go"
    fi

    # Main logic dispatch based on action
    case "$action" in
        set|go)
            if [[ -z "$num_arg" ]]; then # Default to workspace 1 if called as "ws set" or "ws go" with no number
                ws_num=1
            elif [[ "$num_arg" =~ ^[0-9]$ ]] && [[ ${#num_arg} -eq 1 ]]; then
                ws_num="$num_arg"
            else
                echo "Error: Workspace number for '$action' must be a single digit (0-9)."
                echo "If no number is provided (for 'set' or 'go'), it defaults to workspace 1."
                echo "Usage: ws $action [0-9]"
                return 1
            fi
            wsfile="${base_wsfile_path}${ws_num}" # Define wsfile here once ws_num is known

            if [[ "$action" == "set" ]]; then
                # Storing the full path guarantees correctness even if PWD changes for symlinks
                local current_dir
                current_dir=$(pwd -P)
                if echo "$current_dir" > "$wsfile"; then
                    echo "Workspace $ws_num set to $current_dir"
                else
                    echo "Error: Failed to write to workspace file $wsfile."
                    return 1
                fi
            else # action == "go"
                if [[ -f "$wsfile" ]]; then
                    dir=$(<"$wsfile") # Read directory path from file
                    if [[ -n "$dir" ]] && [[ -d "$dir" ]]; then
                        if cd "$dir"; then
                            # Optionally, print a confirmation:
                            # echo "Changed directory to workspace $ws_num: $dir"
                            : # Successful cd
                        else
                            echo "Error: Could not change directory to '$dir' for workspace $ws_num."
                            echo "The path might be correct but permissions prevent access or it's no longer valid."
                            return 1
                        fi
                    else
                        echo "Error: Directory for workspace $ws_num ('$dir') is invalid or not found."
                        echo "The workspace file $wsfile might be corrupted or point to a non-existent/invalid directory."
                        echo "You can set it again with: ws set $ws_num"
                        return 1
                    fi
                else
                    echo "Workspace $ws_num is not set. Use 'ws set $ws_num' to set it."
                    return 1
                fi
            fi
            ;;
        get)
            if [[ "$num_arg" =~ ^[0-9]$ ]] && [[ ${#num_arg} -eq 1 ]]; then
                ws_num="$num_arg"
                wsfile="${base_wsfile_path}${ws_num}"
                if [[ -f "$wsfile" ]]; then
                    cat "$wsfile"
                else
                    echo "Workspace $ws_num is not set."
                    return 1 # Indicate that the get operation couldn't find the workspace
                fi
            else
                echo "Error: Workspace number (a single digit 0-9) is required for 'get'."
                echo "Usage: ws get <0-9>"
                return 1
            fi
            ;;
        clear)
            if [[ -z "$num_arg" ]]; then
                # "ws clear" - clear all workspaces
                local count_cleared=0
                local count_found=0
                local count_errors=0
                echo "Attempting to clear all workspaces (0-9):"
                for i in {0..9}; do
                    wsfile="${base_wsfile_path}${i}"
                    if [[ -f "$wsfile" ]]; then
                        ((count_found++))
                        if rm "$wsfile"; then
                            echo "  Workspace $i cleared."
                            ((count_cleared++))
                        else
                            echo "  Error: Could not clear workspace $i ($wsfile)."
                            ((count_errors++))
                        fi
                    fi
                done

                if ((count_found == 0)); then
                    echo "No workspaces were set to clear."
                else
                    echo "Finished: $count_cleared of $count_found found workspace(s) cleared."
                    if ((count_errors > 0)); then
                        echo "$count_errors workspace(s) could not be cleared due to errors."
                        return 1 # Indicate some operations failed
                    fi
                fi
            elif [[ "$num_arg" =~ ^[0-9]$ ]] && [[ ${#num_arg} -eq 1 ]]; then
                # "ws clear <n>" - clear specific workspace
                ws_num="$num_arg"
                wsfile="${base_wsfile_path}${ws_num}"
                if [[ -f "$wsfile" ]]; then
                    if rm "$wsfile"; then
                        echo "Workspace $ws_num cleared."
                    else
                        echo "Error: Could not clear workspace $ws_num ($wsfile)."
                        return 1
                    fi
                else
                    echo "Workspace $ws_num was not set, nothing to clear."
                fi
            else
                echo "Error: For 'clear', provide a single digit (0-9) or no argument (to clear all)."
                echo "Usage: ws clear [0-9]"
                return 1
            fi
            ;;
        *)
            echo "Usage: ws {set [0-9]?|go [0-9]?|get <0-9>|clear [0-9]?|<0-9>}"
            echo "Details:"
            echo "  ws set [n]    - Sets workspace n (default 1) to current directory."
            echo "  ws go [n]     - Goes to workspace n (default 1)."
            echo "  ws get <n>    - Prints path of workspace n."
            echo "  ws clear [n]  - Clears workspace n; if n is omitted, clears all (0-9)."
            echo "  ws <n>        - Shorthand for 'ws go n' (n is 0-9)."
            echo "  ws            - Shorthand for 'ws go 1'."
            return 1
            ;;
    esac
    return 0 # Default success if not returned earlier
}


mass_replace() {
    if [ "$#" -eq 2 ]; then
        local dir="."
        local original="$1"
        local target="$2"
    elif [ "$#" -eq 3 ]; then
        local dir="$1"
        local original="$2"
        local target="$3"
    else
        echo "Usage:"
        echo "  mass_replace <original> <target>"
        echo "  mass_replace <directory> <original> <target>"
        return 1
    fi

    find "$dir" -type f -exec sed -i "s|$original|$target|g" {} +
}


#------------------------------------------------------------------------------
# External Tools Initialization
#------------------------------------------------------------------------------

# Pyenv
PATH="${PATH:+"$PATH:"}${HOME}/.pyenv/bin"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
fi

# Conda
[[ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]] && \
    source "${HOME}/miniconda3/etc/profile.d/conda.sh"

# Broot
[[ -f "${HOME}/.config/broot/launcher/bash/br" ]] && \
    source "${HOME}/.config/broot/launcher/bash/br"

# TMUX (optional)
# [ -z "$TMUX" ] && [ -n "$DISPLAY" ] && command -v tmux >/dev/null && \
#     exec tmux new-session -A -s "${USER}"

#------------------------------------------------------------------------------
# Cleanup
#------------------------------------------------------------------------------

unset _add_to_path _distro_icon  # Remove helper functions from global scope
export PATH="/home/night/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/night/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export ANDROID_HOME="/home/night/Applications/android-sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export ANDROID_NDK_HOME="/home/night/Applications/android-ndk-r27d"
export PATH="$PATH:$ANDROID_NDK_HOME"
. "$HOME/.cargo/env"
