# Task: prove the two reduction lemmas in PhysicsSM/Draft/H3OReductionLemmas.lean

Lean 4 (v4.28.0) + Mathlib project. The package contains a small octonion
library (`PhysicsSM/Algebra/Octonion/{Basic,Conjugation,Norm}.lean` - real
8-coordinate octonions with the XOR-basis product, `normSq` = sum of eight
coordinate squares, the composition law `normSq_mul : normSq (x*y) =
normSq x * normSq y`, and `normSq_eq_zero`). The target file's module
docstring carries the complete mathematical context and a detailed proof plan
for each lemma - follow it.

Two INDEPENDENT theorems, both currently `sorry`:

1. `exists_complex_witness` - octonion triple -> complex triple with equal
   norms and equal real triple product. Elementary: sqrt constructions + the
   composition law + a Cauchy-Schwarz-style coordinate bound
   (`c0^2 <= normSq`). Handle the degenerate zero-norm cases.
2. `hermitian_cubic_real_rooted` - the invariant triple of a 3x3 complex
   Hermitian matrix is the elementary-symmetric data of three reals. Route:
   Mathlib's Hermitian spectral theory (`Matrix.IsHermitian.eigenvalues`)
   plus explicit 3x3 trace/det/charpoly computation. The docstring licenses
   adjusting the matrix layout to hit the stated sign/conjugation pattern;
   if impossible, prove the true-pattern version and REPORT the discrepancy.

Constraints: no new axioms, no n a t i v e _ d e c i d e; standard axiom set
only; keep statements as licensed. Success = both theorems proven, file
compiles with zero sorries. Partial success (one of two) is acceptable -
complete what you can fully.
