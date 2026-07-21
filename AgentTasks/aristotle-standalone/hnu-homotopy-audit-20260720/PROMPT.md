# Audit/lemma job: independent scrutiny of a massive-gap homotopy claim (3+1 lane)

Mathlib-only. A Floquet/HNU 3+1 construction claims that a one-parameter family
of massive walks `U(a,k)` (mass angle `a in (0,pi)`, momentum `k` in a compact
Brillouin cube) is a homotopy of gapped unitaries - the gap (no +1/-1 eigenvalue)
persists across the whole family, so the topological invariant is constant.
Independently test the ABSTRACT claim that a continuous family of gapped unitaries
has a homotopy-invariant spectral flow, Mathlib-only:
1. for a continuous path `t -> U t` of unitary `m x m` matrices with
   `det(U t - 1) != 0` and `det(U t + 1) != 0` for all `t in [0,1]`, prove the
   number of eigenvalues in the upper half-circle (arg in (0,pi)) is CONSTANT along
   the path (a discrete continuous integer is constant);
2. exhibit a concrete 2x2 gapped path where the two endpoints have the SAME such
   count, and a NON-gapped path (crossing +1) where it JUMPS, showing the gap
   hypothesis is essential;
3. state precisely what additional input (orientation/chirality of each crossing)
   the FULL Floquet invariant needs beyond this eigenvalue count.
Deliverable: the invariance lemma + the essential-gap witness + the missing-input
statement. No new axioms/native_decide; standard axioms; report axioms.
