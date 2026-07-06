# OctonionMassCoupling — delivery report

## Deliverable

`OctonionMassCoupling.lean`, namespace
`PhysicsSM.Algebra.Furey.OctonionMassCoupling`. A concrete, kernel-checked
**coupling relation** between the octonionic `SU(3)` color structure and a
mass-like grading operator, going beyond charge co-location.

## Build status

* `OctonionMassCoupling.lean` **type-checks and builds cleanly** (no errors, no
  warnings): `lake build OctonionMassCoupling` → `Build completed successfully`.
* The two pre-existing files (`Basic.lean`, `ColorTripletFundamental.lean`) do
  **not** build in this repository: they import upstream modules
  (`PhysicsSM.Algebra.Octonion.ComplexOctonion`,
  `PhysicsSM.Algebra.Furey.OperatorAlgebra`, `...ColorRepresentation`,
  `...ConventionBridge`) that are **absent from this project**. This is a
  pre-existing condition, not introduced here. Per the task's escape hatch
  ("if a full build stalls on absent deps, skip it and return the typechecking
  file + report"), the new file was made **self-contained** on Mathlib and does
  not import those missing modules.

## How it stays faithful without the missing octonion stack

Because the upstream octonion/operator modules are unavailable, the new file
reconstructs — **at the linear-operator level** — the exact color action table
that `ColorTripletFundamental` proves on the triplet `{v4, v5, v6}`:

* Cartan weights `w4 = (-1,-1)`, `w5 = (1,0)`, `w6 = (0,1)`;
* ladder actions `T12 v6 = v5`, `T21 v5 = v6`, `T13 v6 = -v4`, `T31 v4 = -v6`,
  `T23 v5 = v4`, `T32 v4 = v5`, all others zero.

These are realized as `3 × 3` complex matrices on the basis `(v4,v5,v6) ↔
(e0,e1,e2)`. In Furey's construction the color generators come from octonion
**left-multiplication** maps `L_x : y ↦ x·y`, which are linear despite octonion
nonassociativity. All algebra here composes such linear operators (matrix
products) — **no raw octonion products are formed**, honoring the nonassociativity
caution.

## The coupling that is established

Let `M = diag(m0, m1, m2)` be the mass grading (a diagonal mass functional
assigning a value to each color state); `⁅G, M⁆ = G·M − M·G`.

* `mass_comm_cartan_zero` — **co-location**: `M` commutes with both color Cartan
  generators `H23`, `H13`.
* `mass_comm_ladder_{T23,T32,T12,T21,T13,T31}` — **coupling**: for each ladder
  `T`, `⁅T, M⁆ = (m_j − m_i) • T`, a definite mass splitting on the root
  generator.
* `mass_not_central_of_split` / `mass_grading_not_central` — **headline**: a
  non-degenerate mass (`m0 ≠ m1`, and concretely `diag(1,2,3)`) does NOT commute
  with the color ladder `T23`; the mass grading is not central w.r.t. color.
* `mass_covariant_not_invariant` — **covariance**: some color generator acts
  non-trivially on `M`; combined with the ladder identities, `M` transforms as a
  definite tensor (covariant), not a singlet (invariant).
* `scalar_mass_central` — **contrast**: a color-blind scalar mass `m • 1`
  commutes with every operator (the trivial co-location case), delimiting exactly
  what non-degeneracy adds.
* `generators_traceless` — sanity: the eight generators are traceless (`su(3)`).

## What is NOT established

A finite structural identity only. NOT a derivation of the SM Yukawa sector,
physical quark masses, electroweak symmetry breaking, or any dynamical mass
mechanism. The "mass operator" is a chosen grading exhibiting the algebraic
coupling.

## Axiom footprint

Every theorem depends only on the standard axioms `propext`, `Classical.choice`,
`Quot.sound`. No `sorry`, no `axiom`, no `native_decide`. Verified via
`#print axioms` on `mass_grading_not_central`, `mass_covariant_not_invariant`,
`scalar_mass_central`, `mass_comm_cartan_zero`, `mass_not_central_of_split`,
`generators_traceless`.
