import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000

/-!
# `mass² = det P` is the CANONICAL choice

On real symmetric `2×2` matrices, the determinant is (up to scale) the **unique** quadratic form
that (i) vanishes on every rank-`≤1` ("null edge") matrix and (ii) is invariant under the
congruence action of `SL(2,ℝ)` (`P ↦ Aᵀ P A`, `det A = 1`).  Hence the mass invariant
`mass² = det P` is *forced*, not conventional.

The space of symmetric `2×2` matrices `P = !![a,b;b,c]` is `3`-dimensional with coordinates
`(a,b,c)`.  A general quadratic form has six coefficients:
`Q(P) = c₀ a² + c₁ b² + c₂ c² + c₃ a b + c₄ a c + c₅ b c`.
The determinant `det P = a c - b²` corresponds to `c₁ = -1, c₄ = 1`, the rest zero.

Provenance: classical invariant theory — the determinant is *the* `SL(2)` relative invariant.
Honest scope: real symmetric `2×2` (one null-edge pair / one momentum); the uniqueness is among
quadratic forms.
-/

namespace DetPUniqueness

open Matrix

/-- A symmetric `2×2` real matrix from its three coordinates `(a,b,c)`. -/
def sym (a b c : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![a, b; b, c]

/-- The rank-`≤1` "null edge" matrix `v vᵀ`. -/
def edge (v : Fin 2 → ℝ) : Matrix (Fin 2) (Fin 2) ℝ := Matrix.of (fun i j => v i * v j)

/-- A general quadratic form on symmetric `2×2` matrices, given by six coefficients
`co 0,…,co 5` acting on the entries `a = P 0 0`, `b = P 0 1`, `c = P 1 1`. -/
def Qform (co : Fin 6 → ℝ) (P : Matrix (Fin 2) (Fin 2) ℝ) : ℝ :=
  co 0 * (P 0 0)^2 + co 1 * (P 0 1)^2 + co 2 * (P 1 1)^2
    + co 3 * (P 0 0) * (P 0 1) + co 4 * (P 0 0) * (P 1 1) + co 5 * (P 0 1) * (P 1 1)

/-- Coefficients of the determinant form `det P = a c - b²` (`c₁ = -1`, `c₄ = 1`). -/
def detCoeff : Fin 6 → ℝ := ![0, -1, 0, 0, 1, 0]

/-- Coefficients of the "trace-like" product `Q'(P) = a c` (only `c₄ = 1`). -/
def acCoeff : Fin 6 → ℝ := ![0, 0, 0, 0, 1, 0]

/-! ## Basic identities -/

@[simp] lemma sym_00 (a b c : ℝ) : (sym a b c) 0 0 = a := by simp [sym]
@[simp] lemma sym_01 (a b c : ℝ) : (sym a b c) 0 1 = b := by simp [sym]
@[simp] lemma sym_10 (a b c : ℝ) : (sym a b c) 1 0 = b := by simp [sym]
@[simp] lemma sym_11 (a b c : ℝ) : (sym a b c) 1 1 = c := by simp [sym]

lemma det_sym (a b c : ℝ) : Matrix.det (sym a b c) = a * c - b * b := by
  simp [sym, Matrix.det_fin_two]

/-- **Target 1.** The determinant vanishes on every null edge `v vᵀ`. -/
theorem det_vanishes_on_edges (v : Fin 2 → ℝ) : Matrix.det (edge v) = 0 := by
  simp only [edge, Matrix.det_fin_two, Matrix.of_apply]
  ring

/-- **Target 2.** The determinant is a relative invariant of congruence:
`det (Aᵀ P A) = (det A)² · det P`. -/
theorem det_congruence_relative_invariant
    (A P : Matrix (Fin 2) (Fin 2) ℝ) :
    Matrix.det (Aᵀ * P * A) = (Matrix.det A)^2 * Matrix.det P := by
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose]
  ring

/-- In particular, for `A ∈ SL(2,ℝ)` (`det A = 1`) the determinant is congruence-invariant. -/
theorem det_congruence_SL2_invariant
    (A P : Matrix (Fin 2) (Fin 2) ℝ) (hA : Matrix.det A = 1) :
    Matrix.det (Aᵀ * P * A) = Matrix.det P := by
  rw [det_congruence_relative_invariant, hA]; ring

/-- Evaluation of a quadratic form on a null edge `edge ![x,y]` as a quartic in `x,y`. -/
lemma Qform_edge (co : Fin 6 → ℝ) (x y : ℝ) :
    Qform co (edge ![x, y]) =
      co 0 * x^4 + co 3 * x^3 * y + (co 1 + co 4) * x^2 * y^2
        + co 5 * x * y^3 + co 2 * y^4 := by
  simp only [Qform, edge, Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-! ## The support lemma: null-vanishing pins the coefficients to the `det` pattern -/

/-- **Target 3 (`edge_span`).**  If a quadratic form `Q` vanishes on *every* null edge `v vᵀ`,
then its coefficients are forced onto the determinant pattern: the pure `a²`, `c²`, `ab`, `bc`
coefficients vanish and the `b²` and `ac` coefficients are opposite. -/
theorem edge_span (co : Fin 6 → ℝ)
    (hnull : ∀ v : Fin 2 → ℝ, Qform co (edge v) = 0) :
    co 0 = 0 ∧ co 2 = 0 ∧ co 3 = 0 ∧ co 5 = 0 ∧ co 1 + co 4 = 0 := by
  have h10 := hnull ![1, 0]
  have h01 := hnull ![0, 1]
  have h11 := hnull ![1, 1]
  have h1m := hnull ![1, -1]
  have h21 := hnull ![2, 1]
  rw [Qform_edge] at h10 h01 h11 h1m h21
  norm_num at h10 h01 h11 h1m h21
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> linarith

/-- **Target 4 (`detP_unique`).**  Any quadratic form on symmetric `2×2` matrices that
(i) vanishes on every null edge and (ii) is `SL(2,ℝ)`-congruence invariant equals `k · det`
for some real scalar `k`.  Thus the mass invariant `mass² = det P` is canonical.

(The `SL(2)`-invariance hypothesis `hinv` is requested by the specification and is kept for
faithfulness; the null-vanishing condition already forces the conclusion, so `hinv` is not needed
in the proof.) -/
theorem detP_unique (co : Fin 6 → ℝ)
    (hnull : ∀ v : Fin 2 → ℝ, Qform co (edge v) = 0)
    (_hinv : ∀ (A : Matrix (Fin 2) (Fin 2) ℝ) (a b c : ℝ), Matrix.det A = 1 →
      Qform co (Aᵀ * (sym a b c) * A) = Qform co (sym a b c)) :
    ∃ k : ℝ, ∀ (a b c : ℝ), Qform co (sym a b c) = k * Matrix.det (sym a b c) := by
  obtain ⟨hc0, hc2, hc3, hc5, hsum⟩ := edge_span co hnull
  refine ⟨co 4, ?_⟩
  intro a b c
  simp only [Qform, sym_00, sym_01, sym_11, det_sym]
  linear_combination a^2 * hc0 + c^2 * hc2 + (a*b) * hc3 + (b*c) * hc5 + b^2 * hsum

/-! ## Non-degeneracy: the null-vanishing condition is a real constraint -/

lemma sym_transpose (a b c : ℝ) : (sym a b c)ᵀ = sym a b c := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [sym]

/-- On any symmetric matrix (`M 0 1 = M 1 0`) the determinant form `Qform detCoeff` equals the
determinant. -/
lemma Qform_detCoeff_eq_det (M : Matrix (Fin 2) (Fin 2) ℝ) (hM : M 0 1 = M 1 0) :
    Qform detCoeff M = Matrix.det M := by
  simp only [Qform, detCoeff, Matrix.det_fin_two,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
  rw [hM]; ring

/-- The determinant form `Qform detCoeff` really is the determinant on symmetric matrices. -/
lemma Qform_detCoeff (a b c : ℝ) :
    Qform detCoeff (sym a b c) = Matrix.det (sym a b c) :=
  Qform_detCoeff_eq_det _ (by simp)

/-- The determinant form vanishes on every null edge (target-1 restated for `detCoeff`). -/
lemma detCoeff_null (v : Fin 2 → ℝ) : Qform detCoeff (edge v) = 0 := by
  have : Qform detCoeff (edge v) = Matrix.det (edge v) := by
    simp only [Qform, detCoeff, edge, Matrix.of_apply, Matrix.det_fin_two,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
    norm_num; ring
  rw [this, det_vanishes_on_edges]

/-- **Mandatory non-degeneracy.**  The "trace-like" quadratic `Q'(P) = a c` vanishes on the two
coordinate null edges `edge e₀` and `edge e₁`, but *not* on the diagonal null edge
`edge (e₀+e₁)` where it equals `1 ≠ 0`.  This shows the null-vanishing condition is a genuine
constraint — one that the determinant uniquely satisfies (any `ac`-only form fails it). -/
theorem acCoeff_not_null :
    Qform acCoeff (edge ![1, 0]) = 0 ∧ Qform acCoeff (edge ![0, 1]) = 0 ∧
      Qform acCoeff (edge ![1, 1]) = 1 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    · simp only [Qform, acCoeff, edge, Matrix.of_apply, Matrix.cons_val_zero,
        Matrix.cons_val_one, Matrix.cons_val_fin_one, Matrix.cons_val]
      norm_num

/-- The trace-like form `Q'(P) = a c` is **not** `SL(2,ℝ)`-congruence invariant: the unit-shear
`A = !![1,1;0,1]` (`det A = 1`) maps `P = !![1,0;0,0]` to `!![1,1;1,1]`, changing `Q'` from `0`
to `1`. -/
theorem acCoeff_not_invariant :
    ∃ (A : Matrix (Fin 2) (Fin 2) ℝ) (a b c : ℝ), Matrix.det A = 1 ∧
      Qform acCoeff (Aᵀ * (sym a b c) * A) ≠ Qform acCoeff (sym a b c) := by
  refine ⟨!![1, 1; 0, 1], 1, 0, 0, ?_, ?_⟩
  · simp [Matrix.det_fin_two]
  · simp only [sym, acCoeff, Qform, Matrix.transpose_apply,
      Matrix.mul_apply, Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val]
    norm_num

/-! ## Verdict -/

/-- **`uniqueness_verdict`.**  Packaging: `det P` is *the* `mass²` invariant, forced by
null-vanishing together with `SL(2,ℝ)`-invariance, not chosen.

* the determinant form vanishes on every null edge;
* it is `SL(2,ℝ)`-congruence invariant;
* **uniqueness**: any quadratic form with both properties equals `k · det`;
* **non-degeneracy**: the trace-like form `Q'(P) = a c` vanishes on the coordinate edges but
  not on the diagonal edge, so null-vanishing is a real constraint that `det` uniquely meets. -/
theorem uniqueness_verdict :
    (∀ v : Fin 2 → ℝ, Qform detCoeff (edge v) = 0) ∧
    (∀ (A : Matrix (Fin 2) (Fin 2) ℝ) (a b c : ℝ), Matrix.det A = 1 →
      Qform detCoeff (Aᵀ * (sym a b c) * A) = Qform detCoeff (sym a b c)) ∧
    (∀ co : Fin 6 → ℝ,
      (∀ v : Fin 2 → ℝ, Qform co (edge v) = 0) →
      (∀ (A : Matrix (Fin 2) (Fin 2) ℝ) (a b c : ℝ), Matrix.det A = 1 →
        Qform co (Aᵀ * (sym a b c) * A) = Qform co (sym a b c)) →
      ∃ k : ℝ, ∀ (a b c : ℝ), Qform co (sym a b c) = k * Matrix.det (sym a b c)) ∧
    (Qform acCoeff (edge ![1, 0]) = 0 ∧ Qform acCoeff (edge ![0, 1]) = 0 ∧
      Qform acCoeff (edge ![1, 1]) = 1) := by
  refine ⟨detCoeff_null, ?_, detP_unique, acCoeff_not_null⟩
  intro A a b c hA
  have hMsymm : (Aᵀ * sym a b c * A)ᵀ = Aᵀ * sym a b c * A := by
    rw [Matrix.transpose_mul, Matrix.transpose_mul, Matrix.transpose_transpose,
      sym_transpose, Matrix.mul_assoc]
  have hM01 := congrFun (congrFun hMsymm 1) 0
  simp only [Matrix.transpose_apply] at hM01
  rw [Qform_detCoeff_eq_det _ hM01, Qform_detCoeff_eq_det _ (by simp),
    det_congruence_SL2_invariant _ _ hA]

/-! ## Axiom audit -/

/-- info: 'DetPUniqueness.det_vanishes_on_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_vanishes_on_edges

/-- info: 'DetPUniqueness.det_congruence_relative_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_congruence_relative_invariant

/-- info: 'DetPUniqueness.edge_span' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edge_span

/-- info: 'DetPUniqueness.detP_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms detP_unique

/-- info: 'DetPUniqueness.acCoeff_not_null' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms acCoeff_not_null

/-- info: 'DetPUniqueness.acCoeff_not_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms acCoeff_not_invariant

/-- info: 'DetPUniqueness.uniqueness_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms uniqueness_verdict

end DetPUniqueness
