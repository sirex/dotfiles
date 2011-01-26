bindkey -e              # Emacs key bindings
setopt MENU_COMPLETE	# Complete'ina katalogus iš eilės, kaip Vim'e

PROMPT=$(print "\n<%n@%M:%/>\n » ")
PATH=$PATH:/home/sirex/bin

export AUTHOR="Mantas Zimnickas <sirexas@gmail.com>"
export EDITOR=vim

# Aliases
alias pd='pushd'
alias ls="ls --color=auto -pX"
alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias -g G='| grep -i'
alias -g L='| less'
alias -g C='| wc -l'
alias -g X='| xargs'
alias -g V='| vim -'
alias -g XV='| xargs vim'

alias o=xdg-open
# no glob
alias find="noglob find"
alias findgrep="noglob findgrep"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
