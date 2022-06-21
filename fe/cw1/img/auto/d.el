(TeX-add-style-hook
 "d"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "border=0.2cm" "dvipsnames")))
   (TeX-run-style-hooks
    "latex2e"
    "tri"
    "standalone"
    "standalone10"
    "tikz"
    "tcolorbox")
   (TeX-add-symbols
    '("clc" 1)
    '("clb" 1)
    '("cla" 1)
    "mycola"
    "mycolb"
    "mycolc"))
 :latex)

