if exists("current_compiler")
  finish
endif

let current_compiler = "python"

if exists(":CompilerSet") != 2                " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet errorformat=
    \\ %#File\ \"%f\"\\,\ line\ %l%m,
    \\@File\:\ %f

let &cpo = s:cpo_save
unlet s:cpo_save
