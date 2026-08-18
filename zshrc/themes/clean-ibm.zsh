autoload -Uz colors && colors

setopt PROMPT_SUBST

PROMPT='%F{208}[%n@%m %1~]%f %# '
RPROMPT='%F{124}%*%f'
