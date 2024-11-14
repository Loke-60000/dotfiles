# ██       ██████  ██   ██ ███    ███  █████  ███    ██    ██████   █████  ███████ ██   ██ ██████   ██████
# ██      ██    ██ ██  ██  ████  ████ ██   ██ ████   ██    ██   ██ ██   ██ ██      ██   ██ ██   ██ ██
# ██      ██    ██ █████   ██ ████ ██ ███████ ██ ██  ██    ██████  ███████ ███████ ███████ ██████  ██
# ██      ██    ██ ██  ██  ██  ██  ██ ██   ██ ██  ██ ██    ██   ██ ██   ██      ██ ██   ██ ██   ██ ██
# ███████  ██████  ██   ██ ██      ██ ██   ██ ██   ████ ██ ██████  ██   ██ ███████ ██   ██ ██   ██  ██████

[[ $- != *i* ]] && return

source ~/.bash_env
source ~/.bash_functions
source ~/.bash_aliases

PS1="${YELLOW}\A ${RESET}| ${WHITE}\u${RESET}@${RED}I${GREEN}B${BLUE}M${RESET}-${WHITE}T480${RESET}:${BLUE}\w${CYAN}\$(parse_git_branch)${RESET}\\$ "

# # >>> conda initialize >>>
# __conda_setup="$('/home/lokman/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/lokman/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/lokman/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/lokman/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
