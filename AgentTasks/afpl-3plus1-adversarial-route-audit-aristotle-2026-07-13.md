# Aristotle adversarial audit: anomalous-Floquet 3+1 route

Red-team the proposed escape from lattice doubling:

1. Primitive substeps are local projector-conditioned null shifts.
2. A finite-depth drive has endpoint `U(k)` with one zero-quasienergy Weyl node.
3. The compensating topology is carried by a distinct pi-gap/boundary structure.
4. The global invariant is a degree of `T^3 -> SU(2)`, while local Weyl charge is
   an enclosing-sphere degree/Chern number.

Find false equivalences, hidden periodicity assumptions, determinant-level
doublers, misuse of zero/pi gap tags, and places where "primitive null" has
silently changed meaning. Produce a verdict matrix for: strict spin-blind shift,
projector-conditioned shift, open finite box, and genuine half-space. For every
fatal objection, give a minimal Lean counterexample target; for every surviving
claim, give the strongest theorem statement that would close it. Do not accept
numerical `W=1` as proof.
