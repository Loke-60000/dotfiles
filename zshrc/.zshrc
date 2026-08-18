# start tmux in ghostty
if [[ -o interactive && -z $TMUX && -n $GHOSTTY_RESOURCES_DIR ]] && command -v tmux >/dev/null; then
  tmux new-session -A -s main && exit
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## ~/.zshrc

# Fast, clean shell defaults
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB

HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000

zmodload zsh/complist
autoload -Uz compinit

# Extra completion definitions
fpath=("$HOME/.zsh/plugins/zsh-completions/src" $fpath)
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' rehash true

# Theme switching (p10k default, minimal clean fallback)
THEME_MODE_FILE="$HOME/.zsh/theme-mode"

use_theme_minimal() {
  mkdir -p "$HOME/.zsh"
  printf 'minimal\n' >| "$THEME_MODE_FILE"
  exec zsh
}

use_theme_p10k() {
  mkdir -p "$HOME/.zsh"
  printf 'p10k\n' >| "$THEME_MODE_FILE"
  exec zsh
}

theme_current() {
  if [ -f "$THEME_MODE_FILE" ]; then
    cat "$THEME_MODE_FILE"
  else
    printf 'p10k\n'
  fi
}

THEME_MODE='p10k'
[ -f "$THEME_MODE_FILE" ] && THEME_MODE="$(<"$THEME_MODE_FILE")"

if [ "$THEME_MODE" = 'minimal' ]; then
  source "$HOME/.zsh/themes/clean-ibm.zsh"
else
  source "$HOME/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme"
  [ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"

  # Evangelion palette overrides for prompt segments.
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=214
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=214
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=214
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=214
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=34
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=160
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=214
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=34
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=178
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=178
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=214
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=160
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=214
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=160
fi

# Keep plain command text in Evangelion orange to match Ghostty foreground.
autoload -Uz add-zsh-hook
_eva_cmd_orange() { print -Pn "\e]10;#EB9318\a" }
add-zsh-hook precmd _eva_cmd_orange

# Plugins (order matters)
source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Autosuggestion behavior
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#767676'
bindkey '^ ' autosuggest-accept

# Evangelion colors for fuzzy finder/completion UI.
export FZF_DEFAULT_OPTS='--color=fg:#EB9318,bg:#000000,hl:#C50F1F,fg+:#F2F2F2,bg+:#0C0C0C,hl+:#E74856,pointer:#C50F1F,marker:#13A10E,prompt:#EB9318,spinner:#881798,header:#3A96DD'

# Better history search with arrows
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# fzf integration (Ctrl+R search)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# Extra power tools (loaded only when installed)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

[ -x /usr/bin/eza ] && alias ls='eza --group-directories-first --icons=auto'
[ -x /usr/bin/eza ] && alias ll='eza -lah --group-directories-first --icons=auto'
[ -x /usr/bin/eza ] || alias ls='ls --color=auto'
[ -x /usr/bin/eza ] || alias ll='ls -lah'

command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never --style=plain'
command -v bat >/dev/null 2>&1 && alias bathelp='bat --help'
command -v fd >/dev/null 2>&1 && alias find='fd'

# Short aliases
alias la='ls -a'
alias l='ls'
alias lt='ls --tree --level=2'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias md='mkdir -p'
alias rd='rmdir'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias du='du -sh'
alias grep='grep --color=auto'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -15'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias cls='clear'
alias c='clear'
alias ff='fastfetch'
# alias code='flatpak run com.visualstudio.code'
alias q='exit'
alias py='python'
alias zed='zeditor'
alias cc='claude --dangerously-skip-permissions'
alias oc='OPENCODE_PERMISSION='\''{"edit":"allow","bash":"allow","webfetch":"allow"}'\'' opencode'

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

# opencode
export PATH=$HOME/.opencode/bin:$PATH
alias op='opencode'

alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'

# cheatsheet
h() {
  [ -n "$1" ] && { alias | grep -i -- "$1"; return }
  print -P '
%F{214}typing in the shell%f
  ctrl + space        take the grey suggestion
  ctrl + left/right   jump a whole word
  up / down           search history for what you typed so far
  ctrl + r            fuzzy-search all history
  ctrl + v            paste     (ctrl+shift+c copies)
  ctrl + c            interrupt, never paste

%F{214}tmux%f  splits one window into several shells
  tn work             start a session named work
  ta work             go back into it later
  tl                  list sessions

%F{214}inside tmux -- no ctrl+b needed%f
  alt + t             new window
  alt + 1 2 3 ...     jump to window 1, 2, 3
  alt + r             rename this window
  ctrl + pgup/pgdn    previous / next window
  alt + arrows        move between panes
  or just click a window name in the bottom bar
  shift + drag        select text the normal way (ignores tmux)
  drag                selects one pane and copies, highlight just vanishes

%F{214}the rest%f  press ctrl+b, let go, then the key
  ctrl+b   |          split left/right
  ctrl+b   -          split top/bottom
  ctrl+b   z          fullscreen this pane (again to undo)
  ctrl+b   d          leave tmux, keep it running
  ctrl+b   [          scroll back (press q to stop)
  ctrl+b   ?          list every key
  ctrl+b   ctrl+s     save the session now
  ctrl+b   ctrl+r     bring a saved session back
  fg                  if tmux ever "suspends", this brings it back

%F{8}h <word>   find an alias, e.g.  h git%f'
}

# Fastfetch: run manually with 'fastfetch'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


. "$HOME/.local/bin/env"

# Android SDK
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH"

# kimi-code
export PATH="$HOME/.kimi-code/bin:$PATH"

eval "$(snail init zsh)"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# keys zsh leaves unbound, which otherwise spit out ~ C D A B
for k in '^[[H' '^[[1~' '^[OH' '^[[1;5H' '^[[1;2H'; do bindkey $k beginning-of-line; done
for k in '^[[F' '^[[4~' '^[OF' '^[[1;5F' '^[[1;2F'; do bindkey $k end-of-line; done
for k in '^[[1;5C' '^[[1;3C' '^[[1;6C'; do bindkey $k forward-word; done
for k in '^[[1;5D' '^[[1;3D' '^[[1;6D'; do bindkey $k backward-word; done
for k in '^[[1;5A' '^[[1;3A' '^[[1;2A' '^[[5~' '^[[5;5~'; do bindkey $k history-substring-search-up; done
for k in '^[[1;5B' '^[[1;3B' '^[[1;2B' '^[[6~' '^[[6;5~'; do bindkey $k history-substring-search-down; done
bindkey '^[[3~'   delete-char           # delete
bindkey '^[[3;2~' delete-char
bindkey '^[[3;3~' kill-word
bindkey '^[[3;5~' kill-word             # ctrl+delete
bindkey '^H'      backward-kill-word    # ctrl+backspace
bindkey '^[[2~'   overwrite-mode
bindkey '^[[Z'    reverse-menu-complete # shift+tab
bindkey '^[[1;2C' forward-char          # shift+arrows: zsh has no selection,
bindkey '^[[1;2D' backward-char         # so just move instead of typing letters

# private, untracked
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
