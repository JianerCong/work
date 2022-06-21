(TeX-add-style-hook
 "d"
 (lambda ()
   (TeX-run-style-hooks
    "d2"
    "d3")
   (LaTeX-add-counters
    "x"))
 :latex)

