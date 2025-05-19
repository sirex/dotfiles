export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh: https://ohmyz.sh/
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled    # disable automatic updates
plugins=()

ZSH_CUSTOM=$HOME/.config/zsh
ZSH_THEME="sirex"  # Custom theme ~/.config/zsh/themes/sirex.zsh-theme
HIST_STAMPS="yyyy-mm-dd"

source $ZSH/oh-my-zsh.sh

export AUTHOR="Mantas Zimnickas <sirexas@gmail.com>"
export EDITOR=nvim
export LESS="-R"

# Aliases
alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'
alias -g G='| grep -i'
alias -g L='| less -FRX'
alias -g C='| wc -l'
alias -g X='| xargs'

alias lg='lazygit'

if which eza >/dev/null ; then
    alias ls="eza -lMh --icons=auto --time-style=long-iso --smart-group"
    alias lss="eza -lMh --icons=auto --time-style=long-iso --smart-group --total-size --sort=size"
else
    alias ls='ls -1p --color --group-directories-first --time-style=long-iso -l'
fi


# Yazi
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}


# Fzf
source <(fzf --zsh)


# Zoxide
eval "$(zoxide init zsh)"
