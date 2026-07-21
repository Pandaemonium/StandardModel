# Task: corrected S1 - genuine Krasnov pairs are standardizable (Spin(10) lane)

Project: Lean 4 (v4.28.0) + Mathlib. Spin(10) stabilizer program successor
job. Self-contained package (the full SpinorTenfold tree, the UPDATED
`Spin10StabilizerTransitivity.lean` with the integrated refutation +
`ProjectivelyDistinct` + `StandardizablePair` + the PROVED conditional
reduction, and the target file). Your predecessor project's PROOF_PLAN
decomposition is reproduced below - it is your roadmap.

## Target

`PhysicsSM/Draft/Spin10StandardizablePairs.lean` - three theorems ending in
a hole:

1. `exists_evenCliffordGroup_smul_eq_vacuum` (plan step 2): marked
   transitivity on ALL nonzero pure spinors, generalizing the landed
   even-wedge-monomial orbit results (`exists_evenCliffordGroup_smul_basisSpinor`,
   `exists_evenCliffordGroup_basisSpinor`).
2. `standardizable_of_genuine_krasnov_pair` (plan exit): purity +
   orthogonality + projective distinctness => the standard
   `(vacuumSpinor, weakSpinor)` normal form.
3. `evenCliffordGroup_transitive_on_genuine_krasnov_pairs` (corrected S1):
   follows from 2 plus the PROVED
   `evenCliffordGroup_transitive_on_standardizable_krasnov_pairs`.

## Roadmap (from the predecessor's proof plan; steps 1 and 3 need NEW
## definitions - introducing them is an expected deliverable)

1. Define the annihilator-dimension / relative-position invariant for
   arbitrary pure spinors; prove orthogonality + projective distinctness
   gives intersection dimension exactly three (excludes the diagonal
   stratum).
2. Prove marked transitivity on nonzero pure spinors (target 1).
3. Identify the stabilizer of `vacuumSpinor`; prove it acts transitively on
   pure spinors whose annihilator meets the vacuum annihilator in dimension
   three.
4. Use `scalarUnit_mem` to normalize the first marked scale, retaining only
   a nonzero projective scale on the second entry.
5. Conclude with the proved conditional reduction.

Useful landed results: `exists_evenCliffordGroup_vacuum_weak`,
`scalarUnit_mem`, the concrete purity/orthogonality lemmas for
`vacuumSpinor`/`weakSpinor`, and the whole `SpinorTenfoldBasisOrbit` module.

## Pre-registered honesty license

- If marked transitivity holds only up to a nonzero scalar
  (`g ψ = c • vacuumSpinor`), prove that version, rename it, thread the
  scale via `scalarUnit_mem`, and record the change prominently.
- If a target is FALSE as stated, refute it with a kernel counterexample
  (first-class outcome) and prove the strongest corrected version.
- If the full chain resists, prove targets in plan order and return a
  precise report of the exact missing sub-lemma (statement included) at the
  first blocker.
- Do not modify the included modules; do not weaken target 3.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/Spin10StandardizablePairs.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

Corrected S1 (target 3) proven is full success; targets 1-2 with a precise
blocker report is partial success. Completion report: solved targets, new
definitions introduced, statement changes, remaining holes, axioms used.
