if (.Platform$OS.type == 'unix'){
  source('~/Templates/scripts/mylib.R')
}else{
  source('c:/Users/congj/AppData/Roaming/Templates/scripts/mylib.R')
}
library(tidyverse)

tf <- read_csv('m.csv',
               col_types = list(col_double(),
                                col_double(),
                                col_double()
                                )
               )
vw3('table read\n', tf)
p <- ggplot(tf, aes(x=Mx, y=My, col=N))+
  geom_point()
