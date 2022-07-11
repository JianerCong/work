from m import Solution
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['x','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P('()',True),
                             P('(){}[]',True),
                             P('(]',False),
                         ])

def test_f(db):
    assert S.isValid(db.x) == db.r

