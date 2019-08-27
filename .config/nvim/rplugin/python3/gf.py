import os
import re

import pynvim


find_left_re = re.compile(r'[\w\d./_-]+$')
find_right_re = re.compile(r'^[\w\d./_-]+')
find_line_re = re.compile(r'^:(\d+)|^", line (\d+)')


def _generic_finder(line, column):
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


find_python_exception_re = re.compile(r'[Ff]ile "([^"]+)", line (\d+)')


def _python_exception_finder(line, column):
    match = find_python_exception_re.search(line)
    if match:
        path, lineno = match.groups()
        lineno = int(lineno)
        return path, lineno


finders = (
    _python_exception_finder,
    _generic_finder,
)


def find_file(line, column):
    """Find file path in a given line.

    >>> find_file('  File "/some/file.py", line 42, in func', 10)
    ('/some/file.py', 42)

    >>> find_file('  File "/some/file.py", line 42, in func', 0)
    ('/some/file.py', 42)

    >>> find_file('  File "/some/file.py", line 42, in func', 40)
    ('/some/file.py', 42)

    """
    path = None
    for finder in finders:
        path, lineno = finder(line, column)
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
        column = self.nvim.funcs.col('.')
        path, lineno = find_file(line, column)
        if path and os.path.exists(path):
            self.nvim.command('wincmd p')
            self.nvim.command('edit %s' % path)
            if lineno:
                self.nvim.command('normal %sG' % lineno)
