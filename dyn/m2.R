## 2019 Q4 (d)
library(tibble)
library(purrr)

v. <- function(...) cat(gettextf(...),'\n')

dt=0.02 #s
m=60e3 #kg
c=0

u0=0
u0d=0

T=0.2 #the total period

## the restoring force
k=1e3/15e-3
period=2*pi*sqrt(m/k)


fs <- function(u){
  min(u*k,1e3)
}
## the applied force
p <- function(t){
  max(0,25e3*(1-t/0.1))
}

## --------------------------------------------------
n=T/dt #number of interval

tf=tibble(
  t=seq(0,T,dt),
  ps=map_dbl(t,p)
)


u0dd=(tf$ps[1]-c*u0-fs(u0))/m
u_1=u0 - dt* u0d + (dt)^2/2 * u0dd

A= m/(dt^2);B=c/(2*dt)
kh=A+B
a=A-B

v.('After initial calculation:\n\tA=m/(dt^2)=%g',A)

## the u
u=rep(0,n+2)
pih=rep(0,n+1)
u[1]=u_1
u[2]=u0
for (i in 1:n){
  pih[i]=tf$ps[i] - a*u[i] + 2*A*u[i+1] - fs(u[i+1])
  u[i+2]=pih[i]/kh
}

tf$pih=pih
tf$u=u[2:(n+2)]

