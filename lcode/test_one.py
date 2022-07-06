from m import Solution
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['x','t','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P([1,0,-1,0,-2,2],0,[[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]),
                             P([2,2,2,2,2], 8, [[2,2,2,2]])
                         ])

def test_f(db):
    assert S.fourSum(db.x, db.t) == db.r

