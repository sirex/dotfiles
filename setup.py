#!/usr/bin/env python3

import os
import sys

from os import makedirs
from os import symlink
from subprocess import call


def sh(cfg, cmd):
    cmd = cmd.format(**cfg)
    print('{cmd}'.format(cmd=cmd))
    call(cmd, shell=True)


def ifmissing(cfg, target, *args):
    args = list(args)
    if callable(target):
        if target.__name__ not in cfg['executed']:
            print('{fn}:'.format(fn=target.__name__))
            target(cfg)
            cfg['executed'].append(target.__name__)
    else:
        target = target.format(**cfg)
        if not os.path.exists(target):
            fn = args.pop(0)
            args = [
                arg.format(**dict(cfg, target=target))
                for arg in args if isinstance(arg, str)
            ]
            if fn in (sh,):
                fn(cfg, *args)
            else:
                print('{fn} {args}'.format(fn=fn.__name__, args=' '.join(args)))
                fn(*args)


def bin(cfg):
    ifmissing(cfg, '{home}/bin/', makedirs, '{target}')


def vimpire(cfg):
    ifmissing(cfg, '{home}/.vim/vimpire.py', sh,
        'wget -q http://bitbucket.org/sirex/vimpire/raw/tip/vimpire.py '
        '-O {target}'
    )
    ifmissing(cfg, '{home}/.vim/autoload', makedirs, '{target}')
    ifmissing(cfg, '{home}/.vim/autoload/pathogen.vim', sh,
        "wget "
        "-q 'http://www.vim.org/scripts/download_script.php?src_id=16224' "
        "-O {target}"
    )
    sh(cfg, 'python3 {home}/.vim/vimpire.py')


def vpaste(cfg):
    ifmissing(cfg, '{home}/bin/vpaste', symlink, '{pwd}/bin/vpaste', '{target}')


def zsh(cfg):
    ifmissing(cfg, '{home}/.oh-my-zsh/', sh,
        'git clone https://github.com/robbyrussell/oh-my-zsh.git {target}'
    )
    ifmissing(cfg, '{home}/.oh-my-zsh/themes/sirex.zsh-theme',
        symlink, '{pwd}/.oh-my-zsh/themes/sirex.zsh-theme', '{target}'
    )
    ifmissing(cfg, '{home}/.zshrc', symlink, '{pwd}/.zshrc', '{target}')



def hg(cfg):
    ifmissing(cfg, '{home}/.hgrc', symlink, '{pwd}/.hgrc', '{target}')
    ifmissing(cfg, bin)
    ifmissing(cfg, '{home}/bin/hgeditor',
        symlink, '{pwd}/bin/hgeditor', '{target}'
    )


def git(cfg):
    ifmissing(cfg, '{home}/.gitconfig', symlink, '{pwd}/.gitconfig', '{target}')


def vim(cfg):
    ifmissing(cfg, '{home}/.vim/bundle/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.vimrc', symlink, '{pwd}/.vimrc', '{target}')
    ifmissing(cfg, '{home}/.vim/var/swap/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.vim/var/undo/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.vim/var/backup/', makedirs, '{target}')
    ifmissing(cfg, bin)
    ifmissing(cfg, vpaste)
    ifmissing(cfg, vimpire)
    ifmissing(cfg, '{home}/.vim/snippets/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.vim/snippets/htmldjango.snippets',
        symlink, '{pwd}/.vim/snippets/htmldjango.snippets', '{target}'
    )
    ifmissing(cfg, '{home}/.vim/snippets/python.snippets',
        symlink, '{pwd}/.vim/snippets/python.snippets', '{target}'
    )


def terminator(cfg):
    ifmissing(cfg, '{home}/.config/terminator/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.config/terminator/config',
        symlink, '{pwd}/.config/terminator/config', '{target}'
    )


def gnome_terminal(cfg):
    ifmissing(cfg, '{home}/.gconf/apps/gnome-terminal/profiles/Default/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.gconf/apps/gnome-terminal/profiles/Default/%gconf.xml',
        symlink, '{pwd}/.gconf/apps/gnome-terminal/profiles/Default/%gconf.xml', '{target}'
    )


def buildout(cfg):
    ifmissing(cfg, '{home}/.buildout/downloads/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.buildout/eggs/', makedirs, '{target}')
    ifmissing(cfg, '{home}/.buildout/default.cfg',
        symlink, '{pwd}/.buildout/default.cfg', '{target}'
    )


def default(cfg):
    ifmissing(cfg, zsh)
    ifmissing(cfg, hg)
    ifmissing(cfg, git)
    ifmissing(cfg, vim)
    ifmissing(cfg, terminator)
    ifmissing(cfg, gnome_terminal)
    ifmissing(cfg, buildout)


def main(target):
    target = 'default' if target is None else target
    target = globals()[target]
    target(dict(
        home=os.environ['HOME'],
        pwd=os.getcwd(),
        executed=[],
    ))


if __name__ == '__main__':
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main(None)
