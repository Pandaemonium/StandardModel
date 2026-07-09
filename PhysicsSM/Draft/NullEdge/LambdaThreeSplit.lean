import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The three Lambdas: bare + induced, sequestered, and count-set observed

A finite rational-matrix avatar of the vacuum-sequestering resolution of the
cosmological-constant magnitude problem in the spectral-action picture.

The Dirac square is modeled as `H = H0 + lb • one + g • Hmat` on `Fin n` (here `n = 3`):
`H0` is the bare kinetic square, `lb • one` the bare Lambda (a uniform vacuum shift),
`g • Hmat` the matter contribution.

Three "Lambdas" appear:

* `Lambda_bare lb := lb`                         -- adjustable order-0 input;
* `Lambda_ind  g  := (1/n) * (g • Hmat).trace`   -- radiative order-4 induced density;
* `Lambda_obs = Lambda_count N := 1 / N`         -- fixed by the pierced-edge count.

The sequestering map `seq H := H - (H.trace / n) • one` (the traceless part) kills every
uniform (identity-proportional) shift, so `Lambda_bare` and the uniform part of `Lambda_ind`
drop out of the unimodular/traceless dynamics. What remains -- the observed Lambda -- is the
count functional, independent of `lb` and `g`.

Honest scope: this is a finite linear-algebra *structure* result (uniform shifts drop, count
remains); it does not fix the numerical value or sign of the physical Lambda.
-/

namespace LambdaThreeSplit

/-- Fixed small dimension. -/
abbrev n : ℕ := 3

/-- Rational `n × n` matrices (the finite Dirac-square arena). -/
abbrev M := Matrix (Fin n) (Fin n) ℚ

/-- Bare kinetic square: explicit, nonzero. -/
def H0 : M := !![1, 0, 0; 0, 2, 0; 0, 0, 3]

/-- Matter block: explicit, nonzero, distinct from `H0`, with `trace = 3`. -/
def Hmat : M := !![1, 1, 0; 0, 1, 0; 0, 0, 1]

/-- The bare Lambda coefficient (the uniform vacuum shift coefficient). -/
def Lambda_bare (lb : ℚ) : ℚ := lb

/-- The uniform/scalar part of the matter-induced Lambda: trace density of `g • Hmat`. -/
def Lambda_ind (g : ℚ) : ℚ := (1 / (n : ℚ)) * (g • Hmat).trace

/-- The naive total: bare plus induced. Adjustable -- nothing in it fixes the magnitude. -/
def Lambda_naive (lb g : ℚ) : ℚ := Lambda_bare lb + Lambda_ind g

/-- The sequestering (traceless) map: subtracts the uniform, identity-proportional part. -/
def seq (H : M) : M := H - (H.trace / (n : ℚ)) • (1 : M)

/-- The physical/observed Lambda is the pierced-edge count functional. -/
def Lambda_count (N : ℚ) : ℚ := 1 / N

/-- Observed Lambda as a function that (by construction) ignores `lb` and `g`. -/
def Lambda_obs (N _lb _g : ℚ) : ℚ := Lambda_count N

/-! ## Non-degeneracy of the data -/

/-- `H0` and `Hmat` are nonzero and distinct. -/
theorem data_nondegenerate : H0 ≠ 0 ∧ Hmat ≠ 0 ∧ H0 ≠ Hmat := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have := congrArg (fun A : M => A 0 0) h
    simp [H0] at this
  · intro h
    have := congrArg (fun A : M => A 0 0) h
    simp [Hmat] at this
  · intro h
    have := congrArg (fun A : M => A 1 1) h
    simp [H0, Hmat] at this

/-! ## Target 1: bare + induced is adjustable (the magnitude problem) -/

/-- The naive total `Lambda_naive lb g = Lambda_bare lb + Lambda_ind g` is adjustable:
two different `(lb, g)` give different values, so nothing fixes it. -/
theorem bare_plus_induced : Lambda_naive 1 1 ≠ Lambda_naive 2 3 := by
  norm_num [Lambda_naive, Lambda_bare, Lambda_ind, Hmat]

/-! ## Target 2 (payload 1): the traceless map kills every uniform shift -/

/-- `seq` is blind to uniform (identity-proportional) shifts: `seq (H + c • one) = seq H`
for all rational `c`. In particular `seq` cannot see `Lambda_bare` nor the uniform part of
the induced Lambda. -/
theorem uniform_shift_sequestered (H : M) (c : ℚ) :
    seq (H + c • (1 : M)) = seq H := by
  have hc : ((1 : M).trace) = (n : ℚ) := by
    simp [Matrix.trace_one, Fintype.card_fin]
  simp only [seq, Matrix.trace_add, Matrix.trace_smul, smul_eq_mul, hc]
  module

/-! ## Target 3 (payload 2): the observed Lambda is the count, independent of `lb`, `g` -/

/-- The observed Lambda is the count functional, independent of `lb` and `g`; and the
sequestered operator `seq (H0 + lb • one + g • Hmat)` is itself independent of `lb`. -/
theorem observed_is_count :
    (∀ N lb g lb' g' : ℚ, Lambda_obs N lb g = Lambda_obs N lb' g') ∧
    (∀ (lb g : ℚ),
        seq (H0 + lb • (1 : M) + g • Hmat) = seq (H0 + g • Hmat)) := by
  refine ⟨?_, ?_⟩
  · intro N lb g lb' g'; rfl
  · intro lb g
    have : H0 + lb • (1 : M) + g • Hmat = (H0 + g • Hmat) + lb • (1 : M) := by
      abel
    rw [this, uniform_shift_sequestered]

/-! ## Non-degeneracy witness: sequestering in action -/

/-- Two `(lb, g)` pairs with the *same* `g` but different `lb`: they give different
`Lambda_naive`, yet the sequestered operator `seq (H0 + lb • one + g • Hmat)` is identical.
This directly witnesses sequestering: the bare Lambda is adjustable but drops out. -/
theorem sequestering_witness :
    Lambda_naive 1 1 ≠ Lambda_naive 2 1 ∧
    seq (H0 + (1 : ℚ) • (1 : M) + (1 : ℚ) • Hmat)
      = seq (H0 + (2 : ℚ) • (1 : M) + (1 : ℚ) • Hmat) := by
  refine ⟨?_, ?_⟩
  · norm_num [Lambda_naive, Lambda_bare, Lambda_ind, Hmat]
  · rw [(observed_is_count.2 1 1), (observed_is_count.2 2 1)]

/-! ## Target 4: the three-Lambda verdict -/

/-- Package. There are three Lambdas:

* `Lambda_bare` (adjustable, order-0 input) -- witnessed adjustable;
* `Lambda_ind` (radiative, order-4) -- enters only through `Lambda_naive`;
* `Lambda_obs = Lambda_count` (set by the pierced-edge count) -- the survivor.

The traceless/unimodular map `seq` kills every uniform shift, so `Lambda_bare` and the
uniform part of the induced Lambda are sequestered out (`seq (H0 + lb•one + g•Hmat)` is
independent of `lb`); only the count remains, and it varies with the count `N`. -/
theorem three_lambda_verdict :
    -- (1) bare + induced is adjustable
    (Lambda_naive 1 1 ≠ Lambda_naive 2 3) ∧
    -- (2) seq kills every uniform shift (sequestering)
    (∀ (H : M) (c : ℚ), seq (H + c • (1 : M)) = seq H) ∧
    -- (3) the sequestered operator is independent of the bare Lambda `lb`
    (∀ (lb g : ℚ), seq (H0 + lb • (1 : M) + g • Hmat) = seq (H0 + g • Hmat)) ∧
    -- (4) the observed Lambda is the count, independent of `(lb, g)`
    (∀ N lb g lb' g' : ℚ, Lambda_obs N lb g = Lambda_obs N lb' g') ∧
    -- (5) the count is the everpresent handle: two counts, two values
    (Lambda_count 3 ≠ Lambda_count 5) := by
  refine ⟨bare_plus_induced, ?_, observed_is_count.2, observed_is_count.1, ?_⟩
  · intro H c; exact uniform_shift_sequestered H c
  · norm_num [Lambda_count]

/-! ## Axiom footprint: exactly `[propext, Classical.choice, Quot.sound]` on every headline. -/

/-- info: 'LambdaThreeSplit.bare_plus_induced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms bare_plus_induced

/-- info: 'LambdaThreeSplit.uniform_shift_sequestered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms uniform_shift_sequestered

/-- info: 'LambdaThreeSplit.observed_is_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms observed_is_count

/-- info: 'LambdaThreeSplit.sequestering_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms sequestering_witness

/-- info: 'LambdaThreeSplit.three_lambda_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms three_lambda_verdict

/-- info: 'LambdaThreeSplit.data_nondegenerate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms data_nondegenerate

end LambdaThreeSplit
