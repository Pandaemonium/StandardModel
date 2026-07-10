import PhysicsSM.NullStrand.ZigZag.QuantumWalk

/-!
# Exact lattice dispersion and the zero-momentum mass gap

This module makes the spectral content of the finite `1+1` null-step walk
explicit.  The one-step operator has determinant one and trace
`2 cos(ka) cos(mu a)`, so its quasienergy relation is exactly

```text
cos(omega a) = cos(k a) cos(mu a).
```

At zero momentum the two `sigma_x` eigenvectors have exact eigenvalues
`exp(-i mu a)` and `exp(+i mu a)`.  Thus the checkerboard turn parameter is the
zero-momentum eigenphase on the principal quasienergy branch.  Quasienergy is
periodic modulo `2 pi / a`; no unqualified global equality `omega = mu` is
asserted without a branch convention.

Provenance: clean-room wrapper around the landed null-step quantum-walk core
and standard complex Euler identities in Mathlib.  Status: draft,
kernel-checked; axiom footprint pinned below.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ExactQuantumWalkDispersion

open Complex Matrix
open PhysicsSM.NullStrand.ZigZag
open PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore

/-- The positive `sigma_x` eigenvector. -/
def xPlus : Fin 2 → ℂ := ![1, 1]

/-- The negative `sigma_x` eigenvector. -/
def xMinus : Fin 2 → ℂ := ![1, -1]

/-- Exact lattice quasienergy relation for the finite walk. -/
theorem exact_lattice_dispersion (a k mu omega : ℝ) :
    PhysicsSM.NullStrand.ZigZag.IsQuasienergy a k mu omega ↔
      Real.cos (omega * a) = Real.cos (k * a) * Real.cos (mu * a) := by
  rfl

/-- The turn/mass parameter itself is a zero-momentum quasienergy. -/
theorem mass_is_zero_momentum_quasienergy (a mu : ℝ) :
    PhysicsSM.NullStrand.ZigZag.IsQuasienergy a 0 mu mu := by
  simp [PhysicsSM.NullStrand.ZigZag.IsQuasienergy,
    PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.IsQuasienergy]

/-- At zero momentum, `xPlus` has eigenphase `exp(-i mu a)`. -/
theorem zero_momentum_xPlus_eigenvector (a mu : ℝ) :
    (quantumWalkOperator a 0 mu).mulVec xPlus =
      Complex.exp (-((mu * a : ℝ) : ℂ) * I) • xPlus := by
  ext i
  fin_cases i <;>
    simp [quantumWalkOperator, Ua, Rz, Rx, xPlus, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two, mul_comm]
  all_goals
    rw [show -(I * ((a : ℂ) * (mu : ℂ))) = -((a : ℂ) * (mu : ℂ)) * I by ring]
    rw [← Complex.cos_sub_sin_I]
    ring

/-- At zero momentum, `xMinus` has eigenphase `exp(+i mu a)`. -/
theorem zero_momentum_xMinus_eigenvector (a mu : ℝ) :
    (quantumWalkOperator a 0 mu).mulVec xMinus =
      Complex.exp (((mu * a : ℝ) : ℂ) * I) • xMinus := by
  ext i
  fin_cases i <;>
    simp [quantumWalkOperator, Ua, Rz, Rx, xMinus, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two, mul_comm]
  all_goals
    rw [show I * ((a : ℂ) * (mu : ℂ)) = ((a : ℂ) * (mu : ℂ)) * I by ring]
    rw [Complex.exp_mul_I]
    ring

/-- Compact spectral verdict: exact dispersion, determinant one, and both
zero-momentum eigenphases. -/
theorem exact_quantum_walk_dispersion_verdict (a k mu omega : ℝ) :
    (PhysicsSM.NullStrand.ZigZag.IsQuasienergy a k mu omega ↔
      Real.cos (omega * a) = Real.cos (k * a) * Real.cos (mu * a))
      ∧ (quantumWalkOperator a k mu).det = 1
      ∧ PhysicsSM.NullStrand.ZigZag.IsQuasienergy a 0 mu mu
      ∧ (quantumWalkOperator a 0 mu).mulVec xPlus =
          Complex.exp (-((mu * a : ℝ) : ℂ) * I) • xPlus
      ∧ (quantumWalkOperator a 0 mu).mulVec xMinus =
          Complex.exp (((mu * a : ℝ) : ℂ) * I) • xMinus :=
  ⟨exact_lattice_dispersion a k mu omega, quantumWalk_det_one a k mu,
    mass_is_zero_momentum_quasienergy a mu,
    zero_momentum_xPlus_eigenvector a mu,
    zero_momentum_xMinus_eigenvector a mu⟩

end PhysicsSM.Draft.NullEdge.ExactQuantumWalkDispersion

/-! ## Build-enforced axiom-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExactQuantumWalkDispersion.zero_momentum_xPlus_eigenvector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ExactQuantumWalkDispersion.zero_momentum_xPlus_eigenvector

/-- info: 'PhysicsSM.Draft.NullEdge.ExactQuantumWalkDispersion.exact_quantum_walk_dispersion_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ExactQuantumWalkDispersion.exact_quantum_walk_dispersion_verdict
