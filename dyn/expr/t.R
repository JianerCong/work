vwl <- function(...){
  l <- rlang::enexprs(...) #fix this
  print(l)
  cli::cli_ol()
  for (n in names(l)){
    message('n is ',n)
    cli_li(paste0(n, '\t',l[[n]]))
  }
  cli::cli_end()
}
a <- 1;b <- 'hi';c <- c(1,2,3)
vwl(a,b,c)
