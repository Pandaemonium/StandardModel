import Mathlib

/-!
# mass² = 2E² · (linear entropy of the ±c velocity mixture)

This module adds the *information-theoretic* entry of the "mass-drift dictionary" for a
massive Dirac fermion's internal motion, using a **rational** entropy: the **linear entropy**
(a.k.a. impurity) `S_L = 1 - Tr ρ²`.

## Physical setup

A massive Dirac fermion's instantaneous velocity operator has spectrum exactly `{+1, -1}`
(`= ±c`, the luminal "zigzag"). For a stationary mode the observable mean velocity is
`vbar = p/E` with `vbar² = 1 - m²/E² = (p/E)²`, on shell `m² = E² - p²`.

We model the `±c` motion as a 2-outcome classical distribution over the velocity
eigenvalues `{+1, -1}` with the correct mean `vbar = p/E`:

* `pplus  = (E + p)/(2E)`
* `pminus = (E - p)/(2E)`

Its **linear entropy** is
`S_L = 1 - (pplus² + pminus²) = 2·pplus·pminus = (E² - p²)/(2E²) = m²/(2E²)`,
so `m² = 2E²·S_L`: mass squared is exactly `2E²` times the linear entropy of the luminal
velocity mixture. Massless (`p = ±E`) ⇒ `S_L = 0` (a PURE single luminal channel, zero
impurity); rest (`p = 0`, `m = E`) ⇒ `S_L = 1/2` (MAXIMAL impurity for a 2-outcome mixture,
the 50/50 zigzag).

## HONEST framing

This is the **linear entropy** (a rational `1 - Tr ρ²` proxy), **NOT** the Shannon entropy.
The result is a **corollary-level restatement** of the drift relation `vbar² = 1 - m²/E²` in
information-theoretic language: `S_L = (1 - vbar²)/2`. The value here is the interpretation /
connection (mass² = velocity-mixture impurity), not proof depth. This is not Shannon entropy
and claims no more than a rational-entropy proxy. The linear entropy / purity `1 - Tr ρ²`
notion is standard quantum information (clean-room here, not imported).

Everything is purely rational (`Q = ℚ`), proved by `field_simp`/`ring`/`norm_num`, carrying
`E ≠ 0`; no `Real.log`/`sqrt`/`cos`/`sin`, no `Complex`, no `nlinarith`.
-/

namespace VelocityMixtureLinearEntropy

/-- The rational scalar type. -/
abbrev Q := ℚ

/-- Probability of the `+1` (`+c`) velocity eigenvalue. -/
def pplus (E p : Q) : Q := (E + p) / (2 * E)

/-- Probability of the `-1` (`-c`) velocity eigenvalue. -/
def pminus (E p : Q) : Q := (E - p) / (2 * E)

/-- Linear entropy (impurity) `S_L = 1 - (pplus² + pminus²)` of the `±c` mixture. -/
def SL (E p : Q) : Q := 1 - (pplus E p ^ 2 + pminus E p ^ 2)

/-- On-shell mass squared `m² = E² - p²`. -/
def msq (E p : Q) : Q := E ^ 2 - p ^ 2

/-- The two velocity outcomes form a normalized distribution: `pplus + pminus = 1`. -/
theorem dist_normalized (E p : Q) (hE : E ≠ 0) :
    pplus E p + pminus E p = 1 := by
  unfold pplus pminus
  field_simp
  ring

/-- The distribution is nonnegative for `0 < E` and `|p| ≤ E`. -/
theorem dist_nonneg (E p : Q) (hE : 0 < E) (hlo : -E ≤ p) (hhi : p ≤ E) :
    0 ≤ pplus E p ∧ 0 ≤ pminus E p := by
  refine ⟨?_, ?_⟩
  · unfold pplus
    apply div_nonneg
    · linarith
    · linarith
  · unfold pminus
    apply div_nonneg
    · linarith
    · linarith

/-- The mean of the `±c` velocity eigenvalues is the drift `vbar = p/E`. -/
theorem mean_is_drift (E p : Q) (hE : E ≠ 0) :
    pplus E p * 1 + pminus E p * (-1) = p / E := by
  unfold pplus pminus
  field_simp
  ring

/-- **PAYLOAD.** Closed form of the linear entropy: `S_L = (E² - p²)/(2E²)`. -/
theorem linear_entropy_closed (E p : Q) (hE : E ≠ 0) :
    SL E p = (E ^ 2 - p ^ 2) / (2 * E ^ 2) := by
  unfold SL pplus pminus
  field_simp
  ring

/-- **PAYLOAD.** `m² = 2E²·S_L`: mass squared is `2E²` times the linear entropy. -/
theorem mass_sq_eq_two_Esq_SL (E p : Q) (hE : E ≠ 0) :
    msq E p = 2 * E ^ 2 * SL E p := by
  unfold msq
  rw [linear_entropy_closed E p hE]
  field_simp

/-- At masslessness `p = ±E` the mixture is PURE: `S_L = 0` (and `m² = 0`). -/
theorem massless_pure (E : Q) (hE : E ≠ 0) :
    SL E E = 0 ∧ SL E (-E) = 0 ∧ msq E E = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · unfold SL pplus pminus
    field_simp
    ring
  · unfold SL pplus pminus
    field_simp
    ring
  · unfold msq
    ring

/-- At rest `p = 0` the mixture is MAXIMALLY impure: `S_L = 1/2` (and `m² = E²`). -/
theorem rest_maximal (E : Q) (hE : E ≠ 0) :
    SL E 0 = 1 / 2 ∧ msq E 0 = E ^ 2 := by
  refine ⟨?_, ?_⟩
  · unfold SL pplus pminus
    field_simp
    ring
  · unfold msq
    ring

/-- **VERDICT.** The full linear-entropy face of the mass-drift dictionary:
`pplus, pminus` are a valid 2-outcome distribution (normalized, nonnegative for `|p| ≤ E`)
with mean `p/E`; its linear entropy is `S_L = (E²-p²)/(2E²) = m²/(2E²)`, so `m² = 2E²·S_L`;
`S_L = 0` exactly at masslessness (`p = ±E`, pure single channel) and `S_L = 1/2` at rest
(`p = 0`, maximal mixing). -/
theorem velocity_linear_entropy_verdict (E p : Q) (hE : 0 < E)
    (hlo : -E ≤ p) (hhi : p ≤ E) :
    -- valid distribution
    (pplus E p + pminus E p = 1) ∧
    (0 ≤ pplus E p ∧ 0 ≤ pminus E p) ∧
    -- correct mean
    (pplus E p * 1 + pminus E p * (-1) = p / E) ∧
    -- linear entropy closed form and mass relation
    (SL E p = (E ^ 2 - p ^ 2) / (2 * E ^ 2)) ∧
    (msq E p = 2 * E ^ 2 * SL E p) ∧
    -- pure at masslessness, maximal at rest
    (SL E E = 0 ∧ SL E (-E) = 0) ∧
    (SL E 0 = 1 / 2) := by
  have hE' : E ≠ 0 := ne_of_gt hE
  refine ⟨dist_normalized E p hE', dist_nonneg E p hE hlo hhi,
    mean_is_drift E p hE', linear_entropy_closed E p hE',
    mass_sq_eq_two_Esq_SL E p hE', ?_, ?_⟩
  · exact ⟨(massless_pure E hE').1, (massless_pure E hE').2.1⟩
  · exact (rest_maximal E hE').1

/-! ## Mandatory non-degeneracy witnesses (explicit, by `norm_num`) -/

/-- Massive witness `E = 5, p = 3`: `msq = 16`, `pplus = 4/5`, `pminus = 1/5`,
`SL = 8/25`, and `16 = 2·25·(8/25)`. -/
theorem witness_massive :
    pplus 5 3 = 4 / 5 ∧ pminus 5 3 = 1 / 5 ∧ SL 5 3 = 8 / 25 ∧
    msq 5 3 = 16 ∧ (16 : Q) = 2 * 5 ^ 2 * (8 / 25) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · unfold pplus; norm_num
  · unfold pminus; norm_num
  · unfold SL pplus pminus; norm_num
  · unfold msq; norm_num
  · norm_num

/-- Rest witness `E = 5, p = 0`: `SL = 1/2`, `msq = 25`. -/
theorem witness_rest :
    SL 5 0 = 1 / 2 ∧ msq 5 0 = 25 := by
  refine ⟨?_, ?_⟩
  · unfold SL pplus pminus; norm_num
  · unfold msq; norm_num

/-- Massless witness `E = 5, p = 5`: `SL = 0`, `msq = 0`. -/
theorem witness_massless :
    SL 5 5 = 0 ∧ msq 5 5 = 0 := by
  refine ⟨?_, ?_⟩
  · unfold SL pplus pminus; norm_num
  · unfold msq; norm_num

/-- Genuine intermediate impurity: `SL 5 3 ≠ 0` and `SL 5 3 ≠ 1/2`. -/
theorem witness_intermediate :
    SL 5 3 ≠ 0 ∧ SL 5 3 ≠ 1 / 2 := by
  refine ⟨?_, ?_⟩
  · unfold SL pplus pminus; norm_num
  · unfold SL pplus pminus; norm_num

/-! ## Axiom footprint checks (exactly `[propext, Classical.choice, Quot.sound]`) -/

/-- info: 'VelocityMixtureLinearEntropy.dist_normalized' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dist_normalized
/-- info: 'VelocityMixtureLinearEntropy.dist_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dist_nonneg
/-- info: 'VelocityMixtureLinearEntropy.mean_is_drift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mean_is_drift
/-- info: 'VelocityMixtureLinearEntropy.linear_entropy_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms linear_entropy_closed
/-- info: 'VelocityMixtureLinearEntropy.mass_sq_eq_two_Esq_SL' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mass_sq_eq_two_Esq_SL
/-- info: 'VelocityMixtureLinearEntropy.massless_pure' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_pure
/-- info: 'VelocityMixtureLinearEntropy.rest_maximal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms rest_maximal
/-- info: 'VelocityMixtureLinearEntropy.velocity_linear_entropy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms velocity_linear_entropy_verdict
/-- info: 'VelocityMixtureLinearEntropy.witness_massive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_massive
/-- info: 'VelocityMixtureLinearEntropy.witness_rest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_rest
/-- info: 'VelocityMixtureLinearEntropy.witness_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_massless
/-- info: 'VelocityMixtureLinearEntropy.witness_intermediate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_intermediate

end VelocityMixtureLinearEntropy
