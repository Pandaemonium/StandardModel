# Aristotle proof job: exact Dirac momentum-multiplier isometry

## Context

The changing-cell continuum chain now lands inverse-Fourier transport of the
full `L2` error. Aristotle strategy project
`5d4f2be5-f731-40ea-9dee-d5716b20be69` identified the first F2 proof rung:
package the existing exact Hermitian Dirac flow as a continuous linear map on
the Euclidean spinor and prove pointwise norm preservation. This is the input
for a representative-safe `L2` multiplier isometry.

## Immutable target

Create `PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`, importing
`ChangingCellFourierL2`, and preserve the repository types and conventions.
The target declarations are:

```lean
/-- Exact momentum-space Dirac multiplier as a bounded operator on the spinor. -/
def momMult (m t : Real) (k : FourierMomentum3) : Spinor ->L[Complex] Spinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex)
    (exactFlow (k 0) (k 1) (k 2) m t)

/-- Pointwise unitarity of the exact Hermitian-generated multiplier. -/
theorem momMult_isometry (m t : Real) (k : FourierMomentum3) (v : Spinor) :
    norm (momMult m t k v) = norm v := by
  sorry
```

Use the actual argument name accepted by `Matrix.toEuclideanCLM` in this pinned
Mathlib (`k` versus `R`/implicit syntax is a syntactic adjustment only). Do not
change the mathematical statement, types, exact flow, or norm.

## Required route and controls

- Reuse `Compact3Plus1DiracRate.exactFlow_mem_unitary`; do not reprove the
  matrix exponential or replace it by an assumed isometry.
- Make the matrix-to-Euclidean-space action explicit and prove that it preserves
  the project Hermitian spinor norm.
- Include the controls `t = 0`, `v = 0`, and the nonzero exact rest witness
  `m = 4`, `k = (3,0,0)` (the theorem is universal, so controls may be
  corollaries or examples).
- Keep the expected footprint to the standard kernel axioms only. No
  `native_decide`, new axiom, opaque placeholder, or theorem weakening.
- Run `lake env lean PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`
  before any broad build.

## Boundary

This theorem is pointwise norm preservation only. It does not by itself prove
measurability, the `L2` multiplier lift, Fourier transport, the PDE, strong
continuity, a continuum limit, or Lorentz restoration.

Success is the exact proof, plus any small reusable helper lemma. If the target
is blocked by a genuine API mismatch, return the smallest elaborating
replacement statement and the exact missing bridge; do not silently weaken it.

## Submission metadata

- Aristotle project: `e790e78a-eab4-4ddd-bfa6-719a302efb5f`
- Submission project: `AgentTasks/aristotle-submit/cont-mom-mult-isometry-20260712-project`
- Lab work item: `CONT-FOURIER-001`
- Output: `AgentTasks/aristotle-output/e790e78a-eab4-4ddd-bfa6-719a302efb5f/`
- Integrated module: `PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean`
- Status: integrated 2026-07-13 by Codex

## Harvest review

The returned `ChangingCellFourierPDE.lean` proved the immutable pointwise
isometry target from `Compact3Plus1DiracRate.exactFlow_mem_unitary` and included
the required zero-time, zero-spinor, and nonzero rest controls. The proof was
replayed in the live pinned checkout before integration. Its axiom footprint is
build-pinned to `[propext, Classical.choice, Quot.sound]` both locally and in
`OvernightTheoryAxiomGuard`.

Aristotle also returned a stale `GeneralMaxEntropy.lean` that was unrelated to
this task and omitted an existing theorem. It was not integrated.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/ChangingCellFourierPDE.lean
lake build PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE
lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard
```

The top-level `PhysicsSMDraft.lean` direct check remains unavailable in this
native Windows checkout because its optional Sphere-Packing import is enabled
only in the separate Linux/SPL environment.
