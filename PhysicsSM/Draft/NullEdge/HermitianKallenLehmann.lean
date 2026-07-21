import Mathlib

/-!
# General Hermitian Kallen-Lehmann representation (Opus, verified Aristotle 548ef54a)

Spectral-theorem lift of the diagonal KL capstone to ARBITRARY finite Hermitian
H: <v,(zI-H)^-1 v> = sum_i w_i/(z-mu_i), w_i>=0, via Mathlib's Hermitian spectral
theorem + unitary eigenbasis. physical_mass_can_exceed_ground_mass: non-diagonal
[[1,1],[1,1]] (eigs 0,2), excited eigenvector -> ground mass 0, physical mass 2.
Namespace kept as the prover's HermitianKallenLehmann (verbatim). Provenance:
verified at pin from task ea3b106f. Standard three. Claim grade M, [comp]. -/

open scoped BigOperators
open scoped ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace HermitianKallenLehmann

open Matrix

/-- The Källén--Lehmann weight of `v` at the `i`th vector in the orthonormal
spectral basis of a Hermitian matrix. -/
noncomputable def klWeight {m : ℕ} {H : Matrix (Fin m) (Fin m) ℂ}
    (hH : H.IsHermitian) (v : Fin m → ℂ) (i : Fin m) : ℝ :=
  Complex.normSq (dotProduct (star ⇑(hH.eigenvectorBasis i)) v)

lemma klWeight_nonneg {m : ℕ} {H : Matrix (Fin m) (Fin m) ℂ}
    (hH : H.IsHermitian) (v : Fin m → ℂ) (i : Fin m) :
    0 ≤ klWeight hH v i := by
  exact Complex.normSq_nonneg _

/-
General finite-dimensional Källén--Lehmann representation for a Hermitian
response matrix. The denominators are nonzero exactly at the indices carrying
the (repeated) eigenvalues.
-/
theorem hermitian_resolvent_inner_eq_sum {m : ℕ}
    (H : Matrix (Fin m) (Fin m) ℂ) (hH : H.IsHermitian)
    (v : Fin m → ℂ) (z : ℂ)
    (hz : ∀ i : Fin m, z ≠ (hH.eigenvalues i : ℂ)) :
    dotProduct (star v) ((z • (1 : Matrix (Fin m) (Fin m) ℂ) - H)⁻¹ *ᵥ v) =
      ∑ i : Fin m, (klWeight hH v i : ℂ) / (z - (hH.eigenvalues i : ℂ)) := by
  -- By the spectral theorem, $H$ can be diagonalized as $H = UDU^*$, where $U$ is the unitary matrix of eigenvectors and $D$ is the diagonal matrix of eigenvalues.
  set U := hH.eigenvectorUnitary
  set D := Matrix.diagonal (fun i => (hH.eigenvalues i : ℂ)) with hD;
  -- Then $zI-H = U(zI-D)U^*$ and $(zI-H)^{-1} = U(zI-D)^{-1}U^*$.
  have h_transform : (z • 1 - H)⁻¹ = U.val * (z • 1 - D)⁻¹ * star U.val := by
    have h_transform : (z • 1 - H) = U.val * (z • 1 - D) * star U.val := by
      have h_diag : H = U.val * D * star U.val := by
        convert hH.spectral_theorem using 1;
      simp +decide [ h_diag, mul_sub, sub_mul ];
    rw [ h_transform, Matrix.mul_inv_rev ];
    simp +decide [ ← mul_assoc, Matrix.mul_inv_rev ];
    rw [ Matrix.inv_eq_left_inv ];
    congr! 1;
    · exact Matrix.inv_eq_right_inv (by simp +decide)
    · simp +decide
  -- Then $(zI-D)^{-1} = \text{diag}(1/(z-\mu_1), \ldots, 1/(z-\mu_m))$.
  have h_diag : (z • 1 - D)⁻¹ = Matrix.diagonal (fun i => 1 / (z - (hH.eigenvalues i : ℂ))) := by
    rw [ Matrix.inv_eq_left_inv ];
    ext i j ; by_cases hi : i = j <;> simp_all +decide [ sub_eq_iff_eq_add ];
    simp +decide [ hi, Matrix.one_apply ];
  -- Then $star v ⬝ᵥ (z • 1 - H)⁻¹ *ᵥ v = star v ⬝ᵥ U * (z • 1 - D)⁻¹ * star U *ᵥ v$.
  have h_mul : star v ⬝ᵥ (z • 1 - H)⁻¹ *ᵥ v = star (U.val.conjTranspose.mulVec v) ⬝ᵥ (z • 1 - D)⁻¹ *ᵥ (U.val.conjTranspose.mulVec v) := by
    simp +decide [h_transform, Matrix.mul_assoc, Matrix.dotProduct_mulVec]
    simp +decide [Matrix.star_mulVec]
    rfl;
  simp_all +decide [ div_eq_mul_inv, Matrix.mulVec_diagonal, dotProduct ];
  simp +decide [klWeight, mul_assoc, mul_comm]
  simp +decide [ Complex.mul_conj, Complex.normSq_eq_norm_sq, dotProduct ];
  congr! 3

/-- Ground mass of a finite list of real eigenvalues. -/
noncomputable def groundMass {m : ℕ} (hm : 0 < m) (mu : Fin m → ℝ) : ℝ :=
  (Finset.univ.image mu).min' <| by
    rw [Finset.image_nonempty]
    exact ⟨⟨0, hm⟩, Finset.mem_univ _⟩

/-- Minimum eigenvalue whose Källén--Lehmann weight is nonzero. -/
noncomputable def physicalMass {m : ℕ} (mu w : Fin m → ℝ)
    (hs : (Finset.univ.filter fun i => w i ≠ 0).Nonempty) : ℝ :=
  ((Finset.univ.filter fun i => w i ≠ 0).image mu).min' (Finset.image_nonempty.mpr hs)

/-- A concrete non-diagonal Hermitian two-state response operator. -/
def witnessH : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(1 : ℂ), 1; 1, 1]

/-- Its ground and excited eigenvectors, used as columns. -/
def witnessEigenvector : Fin 2 → Fin 2 → ℂ
  | 0, 0 => 1
  | 0, 1 => -1
  | 1, 0 => 1
  | 1, 1 => 1

/-- The corresponding eigenvalues. -/
def witnessEigenvalue : Fin 2 → ℝ
  | 0 => 0
  | 1 => 2

/-- We take the physical vector to be the excited eigenvector. -/
def witnessVector : Fin 2 → ℂ := witnessEigenvector 1

/-- Explicit weights in the displayed eigenbasis. Normalization is immaterial
for the support and hence for the physical mass. -/
noncomputable def witnessWeight (i : Fin 2) : ℝ :=
  Complex.normSq (dotProduct (star (witnessEigenvector i)) witnessVector)

lemma witnessH_hermitian : witnessH.IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ witnessH ] ;

lemma witness_eigenvector_equation (i : Fin 2) :
    witnessH *ᵥ witnessEigenvector i =
      (witnessEigenvalue i : ℂ) • witnessEigenvector i := by
  ext j;
  fin_cases i <;> fin_cases j <;> norm_num [ witnessH, witnessEigenvector, witnessEigenvalue, dotProduct, Matrix.mulVec ]

lemma witness_weights : witnessWeight 0 = 0 ∧ witnessWeight 1 = 4 := by
  unfold witnessWeight; norm_num [ Complex.ext_iff, Fin.sum_univ_succ ] ;
  unfold witnessVector witnessEigenvector; norm_num [ Complex.normSq ] ;

/-
In this genuinely non-diagonal Hermitian example the spectral ground mass
is `0`, while the least mass visible to the chosen physical vector is `2`.
Thus a ground eigenvector orthogonal to the physical vector can be absent from
the Källén--Lehmann support.
-/
theorem physical_mass_can_exceed_ground_mass :
    ∃ (hs : (Finset.univ.filter fun i => witnessWeight i ≠ 0).Nonempty),
      groundMass (by omega : 0 < 2) witnessEigenvalue = 0 ∧
      physicalMass witnessEigenvalue witnessWeight hs = 2 ∧
      groundMass (by omega : 0 < 2) witnessEigenvalue <
        physicalMass witnessEigenvalue witnessWeight hs := by
  unfold groundMass physicalMass; norm_num [ Fin.univ_succ ] ;
  simp +decide [ Finset.filter_insert, Finset.filter_singleton, witnessEigenvalue, witnessWeight ];
  simp +decide [ witnessEigenvector, witnessVector ];
  rfl

end HermitianKallenLehmann
