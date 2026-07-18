import Mathlib

/-!
# Chiral spiral commutators

This draft module isolates a finite chiral-basis Dirac avatar of the spiral
picture.  At unit momentum along `+z`, the transverse velocity ladders have
opposite commutator signs in the two chirality blocks, their double
commutator has eigenvalue four, and the mass matrix couples the blocks
nontrivially.  Two scalar lemmas record the on-shell transverse-momentum and
zitter-radius dictionary.

The matrix and scalar identities are kernel-checked.  Calling their dynamics
a literal particle trajectory or deriving mass from a spiral are
interpretations not established by these statements.

## Conventions and provenance

Indices `0,1` are the chirality `+1` block and `2,3` the chirality `-1`
block.  Thus `g5 = diag(1,1,-1,-1)` and
`D0 = diag(1,-1,-1,1)`.  The transverse ladders use the unnormalized Pauli
ladders with nonzero entry `2`.  Aristotle project
`9858b0d2-baf3-42d1-b939-142dfbef45cb` supplied the proof bodies; despite its
remote `COMPLETE_WITH_ERRORS` label, the returned file preserved every
statement and passed the pinned local Lean kernel on 2026-07-14.
Standard-three axiom guards backfilled 2026-07-16 to match the wave-2
integration pattern.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator

open Matrix

/-- Four-by-four complex matrices for the finite chiral-basis avatar. -/
abbrev DiracMat := Matrix (Fin 4) (Fin 4) ℂ

/-- Matrix commutator. -/
def comm (X Y : DiracMat) : DiracMat := X * Y - Y * X

/-- Massless chiral-basis Dirac operator at unit momentum along `+z`. -/
def D0 : DiracMat := !![1, 0, 0, 0; 0, -1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 1]

/-- Chirality grading `diag(1,1,-1,-1)`. -/
def g5 : DiracMat := !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- Chirality-swapping mass matrix with off-diagonal identity blocks. -/
def betaM : DiracMat := !![0, 0, 1, 0; 0, 0, 0, 1; 1, 0, 0, 0; 0, 1, 0, 0]

/-- Transverse raising ladder `alpha_1 + i alpha_2`. -/
def APlus : DiracMat := !![0, 2, 0, 0; 0, 0, 0, 0; 0, 0, 0, -2; 0, 0, 0, 0]

/-- Transverse lowering ladder `alpha_1 - i alpha_2`. -/
def AMinus : DiracMat := !![0, 0, 0, 0; 2, 0, 0, 0; 0, 0, 0, 0; 0, 0, -2, 0]

/-- The chirality grading squares to the identity. -/
theorem g5_sq : g5 * g5 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [g5]

/-- The massless operator commutes with the chirality grading. -/
theorem comm_D0_g5 : comm D0 g5 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [comm, D0, g5, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Raising-side chiral rotation relation. -/
theorem comm_D0_APlus : comm D0 APlus = (2 : ℂ) • (g5 * APlus) := by
  apply Matrix.ext
  norm_num [Fin.forall_fin_succ, D0, APlus, g5, comm]

/-- Lowering-side chiral rotation relation. -/
theorem comm_D0_AMinus : comm D0 AMinus = (-2 : ℂ) • (g5 * AMinus) := by
  unfold comm g5 D0 AMinus
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply]

/-- Raising-side double commutator at unit momentum. -/
theorem zitter_double_comm_APlus :
    comm D0 (comm D0 APlus) = (4 : ℂ) • APlus := by
  unfold comm D0 APlus
  norm_num [← List.ofFn_inj]

/-- Lowering-side double commutator at unit momentum. -/
theorem zitter_double_comm_AMinus :
    comm D0 (comm D0 AMinus) = (4 : ℂ) • AMinus := by
  unfold comm
  simp [D0, AMinus]
  norm_num

/-- The mass-ladder commutator is odd under chirality conjugation. -/
theorem mass_comm_g5_odd :
    g5 * comm betaM APlus * g5 = -(comm betaM APlus) := by
  unfold comm
  unfold g5 betaM APlus
  norm_num [← List.ofFn_inj, Matrix.vecMul]

/-- The mass matrix couples nontrivially to the transverse ladder. -/
theorem mass_comm_ne_zero : comm betaM APlus ≠ 0 := by
  refine ne_of_apply_ne (fun M => M 0 3) ?_
  norm_num [Matrix.mul_apply, comm]
  simp +decide [betaM, APlus]
  norm_num [Fin.sum_univ_succ]

/-- The on-shell transverse momentum squared equals the mass squared. -/
theorem transverse_momentum_sq_eq_mass_sq (E p m : ℝ) (hE : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    E ^ 2 * (1 - (p / E) ^ 2) = m ^ 2 := by
  grind

/-- The spin-half orbital condition is equivalent to the zitter radius. -/
theorem spin_half_iff_zitter_radius (r m : ℝ) (hm : m ≠ 0) :
    r * m = 1 / 2 ↔ r = 1 / (2 * m) := by
  grind

end PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator

/-! ## Build-enforced assumption-footprint guards (backfilled 2026-07-16) -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.g5_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.g5_sq

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.comm_D0_g5' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.comm_D0_g5

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.comm_D0_APlus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.comm_D0_APlus

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.comm_D0_AMinus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.comm_D0_AMinus

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.zitter_double_comm_APlus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.zitter_double_comm_APlus

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.zitter_double_comm_AMinus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.zitter_double_comm_AMinus

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.mass_comm_g5_odd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.mass_comm_g5_odd

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.mass_comm_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.mass_comm_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.transverse_momentum_sq_eq_mass_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.transverse_momentum_sq_eq_mass_sq

/-- info: 'PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.spin_half_iff_zitter_radius' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChiralSpiralCommutator.spin_half_iff_zitter_radius

end
