go <- function() source('m.R')
library(tidyverse)
library(yaml)
library(rlang)

l <- read_yaml('l.yaml')

get_I <- function(b,h)  b * h^3 / 12
q1 <- function(L = 5, b = 0.5, h = 1.75,
               P = 100,
               E = 31475.5 * 1e3,
               G = 13114.9 * 1e3){
  k <- 0.833

  A <- b * h
  I <- get_I(b,h)

  Vy <- P * L^3 / ( 3 * E * I) + P * L / (k * A * G)
  Vy_mm <- Vy * 1e3
  current_env()
}

q2 <- function(){

  E <- 31475.5 * 1e6 #in Pa
  b <- 0.5
  h <- 1.15
  I <- get_I(b,h)
  L <- 12
  m <- 16.56e3 / L #mass per unit length in kg

  f1 <- 3.52/(2*pi)
  f2 <- E * I / (m * L^4)
  fn <- f1 * sqrt(f2)

  f <- c(4.671,3.244,4.651,4.176,4.649,4.425,
          4.648,4.565,4.648,4.627)
  df <- tibble(freq=f,
               type=rep(c('n','d'),5),
               nElem=rep(c(1,2,3,5,10),each=2))

  ## print table --------------------------------------------------
  print_table <- function(df){
    h <- function() cat('\\hline\n')
    r <- function(a,b,c) cat(gettextf('%5s & %5s & %5s \\\\\n',a,b,c))
    f <- function(s) gettextf('%s',s)
    do <- function(tp='n',lb='mass lumped at nodes'){
      df0 <- df %>% filter(type==tp)
      s <- f(str_c('GSA: ', lb))
      r(s, df0$nElem[[1]], df0$freq[[1]])
      for (i in 2:nrow(df0)){
        r('', df0$nElem[[i]], df0$freq[[i]])
      }
      h()
    }
    cat('\\begin{center}\\begin{tabular}{|c|c|c|c|}\n')
    h()
    r('Source','Number of element','Frequency of vibration')
    h()
    do()
    do(tp='d',lb='distributed mass')
    ## r('Hand calculation','',fn)
    cat(gettextf('Hand calculation & & %.2f\\\\',fn))
    h()
    cat('\\end{tabular}\\end{center}')
  }

  sink('t2-table.tex')
  print_table(df)
  sink()

  p <- ggplot(data=df,aes(x=nElem,y=freq,colour=type))+
    geom_point() + geom_line() +
    geom_hline(yintercept=fn)

  current_env()
}

e1 <- q1()
e2 <- q2()
## p <- env_get(e2,'p')
## df <- env_get(e2,'df')

e3 <- q1(L = 48, b = 1, h = 8, P = 40,
               E = 29007.54,
               G = 11156.7)

fout <- 'out.tex'
unlink(fout) #delete the file

source('ex.R')

export_em <- function(fout,l,p,e){
  g <- make_env_export_g(e)
  message('Exporting ',p)
  i <- 0
  for (k in names(l[[p]])){
    i <- i + 1
    set_this(fout,
             str_c(p,'.',l[[p]][[k]])
            ,g(k))
  }
  message(i, ' items exported.')
}

export_em(fout, l, 't1', e1)
export_em(fout, l, 't2', e2)
export_em(fout, l, 't3', e3)

