from sympy import *

C,Q,qn,A,T1 = symbols('C Q q_n A T1')
K = C * Matrix([[2,-1,0],
            [-1,2,-1],
            [0,-1,1]])

v1 = Q * Matrix([2,2,1])
v2 = A * Matrix([0,0,-qn])
v3 = Matrix([T1 * C,0,0])
v = v1 + v2 + v3

r = (K ** -1 ) * v
r.simplify()

# Find q0
q0 = (C*(T1 - r[0]) - Q)/A

k = symbols('k')
q0k = q0.subs(C,A * k / 2)
q0k.simplify()
# q0 = q0.subs()
