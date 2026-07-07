import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.PSA

/-!
# Q12 charge-resolution bookkeeping

This module isolates the finite linear-algebra additivity step behind the Q12
charge-sector anomaly-gate audit.  It proves that a grading-weighted diagonal
supertrace decomposes as the sum of its charge/sector contributions, and that
total cancellation cannot hide a single nonzero sector contribution: another
sector must cancel it.

Claim boundary: these are finite accounting identities only.  They do not prove
an equivariant McKean-Singer theorem, anomaly cancellation, constraint
equivariance on a physical quotient, or any physical chirality result.

Provenance: `AgentTasks/fable_parallel/Q12_answer.md`; Aristotle project
`c2e23b53`, task `2dd7d98f`.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution

open Finset

variable {R : Type*} [CommRing R]
variable {iota omega : Type*} [Fintype iota] [Fintype omega] [DecidableEq omega]

/-- A grading-weighted diagonal supertrace of a finite matrix. -/
noncomputable def superTrace (grading : iota -> R) (A : Matrix iota iota R) : R :=
  ∑ i : iota, grading i * A i i

/-- The finite set of basis labels in a fixed charge/sector label. -/
def sectorFilter (sector : iota -> omega) (w : omega) : Finset iota :=
  univ.filter fun i => sector i = w

/-- The grading-weighted diagonal contribution from one sector. -/
noncomputable def sectorSuperTrace
    (sector : iota -> omega) (grading : iota -> R) (A : Matrix iota iota R)
    (w : omega) : R :=
  ∑ i ∈ sectorFilter sector w, grading i * A i i

/--
Finite charge-sector resolution for supertraces: the total diagonal
supertrace is the sum of the sector supertraces.
-/
theorem superTrace_eq_sum_sector
    (sector : iota -> omega) (grading : iota -> R) (A : Matrix iota iota R) :
    superTrace grading A = ∑ w : omega, sectorSuperTrace sector grading A w := by
  simp only [superTrace, sectorSuperTrace, sectorFilter]
  rw [Finset.sum_fiberwise univ sector fun i => grading i * A i i]

set_option linter.unusedFintypeInType false in
/-- If every sector contribution vanishes, then the total supertrace vanishes. -/
theorem superTrace_eq_zero_of_sectors
    (sector : iota -> omega) (grading : iota -> R) (A : Matrix iota iota R)
    (hsector : ∀ w : omega, sectorSuperTrace sector grading A w = 0) :
    superTrace grading A = 0 := by
  rw [superTrace_eq_sum_sector sector grading A]
  simp [hsector]

set_option linter.unusedFintypeInType false in
/--
Sector failures cannot be hidden by total cancellation.  If the total
supertrace is zero and one sector contribution is nonzero, then a different
sector contribution is also nonzero.
-/
theorem sector_failure_not_hidden
    (sector : iota -> omega) (grading : iota -> R) (A : Matrix iota iota R)
    (w0 : omega)
    (htotal : superTrace grading A = 0)
    (hfail : sectorSuperTrace sector grading A w0 ≠ 0) :
    ∃ w1 : omega, w1 ≠ w0 ∧ sectorSuperTrace sector grading A w1 ≠ 0 := by
  by_contra hcon
  push_neg at hcon
  apply hfail
  have hsum : ∑ w : omega, sectorSuperTrace sector grading A w = 0 := by
    rw [← superTrace_eq_sum_sector sector grading A]
    exact htotal
  rw [Finset.sum_eq_single w0] at hsum
  · exact hsum
  · intro w _ hw
    exact hcon w hw
  · intro hmem
    exact False.elim (hmem (Finset.mem_univ w0))

/-! ## Finite index specialization -/

/-- The total finite graded dimension. -/
noncomputable def sdim (grading : iota -> R) : R :=
  ∑ i : iota, grading i

/-- The finite graded dimension contribution from one charge/sector label. -/
noncomputable def chargeIndex (sector : iota -> omega) (grading : iota -> R)
    (w : omega) : R :=
  ∑ i ∈ sectorFilter sector w, grading i

/-- The total finite graded dimension is the sum of charge-sector indices. -/
theorem sdim_eq_sum_chargeIndex (sector : iota -> omega) (grading : iota -> R) :
    sdim grading = ∑ w : omega, chargeIndex sector grading w := by
  simp only [sdim, chargeIndex, sectorFilter]
  rw [Finset.sum_fiberwise univ sector fun i => grading i]

set_option linter.unusedFintypeInType false in
/--
Index-sector failures cannot be hidden by a zero total finite graded
dimension.
-/
theorem chargeIndex_failure_not_hidden
    (sector : iota -> omega) (grading : iota -> R) (w0 : omega)
    (htotal : sdim grading = 0)
    (hfail : chargeIndex sector grading w0 ≠ 0) :
    ∃ w1 : omega, w1 ≠ w0 ∧ chargeIndex sector grading w1 ≠ 0 := by
  by_contra hcon
  push_neg at hcon
  apply hfail
  have hsum : ∑ w : omega, chargeIndex sector grading w = 0 := by
    rw [← sdim_eq_sum_chargeIndex sector grading]
    exact htotal
  rw [Finset.sum_eq_single w0] at hsum
  · exact hsum
  · intro w _ hw
    exact hcon w hw
  · intro hmem
    exact False.elim (hmem (Finset.mem_univ w0))

/-! ## Honest finite direct-sum form -/

section DirectSum

variable {kappa : omega -> Type*}
variable [∀ w : omega, Fintype (kappa w)]

/-- Grading on a finite sigma-type direct sum, assembled from sector gradings. -/
def blockGrading (grading : ∀ w : omega, kappa w -> R) :
    (Sigma kappa) -> R :=
  fun p => grading p.1 p.2

/--
For an honest finite block-diagonal direct sum, the total supertrace is the sum
of the supertraces of the blocks.
-/
theorem superTrace_blockDiagonal'
    (grading : ∀ w : omega, kappa w -> R)
    (A : ∀ w : omega, Matrix (kappa w) (kappa w) R) :
    superTrace (blockGrading grading) (Matrix.blockDiagonal' A) =
      ∑ w : omega, superTrace (grading w) (A w) := by
  simp only [superTrace]
  rw [Fintype.sum_sigma]
  refine Finset.sum_congr rfl ?_
  intro w _
  refine Finset.sum_congr rfl ?_
  intro i _
  simp [blockGrading, Matrix.blockDiagonal'_apply_eq]

end DirectSum

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution.superTrace_eq_sum_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms superTrace_eq_sum_sector

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution.sector_failure_not_hidden' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sector_failure_not_hidden

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution.sdim_eq_sum_chargeIndex' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sdim_eq_sum_chargeIndex

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution.chargeIndex_failure_not_hidden' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chargeIndex_failure_not_hidden

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution.superTrace_blockDiagonal'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms superTrace_blockDiagonal'

end PhysicsSM.Draft.NullEdge.GateI1.ChargeResolution
