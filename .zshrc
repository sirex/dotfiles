# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sirex"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

export AUTHOR="Mantas Zimnickas <sirexas@gmail.com>"
export EDITOR=vim
export HGEDITOR=$HOME/bin/hgeditor
export PYTHONIOENCODING=UTF-8
export LESS="-R"

# Aliases
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

#alias lab="ipython --no-confirm-exit --no-banner --pylab --autocall=2 --colors=Linux -c 'from __future__ import division ; from datetime import datetime, timedelta, date ; now = datetime.now ; today = date.today ; dt = datetime ; td = timedelta ; year = td(days=365) ; month = td(days=30) ; week = td(days=7) ; day = td(days=1)' -i"
alias lab="ipython --no-confirm-exit --no-banner --pylab --autocall=2 -i"

unsetopt correct_all

# Edit entered command using external editor by pressing <c-x>e
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# Change current working directory using ranger.
function rcd {
  tempfile='/tmp/choosendir'
  ranger --fail-unless-cd --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" && \
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}

# virtualenvwrapper
# http://virtualenvwrapper.readthedocs.org/
export WORKON_HOME=$HOME/.venvs
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper_lazy.sh

if [ -f $HOME/.local/zshrc ] ; then
    source $HOME/.local/zshrc
fi
