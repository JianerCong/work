library(tidyverse)
library(rlang)
if (.Platform$OS.type == 'unix'){
  source('~/Templates/scripts/mylib.R')
}else{
  source('c:/Users/congj/AppData/Roaming/Templates/scripts/mylib.R')
}
source('global_data.R')
source('col_all.R')

e <- col_all()
## extract b and h from e
b_mm <- env_get(e, 'b_mm')
h_mm <- env_get(e, 'h_mm')

