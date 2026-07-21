import Mathlib

/-!
# CP violation requires three generations (Opus, verified Aristotle e85fede0)

Kobayashi-Maskawa threshold from the landed Jarlskog invariant: every 1-generation
quartet vanishes; every 2x2 unitary has vanishing quartets AND can be made
entrywise real by unit-norm row/column rephasing; the normalized 3x3 Fourier matrix
is unitary with explicit nonzero quartet. Hence a nonzero Jarlskog invariant
REQUIRES n >= 3 generations - the CP threshold behind the A2 '+1 CP phase'.

Namespace kept as the prover's (verbatim, preserving proofs). Provenance:
verified at the pinned toolchain from Aristotle project e85fede0.
Clean-room Mathlib port; standard three axioms. Claim grade M, [comp]. -/

open scoped BigOperators ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace CKM

/-- The imaginary part of a rephasing-invariant CKM quartet. -/
def jarlskogQuartet {n : ℕ} (V : Matrix (Fin n) (Fin n) ℂ)
    (i k j l : Fin n) : ℝ :=
  (V i j * conj (V k j) * V k l * conj (V i l)).im

/-- Unitarity, phrased as membership in Mathlib's unitary matrix group. -/
def IsUnitary {n : ℕ} (V : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  V ∈ Matrix.unitaryGroup (Fin n) ℂ

/-- A nonzero quartet is the algebraic signal of CKM CP violation. -/
def HasNonzeroQuartet (n : ℕ) : Prop :=
  ∃ (V : Matrix (Fin n) (Fin n) ℂ), IsUnitary V ∧
    ∃ i k j l, jarlskogQuartet V i k j l ≠ 0

/-- The standard number of physical CKM CP phases for `n` generations. -/
def ckmPhysCP (n : ℕ) : ℕ := (n - 1) * (n - 2) / 2

/-
With one generation every quartet vanishes, without any unitarity assumption.
-/
theorem jarlskogQuartet_fin_one_zero
    (V : Matrix (Fin 1) (Fin 1) ℂ) (i k j l : Fin 1) :
    jarlskogQuartet V i k j l = 0 := by
  fin_cases i ; fin_cases k ; fin_cases j ; fin_cases l ; norm_num [ jarlskogQuartet ];
  ring

/-
The two-generation obstruction: every quartet of every unitary `2 × 2`
matrix is real, hence has zero imaginary part.  This is the invariant form of
the statement that all phases can be removed by row/column rephasing.
-/
theorem jarlskogQuartet_fin_two_zero
    (V : Matrix (Fin 2) (Fin 2) ℂ) (hV : IsUnitary V)
    (i k j l : Fin 2) :
    jarlskogQuartet V i k j l = 0 := by
  fin_cases i <;> fin_cases k <;> fin_cases j <;> fin_cases l <;> simp_all +decide [ jarlskogQuartet ];
  all_goals ring;
  · have := hV.2;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, Complex.ext_iff ];
    grind +ring;
  · simp_all +decide [IsUnitary];
    have := hV.2;
    rw [ ← Matrix.ext_iff ] at this;
    simp_all +decide [ Fin.forall_fin_two, Matrix.mul_apply, Complex.ext_iff ];
    grind;
  · obtain ⟨h₁, h₂⟩ : V 0 0 * starRingEnd ℂ (V 0 0) + V 0 1 * starRingEnd ℂ (V 0 1) = 1 ∧ V 1 0 * starRingEnd ℂ (V 1 0) + V 1 1 * starRingEnd ℂ (V 1 1) = 1 ∧ V 0 0 * starRingEnd ℂ (V 1 0) + V 0 1 * starRingEnd ℂ (V 1 1) = 0 ∧ V 1 0 * starRingEnd ℂ (V 0 0) + V 1 1 * starRingEnd ℂ (V 0 1) = 0 := by
      have h_unitary : V * star V = 1 := by
        exact hV.2;
      simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ];
    norm_num [ Complex.ext_iff ] at *;
    grind +ring;
  · have := hV;
    replace := congr_fun ( congr_fun this.2 0 ) 1; norm_num [ Matrix.mul_apply, Complex.ext_iff ] at this;
    grind

/-- A matrix can be made entrywise real by independent unit-modulus row and
column phase changes. -/
def CanBeMadeRealByRephasing {n : ℕ}
    (V : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  ∃ rowPhase colPhase : Fin n → ℂ,
    (∀ i, ‖rowPhase i‖ = 1) ∧
    (∀ j, ‖colPhase j‖ = 1) ∧
    ∀ i j, (rowPhase i * V i j * colPhase j).im = 0

/-
Every unitary two-generation mixing matrix can be made real by rephasing.
-/
theorem unitary_fin_two_canBeMadeRealByRephasing
    (V : Matrix (Fin 2) (Fin 2) ℂ) (hV : IsUnitary V) :
    CanBeMadeRealByRephasing V := by
  obtain ⟨rowPhase, colPhase, h_rowPhase, h_colPhase, h_real⟩ : ∃ (rowPhase colPhase : Fin 2 → ℂ), (∀ i, rowPhase i ≠ 0) ∧ (∀ j, colPhase j ≠ 0) ∧ (∀ i j, Complex.im (rowPhase i * V i j * colPhase j) = 0) := by
    by_cases ha : V 0 0 = 0 <;> by_cases hb : V 0 1 = 0 <;> by_cases hc : V 1 0 = 0 <;> by_cases hd : V 1 1 = 0 <;> simp_all +decide [ Fin.forall_fin_two ];
    all_goals have := hV.2; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two ];
    all_goals simp_all +decide [ Matrix.mul_apply ];
    · refine' ⟨ fun i => if i = 0 then 1 / V 0 1 else 1 / V 1 0, _, fun i => 1, _, _, _ ⟩ <;> simp_all +decide [ Complex.ext_iff ]; all_goals ring;
    · refine' ⟨ fun i => if i = 0 then starRingEnd ℂ ( V 0 0 ) else starRingEnd ℂ ( V 1 1 ), _, fun i => 1, _, _, _ ⟩ <;> simp_all +decide [ Complex.ext_iff ]; all_goals ring;
    · refine' ⟨ fun i => if i = 0 then ( V 0 0 ) ⁻¹ else ( V 1 0 ) ⁻¹, _, fun i => if i = 0 then 1 else ( V 0 1 / V 0 0 ) ⁻¹, _, _ ⟩ <;> simp_all +decide [ Complex.ext_iff ];
      simp_all +decide [ Complex.normSq, Complex.div_re, Complex.div_im ];
      grind;
  refine' ⟨ fun i => rowPhase i / ‖rowPhase i‖, fun j => colPhase j / ‖colPhase j‖, _, _, _ ⟩ <;> simp_all +decide [ Complex.div_re, Complex.div_im ];
  grind

/-
No nonzero CKM quartet exists with one generation.
-/
theorem not_hasNonzeroQuartet_one : ¬ HasNonzeroQuartet 1 := by
  rintro ⟨ V, hV, i, k, j, l, h ⟩ ; exact h ( jarlskogQuartet_fin_one_zero V i k j l ) ;

/-
No nonzero CKM quartet exists with two generations.
-/
theorem not_hasNonzeroQuartet_two : ¬ HasNonzeroQuartet 2 := by
  -- Assume for contradiction that there exists a nonzero CKM quartet with two generations.
  by_contra h_contra;
  obtain ⟨V, hV_unitary, i, k, j, l, h_quartet⟩ : ∃ V : Matrix (Fin 2) (Fin 2) ℂ, IsUnitary V ∧ ∃ i k j l : Fin 2, jarlskogQuartet V i k j l ≠ 0 := by
    exact h_contra;
  exact h_quartet <| jarlskogQuartet_fin_two_zero V hV_unitary i k j l

private noncomputable def sqrtThree : ℝ := Real.sqrt 3
private noncomputable def invSqrtThree : ℝ := 1 / Real.sqrt 3
private noncomputable def omega : ℂ := (-1 / 2 : ℝ) + (Real.sqrt 3 / 2) * Complex.I

/-- The normalized three-point Fourier matrix, an explicit CKM witness. -/
noncomputable def fourierThree : Matrix (Fin 3) (Fin 3) ℂ :=
  let r : ℂ := (invSqrtThree : ℂ)
  let w : ℂ := omega
  !![r, r, r;
     r, r * w, r * w ^ 2;
     r, r * w ^ 2, r * w]

/-
The explicit Fourier witness is unitary.
-/
theorem fourierThree_unitary : IsUnitary fourierThree := by
  -- To prove unitarity, we need to show that for any i, j, the sum over k of fourierThree i k * conj fourierThree j k equals 1 if i = j and 0 otherwise.
  have h_unitary : ∀ i j, ∑ k, fourierThree i k * starRingEnd ℂ (fourierThree j k) = if i = j then 1 else 0 := by
    unfold fourierThree; norm_num [ Fin.sum_univ_succ, Complex.ext_iff ] ;
    simp +decide [ Fin.forall_fin_succ, omega, invSqrtThree ] ; ring_nf ; norm_num;
    norm_cast; norm_num [ pow_three ] ; ring_nf ; norm_num;
    nlinarith [ Real.sq_sqrt <| show 0 ≤ 3 by norm_num ];
  convert Matrix.mem_unitaryGroup_iff.mpr _;
  ext i j; aesop;

/-
A specified quartet of the Fourier witness is nonzero.
-/
theorem fourierThree_quartet_nonzero :
    jarlskogQuartet fourierThree 0 1 0 1 ≠ 0 := by
  unfold jarlskogQuartet fourierThree;
  norm_num [ sq, Complex.normSq, Complex.div_re, Complex.div_im, omega ] ; ring_nf;
  exact ne_of_gt <| one_div_pos.mpr <| Real.sqrt_pos.mpr zero_lt_three

/-
Three generations admit a unitary matrix with a nonzero quartet.
-/
theorem hasNonzeroQuartet_three : HasNonzeroQuartet 3 := by
  exact ⟨ fourierThree, fourierThree_unitary, 0, 1, 0, 1, fourierThree_quartet_nonzero ⟩

/-
A nonzero quartet requires at least three generations.
-/
theorem nonzero_quartet_requires_three {n : ℕ} :
    HasNonzeroQuartet n → 3 ≤ n := by
  intro h_nonzero
  by_contra h_contra
  have h_gen : n < 3 := by
    exact lt_of_not_ge h_contra;
  interval_cases n <;> simp_all +decide [ not_hasNonzeroQuartet_one, not_hasNonzeroQuartet_two ];
  obtain ⟨ V, hV, i, k, j, l, h ⟩ := h_nonzero; fin_cases i;

/-
The physical CKM phase count is positive exactly at the KM threshold.
-/
theorem ckmPhysCP_pos_iff (n : ℕ) :
    0 < ckmPhysCP n ↔ 3 ≤ n := by
  rcases n with ( _ | _ | _ | n ) <;> simp +arith +decide [ ckmPhysCP ];
  nlinarith

/-
Capstone bridge: quartet CP violation implies precisely the positivity
threshold of the physical CKM phase count.
-/
theorem jarlskog_kobayashi_maskawa_bridge {n : ℕ}
    (hCP : HasNonzeroQuartet n) :
    0 < ckmPhysCP n := by
  exact ckmPhysCP_pos_iff n |>.2 ( nonzero_quartet_requires_three hCP )

end CKM

#print axioms CKM.jarlskogQuartet_fin_one_zero
#print axioms CKM.jarlskogQuartet_fin_two_zero
#print axioms CKM.unitary_fin_two_canBeMadeRealByRephasing
#print axioms CKM.fourierThree_unitary
#print axioms CKM.fourierThree_quartet_nonzero
#print axioms CKM.hasNonzeroQuartet_three
#print axioms CKM.nonzero_quartet_requires_three
#print axioms CKM.ckmPhysCP_pos_iff
#print axioms CKM.jarlskog_kobayashi_maskawa_bridge
