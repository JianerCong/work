(TeX-add-style-hook
 "p1"
 (lambda ()
   (TeX-run-style-hooks
    "img/shapes"
    "tex/matM")
   (TeX-add-symbols
    '("mynode" ["argument"] 2)
    '("prnIt" 1)
    '("brkItl" 1)
    '("brkIt" 1)
    '("il" 1)
    '("tsps" 1)
    '("pFrac" 2)
    '("eBdr" 1)
    '("eBdri" 1)
    '("thethree" 5)
    "lhs"
    "twoBdr"
    "pcTk"
    "na"
    "nb"
    "nc"
    "nd"
    "Ta"
    "Tb"
    "bdr"
    "Bdr"
    "aai"
    "aa"
    "bbi"
    "bb"
    "cci"
    "cc"
    "T"
    "c"
    "K"
    "matK"
    "w"
    "h"
    "i"
    "xl"
    "a"
    "anum"
    "bnum"
    "bnumb"
    "L"
    "x"
    "b"
    "matb"
    "aTi"
    "A"
    "alT"
    "M"
    "Tn"
    "alTt"
    "g")
   (LaTeX-add-labels
    "eq:base"
    "eq:bc1"
    "eq:bc2"
    "sec:q1"
    "eq:base2"
    "eq:1"
    "eq:2"
    "eq:3"
    "eq:4"
    "eq:var"
    "eq:testfun"
    "eq:6"
    "eq:mtb"
    "eq:bigc"
    "fig:shpfuncs"
    "eq:k11"
    "eq:k22"
    "eq:k33"
    "eq:k44"
    "eq:k55"
    "eq:na"
    "eq:nb"
    "eq:nc"
    "eq:nd"
    "eq:nk11"
    "eq:nk22"
    "eq:nk33"
    "eq:nk44"
    "eq:nk55"
    "eq:nk12"
    "eq:nk23"
    "eq:nk34"
    "eq:nk45"
    "eq:bigK"
    "eq:l1"
    "eq:l2"
    "eq:l3"
    "eq:bigL"
    "eq:bigb"
    "eq:bigM"
    "eq:readyToSplit"
    "eq:toDivide"
    "eq:mupper"
    "eq:mlower"
    "eq:resultT")
   (LaTeX-add-environments
    "tbmatrix"))
 :latex)

