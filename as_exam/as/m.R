## MNA Q1
h=475

h1=475-35 #the depth from concrete top to tension steel
de=h1

b=250

Es=200e3
Ec=35e3

si_s=500
fc=50

Ast=(pi * 20^2)/4 * 3

eps=0.0025

source('mna.R')
ApEp=4*250*160e3 #b x FRP_thickness x Ep
AscEs=0
ccs=0

k=mna_get_ks(b,Ec,fc,Ast,si_s,ApEp,AscEs,h,ccs)

# no FRP
# epct=0.0035
# o_noFRP=mna_get_dc_from_steel_yield2(de,Es,si_s,fc,Ast,b)
# ka1=eps/(de-o_noFRP$dc)
# o_yesFRP<-mna_get_dc_from_steel_yield2(h1,Es,si_s,fc,Ast,b,ApEp,AscEs,h,ccs)
# ka2=eps/(de-o_yesFRP$dc)

epcm=0.0035
o1 <- mna_get_dc_from_conc_crash2(b,Ec,fc,Ast,si_s,epcm,ApEp=0,AscEs=0,ccs=0,h=0)
ka1=eps/(de-o1$dc)
o2 <- mna_get_dc_from_conc_crash2(b,Ec,fc,Ast,si_s,epcm,ApEp,AscEs,ccs,h)
ka2=eps/(de-o2$dc)

