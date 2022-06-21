(TeX-add-style-hook
 "d1"
 (lambda ()
   (TeX-run-style-hooks
    "tex/f_yd")
   (TeX-add-symbols
    '("inpage" ["argument"] 1)
    '("RightToLeft" ["argument"] 1)
    '("RightToRight" ["argument"] 1)
    '("LeftToLeft" ["argument"] 1)
    '("UpToDown" ["argument"] 1))
   (LaTeX-add-counters
    "data"
    "proc"))
 :latex)

