# Task: pure-spinor normal form (Selector step 2 - marked transitivity)

Project: Lean 4 (v4.28.0) + Mathlib. Ten-file package: eight PROVEN landed
modules (do not modify) + the target file with two holes. This job targets
EXACTLY ONE of them.

## Target

In `PhysicsSM/Draft/Spin10StandardizablePairs.lean`, prove

`exists_evenCliffordGroup_smul_eq_vacuum` : every nonzero pure spinor
(`IsPureSpinor` = nonzero + even chirality + Cartan quadric
`gammaBilinear psi psi = 0`) is carried to `vacuumSpinor` by some element
of `evenCliffordGroup`.

PRE-REGISTERED SCALAR LICENSE: if the group orbit only reaches
`c • vacuumSpinor` with `c ≠ 0`, prove THAT version under the new name
`exists_evenCliffordGroup_smul_eq_scalar_vacuum`, record the change
prominently in the docstring, and leave the original statement as a
documented hole ONLY if the scalar version genuinely cannot be upgraded
(check first whether `scalarUnit_mem`-style machinery in the landed
modules lets you absorb `c`).

DO NOT touch the second hole (`standardizable_of_genuine_krasnov_pair`) -
it needs further steps that are out of scope. Do not modify the eight
landed modules; add helper lemmas in the target file.

## Suggested route (5-mode Fock model is small and concrete)

`FockSpinor = Finset (Fin 5) → ℂ`; even spinors have support in degrees
{0, 2, 4} (1 + 10 + 5 = 16 coefficients).

1. **Vacuum-coefficient normalization.** Show some landed basis-orbit
   element (the `flipUnit` products behind
   `exists_evenCliffordGroup_smul_basisSpinor` in
   `SpinorTenfoldBasisOrbit`) moves any nonzero even spinor to one with
   `psi ∅ ≠ 0`: pick a minimal-cardinality support set `T` (degree 0, 2,
   or 4) and flip its modes down to `∅`. Minimality prevents cancellation
   in the `∅` coefficient.
2. **Exponential parametrization.** For `psi` with `psi ∅ = 1`, define the
   bivector element `B = ∑_{i<j} psi {i,j} • (creation_i ∘ creation_j)`
   (an even, nilpotent endomorphism from the landed CAR machinery). Its
   exponential is the FINITE sum `1 + B + B²/2` (B³ = 0 on 5 modes by
   degree), invertible with inverse `exp(-B)`, and lies in
   `evenCliffordGroup` (check the group's definition in
   `SpinorTenfoldCliffordGroup`; if membership needs a product-of-vectors
   form rather than exponentials, use the landed generators or report
   precisely which membership lemma is missing).
3. **Purity forces the degree-4 part.** The Cartan quadric
   `gammaBilinear psi psi = 0` (10 components) says exactly that the five
   degree-4 coefficients equal the corresponding Pfaffian-type quadratics
   in the degree-2 coefficients - i.e. `psi = exp(B) · vacuumSpinor`.
   Landed pairing lemmas (`chevalleyPairing_*`, `gammaBilinear_*`,
   `B10_gammaBilinear`) give the component formulas.
4. Conclude: `g = (normalizing flips)⁻¹ * exp(B)` sends `vacuumSpinor`
   to... (compose carefully in the correct direction; the statement wants
   `g · psi = vacuumSpinor`, so use inverses of the above).

A KERNEL COUNTEREXAMPLE to the statement (a nonzero even quadric spinor
NOT in the orbit) is a first-class outcome - the file's S1 history shows
refutations are valued here. But the classical Spin(10) pure-spinor
theory says the statement (possibly with the scalar) is true.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not change `IsPureSpinor`, `evenCliffordGroup`, or any landed
  definition.
- Verify with `lake env lean PhysicsSM/Draft/Spin10StandardizablePairs.lean`.

## Success criteria

The step-2 theorem proven (exact or scalar-licensed form) = full success.
If the exponential route stalls: land the normalization lemma (route
step 1) and the `exp(B) ∈ evenCliffordGroup` membership lemma separately,
plus a precise report of the remaining gap (which quadric component
identity failed, what Mathlib lemma is missing). Completion report:
statement changes (if any), axioms per theorem.

## RESTART ADDENDUM (2026-07-19 08:20)

The target file now carries the FIRST HARVEST: `creationRootEnd` and the
membership lemma `creationRootEnd_mem` (elementary creation-root operators
lie in `evenCliffordGroup` via an explicit gamma-unit factorization) are
already PROVEN - reuse them; do not modify. The remaining work is the two
stated chart lemmas: `exists_creationRoots_vacuum_eq_of_quadric` (finite
products of `creationRootEnd` realize any quadric-satisfying even spinor
with vacuum coefficient 1 - the bivector normal form, using the proven
membership lemma per mode pair) and
`exists_evenCliffordGroup_vacuum_coefficient_ne_zero` (signed mode flips
move a nonzero even quadric spinor into the affine vacuum chart; the
landed `flipUnit` basis-orbit machinery supplies the flips). Close the
original step-2 target from these two if reachable; otherwise land the
two chart lemmas alone. All other instructions unchanged.
