# Summary of changes for run 5c8b9302-4972-4a9f-bb28-7dcc77ae0a93
Delivered `RequestProject/Main.lean` (namespace `NeutrinoSeesaw`) and `ARISTOTLE_SUMMARY.md`, formalizing a finite 2×2 avatar of the type-I seesaw over ℝ (real, so the eigenvalue hypotheses are genuinely satisfiable — not vacuous). No square roots, no `Complex`; only `det`/`trace`/Vieta and order/field arithmetic (`linarith`, `linear_combination`, `div_lt_div_of_pos_left`, `norm_num`, `positivity`), all degree ≤ 2. No `nlinarith`, no `sorry`/`admit`/`native_decide`, no new axioms.

Model: `M mD MR = !![0, mD; mD, MR]` — active–active entry 0 (no bare Majorana), Dirac off-diagonal `mD`, sterile Majorana `MR`; eigenvalues solve `lam^2 - MR*lam - mD^2 = 0`.

Results:
- `char_vieta`: `det M = -mD^2`, `trace M = MR` (Vieta data of `X^2 - MR·X - mD^2`).
- `eig_vieta`: two distinct roots give `lp·ln = -mD^2` and `lp + ln = MR`.
- `opposite_signs`: product `-mD^2 < 0` forces opposite signs (light neutrino vs heavy partner).
- `seesaw_bound` (payload): light mass suppressed, `|ln| = -ln < mD^2/MR`, proved via `lp = MR - ln > MR > 0` and `-ln = mD^2/lp < mD^2/MR` — no root formula.
- `seesaw_verdict`: package — `0 < lp`, `ln < 0`, product pinned `lp·(-ln) = mD^2`, and `|ln| < mD^2/MR`.
- Non-degeneracy in-theorem: `nondegen_suppressed` (`mD=1, MR=100` ⇒ `lp>100`, `|ln|<1/100`) and control `nondegen_control` (`mD=MR=1` ⇒ `|ln|<1`, not small), showing the suppression is MR-driven.

Every headline carries `#guard_msgs (whitespace := lax) in #print axioms <thm>`, each confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. `lean_build` on `RequestProject.Main` succeeds (~14s) and a grep confirms no `sorry`/`nlinarith` remain. Committed and pushed.

Honest scope (also in the docstrings/summary): a finite real 2×2 avatar of the type-I seesaw — the product of the two masses is fixed at `mD^2` and the light one is bounded by `mD^2/MR`, a structural suppression, not a prediction of the physical neutrino mass.

# NeutrinoSeesaw — a finite rational 2×2 avatar of the type-I seesaw

All results live in `RequestProject/Main.lean`, namespace `NeutrinoSeesaw`.
Everything is kernel-checked: no `sorry`/`admit`/`native_decide`, no new axioms.
The footprint of every headline result is exactly `[propext, Classical.choice, Quot.sound]`,
asserted in-file with `#guard_msgs (whitespace := lax) in #print axioms <thm>`.

Base field: `ℝ` (real, so the eigenvalue hypotheses are genuinely satisfiable — not vacuous).
No `Real.sqrt`, no `cos`/`sin`, no `Complex`; only `det`/`trace`/Vieta and order/field arithmetic
(`linarith`, `linear_combination`, `div_lt_div_of_pos_left`, `norm_num`, `positivity`), all degree ≤ 2.

## The model

`M mD MR = !![0, mD; mD, MR]`: symmetric mass matrix mixing a light active state (active–active
entry `0`, no bare Majorana mass) with a heavy sterile partner (Majorana mass `MR`) via the Dirac
mass `mD`. Eigenvalues `lam` solve `lam^2 - MR*lam - mD^2 = 0`; we use only their symmetric
functions (product/sum), never the square-root root formula.

## Results

1. `char_vieta` — `det (M mD MR) = -mD^2` and `trace (M mD MR) = MR` (the Vieta data of the
   characteristic polynomial `X^2 - MR*X - mD^2`), directly from the explicit entries.
2. `eig_vieta` — two distinct roots `lp ≠ ln` of `lam^2 - MR*lam - mD^2 = 0` satisfy Vieta:
   `lp*ln = -mD^2` and `lp + ln = MR`.
3. `opposite_signs` — since `lp*ln = -mD^2 < 0` (with `mD ≠ 0`), the eigenvalues have opposite
   signs (one positive, one negative): the light neutrino and its heavy partner.
4. `seesaw_bound` (payload) — labelling `ln < 0` the light eigenvalue, its magnitude is suppressed:
   `-ln < mD^2 / MR`. Proof with no square roots: `lp = MR - ln > MR > 0` (trace, `ln < 0`) and
   `-ln = mD^2 / lp < mD^2 / MR` (det + `0 < MR < lp`).
5. `seesaw_verdict` — the package: `0 < lp`, `ln < 0`, product of the two masses pinned at
   `lp*(-ln) = mD^2`, and light mass bounded `-ln < mD^2 / MR`.

## Non-degeneracy (in-theorem)

- `nondegen_suppressed` — `mD = 1, MR = 100`: any pair with `lp*ln = -1`, `lp+ln = 100`, `ln < 0`
  has `lp > 100` and `|ln| < 1/100` (strong `MR`-driven suppression).
- `nondegen_control` — `mD = MR = 1` (no hierarchy): `|ln| < 1` still holds but is not small,
  demonstrating the suppression is genuinely `MR`-driven.

## Honest scope

A finite real `2×2` avatar of the type-I seesaw: the product of the two masses is fixed at `mD^2`
and the light one is bounded by `mD^2/MR` — a structural suppression, not a prediction of the
physical neutrino mass.
