/-
# The equivariant graded index: the program's candidate organizing theorem

DRAFT (kernel-clean; no `s o r r y`). The structural core of the finite
equivariant-index framework proposed in Fable call-03 (Part A), overnight
all-mass run 2026-07-08. Full design + corollary map:
`AgentTasks/overnight-allmass-run-2026-07-08/CALL03_UNIFIER_S6WITNESS_MASSGAP.md`.

## The framework (why one theorem organizes §§4, 6, 8)

Three gradings the program discovered separately - the chirality `Gamma`,
the closure bivector `b = sigma_z (x) 1` (S1-CC), and the
edge-orientation-reversal grading of the GW structure - are all ODD
elements of ONE symmetry group acting on the decorated complex; gauge
transformations and the reflection `R` (C4) are EVEN elements. The master
invariant is the equivariant supertrace `tr(Gamma g | sector)`, and its
three uses are `g = 1` (McKean-Singer index protection,
`chiralIndex_eq_graded_dimension`), `g = R` (the C4 sectored pinning), and
"an odd element exists" (S1-CC: the closure form has an exact supersymmetry,
so its Witten index vanishes sector-by-sector, forcing balanced inertia).
In the code `b` and the C4 witness grading are LITERALLY the same matrix
`sigma_z` - that identity is the framework, not a coincidence.

## What this file lands (the structural core)

* `IsOddInvolutionFor`, `IsEvenSymmetryFor`: the shared data (an odd
  involution grading, an even commuting symmetry).
* `chiralProduct_involution`: for an odd involution `Gamma` and a unitary
  `W` with `Gamma W Gamma = Wᴴ` (the repo's `ChiralInvolution`), the
  product `C := Gamma * W` is an involution (`C^2 = 1`). This is the
  algebraic heart of the sector index: `C` an involution means `V`
  splits into its `+-1` eigenspaces, which (with `Gamma`'s split) is what
  pins the `+-1` modes of `W` (clause (iii)) - and is the multiplicative
  face of the same `X ~ -X` anticonjugation that gives the additive
  balanced inertia (clause (i), S1-CC).

## Claim boundary

Structural core only. The substance - L3 `graded_supertrace_localizes_to_kernel`
(the finite McKean-Singer-Lefschetz engine, re-deriving the index family),
L4 `sector_involution_pinning` (C4), the balanced-inertia capstone (L2), and
the RG-Schur bridge (L5, grade C) - are documented M-targets in the call-03
doc, requiring the spectral/eigenspace API and handed off. This file makes
the framework's shared object concrete and kernel-checked, so the
corollaries have a common home.

## Provenance

Fable call-03 (2026-07-08), Part A - the organizing theorem and its Lean
design - [orig]/[interp]; the involution algebra is elementary - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Shared data (odd face).** `Gamma` is an odd involution for the
operator `X`: a Hermitian self-inverse grading anticommuting with `X`. The
additive-face hypothesis of the master theorem (S1-CC / index protection). -/
structure IsOddInvolutionFor (Gamma X : Matrix n n ℂ) : Prop where
  invol : Gamma * Gamma = 1
  herm : Gammaᴴ = Gamma
  anti : Gamma * X = -(X * Gamma)

/-- **Shared data (even face).** `g` is an even symmetry: it commutes with
both the operator `X` and the grading `Gamma`. The gauge group and the C4
reflection `R` are even elements. -/
structure IsEvenSymmetryFor (g X Gamma : Matrix n n ℂ) : Prop where
  commX : g * X = X * g
  commGamma : g * Gamma = Gamma * g

/-- **The chiral product is an involution (the sector-index heart).** For an
odd involution `Gamma` (`Gamma^2 = 1`) and a unitary `W` (`Wᴴ W = 1`) with
`Gamma W Gamma = Wᴴ` (the multiplicative face), `C := Gamma * W` satisfies
`C^2 = 1`. So `V` splits into `C`'s `+-1` eigenspaces, and together with
`Gamma`'s split this pins the `+-1` eigenvalues of `W` - the multiplicative
face of the same anticonjugation that gives the additive balanced inertia. -/
theorem chiralProduct_involution (Gamma W : Matrix n n ℂ)
    (hchiral : Gamma * W * Gamma = Wᴴ) (hU : Wᴴ * W = 1) :
    (Gamma * W) * (Gamma * W) = 1 := by
  rw [← mul_assoc (Gamma * W) Gamma W, hchiral, hU]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.chiralProduct_involution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiralProduct_involution

end PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex
