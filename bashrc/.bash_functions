parse_git_branch() {
  branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ -n "$branch" ]; then
    echo " -[$branch]-"
  fi
}

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
  echo "Calculating repository size, please wait..."
  tempDir=$(mktemp -d)
  git clone --quiet "$1" "$tempDir" > /dev/null 2>&1
  repoSize=$(du -sh "$tempDir" | cut -f1)
  rm -rf "$tempDir"
  echo "Repository size: $repoSize"
}

filter_python_history() {
    history | grep --color=auto -E 'python|pip|conda|jupyter'
}

docker_run_port() {
    docker run -p 8080:8000 "$1"
}

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

gen-ssh-cli() {
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    RESET='\033[0m'

    echo -e "${GREEN}Please enter your email:${RESET}"
    read -p "> " email
    while [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
        echo -e "${RED}Invalid email format. Please try again:${RESET}"
        read -p "> " email
    done

    echo -e "${GREEN}Please enter key type (e.g., rsa, ed25519) [default: rsa]:${RESET}"
    read -p "> " key_type
    key_type=${key_type:-rsa}

    if [[ "$key_type" == "rsa" ]]; then
        echo -e "${GREEN}Please enter key size (e.g., 4096) [default: 4096]:${RESET}"
        read -p "> " key_size
        key_size=${key_size:-4096}
    fi

    filename="$HOME/.ssh/id_${key_type}"

    if [[ "$key_type" == "ed25519" ]]; then
        ssh-keygen -t "$key_type" -C "$email" -f "$filename"
    else
        ssh-keygen -t "$key_type" -b "$key_size" -C "$email" -f "$filename"
    fi

    echo -e "${GREEN}Your SSH public key:${RESET}"
    cat "${filename}.pub"
}

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
