import Mathlib

/-!
# General Hermitian transfer bridge (Opus, verified Aristotle 870e4b24)

Spectral-theorem lift of the diagonal transfer-mass bridge to any symmetric
positive-definite T: RealSpectralData (eigenvalues+orthonormal eigenbasis),
eigenvalue positivity, <v,T^n v>=sum_i <e_i,v>^2 mu_i^n, connected expansion
after removing the top eigenspace. Namespace kept as prover's HermitianTransfer.
Provenance: verified at pin from task ba1bc54f. Standard three. Grade M,[comp]. -/

open scoped BigOperators
open Finset Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace HermitianTransfer

/-- Elementary spectral data for a real matrix.  The three fields say that `e` is an
orthonormal eigenbasis with eigenvalue function `μ`.  This formulation keeps the
transfer lemmas independent of any particular ordering convention used by the
spectral theorem. -/
structure RealSpectralData (m : ℕ) (T : Matrix (Fin m) (Fin m) ℝ) where
  μ : Fin m → ℝ
  e : Fin m → (Fin m → ℝ)
  orthonormal : ∀ i j, dotProduct (e i) (e j) = if i = j then 1 else 0
  complete : ∀ v, v = ∑ i, (dotProduct (e i) v) • e i
  eigenvector : ∀ i, T *ᵥ e i = μ i • e i

variable {m : ℕ} {T : Matrix (Fin m) (Fin m) ℝ}

lemma hermitian_eigenvectorBasis_dotProduct
    (hT : T.IsHermitian) (i j : Fin m) :
    dotProduct (⇑(hT.eigenvectorBasis i)) (⇑(hT.eigenvectorBasis j)) =
      if i = j then 1 else 0 := by
  have := hT.eigenvectorBasis.orthonormal; simp_all +decide [ orthonormal_iff_ite ] ;
  simp +decide [← this i j, dotProduct];
  simp +decide [ mul_comm, inner ]

lemma hermitian_eigenvectorBasis_complete
    (hT : T.IsHermitian) (v : Fin m → ℝ) :
    v = ∑ i, (dotProduct (⇑(hT.eigenvectorBasis i)) v) •
      ⇑(hT.eigenvectorBasis i) := by
  have h_orthonormal : ∀ i j, dotProduct (⇑(hT.eigenvectorBasis i)) (⇑(hT.eigenvectorBasis j)) = if i = j then 1 else 0 := by
    convert hermitian_eigenvectorBasis_dotProduct hT using 1;
  have h_complete : ∀ v : EuclideanSpace ℝ (Fin m), v = ∑ i, (inner ℝ (hT.eigenvectorBasis i) v) • (hT.eigenvectorBasis i) := by
    convert OrthonormalBasis.sum_repr' ( hT.eigenvectorBasis ) using 1;
    rw [ eq_comm ];
  convert h_complete ( EuclideanSpace.equiv ( Fin m ) ℝ |>.symm v ) using 1;
  simp +decide [ funext_iff, dotProduct, inner ];
  constructor <;> intro h;
  · convert h_complete ( EuclideanSpace.equiv ( Fin m ) ℝ |>.symm v ) using 1;
  · intro i; replace h := congr_arg ( fun f => f i ) h; simp +decide [ mul_comm ] at h ⊢;
    convert h using 1

/-- Mathlib's spectral theorem supplies the abstract spectral data used below for
every real Hermitian (equivalently, symmetric) matrix. -/
noncomputable def hermitianSpectralData (hT : T.IsHermitian) : RealSpectralData m T where
  μ := hT.eigenvalues
  e := fun i ↦ ⇑(hT.eigenvectorBasis i)
  orthonormal := hermitian_eigenvectorBasis_dotProduct hT
  complete := hermitian_eigenvectorBasis_complete hT
  eigenvector := hT.mulVec_eigenvectorBasis

/-
For a positive-definite Hermitian matrix all eigenvalues in the spectral data
constructed by `hermitianSpectralData` are positive.
-/
theorem hermitianSpectralData_eigenvalue_pos
    (hT : T.IsHermitian) (hpos : T.PosDef) (i : Fin m) :
    0 < (hermitianSpectralData hT).μ i := by
  convert hT.posDef_iff_eigenvalues_pos.mp hpos i using 1

lemma RealSpectralData.pow_mulVec_eigenvector
    (S : RealSpectralData m T) (i : Fin m) (n : ℕ) :
    (T ^ n) *ᵥ S.e i = (S.μ i) ^ n • S.e i := by
  induction' n with n ih generalizing i;
  · norm_num;
  · simp_all +decide [ pow_succ', ← Matrix.mulVec_mulVec ];
    rw [ Matrix.mulVec_smul, S.eigenvector i, smul_smul, mul_comm ]

/-
Spectral expansion of a Euclidean transfer correlation.
-/
theorem spectral_correlation_expansion
    (S : RealSpectralData m T) (v : Fin m → ℝ) (n : ℕ) :
    dotProduct v ((T ^ n) *ᵥ v) =
      ∑ i, (dotProduct (S.e i) v) ^ 2 * (S.μ i) ^ n := by
  -- Apply the spectral expansion from S.complete to v.
  have h_expand : v ⬝ᵥ (T ^ n) *ᵥ v = v ⬝ᵥ (T ^ n) *ᵥ (∑ i, (S.e i ⬝ᵥ v) • S.e i) := by
    rw [ ← S.complete v ];
  -- Distribute matrix mulVec over the finite sum and coefficients.
  have h_distribute : v ⬝ᵥ (T ^ n) *ᵥ (∑ i, (S.e i ⬝ᵥ v) • S.e i) = ∑ i, (S.e i ⬝ᵥ v) • (v ⬝ᵥ (T ^ n) *ᵥ S.e i) := by
    induction' ( Finset.univ : Finset ( Fin m ) ) using Finset.induction <;> simp_all +decide [ Matrix.mulVec_add, Matrix.mulVec_smul ];
  -- Apply S.pow_mulVec_eigenvector to each term in the sum.
  have h_apply : ∀ i, v ⬝ᵥ (T ^ n) *ᵥ S.e i = (S.μ i) ^ n * (v ⬝ᵥ S.e i) := by
    intro i; rw [ RealSpectralData.pow_mulVec_eigenvector S i n ] ; simp +decide [dotProduct_smul] ;
  simp_all +decide [sq, mul_comm, mul_left_comm];
  simp +decide only [dotProduct_comm]

/-
Removing one distinguished eigenstate removes exactly its spectral summand.
-/
theorem connected_correlation_expansion
    (S : RealSpectralData m T) (v : Fin m → ℝ) (top : Fin m) (n : ℕ) :
    dotProduct v ((T ^ n) *ᵥ v) -
        (dotProduct (S.e top) v) ^ 2 * (S.μ top) ^ n =
      ∑ i ∈ Finset.univ.erase top,
        (dotProduct (S.e i) v) ^ 2 * (S.μ i) ^ n := by
  convert congr_arg ( fun x : ℝ => x - ( S.e top ⬝ᵥ v ) ^ 2 * S.μ top ^ n ) ( spectral_correlation_expansion S v n ) using 1;
  rw [ Finset.sum_erase_eq_sub ( Finset.mem_univ top ) ]

/-
The positive first-excited spectral weight gives a uniform positive lower
bound after normalization by its eigenvalue.
-/
theorem connected_ratio_lower_bound
    (S : RealSpectralData m T) (v : Fin m → ℝ) (top exc : Fin m)
    (hne : exc ≠ top) (hμ : 0 < S.μ exc)
    (hμ_nonneg : ∀ i, 0 ≤ S.μ i) (n : ℕ) :
    (dotProduct (S.e exc) v) ^ 2 ≤
      (dotProduct v ((T ^ n) *ᵥ v) -
          (dotProduct (S.e top) v) ^ 2 * (S.μ top) ^ n) /
        (S.μ exc) ^ n := by
  rw [ le_div_iff₀ ( pow_pos hμ _ ) ];
  rw [ connected_correlation_expansion ];
  exact le_trans ( by aesop ) ( Finset.single_le_sum ( fun i _ => mul_nonneg ( sq_nonneg _ ) ( pow_nonneg ( hμ_nonneg i ) _ ) ) ( Finset.mem_erase_of_ne_of_mem hne ( Finset.mem_univ _ ) ) )

/-
If every non-top eigenvalue is at most the first-excited eigenvalue, the
normalized connected correlation also has a uniform upper bound.  Together with
`connected_ratio_lower_bound`, this is an exact positive transfer-mass bridge.
-/
theorem connected_ratio_upper_bound
    (S : RealSpectralData m T) (v : Fin m → ℝ) (top exc : Fin m)
    (hμ : 0 < S.μ exc) (hμ_nonneg : ∀ i, 0 ≤ S.μ i)
    (hsecond : ∀ i, i ≠ top → S.μ i ≤ S.μ exc) (n : ℕ) :
    (dotProduct v ((T ^ n) *ᵥ v) -
          (dotProduct (S.e top) v) ^ 2 * (S.μ top) ^ n) /
        (S.μ exc) ^ n ≤
      ∑ i ∈ Finset.univ.erase top, (dotProduct (S.e i) v) ^ 2 := by
  rw [ div_le_iff₀ ( by positivity ) ];
  convert Finset.sum_le_sum fun i hi => mul_le_mul_of_nonneg_left ( pow_le_pow_left₀ ( hμ_nonneg i ) ( hsecond i ( Finset.ne_of_mem_erase hi ) ) n ) ( sq_nonneg ( dotProduct ( S.e i ) v ) ) using 1;
  convert connected_correlation_expansion S v top n using 1;
  rw [ Finset.sum_mul _ _ _ ]

/-
The bridge specialized to the conventional labels `0` and `1`.  The lower
constant is strictly positive exactly when the observable overlaps eigenvector
`1`.  Positive definiteness supplies `hμ_nonneg` (indeed strict positivity) when
these spectral data are obtained from a positive-definite symmetric matrix.
-/
theorem positive_transfer_mass_bridge
    {T₂ : Matrix (Fin (m + 2)) (Fin (m + 2)) ℝ}
    (S : RealSpectralData (m + 2) T₂) (v : Fin (m + 2) → ℝ)
    (hμtop : S.μ 1 < S.μ 0) (hμone : 0 < S.μ 1)
    (hμ_nonneg : ∀ i, 0 ≤ S.μ i)
    (hsecond : ∀ i, i ≠ 0 → S.μ i ≤ S.μ 1)
    (hoverlap : dotProduct (S.e 1) v ≠ 0) :
    let Cc : ℕ → ℝ := fun n ↦
      dotProduct v ((T₂ ^ n) *ᵥ v) -
        (dotProduct (S.e 0) v) ^ 2 * (S.μ 0) ^ n
    let c : ℝ := (dotProduct (S.e 1) v) ^ 2
    (0 < c) ∧
    (∀ n, c ≤ Cc n / (S.μ 1) ^ n) ∧
    (∀ n, Cc n / (S.μ 1) ^ n ≤
      ∑ i ∈ Finset.univ.erase 0, (dotProduct (S.e i) v) ^ 2) ∧
    (0 < Real.log (S.μ 0 / S.μ 1)) ∧
    (-Real.log (S.μ 1 / S.μ 0) = Real.log (S.μ 0 / S.μ 1)) := by
  refine' ⟨ sq_pos_of_ne_zero hoverlap, _, _, Real.log_pos _, _ ⟩;
  · exact fun n => connected_ratio_lower_bound S v 0 1 ( by aesop ) hμone hμ_nonneg n;
  · convert connected_ratio_upper_bound S v 0 1 hμone hμ_nonneg hsecond using 1;
  · rwa [ one_lt_div hμone ];
  · rw [ ← Real.log_inv, inv_div ]

end HermitianTransfer
