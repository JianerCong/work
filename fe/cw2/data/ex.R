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


set_this <- function(fout,k,v){
  write(str_c("\\MySet{", k,
              "}{\\textcolor{blue}{",v,"}}"),
        file=fout, append=TRUE)
}
