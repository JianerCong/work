(TeX-add-style-hook
 "d3"
 (lambda ()
   (TeX-run-style-hooks
    "flr")
   (TeX-add-symbols
    '("getfour" ["argument"] 1)
    '("sdowntxt" ["argument"] 3)
    '("ldb" ["argument"] 0)
    '("lda" ["argument"] 0)
    '("mff" ["argument"] 2)
    "mf"
    "twotwoone"))
 :latex)

