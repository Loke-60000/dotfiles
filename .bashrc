# ██       ██████  ██   ██ ███    ███  █████  ███    ██    ██████   █████  ███████ ██   ██ ██████   ██████
# ██      ██    ██ ██  ██  ████  ████ ██   ██ ████   ██    ██   ██ ██   ██ ██      ██   ██ ██   ██ ██
# ██      ██    ██ █████   ██ ████ ██ ███████ ██ ██  ██    ██████  ███████ ███████ ███████ ██████  ██
# ██      ██    ██ ██  ██  ██  ██  ██ ██   ██ ██  ██ ██    ██   ██ ██   ██      ██ ██   ██ ██   ██ ██
# ███████  ██████  ██   ██ ██      ██ ██   ██ ██   ████ ██ ██████  ██   ██ ███████ ██   ██ ██   ██  ██████

[[ $- != *i* ]] && return

export LANG=en_US.UTF-8
export PATH=/usr/bin:$PATH
export PATH="$PATH:/root/.local/share/gem/ruby/3.0.0/bin"
export HISTTIMEFORMAT='%F %T '

# # Check if we are not already in a tmux session
# if [ -z "$TMUX" ]; then
#     # Create a unique session name based on the current date and time
#     SESSION_NAME="session_$(date +%Y%m%d%H%M%S)"
    
#     # Create a new detached tmux session with the unique name
#     tmux new-session -s "$SESSION_NAME" -d
    
#     # Attach to the newly created session
#     tmux attach-session -t "$SESSION_NAME"
    
#     # Ensure .tmux.conf is sourced after attaching to a session
#     # This line is not needed for sourcing .tmux.conf but ensures your environment is as expected
# fi

WHITE="\[\033[97m\]"
RED="\[\033[91m\]"
GREEN="\[\033[92m\]"
BLUE="\[\033[94m\]"
YELLOW="\[\033[93m\]"
CYAN="\[\033[96m\]"
RESET="\[\033[0m\]"

parse_git_branch() {
  branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ -n "$branch" ]; then
    echo " -[$branch]-"
  fi
}

PS1="${YELLOW}\A ${RESET}| ${WHITE}\u${RESET}@${RED}I${GREEN}B${BLUE}M${RESET}-${WHITE}T480${RESET}:${BLUE}\w${CYAN}\$(parse_git_branch)${RESET}\\$ "

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

gitsize() {
  local repoPath=$(echo $1 | sed -E 's/https:\/\/github\.com\/([^\/]+\/[^\/]+).*/\1/')
  local repoUrl="https://api.github.com/repos/$repoPath"
  local size=$(curl -s "$repoUrl" | jq '.size')
  echo "${size}KB"
}

filter_python_history() {
    history | grep --color=auto -E 'python|pip|conda|jupyter'
}

docker_run_port() {
    docker run -p 8080:8000 "$1"
}


# common commands
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
alias gcl="git clone"
alias gs="git status"
alias gco="git checkout"
alias gpull="git pull"
alias gf="git fetch"
alias gfa="git fetch --all"
alias tiga="tig --all"
alias gcm="git commit -m"
alias gpush="git push"
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
alias ca="conda activate"
alias cdeactivate="conda deactivate"
alias ci="conda install"

#Docker
docker-start() {
    sudo systemctl start docker
}
docker-stop() {
    sudo systemctl stop docker
}
docker-build() {
    docker build -t "$1" .
}
docker-run() {
    docker run -it "$1"
}
docker-run-port() {
    docker run -p "$2":8000 "$1"
}

#PostgrelSQL
alias pgstart='sudo systemctl start postgresql'
alias pgstop='sudo systemctl stop postgresql'

#Azure
alias azurevm='ssh -i /home/lokman/.azure/ssh/lokman-az.pem lokman@4.178.104.84'
alias azlogin='az login'
alias azlistvms='az vm list -d -o table'
alias azstartvm='az vm start --name <your-vm-name> --resource-group <your-resource-group>'
alias azstopvm='az vm deallocate --name <your-vm-name> --resource-group <your-resource-group>'
alias azlistcontainers='az storage container list --account-name <storage-account-name> -o table'
alias azuploadblob='az storage blob upload --file <file-path> --container-name <container-name> --name <blob-name> --account-name <storage-account-name>'
azurepushdocker() {
    if [[ $# -ne 3 ]]; then
        echo "Usage: azurepushdocker <local-image-name:tag> <acr-name> <acr-repo:tag>"
        return 1
    fi
    local LOCAL_IMAGE_NAME=$1
    local ACR_NAME=$2
    local ACR_REPO_TAG=$3
    local ACR_LOGIN_SERVER="${ACR_NAME}.azurecr.io"
    az acr login --name "${ACR_NAME}"
    if [[ $? -ne 0 ]]; then
        echo "Failed to log in to Azure Container Registry: ${ACR_NAME}"
        return 1
    fi
    docker tag "${LOCAL_IMAGE_NAME}" "${ACR_LOGIN_SERVER}/${ACR_REPO_TAG}"
    docker push "${ACR_LOGIN_SERVER}/${ACR_REPO_TAG}"
}

# SSL Servers
alias khadas='ssh salieri@khadas.lokman.fr'
push2khadas() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: push2khadas <path-to-file-or-folder>"
        return 1
    fi
    local ITEM_TO_PUSH=$1
    local DESTINATION="salieri@khadas.lokman.fr:/home/salieri/Desktop/ssl-sharing"
    ssh salieri@khadas.lokman.fr "mkdir -p /home/salieri/Desktop/ssl-sharing"
    scp -r "${ITEM_TO_PUSH}" "${DESTINATION}/"

    if [[ $? -eq 0 ]]; then
        echo "Successfully pushed ${ITEM_TO_PUSH} to ${DESTINATION}"
    else
        echo "Failed to push ${ITEM_TO_PUSH} to ${DESTINATION}"
        return 1
    fi
}

#Apps
alias ani-cli="sudo ani-cli"
alias yt="ytfzf -t"
alias rr="/home/lokman/.local/roll.sh"
alias weather="curl wttr.in"
alias coin="curl rate.sx"
alias meaning='function _meaning_input() { read -p "Enter a word: " word; curl "dict://dict.org/d:$word"; }; _meaning_input'

# >>> conda initialize >>>
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
