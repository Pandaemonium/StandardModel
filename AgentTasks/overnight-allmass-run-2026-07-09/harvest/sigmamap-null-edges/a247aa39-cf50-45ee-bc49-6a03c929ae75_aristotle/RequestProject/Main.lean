import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# The sigma-map `P(p) = p.σ` IS a sum of two null-edge dyads

We close the "which `P`" loop between two representations of the little-group
spinor matrix that appear in the program:

* the **sigma-map** `P(p) = p_μ σ^μ` (PhysLean's Pauli convention, with
  `det P = m²`), and
* the manuscript's **null-edge Gram** `M Mᴴ = Σᵢ ψᵢ ψᵢᴴ`, i.e. a PSD matrix
  written as a sum of rank-1 null dyads.

Restricting a massive 2-momentum to the `(t,z)` plane, `p = (E, 0, 0, kz)`, the
Pauli sigma-map is the *real* diagonal Hermitian matrix

  `P E kz = !![E + kz, 0; 0, E - kz]`,   `det P = E² - kz² = m²`.

We show `P E kz` is *exactly* a nonnegative combination of two rank-1 null-edge
dyads (the two chirality / light-cone directions), that its determinant equals
the "disagreement" of the two edges (the product of their weights), and that it
collapses to a single null edge (rank 1, `det = 0`) precisely at masslessness.

Honest scope: this is the real `(t,z)`-restricted rational avatar; the general
complex case is identical with Hermitian dyads.
-/

namespace SigmaMapNullEdges

/-- The Pauli sigma-map `P(p) = p_μ σ^μ` in the `(t,z)` plane, `p = (E,0,0,kz)`.
Real diagonal Hermitian `2×2`, PSD when `E ≥ |kz|`. -/
def P (E kz : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![E + kz, 0; 0, E - kz]

/-- A rank-1 "null edge" dyad `v vᵀ`. Its determinant vanishes (rank 1). -/
def edge (v : Fin 2 → ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![v 0 * v 0, v 0 * v 1; v 1 * v 0, v 1 * v 1]

/-- The two light-cone / chirality directions. -/
def e0 : Fin 2 → ℚ := ![1, 0]
def e1 : Fin 2 → ℚ := ![0, 1]

/-! ## Target 1 : `P` is the closed sigma-map and `det P = E² - kz² = m²` -/

/-- The sigma-map is the stated diagonal matrix and its determinant is
`E² - kz² = m²` on shell. -/
theorem P_closed (E kz : ℚ) :
    P E kz = !![E + kz, 0; 0, E - kz] ∧ (P E kz).det = E ^ 2 - kz ^ 2 := by
  refine ⟨rfl, ?_⟩
  simp [P, Matrix.det_fin_two]; ring

/-! ## Target 2 : each null edge is rank-1 (`det = 0`) -/

/-- Every null-edge dyad `edge v = v vᵀ` has determinant `0`, i.e. it is rank ≤ 1
(null). -/
theorem edge_rank_one (v : Fin 2 → ℚ) : (edge v).det = 0 := by
  simp [edge, Matrix.det_fin_two]; ring

/-- The explicit first null edge: `edge ![1,0] = !![1,0;0,0]`. -/
theorem edge_e0 : edge e0 = !![1, 0; 0, 0] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [edge, e0]

/-- The explicit second null edge: `edge ![0,1] = !![0,0;0,1]`. -/
theorem edge_e1 : edge e1 = !![0, 0; 0, 1] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [edge, e1]

/-! ## Target 3 (payload) : `P` is a nonneg sum of two rank-1 null-edge dyads -/

/-- **Payload.** The sigma-map matrix is *exactly* a nonnegative combination of
two rank-1 null-edge dyads, one for each chirality / light-cone direction:
`P E kz = (E+kz) • edge e0 + (E-kz) • edge e1`.  So `P(p)` coming from PhysLean's
Pauli convention IS a sum of null edges. -/
theorem P_eq_null_edge_sum (E kz : ℚ) :
    P E kz = (E + kz) • edge e0 + (E - kz) • edge e1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [P, edge, e0, e1]

/-! ## Target 4 (payload) : the determinant is the null-edge disagreement -/

/-- **Payload.** `det P` is the product of the two edge weights `(E+kz)(E-kz)`,
which equals `E² - kz² = m²`: the "disagreement" between the two null edges. -/
theorem det_is_disagreement (E kz : ℚ) :
    (P E kz).det = (E + kz) * (E - kz) ∧ (P E kz).det = E ^ 2 - kz ^ 2 := by
  have h : (P E kz).det = E ^ 2 - kz ^ 2 := by simp [P, Matrix.det_fin_two]; ring
  exact ⟨by rw [h]; ring, h⟩

/-- Massless ⟺ one weight vanishes ⟺ a single null edge: `det P = 0 ↔ E² = kz²`. -/
theorem det_zero_iff_massless (E kz : ℚ) :
    (P E kz).det = 0 ↔ E ^ 2 = kz ^ 2 := by
  have h : (P E kz).det = E ^ 2 - kz ^ 2 := by simp [P, Matrix.det_fin_two]; ring
  rw [h, sub_eq_zero]

/-- Massive ⟺ both weights nonzero of the same sign ⟺ two genuine null edges:
`0 < det P ↔ kz² < E²`. -/
theorem det_pos_iff_massive (E kz : ℚ) :
    0 < (P E kz).det ↔ kz ^ 2 < E ^ 2 := by
  have h : (P E kz).det = E ^ 2 - kz ^ 2 := by simp [P, Matrix.det_fin_two]; ring
  rw [h, sub_pos]

/-! ## Mandatory non-degeneracy witnesses -/

/-- Massive witness `E = 5, kz = 3`: `P = !![8,0;0,2]`. -/
theorem witness_massive_P : P 5 3 = !![8, 0; 0, 2] := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [P]

/-- Massive witness: `det (P 5 3) = 16 = m²`, and it is a sum of two null edges
with weights `8` and `2`. -/
theorem witness_massive_det :
    (P 5 3).det = 16 ∧ P 5 3 = (8 : ℚ) • edge e0 + (2 : ℚ) • edge e1 := by
  refine ⟨by simp [P, Matrix.det_fin_two]; norm_num, ?_⟩
  have := P_eq_null_edge_sum 5 3
  norm_num at this ⊢
  exact this

/-- Null (massless) witness `E = kz = 1`: `P = !![2,0;0,0]`, a single null edge,
`det = 0`. -/
theorem witness_massless :
    P 1 1 = !![2, 0; 0, 0] ∧ (P 1 1).det = 0 := by
  refine ⟨?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> norm_num [P]
  · simp [P, Matrix.det_fin_two]

/-! ## Target 5 : the verdict, packaging the closed loop -/

/-- **Verdict.** The PhysLean-grounded sigma-map `P(p) = p.σ` and the manuscript's
null-edge Gram `M Mᴴ = Σᵢ ψᵢ ψᵢᴴ` are the SAME little-group spinor matrix:

1. `P` is a nonnegative sum of two rank-1 null-edge dyads (`P_eq_null_edge_sum`);
2. each dyad is rank-1 / null (`edge_rank_one`);
3. `det P` is the null-edge disagreement `(E+kz)(E-kz) = E² - kz² = m²`
   (`det_is_disagreement`);
4. `P` collapses to a single null edge (rank 1, `det = 0`) exactly at
   masslessness (`det_zero_iff_massless`), and is genuinely two edges
   (`0 < det P`) exactly when massive (`det_pos_iff_massive`).

This closes the "which `P`" loop: the `det P` mass is frame-independent because
`P` is this spinor object, decomposable into null edges. -/
theorem sigmamap_null_edge_verdict (E kz : ℚ) :
    P E kz = (E + kz) • edge e0 + (E - kz) • edge e1
      ∧ (edge e0).det = 0 ∧ (edge e1).det = 0
      ∧ (P E kz).det = (E + kz) * (E - kz)
      ∧ (P E kz).det = E ^ 2 - kz ^ 2
      ∧ ((P E kz).det = 0 ↔ E ^ 2 = kz ^ 2)
      ∧ (0 < (P E kz).det ↔ kz ^ 2 < E ^ 2) := by
  refine ⟨P_eq_null_edge_sum E kz, edge_rank_one e0, edge_rank_one e1,
    (det_is_disagreement E kz).1, (det_is_disagreement E kz).2,
    det_zero_iff_massless E kz, det_pos_iff_massive E kz⟩

/-! ## Kernel-checked axiom footprint on every headline -/

/-- info: 'SigmaMapNullEdges.P_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms P_closed

/-- info: 'SigmaMapNullEdges.edge_rank_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edge_rank_one

/-- info: 'SigmaMapNullEdges.P_eq_null_edge_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms P_eq_null_edge_sum

/-- info: 'SigmaMapNullEdges.det_is_disagreement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_is_disagreement

/-- info: 'SigmaMapNullEdges.det_zero_iff_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_zero_iff_massless

/-- info: 'SigmaMapNullEdges.det_pos_iff_massive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_pos_iff_massive

/-- info: 'SigmaMapNullEdges.sigmamap_null_edge_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sigmamap_null_edge_verdict

end SigmaMapNullEdges
