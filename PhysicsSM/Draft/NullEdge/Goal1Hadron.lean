import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000

/-!
# Goal I — The verified toy hadron (one carrier, one theorem chain)

This is a clean-room, self-contained (Mathlib-only) development of a finite
"toy hadron": fermions on `Cl(4) ⊗ C^3` (spin part `Fin 4` with the real Krein
metric `eta4 = diag(1,1,-1,-1)`, color part `Fin 3` with the hollow all-ones
color closure form `Gcolor`), equipped with a Krein/closure background and a
color-Gauss constraint.

It is a **machine-verified toy**, NOT a physical pion/rho prediction, and makes
no continuum claim.  See `ARISTOTLE_SUMMARY.md`.
-/

namespace Goal1Hadron

open Matrix
open scoped Kronecker

/-! ## Rung 1 — the confinement dichotomy on the 12-dimensional carrier

We lift the `2×3` toy dichotomy (colored ⇒ negative-definite, singlet ⇒
positive-definite) to the true 12-dimensional carrier `Cl(4) ⊗ C^3` on
`Fin 4 × Fin 3`. -/

/-- The spin Krein form on `Fin 4`: `eta4 = diag(1, 1, -1, -1)`.  Spins `0,1`
are the physical (positive-signature) modes, `2,3` the null/ghost modes. -/
noncomputable def eta4 : Matrix (Fin 4) (Fin 4) ℝ :=
  Matrix.diagonal ![1, 1, -1, -1]

/-- The color closure form on `Fin 3`: the hollow all-ones matrix
`!![0,1,1; 1,0,1; 1,1,0]`, whose quadratic form is `(∑ xᵢ)² - ‖x‖²`. -/
noncomputable def Gcolor : Matrix (Fin 3) (Fin 3) ℝ := !![0, 1, 1; 1, 0, 1; 1, 1, 0]

/-- The full `Cl(4) ⊗ C^3` Krein closure form on the 12-dimensional carrier
`Fin 4 × Fin 3`. -/
noncomputable def M12 : Matrix (Fin 4 × Fin 3) (Fin 4 × Fin 3) ℝ := eta4 ⊗ₖ Gcolor

/-- Quadratic form (closure value) `qval M x = xᵀ M x`. -/
noncomputable def qval {n : Type*} [Fintype n] (M : Matrix n n ℝ) (x : n → ℝ) : ℝ :=
  x ⬝ᵥ (M *ᵥ x)

/-- The 3-dimensional color quadratic form is `(∑ xᵢ)² - ‖x‖²`. -/
lemma qval_Gcolor (x : Fin 3 → ℝ) :
    qval Gcolor x = (x 0 + x 1 + x 2) ^ 2 - (x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  simp [qval, Gcolor, dotProduct, Matrix.mulVec, Fin.sum_univ_three]
  ring

/-- The color form of a singlet (`x0 = x1 = x2`) equals `6 x0²`. -/
lemma qval_Gcolor_singlet (x : Fin 3 → ℝ) (h1 : x 0 = x 1) (h2 : x 1 = x 2) :
    qval Gcolor x = 6 * x 0 ^ 2 := by
  rw [qval_Gcolor]; rw [← h1, ← h2, ← h1]; ring

/-- The color form of a colored (traceless, `x0+x1+x2=0`) state equals
`-(x0²+x1²+x2²)`. -/
lemma qval_Gcolor_colored (x : Fin 3 → ℝ) (h : x 0 + x 1 + x 2 = 0) :
    qval Gcolor x = -(x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2) := by
  rw [qval_Gcolor, h]; ring

/-
On any state supported on the two physical spins `{0,1}` (i.e. vanishing on
the ghost spins `2,3`), the 12-dim closure form decomposes as the sum of the
color closure forms of the two physical color parts (no cross terms, since the
Krein metric is diagonal and `+1` on both physical spins).
-/
lemma qval_M12_phys (v : Fin 4 × Fin 3 → ℝ)
    (h2 : ∀ c, v (2, c) = 0) (h3 : ∀ c, v (3, c) = 0) :
    qval M12 v = qval Gcolor (fun c => v (0, c)) + qval Gcolor (fun c => v (1, c)) := by
  simp +decide only [qval];
  simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_four, Fin.sum_univ_three, M12, h2, h3, eta4, Gcolor ];
  simp +decide [Fin.sum_univ_three, diagonal];
  erw [ Finset.sum_product ] ; simp +decide [ Fin.sum_univ_four, Fin.sum_univ_three, h2, h3 ] ; ring;
  erw [ Finset.sum_product, Finset.sum_product, Finset.sum_product, Finset.sum_product, Finset.sum_product, Finset.sum_product ] ; simp +decide [ Fin.sum_univ_three ] ; ring!;

/-! ### The two sectors as submodules of the carrier -/

/-- The **color-singlet sector**: states supported on the physical spins `{0,1}`
whose color part in each physical spin is a singlet (all three colors equal). -/
def singletSector : Submodule ℝ (Fin 4 × Fin 3 → ℝ) where
  carrier := {v | (∀ c, v (2, c) = 0) ∧ (∀ c, v (3, c) = 0) ∧
    (v (0, 0) = v (0, 1) ∧ v (0, 1) = v (0, 2)) ∧
    (v (1, 0) = v (1, 1) ∧ v (1, 1) = v (1, 2))}
  add_mem' := by
    rintro a b ⟨ha2, ha3, ⟨ha01, ha02⟩, ⟨ha11, ha12⟩⟩ ⟨hb2, hb3, ⟨hb01, hb02⟩, ⟨hb11, hb12⟩⟩
    refine ⟨fun c => by simp [ha2 c, hb2 c], fun c => by simp [ha3 c, hb3 c], ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩ <;>
      simp [Pi.add_apply] <;> linarith
  zero_mem' := by refine ⟨fun c => rfl, fun c => rfl, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩
  smul_mem' := by
    rintro r a ⟨ha2, ha3, ⟨ha01, ha02⟩, ⟨ha11, ha12⟩⟩
    refine ⟨fun c => by simp [ha2 c], fun c => by simp [ha3 c], ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩ <;>
      simp [Pi.smul_apply, ha01, ha02, ha11, ha12]

/-- The **colored (non-singlet) sector**: states supported on the physical spins
`{0,1}` whose color part in each physical spin is traceless (total color charge
zero). -/
def coloredSector : Submodule ℝ (Fin 4 × Fin 3 → ℝ) where
  carrier := {v | (∀ c, v (2, c) = 0) ∧ (∀ c, v (3, c) = 0) ∧
    (v (0, 0) + v (0, 1) + v (0, 2) = 0) ∧
    (v (1, 0) + v (1, 1) + v (1, 2) = 0)}
  add_mem' := by
    rintro a b ⟨ha2, ha3, ha0, ha1⟩ ⟨hb2, hb3, hb0, hb1⟩
    refine ⟨fun c => by simp [ha2 c, hb2 c], fun c => by simp [ha3 c, hb3 c], ?_, ?_⟩ <;>
      simp [Pi.add_apply] <;> linarith
  zero_mem' := by refine ⟨fun c => rfl, fun c => rfl, by simp, by simp⟩
  smul_mem' := by
    rintro r a ⟨ha2, ha3, ha0, ha1⟩
    refine ⟨fun c => by simp [ha2 c], fun c => by simp [ha3 c], ?_, ?_⟩ <;>
      simp only [Pi.smul_apply, smul_eq_mul]
    · linear_combination r * ha0
    · linear_combination r * ha1

/-
**Singlet sector is positive-definite.** Every nonzero color-singlet state
has strictly positive closure value.
-/
theorem singlet_posDef (v : Fin 4 × Fin 3 → ℝ) (hv : v ∈ singletSector) (hne : v ≠ 0) :
    0 < qval M12 v := by
  -- From `hv : v ∈ singletSector` extract h2, h3 (support on spins 2,3 zero) and the singlet equalities for spin 0 (v(0,0)=v(0,1), v(0,1)=v(0,2)) and spin 1.
  obtain ⟨h2, h3, ⟨h01, h02⟩, ⟨h11, h12⟩⟩ := hv;
  rw [ qval_M12_phys v h2 h3, qval_Gcolor_singlet, qval_Gcolor_singlet ] <;> try linarith!;
  contrapose! hne; ext ⟨ i, j ⟩ ; fin_cases i <;> fin_cases j <;> simp_all +decide ;
  all_goals nlinarith;

/-
**Colored sector is negative-definite.** Every nonzero colored state has
strictly negative closure value.
-/
theorem colored_negDef (v : Fin 4 × Fin 3 → ℝ) (hv : v ∈ coloredSector) (hne : v ≠ 0) :
    qval M12 v < 0 := by
  -- By definition of coloredSector, we know that v is supported on the physical spins {0,1} and the color parts are traceless.
  obtain ⟨h2, h3, h0, h1⟩ := hv
  have h_support : ∀ i j, i = 0 ∨ i = 1 → j ∈ Finset.univ → v (i, j) = v (i, j) := by
    exact fun _ _ _ _ => rfl;
  rw [ qval_M12_phys v h2 h3, qval_Gcolor_colored, qval_Gcolor_colored ] <;> try linarith!;
  contrapose! hne;
  ext ⟨ i, j ⟩ ; fin_cases i <;> fin_cases j <;> simp +decide [ * ] <;> nlinarith!;

/-! ### Mandatory non-degeneracy fixtures -/

/-- Explicit nonzero singlet witness: color `(1,1,1)` placed in physical spin `0`. -/
noncomputable def singletWitness : Fin 4 × Fin 3 → ℝ :=
  fun p => if p.1 = 0 then 1 else 0

/-- Explicit nonzero colored witness: color `(1,-1,0)` placed in physical spin `0`. -/
noncomputable def coloredWitness : Fin 4 × Fin 3 → ℝ :=
  fun p => if p.1 = 0 then (if p.2 = 0 then 1 else if p.2 = 1 then -1 else 0) else 0

theorem singletWitness_mem : singletWitness ∈ singletSector := by
  refine ⟨?_, ?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩ <;> simp [singletWitness]

theorem singletWitness_ne : singletWitness ≠ 0 := by
  intro h; have := congrFun h (0, 0); simp [singletWitness] at this

theorem coloredWitness_mem : coloredWitness ∈ coloredSector := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [coloredWitness]

theorem coloredWitness_ne : coloredWitness ≠ 0 := by
  intro h; have := congrFun h (0, 0); simp [coloredWitness] at this

/-- The singlet witness has strictly positive closure value. -/
theorem singletWitness_pos : 0 < qval M12 singletWitness :=
  singlet_posDef _ singletWitness_mem singletWitness_ne

/-- The colored witness has strictly negative closure value. -/
theorem coloredWitness_neg : qval M12 coloredWitness < 0 :=
  colored_negDef _ coloredWitness_mem coloredWitness_ne

/-
**Both sectors have strictly positive dimension** (the dichotomy is not
vacuous).
-/
theorem singletSector_finrank_pos : 0 < Module.finrank ℝ singletSector := by
  refine' Nat.pos_of_ne_zero _;
  simp;
  exact fun h => singletWitness_ne <| by simpa [ h ] using singletWitness_mem;

theorem coloredSector_finrank_pos : 0 < Module.finrank ℝ coloredSector := by
  refine' Nat.pos_of_ne_zero _;
  simp +zetaDelta at *;
  exact fun h => coloredWitness_ne <| by simpa [ h ] using coloredWitness_mem;

/-- **Rung 1 — the confinement dichotomy on the 12-dim carrier**, packaged with
its non-degeneracy fixtures: both sectors have positive dimension; on the
singlet sector the closure form is positive-definite (witnessed by
`singletWitness`); on the colored sector it is negative-definite (witnessed by
`coloredWitness`). -/
theorem confinement_dichotomy_12 :
    0 < Module.finrank ℝ singletSector ∧
    0 < Module.finrank ℝ coloredSector ∧
    (∀ v ∈ singletSector, v ≠ 0 → 0 < qval M12 v) ∧
    (∀ v ∈ coloredSector, v ≠ 0 → qval M12 v < 0) ∧
    (singletWitness ∈ singletSector ∧ singletWitness ≠ 0 ∧ 0 < qval M12 singletWitness) ∧
    (coloredWitness ∈ coloredSector ∧ coloredWitness ≠ 0 ∧ qval M12 coloredWitness < 0) :=
  ⟨singletSector_finrank_pos, coloredSector_finrank_pos,
    fun v hv hne => singlet_posDef v hv hne, fun v hv hne => colored_negDef v hv hne,
    ⟨singletWitness_mem, singletWitness_ne, singletWitness_pos⟩,
    ⟨coloredWitness_mem, coloredWitness_ne, coloredWitness_neg⟩⟩

/-! ## Rung 2 — the interacting two-particle (color-singlet channel) Hamiltonian

The two-particle color-singlet Fock sector is spanned by the three pair-occupation
states over the three one-particle modes `Fin 3` (index `0 ↔ {0,1}`, `1 ↔ {0,2}`,
`2 ↔ {1,2}`).  The free two-body Hamiltonian is diagonal in the pair energies; the
attractive closure interaction `V` couples the two pairs sharing the lowest mode
(the physical color-singlet binding channel).  `H2 = freeH2 + interaction` is the
singlet-channel two-body Hamiltonian; it is Hermitian. -/

/-- Free two-body energies of the three pairs. -/
def pairEnergy (d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![d 0 + d 1, d 0 + d 2, d 1 + d 2]

/-- The free two-body Hamiltonian: diagonal in the pair basis. -/
def freeH2 (d : Fin 3 → ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  Matrix.diagonal (pairEnergy d)

/-- The attractive closure interaction `V` of strength `κ` between the two pairs
sharing the lowest mode `0`. -/
def interaction (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![0, -kappa, 0; -kappa, 0, 0; 0, 0, 0]

/-- The interacting two-body (color-singlet channel) Hamiltonian `H2 = freeH2 + V`. -/
def H2 (d : Fin 3 → ℝ) (kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  freeH2 d + interaction kappa

/-- The free two-body threshold `min_{i≠j}(d i + d j)`. -/
def pairThreshold (d : Fin 3 → ℝ) : ℝ :=
  min (d 0 + d 1) (min (d 0 + d 2) (d 1 + d 2))

/-- The (real) spectrum of `H2`. -/
def spectrum2 (d : Fin 3 → ℝ) (kappa : ℝ) : Set ℝ :=
  {μ | ∃ v : Fin 3 → ℝ, v ≠ 0 ∧ (H2 d kappa).mulVec v = μ • v}

/-- The discriminant `(a-c)²/4 + κ²` of the attractive `2×2` block. -/
noncomputable def discr (d : Fin 3 → ℝ) (kappa : ℝ) : ℝ :=
  ((d 0 + d 1) - (d 0 + d 2)) ^ 2 / 4 + kappa ^ 2

/-- The least eigenvalue of `H2`: `(a+c)/2 - sqrt((a-c)²/4 + κ²)`. -/
noncomputable def boundEnergy (d : Fin 3 → ℝ) (kappa : ℝ) : ℝ :=
  ((d 0 + d 1) + (d 0 + d 2)) / 2 - Real.sqrt (discr d kappa)

/-- The interaction is Hermitian (real-symmetric). -/
theorem interaction_isHermitian (kappa : ℝ) : (interaction kappa).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [interaction]

/-- **Rung 2 headline: the singlet-channel two-body Hamiltonian is Hermitian.** -/
theorem H2_isHermitian (d : Fin 3 → ℝ) (kappa : ℝ) : (H2 d kappa).IsHermitian := by
  convert Matrix.IsHermitian.add (Matrix.isHermitian_diagonal _) (interaction_isHermitian kappa) using 1

theorem discr_nonneg (d : Fin 3 → ℝ) (kappa : ℝ) : 0 ≤ discr d kappa :=
  add_nonneg (div_nonneg (sq_nonneg _) zero_le_four) (sq_nonneg _)

/-- The defining quadratic relation of the least eigenvalue: `(a-μ)(c-μ) = κ²`. -/
theorem boundEnergy_key (d : Fin 3 → ℝ) (kappa : ℝ) :
    ((d 0 + d 1) - boundEnergy d kappa) * ((d 0 + d 2) - boundEnergy d kappa)
      = kappa ^ 2 := by
  unfold boundEnergy discr
  nlinarith [Real.mul_self_sqrt (show 0 ≤ (d 0 + d 1 - (d 0 + d 2)) ^ 2 / 4 + kappa ^ 2 by positivity)]

/-- `boundEnergy` is an eigenvalue of `H2` (a genuine bound state). -/
theorem boundEnergy_mem_spectrum (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa) :
    boundEnergy d kappa ∈ spectrum2 d kappa := by
  use ![-kappa, boundEnergy d kappa - (d 0 + d 1), 0]
  refine ⟨ne_of_apply_ne (fun v => v 0) (by norm_num; linarith), ?_⟩
  ext i; fin_cases i <;> norm_num [H2, freeH2, interaction, Matrix.mulVec]
  · simp +decide [Matrix.vecHead, Matrix.vecTail, pairEnergy]; ring
  · simp +decide [Matrix.vecHead, Matrix.vecTail, pairEnergy]
    have := boundEnergy_key d kappa; norm_num [discr] at this; nlinarith
  · simp +decide [Matrix.vecHead, Matrix.vecTail, pairEnergy]

/-- **Spectral quadratic:** any eigenvalue satisfies `(a-μ)(c-μ)=κ²` or `μ=d1+d2`. -/
theorem spectrum2_quad (d : Fin 3 → ℝ) (kappa μ : ℝ) (hμ : μ ∈ spectrum2 d kappa) :
    ((d 0 + d 1) - μ) * ((d 0 + d 2) - μ) = kappa ^ 2 ∨ μ = d 1 + d 2 := by
  obtain ⟨v, hv_ne_zero, hv_eq⟩ := hμ
  have h_det : Matrix.det (Matrix.diagonal (pairEnergy d) + interaction kappa
      - Matrix.diagonal (fun _ => μ)) = 0 := by
    rw [← Matrix.exists_mulVec_eq_zero_iff]
    simp_all +decide [H2, Matrix.sub_mulVec]
    exact ⟨v, hv_ne_zero, sub_eq_zero.mpr hv_eq⟩
  simp_all +decide [Matrix.det_fin_three, pairEnergy, interaction]
  exact Classical.or_iff_not_imp_right.2 fun h =>
    mul_left_cancel₀ (sub_ne_zero_of_ne h) <| by linarith

/-- Any eigenvalue of `H2` is at least `boundEnergy`. -/
theorem boundEnergy_lower_bound (d : Fin 3 → ℝ) (kappa : ℝ)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2)
    (μ : ℝ) (hμ : μ ∈ spectrum2 d kappa) : boundEnergy d kappa ≤ μ := by
  have h_quad := spectrum2_quad d kappa μ hμ
  cases' h_quad with h_quad h_quad <;> simp_all +decide [boundEnergy, discr]
  · nlinarith [Real.sqrt_nonneg ((d 1 - d 2) ^ 2 / 4 + kappa ^ 2),
      Real.mul_self_sqrt (by positivity : 0 ≤ (d 1 - d 2) ^ 2 / 4 + kappa ^ 2)]
  · nlinarith [Real.sqrt_nonneg ((d 1 - d 2) ^ 2 / 4 + kappa ^ 2)]

/-- `boundEnergy` is the least eigenvalue of `H2`. -/
theorem boundEnergy_isLeast (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrum2 d kappa) (boundEnergy d kappa) :=
  ⟨boundEnergy_mem_spectrum d kappa hk,
    fun _ hμ => boundEnergy_lower_bound d kappa h01 h12 _ hμ⟩

theorem pairThreshold_eq (d : Fin 3 → ℝ) (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    pairThreshold d = d 0 + d 1 :=
  min_eq_left (by cases min_cases (d 0 + d 2) (d 1 + d 2) <;> linarith)

/-- The least eigenvalue dips strictly below the free threshold when `κ > 0`. -/
theorem boundEnergy_lt_pairThreshold (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    boundEnergy d kappa < pairThreshold d := by
  unfold boundEnergy pairThreshold
  rw [min_def, min_def]
  split_ifs <;>
    nlinarith [Real.sqrt_nonneg (discr d kappa),
      Real.mul_self_sqrt (show 0 ≤ discr d kappa by
        exact add_nonneg (div_nonneg (sq_nonneg _) zero_le_four) (sq_nonneg _)),
      show 0 < kappa ^ 2 by positivity,
      show discr d kappa > (d 1 - d 2) ^ 2 / 4 by unfold discr; nlinarith]

/-- **Rung 3 (general): interacting two-body bound state strictly below threshold.** -/
theorem interacting_boundState_below_threshold
    (d : Fin 3 → ℝ) (kappa : ℝ) (hk : 0 < kappa)
    (h01 : d 0 ≤ d 1) (h12 : d 1 ≤ d 2) :
    IsLeast (spectrum2 d kappa) (boundEnergy d kappa) ∧
      boundEnergy d kappa < pairThreshold d :=
  ⟨boundEnergy_isLeast d kappa hk h01 h12,
    boundEnergy_lt_pairThreshold d kappa hk h01 h12⟩

/-! ## Rung 3 — explicit rational below-threshold bound state

We fix the rational witness `d = (0,1,7)`, `κ = 4` (a `3-4-5` holonomy:
`(a-c)²/4 + κ² = 9 + 16 = 25`, so `√ = 5`).  Then the bound (ground) energy is
exactly `-1`, strictly below the two-constituent threshold `1`. -/

/-- The rational one-particle spectrum witness `(0,1,7)`. -/
def dW : Fin 3 → ℝ := ![0, 1, 7]

/-- The rational closure strength witness `κ = 4 ≠ 0`. -/
def kW : ℝ := 4

theorem dW_sorted : dW 0 ≤ dW 1 ∧ dW 1 ≤ dW 2 := by
  constructor <;> simp [dW]

theorem kW_pos : 0 < kW := by norm_num [kW]

/-- The 3-4-5 discriminant is `25`. -/
theorem discr_W : discr dW kW = 25 := by
  simp [discr, dW, kW]; norm_num

/-- The bound (ground) energy is exactly the rational number `-1`. -/
theorem boundEnergy_W : boundEnergy dW kW = -1 := by
  have h : Real.sqrt (discr dW kW) = 5 := by
    rw [discr_W]; rw [show (25 : ℝ) = 5 ^ 2 by norm_num]; exact Real.sqrt_sq (by norm_num)
  unfold boundEnergy
  rw [h]
  norm_num [dW, show (![0,1,7] : Fin 3 → ℝ) 0 = 0 from rfl,
    show (![0,1,7] : Fin 3 → ℝ) 1 = 1 from rfl, show (![0,1,7] : Fin 3 → ℝ) 2 = 7 from rfl]

/-- The free two-constituent threshold is exactly `1`. -/
theorem pairThreshold_W : pairThreshold dW = 1 := by
  rw [pairThreshold_eq dW dW_sorted.1 dW_sorted.2]; simp [dW]

/-- **Rung 3 headline: rational below-threshold bound ground state.** For the
explicit rational witness `d = (0,1,7)`, `κ = 4`, the singlet-channel two-body
ground energy is exactly `-1`, is the least eigenvalue of `H2`, and lies strictly
below the two-constituent threshold `1`. -/
theorem rung3_bound_below_threshold :
    boundEnergy dW kW = -1 ∧ pairThreshold dW = 1 ∧
    IsLeast (spectrum2 dW kW) (boundEnergy dW kW) ∧
    boundEnergy dW kW < pairThreshold dW := by
  refine ⟨boundEnergy_W, pairThreshold_W, ?_, ?_⟩
  · exact boundEnergy_isLeast dW kW kW_pos dW_sorted.1 dW_sorted.2
  · rw [boundEnergy_W, pairThreshold_W]; norm_num

/-! ## Rung 4 — a positive many-body gap above the bound state

For the witness, `H2 dW kW = !![1,-4,0; -4,7,0; 0,0,8]` has exact spectrum
`{-1, 8, 9}`.  The ground state is `-1`; the first excited eigenvalue is `8`, so
there is a strictly positive gap of `9`. -/

/-- `8` is an eigenvalue (eigenvector `![0,0,1]`, the decoupled pair `{1,2}`). -/
theorem eight_mem_spectrum : (8 : ℝ) ∈ spectrum2 dW kW := by
  refine ⟨![0, 0, 1], ?_, ?_⟩
  · intro h; have := congrFun h 2; simp at this
  · ext i; fin_cases i <;>
      simp +decide [H2, freeH2, interaction, dW, kW, Matrix.mulVec,
        pairEnergy, dotProduct, Fin.sum_univ_three] <;> norm_num

/-- `9` is an eigenvalue (eigenvector `![1,-2,0]` in the attractive block). -/
theorem nine_mem_spectrum : (9 : ℝ) ∈ spectrum2 dW kW := by
  refine ⟨![1, -2, 0], ?_, ?_⟩
  · intro h; have := congrFun h 0; simp at this
  · ext i; fin_cases i <;>
      simp +decide [H2, freeH2, interaction, dW, kW, Matrix.mulVec,
        pairEnergy, dotProduct, Fin.sum_univ_three] <;> norm_num

/-- **Rung 4 headline: exact eigenvalue ordering / positive many-body gap.**
The ground energy `-1` is the least eigenvalue; `8` and `9` are eigenvalues; and
every eigenvalue is either `-1` (the ground state) or `≥ 8`.  Hence the gap above
the bound state is `8 - (-1) = 9 > 0`. -/
theorem rung4_positive_gap :
    IsLeast (spectrum2 dW kW) (-1) ∧
    (8 : ℝ) ∈ spectrum2 dW kW ∧ (9 : ℝ) ∈ spectrum2 dW kW ∧
    (∀ μ ∈ spectrum2 dW kW, μ = -1 ∨ 8 ≤ μ) := by
  have hleast : IsLeast (spectrum2 dW kW) (boundEnergy dW kW) :=
    boundEnergy_isLeast dW kW kW_pos dW_sorted.1 dW_sorted.2
  rw [boundEnergy_W] at hleast
  refine ⟨hleast, eight_mem_spectrum, nine_mem_spectrum, ?_⟩
  intro μ hμ
  have hq := spectrum2_quad dW kW μ hμ
  rcases hq with hq | hq
  · -- (1-μ)(7-μ) = 16  ⇒  μ = -1 or μ = 9
    rw [show dW 0 = 0 from rfl, show dW 1 = 1 from rfl, show dW 2 = 7 from rfl,
      show kW = 4 from rfl] at hq
    have : (μ + 1) * (μ - 9) = 0 := by nlinarith [hq]
    rcases mul_eq_zero.1 this with h | h
    · left; linarith
    · right; linarith
  · right; rw [show dW 1 = 1 from rfl, show dW 2 = 7 from rfl] at hq; linarith

/-! ## Rung 5 — the signed channel mass budget with negative closure share

The Ji-shaped statement: the finite mass budget splits **exactly** into
aperture / closure / turn shares summing to `1`, with the **closure share
`b_C < 0`** — binding realized as a negative closure share.

The abstract `signed_budget_sum_one` holds for any linear expectation `ev` with
`ev(D²) ≠ 0`.  The seed's Euclidean (ordinary-trace) witness gives `b_C = 0`; to
realize the SIGNED generality (`b_C < 0`) we use the indefinite **Krein-weighted
trace** `krTrace X = X₀₀ - X₁₁` (trace against `diag(1,-1)`).  The shares are
exactly rational (`b_A = 3/2`, `b_C = -1/2`, `b_T = 0`), reusing rational data. -/

/-- The abstract **signed mass-budget decomposition of unity** over `ℝ`: from a
Weitzenböck-type identity `4•(D²) = QA + QC + 4•QT` and a linear expectation `ev`
with `ev(D²) ≠ 0`, the aperture/closure/turn shares of `M² = 4·ev(D²)` sum to one.
Shares are signed — no positivity is assumed. -/
theorem signed_budget_sum_one {B : Type*} [Ring B] [Algebra ℝ B]
    (ev : B →ₗ[ℝ] ℝ) (D QA QC QT : B)
    (hid : (4 : ℝ) • (D * D) = QA + QC + (4 : ℝ) • QT)
    (hM : ev (D * D) ≠ 0) :
    ev QA / (4 * ev (D * D)) + ev QC / (4 * ev (D * D))
        + (4 * ev QT) / (4 * ev (D * D)) = 1 := by
  have hev : (4 : ℝ) * ev (D * D) = ev QA + ev QC + 4 * ev QT := by
    have h := congrArg ev hid
    rw [map_smul, map_add, map_add, map_smul, smul_eq_mul, smul_eq_mul] at h
    exact h
  have hs : (4 : ℝ) * ev (D * D) ≠ 0 := mul_ne_zero (by norm_num) hM
  rw [← add_div, ← add_div, ← hev, div_self hs]

/-- The indefinite **Krein-weighted trace** `X ↦ X₀₀ - X₁₁` (trace against the
Krein metric `diag(1,-1)`), as an ℝ-linear functional. -/
def krTrace : Matrix (Fin 2) (Fin 2) ℝ →ₗ[ℝ] ℝ where
  toFun X := X 0 0 - X 1 1
  map_add' X Y := by simp [Matrix.add_apply]; ring
  map_smul' c X := by simp [Matrix.smul_apply]; ring

/-- The Dirac-type carrier `D` of the budget witness. -/
def Db : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, 0]

/-- The aperture block `QA`. -/
def QAb : Matrix (Fin 2) (Fin 2) ℝ := !![5, 0; 0, -1]

/-- The closure block `QC` (has negative Krein-trace: the chromomagnetic share). -/
def QCb : Matrix (Fin 2) (Fin 2) ℝ := !![-1, 0; 0, 1]

/-- The turn block `QT`. -/
def QTb : Matrix (Fin 2) (Fin 2) ℝ := 0

/-- The Weitzenböck-type identity of the witness: `4•(D²) = QA + QC + 4•QT`. -/
theorem witness_id : (4 : ℝ) • (Db * Db) = QAb + QCb + (4 : ℝ) • QTb := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Db, QAb, QCb, QTb, Matrix.mul_apply, Fin.sum_univ_two] <;> norm_num

/-- The Krein-trace of `D²` is `1 ≠ 0` (the expectation is nondegenerate). -/
theorem krTrace_DD : krTrace (Db * Db) = 1 := by
  simp [krTrace, Db, Matrix.mul_apply, Fin.sum_univ_two]

/-- **Rung 5 headline: the signed channel mass budget with `b_C < 0`.**
With the indefinite Krein expectation, the aperture/closure/turn shares of the
witness carrier sum to `1`, and the closure share is exactly `-1/2 < 0` — the
binding is realized as a negative closure share (the Ji-shaped statement). -/
theorem rung5_signed_budget :
    (krTrace QAb / (4 * krTrace (Db * Db)) + krTrace QCb / (4 * krTrace (Db * Db))
      + (4 * krTrace QTb) / (4 * krTrace (Db * Db)) = 1)
    ∧ krTrace QCb / (4 * krTrace (Db * Db)) = -1/2
    ∧ krTrace QCb / (4 * krTrace (Db * Db)) < 0 := by
  have hM : krTrace (Db * Db) ≠ 0 := by rw [krTrace_DD]; norm_num
  refine ⟨signed_budget_sum_one krTrace Db QAb QCb QTb witness_id hM, ?_, ?_⟩
  · rw [krTrace_DD]; simp [krTrace, QCb]; norm_num
  · rw [krTrace_DD]; simp [krTrace, QCb]; norm_num

/-- info: 'Goal1Hadron.confinement_dichotomy_12' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms confinement_dichotomy_12

/-- info: 'Goal1Hadron.H2_isHermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H2_isHermitian

/-- info: 'Goal1Hadron.rung3_bound_below_threshold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rung3_bound_below_threshold

/-- info: 'Goal1Hadron.rung4_positive_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rung4_positive_gap

/-- info: 'Goal1Hadron.rung5_signed_budget' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rung5_signed_budget

end Goal1Hadron
