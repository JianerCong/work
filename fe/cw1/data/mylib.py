from sympy import *
# Export data
def set_this(k,v):
    r = '\\MySet{%s}{%s}' % (k,v)
    return r

def write_this(f,k,v):
    f.write('\n' + set_this(k,v))

def trim_0s(M):
    return M.replace(' 0 ','',-1).replace(' 0','',-1).replace('0 ','',-1)

def export_this(f,k,M,trim_0=True):
    print('Exporting %s' % k)
    v = latex(M)
    if trim_0:
        # print('Triming')
        v = trim_0s(v)
    # print('Writing')
    write_this(f,k,v)


def humanize_m(M):
    shp = M.shape
    print('Humanizing for shape of ', shp)
    for i in range(shp[0]):     # in range(3) ⇒ 0,1,2
        for j in range(shp[1]):
            if not M[i,j].equals(0):
                print('Changing for (%d,%d)' % (i,j))
                M[i,j]=M[i,j].evalf(4)
            else:
                print('Skip for (%d,%d)' % (i,j))
    return M
