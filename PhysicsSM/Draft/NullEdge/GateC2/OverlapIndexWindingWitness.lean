import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexIntegrality

/-!
# Gate C2: a finite overlap witness with nonzero (winding) index

This Draft module realizes the **C2a algebra/topology bridge** from the Aristotle
Gate-C2 design brief: an explicit finite chirality/sign involution pair whose
`OverlapIndexToy.overlapIndex` is a prescribed nonzero integer, defeating the
free-index-zero benchmark (`GateC2.TetraFreeIndexZero.tetraFreeOverlapIndex_eq_zero`).

Aristotle's controlling observation: with a balanced chirality (`Tr gamma5 = 0`)
the index is `-(1/2) . sig(eps)` (the signature of the sign involution), so a
NONZERO index is achieved exactly by a `eps` whose `+1` versus `-1` eigenvalue
counts are imbalanced - a *signature defect*.  The minimal graded unit is a 2-site Wilson
line `gamma5 = 1 (x) sigma3` on `Fin 4` with a one-site defect
`eps = diag(-1,-1,-1,1)`, giving index `1`.  Block-stacking `Q` copies realizes
any winding charge `Q`.

## HONESTY CAVEAT (scope; red-team ee95ba08)

This is the **bridge**, NOT yet a gauge index theorem.  The involution `eps` here
is CONSTRUCTED to carry the target signature; it is not (yet) derived as
`sign(H_U)` for a genuine gauge-Wilson operator `H_U`.  That derivation - the
finite positivity certificate `eps_U = eps_U^*`, `eps_U^2 = 1`, `[eps_U, H_U] = 0`,
`eps_U . H_U` positive semidefinite - is the hard **C2b** target.  Crucially, the
general-`Q` family here is ALGEBRA-LEVEL only: `overlapIndex_gamma5WQ_epsWQ_eq`
computes the index of a CONSTRUCTED involution pair; it does NOT certify those
`gamma5WQ/epsWQ` as the sign of any operator.  Only the `Q = 1` unit `epsW` is
later certified as a genuine operator sign (of the diagonal `HU` in
`OverlapWindingSignJoin`, and the non-diagonal `HU2` in
`OverlapHoppingSignWitness`).  What is proved here: the overlap-index *framework*
realizes every integer charge, so the free-index-zero result is not a degeneracy
of the construction.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity / consistency witness** (algebra-topology bridge;
no gauge operator, no functional calculus).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexWindingWitness

open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy

/-! ## The graded minimal unit (2-site Wilson line, index 1) -/

/-- Graded chirality on the 2-site line `Fin 4 = site (x) spin`, `1 (x) sigma3`. -/
def gamma5W : Matrix (Fin 4) (Fin 4) ℂ := Matrix.diagonal ![1, -1, 1, -1]

/-- Sign involution with a one-site signature defect (`n_+ = 1`, `sig = -2`). -/
def epsW : Matrix (Fin 4) (Fin 4) ℂ := Matrix.diagonal ![-1, -1, -1, 1]

theorem gamma5W_sq : gamma5W * gamma5W = 1 := by
  rw [gamma5W, Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_one]
  congr 1
  funext i
  fin_cases i <;> simp

theorem epsW_sq : epsW * epsW = 1 := by
  rw [epsW, Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_one]
  congr 1
  funext i
  fin_cases i <;> simp

theorem gamma5W_trace : gamma5W.trace = 0 := by
  rw [gamma5W, Matrix.trace_diagonal]
  simp [Fin.sum_univ_four]

theorem epsW_trace : epsW.trace = -2 := by
  rw [epsW, Matrix.trace_diagonal]
  simp [Fin.sum_univ_four]
  norm_num

/-- The graded 2-site unit witness has overlap index `1`. -/
theorem overlapIndex_gamma5W_epsW_eq_one : overlapIndex gamma5W epsW = 1 := by
  rw [overlapIndex_eq gamma5W epsW gamma5W_sq, gamma5W_trace, epsW_trace]
  norm_num

/-! ## Block-stacked family realizing any winding charge `Q` -/

/-- `Q` copies of the graded chirality unit (index type `Fin 4 (x) Fin Q`). -/
def gamma5WQ (Q : ℕ) : Matrix (Fin 4 × Fin Q) (Fin 4 × Fin Q) ℂ :=
  Matrix.blockDiagonal (fun _ : Fin Q => gamma5W)

/-- `Q` copies of the signature-defect sign involution. -/
def epsWQ (Q : ℕ) : Matrix (Fin 4 × Fin Q) (Fin 4 × Fin Q) ℂ :=
  Matrix.blockDiagonal (fun _ : Fin Q => epsW)

theorem gamma5WQ_sq (Q : ℕ) : gamma5WQ Q * gamma5WQ Q = 1 := by
  rw [gamma5WQ, ← Matrix.blockDiagonal_mul]
  simp only [gamma5W_sq]
  exact Matrix.blockDiagonal_one

theorem epsWQ_sq (Q : ℕ) : epsWQ Q * epsWQ Q = 1 := by
  rw [epsWQ, ← Matrix.blockDiagonal_mul]
  simp only [epsW_sq]
  exact Matrix.blockDiagonal_one

theorem gamma5WQ_trace (Q : ℕ) : (gamma5WQ Q).trace = 0 := by
  rw [gamma5WQ, Matrix.trace_blockDiagonal]
  simp [gamma5W_trace]

theorem epsWQ_trace (Q : ℕ) : (epsWQ Q).trace = -(2 * Q) := by
  rw [epsWQ, Matrix.trace_blockDiagonal]
  simp only [epsW_trace, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul]
  ring

/-- **Winding-charge realization.**  The block-stacked graded witness has overlap
index exactly `Q`: the finite overlap-index framework realizes every winding
charge.  (Bridge only - see the module honesty caveat; `epsWQ` is constructed
with the target signature, not derived as `sign(H_U)`.) -/
theorem overlapIndex_gamma5WQ_epsWQ_eq (Q : ℕ) :
    overlapIndex (gamma5WQ Q) (epsWQ Q) = (Q : ℂ) := by
  rw [overlapIndex_eq (gamma5WQ Q) (epsWQ Q) (gamma5WQ_sq Q), gamma5WQ_trace,
    epsWQ_trace]
  ring

/-- The unit witness index is nonzero, so it genuinely defeats the free-index-zero
benchmark (contrast `GateC2.TetraFreeIndexZero.tetraFreeOverlapIndex_eq_zero`). -/
theorem overlapIndex_gamma5W_epsW_ne_zero : overlapIndex gamma5W epsW ≠ 0 := by
  rw [overlapIndex_gamma5W_epsW_eq_one]; norm_num

end OverlapIndexWindingWitness
end GateC2
end NullEdge
end Draft
end PhysicsSM
