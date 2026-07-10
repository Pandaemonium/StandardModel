import Mathlib

/-!
# Suite A — operator-to-geometry: a finite causal spectral distance on the T2 carrier

This file builds a finite **Lorentzian / causal** spectral distance `dCausal` on a
two–point Krein carrier and shows that the operator data `(A, D, J)` recovers

* the **mass scale** (Target 2): `dCausal m 0 1 = 1/m`, mirroring the Euclidean
  `seeds/SpectralDistance.lean` result `fwit_sep`, with explicit non-degeneracy
  witnesses `m = 3` and `m = 3/5`;
* the **causal order** (Target 3): the Krein/causal relation `CausalLE` is a partial
  order (reflexive, transitive, antisymmetric) and orients the two points `0 ≼ 1`;
* the **E-slot split** (Target 4): the order-derived causal class is *independent of
  the mass* (conformal class for free), while the scale `1/m` is decoration-derived,
  and their mismatch is exactly the scale ratio `m'/m`.

## The Krein carrier and the causal spectral distance `dCausal`

* Hilbert space `H = ℂ²` (`Fin 2`).
* Fundamental symmetry `J = σₓ = ![![0,1],![1,0]]` (Hermitian, `J² = 1`, trace `0`,
  indefinite): a genuine indefinite metric.
* Krein-self-adjoint Dirac operator `D m = ![![0, m],![-m, 0]]` (real antisymmetric;
  `sharp (D m) = J (D m)ᴴ J = D m`), with mass / decoration scale `m > 0`.
* Commutator `[D m, diag f] = m·(f 1 - f 0)·σₓ`, hence
  `J·[D m, diag f] = m·(f 1 - f 0)·I`, a real multiple of the identity: this is the
  Krein "causal energy" operator.

Following the **Franco–Eckstein causal-spectral-triple recipe** (clean-room port,
not assumed present in Mathlib):

* the **causal cone** is `IsCausal m f : (J·[D m, diag f]).PosSemidef`, i.e.
  the Krein causal-energy operator is positive semidefinite — equivalently
  `0 ≤ m·(f 1 - f 0)`;
* the **steepness normalization** is Connes' `‖[D m, diag f]‖ ≤ 1`;
* the **causal spectral distance** is the sup of the separation over admissible
  (causal + steep) test functions:
  `dCausal m x y = sup { f y - f x : IsCausal m f ∧ ‖[D m, diag f]‖ ≤ 1 }`.

All headline theorems are kernel-checked with axiom footprint
`[propext, Classical.choice, Quot.sound]`, verified in-file.
-/

open scoped Matrix Matrix.Norms.L2Operator ComplexOrder
open Matrix

namespace SuiteA_Op2Geom

/-! ## The Krein carrier -/

/-- Fundamental symmetry `J = σₓ` of the two–point Krein carrier (indefinite metric). -/
noncomputable def Jc : Matrix (Fin 2) (Fin 2) ℂ := Matrix.of ![![0, 1], ![1, 0]]

/-- Krein-self-adjoint Dirac operator with mass / decoration scale `m`:
`D m = ![![0, m],![-m, 0]]`. -/
noncomputable def Dc (m : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of ![![0, (m : ℂ)], ![-(m : ℂ), 0]]

/-- The Krein adjoint `X^# = J Xᴴ J`. -/
noncomputable def sharp (X : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Jc * Xᴴ * Jc

/-- Coercion of a real test function to a complex one. -/
noncomputable def cf (f : Fin 2 → ℝ) : Fin 2 → ℂ := fun i => (f i : ℂ)

/-- The Dirac commutator `[D m, diag f] = D m · diag f − diag f · D m`. -/
noncomputable def diracCommutator (m : ℝ) (f : Fin 2 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Dc m * Matrix.diagonal f - Matrix.diagonal f * Dc m

/-! ## Basic structural facts -/

/-- Every entry of a matrix is bounded in absolute value by its L² operator norm. -/
theorem entry_norm_le_l2_opNorm {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n ℂ) (i j : n) : ‖A i j‖ ≤ ‖A‖ := by
  have hmv := Matrix.l2_opNorm_mulVec A (EuclideanSpace.single j (1 : ℂ))
  rw [EuclideanSpace.norm_single] at hmv
  simp only [norm_one, mul_one] at hmv
  refine le_trans ?_ hmv
  have h2 : (EuclideanSpace.equiv n ℂ).symm (A *ᵥ (EuclideanSpace.single j (1 : ℂ)).ofLp) i
      = A i j := by
    rw [EuclideanSpace.ofLp_single]
    simp [Matrix.mulVec_single]
  rw [← h2]
  exact PiLp.norm_apply_le _ i

/-- `J² = 1` (`J` is a fundamental symmetry). -/
theorem Jc_sq : Jc * Jc = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Jc, Matrix.mul_apply, Fin.sum_univ_two]

/-- `J` is Hermitian. -/
theorem Jc_herm : Jcᴴ = Jc := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Jc, Matrix.conjTranspose_apply]

/-- `J` has zero trace, hence is genuinely indefinite. -/
theorem Jc_trace_zero : Jc.trace = 0 := by
  simp [Jc, Matrix.trace, Matrix.diag, Fin.sum_univ_two]

/-- The Dirac operator is Krein-self-adjoint: `sharp (D m) = D m`. -/
theorem sharp_Dc (m : ℝ) : sharp (Dc m) = Dc m := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [sharp, Dc, Jc, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.vecMul, dotProduct]

/-- `‖J‖ = 1` (`J` is unitary). -/
theorem Jc_norm : ‖Jc‖ = 1 := by
  apply CStarRing.norm_of_mem_unitary
  rw [Matrix.mem_unitaryGroup_iff]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Jc, Matrix.mul_apply, Fin.sum_univ_two, Matrix.star_apply]

/-- **Commutator computation.** `[D m, diag f] = (m·(f 1 - f 0))·J`. -/
theorem diracCommutator_eq (m : ℝ) (f : Fin 2 → ℝ) :
    diracCommutator m (cf f) = ((m * (f 1 - f 0) : ℝ) : ℂ) • Jc := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [diracCommutator, cf, Dc, Jc, Matrix.mul_apply, Matrix.diagonal_apply,
      Matrix.vecMul_diagonal, Matrix.cons_val_zero, Matrix.cons_val_one] <;>
    ring

/-- **Krein causal-energy operator.** `J·[D m, diag f] = (m·(f 1 - f 0))·I`. -/
theorem kreinComm_eq (m : ℝ) (f : Fin 2 → ℝ) :
    Jc * diracCommutator m (cf f)
      = ((m * (f 1 - f 0) : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  rw [diracCommutator_eq, mul_smul_comm, Jc_sq]

/-! ## The causal spectral distance -/

/-- The **causal cone** (Franco–Eckstein): `f` is causal when the Krein causal-energy
operator `J·[D m, diag f]` is positive semidefinite. -/
def IsCausal (m : ℝ) (f : Fin 2 → ℝ) : Prop :=
  (Jc * diracCommutator m (cf f)).PosSemidef

/-- The **steepness normalization** (Connes): `‖[D m, diag f]‖ ≤ 1`. -/
def Steep (m : ℝ) (f : Fin 2 → ℝ) : Prop :=
  ‖diracCommutator m (cf f)‖ ≤ 1

/-- Admissible test functions: causal and steep. -/
def Admissible (m : ℝ) (f : Fin 2 → ℝ) : Prop := IsCausal m f ∧ Steep m f

/-- **The finite causal spectral distance.** -/
noncomputable def dCausal (m : ℝ) (x y : Fin 2) : ℝ :=
  sSup ((fun f => f y - f x) '' {f | Admissible m f})

/-- The causal cone is the half-space `0 ≤ m·(f 1 - f 0)`. -/
theorem isCausal_iff (m : ℝ) (f : Fin 2 → ℝ) :
    IsCausal m f ↔ 0 ≤ m * (f 1 - f 0) := by
  unfold IsCausal
  rw [kreinComm_eq]
  rw [show ((m * (f 1 - f 0) : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        = diagonal (fun _ => ((m * (f 1 - f 0) : ℝ) : ℂ)) by
    simp [Matrix.smul_one_eq_diagonal]]
  rw [Matrix.posSemidef_diagonal_iff]
  constructor
  · intro h; have := h 0; rwa [Complex.zero_le_real] at this
  · intro h i; rwa [Complex.zero_le_real]

/-- Steepness bounds the Krein causal energy: `|m·(f 1 - f 0)| ≤ 1`. -/
theorem steep_bound (m : ℝ) (f : Fin 2 → ℝ) (h : Steep m f) :
    |m * (f 1 - f 0)| ≤ 1 := by
  unfold Steep at h
  rw [diracCommutator_eq] at h
  have hentry := entry_norm_le_l2_opNorm (((m * (f 1 - f 0) : ℝ) : ℂ) • Jc) 0 1
  have hJ : Jc 0 1 = 1 := by simp [Jc]
  have hval : ‖(((m * (f 1 - f 0) : ℝ) : ℂ) • Jc) 0 1‖ = |m * (f 1 - f 0)| := by
    rw [Matrix.smul_apply, hJ, smul_eq_mul, mul_one, Complex.norm_real, Real.norm_eq_abs]
  rw [hval] at hentry
  exact le_trans hentry h

/-- The optimizing (steep, causal) test function for the two–point separation. -/
noncomputable def fwit (m : ℝ) : Fin 2 → ℝ := ![0, 1 / m]

theorem fwit_zero (m : ℝ) : fwit m 0 = 0 := rfl
theorem fwit_one (m : ℝ) : fwit m 1 = 1 / m := rfl

/-- The optimizer is admissible and separates the two points by exactly `1/m`. -/
theorem admissible_fwit (m : ℝ) (hm : 0 < m) : Admissible m (fwit m) := by
  have hm0 : (m : ℝ) ≠ 0 := ne_of_gt hm
  have hc : m * (fwit m 1 - fwit m 0) = 1 := by
    simp only [fwit_zero, fwit_one, sub_zero]; field_simp
  refine ⟨?_, ?_⟩
  · rw [isCausal_iff, hc]; norm_num
  · unfold Steep
    rw [diracCommutator_eq, hc]
    simp [Jc_norm]

/-! ## Target 2 — scale recovery -/

/-- **Attainment / well-definedness (Target 1).** The causal spectral distance
`dCausal m 0 1` is the greatest separation over admissible test functions, attained
at `fwit m`, and equals `1/m`. -/
theorem dCausal_isGreatest_01 (m : ℝ) (hm : 0 < m) :
    IsGreatest ((fun f => f 1 - f 0) '' {f | Admissible m f}) (1 / m) := by
  constructor
  · refine ⟨fwit m, admissible_fwit m hm, ?_⟩
    simp [fwit_zero, fwit_one]
  · rintro z ⟨f, hf, rfl⟩
    have hb := steep_bound m f hf.2
    have hle : m * (f 1 - f 0) ≤ 1 := le_trans (le_abs_self _) hb
    rw [le_div_iff₀ hm, mul_comm]
    exact hle

/-- **Scale recovery (Target 2).** The causal spectral distance recovers the mass:
`dCausal m 0 1 = 1/m`. -/
theorem dCausal_01 (m : ℝ) (hm : 0 < m) : dCausal m 0 1 = 1 / m := by
  simpa [dCausal] using (dCausal_isGreatest_01 m hm).csSup_eq

/-- The reverse (anti-causal) separation is the greatest value `0`. -/
theorem dCausal_isGreatest_10 (m : ℝ) (hm : 0 < m) :
    IsGreatest ((fun f => f 0 - f 1) '' {f | Admissible m f}) 0 := by
  constructor
  · refine ⟨(fun _ => 0), ?_, by simp⟩
    refine ⟨?_, ?_⟩
    · rw [isCausal_iff]; simp
    · unfold Steep; rw [diracCommutator_eq]; simp
  · rintro z ⟨f, hf, rfl⟩
    have hc := (isCausal_iff m f).1 hf.1
    have h01 : 0 ≤ f 1 - f 0 := by nlinarith [hc, hm]
    linarith

/-- `dCausal m 1 0 = 0`: no causal separation against the arrow of time. -/
theorem dCausal_10 (m : ℝ) (hm : 0 < m) : dCausal m 1 0 = 0 := by
  simpa [dCausal] using (dCausal_isGreatest_10 m hm).csSup_eq

/-- `dCausal m x x = 0`. -/
theorem dCausal_self (m : ℝ) (x : Fin 2) : dCausal m x x = 0 := by
  have hG : IsGreatest ((fun f => f x - f x) '' {f | Admissible m f}) 0 := by
    constructor
    · refine ⟨(fun _ => 0), ?_, by simp⟩
      refine ⟨?_, ?_⟩
      · rw [isCausal_iff]; simp
      · unfold Steep; rw [diracCommutator_eq]; simp
    · rintro z ⟨f, hf, rfl⟩; simp
  simpa [dCausal] using hG.csSup_eq

/-- **Non-degeneracy witness `m = 3`.** -/
theorem dCausal_witness_3 : dCausal 3 0 1 = 1 / 3 := dCausal_01 3 (by norm_num)

/-- **Non-degeneracy witness `m = 3/5`.** -/
theorem dCausal_witness_35 : dCausal (3 / 5) 0 1 = 5 / 3 := by
  rw [dCausal_01 (3 / 5) (by norm_num)]; norm_num

/-- **Kill avoided (scale is recovered, not degenerate).** The distance is a strictly
positive, mass-dependent number: neither identically `0` nor mass-independent. -/
theorem kill_degenerate_avoided (m : ℝ) (hm : 0 < m) :
    0 < dCausal m 0 1 ∧ dCausal m 0 1 = 1 / m := by
  refine ⟨?_, dCausal_01 m hm⟩
  rw [dCausal_01 m hm]; positivity

/-- **Kill avoided (mass dependence).** The distance genuinely depends on `m`. -/
theorem kill_mass_dependence : dCausal 3 0 1 ≠ dCausal 1 0 1 := by
  rw [dCausal_witness_3, dCausal_01 1 (by norm_num)]; norm_num

/-! ## Target 3 — order recovery -/

/-- The **causal order** read off from the operator data: `x ≼ y` iff every causal
function is non-decreasing from `x` to `y`. -/
def CausalLE (m : ℝ) (x y : Fin 2) : Prop :=
  ∀ f : Fin 2 → ℝ, IsCausal m f → f x ≤ f y

theorem causalLE_refl (m : ℝ) (x : Fin 2) : CausalLE m x x := fun _ _ => le_refl _

theorem causalLE_trans (m : ℝ) {x y z : Fin 2}
    (hxy : CausalLE m x y) (hyz : CausalLE m y z) : CausalLE m x z :=
  fun f hf => le_trans (hxy f hf) (hyz f hf)

/-- The two points are causally ordered `0 ≼ 1`. -/
theorem causalLE_01 (m : ℝ) (hm : 0 < m) : CausalLE m 0 1 := by
  intro f hf
  have hc := (isCausal_iff m f).1 hf
  nlinarith [hc, hm]

/-- The order does not run backwards: `¬ (1 ≼ 0)`. -/
theorem not_causalLE_10 (m : ℝ) (hm : 0 < m) : ¬ CausalLE m 1 0 := by
  intro h
  have hcaus : IsCausal m (![0, 1] : Fin 2 → ℝ) := by
    rw [isCausal_iff]; norm_num; positivity
  have := h (![0, 1] : Fin 2 → ℝ) hcaus
  norm_num at this

/-- **Order recovery (Target 3) + Kill avoided.** `CausalLE` is a partial order
(reflexive, transitive, antisymmetric), so the operator determines a genuine causal
order, not merely a metric. -/
theorem causalLE_isPartialOrder (m : ℝ) (hm : 0 < m) :
    (∀ x, CausalLE m x x) ∧
    (∀ x y z, CausalLE m x y → CausalLE m y z → CausalLE m x z) ∧
    (∀ x y, CausalLE m x y → CausalLE m y x → x = y) := by
  refine ⟨causalLE_refl m, fun x y z => causalLE_trans m, ?_⟩
  intro x y hxy hyx
  fin_cases x <;> fin_cases y
  · rfl
  · exact absurd hyx (not_causalLE_10 m hm)
  · exact absurd hxy (not_causalLE_10 m hm)
  · rfl

/-- **Sign recovery.** The positivity of `dCausal` reproduces the strict causal order:
`0 < dCausal m x y ↔ x ≠ y ∧ CausalLE m x y`. -/
theorem dCausal_pos_iff (m : ℝ) (hm : 0 < m) (x y : Fin 2) :
    0 < dCausal m x y ↔ x ≠ y ∧ CausalLE m x y := by
  fin_cases x <;> fin_cases y <;> simp only [Fin.mk_zero, Fin.mk_one, Fin.isValue]
  · simp [dCausal_self m]
  · rw [dCausal_01 m hm]
    have hpos : (0 : ℝ) < 1 / m := by positivity
    simp only [hpos, true_and, true_iff, ne_eq, zero_ne_one, not_false_eq_true]
    exact causalLE_01 m hm
  · rw [dCausal_10 m hm]
    simp only [lt_irrefl, false_iff, not_and]
    intro _; exact not_causalLE_10 m hm
  · simp [dCausal_self m]

/-! ## Target 4 — the E-slot as order/scale mismatch -/

/-- The causal order is **independent of the mass**: the order-derived (conformal)
class is fixed for free, before any decoration. -/
theorem causalLE_mass_independent (m m' : ℝ) (hm : 0 < m) (hm' : 0 < m') (x y : Fin 2) :
    CausalLE m x y ↔ CausalLE m' x y := by
  constructor <;> intro h f hf <;> apply h f
  · rw [isCausal_iff] at hf ⊢
    have : 0 ≤ f 1 - f 0 := by nlinarith [hf, hm']
    nlinarith [this, hm]
  · rw [isCausal_iff] at hf ⊢
    have : 0 ≤ f 1 - f 0 := by nlinarith [hf, hm]
    nlinarith [this, hm']

/-- The **E-slot** quantity: the scale mismatch between two decorations at fixed causal
order. -/
noncomputable def Eslot (m m' : ℝ) : ℝ := dCausal m 0 1 / dCausal m' 0 1

/-- **E-slot split (Target 4).** The order-derived causal class is identical for the two
decorations `m, m'` (conformal class for free), while the decoration-derived scale
differs; the whole disagreement is the E-slot ratio `m'/m`. -/
theorem Eslot_mismatch (m m' : ℝ) (hm : 0 < m) (hm' : 0 < m') :
    (∀ x y, CausalLE m x y ↔ CausalLE m' x y) ∧
    dCausal m 0 1 = 1 / m ∧ dCausal m' 0 1 = 1 / m' ∧
    Eslot m m' = m' / m := by
  refine ⟨fun x y => causalLE_mass_independent m m' hm hm' x y,
    dCausal_01 m hm, dCausal_01 m' hm', ?_⟩
  unfold Eslot
  rw [dCausal_01 m hm, dCausal_01 m' hm']
  field_simp

/-- The E-slot is a genuine defect: it is `≠ 1` exactly when the scales differ, even
though the causal order is the same. -/
theorem Eslot_ne_one (m m' : ℝ) (hm : 0 < m) (hm' : 0 < m') (hmm : m ≠ m') :
    Eslot m m' ≠ 1 := by
  rw [(Eslot_mismatch m m' hm hm').2.2.2]
  intro h
  rw [div_eq_one_iff_eq (ne_of_gt hm)] at h
  exact hmm h.symm

end SuiteA_Op2Geom

/-! ## Axiom-footprint guards

Each headline result depends only on `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'SuiteA_Op2Geom.dCausal_01' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.dCausal_01

/-- info: 'SuiteA_Op2Geom.dCausal_isGreatest_01' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.dCausal_isGreatest_01

/-- info: 'SuiteA_Op2Geom.kill_degenerate_avoided' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.kill_degenerate_avoided

/-- info: 'SuiteA_Op2Geom.kill_mass_dependence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.kill_mass_dependence

/-- info: 'SuiteA_Op2Geom.dCausal_witness_3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.dCausal_witness_3

/-- info: 'SuiteA_Op2Geom.dCausal_witness_35' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.dCausal_witness_35

/-- info: 'SuiteA_Op2Geom.causalLE_mass_independent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.causalLE_mass_independent

/-- info: 'SuiteA_Op2Geom.causalLE_isPartialOrder' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.causalLE_isPartialOrder

/-- info: 'SuiteA_Op2Geom.dCausal_pos_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.dCausal_pos_iff

/-- info: 'SuiteA_Op2Geom.Eslot_mismatch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.Eslot_mismatch

/-- info: 'SuiteA_Op2Geom.Eslot_ne_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteA_Op2Geom.Eslot_ne_one
