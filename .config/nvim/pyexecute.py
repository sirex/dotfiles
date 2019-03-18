# https://stackoverflow.com/a/47130538/475477
import ast
import sys

try:
    import pprintpp as pprint
except ImportError:
    import pprint

NA = object()


def execute(filename, globals=None, locals=None):
    with open(filename) as f:
        script = f.read()

    stmts = list(ast.iter_child_nodes(ast.parse(script)))
    expr = None

    if isinstance(stmts[-1], ast.Expr):
        stmts, expr = stmts[:-1], stmts[-1]

    if stmts:
        exec(compile(ast.Module(body=stmts), filename=filename, mode="exec"), globals, locals)

    if expr:
        value = eval(compile(ast.Expression(body=expr.value), filename=filename, mode="eval"), globals, locals)

        if not hasattr(expr.value, 'func') or not hasattr(expr.value.func, 'id') or expr.value.func.id != 'print':
            return value

    return NA


value = execute(sys.argv[1])

if value is not NA:
    pprint.pprint(value)
