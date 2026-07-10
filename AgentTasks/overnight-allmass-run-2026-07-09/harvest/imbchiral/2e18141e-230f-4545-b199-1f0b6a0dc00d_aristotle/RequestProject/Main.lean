import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 4000000

/-!
# Imbalanced grading ⇒ genuine chiral zero-mode protection

A *balanced* 2D graded toy (`dim H+ = dim H-`) cannot demonstrate chiral zero-mode protection:
the index is `0` and a generic odd (Dirac-mass) perturbation gaps the mode.  The honest replacement
is an **imbalanced** grading, where the index is nonzero and *every* odd operator is forced to have a
zero mode in the larger chirality sector by a pure rank/kernel argument.

We work with the finite rational avatar: grading `Γ = diag(1,1,-1)` on `ℚ³`, with
`H+ = span(e₀,e₁)` (dimension `2`) and `H- = span(e₂)` (dimension `1`), so the index is
`dim H+ - dim H- = tr Γ = +1`.

* An **odd** operator (anticommuting with `Γ`) is block-off-diagonal:
  `D b0 b1 c0 c1 = !![0,0,b0; 0,0,b1; c0,c1,0]`.
* An **even** operator (commuting with `Γ`) is grading-diagonal: `E a b c = diag(a,b,c)`.

The payload `odd_has_zero_mode`: for *every* odd `D`, the `H+ → H-` block is the `1×2` map
`(c0,c1)`, whose kernel is at least `2-1 = 1`-dimensional; the explicit `H+` vector `![c1,-c0,0]`
(or `e₀` when `(c0,c1)=0`) is a nonzero zero mode.  So the mode survives every odd perturbation —
genuine index/SSH-BdG chiral protection.  The honest contrast `even_can_gap`: a grading-breaking
even term can lift the mode.
-/

namespace ImbalancedChiralProtection

/-- The `ℤ₂` grading `Γ = diag(1,1,-1)` on `ℚ³`. `H+ = span(e₀,e₁)`, `H- = span(e₂)`. -/
def Gamma : Matrix (Fin 3) (Fin 3) ℚ := !![1,0,0; 0,1,0; 0,0,-1]

/-- A generic **odd** operator (block-off-diagonal): the `H- → H+` column `(b0,b1)` and the
`H+ → H-` row `(c0,c1)`. -/
def D (b0 b1 c0 c1 : ℚ) : Matrix (Fin 3) (Fin 3) ℚ := !![0,0,b0; 0,0,b1; c0,c1,0]

/-- A generic **even** operator (grading-diagonal) `E a b c = diag(a,b,c)`. -/
def E (a b c : ℚ) : Matrix (Fin 3) (Fin 3) ℚ := !![a,0,0; 0,b,0; 0,0,c]

/-! ## 1. Parity of the operators -/

/-- **Odd:** every `D b0 b1 c0 c1` anticommutes with `Γ`. -/
theorem D_is_odd (b0 b1 c0 c1 : ℚ) :
    Gamma * (D b0 b1 c0 c1) = - (D b0 b1 c0 c1) * Gamma := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Gamma, D, Matrix.mul_apply, Fin.sum_univ_three]

/-- **Even:** every `E a b c = diag(a,b,c)` commutes with `Γ`. -/
theorem E_is_even (a b c : ℚ) :
    Gamma * (E a b c) = (E a b c) * Gamma := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Gamma, E, Matrix.mul_apply, Fin.sum_univ_three]

/-! ## 2. The grading is imbalanced: index `= +1` -/

/-- The index equals the trace of the grading: `tr Γ = 1 = dim H+ - dim H-`.  This is the
imbalance (`2 - 1 = 1 ≠ 0`) that a balanced toy cannot have. -/
theorem index_is_one : Matrix.trace Gamma = 1 := by
  simp [Gamma, Matrix.trace, Matrix.diag, Fin.sum_univ_three]

/-! ## 3. Payload — every odd operator has a zero mode in `H+` -/

set_option linter.unnecessarySeqFocus false in
/-- **Key `1×2`-kernel computation:** for all coefficients, the explicit `H+` vector `![c1,-c0,0]`
is annihilated by `D` (its `H-` output is `c0·c1 - c1·c0 = 0`). -/
theorem D_mulVec_kernel (b0 b1 c0 c1 : ℚ) :
    (D b0 b1 c0 c1).mulVec ![c1, -c0, 0] = 0 := by
  funext i; fin_cases i <;>
    simp [D, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> ring

/-- **The correct chiral protection.**  For *every* odd operator `D b0 b1 c0 c1` there is a nonzero
`v ∈ H+` (i.e. `v 2 = 0`) with `D v = 0`.  The `H+ → H-` block `(c0,c1)` is a `1×2` map, so its
kernel is `≥ 2-1 = 1`-dimensional: use `![c1,-c0,0]` when `(c0,c1) ≠ 0`, else `e₀`.  Hence the zero
mode survives every odd perturbation — not a cherry-picked example. -/
theorem odd_has_zero_mode (b0 b1 c0 c1 : ℚ) :
    ∃ v : Fin 3 → ℚ, v ≠ 0 ∧ v 2 = 0 ∧ (D b0 b1 c0 c1).mulVec v = 0 := by
  by_cases h : c0 = 0 ∧ c1 = 0
  · -- degenerate column: e₀ itself is a zero mode
    refine ⟨![1, 0, 0], ?_, ?_, ?_⟩
    · intro hv; have := congrFun hv 0; simp at this
    · rfl
    · funext i; fin_cases i <;>
        simp [D, Matrix.mulVec, dotProduct, Fin.sum_univ_three, h.1, h.2]
  · -- generic column: the 1×2 kernel vector
    refine ⟨![c1, -c0, 0], ?_, rfl, D_mulVec_kernel b0 b1 c0 c1⟩
    intro hv
    have e0 := congrFun hv 0
    have e1 := congrFun hv 1
    simp at e0 e1
    exact h ⟨by linarith, e0⟩

/-- **Explicit non-degenerate witness.**  For the odd operator with `b = c = (1,1)`, the vector
`![1,-1,0] ∈ H+` is a genuine nonzero zero mode. -/
theorem odd_zero_mode_witness :
    (![(1:ℚ), -1, 0] : Fin 3 → ℚ) ≠ 0 ∧ (![(1:ℚ), -1, 0] : Fin 3 → ℚ) 2 = 0 ∧
      (D 1 1 1 1).mulVec ![1, -1, 0] = 0 := by
  refine ⟨?_, rfl, ?_⟩
  · intro hv; have := congrFun hv 0; simp at this
  · funext i; fin_cases i <;>
      simp [D, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-! ## 4. Honest contrast — an even (grading-breaking) term can gap the mode -/

/-- **The even perturbation can gap the mode.**  Take the odd base `D 0 0 0 1` and the even
`E 1 0 0 = diag(1,0,0)`.  On `H+` the sum acts as `(x,y,0) ↦ (x, 0, y)`, i.e. by the invertible
block `diag(1,1)` (`det = 1 ≠ 0`); hence it has *no* nonzero zero mode in `H+`. -/
theorem even_can_gap :
    Gamma * (E 1 0 0) = (E 1 0 0) * Gamma ∧
      ∀ v : Fin 3 → ℚ, v 2 = 0 → (D 0 0 0 1 + E 1 0 0).mulVec v = 0 → v = 0 := by
  refine ⟨E_is_even 1 0 0, ?_⟩
  intro v h2 hz
  have h0 := congrFun hz 0
  have h1 := congrFun hz 2
  simp [D, E, Matrix.mulVec, dotProduct, Fin.sum_univ_three] at h0 h1
  funext i; fin_cases i <;> simp_all

/-! ## 5. Verdict -/

/-- **Chiral protection verdict.**  For the imbalanced grading `Γ = diag(1,1,-1)` with index
`tr Γ = 1`:

* `index_is_one`: the grading is imbalanced (`2 - 1 = 1 ≠ 0`);
* **every** odd perturbation preserves a zero mode in `H+` (the `1×2`-kernel rank argument) — the
  genuine index/SSH-BdG chiral protection the balanced 2D toy could **not** exhibit;
* an even (grading-breaking) term can gap it.

Honest scope: a finite rational avatar; the robustness is the rank argument for imbalanced gradings
(the real content), not a cherry-picked example. -/
theorem chiral_protection_verdict :
    Matrix.trace Gamma = 1 ∧
    (∀ b0 b1 c0 c1 : ℚ,
      ∃ v : Fin 3 → ℚ, v ≠ 0 ∧ v 2 = 0 ∧ (D b0 b1 c0 c1).mulVec v = 0) ∧
    (Gamma * (E 1 0 0) = (E 1 0 0) * Gamma ∧
      ∀ v : Fin 3 → ℚ, v 2 = 0 → (D 0 0 0 1 + E 1 0 0).mulVec v = 0 → v = 0) :=
  ⟨index_is_one, odd_has_zero_mode, even_can_gap⟩

/-! ## Axiom audit (kernel-checked footprint) -/

/-- info: 'ImbalancedChiralProtection.D_is_odd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms D_is_odd

/-- info: 'ImbalancedChiralProtection.E_is_even' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms E_is_even

/-- info: 'ImbalancedChiralProtection.index_is_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms index_is_one

/-- info: 'ImbalancedChiralProtection.odd_has_zero_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms odd_has_zero_mode

/-- info: 'ImbalancedChiralProtection.odd_zero_mode_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms odd_zero_mode_witness

/-- info: 'ImbalancedChiralProtection.even_can_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms even_can_gap

/-- info: 'ImbalancedChiralProtection.chiral_protection_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiral_protection_verdict

end ImbalancedChiralProtection
