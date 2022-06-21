(TeX-add-style-hook
 "m"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "margin=20mm")))
   (TeX-run-style-hooks
    "latex2e"
    "info"
    "article"
    "art10"
    "tikz"
    "pgffor"
    "geometry"))
 :latex)

