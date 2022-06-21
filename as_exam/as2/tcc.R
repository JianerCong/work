source('lib.R')
tcc_get_F1 <- function(epct,Ec,wc,dc){
  ## F1=tcc_get_F1(epct,Ec,wc,dc)
  A <- epct*Ec*wc/2
  v.('F1 is %.5gdc',A)
  A * dc
}

tcc_get_F2 <- function(epct,eps,dc,hc,Et,dj,wj){
  ## tcc_get_F2(epct,eps,dc,hc,Et,dj,wj)
  ka <- epct/dc
  v.('ka is %.5g',ka)
  (epct + eps - (hc + dj/2)*ka) * Et * wj * dj
}


tcc_get_F1_F2 <- function(epct,eps,dc,tcbm){
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  ## o <- tcc_get_F1_F2(epct,eps,Ec,dc,wc,Et,dj,wj)
  v_('Getting F1,F2')
  o <- c(tcc_get_F1(epct,Ec,wc,dc)
         ,tcc_get_F2(epct,eps,dc,hc,Et,dj,wj)
  )
  names(o) <- c('F1','F2')
  o
}

tcc_no_slip_na_depth <- function(tcbm){
  ## Q1 (b)
  
  ## Get the N.A. depth from bottom, assuming zero slip strain. When there's no
  ## slip strain, beam theory (i.e. moment balance) can be used.
  
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  v_('Calculating N.A. depth assuming no slip.')
  F12 <- c(hc*wc*Ec,dj*wj*Et)
  d12 <- c(dj+hc/2,dj/2)
  d <- sum(F12*d12) / sum(F12)
  o <- list(F12,d12,d)
  names(o) <- c('F_slab_joist','d_slab_joist','d_NA')
  o
}

tcc_no_slip_get_sig_ct <- function(tcbm,d_NA,M){
  ## Get the top concrete compression stress assuming no slip strain, so beam
  ## theory can be used.
  
  ## Q2 (c)
  
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  r=Ec/Et
  core <- (wc*hc^3 + wj*dj^3/r)/12
  shift1 <- wc*hc*(dj + hc/2 - d_NA)^2
  shift2 <- wj*dj*(d_NA - dj/2)^2 / r
  
  I <- core + shift1 + shift2
  y <- hc + dj - d_NA
  
  list(sig_ct=M*y/I,I=I,y=y)
}

tcc_get_sec_moment <- function(epct,dc,tcbm){
  ## Q2 (a)
  
  ## Get the TCC section moment when the concrete section is in partial
  ## compression, and the depth of N.A., dc, is known.
  
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  
  L <- dj/2 + hc-dc/3
  F1 <- tcc_get_F1(epct,Ec,wc,dc)
  Ms1 <- L*F1
  Ms2 <- Et * epct*dj/dc*wj*dj^2/12
  list(Ms1=Ms1,Ms2=Ms2,L=L,F1=F1,M=Ms1+Ms2)
}

tcc_get_dc <- function(epct,eps,tcbm){
  ## dc <- tcc_get_dc(epct,eps,tcbm)
  ## get dc for a partial compressive section when epct and eps are known.
  
  ## Q2 (a)
  
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  
  v_('Getting dc for a partial compressive section, with epct, eps = {epct}, {eps}')
  A <- epct*Ec*wc/2
  v_('slab force: {A}dc')
  b <- Et*wj*dj
  B <- (epct + eps)*b
  C <- (hc + dj/2)*epct*b
  v_('joist force: {B} - {C}/dc')
  
  l <- c(A,B,-C)
  p <- polynom::polynomial(rev(l))
  max(solve(p))
}

tcc_get_eps <- function(epct,dc,tcbm){
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  ka=epct/dc
  F1=tcc_get_F1(epct,Ec,wc,dc)
  v.('Getting slipping strain eps given dc=%g: ka=%g,concrete force=%g',
     dc,ka,F1)
  -F1/(dj*Et*wj)-epct+ka*(hc+dj/2)
}


tcc_get_strs_strn_profiles <- function(epct,ka,eps,tcbm){
  ## o <- tcc_get_strs_strn_profiles(epct,ka,hc,eps,dj,Ec,Et)
  
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  # Q1(b)
  
  epcb=epct-ka*hc
  ep1=epcb+eps
  ep2=ep1-ka*dj
  
  si1=epct*Ec
  si12=epcb*Ec
  si2=ep1*Et
  si3=ep2*Et
  
  list(ep=c(epct,epcb,ep1,ep2),
       si=c(si1,si12,si2,si3))
}

tcc_test_partial_compression <- function(epct,eps,tcbm){
  ## f12 <- tcc_test_partial_compression(epct,eps,tcbm)
  
  ## Q3 (a)
  
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  ## Decide whether it's full compression or partial compression ?
  f12 <- tcc_get_F1_F2(epct,eps,dc=hc,tcbm)
  ## if F1 > F2 ⇒ partial compression (Be careful with the sign)
  if (sum(f12)>0) {
    v_("It's partial compression")
  }else{
    v_("It's full compression")
  }
  f12
}

tcc_test_partial_compre_eptb_ka <- function(eptb,ka,tcbm){
  ## unpack tcbm --------------------------------------------------
  Ec <- env_get(tcbm,"Ec"); Et <- env_get(tcbm,"Et")
  wc <- env_get(tcbm,"wc"); hc <- env_get(tcbm,"hc")
  dj <- env_get(tcbm,"dj"); wj <- env_get(tcbm,"wj")
  
  ep_tmid <- eptb + ka * dj / 2
  F2 <- ep_tmid * Et * wj * dj
  
  v.('Testing if slab is partially compressive or not')
  a <- ka*0.5*wc*Ec
  v.('\tep_tmid=%g, joist force F2=%g,slab force F1=%gdc^2',
     ep_tmid,F2,a)
  dc <- sqrt(-F2/a)
  if (dc<hc){
    s<-c('smaller','partially compressive')
  }else{
    s<-c('greater','fully compressive')
  }
  v.('\tgot dc = %g, which is %s than hc = %g, so it\'s %s',
     dc,s[1],hc,s[2])
  dc
}
