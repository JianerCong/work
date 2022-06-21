library(rlang)
source('tcc.R')

tcbm=env(
  Et=15e3,
  Ec=30e3,
  wc=600,
  hc=90,
  wj=100,
  dj=280
)

eptb=-4.3e-3
epct=1.2e-3

## (a) is the slab partially or fully compression?
Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")

# dc=hc
# F1=tcc_get_F1(epct,Ec,wc,dc)
# ka=epct/dc
# eptm=eptb + ka * dj/2
# F2=eptm*Et*wj*dj

## (b)
# a=0.5*hc
# b=Ec*wc*hc
# c=0.5*dj
# d=Et*wj*dj
# 
# ka=(epct*b + eptb*d)/(a*b-c*d)
# 
# #(c)
# eptt=eptb + ka*dj
# epcb=epct-ka*hc
# eps=eptt-epcb
# 
# #(d)
# eptm=eptb + ka * dj/2
# L=600
# tao=eptm * Et * dj *2 /L

# (e)
dc=hc
ka=epct/dc
eps=tcc_get_eps(epct,dc,tcbm)
eptb=epct -ka*(dj + hc) + eps
sitb=eptb*Et
  


# dc=tcc_test_partial_compre_eptb_ka(eptb,ka,tcbm)

## (b) get eps
# eps=eptb + ka * (tcbm$dj - dc + tcbm$hc)

## (c) compare section moment
# o=tcc_get_sec_moment(epct=ka*dc,dc=dc,tcbm=tcbm)
#   