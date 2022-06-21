(TeX-add-style-hook
 "col"
 (lambda ()
   (TeX-run-style-hooks
    "out")
   (TeX-add-symbols
    "TenBar"
    "x")
   (LaTeX-add-labels
    "sec:col-axi"
    "sec:col-am"
    "fig:gala"
    "fig:envlop"
    "fig:za"
    "fig:zl"
    "table:elem"))
 :latex)

