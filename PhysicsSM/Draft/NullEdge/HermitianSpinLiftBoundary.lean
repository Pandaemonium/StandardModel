import PhysicsSM.NullStrand.Conventions
import PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary

/-!
# Hermitian local spin-lift boundary

This module closes the interpretation gap identified in the first local sign
witness. The trusted `PhysicsSM.NullStrand.Conventions` module already supplies
the `(+---)` Pauli/Hermitian lift, its determinant/Minkowski-norm identity, and
determinant preservation under `SL(2, C)` congruence.

Here the actual Hermitian action is

```text
X |-> A X A^dagger.
```

It preserves Hermitian matrices. The matrices `A` and `-A` have the same action,
and in dimension two they have the same determinant. On spinors their actions
differ by a sign, hence differ whenever the transformed spinor is nonzero.

This is the local algebra underlying the kernel `{+1,-1}` of the standard
spin-to-Lorentz map. It does not prove that every proper orthochronous Lorentz
transformation has a lift, identify the full kernel as a group theorem,
construct compatible lifts on graph edges and faces, or establish a global spin
structure.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary

open PhysicsSM.NullStrand
open PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary

/-- Congruence action used by the Pauli/Hermitian realization of Minkowski
vectors. -/
def hermitianLorentzAction
    (A M : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  A * M * Aᴴ

/-- The central sign is invisible to the Hermitian congruence action. -/
theorem hermitianLorentzAction_neg
    (A M : Matrix (Fin 2) (Fin 2) ℂ) :
    hermitianLorentzAction (-A) M = hermitianLorentzAction A M := by
  unfold hermitianLorentzAction
  simp

/-- Congruence carries Hermitian matrices to Hermitian matrices. -/
theorem hermitianLorentzAction_isHermitian
    (A M : Matrix (Fin 2) (Fin 2) ℂ) (hM : M.IsHermitian) :
    (hermitianLorentzAction A M).IsHermitian := by
  unfold Matrix.IsHermitian at hM ⊢
  unfold hermitianLorentzAction
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul,
    Matrix.conjTranspose_conjTranspose, hM]
  noncomm_ring

/-- The project Pauli lift of every real Minkowski vector is Hermitian. -/
theorem pauliHermitianEquiv_isHermitian (p : Minkowski4) :
    (pauliHermitianEquiv p).IsHermitian := by
  unfold Matrix.IsHermitian
  ext i j
  fin_cases i <;> fin_cases j
  all_goals
    simp [pauliHermitianEquiv_apply, Matrix.conjTranspose_apply,
      Complex.conj_I, Complex.conj_ofReal]
  all_goals ring

/-- In two complex dimensions, a matrix and its negative have equal
determinant. -/
theorem neg_det_eq_det (A : Matrix (Fin 2) (Fin 2) ℂ) :
    (-A).det = A.det := by
  rw [Matrix.det_neg]
  simp

/-- Determinant-one matrices and their negatives have the same Hermitian action
and preserve the `(+---)` Minkowski norm encoded by the Pauli determinant. -/
theorem sl2_sign_pair_minkowski_action
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (p : Minkowski4) :
    (-A).det = 1 ∧
    hermitianLorentzAction (-A) (pauliHermitianEquiv p) =
      hermitianLorentzAction A (pauliHermitianEquiv p) ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).IsHermitian ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).det =
      (minkowskiSq p : ℂ) := by
  refine ⟨?_, hermitianLorentzAction_neg A _, ?_, ?_⟩
  · rw [neg_det_eq_det, hA]
  · exact hermitianLorentzAction_isHermitian A _
      (pauliHermitianEquiv_isHermitian p)
  · rw [hermitianLorentzAction]
    exact (sl2_congruence_preserves_det A (pauliHermitianEquiv p) hA).trans
      (hermitian_det_eq_minkowskiSq p)

/-- The two sign-related matrices act differently on every spinor whose image
under `A` is nonzero. -/
theorem sl2_sign_pair_spinor_actions_ne
    (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ)
    (hpsi : spinorAction A psi ≠ 0) :
    spinorAction (-A) psi ≠ spinorAction A psi := by
  rw [spinorAction_neg]
  exact neg_ne_self.mpr hpsi

/-- **Local Hermitian spin-sign boundary.** The sign pair is invisible on the
Pauli/Hermitian Minkowski action, preserves the Minkowski determinant, and is
visible on every spinor with nonzero transformed image. -/
theorem localHermitianSpinSignBoundary
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (p : Minkowski4) (psi : Fin 2 -> ℂ)
    (hpsi : spinorAction A psi ≠ 0) :
    (-A).det = 1 ∧
    hermitianLorentzAction (-A) (pauliHermitianEquiv p) =
      hermitianLorentzAction A (pauliHermitianEquiv p) ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).IsHermitian ∧
    (hermitianLorentzAction A (pauliHermitianEquiv p)).det =
      (minkowskiSq p : ℂ) ∧
    spinorAction (-A) psi ≠ spinorAction A psi := by
  obtain ⟨hnegDet, hsame, hHermitian, hnorm⟩ :=
    sl2_sign_pair_minkowski_action A hA p
  exact ⟨hnegDet, hsame, hHermitian, hnorm,
    sl2_sign_pair_spinor_actions_ne A psi hpsi⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.sl2_sign_pair_minkowski_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.sl2_sign_pair_minkowski_action

/-- info: 'PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.localHermitianSpinSignBoundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary.localHermitianSpinSignBoundary

end PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary
