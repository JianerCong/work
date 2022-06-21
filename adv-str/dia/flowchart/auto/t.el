(TeX-add-style-hook
 "t"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "d"
    "standalone"
    "standalone10"
    "tikz"
    "amsmath"))
 :latex)

