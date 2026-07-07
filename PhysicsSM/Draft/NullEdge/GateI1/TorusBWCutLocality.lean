import Mathlib

/-!
# Q09 finite torus BW-cut matrix-locality test

This module supplies the finite algebraic scaffolding for the Q09 BW-cut torus
matrix-locality test, downstream of two already-landed Q09 nuclei:

* `ScreenArea.lean`, the relational area functional.
* `ModularNoGo.lean`, the finite positive-generator modular no-go.

The BW-cut conjectural test is that on the one-particle physical space,
`logDelta = 2 * pi * K`, with `K` the cut boost generator.  This module does
not prove BW-cut.  It only provides the proved finite matrix bookkeeping used
to score that future torus-witness test:

* `bwResidual` / `BWCutExact`: the modular calibration residual and its exact
  vanishing predicate.
* `locDefect` / `MatrixLocal`: the off-support locality-defect functional and
  exact locality predicate.
* `locDefect_smul` / `matrixLocal_smul_iff` / `bwCut_localTransfer`: once exact
  calibration holds, locality of `logDelta` is equivalent to locality of the
  geometric generator `K`.
* `RemovableByRedecoration`: a finite predicate for whether an allowed
  redecoration removes an off-support defect.

Claim boundary: everything here is unconditional finite matrix algebra over an
arbitrary index type.  No entropy, SJ area law, Bisognano-Wichmann, Jacobson,
ANEC, surface-gravity, or continuum-horizon statement is asserted or used.  The
physical interpretation of `far`, `K`, and the redecoration family remains part
of the torus-witness construction and is still MEMO/OPEN.

Provenance: Aristotle project
`f1fecdb9-ea66-4ced-b675-4b4e1a640722`
(`ne-q09-bwcut-torus-modular-locality-audit-20260707`), clean-room
formalization of the scoring algebra requested by the Q09 BW-cut audit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateI1.TorusBWCutLocality

open Matrix
open scoped Matrix ComplexOrder BigOperators

variable {n : Type*}

/-! ## Modular calibration residual -/

/-- The BW-cut calibration residual `logDelta - 2 pi * K`. -/
def bwResidual (logDelta K : Matrix n n ℂ) : Matrix n n ℂ :=
  logDelta - (2 * Real.pi : ℂ) • K

/-- Exact BW-cut calibration: the residual vanishes. -/
def BWCutExact (logDelta K : Matrix n n ℂ) : Prop := bwResidual logDelta K = 0

/-- Exact calibration is exactly `logDelta = 2 pi * K`. -/
theorem bwCutExact_iff (logDelta K : Matrix n n ℂ) :
    BWCutExact logDelta K ↔ logDelta = (2 * Real.pi : ℂ) • K := by
  unfold BWCutExact bwResidual
  constructor
  · intro h
    exact sub_eq_zero.mp h
  · intro h
    rw [h]
    simp

/-! ## Off-support locality defect -/

/-- The locality defect of a matrix against a finite set of far index pairs:
the total norm mass of matrix elements that a local operator must leave at
zero. -/
def locDefect (L : Matrix n n ℂ) (far : Finset (n × n)) : ℝ :=
  ∑ p ∈ far, ‖L p.1 p.2‖

/-- The locality defect is nonnegative. -/
theorem locDefect_nonneg (L : Matrix n n ℂ) (far : Finset (n × n)) :
    0 ≤ locDefect L far :=
  Finset.sum_nonneg fun _ _ => norm_nonneg _

/-- Exact matrix locality: the off-support defect vanishes. -/
def MatrixLocal (L : Matrix n n ℂ) (far : Finset (n × n)) : Prop :=
  locDefect L far = 0

/-- A matrix is local iff every far matrix element is exactly zero. -/
theorem matrixLocal_iff (L : Matrix n n ℂ) (far : Finset (n × n)) :
    MatrixLocal L far ↔ ∀ p ∈ far, L p.1 p.2 = 0 := by
  unfold MatrixLocal locDefect
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => norm_nonneg _)]
  simp [norm_eq_zero]

/-- The locality defect scales by the norm of a scalar multiple. -/
theorem locDefect_smul (c : ℂ) (L : Matrix n n ℂ) (far : Finset (n × n)) :
    locDefect (c • L) far = ‖c‖ * locDefect L far := by
  unfold locDefect
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun p _ => ?_
  simp

/-- A nonzero rescaling preserves matrix locality. -/
theorem matrixLocal_smul_iff {c : ℂ} (hc : c ≠ 0) (L : Matrix n n ℂ)
    (far : Finset (n × n)) : MatrixLocal (c • L) far ↔ MatrixLocal L far := by
  unfold MatrixLocal
  rw [locDefect_smul]
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h1 | h2
    · exact absurd (norm_eq_zero.mp h1) hc
    · exact h2
  · intro h
    rw [h, mul_zero]

/-- Locality transfer under exact calibration.  If BW-cut holds exactly, then
`logDelta` is matrix-local iff the geometric generator `K` is.  Thus leakage in
`logDelta` under exact calibration is not a `2 pi` normalization artifact. -/
theorem bwCut_localTransfer {logDelta K : Matrix n n ℂ}
    (h : logDelta = (2 * Real.pi : ℂ) • K) (far : Finset (n × n)) :
    MatrixLocal logDelta far ↔ MatrixLocal K far := by
  subst h
  exact matrixLocal_smul_iff (by simp [Real.pi_ne_zero]) K far

/-! ## Redecoration removability and the composite pass -/

/-- A locality defect is redecoration-removable if some transform in the allowed
redecoration/species family sends `L` to a matrix-local operator. -/
def RemovableByRedecoration (L : Matrix n n ℂ)
    (far : Finset (n × n)) (fam : Set (Matrix n n ℂ → Matrix n n ℂ)) : Prop :=
  ∃ φ ∈ fam, MatrixLocal (φ L) far

/-- The composite BW-cut locality pass on the torus witness: exact modular
calibration together with matrix locality of `logDelta`. -/
def BWCutLocalityPass (logDelta K : Matrix n n ℂ) (far : Finset (n × n)) : Prop :=
  BWCutExact logDelta K ∧ MatrixLocal logDelta far

/-- The composite pass unpacks into calibration and far-entry vanishing. -/
theorem bwCutLocalityPass_iff (logDelta K : Matrix n n ℂ)
    (far : Finset (n × n)) :
    BWCutLocalityPass logDelta K far ↔
      logDelta = (2 * Real.pi : ℂ) • K ∧ (∀ p ∈ far, logDelta p.1 p.2 = 0) := by
  unfold BWCutLocalityPass
  rw [bwCutExact_iff, matrixLocal_iff]

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.TorusBWCutLocality.bwCutExact_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bwCutExact_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.TorusBWCutLocality.matrixLocal_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matrixLocal_iff

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.TorusBWCutLocality.bwCut_localTransfer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bwCut_localTransfer

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.TorusBWCutLocality.bwCutLocalityPass_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bwCutLocalityPass_iff

end PhysicsSM.Draft.NullEdge.GateI1.TorusBWCutLocality

end
