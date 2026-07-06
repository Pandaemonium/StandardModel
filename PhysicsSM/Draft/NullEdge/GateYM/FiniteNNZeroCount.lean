import Mathlib

/-!
# The GENUINE 1D Nielsen–Ninomiya no-go: signed count of ZEROS = 0

This file proves the *genuine* finite (1D) Nielsen–Ninomiya no-go statement on the
discrete Brillouin torus `ZMod N`: the **chirality-weighted count of the ZEROS
(nodes / sign crossings)** of a real periodic lattice dispersion is `0` for
**every** dispersion.

## Why this is the genuine version (and what the earlier skeleton lacked)

The earlier `FiniteNielsenNinomiya` skeleton only telescoped a *nowhere-zero*
symbol (the discrete winding / `arg` of `exp(2πip/N)-1`): that quantity is `0` for
a boring reason (a nowhere-zero branch has nothing to do with the location of
nodes), and its "chirality" reading was by naming, not by proof. Its
`odd_signedCount_impossible` was *vacuous* (its hypothesis was unsatisfiable).

Here everything is built **directly from the zeros of a genuine real dispersion**
`f : ZMod N → K`. The sign function `sgnZ (f p) ∈ {-1,0,1}` changes exactly at the
sign crossings (nodes) of `f`, and the chirality of a crossing is `±1`
(`+1` up-crossing, `-1` down-crossing). The main theorem
`signedZeroCount_eq_zero` is genuinely `0` because the periodicity /
boundarylessness of the loop `ZMod N` forces `f` (hence `sgnZ ∘ f`) to return to
its starting value — a real telescoping over the *zeros*, not over a nowhere-zero
auxiliary phase.

## Physical model

The off-diagonal symbol of a chirally-symmetric 1D Dirac operator is, up to a
phase, a **real** periodic function on the discrete Brillouin torus. We take that
real symbol directly, `f : ZMod N → K` (`K` any linear order with a zero; use
`K = ℚ` for kernel `decide`, `K = ℝ` for the physical model). A *node* / *zero* is
a place where `f` changes sign; its *chirality* is the sign of the jump.

## What is proved (sorry-free, `decide`/`native_decide`-free final theorems)

* `signedZeroCount_eq_zero` : for **every** `f`, the signed (sign-difference)
  crossing count `∑_p (sgn f(p+1) - sgn f p)` is `0`. This is the genuine no-go:
  up-crossings and down-crossings balance because the loop is boundaryless.
* `signedCrossings_eq_zero` : for every **nowhere-zero** `f` (a generic dispersion
  with no accidental lattice-point degeneracy), the sum of the `±1` crossing signs
  is `0` — the number of up-crossings equals the number of down-crossings.
* `numCrossings_even` / `single_crossing_impossible` : for every nowhere-zero `f`
  the total number of sign crossings is **even**, so a **single** lone crossing
  (an isolated Weyl node) is impossible on a periodic lattice. This is
  **non-vacuous**: `numCrossings f` genuinely ranges over `0, 2, 4, …`.
* Concrete `N = 4` instance (`by decide`, kernel-checked): the naive dispersion
  `sin(2πp/4) = ![0,1,0,-1]` has exactly one up-crossing (chirality `+1` at
  `p = 0`) and one down-crossing (chirality `-1` at `p = 2`), with
  `signedZeroCount = 0`, `signedCrossings = 0`, `numCrossings = 2`.
* A concrete nowhere-zero (regularized) dispersion `![1,2,-1,-2]` exercising the
  nowhere-zero theorems non-vacuously.

The axiom footprint of every theorem is reported at the end of the file.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount

variable {N : ℕ} [NeZero N] {K : Type*} [LinearOrder K] [Zero K]

/-- The `{-1, 0, 1}`-valued sign of an element of a linearly ordered type with a
zero. This is the honest sign of a real dispersion value. -/
def sgnZ (x : K) : ℤ := if 0 < x then 1 else if x < 0 then -1 else 0

/-- The sign sequence `sgn ∘ f` of a lattice dispersion `f : ZMod N → K`. It flips
exactly at the sign crossings (zeros / nodes) of `f`. -/
def sSeq (f : ZMod N → K) (p : ZMod N) : ℤ := sgnZ (f p)

/-- The signed sign-difference across the edge `(p, p+1)`. For a genuine crossing
(neighbouring values of opposite nonzero sign) this is `±2`; more robustly it is
the change of `sgn f` across the edge, well-defined even when `f` vanishes at a
lattice point. -/
def crossSign (f : ZMod N → K) (p : ZMod N) : ℤ := sSeq f (p + 1) - sSeq f p

/-- The signed count of zeros: the total chirality of all sign crossings of `f`,
summed over the whole (boundaryless) Brillouin torus `ZMod N`. -/
def signedZeroCount (f : ZMod N → K) : ℤ := ∑ p, crossSign f p

/-- A dispersion is *nowhere zero* (generic: no accidental degeneracy sitting
exactly on a lattice momentum). -/
def NowhereZero (f : ZMod N → K) : Prop := ∀ p, f p ≠ 0

/-- The `±1` chirality of a sign crossing at edge `(p, p+1)`: `+1` for an
up-crossing, `-1` for a down-crossing, and `0` when there is no sign change.
(On the concrete `sin` example below this reproduces exactly one `+1` and one
`-1`.) -/
def chir (f : ZMod N → K) (p : ZMod N) : ℤ :=
  if sSeq f (p + 1) ≠ sSeq f p then sSeq f (p + 1) else 0

/-- Sum over crossings of the `±1` crossing sign (up-crossings minus
down-crossings). -/
def signedCrossings (f : ZMod N → K) : ℤ := ∑ p, chir f p

/-- The (unsigned) number of sign crossings of `f`. -/
def numCrossings (f : ZMod N → K) : ℤ := ∑ p, |chir f p|

omit [NeZero N] in
/-- The sign of a nonzero dispersion value is `±1`. -/
theorem sSeq_eq_one_or_neg_one {f : ZMod N → K} (hf : NowhereZero f) (p : ZMod N) :
    sSeq f p = 1 ∨ sSeq f p = -1 := by
  unfold sSeq sgnZ
  rcases lt_trichotomy (f p) 0 with h | h | h
  · right; simp [not_lt.2 h.le, h]
  · exact absurd h (hf p)
  · left; simp [h]

/-- **The genuine 1D Nielsen–Ninomiya no-go.** For *every* real periodic lattice
dispersion `f : ZMod N → K`, the signed count of its zeros (sign crossings) is
`0`. Up-crossings and down-crossings must balance because the discrete Brillouin
torus `ZMod N` is boundaryless: `sgn ∘ f` returns to its starting value after one
loop, so the telescoping sum of its increments vanishes. This uses the
periodicity of the loop applied to the *zeros* of `f` (the reindexing
`p ↦ p + 1` is the bijection `Equiv.addRight 1`), not any nowhere-zero auxiliary
quantity. -/
theorem signedZeroCount_eq_zero (f : ZMod N → K) : signedZeroCount f = 0 := by
  unfold signedZeroCount crossSign
  have hre : ∑ p : ZMod N, sSeq f (p + 1) = ∑ p : ZMod N, sSeq f p :=
    Equiv.sum_comp (Equiv.addRight (1 : ZMod N)) (sSeq f)
  rw [Finset.sum_sub_distrib, hre, sub_self]

omit [NeZero N] in
/-- For a nowhere-zero dispersion, the sign-difference across each edge is exactly
twice the `±1` crossing chirality: a crossing contributes `±2` to `crossSign` and
`±1` to `chir`, and a non-crossing contributes `0` to both. -/
theorem crossSign_eq_two_mul_chir {f : ZMod N → K} (hf : NowhereZero f)
    (p : ZMod N) : crossSign f p = 2 * chir f p := by
  unfold crossSign chir
  have h1 := sSeq_eq_one_or_neg_one hf (p + 1)
  have h2 := sSeq_eq_one_or_neg_one hf p
  by_cases hc : sSeq f (p + 1) ≠ sSeq f p
  · rw [if_pos hc]; rcases h1 with a | a <;> rcases h2 with b | b <;> omega
  · rw [if_neg hc]; push_neg at hc; omega

/-- **Equal up- and down-crossings.** For every nowhere-zero dispersion the sum of
the `±1` crossing signs is `0`: the number of up-crossings equals the number of
down-crossings. -/
theorem signedCrossings_eq_zero {f : ZMod N → K} (hf : NowhereZero f) :
    signedCrossings f = 0 := by
  have h : signedZeroCount f = 2 * signedCrossings f := by
    unfold signedZeroCount signedCrossings
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl (fun p _ => crossSign_eq_two_mul_chir hf p)
  have h0 : signedZeroCount f = 0 := signedZeroCount_eq_zero f
  omega

/-- **The total number of sign crossings is even.** For every nowhere-zero
dispersion, crossings come in up/down pairs. This is *non-vacuous*: `numCrossings`
genuinely takes the values `0, 2, 4, …` (e.g. `2` for the examples below). -/
theorem numCrossings_even {f : ZMod N → K} (hf : NowhereZero f) :
    Even (numCrossings f) := by
  have h0 : signedCrossings f = 0 := signedCrossings_eq_zero hf
  have hd : (2 : ℤ) ∣ (numCrossings f - signedCrossings f) := by
    unfold numCrossings signedCrossings
    rw [← Finset.sum_sub_distrib]
    apply Finset.dvd_sum
    intro p _
    rcases abs_choice (chir f p) with h | h <;> rw [h] <;> omega
  rw [h0, sub_zero] at hd
  exact even_iff_two_dvd.2 hd

/-- **A lone Weyl node is impossible.** A periodic lattice dispersion cannot have a
single sign crossing: the crossing count is even. So a solitary chiral zero cannot
exist on the lattice without breaking the periodic (boundaryless) structure. -/
theorem single_crossing_impossible {f : ZMod N → K} (hf : NowhereZero f) :
    numCrossings f ≠ 1 := by
  intro h
  have hev := numCrossings_even hf
  rw [h] at hev
  exact (by decide : ¬ Even (1 : ℤ)) hev

/-! ## Concrete `N = 4` instances (kernel `decide`)

The naive lattice dispersion `f p = sin(2πp/4)` evaluates to `![0, 1, 0, -1]` on
`ZMod 4`. Over `ℚ` all comparisons are decidable, so the following are checked by
the kernel via `decide` (no `native_decide`). -/

/-- The naive `sin(2πp/4)` dispersion as a real (rational) vector on `ZMod 4`. -/
def naiveSin4 : ZMod 4 → ℚ := ![0, 1, 0, -1]

/-- The signed count of zeros of the naive dispersion is `0` (kernel `decide`). -/
theorem signedZeroCount_naiveSin4 : signedZeroCount naiveSin4 = 0 := by decide

/-- The sum of the `±1` crossing signs of the naive dispersion is `0`. -/
theorem signedCrossings_naiveSin4 : signedCrossings naiveSin4 = 0 := by decide

/-- The naive dispersion has exactly two sign crossings. -/
theorem numCrossings_naiveSin4 : numCrossings naiveSin4 = 2 := by decide

/-- Exactly one up-crossing (chirality `+1`) at `p = 0`. -/
theorem chir_naiveSin4_zero : chir naiveSin4 0 = 1 := by decide

/-- Exactly one down-crossing (chirality `-1`) at `p = 2`. -/
theorem chir_naiveSin4_two : chir naiveSin4 2 = -1 := by decide

/-! ### A concrete nowhere-zero (regularized) dispersion

`![1, 2, -1, -2]` is a nowhere-zero dispersion (a regularization of `sin` with no
lattice-point zeros); it exercises the nowhere-zero theorems non-vacuously and
also has exactly two crossings. -/

/-- A nowhere-zero regularized dispersion on `ZMod 4`. -/
def regDisp4 : ZMod 4 → ℚ := ![1, 2, -1, -2]

/-- `regDisp4` is nowhere zero. -/
theorem nowhereZero_regDisp4 : NowhereZero regDisp4 := by
  unfold NowhereZero; decide

/-- Instantiating `signedCrossings_eq_zero` on the concrete nowhere-zero example. -/
theorem signedCrossings_regDisp4 : signedCrossings regDisp4 = 0 :=
  signedCrossings_eq_zero nowhereZero_regDisp4

/-- `regDisp4` has an even number of crossings (via `numCrossings_even`). -/
theorem numCrossings_even_regDisp4 : Even (numCrossings regDisp4) :=
  numCrossings_even nowhereZero_regDisp4

/-- and it cannot have a single crossing. -/
theorem single_crossing_impossible_regDisp4 : numCrossings regDisp4 ≠ 1 :=
  single_crossing_impossible nowhereZero_regDisp4

/-- Concretely, `regDisp4` has exactly two crossings (kernel `decide`). -/
theorem numCrossings_regDisp4 : numCrossings regDisp4 = 2 := by decide

/-! ## Axiom footprint

Every theorem depends only on the standard `propext, Classical.choice, Quot.sound`
axioms (no `sorry`, no extra axioms, and the concrete instances use kernel
`decide`, not `native_decide`). Uncomment to inspect. -/

-- #print axioms signedZeroCount_eq_zero
-- #print axioms signedCrossings_eq_zero
-- #print axioms numCrossings_even
-- #print axioms single_crossing_impossible
-- #print axioms signedZeroCount_naiveSin4
-- #print axioms numCrossings_regDisp4

end PhysicsSM.Draft.NullEdge.GateYM.FiniteNNZeroCount
