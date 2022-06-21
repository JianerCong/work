(TeX-add-style-hook
 "d"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "d1"
    "standalone"
    "standalone10"
    "tikz"
    "amsmath"
    "verbatim"))
 :latex)

