library(Rcpp)
library(tidyverse)

sourceCpp("m.cpp")
l <- go()
df <- tibble(t=l$t,u=l$u)

p <- ggplot(df, aes(x=t,y=u)) +
  geom_line()+
  coord_cartesian(ylim=c(-20,20), xlim=c(0,5))+ #zoom only
  labs(x="Time ($t$)", y = "Displacement $u$")
