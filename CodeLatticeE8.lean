import CodeLatticeE8.Publication.TheoremIndex

/-!
# CodeLatticeE8

Clean, paper-facing root for the Hamming-code-to-E8 development.

This root begins the publication package with the finite coding-theory and
integer-lattice layer:

- the concrete extended Hamming `[8,4,4]` code;
- structural certificates for its weight distribution and code parameters;
- self-duality and Type II status of the concrete Hamming code;
- the uniqueness theorem for binary `[8,4,4]` codes;
- the Construction A integer model for the Hamming code, including the
  nonzero minimum squared norm statement and the generic doubly-even
  mod-four norm theorem;
- explicit Hamming Construction A basis vectors and their Gram matrix.
- an explicit coefficient map proving those vectors span the whole Hamming
  Construction A integer lattice.
- the rational normalization that divides the integer Gram form by two,
  giving the usual E8 root squared norm `2`.
- determinant computations showing the unscaled Gram determinant is `256` and
  the scaled E8 Gram determinant is `1`.
- the scaled minimum squared norm theorem in that E8 normalization.

This root is intended to be standalone: publication modules should import only
Mathlib and other `CodeLatticeE8.*` modules.
-/
