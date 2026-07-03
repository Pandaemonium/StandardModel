import Mathlib

/-!
# Gate D2: the finite first-law identity (classical / probability-vector form)

This Draft module banks the algebraic core of the entanglement first law used
in the Gate D dynamics proposal (`Sources/Null_Edge_Dynamics_Gate_D.md`,
section 2, Gate D2).  The central claim of that section is deliberately
deflationary: **the first law `Delta S = Delta<K> - S_rel` is an exact
identity, and all the physics lives in the *universality* of the multipliers,
not in the identity itself.**  This file makes the identity precise and
kernel-checked in the classical (finite probability-vector) setting, which
avoids the matrix-logarithm API while capturing the exact combinatorial
content.

Objects, for finite real weight vectors `p, q : iota -> R` on a finite index
type:

* `crossEntropy p q = - sum_i p_i log q_i`   -- `<K_q>_p`, the `p`-expectation
  of the modular Hamiltonian `K_q = - log q`;
* `shannon p = crossEntropy p p = - sum_i p_i log p_i`   -- Shannon entropy;
* `relEntropy p q = sum_i p_i (log p_i - log q_i)`   -- relative entropy
  `S_rel(p || q)`.

Main results:

* `finite_first_law` : `S(p) - S(q) = <K_q>_p - <K_q>_q - S_rel(p||q)`,
  an *unconditional* identity (no normalization or positivity hypothesis).
* `relEntropy_nonneg` : Gibbs' inequality `S_rel(p||q) >= 0` for probability
  vectors (`p >= 0`, `q > 0`, `sum p = sum q = 1`), via `log x <= x - 1`.

## Status and claim scope

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.

Claim label: **finite identity** (`finite_first_law`) and **structural
theorem** (`relEntropy_nonneg`, Gibbs).  Per the Gate D honesty clause, the
first-law identity is *not* evidence for the gravity story; it is the trivial
half.  The nontrivial half (universality of the maximum-entropy multipliers
across all causal diamonds) is a separate paper-level obligation and is not
touched here.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateD
namespace FiniteFirstLaw

open scoped BigOperators

variable {ι : Type*} [Fintype ι]

/-- Finite cross-entropy `<K_q>_p = - sum_i p_i log q_i`: the expectation in the
weight vector `p` of the modular Hamiltonian `K_q = - log q`. -/
def crossEntropy (p q : ι → ℝ) : ℝ :=
  - ∑ i, p i * Real.log (q i)

/-- Finite Shannon entropy `S(p) = - sum_i p_i log p_i`. -/
def shannon (p : ι → ℝ) : ℝ :=
  crossEntropy p p

/-- Finite relative entropy `S_rel(p || q) = sum_i p_i (log p_i - log q_i)`. -/
def relEntropy (p q : ι → ℝ) : ℝ :=
  ∑ i, p i * (Real.log (p i) - Real.log (q i))

/-- The Shannon entropy of `q` is the `q`-expectation of its own modular
Hamiltonian `K_q`.  This is `crossEntropy q q = shannon q` by definition. -/
theorem shannon_eq_crossEntropy_self (q : ι → ℝ) :
    shannon q = crossEntropy q q := rfl

/-- Relative entropy as cross-entropy minus Shannon entropy:
`S_rel(p || q) = <K_q>_p - S(p)`. -/
theorem relEntropy_eq (p q : ι → ℝ) :
    relEntropy p q = crossEntropy p q - shannon p := by
  unfold relEntropy shannon crossEntropy
  simp only [mul_sub]
  rw [Finset.sum_sub_distrib]
  ring

/-- **Finite first law (exact identity).**

For any finite real weight vectors `p, q`, the Shannon entropy difference
decomposes exactly as a modular-energy difference minus a relative entropy:

`S(p) - S(q) = <K_q>_p - <K_q>_q - S_rel(p || q)`.

This is *unconditional*: it needs no probability normalization and no
positivity.  It is the deflationary content of Gate D2 - the first law is an
identity; the physical content is elsewhere (universality of the multipliers).
-/
theorem finite_first_law (p q : ι → ℝ) :
    shannon p - shannon q =
      crossEntropy p q - crossEntropy q q - relEntropy p q := by
  have hq : crossEntropy q q = shannon q :=
    (shannon_eq_crossEntropy_self q).symm
  rw [hq, relEntropy_eq]
  ring

/-- **Fixed modular-energy entropy gap.**

If `p` has the same `q`-modular energy as `q` itself, then the entropy deficit
from `q` to `p` is exactly the relative entropy `S_rel(p || q)`.  This is the
finite constrained-stationarity form of the first-law identity; positivity of
the deficit is supplied separately by Gibbs' inequality. -/
theorem entropy_gap_eq_relEntropy_of_fixed_crossEntropy (p q : ι → ℝ)
    (hK : crossEntropy p q = crossEntropy q q) :
    shannon q - shannon p = relEntropy p q := by
  have hfl := finite_first_law p q
  rw [hK] at hfl
  linarith

/-- **Gibbs' inequality (finite relative entropy is nonnegative).**

For a probability vector `p` (nonnegative, summing to one) and a *strictly
positive* probability vector `q` (summing to one), the relative entropy is
nonnegative: `S_rel(p || q) >= 0`.  Proof by the elementary bound
`log x <= x - 1` applied to `q_i / p_i`, summed and telescoped using the two
normalizations.

The strict positivity of `q` is essential, not cosmetic: with the Mathlib
convention `Real.log 0 = 0`, the finite sum `relEntropy p q` can be *negative*
when `q` vanishes on the support of `p` (e.g. `p = (1/2, 1/2)`, `q = (1, 0)`
gives `relEntropy = log (1/2) < 0`).  In the measure-theoretic convention that
case is `+ infinity`; the finite `Real.log` truncation loses that, so
absolute continuity (here: `q > 0`) must be a hypothesis.

This is the positivity half of Gate D2 and the finite shadow of the
data-processing / monotonicity content of Gate Q1. -/
theorem relEntropy_nonneg (p q : ι → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hpsum : ∑ i, p i = 1) (hqsum : ∑ i, q i = 1) :
    0 ≤ relEntropy p q := by
  have hterm :
      ∀ i ∈ (Finset.univ : Finset ι),
        p i - q i ≤ p i * (Real.log (p i) - Real.log (q i)) := by
    intro i _
    rcases eq_or_lt_of_le (hp i) with hpi | hpi
    · -- p_i = 0: goal `0 - q_i <= 0`, i.e. `0 <= q_i`.
      rw [← hpi]
      simp only [zero_mul]
      linarith [hq i]
    · -- p_i > 0 and q_i > 0.
      have hstep : p i * (Real.log (q i) - Real.log (p i)) ≤ q i - p i := by
        have hratio : Real.log (q i / p i) ≤ q i / p i - 1 :=
          Real.log_le_sub_one_of_pos (div_pos (hq i) hpi)
        rw [Real.log_div (ne_of_gt (hq i)) (ne_of_gt hpi)] at hratio
        have hmul := mul_le_mul_of_nonneg_left hratio (le_of_lt hpi)
        calc
          p i * (Real.log (q i) - Real.log (p i))
              ≤ p i * (q i / p i - 1) := hmul
          _ = q i - p i := by field_simp
      have hring :
          p i * (Real.log (p i) - Real.log (q i))
            = -(p i * (Real.log (q i) - Real.log (p i))) := by ring
      linarith [hstep, hring]
  calc
    (0 : ℝ) = (∑ i, p i) - ∑ i, q i := by rw [hpsum, hqsum]; ring
    _ = ∑ i, (p i - q i) := by rw [Finset.sum_sub_distrib]
    _ ≤ ∑ i, p i * (Real.log (p i) - Real.log (q i)) :=
        Finset.sum_le_sum hterm
    _ = relEntropy p q := rfl

/-- **Finite fixed-modular-energy maximum entropy.**

Among probability vectors `p` with the same `q`-modular energy as the strictly
positive reference probability vector `q`, the reference vector has at least as
large Shannon entropy.  This is the finite Gate D2 stationarity corollary: the
first-law identity reduces the entropy gap to relative entropy, then Gibbs'
inequality makes the gap nonnegative.

This is not yet the continuum or universal-multiplier claim; it is only the
finite classical constrained-maximum theorem for one fixed reference weight. -/
theorem d2_shannon_le_of_fixed_crossEntropy (p q : ι → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hpsum : ∑ i, p i = 1) (hqsum : ∑ i, q i = 1)
    (hK : crossEntropy p q = crossEntropy q q) :
    shannon p ≤ shannon q := by
  have hgap := entropy_gap_eq_relEntropy_of_fixed_crossEntropy p q hK
  have hrel : 0 ≤ relEntropy p q :=
    relEntropy_nonneg p q hp hq hpsum hqsum
  linarith

end FiniteFirstLaw
end GateD
end NullEdge
end Draft
end PhysicsSM
