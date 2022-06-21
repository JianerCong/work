from sympy import *
he,EI,L= symbols('h_e EI L')
def get_beam_M(he,EI):
    # the local stiffness K
    M = 2*EI/(he**3) * Matrix(
        [
            [6,-3*he,-6,3*he],
            [-3*he,2*he**2,3*he,he**2],
            [-6,3*he,6,3*he],
            [3*he,he**2,3*he,2*he]
        ]
    )
    return(M)

M = get_beam_M(he=L,EI=EI)/(2*EI/L**3)
M

# global matrix for elem 1 (multiply it with 2EI/L^3)
M1 = Matrix.hstack(M,zeros(4,2))
M1 = Matrix.vstack(M1, zeros(2,6))
M1

# global matrix for elem 2 (multiply it with 2EI/L^3)
M2 = Matrix.hstack(zeros(4,2),M)
M2 = Matrix.vstack(zeros(2,6),M2)
M2

# global stiffness matrix (multiply it with 2EI/L^3)
M1 + M2

from sympy import *
# he,xe,x= symbols('h_e x_e x')
L, x, q0= symbols('L x q0')
def get_N(xe,he):
    b=x-xe
    a=b/he
    N = Matrix([
    1 - 3*a**2 + 2*a**3,
    b*(1-a)**2,
    3*a**2 - 2*a**3,
    b * (a**2 - a)])
    return N

def get_local_F(xe,he,q):
    N1 = get_N(xe,he)
    return integrate(N1*q, (x,xe, xe+he))

# applied q(x)
q = q0 * (L-x)/L
q

F1 = get_local_F(xe=0,he=L/2,q=q)  # local F for elem 1
F2 = get_local_F(xe=L/2,he=L/2,q=q)  # for elem2

# global F for elem 1 and 2
F1g = Matrix.vstack(F1,zeros(2,1))
F2g = Matrix.vstack(zeros(2,1),F2)
# Matrix.hstack(F1g,F2g)

# the global F
F = F1g + F2g
F

