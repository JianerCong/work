from typing import List, Optional

# Definition for singly-linked list.
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

    def __str__(self):
        s = str(self.val)
        if self.next:
            return s + ',' + str(self.next)
        return s

def l2L(l):
    # l.reverse()
    n = None
    while len(l) > 0:
        n = ListNode(l.pop(),next=n)  # contruct from bottom
    return n

class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode],
                         n: int) -> Optional[ListNode]:
        return 
