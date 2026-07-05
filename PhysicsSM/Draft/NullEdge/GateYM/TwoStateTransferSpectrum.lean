import PhysicsSM.Draft.NullEdge.GateYM.TransferGapDefinition

/-!
# Gate YM: two-state transfer spectrum bridge

This draft module records the smallest Lean-facing transfer-spectrum payload
used by the finite Z2 Wilson-slab oracle:

* a complex `2 x 2` transfer matrix `!![a, b; b, a]`;
* the vacuum vector `(1, 1)` and local/flux excitation `(1, -1)`;
* their eigenvalue equations with eigenvalues `a + b` and `a - b`;
* the finite spectral-ratio gap convention for this two-state payload.

It is intentionally only a finite identity / descriptor bridge.  It does not
construct the full Wilson slab transfer operator, Gauss projector, OS/GNS
Hilbert space, Hamiltonian, infinite-volume state, or physical mass-gap theorem.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: finite identity / descriptor bridge.
-/

noncomputable section

open scoped Matrix

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TwoStateTransferSpectrum

/-- The complex `2 x 2` transfer matrix `!![a, b; b, a]`.

For the one-link Z2 Wilson slab, `a` and `b` are the two positive real transfer
weights.  This definition is only the spectral payload shape; the full lattice
slab kernel lives in the executable oracle for now. -/
def transfer2 (a b : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(a : ℂ), (b : ℂ); (b : ℂ), (a : ℂ)]

/-- The unnormalized vacuum vector `(1, 1)`. -/
def vacuumVec : Fin 2 → ℂ :=
  fun _ => 1

/-- The unnormalized local/flux excitation vector `(1, -1)`. -/
def localVec : Fin 2 → ℂ :=
  ![(1 : ℂ), -1]

/-- The leading/vacuum eigenvalue branch. -/
def lambda0 (a b : ℝ) : ℝ :=
  a + b

/-- The local/flux excitation eigenvalue branch. -/
def lambdaLocal (a b : ℝ) : ℝ :=
  a - b

/-- The two-state finite spectral-ratio gap, using the GateYM D12 convention. -/
def localGap (a b : ℝ) : ℝ :=
  TransferGapDefinition.finiteMassGap (lambda0 a b) (lambdaLocal a b)

/-- The local/vacuum contraction factor attached to the two-state payload. -/
def localSpectralRatio (a b : ℝ) : ℝ :=
  lambdaLocal a b / lambda0 a b

/-- The transfer matrix is symmetric. -/
theorem transfer2_transpose (a b : ℝ) :
    (transfer2 a b)ᵀ = transfer2 a b := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [transfer2, Matrix.transpose_apply]

/-- The transfer matrix is Hermitian, since all entries are real. -/
theorem transfer2_conjTranspose (a b : ℝ) :
    (transfer2 a b)ᴴ = transfer2 a b := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [transfer2, Matrix.conjTranspose]

/-- `(1, 1)` is an eigenvector with eigenvalue `a + b`. -/
theorem transfer2_mulVec_vacuum (a b : ℝ) :
    (transfer2 a b) *ᵥ vacuumVec =
      ((lambda0 a b : ℝ) : ℂ) • vacuumVec := by
  funext i
  fin_cases i
  · simp [transfer2, vacuumVec, lambda0, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]
  · simp [transfer2, vacuumVec, lambda0, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]
    ring

/-- `(1, -1)` is an eigenvector with eigenvalue `a - b`. -/
theorem transfer2_mulVec_local (a b : ℝ) :
    (transfer2 a b) *ᵥ localVec =
      ((lambdaLocal a b : ℝ) : ℂ) • localVec := by
  funext i
  fin_cases i
  · simp [transfer2, localVec, lambdaLocal, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]
    ring
  · simp [transfer2, localVec, lambdaLocal, Matrix.mulVec, dotProduct,
      Fin.sum_univ_two]
    ring

/-- The vacuum vector is nonzero. -/
theorem vacuumVec_ne_zero : vacuumVec ≠ 0 := by
  intro h
  have h0 := congrFun h (0 : Fin 2)
  simp [vacuumVec] at h0

/-- The local/flux excitation vector is nonzero. -/
theorem localVec_ne_zero : localVec ≠ 0 := by
  intro h
  have h0 := congrFun h (0 : Fin 2)
  simp [localVec] at h0

/-- The local/flux excitation vector is distinct from the vacuum vector. -/
theorem localVec_ne_vacuumVec : localVec ≠ vacuumVec := by
  intro h
  have h1 := congrFun h (1 : Fin 2)
  norm_num [localVec, vacuumVec] at h1

/-- Positivity of the vacuum eigenvalue branch when `0 < b < a`. -/
theorem lambda0_pos {a b : ℝ} (hb : 0 < b) (hba : b < a) :
    0 < lambda0 a b := by
  simp [lambda0]
  linarith

/-- Positivity of the local/flux eigenvalue branch when `0 < b < a`. -/
theorem lambdaLocal_pos {a b : ℝ} (_hb : 0 < b) (hba : b < a) :
    0 < lambdaLocal a b := by
  simp [lambdaLocal]
  linarith

/-- Strict spectral separation of the local/flux branch from the vacuum branch. -/
theorem lambdaLocal_lt_lambda0 {a b : ℝ} (hb : 0 < b) :
    lambdaLocal a b < lambda0 a b := by
  simp [lambdaLocal, lambda0]
  linarith

/-- The two-state local spectral ratio is positive. -/
theorem localSpectralRatio_pos {a b : ℝ} (hb : 0 < b) (hba : b < a) :
    0 < localSpectralRatio a b := by
  exact div_pos (lambdaLocal_pos hb hba) (lambda0_pos hb hba)

/-- The two-state local spectral ratio is strictly below one. -/
theorem localSpectralRatio_lt_one {a b : ℝ} (hb : 0 < b) (hba : b < a) :
    localSpectralRatio a b < 1 := by
  unfold localSpectralRatio
  have hratio :
      lambdaLocal a b / lambda0 a b < lambda0 a b / lambda0 a b :=
    div_lt_div_of_pos_right (lambdaLocal_lt_lambda0 hb) (lambda0_pos hb hba)
  simpa [div_self (lambda0_pos hb hba).ne'] using hratio

/-- The two-state local spectral ratio lies in the open interval `(0, 1)`. -/
theorem localSpectralRatio_mem_Ioo {a b : ℝ} (hb : 0 < b) (hba : b < a) :
    localSpectralRatio a b ∈ Set.Ioo (0 : ℝ) 1 :=
  ⟨localSpectralRatio_pos hb hba, localSpectralRatio_lt_one hb hba⟩

/-- Strict spectral separation gives a positive finite spectral-ratio gap. -/
theorem localGap_pos {a b : ℝ} (hb : 0 < b) (hba : b < a) :
    0 < localGap a b := by
  exact TransferGapDefinition.finiteMassGap_pos
    (lambda0_pos hb hba)
    (lambdaLocal_pos hb hba)
    (lambdaLocal_lt_lambda0 hb)

/-- Exponentiating the negative two-state gap recovers the local/vacuum
spectral ratio. -/
theorem exp_neg_localGap_eq_localSpectralRatio {a b : ℝ}
    (hb : 0 < b) (hba : b < a) :
    Real.exp (-(localGap a b)) = localSpectralRatio a b := by
  unfold localGap localSpectralRatio TransferGapDefinition.finiteMassGap
  rw [neg_neg, Real.exp_log]
  exact div_pos (lambdaLocal_pos hb hba) (lambda0_pos hb hba)

/-- A bundled descriptor for the positive two-state spectral payload. -/
structure Descriptor where
  /-- The diagonal transfer weight. -/
  a : ℝ
  /-- The off-diagonal transfer weight. -/
  b : ℝ
  /-- Positive off-diagonal weight. -/
  b_pos : 0 < b
  /-- Strict ordering that makes the local branch positive. -/
  b_lt_a : b < a

namespace Descriptor

/-- The descriptor's transfer matrix. -/
def matrix (D : Descriptor) : Matrix (Fin 2) (Fin 2) ℂ :=
  transfer2 D.a D.b

/-- The descriptor's leading/vacuum eigenvalue branch. -/
def vacuumEigenvalue (D : Descriptor) : ℝ :=
  lambda0 D.a D.b

/-- The descriptor's local/flux eigenvalue branch. -/
def localEigenvalue (D : Descriptor) : ℝ :=
  lambdaLocal D.a D.b

/-- The descriptor's finite spectral-ratio gap. -/
def gap (D : Descriptor) : ℝ :=
  localGap D.a D.b

/-- The descriptor's local/vacuum contraction factor. -/
def contractionFactor (D : Descriptor) : ℝ :=
  localSpectralRatio D.a D.b

/-- The descriptor matrix has the vacuum eigenvector with the named leading
eigenvalue. -/
theorem matrix_mulVec_vacuum (D : Descriptor) :
    D.matrix *ᵥ vacuumVec =
      ((D.vacuumEigenvalue : ℝ) : ℂ) • vacuumVec := by
  simpa [matrix, vacuumEigenvalue] using transfer2_mulVec_vacuum D.a D.b

/-- The descriptor matrix has the local/flux eigenvector with the named local
eigenvalue. -/
theorem matrix_mulVec_local (D : Descriptor) :
    D.matrix *ᵥ localVec =
      ((D.localEigenvalue : ℝ) : ℂ) • localVec := by
  simpa [matrix, localEigenvalue] using transfer2_mulVec_local D.a D.b

/-- The descriptor's leading eigenvalue is positive. -/
theorem vacuumEigenvalue_pos (D : Descriptor) :
    0 < D.vacuumEigenvalue := by
  simpa [vacuumEigenvalue] using lambda0_pos D.b_pos D.b_lt_a

/-- The descriptor's local eigenvalue is positive. -/
theorem localEigenvalue_pos (D : Descriptor) :
    0 < D.localEigenvalue := by
  simpa [localEigenvalue] using lambdaLocal_pos D.b_pos D.b_lt_a

/-- The descriptor's local eigenvalue lies strictly below the leading
eigenvalue. -/
theorem localEigenvalue_lt_vacuumEigenvalue (D : Descriptor) :
    D.localEigenvalue < D.vacuumEigenvalue := by
  simpa [localEigenvalue, vacuumEigenvalue] using
    lambdaLocal_lt_lambda0 D.b_pos

/-- The descriptor's finite spectral-ratio gap is positive. -/
theorem gap_pos (D : Descriptor) :
    0 < D.gap := by
  simpa [gap] using localGap_pos D.b_pos D.b_lt_a

/-- The descriptor's contraction factor lies in `(0, 1)`. -/
theorem contractionFactor_mem_Ioo (D : Descriptor) :
    D.contractionFactor ∈ Set.Ioo (0 : ℝ) 1 := by
  simpa [contractionFactor] using
    localSpectralRatio_mem_Ioo D.b_pos D.b_lt_a

/-- The descriptor's contraction factor is recovered by exponentiating the
negative gap. -/
theorem exp_neg_gap_eq_contractionFactor (D : Descriptor) :
    Real.exp (-D.gap) = D.contractionFactor := by
  simpa [gap, contractionFactor] using
    exp_neg_localGap_eq_localSpectralRatio D.b_pos D.b_lt_a

end Descriptor

end TwoStateTransferSpectrum
end GateYM
end NullEdge
end Draft
end PhysicsSM
