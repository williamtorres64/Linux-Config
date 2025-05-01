# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Auto TMUX
#if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
#    exec tmux new-session -A -s ${USER} >/dev/null 2>&1
#fi

# ls Colors
LS_COLORS=$LS_COLORS:'di=1;94:' ; export LS_COLORS # Directory as bold bright blue

# Prompt
if [[ $SSH_CLIENT == ::1* ]]; then
  PROMPT_COMMAND='PS1_CMD1=$(whoami | sed "s/^./\U&/"); PS1_CMD2=$(tput sc; tput cuu1; tput hpa $(($(tput cols)-10)); date +%T; tput rc)';
  PS1='\[\e[96m\]🭨\[\e[0;106m\] \[\e[30;106m\]${PS1_CMD1}\[\e[39m\] \[\e[30;42m\] \[\e[0;46m\] \[\e[30;46m\]\w\[\e[0;46m\] \[\e[0;36m\]🭪\n\[\e[96m\] ❱\[\e[0m\]${PS1_CMD2} '
else
  DISTRO_ICON=$(if [ -f /proc/device-tree/model ] && grep -q "^Raspberry Pi" /proc/device-tree/model 2>/dev/null; then echo ""; elif [ -f /etc/os-release ]; then source /etc/os-release; case "${ID,,}" in debian) echo "";; mint) echo "󰣭";; arch) echo "󰣇";; kali) echo "";; manjaro) echo "󱘊";; fedora) echo "";; parrot) echo "";; raspberry|raspbian) echo "";; *) echo "";; esac; else echo ""; fi)
  PROMPT_COMMAND='PS1_CMD1=$(whoami | sed "s/^./\U&/"); PS1_CMD2=$(tput sc; tput cuu1; tput hpa $(($(tput cols)-10)); date +%T; tput rc)';
  PS1='\[\e[96m\]\[\e[30;106m\]${DISTRO_ICON} ${PS1_CMD1}\[\e[96;46m\] \[\e[30;46m\]\w\[\e[0;36m\] \n\[\e[96m\] >\[\e[0m\]${PS1_CMD2} ';
fi
# 󰄾

# Custom bash scripts
export PATH=$PATH:/home/night/Documents/bashScripts

# Neovim Appimage
export PATH="$PATH:/opt/nvim/"

# starship shell
#eval "$(starship init bash)"

# Appimages
export PATH=$PATH:/home/night/AppImages/
export PATH=$PATH:/home/night/Applications/

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
# Check if pyenv exists and initialize it
if [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi
# Local binaries
export PATH="$PATH:/home/night/.local/bin/"
export PICO_SDK_PATH=/home/night/Documents/Raspberry/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/night/Documents/Raspberry/pico/pico-examples
export PICO_EXTRAS_PATH=/home/night/Documents/Raspberry/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/night/Documents/Raspberry/pico/pico-playground
#export PICO_SDK_PATH=/home/night/Documents/Raspberry/pico/pico-sdk
#export PICO_EXAMPLES_PATH=/home/night/Documents/Raspberry/pico/pico-examples
#export PICO_EXTRAS_PATH=/home/night/Documents/Raspberry/pico/pico-extras
#export PICO_PLAYGROUND_PATH=/home/night/Documents/Raspberry/pico/pico-playground
# ESP IDF variables
alias get_idf='. /home/night/Documents/ESP32/esp-idf/export.sh'

# Git Dotfiles configuration
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/night/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/night/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/night/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/night/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

if [[ -d "$HOME/.config/broot" ]]; then
	source /home/night/.config/broot/launcher/bash/br
fi
