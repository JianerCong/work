(TeX-add-style-hook
 "m"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "12pt")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"
    "tikz"
    "tcolorbox")
   (LaTeX-add-tcbuselibraries
    "listings"))
 :latex)

