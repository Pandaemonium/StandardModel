import Mathlib

/-!
# Positive mass sectors of finite Krein carriers

This file classifies, for small explicit **Krein** (indefinite–metric) carriers, when the
*physical sector form* is positive–definite — equivalently, when the carrier has a genuine
**positive mass sector** with a positive mass gap.

## The model

A finite Krein carrier is *not* born with a positive Hilbert metric.  After the constraint /
quotient / sector–selection data has been imposed, what remains is a **sector form**: a
Hermitian matrix `M : Matrix n n ℂ`.  We say the carrier *has a positive mass sector*
(`HasPositiveMassSector`) exactly when `M` is positive definite (`M.PosDef`); the physical
masses are then the eigenvalues of `M`, all of which are positive, so the *ground* eigenvalue
is a positive **mass gap**.

The sector form is built from two ingredients:

* an **aperture** term `A` (an intrinsically positive part), and
* a **closure** term whose sign structure depends on the *grading*.

The whole story turns on **how the closure enters the sector form**, which is governed by
whether the closure bivector `b` coincides with the chirality `Γ`:

* **Grading separation** (`b ≠ Γ`).  The closure enters *squared*, as a Gram term `Bᴴ B`,
  which is positive semidefinite regardless of the closure strength.  Then
  `M = A + Bᴴ B` is positive definite whenever the aperture `A` is
  (`posDef_aperture_add_gram`); the canonical witness is `M = 1 + Bᴴ B`
  (`posDef_one_add_gram`) with mass gap `≥ 1` (`massGap_one_add_gram`).  This is the
  mechanism behind the `Cl(4)` witness `T2_positive_mass`: *enough Clifford room lets the
  closure be signed while the aperture stabilizes.*

* **Grading coincidence** (`b = Γ`, the "too balanced" single–doublet regime).  The closure
  enters *linearly*, as `c • Γ` with `Γ` an indefinite (traceless) chirality, and now
  competes with the aperture.  The doublet sector `a • 1 + c • Γ = diag(a+c, a−c)`
  (`balancedSector`) then exhibits a full **trichotomy** in `a` vs `|c|`:
  massive (`|c| < a`), critical/zero–mode (`|c| = a`), indefinite (`|c| > a`).

## Main results

* `posDef_aperture_add_gram`, `posDef_one_add_gram` — the sufficient positivity criterion
  (aperture dominance via a Gram closure term).
* `massGap_one_add_gram`, `massGap_pos`, `eigenvalues_pos_of_positiveMassSector` — the
  positive mass gap.
* `separatedSector_posDef` — grading separation always yields a positive sector
  (single massive phase, for any closure strength).
* `balanced_massive`, `balanced_critical`, `balanced_indefinite` — the no-go / trichotomy in
  the grading-coincident (chirality) regime.
* `balanced_phase_classification` — the finite phase diagram: for `0 < a`, exactly one of
  the massive / critical / indefinite phases occurs, cut at the threshold `|c| = a`.

All proofs are kernel–checked; see the `#print axioms` block at the end, whose footprint is
`[propext, Classical.choice, Quot.sound]`.
-/

open Matrix
open scoped ComplexOrder

namespace KreinCarrier

/-! ## The sector form and its positive mass sector -/

/-- A carrier's sector form `M` has a **positive mass sector** when it is positive definite:
every physical vector has positive norm, so the ground eigenvalue is a positive mass. -/
def HasPositiveMassSector {n : Type*} [Fintype n] (M : Matrix n n ℂ) : Prop := M.PosDef

/-- A Hermitian form is **indefinite** when neither it nor its negative is positive
semidefinite, i.e. it takes both strictly positive and strictly negative values.  Such a
carrier has no positive mass sector (and no negative one either). -/
def IsIndefinite {n : Type*} [Fintype n] (M : Matrix n n ℂ) : Prop :=
  ¬ M.PosSemidef ∧ ¬ (-M).PosSemidef

/-! ## Sufficient positivity criterion: aperture dominance via a Gram closure term

The closure, when it is *graded away from chirality*, contributes to the sector form as a
square `Bᴴ B` (a Gram matrix).  A Gram matrix is always positive semidefinite, so it can
never destabilize a positive aperture. -/

/-- **Aperture dominance criterion.**  If the aperture form `A` is positive definite, then
adding any Gram closure term `Bᴴ B` keeps the sector form positive definite.  This is the
general mechanism behind the `M6 = 1 + Bᴴ B` witness: a signed closure that enters *squared*
cannot spoil positivity. -/
theorem posDef_aperture_add_gram {n m : Type*} [Fintype n] [Fintype m]
    {A : Matrix n n ℂ} (hA : A.PosDef) (B : Matrix m n ℂ) :
    (A + Bᴴ * B).PosDef :=
  hA.add_posSemidef (posSemidef_conjTranspose_mul_self B)

/-- The canonical positive mass sector `M6 = 1 + Bᴴ B` (unit aperture, Gram closure) is
positive definite for **every** closure block `B`.  This is the abstract form of the
`Cl(4)` witness `T2_positive_mass`. -/
theorem posDef_one_add_gram {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n]
    (B : Matrix m n ℂ) : (1 + Bᴴ * B).PosDef :=
  posDef_aperture_add_gram Matrix.PosDef.one B

/-- A positive real aperture `a • 1` is positive definite. -/
theorem posDef_smul_one {n : Type*} [DecidableEq n] {a : ℝ} (ha : 0 < a) :
    ((a : ℂ) • (1 : Matrix n n ℂ)).PosDef := by
  have h : (a : ℂ) • (1 : Matrix n n ℂ) = diagonal (fun _ => (a : ℂ)) := by
    ext i j; by_cases hij : i = j <;> simp [diagonal, hij]
  rw [h, Matrix.posDef_diagonal_iff]
  intro i; rw [Complex.zero_lt_real]; exact ha

/-- **Grading separation ⇒ single massive phase.**  When the closure is separated from
chirality it enters as a Gram term, so for any positive aperture strength `a` and any
closure block `B`, the sector `a • 1 + Bᴴ B` is positive definite — *regardless of the
closure strength*.  Contrast with `balanced_indefinite`: no indefinite phase can appear. -/
theorem separatedSector_posDef {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n]
    {a : ℝ} (ha : 0 < a) (B : Matrix m n ℂ) :
    ((a : ℂ) • (1 : Matrix n n ℂ) + Bᴴ * B).PosDef :=
  posDef_aperture_add_gram (posDef_smul_one ha) B

/-- **The mass gap is `≥ 1`.**  For the `M6 = 1 + Bᴴ B` sector form, the Rayleigh quotient
dominates the norm: `xᴴ(1 + Bᴴ B)x ≥ xᴴx = ‖x‖²`.  Hence the ground eigenvalue (the mass)
is at least `1`. -/
theorem massGap_one_add_gram {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n]
    (B : Matrix m n ℂ) (x : n → ℂ) :
    RCLike.re (star x ⬝ᵥ (1 : Matrix n n ℂ) *ᵥ x)
      ≤ RCLike.re (star x ⬝ᵥ (1 + Bᴴ * B) *ᵥ x) := by
  have hps := (posSemidef_conjTranspose_mul_self B).re_dotProduct_nonneg x
  have h : (1 + Bᴴ * B) *ᵥ x = (1 : Matrix n n ℂ) *ᵥ x + (Bᴴ * B) *ᵥ x := by rw [add_mulVec]
  rw [h, dotProduct_add, map_add]
  linarith

/-- The closure term *alone* is only positive **semi**definite, not definite: without the
aperture there is no mass gap (there can be null directions).  This is why the aperture is
indispensable even in the graded-separated regime. -/
theorem gram_posSemidef {n m : Type*} [Fintype m] [Finite n] (B : Matrix m n ℂ) :
    (Bᴴ * B).PosSemidef :=
  posSemidef_conjTranspose_mul_self B

/-! ## Positive mass spectrum -/

section Spectrum
variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A positive mass sector has an all-positive mass spectrum: every eigenvalue is `> 0`. -/
theorem eigenvalues_pos_of_positiveMassSector {M : Matrix n n ℂ}
    (hM : HasPositiveMassSector M) (i : n) :
    0 < hM.1.eigenvalues i :=
  hM.eigenvalues_pos i

/-- The **mass gap**: the least eigenvalue of the sector form. -/
noncomputable def massGap {M : Matrix n n ℂ} (hM : M.IsHermitian) [Nonempty n] : ℝ :=
  Finset.univ.inf' Finset.univ_nonempty hM.eigenvalues

/-- A positive mass sector has a **strictly positive mass gap**. -/
theorem massGap_pos [Nonempty n] {M : Matrix n n ℂ} (hM : HasPositiveMassSector M) :
    0 < massGap hM.1 := by
  rw [massGap, Finset.lt_inf'_iff]
  intro i _
  exact hM.eigenvalues_pos i

end Spectrum

/-! ## The chirality and the balanced (grading-coincident) doublet -/

/-- The **chirality** `Γ = diag(1, −1)`: a Hermitian involution with vanishing trace.  When
the closure bivector coincides with `Γ`, the closure enters the sector form linearly (not
squared) and can destabilize the aperture. -/
def chir : Matrix (Fin 2) (Fin 2) ℂ := diagonal ![1, -1]

/-- `Γ² = 1`: the chirality is an involution. -/
theorem chir_involution : chir * chir = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [chir, mul_apply, Fin.sum_univ_two]

/-- `tr Γ = 0`: the chirality is traceless (it balances the two gradings). -/
theorem chir_trace : Matrix.trace chir = 0 := by
  simp [chir, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

/-- The chirality is Hermitian. -/
theorem chir_isHermitian : chir.IsHermitian := by
  unfold Matrix.IsHermitian
  ext i j; fin_cases i <;> fin_cases j <;> simp [chir, conjTranspose_apply, diagonal]

/-- The **balanced (single-doublet) sector form** `a • 1 + c • Γ = diag(a+c, a−c)`, where the
closure grading *coincides* with the chirality.  Here the closure strength `c` competes
directly with the aperture strength `a`. -/
def balancedSector (a c : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  diagonal ![((a + c : ℝ) : ℂ), ((a - c : ℝ) : ℂ)]

/-- The balanced sector form is exactly `a • 1 + c • Γ` (aperture plus a chirality-graded,
hence indefinite, closure). -/
theorem balancedSector_eq (a c : ℝ) :
    balancedSector a c = (a : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) + (c : ℂ) • chir := by
  ext i j
  fin_cases i <;> fin_cases j <;> (simp [balancedSector, chir, diagonal]; try ring)

/-- `-balancedSector` is diagonal with negated entries (for the indefiniteness argument). -/
theorem neg_balancedSector (a c : ℝ) :
    -balancedSector a c = diagonal ![((-(a + c) : ℝ) : ℂ), ((-(a - c) : ℝ) : ℂ)] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [balancedSector, diagonal]

/-! ## The no-go / trichotomy in the grading-coincident regime -/

/-- **Massive phase.**  When the aperture dominates the closure (`|c| < a`), the balanced
sector is positive definite: a genuine positive mass sector. -/
theorem balanced_massive {a c : ℝ} (h : |c| < a) : (balancedSector a c).PosDef := by
  rw [balancedSector, Matrix.posDef_diagonal_iff, Fin.forall_fin_two]
  have hlt := abs_lt.mp h
  refine ⟨?_, ?_⟩
  · rw [Matrix.cons_val_zero, Complex.zero_lt_real]; linarith [hlt.1]
  · rw [Matrix.cons_val_one, Matrix.cons_val_zero, Complex.zero_lt_real]; linarith [hlt.2]

/-- **Critical / balanced boundary.**  At the threshold `|c| = a` (with `0 < a`) the sector
form is positive *semi*definite but **not** positive definite: a massless zero mode appears.
This is the exact grading threshold separating the massive and indefinite regimes. -/
theorem balanced_critical {a c : ℝ} (ha : 0 < a) (h : |c| = a) :
    (balancedSector a c).PosSemidef ∧ ¬ (balancedSector a c).PosDef := by
  constructor
  · rw [balancedSector, Matrix.posSemidef_diagonal_iff, Fin.forall_fin_two]
    rcases abs_cases c with ⟨hc, _⟩ | ⟨hc, _⟩ <;> rw [hc] at h
    · exact ⟨by rw [Matrix.cons_val_zero, Complex.zero_le_real]; linarith,
            by rw [Matrix.cons_val_one, Matrix.cons_val_zero, Complex.zero_le_real]; linarith⟩
    · exact ⟨by rw [Matrix.cons_val_zero, Complex.zero_le_real]; linarith,
            by rw [Matrix.cons_val_one, Matrix.cons_val_zero, Complex.zero_le_real]; linarith⟩
  · rw [balancedSector, Matrix.posDef_diagonal_iff, Fin.forall_fin_two]
    rintro ⟨h0, h1⟩
    rcases abs_cases c with ⟨hc, _⟩ | ⟨hc, _⟩ <;> rw [hc] at h
    · rw [Matrix.cons_val_one, Matrix.cons_val_zero, Complex.zero_lt_real] at h1; linarith
    · rw [Matrix.cons_val_zero, Complex.zero_lt_real] at h0; linarith

/-- **Indefinite phase (no-go).**  When the closure dominates the aperture (`|c| > a`, with
`0 ≤ a`) the sector form is indefinite: neither it nor its negative is positive
semidefinite, so there is **no** positive mass sector.  This is the "too balanced" regime of
the single-doublet witness. -/
theorem balanced_indefinite {a c : ℝ} (ha : 0 ≤ a) (h : a < |c|) :
    IsIndefinite (balancedSector a c) := by
  constructor
  · rw [balancedSector, Matrix.posSemidef_diagonal_iff, Fin.forall_fin_two]
    rintro ⟨h0, h1⟩
    rcases abs_cases c with ⟨hc, _⟩ | ⟨hc, _⟩ <;> rw [hc] at h
    · rw [Matrix.cons_val_one, Matrix.cons_val_zero, Complex.zero_le_real] at h1; linarith
    · rw [Matrix.cons_val_zero, Complex.zero_le_real] at h0; linarith
  · rw [neg_balancedSector, Matrix.posSemidef_diagonal_iff, Fin.forall_fin_two]
    rintro ⟨h0, h1⟩
    rcases abs_cases c with ⟨hc, _⟩ | ⟨hc, _⟩ <;> rw [hc] at h
    · rw [Matrix.cons_val_zero, Complex.zero_le_real] at h0; linarith
    · rw [Matrix.cons_val_one, Matrix.cons_val_zero, Complex.zero_le_real] at h1; linarith

/-! ## The finite phase diagram -/

/-- The three phases of a balanced carrier as a function of the structural variables. -/
inductive Phase where
  | massive
  | critical
  | indefinite
  deriving DecidableEq, Repr

/-- Classification of the balanced doublet by aperture strength `a` and closure strength `c`
(with `0 < a`), computed from the threshold `|c|` vs `a`. -/
noncomputable def balancedPhase (a c : ℝ) : Phase :=
  if |c| < a then Phase.massive
  else if |c| = a then Phase.critical
  else Phase.indefinite

/-- **The finite phase diagram (trichotomy).**  For any positive aperture `0 < a` the
balanced carrier realizes exactly the phase named by `balancedPhase`, and the three phases
are mutually exclusive and exhaustive, cut at the threshold `|c| = a`:

* `massive`     ⇔ `|c| < a`  — positive mass sector (`PosDef`);
* `critical`    ⇔ `|c| = a`  — massless zero mode (`PosSemidef`, not `PosDef`);
* `indefinite`  ⇔ `|c| > a`  — no positive sector (`IsIndefinite`). -/
theorem balanced_phase_classification {a c : ℝ} (ha : 0 < a) :
    (balancedPhase a c = Phase.massive ∧ (balancedSector a c).PosDef) ∨
    (balancedPhase a c = Phase.critical ∧
      (balancedSector a c).PosSemidef ∧ ¬ (balancedSector a c).PosDef) ∨
    (balancedPhase a c = Phase.indefinite ∧ IsIndefinite (balancedSector a c)) := by
  rcases lt_trichotomy (|c|) a with h | h | h
  · exact Or.inl ⟨by simp [balancedPhase, h], balanced_massive h⟩
  · refine Or.inr (Or.inl ⟨?_, balanced_critical ha h⟩)
    simp [balancedPhase, h]
  · refine Or.inr (Or.inr ⟨?_, balanced_indefinite ha.le h⟩)
    have h1 : ¬ |c| < a := not_lt.mpr h.le
    have h2 : ¬ |c| = a := ne_of_gt h
    simp [balancedPhase, h1, h2]

/-! ## The `Cl(4)` witness `T2_positive_mass`, reconstructed

An explicit two-edge closure block `B : Matrix (Fin 2) (Fin 4) ℂ` feeding a `4`-dimensional
carrier.  Its sector form `M6 = 1 + Bᴴ B` is positive definite with mass gap `≥ 1`, while the
closure term `Bᴴ B` alone is only semidefinite.  This is the graded-separated escape from the
balanced no-go. -/

/-- A concrete nontrivial two-edge closure block. -/
def T2_B : Matrix (Fin 2) (Fin 4) ℂ :=
  !![1, Complex.I, 0, 0; 0, 1, Complex.I, 1]

/-- The reconstructed `Cl(4)` sector form. -/
noncomputable def T2_M6 : Matrix (Fin 4) (Fin 4) ℂ := 1 + T2_Bᴴ * T2_B

/-- **`T2_positive_mass`.**  The two-edge `Cl(4)` carrier has a positive mass sector. -/
theorem T2_positive_mass : HasPositiveMassSector T2_M6 :=
  posDef_one_add_gram T2_B

/-- The `Cl(4)` witness has mass gap `≥ 1`. -/
theorem T2_massGap (x : Fin 4 → ℂ) :
    RCLike.re (star x ⬝ᵥ (1 : Matrix (Fin 4) (Fin 4) ℂ) *ᵥ x)
      ≤ RCLike.re (star x ⬝ᵥ T2_M6 *ᵥ x) :=
  massGap_one_add_gram T2_B x

/-- The closure term alone is only positive semidefinite: the aperture is what supplies the
gap. -/
theorem T2_closure_posSemidef : (T2_Bᴴ * T2_B).PosSemidef := gram_posSemidef T2_B

end KreinCarrier

/-! ## Axiom audit -/

#print axioms KreinCarrier.posDef_aperture_add_gram
#print axioms KreinCarrier.posDef_one_add_gram
#print axioms KreinCarrier.separatedSector_posDef
#print axioms KreinCarrier.massGap_one_add_gram
#print axioms KreinCarrier.massGap_pos
#print axioms KreinCarrier.eigenvalues_pos_of_positiveMassSector
#print axioms KreinCarrier.balanced_massive
#print axioms KreinCarrier.balanced_critical
#print axioms KreinCarrier.balanced_indefinite
#print axioms KreinCarrier.balanced_phase_classification
#print axioms KreinCarrier.T2_positive_mass
#print axioms KreinCarrier.T2_massGap
