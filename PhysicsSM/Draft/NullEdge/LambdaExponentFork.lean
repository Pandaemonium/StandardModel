import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

namespace LambdaExponentFork

/-- The Lambda_rms scaling exponent as a function of the count-variance exponent `alpha`.

Since `Var(N) ~ N^alpha`, we have `Lambda_rms = sqrt(Var N)/N = N^{alpha/2}/N = N^{alpha/2 - 1}`,
so the exponent of `Lambda_rms` is `alpha/2 - 1`.  We work entirely with this rational function of
`alpha` (the arithmetic of the exponent itself), avoiding any `Real.rpow`/`log`/`sqrt`. -/
def lamExp (alpha : ℚ) : ℚ := alpha / 2 - 1

/-- **Target 1a.** Closed form of the exponent. -/
theorem lamExp_closed (alpha : ℚ) : lamExp alpha = alpha / 2 - 1 := by
  rfl

/-- **Target 1b.** `lamExp` is strictly increasing in `alpha`. -/
theorem lamExp_strictMono {alpha1 alpha2 : ℚ} (h : alpha1 < alpha2) :
    lamExp alpha1 < lamExp alpha2 := by
  unfold lamExp
  linarith

/-- **Target 2.** The Poisson/extensive everpresent exponent: `lamExp 1 = -1/2`. -/
theorem everpresent_value : lamExp 1 = -1/2 := by
  norm_num [lamExp]

/-- **Target 3a (payload).** For `alpha < 1` (hyperuniform), the exponent is strictly below `-1/2`:
`Lambda_rms` decays strictly faster than `1/sqrt(N)`, so the `10^-122` number is NOT reproduced. -/
theorem hyperuniform_faster {alpha : ℚ} (h : alpha < 1) : lamExp alpha < -1/2 := by
  unfold lamExp
  linarith

/-- **Target 3b (payload).** For `alpha > 1` (super-extensive), the exponent is strictly above `-1/2`. -/
theorem superextensive_slower {alpha : ℚ} (h : 1 < alpha) : -1/2 < lamExp alpha := by
  unfold lamExp
  linarith

/-- **Target 4 (payload).** The everpresent exponent is realized IFF the count is exactly extensive:
`lamExp alpha = -1/2 <-> alpha = 1`.  The fork is decidable on the single measurable exponent. -/
theorem fork_iff (alpha : ℚ) : lamExp alpha = -1/2 ↔ alpha = 1 := by
  unfold lamExp
  constructor
  · intro h; linarith
  · intro h; rw [h]; norm_num

/-- **MANDATORY non-degeneracy witnesses (explicit rationals).** -/
theorem witness_everpresent : lamExp 1 = -1/2 := by norm_num [lamExp]

theorem witness_hyperuniform : lamExp (1/2) = -3/4 ∧ lamExp (1/2) < -1/2 := by
  refine ⟨by norm_num [lamExp], by norm_num [lamExp]⟩

theorem witness_superextensive : lamExp 2 = 0 ∧ -1/2 < lamExp 2 := by
  refine ⟨by norm_num [lamExp], by norm_num [lamExp]⟩

/-- **Target 5.** Package verdict: the count-variance exponent `alpha` is the sharp decidable form of
the Poisson-vs-hyperuniform fork.

* `alpha = 1 <-> lamExp = -1/2` (everpresent number survives);
* `alpha < 1 -> lamExp < -1/2` (hyperuniform: the number fails, decaying strictly faster);
* `alpha > 1 -> lamExp > -1/2` (super-extensive: the number is also not matched);
* `lamExp` is strictly monotone, so the exponent `-1/2` is hit at exactly one `alpha`, namely `1`.

The "not both" content is exactly the equivalence in the first clause combined with the strict
inequality in the second: extensivity (`alpha = 1`) keeps the number but forfeits hyperuniform novelty,
while sub-extensivity (`alpha < 1`) gains novelty at the cost of the number.

Honest scope: this is the EXPONENT arithmetic (a decidable pre-registered kill-condition); it does not
derive which `alpha` nature realizes (a conjecture), and the Lorentz-violation tie for `alpha < 1`
(Bombelli-Henson-Sorkin) is imported context, not proved here. -/
theorem exponent_fork_verdict :
    (∀ alpha : ℚ, lamExp alpha = -1/2 ↔ alpha = 1) ∧
    (∀ alpha : ℚ, alpha < 1 → lamExp alpha < -1/2) ∧
    (∀ alpha : ℚ, 1 < alpha → -1/2 < lamExp alpha) ∧
    (∀ alpha1 alpha2 : ℚ, alpha1 < alpha2 → lamExp alpha1 < lamExp alpha2) := by
  refine ⟨fork_iff, ?_, ?_, ?_⟩
  · intro alpha h; exact hyperuniform_faster h
  · intro alpha h; exact superextensive_slower h
  · intro a1 a2 h; exact lamExp_strictMono h

-- Axiom footprint checks on every headline (must be exactly [propext, Classical.choice, Quot.sound]).
/-- info: 'LambdaExponentFork.lamExp_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lamExp_closed
/-- info: 'LambdaExponentFork.lamExp_strictMono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lamExp_strictMono
/-- info: 'LambdaExponentFork.everpresent_value' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms everpresent_value
/-- info: 'LambdaExponentFork.hyperuniform_faster' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hyperuniform_faster
/-- info: 'LambdaExponentFork.superextensive_slower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms superextensive_slower
/-- info: 'LambdaExponentFork.fork_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms fork_iff
/-- info: 'LambdaExponentFork.exponent_fork_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms exponent_fork_verdict

end LambdaExponentFork
