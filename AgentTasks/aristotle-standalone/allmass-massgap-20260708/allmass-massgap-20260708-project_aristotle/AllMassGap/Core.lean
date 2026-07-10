/-
# The carrier sector mass gap is aperture minus closure

Proof job (Aristotle). Kernel-checks the phase-diagram result of the dynamics
spectrum simulator (`Scripts/oracle/carrier_spectrum_sim.py`): on the two-edge
Cl(4) carrier the physical-sector mass form is block-diagonal with the `3x3`
Hermitian block

  B(lam, kappa) = !![lam, kappa*I, 0; -kappa*I, lam, 0; 0, 0, lam]   (I = Complex.I)

(aperture strength `lam`, closure strength `kappa`, both real). Its spectrum is
`{lam - kappa, lam, lam + kappa}`, so the **least eigenvalue is `lam - kappa`**
(for `kappa >= 0`): the squared mass gap is *aperture minus closure*, the state
is massive iff `kappa < lam`, and massless exactly on `kappa = lam`. This
generalizes the fixed `(lam,kappa)=(2,1)` point of `T2_positive_mass` to the
whole coupling plane and pins the critical line.

## Targets (proved kernel-clean, no `sorry`)

Let `lam kappa : ℝ`, `B := !![(lam:ℂ), kappa*Complex.I, 0; -(kappa*Complex.I),
lam, 0; 0, 0, lam]` (a `Matrix (Fin 3) (Fin 3) ℂ`).

- **B_isHermitian:** `B.IsHermitian`.
- **B_posDef_iff:** `B.PosDef ↔ kappa < lam ∧ -lam < kappa`  (equivalently
  `|kappa| < lam`); and for `0 ≤ kappa`, `B.PosDef ↔ kappa < lam`.
- **B_det / B_massless_iff:** `B.det = lam * (lam^2 - kappa^2)` and
  `B.det = 0 ↔ kappa = lam ∨ kappa = -lam` (the massless critical line).
- **B_least_eigenvalue:** for `0 ≤ kappa ≤ lam`, the least eigenvalue of `B` is
  `lam - kappa` (`IsLeast (Set.range B.eigenvalues) (lam - kappa)`), witnessed by
  `B - (lam-kappa)•1` being positive semidefinite (all eigenvalues `≥ lam-kappa`)
  and singular (`lam-kappa` is an eigenvalue).

Provenance: all-mass solo run 2026-07-08; kernel-checks carrier_spectrum_sim.py
and generalizes T2_positive_mass. [orig].
-/

import Mathlib

namespace AllMassGap

open Matrix Complex

open scoped ComplexOrder

/-- The carrier-sector `3×3` Hermitian mass block with aperture strength `lam`
and closure strength `kappa`. -/
noncomputable def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

/-
The carrier mass block is Hermitian.
-/
theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j;
  fin_cases i <;> fin_cases j <;> simp +decide [ B ]

/-
The determinant of the carrier mass block factors as `lam * (lam² - kappa²)`.
-/
theorem B_det (lam kappa : ℝ) :
    (B lam kappa).det = (lam : ℂ) * ((lam : ℂ) ^ 2 - (kappa : ℂ) ^ 2) := by
  simp +decide [ B, Matrix.det_fin_three ];
  ring ; norm_num

/-
Massless line (general, corrected form). The block is singular exactly when
`lam = 0` **or** `kappa = ±lam`. NOTE: the task's literal statement
`det = 0 ↔ kappa = ±lam` is false when `lam = 0` (then `det = 0` for *every*
`kappa`, since `det = lam*(lam²-kappa²)`), so the honest unconditional
biconditional must include the `lam = 0` disjunct. See `B_massless_iff_of_pos`
for the intended `lam > 0` specialization.
-/
theorem B_massless_iff (lam kappa : ℝ) :
    (B lam kappa).det = 0 ↔ lam = 0 ∨ kappa = lam ∨ kappa = -lam := by
  by_cases h : lam = 0 <;> simp_all +decide [ mul_eq_zero, sub_eq_zero ];
  · convert B_det 0 kappa;
    norm_num;
  · rw [ B_det ] ; norm_num [ sub_eq_iff_eq_add, h ];
    norm_cast ; exact ⟨ fun h => eq_or_eq_neg_of_sq_eq_sq _ _ h.symm, fun h => by rcases h with ( rfl | rfl ) <;> ring ⟩

/-
Massless line for positive aperture (`lam > 0`): singular exactly on the
critical line `kappa = ±lam`. This is the intended physical statement.
-/
theorem B_massless_iff_of_pos (lam kappa : ℝ) (hlam : 0 < lam) :
    (B lam kappa).det = 0 ↔ kappa = lam ∨ kappa = -lam := by
  exact B_massless_iff lam kappa |>.trans ⟨ fun h => by rcases h with ( rfl | rfl | rfl ) <;> simp_all +decide, fun h => by rcases h with ( rfl | rfl ) <;> simp_all +decide ⟩

/-
Positive-definiteness (massive state) holds exactly when aperture dominates
closure: `|kappa| < lam`, stated two-sided.
-/
theorem B_posDef_iff (lam kappa : ℝ) :
    (B lam kappa).PosDef ↔ kappa < lam ∧ -lam < kappa := by
  unfold B;
  constructor;
  · intro h_pos_def
    have h_pos : ∀ x : Fin 3 → ℂ, x ≠ 0 → 0 < (star x ⬝ᵥ (Matrix.of ![![lam, kappa * Complex.I, 0], ![-(kappa * Complex.I), lam, 0], ![0, 0, lam]] *ᵥ x)).re := by
      intro x hx_nonzero
      have h_pos : 0 < (star x ⬝ᵥ (Matrix.of ![![lam, kappa * Complex.I, 0], ![-(kappa * Complex.I), lam, 0], ![0, 0, lam]] *ᵥ x)) := by
        exact?;
      convert h_pos using 1;
      norm_num [ Complex.lt_def ];
      norm_num [ vecHead, vecTail ] ; ring_nf ; aesop;
    have := h_pos ( fun i => if i = 0 then -Complex.I else if i = 1 then 1 else 0 ) ; simp_all +decide [ Fin.sum_univ_three, Matrix.mulVec, dotProduct ];
    have := h_pos ( fun i => if i = 0 then Complex.I else if i = 1 then 1 else 0 ) ; simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
    linarith;
  · intro h
    have h_pos : ∀ x : Fin 3 → ℂ, x ≠ 0 → 0 < (∑ i, (∑ j, (star (x i)) * (if i = 0 ∧ j = 0 then (lam : ℂ) else if i = 1 ∧ j = 1 then (lam : ℂ) else if i = 2 ∧ j = 2 then (lam : ℂ) else if i = 0 ∧ j = 1 then (kappa : ℂ) * Complex.I else if i = 1 ∧ j = 0 then -(kappa : ℂ) * Complex.I else 0) * (x j))) := by
      intro x hx_ne_zero
      have h_pos : 0 < lam * (∑ i, ‖x i‖ ^ 2) - 2 * kappa * Complex.im (star (x 0) * x 1) := by
        have h_pos : 0 < lam * (∑ i, ‖x i‖ ^ 2) - 2 * |kappa| * ‖x 0‖ * ‖x 1‖ := by
          have h_pos : 0 < lam * (∑ i, ‖x i‖ ^ 2) - |kappa| * (∑ i, ‖x i‖ ^ 2) := by
            rw [ ← sub_mul ];
            exact mul_pos ( by cases abs_cases kappa <;> linarith ) ( lt_of_lt_of_le ( by exact lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => sq_nonneg _ ) ( Ne.symm <| by contrapose! hx_ne_zero; ext i; simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg, sq_nonneg ] ) ) le_rfl );
          norm_num [ Fin.sum_univ_three ] at *;
          nlinarith [ sq_nonneg ( ‖x 0‖ - ‖x 1‖ ), abs_nonneg kappa, norm_nonneg ( x 0 ), norm_nonneg ( x 1 ), norm_nonneg ( x 2 ) ];
        have h_im : |Complex.im (star (x 0) * x 1)| ≤ ‖x 0‖ * ‖x 1‖ := by
          exact le_trans ( Complex.abs_im_le_norm _ ) ( by simp +decide [ Complex.normSq, Complex.norm_def ] );
        cases abs_cases kappa <;> nlinarith [ abs_le.mp h_im ];
      convert h_pos using 1 ; norm_num [ Fin.sum_univ_three ] ; ring;
      simp +decide [ Complex.ext_iff, sq ] ; ring;
      rw [ Complex.lt_def ] ; norm_num [ Complex.normSq, Complex.sq_norm ] ; ring;
      exact ⟨ fun h => by linarith, fun h => ⟨ by linarith, trivial ⟩ ⟩;
    constructor <;> norm_num [ Fin.sum_univ_three ] at *;
    · ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff ] ;
    · intro x hx; specialize h_pos ( fun i => x i ) ; simp_all +decide [ Finsupp.sum_fintype, Fin.sum_univ_three ] ;

/-
For nonnegative closure, the block is positive definite iff `kappa < lam`.
-/
theorem B_posDef_iff_of_nonneg (lam kappa : ℝ) (h : 0 ≤ kappa) :
    (B lam kappa).PosDef ↔ kappa < lam := by
  -- By definition of positive definiteness, we know that $(B \lambda \kappa)$ is positive definite if and only if its eigenvalues are all positive.
  rw [B_posDef_iff];
  exact ⟨ fun h => h.1, fun h => ⟨ h, by linarith ⟩ ⟩

/-
The shifted block `B - (lam-kappa)•1` (which equals `B kappa kappa`) is
positive semidefinite when `0 ≤ kappa`: every eigenvalue of `B` is `≥ lam - kappa`.
-/
theorem B_shift_posSemidef (lam kappa : ℝ) (h0 : 0 ≤ kappa) :
    (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).PosSemidef := by
  constructor;
  · ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ B ] ;
  · have h_simp : ∀ x : Fin 3 → ℂ, (∑ i, ∑ j, star (x i) * (B lam kappa - ((lam - kappa) : ℂ) • 1) i j * x j) = kappa * (∑ i, ‖x i‖ ^ 2) - 2 * kappa * Complex.im (star (x 0) * x 1) := by
      unfold B; simp +decide [ Matrix.one_apply, Fin.sum_univ_three ] ; intros; ring;
      norm_num [ Complex.ext_iff, sq ] ; ring;
      simpa [ Complex.normSq, Complex.sq_norm ] using by ring;
    intro x; specialize h_simp x; simp_all +decide [ Finsupp.sum_fintype ] ;
    norm_cast; simp_all +decide [ Fin.sum_univ_three ];
    norm_num [ Complex.normSq, Complex.sq_norm ];
    nlinarith [ sq_nonneg ( ( x 0 |> Complex.re ) - ( x 1 |> Complex.im ) ), sq_nonneg ( ( x 0 |> Complex.im ) + ( x 1 |> Complex.re ) ), sq_nonneg ( ( x 2 |> Complex.re ) ), sq_nonneg ( ( x 2 |> Complex.im ) ) ]

/-
The shifted block `B - (lam-kappa)•1` is singular: `lam - kappa` is an
eigenvalue of `B`.
-/
theorem B_shift_det (lam kappa : ℝ) :
    (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).det = 0 := by
  simp only [B, Matrix.det_fin_three, Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply]
  simp [Matrix.cons_val]
  linear_combination (kappa : ℂ) ^ 2 * (kappa : ℂ) * Complex.I_sq

/-
The least eigenvalue of the carrier mass block is `lam - kappa` (for
`0 ≤ kappa ≤ lam`): the squared mass gap is aperture minus closure. The
hypothesis `hlk : kappa ≤ lam` was requested in the task but turns out to be
unnecessary — `lam - kappa` is the least eigenvalue for all `0 ≤ kappa`.
-/
theorem B_least_eigenvalue (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hlk : kappa ≤ lam) :
    IsLeast (Set.range (B_isHermitian lam kappa).eigenvalues) (lam - kappa) := by
  refine ⟨?_, fun x hx => ?_⟩;
  · have h_mem : lam - kappa ∈ spectrum ℝ (B lam kappa) := by
      rw [ spectrum.mem_iff ];
      convert B_shift_det lam kappa using 1;
      rw [ ← neg_sub, Matrix.isUnit_iff_isUnit_det ] ; norm_num [ Algebra.algebraMap_eq_smul_one ];
      rw [ ← neg_sub, Matrix.det_neg ] ; norm_num;
      norm_num [ Matrix.det_fin_three ];
    convert h_mem using 1;
    rw [ Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues ];
  · have h_spectrum : x - (lam - kappa) ∈ spectrum ℝ (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)) := by
      convert spectrum.sub_singleton_eq ( B lam kappa ) ( lam - kappa ) |> fun h => h.subset ( Set.mem_sub.mpr ?_ ) using 1;
      · norm_num [ Algebra.smul_def ];
        congr!;
      · simp_all +decide;
        obtain ⟨ y, rfl ⟩ := hx; exact B_isHermitian lam kappa |> fun h => h.spectrum_real_eq_range_eigenvalues.symm ▸ Set.mem_range_self _;
    have h_posSemidef : (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)).PosSemidef := by
      convert B_shift_posSemidef lam kappa h0 using 1;
    have h_eigenvalues_nonneg : ∀ y ∈ spectrum ℝ (B lam kappa - ((lam - kappa : ℝ) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)), 0 ≤ y := by
      convert h_posSemidef.eigenvalues_nonneg using 1;
      have := Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues h_posSemidef.1;
      grind +splitIndPred;
    linarith [ h_eigenvalues_nonneg _ h_spectrum ]

end AllMassGap
