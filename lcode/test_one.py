from m import Solution, ListNode, l2L
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['x','t','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P([1,0,-1,0,-2,2],0,[[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]),
                             P([2,2,2,2,2], 8, [[2,2,2,2]]),
                             P([0],0,[])
                         ])

    Q = namedtuple('Q', ['l','s'])
    if 'db2' in metafunc.fixturenames:
        metafunc.parametrize('db2',
                         [
                             Q([1,2,3],'1,2,3')
                         ])
def test_l2L(db2):
    h = l2L(db2.l)
    assert db2.s == str(h)

# def test_f(db):
#     assert S.fourSum(db.x, db.t) == db.r

