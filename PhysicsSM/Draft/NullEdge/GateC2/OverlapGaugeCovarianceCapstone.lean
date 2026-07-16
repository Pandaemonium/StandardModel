import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexGaugeInvariance
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexVanishing

/-!
# Gate C2: certified overlap gauge-covariance capstone

This module closes the structural gauge-covariance package for the finite
overlap construction. For a unitary change of basis `U`:

* a sign certificate for `H` transports to a sign certificate for `U H U^*`;
* the overlap operator transports by the same conjugation;
* the finite overlap index is unchanged.

The sign-certificate and index statements were already proved in
`OverlapIndexGaugeInvariance`. The new load-bearing identity here is
`Dov_conj`; `gauge_covariance_package` composes all three without adding a
second unitary hypothesis. A nonidentity swap changes an explicit diagonal
kernel, so the package is not tested only at `U = 1`. The self-index-zero and
nonzero-index zero-mode theorems are the trivial and gap-closing controls.

PhysLean reference audit (2026-07-12): the v4.31 reference clone contains no
overlap-Dirac, Wilson-Dirac, or Ginsparg-Wilson API. This module is a clean-room
composition of the existing PhysicsSM finite-matrix definitions. PhysLean is
version-pinned away from this v4.28 project and is not imported.

Honest scope: conjugation covariance cannot create a nonzero index. It also
does not prove locality, a continuum anomaly theorem, or the existence of a
nonzero-index gauge background; those are separate Gate C2 layers.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateC2.OverlapGaugeCovarianceCapstone

open Matrix
open PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson
open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexGaugeInvariance

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The overlap operator is covariant when chirality and certified sign are
simultaneously transported by a unitary conjugation. -/
theorem Dov_conj (g eps U : Matrix n n Complex) (hU : Uᴴ * U = 1) :
    Dov (U * g * Uᴴ) (U * eps * Uᴴ) = U * Dov g eps * Uᴴ := by
  have hUU : U * Uᴴ = 1 := mul_eq_one_comm.mp hU
  unfold Dov
  calc
    1 + (U * g * Uᴴ) * (U * eps * Uᴴ)
        = 1 + U * (g * eps) * Uᴴ := by
            rw [show (U * g * Uᴴ) * (U * eps * Uᴴ)
                = U * g * (Uᴴ * U) * eps * Uᴴ by noncomm_ring, hU]
            noncomm_ring
    _ = U * (1 + g * eps) * Uᴴ := by
          rw [show U * (1 + g * eps) * Uᴴ
              = U * Uᴴ + U * (g * eps) * Uᴴ by noncomm_ring, hUU]

/-- The complete finite covariance package: certificate, operator, and index
all transport under the same nontrivial unitary conjugation law. -/
theorem gauge_covariance_package (H g eps U : Matrix n n Complex)
    (hU : Uᴴ * U = 1) (hg : g * g = 1) (hc : SignCertificate H eps) :
    SignCertificate (U * H * Uᴴ) (U * eps * Uᴴ) ∧
      Dov (U * g * Uᴴ) (U * eps * Uᴴ) = U * Dov g eps * Uᴴ ∧
      overlapIndex (U * g * Uᴴ) (U * eps * Uᴴ) = overlapIndex g eps := by
  exact ⟨SignCertificate.conj H eps U hU hc, Dov_conj g eps U hU,
    overlapIndex_conj g eps U hg hU⟩

/-! ## Explicit nonidentity control -/

/-- A nonidentity unitary permutation of two basis states. -/
def swap2 : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]

/-- A diagonal kernel changed by `swap2`. -/
def diag12 : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 2]

/-- The conjugated diagonal kernel. -/
def diag21 : Matrix (Fin 2) (Fin 2) Complex := !![2, 0; 0, 1]

theorem swap2_unitary : swap2ᴴ * swap2 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [swap2, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.conjTranspose_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.of_apply]

theorem swap2_ne_one : swap2 ≠ 1 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [swap2, Matrix.cons_val_zero, Matrix.head_cons, Matrix.of_apply] at h00

theorem swap2_conj_diag12 : swap2 * diag12 * swap2ᴴ = diag21 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [swap2, diag12, diag21, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.conjTranspose_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.of_apply]

theorem diag21_ne_diag12 : diag21 ≠ diag12 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [diag21, diag12, Matrix.cons_val_zero, Matrix.head_cons,
    Matrix.of_apply] at h00

/-- The gauge witness is both nonidentity and nontrivial on the kernel. -/
theorem nonidentity_gauge_control :
    swap2 ≠ 1 ∧ swap2ᴴ * swap2 = 1 ∧
      swap2 * diag12 * swap2ᴴ = diag21 ∧ diag21 ≠ diag12 :=
  ⟨swap2_ne_one, swap2_unitary, swap2_conj_diag12, diag21_ne_diag12⟩

/-! ## Trivial and gap-closing controls -/

/-- Comparing an involution with itself gives zero overlap index. -/
theorem overlapIndex_self_zero (g : Matrix n n Complex) (hg : g * g = 1) :
    overlapIndex g g = 0 := by
  rw [overlapIndex_eq g g hg]
  simp

/-- A nonzero overlap index forces a genuine zero mode of the overlap operator;
unitary conjugation cannot evade this gap-closing boundary. -/
theorem nonzero_index_forces_gap_closure (g eps : Matrix n n Complex)
    (hg : g * g = 1) (heps : eps * eps = 1)
    (hidx : overlapIndex g eps ≠ 0) :
    ∃ psi : n -> Complex, psi ≠ 0 ∧ (Dov g eps) *ᵥ psi = 0 :=
  OverlapIndexVanishing.exists_zero_mode_of_overlapIndex_ne_zero
    g eps hg heps hidx

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateC2.OverlapGaugeCovarianceCapstone.Dov_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Dov_conj

/-- info: 'PhysicsSM.Draft.NullEdge.GateC2.OverlapGaugeCovarianceCapstone.gauge_covariance_package' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms gauge_covariance_package

/-- info: 'PhysicsSM.Draft.NullEdge.GateC2.OverlapGaugeCovarianceCapstone.nonidentity_gauge_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonidentity_gauge_control

/-- info: 'PhysicsSM.Draft.NullEdge.GateC2.OverlapGaugeCovarianceCapstone.nonzero_index_forces_gap_closure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzero_index_forces_gap_closure

end PhysicsSM.Draft.NullEdge.GateC2.OverlapGaugeCovarianceCapstone
