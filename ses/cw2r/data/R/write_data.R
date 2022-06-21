fm <- function(v, fmt = '%.4g'){
  s <- sprintf(fmt,v)
  ## change 12e-2 to 12 \times 10 ^{2}
  if (str_sub(s,-4,-4) == 'e'){
    s1 <- str_sub(s,-999,-5) #1234
    s2 <- str_sub(s,-1,-1)   #8
    s <- str_c(s1, ' \\ensuremath{\\times 10^{', s2, '}}')
  }
  s
}

make_env_export_g <- function(e){
  function(s, fmt = '%.4g'){
    v <- env_get(e, s)
    fm(v,fmt)
  }
}

## Write data for beams
write_beam_data <- function(val,
                            env_beam_flex,
                            env_beam_local_duc,
                            env_beam_shr,
                            prefix = ''){
  g <- make_env_export_g(env_beam_flex)
  gl <- function(l,s,fmt = '%.4g'){
    ## get a value in list in env
    lst <- env_get(env_beam_flex, l)
    v <- lst[[s]]
    fm(v,fmt)
  }

  p <- function(val,k,v){
    kk <- paste0(prefix,k)
    assert_that(kk %in% names(val))
    val[[kk]] <- v
    val
  }
  val <- p(val,"MEd",g("M_Ed_Nmm"))
  val <- p(val,"MEdl",env_get(beam1,"M_Edl_Nmm"))
  val <- p(val,"fyd",fm(f_yd_N_mm2))
  val <- p(val,"Asr",g("A_sreq_mm2"))
  val <- p(val,"n14",gl("get_real_A_s_list","n14"))
  val <- p(val,"n18",gl("get_real_A_s_list","n18"))
  val <- p(val,"As",g("A_s_mm2"))
  val <- p(val,"b",g("B_mm"))
  val <- p(val,"d",g("d_mm"))
  val <- p(val,"fcd",fm(f_cd_N_mm2))
  val <- p(val,"Es",fm(E_s_N_mm2))
  val <- p(val,"x",g("x_mm"))
  val <- p(val,"xa",g("x_a_mm"))
  val <- p(val,"eps",gl("check_ep_s_list","ep_s"))
  val <- p(val,"epsp",gl("check_ep_s_list","ep_s_prm"))
  val <- p(val,"epcu",fm(ep_cu))
  val <- p(val,"c",g("c_mm"))
  val <- p(val,"MRd",g("M_Rd_N_mm"))
  val <- p(val,"qea",gl("find_x_list","a"))
  val <- p(val,"qeb",gl("find_x_list","b"))
  val <- p(val,"qec",gl("find_x_list","c"))
  ## Beam Stage 2
  val <- p(val,"rho",sprintf('%.2g',env_get(env_beam_local_duc,"rho")))
  ## Beam Stage 3
### Critical region
  g <- make_env_export_g(env_beam_shr)
  val <- p(val,"VEd",g('V_Ed_kN'))
  val <- p(val,"dh",g('dh_mm'))
  val <- p(val,"sreq",g('s_req_mm'))
  val <- p(val,"sact",g('s_act_mm'))
  val <- p(val,"Asw",g('A_sw_mm2'))
  val <- p(val,"VRdsAct",g('V_Rd_s_act_kN'))
  val <- p(val,"smax",g('s_max_mm'))
### Non-critical region
  val <- p(val,"sactn",g('s_act_mm_n'))
  val <- p(val,"VRdsActn",g('V_Rd_s_act_kN_n'))
  val <- p(val,"smaxn",g('s_max_mm_n'))
  val <- p(val,"sreqn",g('s_req_mm_n',fmt='%.0f'))
  val
}

## Write beam data
val <- write_beam_data(val, env_beam_flex, env_beam_local_duc,
                       env_beam_shr, prefix = '')
val <- write_beam_data(val, env_beam_flex2, env_beam_local_duc2,
                       env_beam_shr2, prefix = beam2_prefix)

## Column
## Stage 1
g <- make_env_export_g(env_col_all)
p <- function(k,v){
  ## message("Exporting ", k, '\t', v)
  val[[paste0("cl.",k)]] <- g(v)
  val
}
val <- p("N","N_N")
val <- p("b","b_mm")
val <- p("h","h_mm")
val <- p("vd","vd")

## Stage 2
val <- p("bard", "bar_d_mm")
val <- p("rho", "rho")
val <- p("Asmin","A_s_min_mm2")
val <- p("Asa","A_sa_mm2")
val <- p("barn", "bar_n")

## Stage 3
val <- p("MRd.bx","M_bx")
val <- p("MRd.by","M_by")
val <- p("MRd.cx1","M_cx1")
val <- p("MRd.cx2","M_cx2")
val <- p("MRd.cy1","M_cy1")
val <- p("MRd.cy2","M_cy2")
val <- p("SMRd.bx","SM_bx")
val <- p("SMRd.by","SM_by")
val <- p("SMRd.cx","SM_cx")
val <- p("SMRd.cy","SM_cy")
val <- p("N.c1","N_c1")
val <- p("N.c2","N_c2")

## Stage 5
val <- p("bi","bi_mm")
val <- p("bi2","bi2_mm")
val <- p("h0","h0_mm")
val <- p("b0","b0_mm")
val <- p("s","s_mm")
val <- p("aln","al_n")
val <- p("als","al_s")
val <- p("phi","phi_mm")
val <- p("omwd","om_wd")

val[["cl.fcd"]] <- fm(f_cd_N_mm2)
val[["cl.fyd"]] <- fm(f_yd_N_mm2)

val <- p("al","al")
val <- p("alom","alom")

## Stage 4
g <- make_env_export_g(env_col_shr)
p <- function(k,v){
  ## message("Exporting ", k, '\t', v)
  kk <- paste0("cl.shr.",k)
  assert_that(kk %in% names(val))
  val[[kk]] <- g(v)
  val
}

val <- p("MRdc","M_Rd_c_kNm")
val <- p("Lclr","L_clr_mm")
val <- p("VEdcol","V_Ed_kN")

val <- p("dh","dh_mm")
val <- p("d","d_mm")
val <- p("Asw","A_sw_mm2")
val <- p("VEd","V_Ed_kN")
val[["cl.shr.fyd"]] <- fm(f_yd_N_mm2)
val <- p("sreq","s_req_mm")
val <- p("sact","s_act_mm")
val <- p("smax","s_max_mm")
val <- p("VRdsAct","V_Rd_s_act_kN")
val <- p("smaxn","s_max_mm_n")
val <- p("sreqn","s_req_mm_n")
val <- p("sactn","s_act_mm_n")
val <- p("rho","rho")
val <- p("VRdsActn","V_Rd_s_act_kN_n")




## Write the file
unlink(fout)
for (i in seq_along(l)){
  k = l[[i]]
  v = val[[i]]
  write(str_c("\\MySet{", k,
              "}{\\textcolor{black}{",v,"}}"),
  file=fout, append=TRUE)
}
