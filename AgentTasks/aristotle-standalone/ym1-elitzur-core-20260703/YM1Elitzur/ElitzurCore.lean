import Mathlib

/-!
# YM1: the Elitzur pairing bound (abstract core)

PROOF TARGETS for Aristotle (complete both `sorry`s; do NOT change the
statements). Self-contained, Mathlib only.

## Context (not needed for the proofs)

Elitzur's theorem in lattice gauge theory: a LOCAL gauge symmetry cannot
break spontaneously - the expectation of any gauge-odd observable vanishes
as the symmetry-breaking source `h -> 0`, UNIFORMLY in the volume. The
statement freeze (`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`,
Theorem 1) reduces the whole theorem to two pieces of abstract mathematics,
which are this package:

1. a pointwise hyperbolic inequality, and
2. an abstract pairing bound over a finite configuration space with an
   involution.

The lattice instantiation (the involution = the gauge flip at one site; the
Wilson-action invariance is the already-kernel-checked
`plaqSpins_gauge`) is bookkeeping added in-repo afterward and is NOT part of
this package.

## The mathematics (verified by hand; use freely)

Target 1: for real `a, b` with `|a| <= b`:
`|1 - exp(-2a)| <= (1 + exp(-2a)) * tanh b`.
Proof route: `1 - e^{-2a} = 2 e^{-a} sinh a` and `1 + e^{-2a} = 2 e^{-a}
cosh a`, so the ratio is `tanh a`, and `|tanh a| = tanh |a| <= tanh b` by
monotonicity of `tanh` (Mathlib: from `Real.sinh`/`Real.cosh` positivity
facts, or from the derivative `deriv tanh = 1 - tanh^2 > 0` via
`StrictMono.le_iff_le` machinery; either route acceptable). Equivalently:
prove `|1 - e^{-2a}| * cosh? ...` - any correct route is fine; do not
change the statement.

Target 2 (the pairing bound): finite `Omega`, involution `phi`, weights
`w > 0`, observable `f` odd under `phi` (`f (phi s) = - f s`) and bounded
(`|f s| <= c`), and the covariance `w (phi s) = w s * exp (-2 * K s)` with
`|K s| <= b`. Then

`|sum_s f s * w s| <= c * tanh b * sum_s w s`.

Proof route (verified): reindex the sum by the involution (a bijection of
the Fintype: `Function.Involutive.toPerm` + `Equiv.sum_comp` or
`Finset.sum_bijective`):
`N := sum f w = sum (f o phi)(w o phi) = - sum f s * w s * exp(-2 K s)`,
hence `2 N = sum f s * w s * (1 - exp (-2 K s))`; similarly
`2 * sum w = sum w s * (1 + exp (-2 K s))`. Then bound termwise:
`|f s| * w s * |1 - e^{-2 K s}| <= c * w s * (1 + e^{-2 K s}) * tanh b`
by Target 1 with `a = K s` (and `w s > 0`, `tanh b >= 0` from `b >= 0`,
which follows from `b >= |K s| >= 0` when `Omega` is nonempty; the empty
case is trivial since both sides are `0` - handle it separately or note
`tanh b >= 0` needs `0 <= b`, which the hypothesis `hb` supplies directly).
Triangle inequality over the sum finishes.

## Deliverables

No `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`. If a statement appears false,
STOP and report rather than weakening it.
-/

namespace YM1Elitzur

/-- **Target 1: the pointwise pairing inequality.**
For `|a| <= b`: `|1 - e^{-2a}| <= (1 + e^{-2a}) tanh b`. -/
theorem abs_one_sub_exp_le_tanh (a b : ℝ) (hab : |a| ≤ b) :
    |1 - Real.exp (-2 * a)| ≤ (1 + Real.exp (-2 * a)) * Real.tanh b := by
  sorry

/-- **Target 2: the abstract Elitzur pairing bound.**
Finite configuration space, involution `phi`, positive weights with the
source-covariance `w (phi s) = w s * exp (-2 K s)`, `phi`-odd bounded
observable: the weighted average is bounded by `c * tanh b`, uniformly in
everything else - the volume-uniform core of Elitzur's theorem. -/
theorem abstract_elitzur_bound {Ω : Type*} [Fintype Ω]
    (φ : Ω → Ω) (hφ : Function.Involutive φ)
    (f w K : Ω → ℝ) (c b : ℝ)
    (hw : ∀ s, 0 < w s) (hb : 0 ≤ b)
    (hK : ∀ s, |K s| ≤ b)
    (hodd : ∀ s, f (φ s) = - f s)
    (hcov : ∀ s, w (φ s) = w s * Real.exp (-2 * K s))
    (hfb : ∀ s, |f s| ≤ c) :
    |∑ s, f s * w s| ≤ c * Real.tanh b * ∑ s, w s := by
  sorry

end YM1Elitzur
