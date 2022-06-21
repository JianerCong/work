(TeX-add-style-hook
 "Mpb"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "pb"
    "standalone"
    "standalone10"
    "tikz"))
 :latex)

