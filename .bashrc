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

PATH="${PATH:+"$PATH:"}${HOME}/Documents/bashScripts:${HOME}/bash_scripts:${HOME}/AppImages:${HOME}/Applications:/opt/nvim:${HOME}/.local/bin"

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

# (ws was rewritten in c++)

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
