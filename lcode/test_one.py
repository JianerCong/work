from m import Solution
from m import l2L
from collections import namedtuple
S = Solution()

def pytest_generate_tests(metafunc):
    P = namedtuple('P', ['l1','l2','r'])
    if 'db' in metafunc.fixturenames:
        metafunc.parametrize('db',
                         [
                             P([1,2,4],[1,3,4],'1,1,2,3,4,4'),
                             P([],[],'None'),
                             P([],[0],'0'),
                         ])

def test_f(db):
    assert str(S.mergeTwoLists(l2L(db.l1),l2L(db.l2))) == str(db.r)

