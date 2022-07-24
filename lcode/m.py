from typing import List, Optional

class Solution:

    def generateParenthesis(self, n: int) -> List[str]:
        stack = ''
        res = []

        def b(openN, closedN):
            if openN == closedN == n:  # chained comparison in Py
                res.append(stack)
                return

            if openN < n:
                stack+="("
                b(openN+1, closedN)
                stack = stack[:-1]  # pop

            if closedN < openN:
                stack+=")"
                b(openN, closedN+1)
                stack = stack[:-1]
        b(0,0)
        return res
    # def generateParenthesis(self, n: int) -> List[str]:
    #     stack = []
    #     res = []

    #     def b(openN, closedN):
    #         if openN == closedN == n:  # chained comparison in Py
    #             res.append("".join(stack))
    #             return

    #         if openN < n:
    #             stack.append("(")
    #             b(openN+1, closedN)
    #             stack.pop()

    #         if closedN < openN:
    #             stack.append(")")
    #             b(openN, closedN+1)
    #             stack.pop()
    #     b(0,0)
    #     return res
