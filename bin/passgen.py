#!/usr/bin/env python

"""

Installing
==========

From command line::

    sudo apt-get install xsel

Configuring
===========

1. Generate your custom alphabet::

       passgen.py -a

   and set ALPHABET to generated alphabet.

2. Think up your master key, remember it and do not share with anyone.

3. Generate password for 'test'::

       passgen.py test -o

   and set TEST to first letter of generated password for 'test'.

Usage
=====

All your passwords can be generated using an domain name, example::

    passgen.py gmail.com

after entering this command, you will be asked to enter your master key, and if
master key is correct, password will be stored for 60 seconds to clipboard.

"""

import argparse
import hashlib
import random
import string
import subprocess
import sys
import time

from getpass import getpass


PRINTABLE = (string.digits + string.lowercase + string.uppercase +
             '#$%&*+,-.:;<=>?@^_~')

# Always use your custom alphabet. To generate alphabet, you can use
# genalphabet() function.
ALPHABET = ('rJiK+tB>wz;q-Mg2by*UkRY4,0Qo1:hECAcI#FHZ.PW5%seV~p@dSv=?76_8G$Lf^'
            '3xD&uaOlN9TjXn<m')

# This is second letter of password generated for 'test' domain. This letter is
# used to check if entered password is correct.
TEST = 'J'


def genalphabet(alphabet=PRINTABLE):
    alphabet = list(alphabet)
    random.shuffle(alphabet)
    return ''.join(alphabet)


def custombase(number, alphabet=ALPHABET):
    if number == 0:
        return alphabet[0]
    base = ''
    while number != 0:
        number, i = divmod(number, len(alphabet))
        base = alphabet[i] + base
    return base


def passgen(domain, master_key, length=12):
    line = ' '.join([domain, master_key])
    md5 = hashlib.md5(line)
    password = custombase(int(md5.hexdigest(), 16)) + ALPHABET
    return password[:length]


def paste(text):
    p = subprocess.Popen(['xsel', '-pi'], stdin=subprocess.PIPE)
    p.communicate(input=text)
    p = subprocess.Popen(['xsel', '-bi'], stdin=subprocess.PIPE)
    p.communicate(input=text)


def get_master_key(times=3):
    while times > 0:
        key = getpass()
        test = passgen('test', key)
        if test[0] == TEST:
            return key
        else:
            times -= 1



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--alphabet', action='store_true',
                        dest='alphabet', help='generates rendomized alphabet')

    if len(sys.argv) == 2 and sys.argv[1] in ('-a', '--alphabet'):
        print(genalphabet())
        return

    parser.add_argument('-d', '--delay', default=60, dest='delay',
                        help='number of seconds to keep password copied')
    parser.add_argument('-o', '--output', action='store_true', dest='output',
                        help='output generated password to the screen')
    parser.add_argument('domain')
    args = parser.parse_args()

    master_key = get_master_key()
    if master_key is None:
        print('Wrong master key.')
        sys.exit(1)

    password = passgen(args.domain, master_key)

    if args.output:
        print(password)

    else:
        paste(password)
        print('Your password is put to clipboard for %d seconds.' % args.delay)
        try:
            time.sleep(args.delay)
        finally:
            paste('')


if __name__ == '__main__':
    main()
