(TeX-add-style-hook
 "Mpm"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (TeX-run-style-hooks
    "latex2e"
    "pm"
    "standalone"
    "standalone10"
    "tikz"))
 :latex)

