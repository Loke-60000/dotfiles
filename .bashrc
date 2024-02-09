# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export LANG=en_US.UTF-8
export PATH=/usr/bin:$PATH
export PATH="$PATH:/root/.local/share/gem/ruby/3.0.0/bin"

# Set aliases for common commands
alias ani-cli="sudo ani-cli"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l="ls"
alias la="ls -a"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias gcm="git commit -m"
alias gp="git push"
alias ga="git add"
alias gitignore="touch .gitignore"
alias readme="touch README.MD"
alias ginit="git init"
alias gc="git clone"
alias gc="git checkout"
alias gp="git pull"
alias gf="git fetch"
alias gfa="git fetch --all"
alias tiga="tig --all"

#mongoDb

alias mongostart="sudo systemctl start mongodb.service"
alias mongoshlokman="mongosh "mongodb://localhost:27017/?authSource=admin" --username lokman --password"

#Conda

alias conda-new='function _conda_new(){ conda create --name $1 python=$2; };_conda_new'
alias conda-remove='function _conda_remove(){ conda remove --name $1 --all; };_conda_remove'
alias conda-create="conda create -n myenv python=\$(conda search python --json | grep '\"version\":' | tail -1 | awk '{print \$2}' | tr -d '\"' | tr -d ',')"
alias conda-jupyter="conda install -c conda-forge jupyterlab"

WHITE="\[\e[97m\]"
RED="\[\e[91m\]"
GREEN="\[\e[92m\]"
BLUE="\[\e[94m\]"
RESET="\[\e[0m\]"

PS1="${WHITE}\u${RESET}@${RED}I${GREEN}B${BLUE}M${RESET}-${WHITE}T480${RESET}:${BLUE}\w${RESET}\\$ "

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
# <<< conda initialize <<<
