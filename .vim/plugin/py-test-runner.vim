" File: py-test-runner.vim
" Author: Mantas Zimnickas <sirexas@gmail.com>
" Version: 0.1
" Created: 2011-01-25
" Last Modified: 2011-01-25
"

python << EOF
import os
import re
import vim

re_class_name = re.compile(r'class (\w+)')
re_method_name = re.compile(r'\s*def (test\w+)')


def get_django_appname(filename):
    """
    >>> get_django_appname('~/devel/django-plugins/plugins/tests.py')
    'payment'
    >>> get_django_appname('~/devel/django-plugins/setup.py')
    """
    filename = os.path.expanduser(filename)
    filename = os.path.abspath(filename)
    dirs = os.path.dirname(filename).split(os.path.sep)
    while dirs:
        path = os.path.sep.join(dirs)
        if os.path.exists(os.path.join(path, 'models.py')):
            return os.path.basename(path)
        dirs.pop()
    return None


def get_test_name(lines):
    """
    >>> get_test_case_class(['class MyClass:', 'pass'])
    'MyClass'
    >>> get_test_case_class(['class MyClass():', 'pass'])
    'MyClass'
    >>> get_test_case_class(['', ''])
    >>> get_test_case_class(['class MyClass():', '', 'def test_foo():', 'pass'])
    'MyClass.test_foo'
    >>> get_test_case_class(['class MyClass():', '', '    def test_foo():', 'pass'])
    'MyClass.test_foo'
    >>> get_test_case_class(['class MyClass():', '',
    ...                      '    def test_foo():', 'pass',
    ...                      '    def test_bar():', 'pass'])
    'MyClass.test_bar'
    """
    methodname = None
    for line in reversed(lines):
        if line.startswith('class '):
            m = re_class_name.match(line)
            if m:
                if methodname:
                    return "{0}.{1}".format(m.group(1), methodname)
                else:
                    return m.group(1)
        elif not methodname and 'def test' in line:
            m = re_method_name.match(line)
            if m:
                methodname = m.group(1)
    return None


def RunDjangoTestUnderCursor():
    (row, col) = vim.current.window.cursor
    filename = vim.eval("bufname('%')")
    appname = get_django_appname(filename)
    if appname:
        testname = get_test_name(vim.current.buffer[0:row])
        if testname:
            testname = appname + '.' + testname
        else:
            testname = appname
        makeprg = vim.eval('&makeprg')
        vim.command(r'set makeprg=bin/django\ test\ '
                            r'--verbosity=0\ --noinput\ {0}'.format(testname))
        vim.command(r'silent! make')
        vim.command(r'set makeprg={0}'.format(makeprg.replace(' ', r'\ ')))
        vim.command(r'copen')
        vim.command(r'wincmd w')
        print(r'tested: {0}'.format(testname))
    else:
        vim.command(r'silent! make')
        vim.command(r'copen')
        vim.command(r'wincmd w')
EOF
map <F8> :python RunDjangoTestUnderCursor()<CR>
