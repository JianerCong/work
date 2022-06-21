(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("olplainarticle" "fleqn" "10pt")))
   (TeX-run-style-hooks
    "latex2e"
    "tex/kv"
    "data/out"
    "tex/bm"
    "tex/bm2"
    "tex/col"
    "olplainarticle"
    "olplainarticle10"
    "tikz"
    "afterpage"
    "booktabs")
   (TeX-add-symbols
    '("g" 1))
   (LaTeX-add-labels
    "fig:fr3d"
    "fig:frl"
    "sec:bm"
    "sec:bm2"
    "sec:col"))
 :latex)

