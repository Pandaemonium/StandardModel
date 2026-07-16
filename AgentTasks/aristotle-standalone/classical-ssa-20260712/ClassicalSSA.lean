import Mathlib

/-!
# Classical strong subadditivity of Shannon entropy

Aristotle target. Prove `shannon_ssa`: the classical strong subadditivity
`H(XZ) + H(YZ) ≥ H(XYZ) + H(Z)` for a finite joint distribution -- equivalently,
conditional mutual information `I(X:Y|Z) ≥ 0`. SSA is the deep entropy inequality
behind holographic entropy bounds, monotonicity of relative entropy, and the
NERD gravity/DPI program (Q1/Q2); the finite classical case is the tractable
gate.

For a joint probability vector `p : X × Y × Z → ℝ` (nonnegative, summing to one),
with Shannon entropy `H(r) = ∑ negMulLog (r ·)` of a marginal:
`shannonEntropy pXZ + shannonEntropy pYZ ≥ shannonEntropy p + shannonEntropy pZ`.

Route (suggested): `I(X:Y|Z) = ∑ p(x,y,z) log ( p(x,y,z) p_Z(z) / (p_XZ(x,z) p_YZ(y,z)) ) ≥ 0`
by Gibbs'/log-sum inequality (it is a relative entropy between `p(x,y,z)` and the
Markov reconstruction `p_XZ(x,z) p_YZ(y,z) / p_Z(z)`, both normalized to one). Use
`Real.log_le_sub_one_of_pos` / convexity of `x log x`. Handle zero entries via the
`0 * log 0 = 0` convention.

Run: `lake env lean ClassicalSSA.lean`. Close only the hole; keep the definitions
and hypotheses byte-identical.
-/

noncomputable section

namespace ClassicalSSA

open scoped BigOperators

variable {X Y Z : Type*} [Fintype X] [Fintype Y] [Fintype Z]

/-- Shannon entropy of a finite distribution `r`, `∑ i, negMulLog (r i)`. -/
def shannonEntropy {ι : Type*} [Fintype ι] (r : ι → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (r i)

/-- `XZ` marginal of a joint `X × Y × Z` distribution. -/
def margXZ (p : X × Y × Z → ℝ) : X × Z → ℝ :=
  fun xz => ∑ y : Y, p (xz.1, y, xz.2)

/-- `YZ` marginal. -/
def margYZ (p : X × Y × Z → ℝ) : Y × Z → ℝ :=
  fun yz => ∑ x : X, p (x, yz.1, yz.2)

/-- `Z` marginal. -/
def margZ (p : X × Y × Z → ℝ) : Z → ℝ :=
  fun z => ∑ x : X, ∑ y : Y, p (x, y, z)

/-- **TARGET (the hole): classical strong subadditivity.**  For a finite joint
distribution, `H(XZ) + H(YZ) ≥ H(XYZ) + H(Z)`. -/
theorem shannon_ssa (p : X × Y × Z → ℝ)
    (hp : ∀ t, 0 ≤ p t) (hps : ∑ t, p t = 1) :
    shannonEntropy p + shannonEntropy (margZ p)
      ≤ shannonEntropy (margXZ p) + shannonEntropy (margYZ p) := by
  sorry

end ClassicalSSA
