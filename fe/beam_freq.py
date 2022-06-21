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
    a =  Matrix([
    [0,0,0,0],
    [-22*he, 0,0,0],
    [54,-13*he,0,0],
    [13*he, -3*he**2, 22*he, 0]
       ])
    return diag(156,4*he**2,156,4*he**2) + a + a.T

EI,L,rho,A,om,a= symbols('EI L rho A omega a')

k = 2*EI/(L**3) 
K = get_K_core(L)
# k*K is the stiffness K
K

m = rho*A*L/420
M = get_M_core(L)
M

#m * M is the mass M
#for now, let a = om^2 * m
bigA = K - a/840 *M

#get the lower two submatrix
smallA = bigA[2:,2:]
smallA

# the characteristic func, should make this 0
e = det(smallA)
collect(e,a) # polygomial for a

r = solve(e,a)
a_out = Matrix(r)
a_out.evalf() # these are the values for

om = Matrix([sqrt(i) for i in a_out])
# the final natrual frequencies
om = om.evalf(4) * sqrt(EI/(rho * A * L**4))
om
