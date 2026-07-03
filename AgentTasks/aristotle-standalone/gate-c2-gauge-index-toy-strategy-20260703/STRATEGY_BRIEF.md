# Gate C2 strategy brief: a finite gauge toy with nonzero overlap index

You (Aristotle) are a co-equal planning partner for a Lean 4 / Mathlib
formalization program. This is a STRATEGY / DESIGN request, not (yet) a proof
request. Assume you are blind to the wider repository; all needed context is in
this brief and the three attached Lean files (which compile under Lean 4
`v4.28.0` + Mathlib, draft-trust, kernel-checked, axioms
`[propext, Classical.choice, Quot.sound]`).

## Program context

The "null-edge" program is building a finite, kernel-checked lattice chiral
fermion (overlap / Ginsparg-Wilson) construction on a tetrahedral regulator. We
have COMPLETED the free (no-gauge) chiral release, entirely at draft-trust and
kernel-checked:

- Abstract GW algebra (`OverlapGinspargWilson.lean`): for a chirality involution
  `gamma5` (`gamma5^2 = 1`) and a sign-like involution `eps` (`eps^2 = 1`), the
  overlap Dirac matrix `Dov = 1 + gamma5 * eps` satisfies the Ginsparg-Wilson
  relation `gamma5 * Dov + Dov * gamma5 = Dov * gamma5 * Dov`.
- The concrete tetrahedral free operator supplies `eps = sign(H)` ELEMENTARILY,
  because the free Hermitian sign kernel satisfies `H(k)^2 = coeff(k) . I`
  (Clifford SCALAR square) per momentum `k`. Hence `sign(H) = coeff^{-1/2} . H`
  is an explicit self-adjoint involution with NO functional calculus. This was
  adversarially validated as faithful (it genuinely equals the spectral
  `H (H^2)^{-1/2}`). We lifted it to a real-space operator `sign(Hfree)`
  (self-adjoint involution), the operator GW relation, and operator Weyl
  (chirality) projectors `P+/- = (1 +/- sign(Hfree))/2`.

- Index ALGEBRA (`OverlapIndexToy.lean`): the Luscher modified chirality
  `Ghat = gamma5 (1 - (1/2) Dov)`, the lattice chiral index
  `overlapIndex gamma5 eps = trace Ghat`, and the exact identity
  `overlapIndex = (1/2)(trace gamma5 - trace eps)`. Zero-index if `eps`
  anticommutes `gamma5`; an explicit `Fin 2` commuting witness with index 1.

- Index INTEGRALITY (`OverlapIndexIntegrality.lean`, our newest result):
  `overlapIndex gamma5 eps` is an INTEGER for any involutions, equal to
  `trace(specProj gamma5) - trace(specProj eps)` where `specProj M = (1+M)/2`,
  a difference of eigenprojector ranks (trace of idempotent = `finrank` of range
  over char-0, via `LinearMap.IsProj.trace` and `Matrix.trace_toLin'_eq`). Needs
  only the involution property, not Hermiticity.

## The crux (why C2 is hard)

The elementary-sign shortcut `sign(H) = coeff^{-1/2} H` depends ENTIRELY on
`H^2 = scalar . I`, which holds only in the free, translation-invariant case
(each momentum block is a single Clifford element). A gauge background - link
variables `U` decorating the tetrahedral edges, covariant difference
`Q -> Q_U` - destroys translation invariance, so there is no momentum
block-diagonalization and `H_U^2` is NOT a scalar multiple of the identity.
Therefore `sign(H_U)` becomes a genuinely nonlocal spectral object and the
elementary-sign trick does not transfer. This is the wall between "free chiral
fermions" (done) and "nonzero topological index / chiral gauge theory".

We do NOT want to build a general functional calculus. We want the SMALLEST
finite, kernel-checkable milestone that exhibits a NONZERO overlap index tied to
a discrete topological charge.

## Your task

Design the cleanest FINITE, Lean-4/Mathlib-provable (kernel-checked, no
`native_decide`, no functional calculus) toy in which `overlapIndex gamma5 eps_U`
is NONZERO and provably equals a discrete topological charge (winding number,
U(1) flux, or degree). Concretely, address:

1. **Minimal lattice + gauge data.** What is the smallest gauge-decorated finite
   model that carries nontrivial topology reachable by our `overlapIndex`? (E.g.
   2-site Wilson line, a single 2D U(1) plaquette / discrete torus with fixed
   flux, a `Fin n` clock model.) Give the explicit matrices where possible.

2. **Handling `sign(H_U)` without the scalar square.** For your toy, how is the
   sign-like involution `eps_U` obtained as an EXPLICIT self-adjoint involution
   (`eps_U^2 = 1`) when `H_U^2` is not scalar? Options to weigh: (a) small enough
   that the two-band spectral projector is closed-form; (b) a gauge choice where
   `H_U^2` is still block-scalar; (c) defining `eps_U` directly as the correct
   involution and separately proving it is `sign(H_U)`. Which is cleanest to
   formalize?

3. **The topological charge and the index = charge proof.** What is the discrete
   invariant, and what is the cleanest Lean proof that `overlapIndex = charge`?
   Reuse `overlapIndex_eq` / `overlapIndex_isInteger` (attached) where possible.

4. **Mathlib leverage.** Name the specific Mathlib API (matrices, `finrank`,
   traces, roots of unity, `ZMod`, determinant/winding) most likely to make each
   step short.

5. **First target statement.** Write the exact Lean theorem statement (signature)
   you would attack FIRST - the smallest nonzero-index milestone - and a brief
   proof sketch. Flag any place a hidden analytic or convention assumption could
   sneak in.

## Output format

Ranked list of 1-3 concrete construction proposals (most tractable first). For
the top proposal, give the explicit matrices, the exact first Lean theorem
statement, a proof sketch keyed to Mathlib lemma names, and the main risk. Be
concrete and skeptical: if a proposed toy actually has index 0 (a common trap -
e.g. anticommuting `eps` forces index 0), say so and explain why.
