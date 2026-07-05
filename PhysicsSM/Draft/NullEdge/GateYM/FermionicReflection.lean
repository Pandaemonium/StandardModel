import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonDiracOperator

/-!
# QMF5 Deliverable-1 scaffold: the temporal reflection for fermionic RP

Foundation for the finite fermionic reflection-positivity (RP-F) construction
(QMF5 Deliverable 1; design DAG in
`AgentTasks/fourday-ym-run-2026-07-05/QMF5_DESIGN_HARVEST.md`, Aristotle job
`d1e7bece`). This module begins the concrete lattice scaffolding whose
linear-algebra core is already proved:

- `WilsonProjectors`: the Wilson spin projectors `P+- = (1 -+ gamma_mu)/2` are
  orthogonal Hermitian projectors, and `A^dagger P A` is PSD (the RP-F node-N5
  Gram conclusion, in abstract form).

What remains to assemble RP-F is the concrete lattice reflection data. This file
lands the first piece: the **temporal reflection involution on sites**.

## The reflection convention (LINK reflection, not site reflection)

Following the design's Risk-R2 resolution, the mirror plane passes through the
midpoints of the temporal links between time-slices `t = 0` and `t = 1`, so the
reflection is `t |-> 1 - t` on the periodic time coordinate (`0 <-> 1`,
`2 <-> L-1`, ...), NOT a site reflection `t |-> -t` (which would fix `t = 0`).
The time direction is index `timeDir` of `Site L = Fin 4 -> Fin L`.

## Remaining RP-F DAG (next QMF5 cycle; recorded here so the scaffold is legible)

- `rpFReflection` : the reflection unitary `Theta = (site permutation by timeRefl)
  tensor gamma0` on `Idx L nc`; prove `Theta^dagger Theta = 1` and `Theta` an
  involution.
- `rpF_reflection_hermiticity` : `Theta D Theta = D^dagger` (the temporal-
  reflection analogue of QMF4's `gamma5_hermiticity`, same gamma lemmas).
- `reflectedWilsonBlock` + `reflectedWilsonBlock_eq_gram` : the reflected
  positive-half block is `M^dagger M` (node N5; its abstract PSD core is the
  already-proved `WilsonProjectors.conj_projector_posSemidef`).
- measure wrap : feed the Gram data as a factorized/mixture cut kernel into
  `ReflectionPositivityKernel.reflectionForm_nonneg`, weighted by the nonnegative
  paired-flavor determinant (`WilsonDiracOperator.pairedFlavor_det_nonneg`).

## Claim discipline

Claim label: **finite identity** (a finite involution on a finite index set; no
analysis). Draft-trust, kernel-checked, `s o r r y`-free. Prerequisites:
`WilsonDiracOperator` (for `Site`, `shiftUp`/`shiftDn` conventions). Successor:
the reflection unitary and the reflected-block factorization above.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace FermionicReflection

open PhysicsSM.Draft.NullEdge.GateYM.Qmf4bWilson

/-- The Euclidean time direction of `Site L = Fin 4 -> Fin L`. Chosen as index
`0`; the spatial directions are `1, 2, 3`. (The Wilson-Dirac operator treats all
four directions symmetrically, so any fixed choice is a convention.) -/
def timeDir : Fin 4 := 0

/-- **Temporal (link-plane) reflection on sites**: flips the time coordinate by
`t |-> 1 - t` on the periodic time axis, fixing the spatial coordinates. The
mirror plane sits between slices `t = 0` and `t = 1` (link reflection). -/
def timeRefl [NeZero L] (x : Site L) : Site L :=
  Function.update x timeDir (1 - x timeDir)

/-- The temporal reflection is an involution (`timeRefl` composed with itself is
the identity): `1 - (1 - t) = t` on the time coordinate, and the spatial
coordinates are untouched. -/
theorem timeRefl_involutive [NeZero L] : Function.Involutive (timeRefl (L := L)) := by
  intro x
  unfold timeRefl
  rw [Function.update_idem]
  rw [Function.update_self]
  rw [sub_sub_cancel]
  rw [Function.update_eq_self]

/-- The temporal reflection genuinely moves the boundary time-slice (`t = 0` maps
to `t = 1`), confirming it is a LINK reflection (no fixed `t = 0` slice), given
`L >= 2`. -/
theorem timeRefl_zero_slice [NeZero L] (h2 : 2 ≤ L) (x : Site L) (hx : x timeDir = 0) :
    (timeRefl x) timeDir = 1 := by
  unfold timeRefl
  rw [Function.update_self, hx, sub_zero]

end FermionicReflection
end PhysicsSM.Draft.NullEdge.GateYM
