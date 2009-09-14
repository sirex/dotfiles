func! AddSig()
	set spelllang=lt,en
	set spell
	set tw=80
python << EOF

import os
import vim

p = os.popen('fortune linux linuxcookie perl debian science startrek wisdom -s')

for line in p:
    vim.current.buffer.append(line)

p.close()

EOF
endfunc

autocmd FileType mail call AddSig()

