library(tidyverse)
library(tikzDevice)

df <- read_csv('df.csv',
               col_types = list(
                 x=col_double(),
                 y=col_double(),
                 memb=col_character(),
                 phi=col_double()
               ))
df <- df %>% filter(memb != '-')
p <- ggplot(df,aes(x=x,y=y,colour=phi))+
  labs(x=NULL, colour="$\\phi$", y=NULL)+
  geom_point()

exportPlot <- function(texName,p,w,h){
  tikz(texName,
       width = w,
       height = h
       )
  print(p)
  dev.off()
}
exportPlot("../p.tex", p, 6,3)
