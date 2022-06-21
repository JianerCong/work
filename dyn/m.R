source('dyn.R')
h=3
m=1600
E=210e9
I=264e-8

kc=12*E*I/(h^3)

fn=1.5
k=((2*pi*fn)^2)*m - 2*kc