# Torus-genuine doubling frontier report

## Completed Lean targets

The first four declarations in `Strict3Plus1TorusDoubling.lean` are proved:

1. `latticeCongruentZero_origin`, with integer witness `n = 0`.
2. `latticeCongruentZero_two_pi`, with witness `n = (1,0,0)`.
3. `not_latticeCongruentZero_all_pi`; specializing a hypothetical witness at coordinate zero and using `Real.pi_pos` rules out every integer value of that coordinate. No irrationality of `π` is used.
4. `splitU_torus_doubling`, witnessed by the all-`π` corner. The proof directly computes the `-1` Floquet determinant.

The statement of `admissible_doubling_torus` was not changed and remains open.

## Why the proposed axis-IVT route is insufficient as stated

A scalar intermediate-value argument cannot be applied directly to a matrix-valued unitary loop: eigenvalues can collide and exchange labels, while `det(U-I) det(U+I)` is complex-valued. A proof along an axis therefore needs a continuous spectral projection/eigenphase construction or spectral flow, not only the ordinary real intermediate value theorem.

More importantly, the fields of `AdmissibleWalk` impose no chiral symmetry and the four-component Dirac tangent contains the two opposite Weyl sectors at the same point. Thus the net local first-Chern charge may cancel. Before developing a universal degree argument, the following candidate counterexample should be formalized or ruled out.

## Candidate counterexample (not yet kernel-verified)

Let `α₁, α₂, α₃, β` be the existing Hermitian, pairwise anticommuting Dirac matrices. Put

\[
 s(q)=\sum_{j=1}^3(1-\cos q_j),\qquad
 K(q)=\frac12\left(\sum_{j=1}^3\sin(q_j)\alpha_j+s(q)\beta\right),
\]

and take the Cayley transform

\[
 U(q)=(I-iK(q))(I+iK(q))^{-1}.
\]

This is a concrete candidate for an `AdmissibleWalk` whose combined crossings are all on the origin lattice:

- `K` is Hermitian, so its Cayley transform is unitary; trigonometric periodicity gives `2π`-periodicity and continuity.
- `K(0)=0`, hence `U(0)=I`.
- Along axis `j`, `K'(0)=α_j/2`; differentiating the Cayley transform gives `U'(0)=-iα_j`, exactly the required Dirac tangent.
- Clifford anticommutation gives
  \[
  K(q)^2=\frac14\left(\sum_j\sin^2(q_j)+s(q)^2\right)I.
  \]
  The scalar vanishes exactly when every `cos q_j = 1`, hence exactly on the `2π` lattice.
- A finite Cayley transform has no eigenvalue `-1`, and it has eigenvalue `+1` exactly when `K` is singular. Consequently this candidate would have `ZeroOrPiAlias (U q)` exactly at lattice-congruent momenta and would refute `admissible_doubling_torus`.

The last conclusion is a proof plan, not a verified result. The matrix inverse, derivative, and spectral equivalences still need Lean proofs.

## At most three follow-up lemmas

1. **Dirac-square lemma:** prove the displayed formula for `K(q)^2`, deduce invertibility away from `LatticeCongruentZero`, and prove that its scalar coefficient vanishes exactly on the `2π` lattice.
2. **Cayley package lemma:** for Hermitian `K`, prove unitarity and continuity of `(1-iK)(1+iK)⁻¹`, together with `det(U+1) ≠ 0` and `det(U-1)=0 ↔ det K=0`.
3. **Cayley-walk lemma:** prove periodicity, origin normalization, and the three `HasDerivAt` conditions for the concrete `K`; package it as `AdmissibleWalk` and use lemmas 1–2 to prove the negation of `admissible_doubling_torus`.

## Verification footprint

Each of the four completed declarations was checked to use only `propext`, `Classical.choice`, and `Quot.sound`. The target module compiles with exactly the remaining `sorry` in `admissible_doubling_torus`.
