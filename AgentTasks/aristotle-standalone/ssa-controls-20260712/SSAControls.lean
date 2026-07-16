import Mathlib

/-!
# SSA anti-vacuity controls: conditional-independence equality + strict witness

Aristotle target. Preregistered controls for GRAV-SSA-001 requested by the lab
manager: the strong-subadditivity inequality `shannon_ssa` is only a substantive
result if (1) it is TIGHT exactly at conditional independence, and (2) it is
STRICT on a genuinely correlated distribution. These two controls rule out the
vacuity / always-equality failure modes.

Definitions are byte-identical to
`PhysicsSM.Draft.NullEdge.ClassicalSSA` so the controls compose with the main
theorem `shannon_ssa`.

- `ssa_eq_of_condIndep`: if the joint distribution satisfies the
  conditional-independence (Markov) identity
  `p(x,y,z) * margZ z = margXZ (x,z) * margYZ (y,z)` for all `x,y,z`, then SSA
  holds with EQUALITY (conditional mutual information `I(X:Y|Z) = 0`).
- `ssa_strict_witness`: the explicit perfectly-correlated distribution
  `witnessP` on `Fin 2 x Fin 2 x Fin 1` (`p = 1/2` when `X = Y`, else `0`) makes
  SSA STRICT: `H(XYZ) + H(Z) < H(XZ) + H(YZ)` (numerically `log 2 < 2 log 2`).

Route: control 1 -- expand each entropy as `-sum p log p`, substitute the Markov
identity, and cancel via `log (a*b) = log a + log b` with the `0*log0 = 0`
convention (`Real.negMulLog`); it is the equality case of the relative-entropy /
log-sum bound. Control 2 -- compute the four marginals of `witnessP` explicitly
(`margXZ`, `margYZ` are uniform `1/2`; `margZ` is `1`), reduce every entropy to a
finite sum of `negMulLog` at `0, 1/2, 1`, and finish with `Real.log_pos` /
`norm_num` (`log 2 > 0`). Handle `0*log0 = 0` via `Real.negMulLog`.

Run: `lake env lean SSAControls.lean`. Close only the holes; keep the definitions
and statements byte-identical.
-/

noncomputable section

namespace SSAControls

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

/-- **CONTROL 1 (the hole): conditional-independence equality.**  When the joint
distribution satisfies the Markov identity, SSA holds with equality
(`I(X:Y|Z) = 0`). -/
theorem ssa_eq_of_condIndep (p : X × Y × Z → ℝ)
    (hp : ∀ t, 0 ≤ p t) (hps : ∑ t, p t = 1)
    (hCI : ∀ x y z, p (x, y, z) * margZ p z = margXZ p (x, z) * margYZ p (y, z)) :
    shannonEntropy (margXZ p) + shannonEntropy (margYZ p)
      = shannonEntropy p + shannonEntropy (margZ p) := by
  sorry

/-- Perfectly-correlated witness on `Fin 2 × Fin 2 × Fin 1`: mass `1/2` on the
diagonal `X = Y`, else `0`. -/
def witnessP : Fin 2 × Fin 2 × Fin 1 → ℝ :=
  fun t => if t.1 = t.2.1 then (1 : ℝ) / 2 else 0

/-- **CONTROL 2 (the hole): strict correlated witness.**  On `witnessP` the SSA
inequality is strict, so SSA is not vacuously an equality. -/
theorem ssa_strict_witness :
    (∀ t, 0 ≤ witnessP t) ∧ (∑ t, witnessP t = 1) ∧
      shannonEntropy witnessP + shannonEntropy (margZ witnessP)
        < shannonEntropy (margXZ witnessP) + shannonEntropy (margYZ witnessP) := by
  sorry

end SSAControls
