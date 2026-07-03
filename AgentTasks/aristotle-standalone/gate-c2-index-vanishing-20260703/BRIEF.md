# Overlap-index vanishing theorem (topological protection of masslessness)

Complete both `sorry`s in `OverlapVanishing/Vanishing.lean`. Do not change
the statements. The module docstring gives a full hand-verified proof sketch
(finite-dimensional Avron-Seiler-Simon pair-of-projections index: A = P - Q,
B = 1 - P - Q, A^2 + B^2 = 1, AB = -BA, eigenvalue pairing, +-1 eigenspaces
inside ker(1 + g e)) and an alternative unitary-conjugation route. Deliver
kernel-checked proofs, no `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`. If a statement appears false, stop
and report.
