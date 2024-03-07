# ██       ██████  ██   ██ ███    ███  █████  ███    ██    ██████   █████  ███████ ██   ██ ██████   ██████
# ██      ██    ██ ██  ██  ████  ████ ██   ██ ████   ██    ██   ██ ██   ██ ██      ██   ██ ██   ██ ██
# ██      ██    ██ █████   ██ ████ ██ ███████ ██ ██  ██    ██████  ███████ ███████ ███████ ██████  ██
# ██      ██    ██ ██  ██  ██  ██  ██ ██   ██ ██  ██ ██    ██   ██ ██   ██      ██ ██   ██ ██   ██ ██
# ███████  ██████  ██   ██ ██      ██ ██   ██ ██   ████ ██ ██████  ██   ██ ███████ ██   ██ ██   ██  ██████

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#  custom colors for the prompt
WHITE="\[\e[97m\]"
RED="\[\e[91m\]"
GREEN="\[\e[92m\]"
BLUE="\[\e[94m\]"
RESET="\[\e[0m\]"

# Prompt with colors and the IBM logo
PS1="${WHITE}\u${RESET}@${RED}I${GREEN}B${BLUE}M${RESET}-${WHITE}T480${RESET}:${BLUE}\w${RESET}\\$ "

# Check if inside a TMUX session
if [ -z "$TMUX" ]; then
    # Generate a unique session name based on date and time to avoid conflicts
    SESSION_NAME="session_$(date +%Y%m%d%H%M%S)"
    # Create and attach to a new session with the unique name
    tmux new-session -s "$SESSION_NAME" -d
    # Attach to the newly created session
    tmux attach-session -t "$SESSION_NAME"
    # When the tmux attach command exits (meaning the session is closed), kill the session
    # This ensures the session is not left hanging when the terminal window is closed
    tmux kill-session -t "$SESSION_NAME"
fi

export LANG=en_US.UTF-8
export PATH=/usr/bin:$PATH
export PATH="$PATH:/root/.local/share/gem/ruby/3.0.0/bin"
export HISTTIMEFORMAT='%F %T '

# Function for aliases

colorize_history() {
    history | awk '
    /python|jupyter|conda-create|conda-jupyter|conda-new|conda-remove/ {print "\033[1;34m" $0 "\033[0m"}  # Blue for Python, Jupyter, and Conda commands
    /conda|pip|mongostart|mongoshlokman/ {print "\033[1;32m" $0 "\033[0m"}      # Green for Conda, Pip, and MongoDB commands
    /git|gcm|gp|ga|gitignore|readme|ginit|gc|gfa|tiga/ {print "\033[1;31m" $0 "\033[0m"}  # Red for Git commands and aliases
    /ls|l|la|ani-cli/ {print "\033[1;33m" $0 "\033[0m"}   # Yellow for file system commands and ani-cli
    /grep/ {print "\033[1;35m" $0 "\033[0m"}  # Purple for grep
    /c|\.\.|\.\.\.|clear/ {print "\033[1;36m" $0 "\033[0m"}  # Cyan for navigation and clear commands
    !/python|jupyter|conda|pip|git|ls|l|la|grep|ani-cli|c|\.\.|\.\.\.|gcm|gp|ga|gitignore|readme|ginit|gc|gfa|tiga|mongostart|mongoshlokman|conda-create|conda-jupyter|conda-new|conda-remove/ {print $0}  # Default color for other commands
    '
}

filter_python_history() {
    history | grep --color=auto -E 'python|pip|conda|jupyter'
}

docker-run-port() {
    docker run -p 8080:8000 "$1"
}


# Set aliases for common commands
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'
alias l='ls -lAGFbhv --group-directories-first'
alias la="ls -a --color=auto"
alias c="clear"
alias n="nano"
alias q="exit"
alias h='colorize_history'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Directories and files

alias proj="cd ~/projects"
alias simplon="cd ~/simplon"
alias briefs="cd~/simplon/00.briefs"
alias gitignore="touch .gitignore"
alias readme="touch README.MD"
alias mvnew='mkdir -p new_folder && mv * new_folder/'
alias s='source ~/.bashrc'
alias bashrc='nano ~/.bashrc'

#Git
alias ginit="git init"
alias gc="git clone"
alias g="git status"
alias gc="git checkout"
alias gp="git pull"
alias gf="git fetch"
alias gfa="git fetch --all"
alias tiga="tig --all"
alias gcm="git commit -m"
alias gp="git push"
alias ga="git add"

#Python
alias p="python"
alias py='python'
alias hp='filter_python_history'
alias jl="jupyter-lab"

#mongoDb

alias mongostart="sudo systemctl start mongodb.service"
alias mongostop="sudo systemctl stop mongodb.service"
alias mongoshlokman="mongosh "mongodb://localhost:27017/?authSource=admin" --username lokman --password"

#Conda

alias conda-new='function _conda_new(){ conda create --name $1 python=$2; };_conda_new'
alias conda-remove='function _conda_remove(){ conda remove --name $1 --all; };_conda_remove'
alias conda-create="conda create -n myenv python=\$(conda search python --json | grep '\"version\":' | tail -1 | awk '{print \$2}' | tr -d '\"' | tr -d ',')"
alias conda-jupyter="conda install -c conda-forge jupyterlab"

#Docker

alias docker-start='sudo systemctl start docker'
alias docker-stop='sudo systemctl stop docker'
alias docker-build='docker build -t my-python-script .'
alias docker-run='docker run -it my-python-script'
alias docker-run-port='docker run -p 8080:8000 my-python-script'

#Apps
alias ani-cli="sudo ani-cli"
alias yt="ytfzf -t"
alias rr="/home/lokman/.local/roll.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/lokman/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lokman/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/lokman/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/lokman/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Shows an IBM logo when opening a terminal

#if [ -d ~/.local/IBM-ASCII-Logo-For-SSH ] && [ -f ~/.local/IBM-ASCII-Logo-For-SSH/ibm.sh ]; then
#    source ~/.local/IBM-ASCII-Logo-For-SSH/ibm.sh
#fi

