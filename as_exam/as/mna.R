source('lib.R')

mna_get_ks <- function(b,Ec,fc,Ast,si_s,ApEp=0,AscEs=0,h=0,ccs=0){
  
  ## k=mna_get_ks(b,Ec,fc,Ast,si_s,ApEp,AscEs,h,ccs)
  k1=b*Ec/2
  k2=Ec/(6*fc)
  k5=Ast*si_s
  
  b=c(ApEp,AscEs)
  k3=sum(b)
  k4=sum(b*c(h,ccs))
  k6=b[2]
  k7=b[1]
  
  c(k1,k2,k3,k4,k5,k6,k7)
}

mna_get_dc_from_steel_yield <- function(de,Es,si_s,fc,Ast,b){
  v.('Getting dc assuming the tension steel yielded')
  v.('        assuming no compression steel and FRP')
  eps=si_s/Es
  
  k=mna_get_ks(b,Ec,fc,Ast,si_s)
  
  v1=k[1]*eps*c(0,0,de,-(1+k[2]*eps))
  v2=k[5]*c(de^2,-2*de,1,0)
  v=v1-v2
  p <- polynom::polynomial(v)
  r <- solve(p) #the roots
  r_positive <- r[r>0]   #filter out negative roots
  dc <- min(r_positive)
  
  list(eps=eps,k1=k[1],k2=k[2],k5=k[5],dc=dc)
}


mna_get_dc_from_steel_yield2 <- function(h1,Es,si_s,fc,Ast,b,
                                         ApEp=0,AscEs=0,h=0,ccs=0){
  v.('Getting dc assuming the tension steel yielded')
  v.('        assuming no compression steel')
  v.('        assuming there"s FRP')
  k=mna_get_ks(b,Ec,fc,Ast,si_s,ApEp,AscEs,h,ccs)
  eps=si_s/Es # the yield stress,usually 0.0025
  
  a=-eps^2 *k[1]*k[2] - eps * k[1]
  b=eps*de*k[1] - eps * k[3] - k[5]
  c=eps*de*k[3] + eps * k[4] + 2*de*k[5]
  d=-de^2*k[5] - eps*de*k[4]
  
  v=(0:17) * 10 
  for (x in v){
    v.('f(%5.2g) = %10.2g',x,a*x^3 + b*x^2 + c*x +d)
  }
  
  p=polynom::polynomial(c(d,c,b,a))
  v.('polynomial is [%.2g,%.2g,%.2g,%.2g]',a,b,c,d)
  r=solve(p)
  r_positive <- r[r>0]   #filter out negative roots
  
  dc <- min(r_positive)
  
  list(eps=eps,epcm=eps*dc/(de-dc),
       k1=k[1],k2=k[2],k3=k[3],k5=k[5],dc=dc)
}

mna_get_M <- function(b,Ec,fc,Ast,si_s,epcm,dc,de){
  v.('Getting M')
  k=mna_get_ks(b,Ec,fc,Ast,si_s)
  D=k[1]*epcm*(8-9*k[2]*epcm)*dc^3
  E=12*k[5]*(de-dc)*dc
  
  ## b=c(k[7],k[6])
  ## v=c(dc-ccs,h-dc)
  ## v=v^2
  ## F=12*epcm*sum(b*v)
  
  M=(D+E)/(12*dc)
  M
}




mna_get_dc_from_conc_crash2 <- function(b,Ec,fc,Ast,si_s,epcm,
                                        ApEp=0,AscEs=0,ccs=0,h=0){
  # This is the more general version of above function. Use this if there're 
  # compression steel or FRP.
  
  ## o <- mna_get_dc_from_conc_crash2(b,Ec,fc,Ast,si_s,epcm,ApEp,AscEs,ccs,h)
  epcm=0.0035
  v.('Getting dc assuming the concrete crashed (i.e. epcm is known)')
  k=mna_get_ks(b,Ec,fc,Ast,si_s,ApEp,AscEs,h,ccs)
  A=k[1]*epcm*(1-k[2]*epcm)
  B=k[3]*epcm-k[5]
  C=k[4]*epcm
  p=polynom::polynomial(c(-C,B,A))
  r=solve(p)
  
  dc=min(r[r>0])

  list(dc=dc,
       ka=epcm/dc,
       epcm=epcm,
       A=A,B=B,C=C,roots=r,
       k1=k[1],
       k2=k[2],
       k3=k[3],
       k4=k[4],
       k5=k[5],
       k6=k[6],
       k7=k[7])
}

mna_get_dc_from_conc_crash <-mna_get_dc_from_conc_crash2
#   function(b,Ec,fc,Ast,si_s,epcm){
#   # Depricated, use the ver 2 instead.
#   v.('Getting dc assuming the concrete crashed (i.e. epcm is known)')
#   v.('        assuming no compression steel and FRP')
#   k=mna_get_ks(b,Ec,fc,Ast,si_s)
#   a=k[1]*epcm*(1-k[2]*epcm)
#   dc=k[5]/a
#   list(dc=dc,a=a,k1=k[1],k2=k[2],k5=k[5])
# }




  mna_get_M2 <- function(b,Ec,fc,Ast,si_s,epcm,dc,de,
                         ApEp=0,AscEs=0,h=0,ccs=0){
    # version 2 of mna_get_M
    v.('Getting M')
    k=mna_get_ks(b,Ec,fc,Ast,si_s,ApEp,AscEs,h,ccs)
    
    D=k[1]*epcm*(8-9*k[2]*epcm)*dc^3
    E=12*k[5]*(de-dc)*dc
    
    b=c(k[7],k[6])
    v=c(h-dc,dc-ccs)
    v=v^2
    F=12*epcm*sum(b*v)
    
    M=(D+E+F)/(12*dc)
    list(M=M,D=D,E=E,F=F)
  }
  
  mna_get_M <- mna_get_M2
  #   function(b,Ec,fc,Ast,si_s,epcm,dc,de){
  #   v.('Getting M')
  #   k=mna_get_ks(b,Ec,fc,Ast,si_s)
  #   D=k[1]*epcm*(8-9*k[2]*epcm)*dc^3
  #   E=12*k[5]*(de-dc)*dc
  #   
  #   ## b=c(k[7],k[6])
  #   ## v=c(dc-ccs,h-dc)
  #   ## v=v^2
  #   ## F=12*epcm*sum(b*v)
  #   
  #   M=(D+E)/(12*dc)
  #   M
  # }
