(TeX-add-style-hook
 "m"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm")))
   (add-to-list 'LaTeX-verbatim-environments-local "minted")
   (TeX-run-style-hooks
    "latex2e"
    "d"
    "standalone"
    "standalone10"
    "tikz"
    "minted"
    "fontspec"))
 :latex)

