col_shr <- function(M_Rd_c_kNm = 225,
                    L_mm = 4000,
                    d_mm = 600,
                    b_mm = 400,
                     dh_mm = 4){
  L_clr_mm <- L_mm - 2 * d_mm
  V_Ed_kN <- 1.1 * M_Rd_c_kNm * 2 / (L_clr_mm * 1e-3)

  make_practical <- function(x){
    ## floor to the nearest 50
    d <- x /50;
    d <- floor(d)
    d * 50
  }

  rule('Doing column critical region',1)
  A_sw_mm2 <- 5 * pi * dh_mm ^2 / 4

  s_req_mm <- local({
    V_Ed <- V_Ed_kN * 1e3
    0.9 * d_mm * A_sw_mm2 * f_yd_N_mm2 / V_Ed
  })

  ## vw(A_sw_mm2)
  vw(s_req_mm)
  s_act_mm <- make_practical(s_req_mm)
  s_max_mm <- min(c(b_mm / 2, 175, 8 * 14))

  vw(s_act_mm)
  vw(s_max_mm)
  assert_that(s_max_mm > s_act_mm)

  V_Rd_s_act_kN <- local({
    1e-3 * 0.9 * d_mm * A_sw_mm2 * f_yd_N_mm2 / s_act_mm
  })
  vw(V_Rd_s_act_kN)
  assert_that(V_Rd_s_act_kN > V_Ed_kN)

  rule('Doing column non-critical region',1)

  rho <- 2 * A_sw_mm2 / (b_mm * d_mm)

  s_max_mm_n <- local({0.75 * d_mm})
  s_req_mm_n <- local({
    V_Ed <- V_Ed_kN * 1e3
    (0.9 * d_mm * A_sw_mm2 * f_yd_N_mm2 / V_Ed ) * cotd(21.8)
  })
  s_act_mm_n <- make_practical(s_req_mm_n)

  V_Rd_s_act_kN_n <- local({
    (1e-3 * 0.9 * d_mm * A_sw_mm2 * f_yd_N_mm2 / s_act_mm_n) * cotd(21.8)
  })
  vw(s_max_mm_n)
  vw(s_req_mm_n)
  vw(s_act_mm_n)
  assert_that(s_max_mm_n > s_act_mm_n)
  vw(V_Rd_s_act_kN_n)
  assert_that(V_Rd_s_act_kN_n > V_Ed_kN)

  current_env()
}
