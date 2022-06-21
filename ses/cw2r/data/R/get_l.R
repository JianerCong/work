beam2_prefix <- 'b2.'
l <- local({
  l_shr <- c(
    "dh", "d", "Asw", "VEd", "fyd", #the 5
    "rho",
    "sreq","sact", "VRdsAct", "smax",
    "sactn", "VRdsActn","smaxn", "sreqn"
  )

  l_bm <- c(
    "MEdl", "MEd",
    "Asr","n14","n18","As",
    "fcd","Es","epcu", "c",
    "qea", "qeb","qec",
    "x","xa",
    "eps", "b", "epsp", "MRd",
    l_shr
  )

  l_col <- c(## column
    "N", "b", "h", "vd",
    "rho", "Asmin", "Asa","barn",
    "bard",
    ## Stage 3
    "MRd.bx", "MRd.by",
    "MRd.cx1", "MRd.cx2", "MRd.cy1", "MRd.cy2",
    "SMRd.bx", "SMRd.by", "SMRd.cx", "SMRd.cy",
    "N.c1", "N.c2",
    ## Stage 4
### Stage 4.shr
    str_c('shr.', c("MRdc","Lclr","VEdcol", l_shr)),
    ## Stage 5
    "bi", "bi2","b0","h0","s","aln","als","phi",
    "omwd","fyd","fcd","al","alom"
  )

  l_col <- str_c('cl.',l_col)

  c(l_bm,str_c(beam2_prefix, l_bm),l_col)
})
val <- local({
  place_holder_func <- function(x) str_c("[", x , "]")
  val <- place_holder_func(l)
  names(val) <- l
  val
})

