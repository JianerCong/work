from sympy import *

al,l,c = symbols('alpha l c')
K0 = Matrix([[1,-1,0,0,0],
            [-1,4,-3,0,0],
            [0,-3,8,-5,0],
            [0,0,-5,12,-7],
            [0,0,0,-7,7]])
L0 = diag(2,4,4,4,2)
l1 = diag(c,c,c,c).col_insert(4,zeros(4,1)).row_insert(0,zeros(1,5))
L1 = L0 + l1 + l1.T              # construct the L
L2 = L1 * al * l / 6              # add the factor at front
L = L2.subs([(c,1),(l,1)])        # plug in l = c = 1

K = K0 / 2
# Plugin
M = L + K
M2=M[:,0:-1]                    # M without right column
Me=M[:,-1]                      # last col of M
# M = [M2 M2]
M_upper = M2[0:-1,:]
last_lhs = M2[-1,-1]
last_rhs = Me[-1]

v_top = Matrix([1,2,2,2])
v2_top = Matrix(Me[0:-1])

print('Start establishing system')
Ti,T1,T2,T3,T4,T5= symbols('T_{\infty},T1,T2,T3,T4 T5')
vals=[(al,0.4168),(Ti,75),(T5,250)]
print('Substituting for M_upper')
M_upper_n = M_upper.subs(vals)
print('Calculating rhs_upper')
rhs_upper = al * Ti / 2 * v_top - v2_top * T5
print('Substituting for rhs_upper_n')
rhs_upper_n = rhs_upper.subs(vals)
print('Making system')
sys_upper = M_upper_n.col_insert(4,-rhs_upper_n)
print('Solving System')
r = linsolve(sys_upper,(T1,T2,T3,T4))
print('Getting T1_4')
T1_4 = []
for i in r.args[0]:
    print('\tGot ', i)
    T1_4.append(i)
T1_4 = Matrix(T1_4)


# Don't known why it's negative, so I'm gonna revert T1_4: 🐸🐸
T1_4 = - T1_4

# Find s
print('Finding s')
T4_n = T1_4[-1]
last_lhs_n = last_lhs.subs(vals)
last_rhs_n = last_rhs.subs(vals)
alT2_n = (al * Ti / 2).subs(vals)
print('Calculating s')
s = last_lhs_n * T4_n + last_rhs_n * T5 - alT2_n
print('Substituting for s')
s = s.subs(vals)


# Export data
from mylib import *

fname = 'out.tex'
f = open(fname,'w')

T1_4 = humanize_m(T1_4)
M_upper_n = humanize_m(M_upper_n)
rhs_upper_n = humanize_m(rhs_upper_n)
def g(x):
    return x.evalf(4)

d = {'M2':M2,
     'Me':Me,
     'M.upper':M_upper,
     'last.lhs':last_lhs,
     'last.rhs':last_rhs,
     'v.top':v_top,
     'v2.top':v2_top,
     'M.upper.n':M_upper_n,
     'rhs.upper':rhs_upper,
     'rhs.upper.n':rhs_upper_n,
     'T1.T4':T1_4,
     's':g(s),
     'last.lhs.n':g(last_lhs_n),
     'last.rhs.n':g(last_rhs_n),
     'T4.n':g(T4_n),
     'T1.n':g(T1_4[0]),
     'alT2.n':alT2_n
     }

for k in d.keys():
    export_this(f,k,d[k])

f.close()
