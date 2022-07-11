from typing import List, Optional

class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        # m = {')':'(','}':'{',']':'['}
        m2 = '{}[]()'

        for c in s:
            index = m2.find(c)
            # if c in m:
            #     if stack and stack[-1] == m[c]:
            #         stack.pop()
            if index % 2 == 1:  # is closing paren
                if stack and stack[-1] == m2[index-1]:
                    stack.pop()
                else:
                    return False
            else:
                # it's open paren
                stack.append(c)

        return True if not stack else False
