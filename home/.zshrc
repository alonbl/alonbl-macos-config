autoload -Uz compinit && compinit
setopt PROMPT_SUBST
PS1='%F{green}%n@%m%f %F{blue}%1~%f %# '
unsetopt AUTO_MENU
setopt BASH_AUTO_LIST

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export LESS='-RX'

alias diff='diff --color=auto'
