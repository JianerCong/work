(TeX-add-style-hook
 "p2"
 (lambda ()
   (TeX-run-style-hooks
    "img/mesh"
    "img/rec"
    "img/tri"
    "p")
   (TeX-add-symbols
    '("dX" ["argument"] 1)
    '("dXX" ["argument"] 1)
    '("tri" 1)
    '("rec" 1)
    '("globalK" 1)
    '("intd" 1)
    '("G" 1)
    '("intc" 1)
    '("Mij" 1)
    '("Nij" 2)
    '("Ni" 1)
    '("intb" 1)
    '("inta" 1)
    '("el" 1)
    '("bd" 1)
    '("dy" 1)
    '("dx" 1)
    '("dyy" 1)
    '("dxx" 1)
    "shpf"
    "vg"
    "Nx"
    "Ny"
    "bi"
    "tr"
    "p"
    "K"
    "g"
    "mv"
    "mh"
    "x"
    "y"
    "Kx"
    "Ky"
    "N"
    "B"
    "A"
    "vxy"
    "f"
    "dN"
    "dNdN"
    "ar"
    "DOF"
    "au"
    "bn"
    "phin"
    "one"
    "pp")
   (LaTeX-add-labels
    "eq:poi"
    "sec:q2"
    "eq:tosub"
    "eq:fe"
    "eq:fgvals"
    "eq:recK"
    "eq:triK"
    "eq:K.g.#1"))
 :latex)

