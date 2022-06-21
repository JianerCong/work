v_ <- function(...) cat(gettextf(...),'\n')
dyn_get_max_dlf <- function(Om,om,k,p0,xi){
  ## umax <- dyn_get_max_dlf(Om,om,k,p0,xi)
  v_('Getting maximum dynamic deflection due to harmonic force')
  be=Om/om
  mu=p0/k
  Fmax=((1-be^2)^2 + (2*xi*be)^2)^(-0.5)
  v_('be: %g, mu: %g, Fmax: %g',be,mu,Fmax)
  
  umax=mu*Fmax
  umax
}
