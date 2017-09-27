# Runs before showing the prompt
function sirex_termtitle_precmd {
  title '${(j:/:)${(s:/:)PWD}[-2,-1]}'
}

# Runs before executing the command
function sirex_termtitle_preexec {
  title '${(j:/:)${(s:/:)PWD}[-2,-1]}'
}

precmd_functions+=(sirex_termtitle_precmd)
preexec_functions+=(sirex_termtitle_preexec)
