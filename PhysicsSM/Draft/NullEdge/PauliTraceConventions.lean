import PhysicsSM.Draft.NullEdge.MassMixedness

/-!
# Pauli trace conventions (clean-room port layer)

DRAFT (kernel-clean).  A small trace-algebra table for the Pauli matrices
in THIS project's convention (`MassMixedness.sigma1/2/3`, with
`P = E I + p . sigma`), providing the algebraic backbone used by the
mass-mixedness Pauli corollary and the Paper A Pauli-map conventions.

Provenance: clean-room formalization.  Statement selection cross-checked
against the public Physlib (PhysLean) `PauliMatrix` trace API
(`trace_σ1/2/3`, `σi_σj_trace` family) via the offline lean-explore index
on 2026-07-10; no source text was consulted or copied - the identities are
re-derived from this project's own definitions, which need not share
Physlib's basis order or sign conventions.  User directive (2026-07-10):
begin actively porting useful public-repo structure under clean-room rules.
Lean 4.28.0.
-/

noncomputable section

open Matrix

namespace PhysicsSM.Draft.NullEdge.PauliTraceConventions

open PhysicsSM.Draft.NullEdge.MassMixedness

/-- Each Pauli matrix is traceless. -/
theorem trace_sigma1 : sigma1.trace = 0 := by
  simp [Matrix.trace, Matrix.diag, sigma1, Fin.sum_univ_two]

theorem trace_sigma2 : sigma2.trace = 0 := by
  simp [Matrix.trace, Matrix.diag, sigma2, Fin.sum_univ_two]

theorem trace_sigma3 : sigma3.trace = 0 := by
  simp [Matrix.trace, Matrix.diag, sigma3, Fin.sum_univ_two]

/-- Each Pauli matrix squares to the identity. -/
theorem sigma1_sq : sigma1 * sigma1 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [sigma1, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

theorem sigma2_sq : sigma2 * sigma2 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [sigma2, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

theorem sigma3_sq : sigma3 * sigma3 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [sigma3, Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply]

/-- Distinct Pauli products have zero trace (orthogonality of the Pauli
basis under the trace form). -/
theorem trace_sigma1_mul_sigma2 : (sigma1 * sigma2).trace = 0 := by
  simp [Matrix.trace, Matrix.diag, sigma1, sigma2, Matrix.mul_apply,
    Fin.sum_univ_two]

theorem trace_sigma1_mul_sigma3 : (sigma1 * sigma3).trace = 0 := by
  simp [Matrix.trace, Matrix.diag, sigma1, sigma3, Matrix.mul_apply,
    Fin.sum_univ_two]

theorem trace_sigma2_mul_sigma3 : (sigma2 * sigma3).trace = 0 := by
  simp [Matrix.trace, Matrix.diag, sigma2, sigma3, Matrix.mul_apply,
    Fin.sum_univ_two]

/-- Trace normalization of the Pauli basis: `tr(sigma_i^2) = 2`. -/
theorem trace_sigma1_sq : (sigma1 * sigma1).trace = 2 := by
  rw [sigma1_sq]; simp [Matrix.trace_one]

theorem trace_sigma2_sq : (sigma2 * sigma2).trace = 2 := by
  rw [sigma2_sq]; simp [Matrix.trace_one]

theorem trace_sigma3_sq : (sigma3 * sigma3).trace = 2 := by
  rw [sigma3_sq]; simp [Matrix.trace_one]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PauliTraceConventions.sigma1_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sigma1_sq

/-- info: 'PhysicsSM.Draft.NullEdge.PauliTraceConventions.trace_sigma2_mul_sigma3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_sigma2_mul_sigma3

end PhysicsSM.Draft.NullEdge.PauliTraceConventions
