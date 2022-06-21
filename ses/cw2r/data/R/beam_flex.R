
beam_flex <- function(M_Ed_Nmm,d_mm, c_mm, B_mm){

  ## derived data
  x_a_mm <- 0.25 * d_mm
  A_sreq_mm2 <- M_Ed_Nmm / (f_yd_N_mm2 * 0.9 * d_mm)
  ## functions
  check_ep_s <- function(ep_cu,x,c,d){
    ep_sy <-  0.0021;
    ep_s <-  (d - x) * ep_cu / x;
    ep_s_prm <-  (x - c) * ep_cu / x;
    check_smaller(ep_sy,ep_s,"ɛ_sy", "ɛ_s");
    check_smaller(ep_s_prm,ep_sy,"ɛ_s'", "ɛ_sy");
    list(ep_s = ep_s,ep_s_prm=ep_s_prm)
  }

  ## Do things
  rule('Calling get_real_A_s_mm2 from C', level=1)
  get_real_A_s_list <- get_real_A_s_mm2(A_sreq_mm2)
  A_s_mm2 <- get_real_A_s_list$A_s_mm2
  rule('Finding x',1)
  find_x_list <-  find_x(A_s_mm2,B_mm,E_s_N_mm2,
                         f_cd_N_mm2,f_yd_N_mm2,
                         c_mm, ep_cu)
  x_mm <- find_x_list$x
  check_ep_s_list <- check_ep_s(ep_cu, x_mm, c_mm, d_mm)
  M_Rd_N_mm <- get_M_Rd(A_s_mm2, f_yd_N_mm2, d_mm, x_mm, E_s_N_mm2, ep_cu, c_mm);
  check_smaller(M_Ed_Nmm * 1e-6, M_Rd_N_mm * 1e-6, "M_Ed (kNm)", "M_Rd (kNm)");
  current_env()
}

