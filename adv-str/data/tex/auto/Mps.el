(TeX-add-style-hook
 "Mps"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "ps"
    "standalone"
    "standalone10"
    "tikz"))
 :latex)

