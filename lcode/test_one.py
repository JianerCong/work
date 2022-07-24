from m import Solution
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['n','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P(3,["((()))","(()())","(())()","()(())","()()()"]),
                             P(1,["()"]),
                         ])

def test_f(db):
    assert db.r == S.generateParenthesis(db.n)

