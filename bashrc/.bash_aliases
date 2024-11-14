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

#Apps
alias ani-cli="sudo ani-cli"
alias yt="ytfzf -t"
alias rr="/home/lokman/.local/roll.sh"
alias weather="curl wttr.in"
alias coin="curl rate.sx"
alias meaning='function _meaning_input() { read -p "Enter a word: " word; curl "dict://dict.org/d:$word"; }; _meaning_input'
alias wiki='function _wiki_input() { read -p "Enter a word: " word; curl "dict://dict.org/d:$word"; }; _wiki_input'