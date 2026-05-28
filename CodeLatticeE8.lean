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
- the general Type II Construction A bridge: doubly-even codes give even
  scaled real norms, and self-dual codes give the set-theoretic real dual
  identity after the conventional `1 / sqrt 2` scaling;
- explicit Hamming Construction A basis vectors and their Gram matrix.
- an explicit coefficient map proving those vectors span the whole Hamming
  Construction A integer lattice.
- the rational normalization that divides the integer Gram form by two,
  giving the usual E8 root squared norm `2`.
- determinant computations showing the unscaled Gram determinant is `256` and
  the scaled E8 Gram determinant is `1`.
- the scaled minimum squared norm theorem in that E8 normalization.
- the 240-element short shell enumeration (E8 kissing number).
- the E8 root list in doubled integer coordinates and its semantic characterization.
- the Hadamard bridge bijecting the Construction A short shell with the root list.
- a standalone Cayley-Dickson octonion convention, coordinate multiplication,
  norm multiplicativity, and structural closure of the octavian unit shell.
- the E8 Cartan matrix in Bourbaki labelling, with determinant `1`.
- the Gram–Cartan congruence `Pᵀ G P = 2 · Cartan`.
- unimodularity of the change-of-basis matrix `P` (derived algebraically).
- explicit E8 simple roots in Construction A coordinates, with Gram matrix
  reproducing the E8 Dynkin diagram.
- Weyl reflections on the doubled-coordinate root list, including closure and
  involutivity.
- the first semantic theta shells (`q^0` and `q^1`), a finite Hamming
  weight-contribution table check matching the normalized `E4` coefficients
  through `q^6`, and an all-shell semantic Construction A convolution theorem.

The root-list, root-bridge, short-vector count, octonion norm identity,
octavian unit closure, small theta arithmetic, Construction A theta
convolution, Cartan determinant, and Weyl reflection layers have all been
upgraded away from compiler-trusted native evaluation.  The theta material
here is still finite/combinatorial, not the full analytic identity
`Theta_E8 = E4`; that bridge remains in the optional `CodeLatticeE8SPL` layer.

This root is intended to be standalone: publication modules should import only
Mathlib and other `CodeLatticeE8.*` modules.
-/
