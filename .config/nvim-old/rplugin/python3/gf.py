import os
import pathlib
import re

import pynvim


find_left_re = re.compile(r'[\w\d./_-]+$')
find_right_re = re.compile(r'^[\w\d./_-]+')
find_line_re = re.compile(r'^:(\d+)|^", line (\d+)')


def _generic_finder(line, column, cwd=None):
    # Trye generice file name detection
    start = column
    match = find_left_re.search(line[:column])
    if match:
        start = match.start()

    end = column
    match = find_right_re.search(line[column:])
    if match:
        end = match.end()

    if start == end:
        return None, None

    path = line[start:column + end]

    lineno = None
    match = find_line_re.search(line[column + end:])
    if match:
        lineno = next((x for x in match.groups() if x), None)
        if lineno:
            lineno = int(lineno)

    return path, lineno


find_path_left_re = re.compile(r'[\w\d./_-]+$')
find_path_right_re = re.compile(r'^[\w\d./_-]+')


def _python_path_finder(line, column, cwd=None):
    start = column
    match = find_path_left_re.search(line[:column])
    if match:
        start = match.start()

    end = column
    match = find_path_right_re.search(line[column:])
    if match:
        end = match.end()

    if start == end:
        return None, None

    pypath = line[start:column + end]

    if {'/', '-'} & set(pypath):
        return None, None

    pyfiles = [
        pypath.replace('.', '/') + '.py',
        pypath.replace('.', '/') + '/__init__.py',
    ]

    places = [
        '.',
        './src',
        './env/lib/python*/site-packages',
    ]

    for place in places:
        paths = cwd.glob(place) if '*' in place else [(cwd / place)]
        for path in paths:
            for pyfile in pyfiles:
                if (path / pyfile).exists():
                    return str(path / pyfile), None

    return None, None


find_python_exception_re = re.compile(r'[Ff]ile "([^"]+)", line (\d+)')


def _python_exception_finder(line, column, cwd=None):
    match = find_python_exception_re.search(line)
    if match:
        path, lineno = match.groups()
        lineno = int(lineno)
        return path, lineno
    return None, None


finders = (
    _python_exception_finder,
    _python_path_finder,
    _generic_finder,
)


def find_file(line, column, *, cwd=None):
    """Find file path in a given line.

    >>> find_file('  File "/some/file.py", line 42, in func', 10)
    ('/some/file.py', 42)

    >>> find_file('  File "/some/file.py", line 42, in func', 0)
    ('/some/file.py', 42)

    >>> find_file('  File "/some/file.py", line 42, in func', 40)
    ('/some/file.py', 42)

    >>> find_file('some/file_name.py:42:', 1)
    ('some/file_name.py', 42)

    >>> import tempfile, pathlib
    >>> tmpdir = tempfile.mkdtemp(prefix='gftest')
    >>> tmpdir = pathlib.Path(tmpdir)
    >>> (tmpdir / 'module').mkdir()
    >>> (tmpdir / 'module/a.py').touch()
    >>> find_file('module.a', 3, cwd=tmpdir)  #doctest: +ELLIPSIS
    ('.../module/a.py', None)

    >>> find_file('module/a.py:42:', 1)
    ('module/a.py', 42)

    >>> import shutil
    >>> shutil.rmtree(str(tmpdir), ignore_errors=True)

    """
    cwd = cwd or pathlib.Path()
    path = None
    for finder in finders:
        path, lineno = finder(line, column, cwd)
        if path is not None:
            break

    if path is None:
        return None, None
    else:
        return path, lineno


@pynvim.plugin
class GoToFile:

    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command('GoToFile', nargs='*', range='')
    def goto_file_command(self, args, range):
        line = self.nvim.current.line
        line = ''.join([c for c in line if c.isprintable()])
        column = self.nvim.funcs.col('.')
        path, lineno = find_file(line, column)
        fpath = os.path.join(self.nvim.funcs.getcwd(), path)
        with open('/tmp/gf.log', 'a') as f:
            f.write(repr(path) + ' full path: ' + fpath + ' exists: ' + str(os.path.exists(path)) + '\n')
        if path and os.path.exists(fpath):
            self.nvim.command('wincmd p')
            self.nvim.command('edit %s' % path)
            if lineno:
                self.nvim.command('normal %sG' % lineno)
