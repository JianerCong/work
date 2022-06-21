col_all <- function(N_N = 645.7e3,
                    b_mm = 400,
                    h_mm = 600,
                    bar_d_mm = 18,
                    ### Stage 3
                    ## M_Rd in kNm
                    M_bx = 226.9,
                    M_cx1 = 319,
                    M_cx2 = 282.4,
                    M_by = 242,
                    M_cy1 = 207,
                    M_cy2 = 203.1,
                    ## N in kN
                    N_c1 = 159,
                    N_c2 = 139.2,
                    ## Results from stage 4
                    phi_mm = 4,
                    s_mm = 50
                    ){

  vd <- N_N / (b_mm * h_mm * f_cd_N_mm2)
  ## vw(N_N)
  ## vw(b_mm)
  ## vw(h_mm)
  ## vw(f_cd_N_mm2)
  ## vw(vd)

  ## Design for Axial-Moment
  rho <- 0.01
  A_s_min_mm2 <- rho * b_mm * h_mm

  bar_A_mm2 <- area_circ(bar_d_mm)
  bar_n <-  ceiling(A_s_min_mm2 / bar_A_mm2)
  vw(bar_n)
  A_sa_mm2 <- bar_n * bar_A_mm2
  vw(A_sa_mm2)


  ## Stage 3
  starts_with_C <- function(nam){
    str_sub(nam,1,1) == 'C'
  }

  tf <- tibble(
    nam = c('B-1-1-c','B-1-2-c','C-1','C-2',
            'B-1-2-a','B-1-1-a','C-1','C-2'),
    M_Rd_kNm = c(M_bx, M_bx, M_cx1, M_cx2,
                 M_by,M_by,M_cy1,M_cy2),
    dir = c('x', 'x', 'x', 'x', 'y', 'y', 'y','y'),
    N_kN = c(0,0,N_c1,N_c2,0,0,N_c1,N_c2),
    is_col = starts_with_C(nam)
  )

  tf2 <- tf %>%
    group_by(dir,is_col) %>%
    summarise(SM_Rd_kNm = sum(M_Rd_kNm)) %>%
    mutate(SM_Rd_kNm = SM_Rd_kNm * ifelse(is_col,1, 1.3))

  SM_bx <- tf2$SM_Rd_kNm[(tf2$dir == 'x') & !(tf2$is_col)]
  SM_by <- tf2$SM_Rd_kNm[(tf2$dir == 'y') & !(tf2$is_col)]
  SM_cx <- tf2$SM_Rd_kNm[(tf2$dir == 'x') & (tf2$is_col)]
  SM_cy <- tf2$SM_Rd_kNm[(tf2$dir == 'y') & (tf2$is_col)]
  assert_that(SM_cx > SM_bx)
  assert_that(SM_cy > SM_by)

  ## Stage 5
  c_mm <- 40

  hb_mm <- c(h_mm,b_mm)
  hb_i_mm  <- hb_mm - 2 * c_mm
  hb_0_mm <- hb_i_mm + 2 * phi_mm
  h0_mm <- hb_0_mm[[1]]
  b0_mm <- hb_0_mm[[2]]

  ## ?? how they got hb_0 346? Fine, up to Karim
  hb_0_mm <- hb_0_mm + 10

  round_to_nearest_5 <- function(x){
    round(x/5)*5
  }

  bi_mm <- hb_i_mm[[2]]
  ## (h0 / 3) round to nearest 5mm
  bi2_mm <- round_to_nearest_5(hb_i_mm[[1]] / 3)

  ## vw3('[h b]',hb_mm)
  ## vw3('[hi bi]',hb_i_mm)
  ## vw3('[h0 b0]',hb_0_mm)
  ## vw(bi_mm)
  ## vw(bi2_mm)

  bi_s_mm <- c(rep(bi_mm,2),rep(bi2_mm,6))
  al_n <- 1 - (sum(bi_s_mm^2) / (6 * prod(hb_0_mm)))
  al_s <- prod(1 - s_mm/(2 * hb_0_mm))
  al <- al_n * al_s


  om_wd <- (sum(c(bi_s_mm,bi_mm * 2)) #two more horizontal hoops
    * area_circ(phi_mm)) / (prod(hb_0_mm) * s_mm)
  om_wd <- om_wd * f_yd_N_mm2 / f_cd_N_mm2

  alom <- om_wd * al

  ## vw(om_wd)
  ## vw(al_s)
  ## vw(al_n)

  current_env()
}
