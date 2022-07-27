from m import Solution, ListNode
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['n','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P([[1,4,5],[1,3,4],[2,6]],
                               '1,1,2,3,4,4,5,6'),
                             P([],'None'),
                             P([[]],'None'),
                         ])

def test_f(db):
    assert db.r == str(S.mergeKLists([ListNode.l2L(l) for l in db.n]))

