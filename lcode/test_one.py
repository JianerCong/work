from m import Solution
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['s','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P([-1,0,1,2,-1,4],
                               [{-1,0,1},{-1,-1,2}]
                               ),
                             P([0],[]),
                             P([],[])
                         ])
    if 'db2' in metafunc.fixturenames:
        metafunc.parametrize('db2',
                         [
                             P([-1,0,1,2,-1,4],
                               (1,{-1,0,1,2,4},{-1})
                               ),
                         ])

def test_threeSum(db):
    # order doesn't matter
    assert S.threeSum(db.s) == db.r

def test_make_sets(db2):
    assert S.make_sets(db2.s) == db2.r
