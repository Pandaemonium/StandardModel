import PhysicsSM.Draft.NullEdge.CARAnnihilationLocality

noncomputable section

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CARAnnihilationLocality

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

variable {ι : Type*} [Fintype ι] [LinearOrder ι] [DecidableEq ι]

theorem fockInner_sum_right_test {β : Type*} (s : Finset β) (a : Fock ι)
    (g : β → Fock ι) :
    fockInner a (∑ b ∈ s, g b) = ∑ b ∈ s, fockInner a (g b) := by
  simp only [fockInner, Finset.sum_apply, Finset.mul_sum]
  rw [Finset.sum_comm]

theorem fock_ext_inner_test (A B : Fock ι)
    (h : ∀ phi : Fock ι, fockInner phi A = fockInner phi B) : A = B := by
  funext S
  have hS := h (fun T => if T = S then 1 else 0)
  simpa [fockInner] using hS

theorem fockInner_comm_test (a b : Fock ι) :
    fockInner a b = star (fockInner b a) := by
  unfold fockInner
  simp +decide [mul_comm]

theorem fockInner_smul_right_test (c : Complex) (a b : Fock ι) :
    fockInner a (c • b) = c * fockInner a b := by
  simp [fockInner, Finset.mul_sum, mul_assoc, mul_comm, mul_left_comm]

theorem fockInner_smul_left_test (c : Complex) (a b : Fock ι) :
    fockInner (c • a) b = star c * fockInner a b := by
  rw [fockInner_comm_test, fockInner_smul_right_test]
  rw [StarMul.star_mul, ← fockInner_comm_test a b]
  ring

theorem fockInner_sum_left_test {β : Type*} (s : Finset β) (g : β → Fock ι)
    (b : Fock ι) :
    fockInner (∑ a ∈ s, g a) b = ∑ a ∈ s, fockInner (g a) b := by
  rw [fockInner_comm_test, fockInner_sum_right_test]
  rw [star_sum]
  apply Finset.sum_congr rfl
  intro i hi
  exact (fockInner_comm_test (g i) b).symm

theorem fockInner_Gamma_right_test (U : Matrix ι ι Complex) (a b : Fock ι) :
    fockInner a (Gamma U b) = fockInner (Gamma Uᴴ a) b := by
  rw [fockInner_comm_test, fockInner_Gamma_left, fockInner_comm_test]
  rw [star_star]

theorem gamma_annihilate_covariance_test (U : Matrix ι ι Complex)
    (hleft : Uᴴ * U = 1) (hright : U * Uᴴ = 1)
    (j : ι) (psi : Fock ι) :
    annihilate j (Gamma U psi) =
      ∑ i : ι, U j i • Gamma U (annihilate i psi) := by
  apply fock_ext_inner_test
  intro phi
  calc
    fockInner phi (annihilate j (Gamma U psi)) =
        fockInner (create j phi) (Gamma U psi) :=
      (fockInner_create_left j phi (Gamma U psi)).symm
    _ = fockInner (Gamma Uᴴ (create j phi)) psi :=
      fockInner_Gamma_right_test U (create j phi) psi
    _ = fockInner
        (∑ i : ι, Uᴴ i j • create i (Gamma Uᴴ phi)) psi := by
      rw [gamma_create_covariance]
    _ = ∑ i : ι, fockInner (Uᴴ i j • create i (Gamma Uᴴ phi)) psi := by
      rw [fockInner_sum_left_test Finset.univ]
    _ = ∑ i : ι, U j i * fockInner (create i (Gamma Uᴴ phi)) psi := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [fockInner_smul_left_test]
      simp [Matrix.conjTranspose_apply]
    _ = ∑ i : ι, U j i * fockInner (Gamma Uᴴ phi) (annihilate i psi) := by
      simp_rw [fockInner_create_left]
    _ = ∑ i : ι, U j i * fockInner phi (Gamma U (annihilate i psi)) := by
      simp_rw [fockInner_Gamma_right_test]
    _ = ∑ i : ι, fockInner phi (U j i • Gamma U (annihilate i psi)) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [fockInner_smul_right_test]
    _ = fockInner phi
        (∑ i : ι, U j i • Gamma U (annihilate i psi)) := by
      rw [fockInner_sum_right_test Finset.univ]

end PhysicsSM.Draft.NullEdge.CARAnnihilationLocality
