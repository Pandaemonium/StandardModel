# PROOF JOB: the perp-signature lemma for indefinite Hermitian forms (finite dimensions)

## Context (self-contained)

We formalize finite Krein/Pontryagin geometry in Lean 4 + Mathlib. The two
included files show our working style and infrastructure (a kappa = 2
fundamental-symmetry witness on `EuclideanSpace C (Fin 4)`; a Krein form
`kreinForm Gamma x y = inner C x (Gamma y)` for a self-adjoint involution
`Gamma`). We now need the workhorse of finite Gupta-Bleuler theory: the
signature of an orthogonal complement with respect to an INDEFINITE Hermitian
form. Mathlib has no indefinite Witt theory in this form, so part of the job
is designing the Mathlib-native statement; we state our preferred shape below,
but you may improve it if you keep the mathematical content identical and say
so.

## Setting (preferred concrete carrier)

Work on `V := EuclideanSpace C (Fin n)` with a FUNDAMENTAL SYMMETRY
`J : V ->l[C] V` (hypotheses: `LinearMap.adjoint J = J` and
`J ∘l J = LinearMap.id`), defining the indefinite Hermitian form
`B x y := inner C x (J y)`. For a subspace `S : Submodule C V`, define (as
definitions in the file):

- `posDim B S` / `negDim B S`: the maximal dimension of a subspace of `S` on
  which `B` restricts positive definite / negative definite (or an equivalent
  eigenvalue-count formulation if you prefer - state the equivalence);
- `radDim B S := Module.finrank C (S ⊓ orthoB B S)` where
  `orthoB B S := {x | ∀ s ∈ S, B s x = 0}` (the B-orthogonal complement,
  which you should define as a `Submodule`).

Write `(a, b, r) := (posDim B S, negDim B S, radDim B S)` and
`(p, q) := (posDim B ⊤, negDim B ⊤)`; nondegeneracy of `B` on `V` follows
from J invertible - prove it as a lemma (`radDim B ⊤ = 0`).

## The target theorems (in dependency order; all finite-dimensional)

1. `finrank_orthoB` : `finrank (orthoB B S) = n - finrank S + radDim B S`.
2. `dim_count` : `posDim B S + negDim B S + radDim B S = finrank S`
   (existence of a B-adapted basis of S; Gram-Schmidt-style induction on the
   nondegenerate part).
3. **`perp_signature` (the goal)** :
   `posDim B (orthoB B S) = p - posDim B S - radDim B S` and
   `negDim B (orthoB B S) = q - negDim B S - radDim B S`, and
   `radDim B (orthoB B S) = radDim B S`
   (equivalently: `S` and `orthoB B S` share their radical `S ⊓ orthoB B S`).
4. `isotropic_corollary` (finite Gupta-Bleuler, the payoff; a short corollary):
   if `B` vanishes identically on `S` (isotropic) and `finrank S = q`, then
   `negDim B (orthoB B S) = 0`, `radDim B (orthoB B S) = q`, and the radical
   of `orthoB B S` is `S` itself - so the induced form on the quotient
   `orthoB B S / S` is positive definite of dimension `p - q`.

## Constraints and guidance

- No `sorry`, no new axioms, no `native_decide`. Axiom footprint must be
  within `[propext, Classical.choice, Quot.sound]`.
- Everything is finite-dimensional linear algebra: Witt decomposition of the
  nondegenerate part into a positive part, negative part, and hyperbolic
  planes; Cauchy-interlacing-style dimension counting. No analysis, no
  spectral theory needed (you MAY use Mathlib's eigenvalue machinery for
  Hermitian matrices if it shortens proofs, but the statements must stay in
  the form above).
- If `posDim`/`negDim` are more tractable via a diagonalizing basis
  (`Matrix.IsHermitian.eigenvalues` of the Gram matrix), you may define them
  that way and prove the max-subspace characterization as a bridging lemma -
  the bridging lemma is then REQUIRED, since downstream files use the
  subspace form.
- Namespace: `PhysicsSM.Draft.NullEdge.Carrier.GB` (self-contained file,
  `import Mathlib` only; do NOT import the two context files - they are for
  style/convention reference).
- Docstrings on every public declaration; module docstring explaining the
  finite Gupta-Bleuler purpose and citing Bognar, *Indefinite Inner Product
  Spaces* (1974), Ch. I-II as the classical source (clean-room formalization).

## Deliverable

One Lean file `GBPerpSignature.lean` with the four theorem groups above,
compiling against current Mathlib. If theorem 3 resists in full generality,
deliver 1 + 2 + 4 with 3 stated and the blocker documented precisely - the
isotropic corollary (4) is the load-bearing piece for our program and can be
proved directly from a Witt-style decomposition even if the general
perp-signature formula lags.
