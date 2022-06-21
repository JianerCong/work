(TeX-add-style-hook
 "m2"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "BKappaPlot"
    "standalone"
    "standalone10"
    "tikz"))
 :latex)

