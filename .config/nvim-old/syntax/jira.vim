" Borrowed from https://github.com/n0v1c3/vira/blob/master/syntax/vira.vim

if exists('b:current_syntax') | finish | endif

" Syntax matching
syntax match jiraIssuesStatus "| .* |" contained
syntax match jiraIssuesDescription "-  .*"hs=s+3 contains=jiraIssuesStatus nextgroup=jiraIssuesStatus
syntax match jiraIssuesIssue ".*-.*  -"he=e contains=jiraIssuesDescription nextgroup=jiraIssuesDescription
syntax match jiraBold "\*.*\*"
syntax match jiraBullets ".*\* "
syntax match jiraCitvtion "??.*??"
syntax match jiraCommentAuthor /.*@/hs=s,he=e contains=jiraCommentDate nextgroup=jiraCommentDate
syntax match jiraCommentClose "}}}"
syntax match jiraCommentDate /@.*/hs=s,he=e contained
syntax match jiraDetailsA ".*  :"he=e-1 contains=jiraDetailsB,jiraDetailsC,jiraDetailsHighest,jiraDetailsHigh,jiraDetailsMedium,jiraDetailsLow,jiraDetailsLowest,jiraDetailsStatusTodo,jiraDetailsStatusInProgress,jiraDetailsStatusComplete,jiraDetailsStatusDone,jiraDetailsTypeBug,jiraDetailsTypeTask,jiraDetailsTypeStory,jiraDetailsTypeEpic nextgroup=jiraDetailsB
syntax match jiraDetailsB ":" contained nextgroup=jiraDetailsC
syntax match jiraDetailsC ":  .*"hs=s+1 contained nextgroup=jiraDetailsHigh
syntax match jiraDetailsHigh ":  High"hs=s+1 contained nextgroup=jiraDetailsHighest
syntax match jiraDetailsHighest ":  Highest"hs=s+1 contained nextgroup=jiraDetailsLow
syntax match jiraDetailsLow ":  Low"hs=s+1 contained nextgroup=jiraDetailsLowest
syntax match jiraDetailsLowest ":  Lowest"hs=s+1 contained nextgroup=jiraDetailsMedium
syntax match jiraDetailsMedium ":  Medium"hs=s+1 contained nextgroup=jiraDetailsStatusComplete
syntax match jiraDetailsStatusComplete ":  Complete"hs=s+3 contained nextgroup=jiraDetailsStatusDone
syntax match jiraDetailsStatusDone ":  Done"hs=s+3 contained nextgroup=jiraDetailsStatusInProgress
syntax match jiraDetailsStatusInProgress ":  In Progress"hs=s+3 contained nextgroup=jiraDetailsStatusTodo
syntax match jiraDetailsStatusTodo ":  To Do"hs=s+3 contained nextgroup=jiraDetailsTypeBug
syntax match jiraDetailsTypeBug ":  Bug"hs=s+3 contained nextgroup=jiraDetailsTypeEpic
syntax match jiraDetailsTypeEpic ":  Epic"hs=s+3 contained nextgroup=jiraDetailsTypeStory
syntax match jiraDetailsTypeStory ":  Story"hs=s+3 contained nextgroup=jiraDetailsTypeTask
syntax match jiraDetailsTypeTask ":  Task"hs=s+3 contained
syntax match jiraItalic "_.*_"
syntax match jiraLink "\[.*|.*\]"
syntax match jiraMonospaced "{{.*}}"
syntax match jiraPhoto "\!.*|.*\!"
syntax match jiraStory "\v.*" contained
syntax match jiraStrikethrough "-.*-"
syntax match jiraSubscript "\~.*\~"
syntax match jiraTheLine "----"
syntax match jiraTitle "\%1l.*:" nextgroup=jiraStory
syntax match jiraTitleComment /.*{{1/hs=s,he=e contains=jiraTitleFold nextgroup=jiraTitleFold
syntax match jiraTitleFold /{{.*/hs=s,he=e contained
syntax match jiraUnderline "+.*+"
syntax match jiraUsername "\[\~.*\]"
syntax region jiraCode start=/{code.*}/ end=/{code}/
syntax region jiraNoformat start=/{noformat.*}/ end=/{noformat}/

" Highlighting
highlight default link jiraIssuesStatus Statement
highlight default link jiraIssuesDescription Question
highlight default link jiraIssuesIssue Title
highlight default link jiraBullets Identifier
highlight default link jiraCitvtion Title
highlight default link jiraCode Question
highlight default link jiraCommentAuthor Identifier
highlight default link jiraCommentClose Statement
highlight default link jiraCommentDate Statement
highlight default link jiraDetailsA Identifier
highlight default link jiraDetailsB Question
highlight default link jiraDetailsC Question
highlight default link jiraMonospaced Question
highlight default link jiraNoformat Normal
highlight default link jiraPhoto Title
highlight default link jiraStory Identifier
highlight default link jiraSubscript Question
highlight default link jiraTheLine Title
highlight default link jiraTitle Title
highlight default link jiraTitleComment Title
highlight default link jiraTitleDescription Title
highlight default link jiraTitleFold Statement
highlight jiraBold cterm=bold gui=bold
highlight jiraDetailsHigh ctermfg=red guifg=red
highlight jiraDetailsHighest ctermfg=darkred guifg=darkred
highlight jiraDetailsLow ctermfg=darkgreen guifg=darkgreen
highlight jiraDetailsLowest ctermfg=green guifg=green
highlight jiraDetailsMedium ctermfg=darkyellow guifg=darkyellow
highlight jiraDetailsStatusComplete ctermbg=darkgreen ctermfg=white guibg=darkgreen guifg=white
highlight jiraDetailsStatusDone ctermbg=darkgreen ctermfg=white guibg=darkgreen guifg=white
highlight jiraDetailsStatusInProgress ctermbg=darkyellow ctermfg=black guibg=darkyellow guifg=black
highlight jiraDetailsStatusTodo ctermbg=darkgrey ctermfg=white guibg=darkgrey guifg=white
highlight jiraDetailsTypeBug ctermfg=red guifg=red
highlight jiraDetailsTypeEpic ctermfg=white ctermbg=53 guifg=white guibg=#5b005f
highlight jiraDetailsTypeStory ctermfg=lightgreen guifg=lightgreen
highlight jiraDetailsTypeTask ctermfg=darkblue guifg=darkblue
highlight jiraItalic cterm=italic gui=italic
highlight jiraLink cterm=underline gui=underline
highlight jiraStrikethrough cterm=strikethrough gui=strikethrough
highlight jiraUnderline cterm=underline gui=underline
highlight jiraUsername cterm=underline gui=underline

let b:current_syntax = 'jira'
