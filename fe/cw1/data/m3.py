from sympy import *


x,y,L1,L2 = symbols('x y L1 L2')
f2 = x/L1
f1 = 1-f2
g2 = y/L2
g1 = 1-g2

N = []
N.append(f2*g2)
N.append(f1*g2)
N.append(f1*g1)
N.append(f2*g1)

Kx = zeros(4,4)
for i in range(4):
    for j in range(4):
        Kx[i,j] = integrate(N[i].diff(x) * N[j].diff(x),
                           (x,0,L1),
                           (y,0,L2))

Ky = zeros(4,4)
for i in range(4):
    for j in range(4):
        Ky[i,j] = integrate(N[i].diff(y) * N[j].diff(y),
                           (x,0,L1),
                           (y,0,L2))
a = (L2/L1)/6
b = (L1/L2)/6
Kx = Kx / a
Ky = Ky / b


from mylib import *

fname = 'out3.tex'
f = open(fname,'w')

def g(x):
    return x.evalf(4)
d = {
    'rec.Kx':Kx,
    'rec.Ky':Ky,
     }

for k in d.keys():
    export_this(f,k,d[k])

f.close()
