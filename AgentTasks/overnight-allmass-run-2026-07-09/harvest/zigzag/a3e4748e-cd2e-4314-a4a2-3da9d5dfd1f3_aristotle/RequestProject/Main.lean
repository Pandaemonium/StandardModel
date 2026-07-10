import Mathlib

open scoped BigOperators
open scoped Classical
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The chirality zigzag as a finite weighted automaton

Port (reference / provenance, **not** an import; version-pinned) of the finite
weighted-automaton / transfer-operator view of the Penrose zigzag of a massive
fermion, as in the CSLib automata / path-semantics program.

At the classical-stochastic level the zigzag is a **2-state automaton** on the
chirality label `{L, R}`.  The mass is realized as the chirality-**flip**
transition; the massless case is the absorbing/reducible one where `L` and `R`
never mix (two independent luminal channels).

We prove the finite, **rational** transfer-matrix version:

* `mass = spectral gap of the transfer operator = flip rate`, and
* `massless  ↔  zero gap  ↔  reducible`.

Everything is over `ℚ`; no `Real`, no `Complex`, no transcendental functions.

Provenance: CSLib path semantics / weighted automata (reference, version-pinned;
not imported here).
-/

namespace ZigzagAutomaton

/-- Chirality transfer operator on states `{0 = L, 1 = R}`.
`a : ℚ` is the flip parameter (the mass proxy: the per-step chirality-flip
weight, intended for `0 ≤ a ≤ 1`). -/
def T (a : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![1 - a, a; a, 1 - a]

/-- The uniform / stationary chirality mode. -/
def modeSym : Fin 2 → ℚ := ![1, 1]

/-- The chirality-antisymmetric mode. -/
def modeAsym : Fin 2 → ℚ := ![1, -1]

/-- The spectral gap of the transfer operator `T a`: the difference between the
top eigenvalue `1` and the sub-eigenvalue `1 - 2a`. -/
def spectralGap (a : ℚ) : ℚ := 1 - (1 - 2 * a)

/-! ## 1.  `T a` is doubly stochastic and symmetric -/

/-- Every row of `T a` sums to `1`. -/
theorem T_row_sum (a : ℚ) (i : Fin 2) : ∑ j, T a i j = 1 := by
  fin_cases i <;> simp [T, Fin.sum_univ_two]

/-- Every column of `T a` sums to `1`. -/
theorem T_col_sum (a : ℚ) (j : Fin 2) : ∑ i, T a i j = 1 := by
  fin_cases j <;> simp [T, Fin.sum_univ_two]

/-- `T a` is symmetric. -/
theorem T_symm (a : ℚ) : (T a)ᵀ = T a := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [T]

/-- `T` is doubly stochastic (rows and columns sum to `1`) and symmetric. -/
theorem transfer_stochastic (a : ℚ) :
    (∀ i, ∑ j, T a i j = 1) ∧ (∀ j, ∑ i, T a i j = 1) ∧ (T a)ᵀ = T a :=
  ⟨T_row_sum a, T_col_sum a, T_symm a⟩

/-- info: 'ZigzagAutomaton.transfer_stochastic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms transfer_stochastic

/-- At `a = 0` the transfer operator is the identity (no flipping). -/
theorem T_zero : T 0 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [T]

/-- At `a = 1/2` the transfer operator is the uniform-mixing matrix. -/
theorem T_half : T (1 / 2) = !![1 / 2, 1 / 2; 1 / 2, 1 / 2] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [T] <;> norm_num

/-! ## 2.  Spectral gap: eigenvalues `1` and `1 - 2a` -/

/-- The uniform mode `![1,1]` is a fixed point: eigenvalue `1`. -/
theorem eig_sym (a : ℚ) : Matrix.mulVec (T a) modeSym = modeSym := by
  funext i; fin_cases i <;>
    simp [T, modeSym, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- The antisymmetric mode `![1,-1]` is an eigenvector with eigenvalue `1 - 2a`. -/
theorem eig_asym (a : ℚ) :
    Matrix.mulVec (T a) modeAsym = (1 - 2 * a) • modeAsym := by
  funext i; fin_cases i <;>
    simp [T, modeAsym, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> ring

/-- **Spectral gap payload.**  The two eigen-relations hold, and the resulting
spectral gap `1 - (1 - 2a)` equals `2a`, the mass proxy. -/
theorem spectral_gap (a : ℚ) :
    Matrix.mulVec (T a) modeSym = (1 : ℚ) • modeSym ∧
    Matrix.mulVec (T a) modeAsym = (1 - 2 * a) • modeAsym ∧
    spectralGap a = 2 * a := by
  refine ⟨?_, eig_asym a, ?_⟩
  · rw [one_smul]; exact eig_sym a
  · simp only [spectralGap]; ring

/-- info: 'ZigzagAutomaton.spectral_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms spectral_gap

/-! ## 3.  Massless ↔ reducible -/

/-- Pure-`L` state `![1,0]` is fixed by the massless transfer operator. -/
theorem T_zero_fix_L : Matrix.mulVec (T 0) ![1, 0] = ![1, 0] := by
  funext i; fin_cases i <;>
    simp [T, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- Pure-`R` state `![0,1]` is fixed by the massless transfer operator. -/
theorem T_zero_fix_R : Matrix.mulVec (T 0) ![0, 1] = ![0, 1] := by
  funext i; fin_cases i <;>
    simp [T, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- For `a ≠ 0` the pure-`L` state is **not** fixed: the zigzag mixes chirality. -/
theorem T_pos_not_fix_L (a : ℚ) (ha : a ≠ 0) :
    Matrix.mulVec (T a) ![1, 0] ≠ ![1, 0] := by
  intro h
  have := congrFun h 1
  simp [T, Matrix.mulVec, dotProduct, Fin.sum_univ_two] at this
  exact ha this

/-- **Massless ↔ reducible payload.**

`a = 0` is equivalent to `T a` being the identity, which is exactly the
absorbing/reducible automaton in which each pure-chirality state is a fixed
point (two independent luminal channels).  Moreover the spectral gap is then
`0`; and for `a ≠ 0` the pure-`L` state is not fixed (irreducible mixing). -/
theorem massless_iff_reducible (a : ℚ) :
    (a = 0 ↔ T a = 1) ∧
    (a = 0 → (Matrix.mulVec (T a) ![1, 0] = ![1, 0] ∧
             Matrix.mulVec (T a) ![0, 1] = ![0, 1] ∧
             spectralGap a = 0)) ∧
    (a ≠ 0 → Matrix.mulVec (T a) ![1, 0] ≠ ![1, 0]) := by
  refine ⟨⟨?_, ?_⟩, ?_, T_pos_not_fix_L a⟩
  · rintro rfl; exact T_zero
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [T] at this
    linarith
  · rintro rfl
    exact ⟨T_zero_fix_L, T_zero_fix_R, by norm_num [spectralGap]⟩

/-- info: 'ZigzagAutomaton.massless_iff_reducible' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_iff_reducible

/-! ## 4.  Non-degeneracy: explicit rational values -/

/-- `a = 0` (massless): `T = I`, gap `0`, both pure states fixed. -/
theorem check_massless :
    T 0 = 1 ∧ spectralGap 0 = 0 ∧
    Matrix.mulVec (T 0) ![1, 0] = ![1, 0] ∧
    Matrix.mulVec (T 0) ![0, 1] = ![0, 1] :=
  ⟨T_zero, by norm_num [spectralGap], T_zero_fix_L, T_zero_fix_R⟩

/-- `a = 1/2` (uniform mixing): gap `1`. -/
theorem check_half :
    T (1 / 2) = !![1 / 2, 1 / 2; 1 / 2, 1 / 2] ∧ spectralGap (1 / 2) = 1 :=
  ⟨T_half, by norm_num [spectralGap]⟩

/-- `a = 1/4`: gap `1/2`, and the pure-`L` state is **not** fixed. -/
theorem check_quarter :
    spectralGap (1 / 4) = 1 / 2 ∧
    Matrix.mulVec (T (1 / 4)) ![1, 0] ≠ ![1, 0] := by
  refine ⟨by norm_num [spectralGap], ?_⟩
  exact T_pos_not_fix_L (1 / 4) (by norm_num)

/-! ## 5.  Verdict -/

/-- **The zigzag-automaton verdict.**

The massive fermion's chirality dynamics is a finite weighted automaton whose
transfer operator `T a` is doubly stochastic and symmetric, has eigenvalues `1`
(uniform mode) and `1 - 2a` (chirality-antisymmetric mode), hence spectral gap
`spectralGap a = 2a` — the mass proxy.  Massless (`a = 0`) is the reducible
fixed-point case (`T = I`, gap `0`, two luminal channels that never talk);
massive (`a ≠ 0`) is the mixing case (pure-chirality states are not fixed).

Honest scope: this is a finite classical-stochastic avatar of the chirality
zigzag, complementary to the unitary quantum-walk transfer operator elsewhere.
It is **not** a claim about the physical flip rate's numerical value.
Provenance: CSLib path semantics / weighted automata (reference, version-pinned;
not imported). -/
theorem zigzag_automaton_verdict (a : ℚ) :
    -- doubly stochastic + symmetric
    ((∀ i, ∑ j, T a i j = 1) ∧ (∀ j, ∑ i, T a i j = 1) ∧ (T a)ᵀ = T a) ∧
    -- eigen-decomposition and spectral gap = mass proxy
    (Matrix.mulVec (T a) modeSym = (1 : ℚ) • modeSym ∧
     Matrix.mulVec (T a) modeAsym = (1 - 2 * a) • modeAsym ∧
     spectralGap a = 2 * a) ∧
    -- massless ↔ reducible ; massive ↔ mixing
    ((a = 0 ↔ T a = 1) ∧
     (a = 0 → spectralGap a = 0) ∧
     (a ≠ 0 → Matrix.mulVec (T a) ![1, 0] ≠ ![1, 0])) :=
  ⟨transfer_stochastic a, spectral_gap a,
    (massless_iff_reducible a).1,
    fun h => by rw [h]; norm_num [spectralGap],
    (massless_iff_reducible a).2.2⟩

/-- info: 'ZigzagAutomaton.zigzag_automaton_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms zigzag_automaton_verdict

end ZigzagAutomaton
