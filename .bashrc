# vim: set filetype=sh :

#****************
# Shell options
#****************

# Make Tab autocomplete regardless of filename case
set completion-ignore-case on

# List all matches in case multiple possible completions are possible
set show-all-if-ambiguous on

# Immediately add a trailing slash when autocompleting symlinks to directories
set mark-symlinked-directories on

# Do not autocomplete hidden files unless the pattern explicitly begins with a dot
set match-hidden-files off

# Show all autocomplete results at once
set page-completions off

# If there are more than 200 possible completions for a word, ask to show them all
set completion-query-items 200

# Show extra file information when completing, like `ls -F` does
set visible-stats on

# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
set skip-completed-text on

# Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
set input-meta on
set output-meta on
set convert-meta off

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Update bash's idea of window size upon SIGWINCH
shopt -s checkwinsize

#***************
# Bash Exports
#***************

# Set the terminal type to xterm-256color
export TERM=xterm-256color

# Make vim the default editor
export EDITOR="vim"

# Larger bash history
export HISTSIZE=2000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="clear:* --help"

# Use /etc/hosts to complete directory names in bash
export HOSTFILE="/etc/hosts"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Fancy ls colors
export CLICOLOR='Yes'
export LSCOLORS='ExGxCxDxBxegedabagacad'

# Make less searches case-insensitive and let ANSI colours through
export LESS="-i -R"
# Don't let less keep any history
export LESSHISTFILE='/dev/null'
export LESSHISTSIZE=0

# git prompt related environment variables
export GIT_PS1_SHOWDIRTYSTATE='yes'
export GIT_PS1_SHOWSTASHSTATE='yes'
export GIT_PS1_SHOWUNTRACKEDFILES='yes'

# Add a personal bin directory to the PATH, if any
if [[ -d ~/bin ]]; then
	PATH=~/bin:$PATH
fi

# Add /opt/local/bin to the start of the path if it exists
if [[ -d /opt/local/bin ]]; then
  PATH=/opt/local/bin:$PATH
fi

#***************
# Bash Aliases
#***************

# Use vim
alias vi="vim"

# Grep out comments from a file
alias nocomm="grep -Ev '^$|^#'"

#*****************
# Tab Completion
#*****************

### SSH HOSTNAME COMPLETION ###
# Source: http://en.newinstance.it/2011/06/30/ssh-bash-completion/
# Add bash completion for ssh: it tries to complete the host to which you 
# want to connect from the list of the ones contained in ~/.ssh/known_hosts

__ssh_known_hosts() {
    if [[ -f ~/.ssh/known_hosts ]]; then
        cut -d " " -f1 ~/.ssh/known_hosts | cut -d "," -f1
    fi
}

_ssh() {
    local cur known_hosts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    known_hosts="$(__ssh_known_hosts)"
    
    if [[ ! ${cur} == -* ]] ; then
    	COMPREPLY=( $(compgen -W "${known_hosts}" -- ${cur}) )
        return 0
    fi
}

complete -o bashdefault -o default -o nospace -F _ssh ssh 2>/dev/null \
	|| complete -o default -o nospace -F _ssh ssh

# If possible, add tab completion for many more commands
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

#**************
# Bash Prompt
#**************

function __prompt_command() {
  local EXIT="$?"
  PS1=""

  # Set the terminal title
  echo -ne "\033]0;${HOSTNAME}\007"

  local RED="\[$(tput setaf 1)\]"
  local GREEN="\[$(tput setaf 2)\]"
  local YELLOW="\[$(tput setaf 3)\]"
  local BLUE="\[$(tput setaf 4)\]"
  local MAGENTA="\[$(tput setaf 5)\]"
  local CYAN="\[$(tput setaf 6)\]"
  local WHITE="\[$(tput setaf 7)\]"
  local BOLD="\[$(tput bold)\]"
  local UNDERLINE="\[$(tput sgr 0 1)\]"
  local RESET="\[$(tput sgr0)\]"
  local PROMPTCOL="${YELLOW}"
  
  # TODO: prompt I like better
  PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
}

export PROMPT_COMMAND=__prompt_command  # Func to gen PS1 after CMDs

#*******************
# Helper Functions
#*******************

# Do a forward then reverse lookup on a host
hostrev() {
  host `host $1 | cut -d" " -f4` | cut -d" " -f5
}

#*******************
# Local bashrc
#*******************

# Load a local bashrc for this machine, if any
if [ -f ~/.bashrc-local ]; then
	. ~/.bashrc-local
fi
