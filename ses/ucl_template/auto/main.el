(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("olplainarticle" "fleqn" "10pt")))
   (TeX-run-style-hooks
    "latex2e"
    "olplainarticle"
    "olplainarticle10")
   (LaTeX-add-labels
    "sec:examples"
    "fig:view"
    "tab:widgets")
   (LaTeX-add-bibliographies
    "sample"))
 :latex)

