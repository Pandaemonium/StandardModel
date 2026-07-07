import Mathlib

/-!
# Finite modular no-go

This module records the Q09 finite no-go for half-sided modular generation.
If a positive semidefinite finite matrix `P` satisfies a nonzero commutator
eigen-relation

`H * P - P * H = c • P`,

then `P = 0`.  The proof takes traces: finite commutators have zero trace, so
`trace P = 0`; positive semidefinite plus zero trace forces `P` to vanish.

Claim boundary: this is an unconditional finite no-go.  It kills the finite
half-sided modular-generator target; it does not promote any continuum horizon
entropy, Bisognano-Wichmann, Jacobson, ANEC, or universal coefficient claim.

Provenance: Aristotle project
`2ed38421-a2fe-4c80-b34a-6fd1b9ec8f22`
(`ne-q09-entropy-horizon-audit-20260707`), clean-room formalization of
`AgentTasks/fable_parallel/Q09_answer.md` ladder rung L3 / A9.4.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateI1.ModularNoGo

open Matrix
open scoped Matrix ComplexOrder

/-- General trace obstruction for a positive semidefinite finite matrix. -/
theorem posSemidef_eq_zero_of_commutator_smul
    {n : Type*} [Fintype n]
    {H P : Matrix n n ℂ} {c : ℂ} (hc : c ≠ 0) (hP : P.PosSemidef)
    (hcomm : H * P - P * H = c • P) : P = 0 := by
  classical
  have htr : (H * P - P * H).trace = (c • P).trace := by
    rw [hcomm]
  rw [Matrix.trace_sub, Matrix.trace_mul_comm H P, sub_self, Matrix.trace_smul] at htr
  have hz : P.trace = 0 := by
    have h := htr.symm
    simp only [smul_eq_mul] at h
    exact (mul_eq_zero.mp h).resolve_left hc
  exact (hP.trace_eq_zero_iff).mp hz

/-- Finite vacuity of the differentiated Borchers commutation relation. -/
theorem borchers_positive_generator_vanishes
    {n : Type*} [Fintype n]
    {logDelta P : Matrix n n ℂ} (hP : P.PosSemidef)
    (hcomm : logDelta * P - P * logDelta = (2 * Real.pi * Complex.I) • P) :
    P = 0 := by
  classical
  refine posSemidef_eq_zero_of_commutator_smul ?_ hP hcomm
  simp [Real.pi_ne_zero, Complex.I_ne_zero]

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ModularNoGo.posSemidef_eq_zero_of_commutator_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms posSemidef_eq_zero_of_commutator_smul

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.ModularNoGo.borchers_positive_generator_vanishes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms borchers_positive_generator_vanishes

end PhysicsSM.Draft.NullEdge.GateI1.ModularNoGo

end
