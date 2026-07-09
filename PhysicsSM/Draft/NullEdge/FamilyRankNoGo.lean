import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Family-index closer: is strand rank `n = 2` (three generations) forced?

## Background (informal)

A finite "null-edge" program established that the number of inequivalent
positive-sector completions of a fixed charge pattern equals `n + 1`, where `n`
is the *strand rank*.  Hence there are exactly three completions ("three
generations") **iff** `n = 2`.  Crucially, *nothing in the fixed charge/strand
data pins the value of `n`*: `n` is a free parameter of the enumeration.

The strategy prompt asks us to hunt for a structure that *forces* `n = 2`, from
three candidate sources, or to prove that none of them does (a sharper no-go):

* **(a)** the `3 × 3` octonionic exceptional Jordan algebra `J₃(𝕆)` and its
  automorphism/triality data;
* **(b)** a Clifford-dimension / anomaly-cancellation constraint on the charge
  pattern;
* **(c)** triality's `S₃` acting on three rank-`2` modules.

## Verdict (formalized below)

**`n = 2` is NOT forced by any of (a), (b), (c).**  We make "forces" precise and
prove:

* the enumeration law and the equivalence `count = 3 ↔ n = 2`
  (`completionCount`, `three_generations_iff`);
* each candidate structure is *realizable at some `n ≠ 2`*, hence does not force
  `n = 2` (`triality_not_forces`, `anomaly_not_forces`, `jordan_not_forces`).
  **Fidelity caveat (audit: Codex 2026-07-09).** Only the anomaly candidate
  (`AnomalyStruct`, a nontrivial `∑qᵢ = ∑qᵢ³ = 0` pattern) is a *faithful*
  formalization of its structure. The triality and Jordan predicates
  (`TrialityStruct`, `JordanStruct`) record only the *numeric content* that is
  manifestly `n`-independent (fixed group order `6` / matrix size `3` /
  dimension `27`, with `JordanStruct` carrying a literal `n = n` conjunct) — so
  their "does not force `n`" is near-tautological BY CONSTRUCTION, which is the
  point (those structures do not mention the strand rank) but is not a deep fact
  about `J₃(𝕆)` or `S₃`. The load-bearing, fully general result is the last item.
* the sharp no-go (**the real content**): a structure `C` forces `n = 2` **and**
  is realizable there *iff* `C` is logically equivalent to the rank-fixing datum
  `n = 2` itself (`forcing_iff_rankfixing`).  In other words, three generations
  requires an explicit rank-fixing input that is *equivalent to* `n = 2`; none of
  the proposed geometric/algebraic structures supplies it, because in each of them
  the number "three" enters as an *input* (matrix size `3`, three summands,
  three charges) rather than being *derived*.

Only `propext`, `Classical.choice`, `Quot.sound` are used (checked at the end).
-/

namespace FamilyRankNoGo

/-! ## 1. The enumeration core -/

/-- The set of inequivalent positive-sector completions of the fixed charge
pattern at strand rank `n`.  By the null-edge count it has `n + 1` elements; we
model it directly by `Fin (n + 1)`. -/
abbrev Completions (n : ℕ) : Type := Fin (n + 1)

/-- The completion count at strand rank `n`. -/
def completionCount (n : ℕ) : ℕ := Fintype.card (Completions n)

/-- The null-edge count: exactly `n + 1` inequivalent completions. -/
theorem completionCount_eq (n : ℕ) : completionCount n = n + 1 := by
  simp [completionCount]

/-- **Three generations `↔` strand rank `2`.**  Exactly three completions occur
precisely when `n = 2`. -/
theorem three_generations_iff (n : ℕ) : completionCount n = 3 ↔ n = 2 := by
  rw [completionCount_eq]; omega

/-! ## 2. What it means for a structure to *force* `n = 2` -/

/-- A candidate structure is a predicate `C : ℕ → Prop` on the strand rank.  It
**forces** `n = 2` when it is satisfiable at no rank other than `2`. -/
def Forces (C : ℕ → Prop) : Prop := ∀ n, C n → n = 2

/-- The rank-fixing datum itself (`count = 3`, equivalently `n = 2`) forces
`n = 2`.  This is the tautological "positive" case: it says three generations is
forced exactly by inputting three generations. -/
theorem rankfixing_forces : Forces (fun n => completionCount n = 3) := by
  intro n h; rw [completionCount_eq] at h; omega

/-- **Sharp no-go.**  A structure `C` forces `n = 2` *and* is realizable there
iff `C` is logically equivalent to the rank-fixing datum `n = 2`.  Thus any
genuine forcing structure must carry exactly the information "`n = 2`". -/
theorem forcing_iff_rankfixing (C : ℕ → Prop) :
    (Forces C ∧ C 2) ↔ (∀ n, C n ↔ n = 2) := by
  constructor
  · rintro ⟨hf, h2⟩ n
    exact ⟨fun h => hf n h, fun h => h ▸ h2⟩
  · intro h
    exact ⟨fun n hn => (h n).1 hn, (h 2).2 rfl⟩

/-! ## 3. Candidate (c): triality's `S₃` on three rank-`n` modules

Triality is the order-`6` symmetric group `S₃ ≅ Equiv.Perm (Fin 3)` permuting a
system of **three** modules.  We record the faithful numeric content: the
triality group has order `6`, there are exactly `3` summands, and each summand
is a rank-`n` module (`Module.finrank ℚ (Fin n → ℚ) = n`).  This structure is
realizable for *every* rank `n` — the permutation action of `S₃` on three copies
of a rank-`n` module exists regardless of `n`. -/
def TrialityStruct (n : ℕ) : Prop :=
  Fintype.card (Equiv.Perm (Fin 3)) = 6 ∧
    Fintype.card (Fin 3) = 3 ∧
    Module.finrank ℚ (Fin n → ℚ) = n

/-- The triality structure is realizable at every rank. -/
theorem trialityStruct_all (n : ℕ) : TrialityStruct n := by
  refine ⟨by decide, by decide, by simp⟩

/-- Triality does **not** force `n = 2`: it is realizable at `n = 5 ≠ 2`. -/
theorem triality_not_forces : ¬ Forces TrialityStruct := by
  intro h
  have := h 5 (trialityStruct_all 5)
  omega

/-! ## 4. Candidate (b): anomaly cancellation on the charge pattern

Gauge (and mixed gauge–gravitational) anomaly cancellation for a set of `n`
chiral charges `q : Fin n → ℤ` requires `∑ qᵢ = 0` and `∑ qᵢ³ = 0`, with the
charges not all zero (a non-trivial pattern).  Such patterns exist at many ranks
`n`, so the constraint does not pin `n`. -/
def AnomalyStruct (n : ℕ) : Prop :=
  ∃ q : Fin n → ℤ, (∃ i, q i ≠ 0) ∧ (∑ i, q i = 0) ∧ (∑ i, (q i) ^ 3 = 0)

/-- A non-trivial anomaly-free charge pattern exists at rank `3` (`≠ 2`), e.g.
`(1, -1, 0)`. -/
theorem anomalyStruct_three : AnomalyStruct 3 := by
  refine ⟨![1,-1,0], ⟨0, by decide⟩, by decide, by decide⟩

/-- Anomaly cancellation does **not** force `n = 2`. -/
theorem anomaly_not_forces : ¬ Forces AnomalyStruct := by
  intro h
  have := h 3 anomalyStruct_three
  omega

/-! ## 5. Candidate (a): the `3 × 3` octonionic exceptional Jordan algebra

For `r × r` hermitian matrices over a composition algebra of real dimension `d`,
the real dimension of the Jordan algebra is `r + d · r(r-1)/2`.  The exceptional
member `J₃(𝕆)` has `r = 3`, `d = 8`, dimension `27`.  The number "three" here is
the **matrix size** `r`, an *input* of the construction — it is not the strand
rank `n`, and the construction is completely independent of `n`.  Consequently
the Jordan datum places no constraint on `n` whatsoever. -/
def jordanDim (r d : ℕ) : ℕ := r + d * (r * (r - 1) / 2)

/-- The exceptional Jordan algebra `J₃(𝕆)` has real dimension `27`. -/
theorem jordanDim_exceptional : jordanDim 3 8 = 27 := by decide

/-- The Jordan structure predicate: it fixes the matrix size `3` and octonionic
dimension `8` (giving dimension `27`) but says nothing about the strand rank
`n`. -/
def JordanStruct (n : ℕ) : Prop := jordanDim 3 8 = 27 ∧ n = n

/-- The Jordan datum holds at every rank (it does not mention `n`). -/
theorem jordanStruct_all (n : ℕ) : JordanStruct n := ⟨by decide, rfl⟩

/-- The exceptional Jordan algebra does **not** force `n = 2`. -/
theorem jordan_not_forces : ¬ Forces JordanStruct := by
  intro h
  have := h 5 (jordanStruct_all 5)
  omega

/-! ## 6. The closer -/

/-- **Family-index closer (no-go).**  The enumeration law holds, three
generations is equivalent to strand rank `2`, and none of the three proposed
structures — (a) the exceptional Jordan algebra, (b) anomaly cancellation, (c)
triality's `S₃` on three modules — forces `n = 2`.  Forcing three generations
therefore requires an explicit rank-fixing input logically equivalent to
`n = 2`. -/
theorem three_generations_not_forced :
    (∀ n, completionCount n = n + 1) ∧
    (∀ n, completionCount n = 3 ↔ n = 2) ∧
    (¬ Forces TrialityStruct) ∧
    (¬ Forces AnomalyStruct) ∧
    (¬ Forces JordanStruct) ∧
    (∀ C : ℕ → Prop, (Forces C ∧ C 2) ↔ (∀ n, C n ↔ n = 2)) := by
  exact ⟨completionCount_eq, three_generations_iff, triality_not_forces,
    anomaly_not_forces, jordan_not_forces, forcing_iff_rankfixing⟩

end FamilyRankNoGo

/-! ## Axiom audit (build-enforced guard pin) -/

/-- info: 'FamilyRankNoGo.three_generations_not_forced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FamilyRankNoGo.three_generations_not_forced
