ds_get_I <- function(b,h,hf,Ep,Et){
  # Find the I where there's FRP
  h1=h/2+hf
  h2=hf/2
  r=Ep/Et #Modular ratio of FRP-to-timber
  
  dc=(hf*b*r*h2 + h*b*h1)/(hf*b*r + h*b)
  I=b*(h^3 + r*hf^3)/12 + b*h*(h1 - dc)^2 + b*hf*r*(h2-dc)^2
  
  list(I=I,dc=dc)
}

ds_get_R_from_la_Mn <- function(la,Mn){
  # Q3 (b)
  (6*Mn*la + la^3 - 3*la)/(6*Mn*la - 6*Mn + la^3 -3*la+2)
}

ds_get_la_from_R <- function(R){
  #la=ds_get_la_from_R(R)
  
  ## 替Mn =(1-la^2)/2
  # This is to get the la at which minimum Me occurs.
  v=c(-R/6,0,R/2,(1-R)/3)
  p=polynom::polynomial(v)
  
  r=solve(p)
  r=r[r>0]
  la=min(r)
  la
}

ds_get_la_range_from_R_Mn <- function(R,Mn){
  # l = ds_get_la_range_from_R_Mn(R,Mn)
  
  # Q2 (b)
  a=(R-1)/6
  b=0
  c=Mn*R - Mn - R/2 + 1/2
  d=-Mn*R + R/3
  
  n=10
  v=0.9 + 0.1 * (0:(n))/(n)
  for (x in v){
    v.('for la=%10g, f=%10.2g',x,d + c*x + a*x^3)
  }
  
  p=polynom::polynomial(c(d,c,b,a))
  r=solve(p)
  cat('r is ',r)
  r=r[r>0]
  v.('The  lambda is between %.2g and %.2g for the %gWL end hog moment not to be exceeded',
     r[1],r[2],Mn)
  
  r
}

