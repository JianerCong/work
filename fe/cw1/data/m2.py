from sympy import *

x,y=symbols('x y')
def rec_N_xy(L1,L2):
    f2 = x/L1
    f1 = 1-f2
    g2 = y/L2
    g1 = 1-g2

    N = []
    N.append(f1*g1)
    N.append(f2*g1)
    N.append(f2*g2)
    N.append(f1*g2)
    return N

def get_rec_K(L1,L2):
    # x,y,L1,L2 = symbols('x y L1 L2')
    N = rec_N_xy(L1,L2)

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
    return (Kx + Ky, Kx, Ky)

def get_tri_K(p):
    x1,y1 = p[0]
    x2,y2 = p[1]
    x3,y3 = p[2]
    A = Matrix([[1,x1,y1],
                [1,x2,y2],
                [1,x3,y3]])
    B = A ** -1
    B_r2 = B[1,:]
    B_r3 = B[2,:]
    Area = det(A)/2

    Kx = B_r2.T * B_r2 * Area
    Ky = B_r3.T * B_r3 * Area
    return (A,B,Kx + Ky, B_r2, B_r3, Area)

# K1,Kx1,Ky1 = get_rec_K(1,1)
# A,B,K,Br2,Br3,Area = get_tri_K([(0,0),(1,0),(1,1)])

def map_K(Kl,m):
    l = Kl.shape[0]
    K = zeros(9,9)
    for i in range(l):
        for j in range(l):
            # print('For i = %d, j = %d:' % (i,j))
            # print('For m[i] = %d, m[j] = %d:' % (m[i],m[j]))
            K[m[i]-1,m[j]-1] = Kl[i,j]
            # print('Now K is ',K)
    return K

# m = [2,5]
# Kl = Matrix([[1,2],[3,4]])
# K = map_K(Kl,m)
# print(
#     K[1,1].equals(Kl[0,0]),
#       K[4,4].equals(Kl[1,1])
#       )

def rec_elem(m,L1,L2,lower_left_point):
    Kl,Kx,Ky = get_rec_K(L1,L2)
    Kg = map_K(Kl,m)
    return {
        'Kx':Kx,'Ky':Ky,'K':Kl,
        'l1':L1,'l2':L2,'K.g':Kg,
        'lower_left_point':lower_left_point
    }

def tri_elem(m,p):
    A,B,Kl,B_r2,B_r3,Area = get_tri_K(p)
    Kg = map_K(Kl,m)
    return {
        'A'   :A,    'B':B,
        'B.r2':B_r2, 'B.r2.t':B_r2.T,
        'B.r3':B_r3, 'B.r3.t':B_r3.T,
        'Area':Area,
        'K'   :Kl,
        'K.g' :Kg
    }

# e = rec_elem([2,3,4,5],L1=1,L2=1,lower_left_point=(0,0))
# e2 = tri_elem([2,3,4],[(0,0),(1,0),(1,1)])

## Init Element
e={}
e['a']=rec_elem([1,2,4,3],L1=5,L2=2,lower_left_point=(0,0))
e['b']=rec_elem([3,4,8,7],L1=5,L2=4,lower_left_point=(0,2))

n={1:(0,0),
    2:(5,0),
    3:(0,2),
   4:(5,2),
   5:(7,2),
   6:(10,4),
    7:(0,6),
   8:(5,6),
   9:(10,6)}
l={'a':[1,2,4,3],
   'b':[3,4,8,7],
    'c':[2,5,4],
   'd':[4,5,8],
   'e':[5,6,8],
   'f':[6,9,8]}

for k in 'cdef':
    e[k] = tri_elem(m=l[k],
                    p=[n[i] for i in l[k]])

## Calculate Kg
Kg = zeros(9,9)
for k in e.keys():
    # print('Adding element %s to K.g' % k)
    Kg+=e[k]['K.g']

Kg_sm = Kg[2:4,:]
Kg_m1 = Kg_sm[:,2:4]
Kg_m2 = Kg_sm[:,6:]
Kg_m1_i = Kg_m1 ** -1
Kg_m3 = - Kg_m2 * ones(3,1)
phi34 = Kg_m1_i * Kg_m3         # phi34 (au0 is factored out)

phi_s = Matrix([0,0,phi34[0],phi34[1],0,0,1,1,1])
b_n = Kg * phi_s

# Plot --------------------------------------------------
phis = [0,0,phi34[0].evalf(),phi34[1].evalf(),0,0,1,1,1]

import numpy as np
import matplotlib.path as mp
import pandas as pd

def rec_Ns(el):
    L1 = el['l1']
    L2 = el['l2']
    return rec_N_xy(L1,L2)

def eval_N(Ns,xg,yg):
    vals = [(x,xg),(y,yg)]
    r =  np.sum([o.subs(vals) for o in Ns])
    print('For point %g,%g : phi %g' % (xg,yg,r))
    return r

def rec_phi(x,y,el):
    x0 = x - el['lower_left_point'][0]
    y0 = y - el['lower_left_point'][1]
    Ns = rec_Ns(el)
    print('Ns are ',Ns)
    print('Phis are ',el['phis'])
    Ns = [Ns[i] * el['phis'][i] for i in range(4)]
    return eval_N(Ns,x0,y0)

def tri_Ns(el):
    B = el['B']
    v = Matrix([1,x,y])
    N=[]
    for i in range(3):
        N.append(v.T * B[:,i]) # ith col
        N[i] = N[i][0]          # Take out the entry
    return N

def tri_phi(x,y,el):
    Ns = tri_Ns(el)
    Ns = [Ns[i] * el['phis'][i] for i in range(3)]
    return eval_N(Ns,x,y)

def get_points(L1,L2,N1,N2):
    xv,yv = np.meshgrid(
        np.linspace(0,L1,N1),
        np.linspace(0,L2,N2))
    def g(x):
        return x.flatten()[:,np.newaxis]
    return np.hstack((g(xv),g(yv)))

def get_phis(e,pts):
    l = pts.shape[0]
    print('Number of points : %d' % l)
    r=['-' for i in range(l)]
    val= -1 * np.ones(l)
    # for i in range(l):
    #     o = '-'
    #     p = pts[i,:]
    #     for k in e.keys():
    #         if e[k]['poly'].contains_points(p):
    #             print('%d is in element %s' % (i,k))
    #             o = k
    #             val[i]=e[k]['shpf'](x=p[0],y=p[1],el=e[k])
    #     r.append(o)
    for k in e.keys():
        b = e[k]['poly'].contains_points(pts)
        print('%d points is in element %s' % (b.sum(),k))
        for i in range(l):
            if b[i]:
                r[i] = k
                val[i]=e[k]['shpf'](x=pts[i,0],y=pts[i,1],el=e[k])
    return (r,val)

def make_df(pts,r,phi):
    return pd.DataFrame({
        'x':pts[:,0],
        'y':pts[:,1],
        'memb':pd.Categorical(r),
        'phi':phi
    })

for i in 'abcdef':
    e[i]['poly'] = mp.Path([n[j] for j in l[i]])
    e[i]['phis'] = [phis[j-1] for j in l[i]]

for i in 'ab':
    e[i]['shpf'] = rec_phi
for i in 'cdef':
    e[i]['shpf'] = tri_phi

N = 10
L1 = 10
L2= 6
pts = get_points(L1=L1,L2=L2,N1=L1*N,N2=L2*N)
r,phi = get_phis(e,pts)
df = make_df(pts, r ,phi)
df1 = df[df.memb!='-']

import seaborn as sns
# pl = sns.relplot(data=df1,x='x',y='y',hue='phi',style='memb')
df.to_csv("df.csv",index=False)


# from mylib import *

# fname = 'out2.tex'
# f = open(fname,'w')

# def g(x):
#     return x.evalf(4)

# for i in 'abcdef':
#     for k in e[i].keys():
#         export_this(f,k+'.'+i,e[i][k])

# d = {
#     'K.g.m1':Kg_m1,
#     'K.g.m2':Kg_m2,
#     'K.g.m1.inv':Kg_m1_i,
#     'K.g.m3':Kg_m3,
#     'K.g.sm':Kg_sm,
#     'K.g':Kg,
#     'phi3':g(phi34[0]),
#     'phi4':g(phi34[1]),
#     'b.n':humanize_m(b_n)
#      }

# for k in d.keys():
#     export_this(f,k,d[k])

# f.close()
