library(tidyverse)

go <- function() source('d.R')

if (.Platform$OS.type == 'unix'){
  source('~/Templates/scripts/mylib.R')
  this_dir <- '~/work/ses/cw2r/data/'
}else{
  source('C:/Users/congj/AppData/Roaming/Templates/scripts/mylib.R')
  this_dir <- 'C:/Users/congj/work/ses/cw2r/data/'
}

beam1 <- env(
  M_Ed_Nmm = 131e6, M_Edl_Nmm = 45.78e6,
  d_mm =  500, c_mm = 40, B_mm = 300, V_Ed_kN = 87.8)
beam2 <- env(
  M_Ed_Nmm = 194.5e6, M_Edl_Nmm = 128.5e6,
  d_mm =  500, c_mm = 40, B_mm = 300, V_Ed_kN = 124.4)

g <- function(s){
  paste0(this_dir,s)
}
source(g('R/get_l.R')) # defines l, the list of names to be exported
source(g('R/global_data.R')) #defines f_cd_N_mm2 ...

source(g('R/beam_flex.R'))
source(g('R/beam_local_duc.R'))
source(g('R/beam_shr.R'))
source(g('R/col_all.R'))
source(g('R/col_shr.R'))
fout <- g('out.tex')


library(Rcpp)
sourceCpp(g("R/beam_flex.cpp"))


sink('log.txt') #direct output

## Beam 1 --------------------------------------------------
rule('beam_flex() started.')
g <- function(s){env_get(beam1, s)}
env_beam_flex <- beam_flex(g("M_Ed_Nmm"), g("d_mm"),
                           g("c_mm"), g("B_mm"))
rule('beam_local_duc() started.')
env_beam_local_duc <- beam_local_duc(env_beam_flex)
## env_print(env_beam_flex)
rule('beam_shr() started.')
env_beam_shr <- beam_shr(V_Ed_kN = env_get(beam1, "V_Ed_kN"),
                         d_mm = env_get(beam1, "d_mm"))

## Beam 2 --------------------------------------------------
rule('beam_flex() started for beam 2')
g <- function(s){env_get(beam2, s)}
env_beam_flex2 <- beam_flex(g("M_Ed_Nmm"), g("d_mm"),
                           g("c_mm"), g("B_mm"))
rule('beam_local_duc() started for beam 2')
env_beam_local_duc2 <- beam_local_duc(env_beam_flex2)
## env_print(env_beam_flex)
rule('beam_shr() started for beam 2')
env_beam_shr2 <- beam_shr(V_Ed_kN = g("V_Ed_kN"),
                          d_mm = g("d_mm"),
                          dh_mm = 6
                          )
sink() #undirect output

rule('col_all() started.')
env_col_all <- col_all(
  N_N = 746.6e3,
  b_mm = 400,
  h_mm = 600,
  bar_d_mm = 18,
### Stage 3
  ## M_Rd in kNm

  ## M_bx = 146,    #
  ## M_cx1 = 319, #to be read: 140
  ## M_cx2 = 282.4, #tr: 100
  ## M_by = 146,  #146
  ## M_cy1 = 207, #tr: 100
  ## M_cy2 = 203.1, #tr: 80
  M_bx = 146,    #
  M_cx1 = 225, #to be read: 140
  M_cx2 = 220, #tr: 100
  M_by = 123,  #146
  M_cy1 = 180, #tr: 100
  M_cy2 = 178, #tr: 80

  ## lowest N in kN
  N_c1 = 716,
  N_c2 = 516.2,
  ## Results from stage 4
  phi_mm = 4,
  s_mm = 50
)
env_col_shr <- col_shr()

g <- function(s){paste0(this_dir,s)}
source(g('R/write_data.R'))
