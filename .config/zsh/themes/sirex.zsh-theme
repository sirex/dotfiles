# Based on https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/ys.zsh-theme

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}^%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Virtualenv
local venv_info='$(virtenv_prompt)'
YS_THEME_VIRTUALENV_PROMPT_PREFIX=" ("
YS_THEME_VIRTUALENV_PROMPT_SUFFIX=")"
virtenv_prompt() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo "${YS_THEME_VIRTUALENV_PROMPT_PREFIX}${VIRTUAL_ENV:t}${YS_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

local exit_code="%(?,, -> %{$fg[red]%}%?%{$reset_color%})"

# Borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/refined.zsh-theme
# Displays the exec time of the last command if set threshold was exceeded
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    [ $elapsed -gt 5 ] && print -P "\n(%F{yellow}${elapsed}s%f)"
}

# Get the initial timestamp for cmd_exec_time
preexec() {
    cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
precmd() {
    setopt localoptions nopromptsubst
    cmd_exec_time
    unset cmd_timestamp # Reset cmd exec time.
}

PROMPT="
%{$terminfo[bold]$fg[blue]%}# %T:%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n)\
%{$reset_color%}@\
%{$fg[green]%}%m\
%{$reset_color%}:\
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${git_info}\
${venv_info}\
$exit_code
%{$reset_color%}"
