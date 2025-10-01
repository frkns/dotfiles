emulate bash
setopt no_nomatch

# Set up the prompt
autoload -Uz promptinit
promptinit

# ----- Migrated from .bashrc -----
# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
setopt APPEND_HISTORY

# Check for window size
autoload -Uz compinit
compinit

# Prompt configuration - clean prompt without username@hostname
# PS1='%~ $ '
# PS1=$'%~ \n$ '
# Function to get git branch

setopt prompt_subst

git_branch_prompt() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -n $branch ]] && echo " %F{green}($branch)%f"
}

venv_prompt() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo " %F{magenta}(venv:$(basename $VIRTUAL_ENV))%f"
  elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    echo " %F{magenta}(conda:$CONDA_DEFAULT_ENV)%f"
  fi
}

PROMPT=$'%F{magenta}%~%f$(venv_prompt)$(git_branch_prompt)\n$ '



# # Enable color support for ls and add handy aliases
# if command -v dircolors >/dev/null 2>&1; then
#     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
# fi

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias lt='ls -t | less'

if [[ "$TERM_PROGRAM" != "vscode" \
   && "$TERM_PROGRAM" != "WarpTerminal" \
   && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" \
   && -z "$TMUX" ]]; then
    tmux
fi

# Path settings
export PATH="$HOME/pathc:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

export downloads='/mnt/c/Users/flame/Downloads'
export dl='/mnt/c/Users/flame/Downloads'
export flame='/mnt/c/Users/flame'
export wlink='/mnt/c/Users/flame/wlink'
export desktop='/mnt/c/Users/flame/OneDrive/Desktop'

export PATH="$HOME/pathc:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin

export PATH=$PATH:/mnt/c/Windows:/mnt/c/Windows/system32
export PATH=$PATH:/mnt/c/Windows/System32/WindowsPowerShell/v1.0


# Load various environment settings
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh_history


# Exported variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Loads bash_completion


alias vim='nvimcd'

nvimcd() {
  # Create temporary shim directory
  local shim_dir
  shim_dir="$(mktemp -d)"

  # Create a fake `python3` that runs python3.13
  cat <<EOF > "$shim_dir/python3"
#!/bin/bash
exec /usr/bin/python "\$@"
EOF
  chmod +x "$shim_dir/python3"

  # Prepend shim to PATH
  export PATH="$shim_dir:$PATH"

  # Launch Neovim
  nvim "$@"

  # Clean up
  rm -rf "$shim_dir"

  if [ -f ~/.nvim_cwd ]; then
    cd "$(cat ~/.nvim_cwd)" || echo "Failed to change shell dir"
    rm ~/.nvim_cwd
  fi
}



if [[ "$PWD" == *WindowsApps ]] || [[ "$PWD" == *system32 ]]; then
    cd "$HOME"
fi



# Source additional environments
[ -f "/home/sunrise/.ghcup/env" ] && . "/home/sunrise/.ghcup/env"
. "$HOME/.cargo/env"


setopt histignorealldups sharehistory

# Use vi keybindings
bindkey -v
export EDITOR='nvim'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

alias pip='python3.13 -m pip'
# alias pip3.10='python3.10 -m pip'
# alias pip3.11='python3.11 -m pip'
# alias pip3.13='python3.13 -m pip'

export PATH="$HOME/go/bin:$PATH"


function lfcd() {
  local tmpfile=$(mktemp)
  lf -last-dir-path="$tmpfile"
  if [[ -f "$tmpfile" ]]; then
    local dir=$(cat "$tmpfile")
    rm -f "$tmpfile"
    if [[ -d "$dir" ]]; then
      cd "$dir"
    fi
  fi
}
alias lf='lfcd'
