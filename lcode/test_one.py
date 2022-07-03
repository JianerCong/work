from m import Solution
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['nums','target','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P([-1,2,1,-4],1,2),
                             P([0,0,0], 1,0),
                             P([-1,0,1,1,55],3,2),
                         ])

def test_threeSum(db):
    assert S.threeSumClosest(db.nums, db.target) == db.r

