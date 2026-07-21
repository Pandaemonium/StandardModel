# Lemma job: finite reflection positivity - the actual OS condition, not positive-definiteness

Mathlib-only. An earlier audit found that a module described as "reflection-positive"
in fact proved only POSITIVE-DEFINITENESS, which is a strictly weaker and different
condition. Prove the genuine finite Osterwalder-Schrader-type condition and separate
the two.

Setting: a finite configuration index set split as `Neg` (negative time) and `Pos`
(positive time) with a reflection involution `theta : Pos -> Neg` (a bijection), and a
real symmetric "measure" matrix `M` indexed by configurations.

Prove:
1. **Definition and basic form**: define reflection positivity as: for every function
   `f` supported on `Pos`, the reflected pairing
   `RP f = sum over p q in Pos of f p * M (theta p) q * f q` satisfies `RP f >= 0`.
   Show `RP` is the quadratic form of the block `M_{Neg,Pos}` composed with `theta`.
2. **RP is NOT positive-definiteness**: exhibit a symmetric POSITIVE-DEFINITE `M` (all
   eigenvalues positive) whose reflected block form `RP` takes a NEGATIVE value - so
   positive-definiteness does NOT imply reflection positivity.
3. **Converse also fails**: exhibit an `M` that IS reflection positive in the above
   sense but is NOT positive definite (has a negative eigenvalue).
4. **What RP does give**: prove that reflection positivity of `M` makes the reflected
   Gram form positive semidefinite, hence yields a well-defined inner product on the
   quotient by its null space - the step that produces a physical Hilbert space.
Deliver 1 and 4 as theorems, 2 and 3 as explicit small witnesses. This pins exactly
what a lattice bridge must prove and what it may not substitute.
No new axioms/native_decide; standard axioms; report axioms.
