import Mathlib

open scoped BigOperators
open scoped Classical
open Matrix

set_option maxHeartbeats 800000

/-!
# The chirality zigzag as a finite weighted automaton

The Penrose zigzag of a massive fermion, at the classical-stochastic level, is a
two-state automaton on the chirality label `{L, R}`.  Mass is the chirality-FLIP
transition; the massless case is the absorbing/reducible one where `L` and `R`
never mix (two independent luminal channels).

We prove the finite, rational transfer-matrix version:

* `T a = !![1 - a, a; a, 1 - a]` is doubly stochastic and symmetric;
* its eigenvalues are `1` (uniform mode `![1,1]`) and `1 - 2a`
  (antisymmetric mode `![1,-1]`), so the **spectral gap is `2a`** (the mass proxy);
* `a = 0` is the reducible fixed-point case, `a ≠ 0` is the mixing case.

Provenance: the finite weighted-automaton / transfer-operator view of the CSLib
path-semantics / weighted-automata program (reference only, not an import).
-/

namespace ZigzagAutomaton

/-- The `2 × 2` rational transfer / transition operator of the chirality zigzag.
`a : ℚ` is the flip parameter (mass proxy), with `0 ≤ a ≤ 1`. -/
def T (a : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![1 - a, a; a, 1 - a]

/-! ## 1. Stochasticity and symmetry -/

/-- `T a` is doubly stochastic (each row and each column sums to `1`) and
symmetric, for every `a`; moreover `T 0 = 1` (identity) and `T (1/2)` is the
uniform-mixing matrix. -/
theorem transfer_stochastic :
    (∀ (a : ℚ) (i : Fin 2), ∑ j, T a i j = 1) ∧
    (∀ (a : ℚ) (j : Fin 2), ∑ i, T a i j = 1) ∧
    (∀ (a : ℚ), (T a)ᵀ = T a) ∧
    T 0 = 1 ∧
    T (1 / 2) = !![1 / 2, 1 / 2; 1 / 2, 1 / 2] := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro a i; fin_cases i <;> simp [T, Fin.sum_univ_two]
  · intro a j; fin_cases j <;> simp [T, Fin.sum_univ_two]
  · intro a; ext i j; fin_cases i <;> fin_cases j <;> simp [T]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [T]
  · ext i j; fin_cases i <;> fin_cases j <;> norm_num [T]

/-- info: 'ZigzagAutomaton.transfer_stochastic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms transfer_stochastic

/-! ## 2. Spectral gap -/

/-- The eigenvalues of `T a` are `1` (eigenvector `![1,1]`, the stationary/uniform
mode) and `1 - 2a` (eigenvector `![1,-1]`, the chirality-antisymmetric mode).
Hence the spectral gap is `1 - (1 - 2a) = 2a`, the mass proxy. -/
theorem spectral_gap :
    (∀ (a : ℚ), T a *ᵥ ![1, 1] = ![1, 1]) ∧
    (∀ (a : ℚ), T a *ᵥ ![1, -1] = (1 - 2 * a) • ![1, -1]) ∧
    (∀ (a : ℚ), (1 : ℚ) - (1 - 2 * a) = 2 * a) := by
  refine ⟨?_, ?_, ?_⟩
  · intro a; funext i; fin_cases i <;>
      simp [T, mulVec, dotProduct, Fin.sum_univ_two]
  · intro a; funext i; fin_cases i <;>
      simp [T, mulVec, dotProduct, Fin.sum_univ_two] <;> ring
  · intro a; ring

/-- info: 'ZigzagAutomaton.spectral_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms spectral_gap

/-! ## 3. Massless ⇔ reducible -/

/-- Massless ⇔ reducible: `a = 0 ↔ T a = 1`, and when `a = 0` each pure-chirality
state is a fixed point (absorbing/reducible: two independent luminal channels),
while for `a ≠ 0` a pure-chirality state is *not* fixed (the zigzag mixes). -/
theorem massless_iff_reducible :
    (∀ (a : ℚ), a = 0 ↔ T a = 1) ∧
    (T 0 *ᵥ ![1, 0] = ![1, 0] ∧ T 0 *ᵥ ![0, 1] = ![0, 1]) ∧
    (∀ (a : ℚ), a ≠ 0 → T a *ᵥ ![1, 0] ≠ ![1, 0]) := by
  refine ⟨?_, ⟨?_, ?_⟩, ?_⟩
  · intro a
    constructor
    · rintro rfl; ext i j; fin_cases i <;> fin_cases j <;> simp [T]
    · intro h
      have := congrArg (fun M => M 0 1) h
      simpa [T, Matrix.one_apply] using this
  · funext i; fin_cases i <;>
      simp [T, mulVec, dotProduct, Fin.sum_univ_two]
  · funext i; fin_cases i <;>
      simp [T, mulVec, dotProduct, Fin.sum_univ_two]
  · intro a ha hcontra
    have := congrArg (fun v => v 0) hcontra
    simp [T, mulVec, dotProduct, Fin.sum_univ_two] at this
    exact ha this

/-- info: 'ZigzagAutomaton.massless_iff_reducible' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_iff_reducible

/-! ## Non-degeneracy: explicit rational values -/

/-- Explicit rational sanity checks: `a = 0` (massless, `T = I`, gap `0`, both
pure states fixed), `a = 1/2` (uniform mixing, gap `1`, antisymmetric eigenvalue
`0`), `a = 1/4` (gap `1/2`, pure state NOT fixed). -/
theorem zigzag_explicit :
    (T 0 = 1 ∧ (2 : ℚ) * 0 = 0 ∧
      T 0 *ᵥ ![1, 0] = ![1, 0] ∧ T 0 *ᵥ ![0, 1] = ![0, 1]) ∧
    (T (1 / 2) = !![1 / 2, 1 / 2; 1 / 2, 1 / 2] ∧ (2 : ℚ) * (1 / 2) = 1 ∧
      T (1 / 2) *ᵥ ![1, -1] = (0 : ℚ) • ![1, -1]) ∧
    ((2 : ℚ) * (1 / 4) = 1 / 2 ∧ T (1 / 4) *ᵥ ![1, 0] ≠ ![1, 0]) := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ⟨?_, ?_, ?_⟩, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp [T]
  · norm_num
  · funext i; fin_cases i <;> simp [T, mulVec, dotProduct, Fin.sum_univ_two]
  · funext i; fin_cases i <;> simp [T, mulVec, dotProduct, Fin.sum_univ_two]
  · ext i j; fin_cases i <;> fin_cases j <;> norm_num [T]
  · norm_num
  · funext i; fin_cases i <;>
      simp [T, mulVec, dotProduct, Fin.sum_univ_two] <;> norm_num
  · norm_num
  · intro hcontra
    have := congrArg (fun v => v 0) hcontra
    simp [T, mulVec, dotProduct, Fin.sum_univ_two] at this

/-- info: 'ZigzagAutomaton.zigzag_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms zigzag_explicit

/-! ## 4. The verdict -/

/-- Packaged verdict: the massive fermion's chirality dynamics is a finite
weighted automaton whose transfer operator `T a` is doubly stochastic and
symmetric, has eigenvalues `1` and `1 - 2a` (spectral gap `2a`, the mass proxy),
and whose `a = 0` case is the reducible fixed-point automaton (two luminal
channels that never mix) while `a ≠ 0` is the mixing zigzag.

Honest scope: a finite classical-stochastic avatar of the chirality zigzag
(complementary to the unitary quantum-walk transfer operator elsewhere).
Not a claim about the physical flip rate's value. -/
theorem zigzag_automaton_verdict :
    ((∀ (a : ℚ) (i : Fin 2), ∑ j, T a i j = 1) ∧
      (∀ (a : ℚ) (j : Fin 2), ∑ i, T a i j = 1) ∧
      (∀ (a : ℚ), (T a)ᵀ = T a)) ∧
    ((∀ (a : ℚ), T a *ᵥ ![1, 1] = ![1, 1]) ∧
      (∀ (a : ℚ), T a *ᵥ ![1, -1] = (1 - 2 * a) • ![1, -1]) ∧
      (∀ (a : ℚ), (1 : ℚ) - (1 - 2 * a) = 2 * a)) ∧
    ((∀ (a : ℚ), a = 0 ↔ T a = 1) ∧
      (T 0 *ᵥ ![1, 0] = ![1, 0] ∧ T 0 *ᵥ ![0, 1] = ![0, 1]) ∧
      (∀ (a : ℚ), a ≠ 0 → T a *ᵥ ![1, 0] ≠ ![1, 0])) :=
  ⟨⟨transfer_stochastic.1, transfer_stochastic.2.1, transfer_stochastic.2.2.1⟩,
    spectral_gap, massless_iff_reducible⟩

/-- info: 'ZigzagAutomaton.zigzag_automaton_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms zigzag_automaton_verdict

end ZigzagAutomaton
