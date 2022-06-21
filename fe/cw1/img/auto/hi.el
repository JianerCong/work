(TeX-add-style-hook
 "hi"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "geometry"
    "pgfmath")
   (TeX-add-symbols
    "myget"))
 :latex)

