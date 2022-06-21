from sympy import *
def get_K_core(he):
    # multiply this by 2EI/(he^3) to give the local stiffness K
    M = Matrix(
        [
            [6,-3*he,-6,3*he],
            [-3*he,2*he**2,3*he,he**2],
            [-6,3*he,6,3*he],
            [3*he,he**2,3*he,2*he**2]
        ]
    )
    return(M)

def get_M_core(he):
    # multiply this by rho*A*he/420 to get the local M
    # note that the one exam used is alternating sign
    a =  Matrix([
    [0,0,0,0],
    [22*he, 0,0,0],
    [54,13*he,0,0],
    [-13*he, -3*he**2, -22*he, 0]
       ])
    return diag(156,4*he**2,156,4*he**2) + a + a.T

def make_global1(M):
    M1 = Matrix.hstack(M,zeros(4,2))
    M1 = Matrix.vstack(M1, zeros(2,6))
    return M1

def make_global2(M):
    M2 = Matrix.hstack(zeros(4,2),M)
    M2 = Matrix.vstack(zeros(2,6),M2)
    return M2

# brute-force method of calculating global M
l,m,EI = symbols('l m EI')
m1 = m*l/420
M1 = get_M_core(l)
M1

m2 = m*(2*l)/420
M2 = get_M_core(2*l)
M2

M = m1 * make_global1(M1) + m2 * make_global2(M2)
coef_M = m*(l**3)/105
M / coef_M

# brute-force method of calculating global K
k1 = 2*EI/(l**3)
K1 = get_K_core(l)
K1

k2 = 2*EI/((2*l)**3)
K2 = get_K_core(2*l)
K2

K = make_global1(m1 * M1) + make_global2(m2*M2)
coef_K = EI/ l
K = K / coef_K
K


# hand calc --------------------------------------------------
from sympy import *
a = symbols('a')
# the characteristic polynomial
e = (6-9*a)*(2-8*a) - (1+6*a)**2
expand(e)

a_out = Matrix(solve(e,a))
a_out.evalf(2)

om = Matrix(
    [105* sqrt(i) for i in a_out]
)
om.evalf(3)
