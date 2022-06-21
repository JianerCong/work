(TeX-add-style-hook
 "m"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "myplot"
    "standalone"
    "standalone10"
    "tikz"))
 :latex)

