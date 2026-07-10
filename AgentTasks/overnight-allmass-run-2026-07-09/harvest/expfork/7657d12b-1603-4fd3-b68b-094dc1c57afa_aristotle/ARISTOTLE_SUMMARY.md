# Summary of changes for run 7657d12b-1603-4fd3-b68b-094dc1c57afa
Delivered `RequestProject/Main.lean` (namespace `LambdaExponentFork`) plus `ARISTOTLE_SUMMARY.md`. The build succeeds cleanly with no `sorry`/`admit`/`native_decide`/new axioms, using only rational arithmetic (`ring`/`rfl`/`norm_num`/`linarith`) — no `Real.rpow`/`log`/`sqrt`, no `Complex`, no `nlinarith`.

Model: `lamExp (alpha : ℚ) : ℚ := alpha / 2 - 1` (the Λ_rms scaling exponent as a rational function of the count-variance exponent, since Λ_rms = √(Var N)/N = N^{alpha/2−1}).

Proved:
1. `lamExp_closed` (closed form) and `lamExp_strictMono` (strictly increasing in alpha).
2. `everpresent_value`: `lamExp 1 = -1/2` (Poisson/extensive everpresent exponent).
3. Payload `hyperuniform_faster`: `alpha < 1 → lamExp alpha < -1/2` (hyperuniform decays strictly faster, so the 10⁻¹²² number is not reproduced); `superextensive_slower`: `1 < alpha → -1/2 < lamExp alpha`.
4. Payload `fork_iff`: `lamExp alpha = -1/2 ↔ alpha = 1` (everpresent exponent realized iff count exactly extensive — decidable on the single exponent).
5. `exponent_fork_verdict`: packages the equivalence, both strict directions, and monotonicity.

Non-degeneracy witnesses with explicit rationals are included: `lamExp 1 = -1/2`, `lamExp (1/2) = -3/4 < -1/2`, `lamExp 2 = 0 > -1/2`.

Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>`, and all confirm the axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`. Honest scope is documented: this is the decidable exponent arithmetic; it does not derive which alpha nature realizes, and the Lorentz-violation (Bombelli–Henson–Sorkin) tie is imported context, not proved here.

# Lambda-Exponent Fork — summary

File: `RequestProject/Main.lean`, namespace `LambdaExponentFork`.

## Model

The Λ_rms scaling exponent as a rational function of the count-variance exponent `alpha`:

```
lamExp (alpha : ℚ) : ℚ := alpha / 2 - 1
```

This comes from `Λ_rms = sqrt(Var N)/N = N^{alpha/2}/N = N^{alpha/2 - 1}` with `Var(N) ~ N^alpha`.
Everything is done with the exponents themselves as rationals (`ℚ`); no `Real.rpow`/`log`/`sqrt`,
no `Complex`, no `nlinarith`.

## Results proved (kernel-checked, no `sorry`)

1. `lamExp_closed` — `lamExp alpha = alpha/2 - 1` (`rfl`).
   `lamExp_strictMono` — strictly increasing: `alpha1 < alpha2 → lamExp alpha1 < lamExp alpha2` (`linarith`).
2. `everpresent_value` — `lamExp 1 = -1/2` (Poisson/extensive everpresent exponent, `norm_num`).
3. `hyperuniform_faster` (payload) — `alpha < 1 → lamExp alpha < -1/2` (hyperuniform decays strictly
   faster than `1/sqrt(N)`, so the `10^-122` number is not reproduced).
   `superextensive_slower` — `1 < alpha → -1/2 < lamExp alpha`.
4. `fork_iff` (payload) — `lamExp alpha = -1/2 ↔ alpha = 1` (the everpresent exponent is realized iff
   the count is exactly extensive; decidable on the single measurable exponent).
5. `exponent_fork_verdict` — packages the equivalence, both strict directions, and monotonicity.

Non-degeneracy witnesses (explicit rationals): `witness_everpresent` (`lamExp 1 = -1/2`),
`witness_hyperuniform` (`lamExp (1/2) = -3/4 < -1/2`), `witness_superextensive`
(`lamExp 2 = 0 > -1/2`).

## Axiom footprint

Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>`, all
confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

## Honest scope

This is the exponent arithmetic — a decidable pre-registered kill-condition. It does not derive which
`alpha` nature realizes (remains a conjecture), and the Lorentz-violation tie for `alpha < 1`
(Bombelli–Henson–Sorkin) is imported context, not proved here.
