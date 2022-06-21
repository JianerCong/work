(TeX-add-style-hook
 "m2"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "geometry"
    "tcolorbox"
    "varwidth"
    "lipsum"
    "fontspec")
   (TeX-add-symbols
    "coli")
   (LaTeX-add-tcbuselibraries
    "raster"
    "skins"
    "minted"
    "breakable"))
 :latex)

