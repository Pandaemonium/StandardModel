# Claude adversarial cross-family review: ChangingCellFourierTemperate (06176494)

- Reviewer: interactive Claude Code (claude family), adversarial pass
- Builder: Codex (Aristotle 06176494 in-progress snapshot, non-cancellable build loop)
- Work item: `CONT-FOURIER-001`
- Source: `PhysicsSM/Draft/NullEdge/ChangingCellFourierTemperate.lean` (547 lines),
  sha256 249e40a0... verified
- Date: 2026-07-13

## Verdict: ACCEPT

Genuine, substantial, correctly-scoped. No vacuity, false shape, or hidden trust.

## The five required checks

1. **Genuine exact multiplier on full R^3.** `momMultForGrowth m t k =
   toEuclideanCLM (exactFlow (k 0)(k 1)(k 2) m t)` over all of
   `FourierMomentum3`, with no restriction, cutoff, or toy domain. It wraps the
   SAME `exactFlow` used by the rest of the lane (the local name only avoids
   collision with the active F2 job, per docstring). The theorem
   `momMultForGrowth_hasTemperateGrowth : HasTemperateGrowth (momMultForGrowth m t)`
   is the honest full-space statement.

2. **Closed form: correct sign and `t^2 * Q` scaling.** `H_sq` proves the
   Clifford relation `H^2 = Q * 1` with `Q = kx^2+ky^2+kz^2+m^2`. With
   `X = -(t) * (I*H) = -i t H`, `X^2 = (-it)^2 H^2 = -t^2 * (Q*1) = -(t^2 Q)*1`.
   For `X^2 = -(a)*1` with `a = t^2 Q >= 0`,
   `exp(X) = cos(sqrt a)*1 + (sin(sqrt a)/sqrt a)*X = cosCoef(a)*1 + sincCoef(a)*X`.
   `exactFlow_closed_form` proves exactly
   `exactFlow = cosCoef(t^2 Q)*1 + sincCoef(t^2 Q)*(-(t)*(I*H))` via the
   even/odd power-series split (`tsum_even_add_odd`) with `Real.summable_pow_div_factorial`
   side-conditions. Sign and scaling correct.

3. **Bounded-derivative + smoothing-surrogate; non-vacuous, right shape.** The
   crux, handled correctly: because `Q >= 0`, the argument `t^2 Q` is always in
   the BOUNDED branch of the entire coefficient functions
   (`cosCoef(u)=cos(sqrt u)`, `sincCoef(u)=sin(sqrt u)/sqrt u` for `u>=0`),
   NEVER the `cosh`/`sinh` branch for `u<0` that would give a false
   `exp(C||k||)` envelope. `cosCoef_iteratedDeriv_bddOn` /
   `sincCoef_iteratedDeriv_bddOn` bound every iterated derivative on `[0,inf)`
   (each n-th derivative is a polynomial in `1/sqrt u` times bounded cos/sin for
   `u>=1`; continuous on the compact `[0,1]` otherwise). The composition lemma
   `hasTemperateGrowth_comp_nonneg` builds a smoothing surrogate
   `g' = g * smoothTransition(u+1)` that AGREES with `g` on `[0,inf)` (transition
   = 1 for `u>=0`) but has GLOBALLY bounded derivatives (identically 0 below -1,
   compact `[-1,0]`, `= g` above 0), so `g'` has temperate growth (k=0), and
   `g' o phi = g o phi` because `phi = t^2 Q >= 0`. Then
   `HasTemperateGrowth.comp` gives the result. This genuinely produces Mathlib
   `HasTemperateGrowth` (k, C exist); not vacuous, not a false shape.

4. **No hidden trust; guards fire.** No `sorry`/`admit`/`native_decide`/`axiom`/
   `opaque`. The `set_option ... maxHeartbeats` lines are elaboration-budget
   increases for a heavy proof, NOT trust expansions (they do not touch the axiom
   footprint). Three in-file `#guard_msgs` blocks
   (`momMultForGrowth_hasTemperateGrowth`, `..._zero_time`, `..._345_dispersion`)
   pin `[propext, Classical.choice, Quot.sound]`. The main theorem's clean
   footprint transitively certifies every intermediate lemma (a hidden `sorry`
   would propagate into it).

5. **Scope = Schwartz-multiplier hypothesis, not PDE.** The result is temperate
   growth, which is exactly the hypothesis `SchwartzMap.bilinLeftCLM` needs to
   multiply a Schwartz spinor by the flow. The docstring explicitly frames it as
   "the missing hypothesis" and does NOT claim Schwartz closure (the next F3
   step) or a position-space PDE limit. Honest, if anything conservative.

## Overclaim tests

Vacuity: none -- `HasTemperateGrowth` genuinely established; `momMultForGrowth_345_dispersion`
(`Qform 3 4 0 m = 25 + m^2`) and `_zero_momentum` show a nontrivial
momentum-dependent multiplier. Hollow telescoping: none -- the proof does real
work (Clifford square, power-series closed form, poly-in-1/sqrt-u derivative
bounds, smoothing surrogate, composition, operator transport). Docstring
overreach: none. False shape: none -- temperate growth of the genuine exact
multiplier over full momentum space is the correct object.

## Minor (non-blocking)

`momMultForGrowth_zero_momentum` (line ~519) has no `#guard_msgs` block, unlike
the other three declarations. It is a trivial substitution control, sorry-free
and transitively covered by the build and the main guard, so this is a
completeness nit only. Consider adding a fourth guard at bank for uniformity.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.ChangingCellFourierTemperate`: Build
  completed successfully (8043 jobs), exit 0. The whole 547-line proof
  kernel-checks and all three `#guard_msgs` blocks fired and passed; axiom
  footprint `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest defensible claim

For each mass `m` and time `t`, the exact Dirac momentum multiplier
`k |-> toEuclideanCLM(exp(-i t H(k)))`, as an operator-valued function on the
full momentum space `FourierMomentum3`, has temperate growth (Mathlib
`Function.HasTemperateGrowth`). The proof rests on the Clifford closed form and
on `Q(k) >= 0` keeping the entire coefficient functions in their bounded branch.
This is the temperate-growth hypothesis feeding `SchwartzMap.bilinLeftCLM`; it
does NOT itself prove Schwartz-space closure of the multiplier or any
position-space PDE limit.
