beam_local_duc <- function(env_beam_flex){
  g <- function(s){
    env_get(env_beam_flex, s)
  }
  rho <- local({
    A <- g("A_s_mm2")
    b <- g("B_mm")
    d <- g("d_mm")
    A / (b * d)
  })
  vw(rho)
  current_env()
}
