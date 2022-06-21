if (.Platform$OS.type == 'unix'){
  source('~/Templates/scripts/mylib.R')
}else{
  source('c:/Users/congj/AppData/Roaming/Templates/scripts/mylib.R')
}

solve_undamped_init_val_problem <- function(k,m,y0,dy0){
  cli::cli_h1('Solving undamped initial value problem with:')
  vw(k); vw(m); vw(y0); vw(dy0)
  om <- sqrt(k/m)
  t0 <- atan(dy0/y0) / om
  R <- sqrt(y0^2 + (dy0/om)^2)
  cli::cli_h1('Results:')
  vw(om); vw(t0); vw(R)
}

solve_damped_init_val_problem <- function(a,b,c){
  cli::cli_h1('Solving damped initial value problem with:')
  vw(a);vw(b);vw(c)
  B <- b^2 - 4 * a * c
  vw(B)
}

solve_undamped_init_val_problem(k=3*3e4, m=100,
                                y0=-2, dy0=60)
