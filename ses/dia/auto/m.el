(TeX-add-style-hook
 "m"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm" "dvipsnames")))
   (add-to-list 'LaTeX-verbatim-environments-local "minted")
   (TeX-run-style-hooks
    "latex2e"
    "d"
    "standalone"
    "standalone10"
    "tikz"
    "amsmath")
   (TeX-add-symbols
    '("sdown" ["argument"] 1)
    '("Uptodown" ["argument"] 1)
    '("uptodown" ["argument"] 1)
    '("colc" ["argument"] 0)
    '("colb" ["argument"] 0)
    '("cola" ["argument"] 0)
    "mycola"
    "mycolb"
    "mycolc"
    "myem"))
 :latex)

