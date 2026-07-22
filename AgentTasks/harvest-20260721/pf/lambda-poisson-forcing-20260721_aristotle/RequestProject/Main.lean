import Mathlib

open scoped BigOperators
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace FrameBlindVariance

/-- The real indicator vector of a finite region. -/
def regionIndicator {N : ℕ} (A : Finset (Fin N)) : Fin N → ℝ :=
  fun i => if i ∈ A then 1 else 0

/-- Number variance of a region for a covariance matrix. -/
def numberVariance {N : ℕ} (C : Matrix (Fin N) (Fin N) ℝ)
    (A : Finset (Fin N)) : ℝ :=
  dotProduct (regionIndicator A) (C.mulVec (regionIndicator A))

/-- Full permutation (frame) invariance, written entrywise. -/
def PermutationInvariant {N : ℕ} (C : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∀ σ : Equiv.Perm (Fin N), ∀ i j, C (σ i) (σ j) = C i j

/-- A constant-diagonal, constant-off-diagonal matrix. -/
def Exchangeable {N : ℕ} (C : Matrix (Fin N) (Fin N) ℝ) (a b : ℝ) : Prop :=
  ∀ i j, C i j = if i = j then a else b

/-
The exact regional variance law for an exchangeable covariance.
-/
theorem numberVariance_exchangeable {N : ℕ} {C : Matrix (Fin N) (Fin N) ℝ}
    {a b : ℝ} (hC : Exchangeable C a b) (A : Finset (Fin N)) :
    numberVariance C A =
      (A.card : ℝ) * a + (A.card : ℝ) * ((A.card : ℝ) - 1) * b := by
  have h_expand : numberVariance C A = ∑ i ∈ A, ∑ j ∈ A, (if i = j then a else b) := by
    unfold numberVariance;
    simp +decide [ dotProduct, Matrix.mulVec, regionIndicator ];
    exact Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => hC i j;
  simp_all +decide [ Finset.sum_ite, Finset.filter_eq, Finset.filter_ne ];
  cases A using Finset.induction <;> simp +decide [ * ] ; ring

/-
The total-vector quadratic form for an exchangeable covariance.
-/
theorem totalVariance_exchangeable {N : ℕ} {C : Matrix (Fin N) (Fin N) ℝ}
    {a b : ℝ} (hC : Exchangeable C a b) :
    numberVariance C Finset.univ = (N : ℝ) * (a + ((N : ℝ) - 1) * b) := by
  convert numberVariance_exchangeable hC Finset.univ using 1;
  simpa using by ring;

/-
Fixed total forces the unique off-diagonal value.
-/
theorem offDiagonal_eq_of_fixedTotal {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} {a b : ℝ}
    (hC : Exchangeable C a b) (htotal : numberVariance C Finset.univ = 0) :
    b = -a / ((N : ℝ) - 1) := by
  rw [ eq_div_iff ] <;> nlinarith [ show ( N : ℝ ) ≥ 2 by norm_cast, totalVariance_exchangeable hC ]

/-
Under fixed total, regional variance is completely fixed by its size and diagonal.
-/
theorem numberVariance_fixedTotal {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} {a b : ℝ}
    (hC : Exchangeable C a b) (htotal : numberVariance C Finset.univ = 0)
    (A : Finset (Fin N)) :
    numberVariance C A =
      a * (A.card : ℝ) * ((N : ℝ) - (A.card : ℝ)) / ((N : ℝ) - 1) := by
  rw [ numberVariance_exchangeable hC, offDiagonal_eq_of_fixedTotal hN hC htotal ] ; ring;
  nlinarith only [ mul_inv_cancel_left₀ ( by linarith [ show ( N : ℝ ) ≥ 2 by norm_cast ] : ( -1 + N : ℝ ) ≠ 0 ) ( A.card * a ) ]

/-
PSD makes every diagonal entry nonnegative.
-/
theorem diagonal_nonnegative {N : ℕ} {C : Matrix (Fin N) (Fin N) ℝ}
    (hpsd : C.PosSemidef) (i : Fin N) : 0 ≤ C i i := by
  have := hpsd.2;
  simpa using this ( Finsupp.single i 1 )

/-
PSD also makes the total-vector quadratic form nonnegative.
-/
theorem totalVariance_nonnegative {N : ℕ} {C : Matrix (Fin N) (Fin N) ℝ}
    (hpsd : C.PosSemidef) : 0 ≤ numberVariance C Finset.univ := by
  convert hpsd.dotProduct_mulVec_nonneg _

/-
For an exchangeable PSD matrix, both eigenvalue parameters have the required sign.
-/
theorem exchangeable_psd_signs {N : ℕ} [NeZero N]
    {C : Matrix (Fin N) (Fin N) ℝ} {a b : ℝ}
    (hC : Exchangeable C a b) (hpsd : C.PosSemidef) :
    0 ≤ a ∧ 0 ≤ a + ((N : ℝ) - 1) * b := by
  constructor;
  · simpa [ hC _ _ ] using diagonal_nonnegative hpsd ⟨ 0, NeZero.pos N ⟩;
  · have := totalVariance_nonnegative hpsd;
    rw [ totalVariance_exchangeable hC ] at this ; nlinarith [ show ( N : ℝ ) ≥ 1 by norm_cast; exact NeZero.pos N ]

/-
A PSD real matrix whose diagonal vanishes everywhere is zero.
-/
theorem posSemidef_eq_zero_of_diagonal_eq_zero {N : ℕ}
    {C : Matrix (Fin N) (Fin N) ℝ} (hpsd : C.PosSemidef)
    (hdiag : ∀ i, C i i = 0) : C = 0 := by
  -- For any $i \neq j$, by PSD we have $C i i + 2C i j + C j j \geq 0$ and $C i i - 2C i j + C j j \geq 0$. Given $C i i = C j j = 0$, we get $2|C i j| \leq 0 \Rightarrow C i j = 0$.
  have h_off_diag_zero (i j : Fin N) (hij : i ≠ j) : C i j = 0 := by
    have h_off_diag_zero (i j : Fin N) (hij : i ≠ j) : C i j + C j i = 0 := by
      have := hpsd.2;
      have := this ( Finsupp.single i 1 + Finsupp.single j 1 ) ; simp_all +decide [ Finsupp.sum_add_index', add_mul, mul_add ] ;
      have := ‹∀ x : Fin N →₀ ℝ, 0 ≤ x.sum fun i xi => x.sum fun j xj => xi * C i j * xj› ( Finsupp.single i 1 - Finsupp.single j 1 ) ; simp_all +decide [ Finsupp.sum_sub_index, sub_mul, mul_sub ] ; linarith;
    have := hpsd.1;
    replace := congr_fun ( congr_fun this i ) j; norm_num at this; linarith [ h_off_diag_zero i j hij ] ;
  ext i j; by_cases hij : i = j <;> aesop;

/-
In the exchangeable case, suppression of the single diagonal parameter suppresses all modes.
-/
theorem exchangeable_eq_zero_of_a_eq_zero {N : ℕ}
    {C : Matrix (Fin N) (Fin N) ℝ} {a b : ℝ}
    (hC : Exchangeable C a b) (hpsd : C.PosSemidef) (ha : a = 0) : C = 0 := by
  convert posSemidef_eq_zero_of_diagonal_eq_zero hpsd _;
  exact fun i => by simpa [ ha ] using hC i i;

/-
For regions of size at most half the space, fixed-total variance has a linear lower bound.
-/
theorem numberVariance_linear_lower_bound {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} {a b : ℝ}
    (hC : Exchangeable C a b) (hpsd : C.PosSemidef)
    (htotal : numberVariance C Finset.univ = 0)
    (A : Finset (Fin N)) (hA : 2 * A.card ≤ N) :
    a * (A.card : ℝ) / 2 ≤ numberVariance C A := by
  rw [ numberVariance_fixedTotal hN hC htotal ];
  -- By exchangeable_psd_signs, we know that $0 \leq a$.
  have h_nonneg_a : 0 ≤ a := by
    convert diagonal_nonnegative hpsd ⟨ 0, by linarith ⟩ using 1;
    exact hC _ _ ▸ rfl;
  rw [ le_div_iff₀ ] <;> nlinarith [ show ( N : ℝ ) ≥ 2 by norm_cast, show ( A.card : ℝ ) ≤ N / 2 by linarith [ show ( 2 * A.card : ℝ ) ≤ N by norm_cast ], mul_nonneg h_nonneg_a ( show ( 0 : ℝ ) ≤ A.card by positivity ) ]

/-
The frame-blind fixed-total dichotomy: either total suppression, or every nonempty
small region has a strictly positive Poisson-scale lower bound.
-/
theorem frameBlind_dichotomy {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} {a b : ℝ}
    (hC : Exchangeable C a b) (hpsd : C.PosSemidef)
    (htotal : numberVariance C Finset.univ = 0) :
    C = 0 ∨ (0 < a ∧ ∀ A : Finset (Fin N), A.Nonempty → 2 * A.card ≤ N →
      0 < numberVariance C A ∧ a * (A.card : ℝ) / 2 ≤ numberVariance C A) := by
  have := exchangeable_eq_zero_of_a_eq_zero hC hpsd;
  by_cases ha : a = 0 <;> simp_all +decide [ Exchangeable ];
  refine Or.inr ⟨ lt_of_le_of_ne ?_ ( Ne.symm ha ), ?_ ⟩;
  · exact diagonal_nonnegative hpsd ⟨ 0, by linarith ⟩ |> fun h => by simpa [ hC ] using h;
  · intro A hA₁ hA₂; exact ⟨ by
      have := numberVariance_linear_lower_bound hN hC hpsd htotal A hA₂; simp_all +decide [ numberVariance ] ;
      exact lt_of_lt_of_le ( div_pos ( mul_pos ( lt_of_le_of_ne ( by simpa [ hC ] using diagonal_nonnegative hpsd ⟨ 0, by linarith ⟩ ) ( Ne.symm ha ) ) ( Nat.cast_pos.mpr hA₁.card_pos ) ) zero_lt_two ) this, by
      convert numberVariance_linear_lower_bound hN hC hpsd htotal A hA₂ using 1 ⟩ ;

/-
Two ordered pairs of distinct points in `Fin N` are related by a permutation.
-/
theorem exists_perm_map_pair {N : ℕ} {i j k l : Fin N}
    (hij : i ≠ j) (hkl : k ≠ l) :
    ∃ σ : Equiv.Perm (Fin N), σ i = k ∧ σ j = l := by
  by_contra h_contra;
  -- By transitivity of permutations, we can find a permutation $\sigma$ such that $\sigma(i) = k$ and $\sigma(j) = l$.
  obtain ⟨σ, hσ⟩ : ∃ σ : Equiv.Perm (Fin N), σ i = k := by
    exact ⟨ Equiv.swap i k, by simp +decide ⟩;
  exact h_contra ⟨ σ * Equiv.swap j ( σ⁻¹ l ), by aesop ⟩

/-
Full symmetric-group invariance is equivalent to the elementary exchangeable form
when at least two points are present.
-/
theorem permutationInvariant_iff_exchangeable {N : ℕ} (hN : 2 ≤ N)
    (C : Matrix (Fin N) (Fin N) ℝ) :
    PermutationInvariant C ↔
      Exchangeable C (C ⟨0, by omega⟩ ⟨0, by omega⟩)
        (C ⟨0, by omega⟩ ⟨1, by omega⟩) := by
  constructor <;> intro h;
  · intro i j; by_cases hij : i = j;
    · obtain ⟨σ, hσ⟩ : ∃ σ : Equiv.Perm (Fin N), σ i = ⟨0, by linarith⟩ := by
        exact ⟨ Equiv.swap i ⟨ 0, by linarith ⟩, by simp +decide ⟩;
      have := h σ i i; aesop;
    · obtain ⟨σ, hσ⟩ : ∃ σ : Equiv.Perm (Fin N), σ i = ⟨0, by linarith⟩ ∧ σ j = ⟨1, by linarith⟩ := by
        exact exists_perm_map_pair hij ( by aesop );
      have := h σ i j; aesop;
  · intro σ i j; have := h i j; have := h (σ i) (σ j); aesop;

/-
Thus full permutation invariance itself forces the exact counting law.
-/
theorem numberVariance_permutationInvariant {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} (hInv : PermutationInvariant C)
    (A : Finset (Fin N)) :
    numberVariance C A =
      (A.card : ℝ) * C ⟨0, by omega⟩ ⟨0, by omega⟩ +
      (A.card : ℝ) * ((A.card : ℝ) - 1) * C ⟨0, by omega⟩ ⟨1, by omega⟩ := by
  convert numberVariance_exchangeable _ A;
  convert permutationInvariant_iff_exchangeable hN C |>.1 hInv using 1

/-
Full permutation invariance and fixed total give the closed variance formula directly.
-/
theorem numberVariance_permutationInvariant_fixedTotal {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} (hInv : PermutationInvariant C)
    (htotal : numberVariance C Finset.univ = 0) (A : Finset (Fin N)) :
    numberVariance C A =
      C ⟨0, by omega⟩ ⟨0, by omega⟩ * (A.card : ℝ) *
        ((N : ℝ) - (A.card : ℝ)) / ((N : ℝ) - 1) := by
  apply numberVariance_fixedTotal;
  exact hN;
  convert permutationInvariant_iff_exchangeable hN C |>.1 hInv;
  exact htotal

/-
Under full permutation invariance, a zero diagonal entry of a PSD covariance
forces total suppression.
-/
theorem permutationInvariant_eq_zero_of_diagonal_zero {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} (hInv : PermutationInvariant C)
    (hpsd : C.PosSemidef) (hzero : C ⟨0, by omega⟩ ⟨0, by omega⟩ = 0) : C = 0 := by
  apply exchangeable_eq_zero_of_a_eq_zero
  · exact (permutationInvariant_iff_exchangeable hN C).mp hInv
  · exact hpsd
  · exact hzero

/-
The linear regional lower bound, stated directly for full permutation invariance.
-/
theorem permutationInvariant_linear_lower_bound {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} (hInv : PermutationInvariant C)
    (hpsd : C.PosSemidef) (htotal : numberVariance C Finset.univ = 0)
    (A : Finset (Fin N)) (hA : 2 * A.card ≤ N) :
    C ⟨0, by omega⟩ ⟨0, by omega⟩ * (A.card : ℝ) / 2 ≤ numberVariance C A := by
  obtain ⟨a, b, hC⟩ : ∃ a b : ℝ, Exchangeable C a b := by
    exact ⟨ _, _, ( permutationInvariant_iff_exchangeable hN C ).mp hInv ⟩;
  convert numberVariance_linear_lower_bound hN hC hpsd htotal A hA using 1;
  exact hC _ _ ▸ by norm_num;

/-
The no-hyperuniformity dichotomy stated directly for full permutation invariance.
-/
theorem permutationInvariant_dichotomy {N : ℕ} (hN : 2 ≤ N)
    {C : Matrix (Fin N) (Fin N) ℝ} (hInv : PermutationInvariant C)
    (hpsd : C.PosSemidef) (htotal : numberVariance C Finset.univ = 0) :
    C = 0 ∨
      (0 < C ⟨0, by omega⟩ ⟨0, by omega⟩ ∧
        ∀ A : Finset (Fin N), A.Nonempty → 2 * A.card ≤ N →
          0 < numberVariance C A ∧
            C ⟨0, by omega⟩ ⟨0, by omega⟩ * (A.card : ℝ) / 2 ≤
              numberVariance C A) := by
  convert frameBlind_dichotomy hN _ hpsd htotal using 1;
  exact C ⟨ 0, by linarith ⟩ ⟨ 1, by linarith ⟩;
  convert permutationInvariant_iff_exchangeable hN C |>.1 hInv using 1

/-! A concrete sharpness example at `N = 4`. It is the rank-one matrix `v vᵀ` for
`v = (1,-1,1,-1)`. Its total mode and the region `{0,1}` are suppressed, while its
positive diagonal and unequal off-diagonal entries witness non-invariance. -/

def sharpVector : Fin 4 → ℝ := fun i => ![1, -1, 1, -1] i

def sharpMatrix : Matrix (Fin 4) (Fin 4) ℝ := fun i j => sharpVector i * sharpVector j

def sharpRegion : Finset (Fin 4) := {0, 1}

theorem sharpMatrix_psd : sharpMatrix.PosSemidef := by
  constructor <;> norm_num [ Matrix.mulVec, dotProduct ];
  · ext i j; simp +decide [ sharpMatrix ] ; ring;
  · intro x
    have h_sum : ∑ i, ∑ j, x i * x j * (sharpVector i * sharpVector j) = (∑ i, x i * sharpVector i) ^ 2 := by
      simp +decide only [mul_comm, mul_assoc, pow_two, Finset.mul_sum _ _ _, mul_left_comm];
    simp_all +decide [ Finsupp.sum_fintype, sharpMatrix ];
    convert h_sum.symm ▸ sq_nonneg _ using 1 ; ring!;
    ac_rfl

theorem sharpMatrix_fixedTotal : numberVariance sharpMatrix Finset.univ = 0 := by
  unfold numberVariance sharpMatrix;
  unfold regionIndicator sharpVector; norm_num [ Fin.sum_univ_succ, dotProduct, Matrix.mulVec ] ;

theorem sharpMatrix_positive_diagonal : 0 < sharpMatrix 0 0 := by
  unfold sharpMatrix; norm_num [ sharpVector ] ;

theorem sharpMatrix_region_suppressed : numberVariance sharpMatrix sharpRegion = 0 := by
  unfold numberVariance;
  unfold regionIndicator sharpMatrix; norm_num [ Fin.sum_univ_succ, Matrix.mulVec, dotProduct ] ;
  unfold sharpRegion sharpVector; norm_num [ Fin.sum_univ_succ ] ;

theorem sharpMatrix_not_invariant : ¬ PermutationInvariant sharpMatrix := by
  intro h;
  convert h ( Equiv.swap 1 2 ) 0 1 using 1 ; norm_num [ Fin.ext_iff, Fin.forall_fin_succ ];
  unfold sharpMatrix; norm_num [ Equiv.swap_apply_def ] ;
  unfold sharpVector; norm_num [ Fin.ext_iff ] ;
  erw [ Matrix.cons_val_succ' ] ; norm_num

/-
A single existential statement collecting all features of the sharp non-invariant
counterexample.
-/
theorem exists_noninvariant_suppressed_region :
    ∃ (C : Matrix (Fin 4) (Fin 4) ℝ) (A : Finset (Fin 4)),
      C.PosSemidef ∧ numberVariance C Finset.univ = 0 ∧ 0 < C 0 0 ∧
      numberVariance C A = 0 ∧ ¬ PermutationInvariant C := by
  refine' ⟨ sharpMatrix, sharpRegion, _, _, _, _, _ ⟩ <;> norm_num [ sharpMatrix_psd, sharpMatrix_fixedTotal, sharpMatrix_positive_diagonal, sharpMatrix_region_suppressed, sharpMatrix_not_invariant ]

/-
Applying a permutation to a region preserves its number variance whenever the
covariance is invariant under that permutation.
-/
theorem numberVariance_image_eq {N : ℕ} {C : Matrix (Fin N) (Fin N) ℝ}
    (σ : Equiv.Perm (Fin N))
    (hInv : ∀ i j, C (σ i) (σ j) = C i j)
    (A : Finset (Fin N)) :
    numberVariance C (A.map σ.toEmbedding) = numberVariance C A := by
  unfold numberVariance;
  unfold regionIndicator;
  simp +decide [ dotProduct, Matrix.mulVec, Finset.sum_ite ];
  convert Finset.sum_image ?_ using 2;
  rotate_left;
  rotate_left;
  infer_instance;
  use fun x => σ x;
  · exact σ.injective.injOn;
  · ext; aesop;
  · refine' Finset.sum_bij ( fun x hx => σ x ) _ _ _ _ <;> aesop

#print axioms numberVariance_exchangeable
#print axioms totalVariance_exchangeable
#print axioms offDiagonal_eq_of_fixedTotal
#print axioms numberVariance_fixedTotal
#print axioms diagonal_nonnegative
#print axioms totalVariance_nonnegative
#print axioms exchangeable_psd_signs
#print axioms posSemidef_eq_zero_of_diagonal_eq_zero
#print axioms exchangeable_eq_zero_of_a_eq_zero
#print axioms numberVariance_linear_lower_bound
#print axioms frameBlind_dichotomy
#print axioms exists_perm_map_pair
#print axioms permutationInvariant_iff_exchangeable
#print axioms numberVariance_permutationInvariant
#print axioms numberVariance_permutationInvariant_fixedTotal
#print axioms permutationInvariant_eq_zero_of_diagonal_zero
#print axioms permutationInvariant_linear_lower_bound
#print axioms permutationInvariant_dichotomy
#print axioms sharpMatrix_psd
#print axioms sharpMatrix_fixedTotal
#print axioms sharpMatrix_positive_diagonal
#print axioms sharpMatrix_region_suppressed
#print axioms sharpMatrix_not_invariant
#print axioms exists_noninvariant_suppressed_region
#print axioms numberVariance_image_eq

end FrameBlindVariance
