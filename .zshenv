bindkey -e              # Emacs key bindings
setopt MENU_COMPLETE	# Complete'ina katalogus iš eilės, kaip Vim'e

PROMPT=$(print "\n<%n@%M:%/>\n » ")
PATH=$PATH:/home/sirex/bin

export AUTHOR="Mantas Zimnickas <sirexas@gmail.com>"
export EDITOR=vim

# Aliases
alias ls="ls --color=auto -pX"
alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias less="w3m"
alias man="w3mman"
alias -g G='| grep -i'
alias -g L='| less'

# no glob
alias find="noglob find"
alias findgrep="noglob findgrep"

