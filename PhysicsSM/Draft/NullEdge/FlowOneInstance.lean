/-
Provenance: Aristotle job 88350d15 (fable-24h-flowinstance), harvested
2026-07-12 ~05:36 PDT. KERNEL-ONLY (0 native). Closes P-1DFLOW-R1's
no-instance caveat: a concrete two-band walk U(k)=diag(e^ik, i) whose
strengthened TwoBandFamily fields are all discharged, instantiating
flowDiff_eq_zero / no_single_crossing on an explicit walk. FINDING
(documented): the flow-one pseudo-doubler itself CANNOT satisfy the
fields (its second eigenvalue sits on the real axis at the coincident
crossing), so the simplest genuine transversal two-band walk is used.
-/
/-
# A concrete grounded `TwoBandFamily`: the diagonal flow walk `U(k) = diag(e^{ik}, i)`

This file closes the audit gap flagged against `context/TwoBandEigenphaseAnalytic.lean`:
that file proves the 1D flow-count law (`flowDiff_eq_zero`, `no_single_crossing'`)
for a *strengthened* `TwoBandFamily` structure but constructs **no** concrete
instance, so nothing verified that a real walk satisfies its hypotheses.

Here we build an explicit instance and discharge *every* field with no added
abstract hypotheses.

## Why not `U1c` itself?

The flow-one pseudo-doubler `U1c(z) = diag(z,1)·coin` of
`context/TwoBandCrossingDoubling.lean` has BOTH its `+1` and `−1` crossings at the
*same* momentum (`z = −1`), where `U1c(−1)` has eigenvalues `+1` AND `−1`
simultaneously.  Thus at that crossing the *second* eigenvalue is on the real
axis, which directly violates `CrossingData.hother_ne` (the second eigenvalue
must be off the real axis at a genuine simple transversal crossing).  So the
pseudo-doubler cannot satisfy the strengthened fields.

We therefore instantiate the *simplest* genuine two-band walk with exactly the
crossing structure the strengthened fields require:

  `U(k) = diag(e^{ik}, i)`.

Its two eigenphase bands are `e^{ik}` (winding once) and the constant `i`.
Over one period there are exactly two transversal `±1` crossings:

* a `+1` (`0`-) crossing at `k = 0`, and
* a `−1` (`π`-) crossing at `k = π`,

each *simple*: the second eigenvalue is the constant `i`, off the real axis.
The crossing list `[⟨0,true,1⟩, ⟨π,false,1⟩]` is complete, and we discharge the
crossing-list, `hbracket`/`hisolate`, `hclean` (bracket cleanliness) and the full
`CrossingData` `other`/`hother`/`hroots`/`hother_ne` branch fields.  Instantiating
`flowDiff_eq_zero` / `no_single_crossing'` on this family then gives a fully
grounded flow-count statement for an explicit walk.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.TwoBandEigenphaseAnalytic

noncomputable section

open Matrix Polynomial
open scoped Classical

namespace PhysicsSM.Draft.NullEdge.FlowOneInstance

open PhysicsSM.Draft.NullEdge.TwoBandEigenphaseCount

/-- The concrete two-band walk symbol `U(k) = diag(e^{ik}, i)`. -/
def Uw (k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![Complex.exp (Complex.I * k), 0; 0, Complex.I]

/-! ### Algebraic identities for `Uw` -/

lemma Uw_trace (k : ℝ) : (Uw k).trace = Complex.exp (Complex.I * k) + Complex.I := by
  simp [Uw, Matrix.trace_fin_two]

lemma Uw_det (k : ℝ) : (Uw k).det = Complex.exp (Complex.I * k) * Complex.I := by
  simp [Uw, Matrix.det_fin_two]

/-- The characteristic polynomial factors as `(X - e^{ik})(X - i)`. -/
lemma Uw_charpoly (k : ℝ) :
    (Uw k).charpoly = (X - C (Complex.exp (Complex.I * k))) * (X - C Complex.I) := by
  rw [Matrix.charpoly_fin_two, Uw_trace, Uw_det]
  simp only [Polynomial.C_add, Polynomial.C_mul]
  ring

/-- The eigenvalue multiset is `{e^{ik}, i}`. -/
lemma Uw_roots (k : ℝ) :
    (Uw k).charpoly.roots = {Complex.exp (Complex.I * k), Complex.I} := by
  rw [Uw_charpoly, Polynomial.roots_mul, Polynomial.roots_X_sub_C, Polynomial.roots_X_sub_C]
  · rfl
  · exact mul_ne_zero (Polynomial.X_sub_C_ne_zero _) (Polynomial.X_sub_C_ne_zero _)

/-- The characteristic polynomial vanishes at the crossing eigenvalue `e^{ik}`. -/
lemma Uw_eval_root (k : ℝ) :
    (Uw k).charpoly.eval (Complex.exp (Complex.I * k)) = 0 := by
  rw [Uw_charpoly]; simp

/-- Exact `0`-crossing polynomial value. -/
lemma Uw_eval_one (k : ℝ) :
    (Uw k).charpoly.eval 1 = (1 - Complex.I) * (1 - Complex.exp (Complex.I * k)) := by
  rw [Uw_charpoly]
  simp only [eval_mul, eval_sub, eval_X, eval_C]
  ring

/-- Exact `π`-crossing polynomial value. -/
lemma Uw_eval_neg_one (k : ℝ) :
    (Uw k).charpoly.eval (-1) = (1 + Complex.I) * (1 + Complex.exp (Complex.I * k)) := by
  rw [Uw_charpoly]
  simp only [eval_mul, eval_sub, eval_X, eval_C]
  ring

/-- Imaginary part of the winding band. -/
lemma Uw_exp_im (k : ℝ) : (Complex.exp (Complex.I * k)).im = Real.sin k := by
  rw [mul_comm, Complex.exp_mul_I]
  simp [Complex.add_im, Complex.mul_im, Complex.sin_ofReal_re]

lemma Uw_continuous : Continuous Uw := by
  apply continuous_matrix
  intro i j
  fin_cases i <;> fin_cases j <;>
    simp only [Uw, Matrix.of_apply, Matrix.cons_val', Matrix.empty_val',
      Matrix.cons_val_fin_one] <;>
    first
      | exact continuous_const
      | exact Complex.continuous_exp.comp (continuous_const.mul Complex.continuous_ofReal)

lemma Uw_periodic (k : ℝ) : Uw (k + 2 * Real.pi) = Uw k := by
  have h : Complex.exp (Complex.I * ((k : ℂ) + 2 * Real.pi)) = Complex.exp (Complex.I * k) := by
    rw [mul_add, Complex.exp_add]
    have hc : Complex.I * (2 * (Real.pi : ℂ)) = (2 * Real.pi) * Complex.I := by ring
    rw [hc, Complex.exp_two_pi_mul_I, mul_one]
  unfold Uw
  push_cast
  rw [h]

lemma Uw_unitary (k : ℝ) : Uw k ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [Matrix.mem_unitaryGroup_iff]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Uw, Matrix.mul_apply, Fin.sum_univ_two, Matrix.star_apply]
  rw [← Complex.exp_conj, ← Complex.exp_add]; simp

/-! ### `±1` occur only where `sin` vanishes -/

/-- On `[-π/2, π/2]`, the sine vanishes only at `0`. -/
lemma sin_ne_zero_bracket0 (k : ℝ) (hk : k ∈ Set.Icc (-(Real.pi/2)) (Real.pi/2))
    (hne : k ≠ 0) : Real.sin k ≠ 0 := by
  intro hsin
  rw [Real.sin_eq_zero_iff] at hsin
  obtain ⟨n, rfl⟩ := hsin
  obtain ⟨h1, h2⟩ := hk
  have hpi := Real.pi_pos
  have hn : n = 0 := by
    rcases lt_trichotomy n 0 with h | h | h
    · exfalso; have : (n : ℝ) ≤ -1 := by exact_mod_cast Int.le_sub_one_of_lt h
      nlinarith
    · exact h
    · exfalso; have : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast h
      nlinarith
  simp [hn] at hne

/-- On `[π/2, 3π/2]`, the sine vanishes only at `π`. -/
lemma sin_ne_zero_bracket1 (k : ℝ) (hk : k ∈ Set.Icc (Real.pi/2) (3*Real.pi/2))
    (hne : k ≠ Real.pi) : Real.sin k ≠ 0 := by
  intro hsin
  rw [Real.sin_eq_zero_iff] at hsin
  obtain ⟨n, rfl⟩ := hsin
  obtain ⟨h1, h2⟩ := hk
  have hpi := Real.pi_pos
  have hn : n = 1 := by
    rcases lt_trichotomy n 1 with h | h | h
    · exfalso; have : (n : ℝ) ≤ 0 := by exact_mod_cast Int.lt_add_one_iff.mp h
      nlinarith
    · exact h
    · exfalso; have : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast h
      nlinarith
  rw [hn] at hne; simp at hne

/-- If `sin k ≠ 0`, neither `1` nor `-1` is an eigenvalue of `Uw k`. -/
lemma Uw_gapped_of_sin_ne (k : ℝ) (h : Real.sin k ≠ 0) :
    (Uw k).charpoly.eval 1 ≠ 0 ∧ (Uw k).charpoly.eval (-1) ≠ 0 := by
  constructor
  · rw [Uw_eval_one]
    intro hz
    rcases mul_eq_zero.mp hz with h1 | h1
    · exact absurd h1 (by simp [Complex.ext_iff])
    · apply h
      have hone : Complex.exp (Complex.I * k) = 1 := by linear_combination -h1
      rw [← Uw_exp_im, hone]; simp
  · rw [Uw_eval_neg_one]
    intro hz
    rcases mul_eq_zero.mp hz with h1 | h1
    · exact absurd h1 (by simp [Complex.ext_iff])
    · apply h
      have hone : Complex.exp (Complex.I * k) = -1 := by linear_combination h1
      rw [← Uw_exp_im, hone]; simp

/-! ### The crossing data -/

/-- `0`-crossing (`+1`) at momentum `0`. -/
def c0 : Crossing := ⟨0, true, 1⟩

/-- `π`-crossing (`-1`) at momentum `π`. -/
def c1 : Crossing := ⟨Real.pi, false, 1⟩

/-- Crossing data at the `+1` crossing `k = 0`. -/
def dataF0 : CrossingData Uw c0 where
  branch := id
  deriv_val := 1
  hderiv := hasDerivAt_id _
  hnz := one_ne_zero
  hphase0 := by simp [c0]
  heigen := Filter.Eventually.of_forall (fun k => Uw_eval_root k)
  hsign := by norm_num [c0]
  other := fun _ => Complex.I
  hother := continuous_const
  hroots := Filter.Eventually.of_forall (fun k => Uw_roots k)
  hother_ne := by simp

/-- Crossing data at the `-1` crossing `k = π`. -/
def dataF1 : CrossingData Uw c1 where
  branch := id
  deriv_val := 1
  hderiv := hasDerivAt_id _
  hnz := one_ne_zero
  hphase0 := by simp [c1]
  heigen := Filter.Eventually.of_forall (fun k => Uw_eval_root k)
  hsign := by norm_num [c1]
  other := fun _ => Complex.I
  hother := continuous_const
  hroots := Filter.Eventually.of_forall (fun k => Uw_roots k)
  hother_ne := by simp

/-! ### The family data -/

/-- The ordered crossing list: complete. -/
def csF : List Crossing := [c0, c1]

/-- The interval sample momenta: `-π/2, π/2, 3π/2, …`. -/
def sampleF : ℕ → ℝ := fun n => -(Real.pi/2) + n * Real.pi

lemma hsample_wrapF : sampleF csF.length = sampleF 0 + 2 * Real.pi := by
  show sampleF 2 = sampleF 0 + 2 * Real.pi
  simp only [sampleF]
  push_cast
  ring

lemma hbracketF : ∀ i : Fin csF.length,
    sampleF i < (csF[i]).momentum ∧ (csF[i]).momentum < sampleF (i + 1) := by
  have hpi := Real.pi_pos
  intro i
  match i with
  | ⟨0, _⟩ => refine ⟨?_, ?_⟩ <;> · simp [sampleF, csF, c0]; nlinarith
  | ⟨1, _⟩ => refine ⟨?_, ?_⟩ <;> · simp [sampleF, csF, c1]; nlinarith

lemma hisolateF : ∀ i j : Fin csF.length,
    (csF[j]).momentum ∈ Set.Icc (sampleF i) (sampleF (i + 1)) → j = i := by
  have hpi := Real.pi_pos
  intro i j hmem
  match i, j with
  | ⟨0, _⟩, ⟨0, _⟩ => rfl
  | ⟨0, _⟩, ⟨1, _⟩ =>
      exfalso; simp [sampleF, csF, c0, c1, Set.mem_Icc] at hmem; nlinarith [hmem.1, hmem.2]
  | ⟨1, _⟩, ⟨0, _⟩ =>
      exfalso; simp [sampleF, csF, c0, c1, Set.mem_Icc] at hmem; nlinarith [hmem.1, hmem.2]
  | ⟨1, _⟩, ⟨1, _⟩ => rfl

lemma hcleanF : ∀ i : Fin csF.length, ∀ k ∈ Set.Icc (sampleF i) (sampleF (i + 1)),
    k ≠ (csF[i]).momentum →
      (Uw k).charpoly.eval 1 ≠ 0 ∧ (Uw k).charpoly.eval (-1) ≠ 0 := by
  intro i k hk hne
  apply Uw_gapped_of_sin_ne
  match i with
  | ⟨0, _⟩ =>
    refine sin_ne_zero_bracket0 k ?_ (by simpa [csF, c0] using hne)
    simp only [Set.mem_Icc, sampleF] at hk ⊢
    push_cast at hk
    constructor <;> nlinarith [hk.1, hk.2, Real.pi_pos]
  | ⟨1, _⟩ =>
    refine sin_ne_zero_bracket1 k ?_ (by simpa [csF, c1] using hne)
    simp only [Set.mem_Icc, sampleF] at hk ⊢
    push_cast at hk
    constructor <;> nlinarith [hk.1, hk.2, Real.pi_pos]

/-- **The concrete grounded two-band family** `U(k) = diag(e^{ik}, i)`. -/
def flowOneFamily : TwoBandFamily where
  U := Uw
  hcont := Uw_continuous
  hper := Uw_periodic
  hU := Uw_unitary
  cs := csF
  sample := sampleF
  hsample_wrap := hsample_wrapF
  hbracket := hbracketF
  hisolate := hisolateF
  data := fun i => by
    match i with
    | ⟨0, _⟩ => exact dataF0
    | ⟨1, _⟩ => exact dataF1
  hclean := hcleanF

/-! ### The grounded flow-count statements for this explicit walk -/

/-- The signed flow difference of the explicit walk vanishes. -/
theorem flowOne_flowDiff_eq_zero : flowDiff flowOneFamily.cs = 0 :=
  flowOneFamily.flowDiff_eq_zero

/-- The explicit walk has more than one crossing (no single crossing). -/
theorem flowOne_no_single_crossing : flowOneFamily.cs.length ≠ 1 :=
  flowOneFamily.no_single_crossing' (by
    intro c hc
    fin_cases hc <;> simp [c0, c1])

end PhysicsSM.Draft.NullEdge.FlowOneInstance
