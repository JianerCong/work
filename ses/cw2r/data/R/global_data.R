ep_s <- 0.0021
ep_cu <- 0.0035
f_ck_N_mm2 <-  25
f_yk_N_mm2 <- 500
f_yd_N_mm2 <- f_yk_N_mm2 / 1.15
f_cd_N_mm2 <- 0.85 * f_ck_N_mm2 / 1.5
E_s_N_mm2 <- f_yd_N_mm2 / ep_s
