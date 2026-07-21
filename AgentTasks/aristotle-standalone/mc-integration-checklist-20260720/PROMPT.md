# Lemma job: a single machine-checked integration precondition bundle

Mathlib-only, abstract, scoped L2 operator norm on `Matrix (Fin 4) (Fin 4) C`.

Several audits produced a scattered list of side conditions for safely composing a
continuum ladder. Bundle them into ONE structure and ONE theorem, so an integrator
discharges a single hypothesis record instead of remembering a checklist.

Define a structure `LadderPreconditions` bundling:
- `W E : R -> Matrix (Fin 4) (Fin 4) C` with `hW : forall eps, W eps in unitaryGroup`,
  `hE : forall eps, E eps in unitaryGroup`;
- `hgroup : forall s t, E s * E t = E (s + t)` and `hid : E 0 = 1`;
- `hstep : forall eps, 0 <= eps -> eps <= 1 -> ||W eps - E eps|| <= c * eps^2`;
- `hc : 0 <= c`.
Then prove ONE theorem `LadderPreconditions -> forall t > 0, forall n > 0, t/n <= 1 ->
||(W (t/n))^n - E t|| <= c * t^2 / n`, and a `Tendsto` corollary.
Also prove: each field is INDEPENDENT - for each of `hW`, `hE`, `hgroup`, `hid`,
`hstep`, give a counterexample family satisfying all the others but not that one, for
which the conclusion FAILS. (If any field turns out to be derivable from the rest,
say so and prove it instead - that is an equally useful finding.)
No new axioms/native_decide; standard axioms; report axioms.
