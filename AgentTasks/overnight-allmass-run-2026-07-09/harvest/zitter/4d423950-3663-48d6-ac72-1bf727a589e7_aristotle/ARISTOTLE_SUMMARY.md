# Summary of changes for run 4d423950-3663-48d6-ac72-1bf727a589e7
Delivered `RequestProject/Main.lean` (namespace `ZitterbewegungAverage`) plus `ARISTOTLE_SUMMARY.md`. The file builds cleanly under Mathlib with no `sorry`/`admit`/`native_decide`/new axioms, no `Real.sqrt`, no `Complex`, and no high-degree `nlinarith` (proofs use `ring`/`norm_num`/`linear_combination`/`field_simp`/`linarith`).

Model: two luminal channels with weights `w₊ = (1+p/E)/2`, `w₋ = (1−p/E)/2` (Dirac imbalance `w₊−w₋ = p/E`), drift `vbar = w₊−w₋`, parametrized over rational Pythagorean shells `p²+m²=E²`.

Theorems proved (all with in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming footprint exactly `[propext, Classical.choice, Quot.sound]`):
- `weights_sum_one`: `w₊ + w₋ = 1`.
- `mean_velocity_eq_p_over_E` (Target 1): `vbar = p/E` and, for `|p| ≤ E`, `0 ≤ w₊,w₋ ≤ 1`.
- `drift_subluminal_from_average` (Target 2, payload): on the shell, `vbar² = (p/E)² = 1 − m²/E²`.
- `massless_limit` (Target 3): `m=0` (p=E) ⇒ `w₋=0`, `w₊=1`, `vbar=1`.
- `rest_limit` (Target 3): `p=0` ⇒ `w₊=w₋=1/2`, `vbar=0`.
- `zitterbewegung_verdict` (Target 4): packages valid convex weights, `vbar=p/E`, `vbar²=1−m²/E²`.
- `instance_345` (mandatory non-degeneracy): explicit rationals at `(m,p,E)=(3,4,5)`: `w₊=9/10`, `w₋=1/10`, `vbar=4/5`, `vbar²=16/25=1−9/25`, `4²+3²=5²`.

Scope stated honestly in the docstring and summary: a finite 2-channel algebraic model tying the instantaneous-±c and drift-subluminal facts together as one exact convex-averaging identity, not a derivation from the Dirac equation. All work committed and pushed.

# Zitterbewegung averaging — summary

`RequestProject/Main.lean` (namespace `ZitterbewegungAverage`) formalizes a finite,
`sqrt`-free, purely rational algebraic model reconciling the two "landed halves":

* instantaneous velocity is always ±c (velocity-operator eigenvalues ±1), and
* the observable drift is subluminal, `‖v‖² = 1 − m²/E²`.

The bridge is Zitterbewegung: the drift is the convex (time-)average of the ±c luminal
motion, with the mass setting the mixing.

## Model

Two luminal channels — a right-mover (`+1`) and a left-mover (`−1`) — with weights `w₊, w₋`,
`w₊ + w₋ = 1`. The occupation imbalance is fixed to the physical Dirac value `w₊ − w₋ = p/E`,
so `w₊ = (1 + p/E)/2`, `w₋ = (1 − p/E)/2`. The drift is `vbar = w₊·(+1) + w₋·(−1) = w₊ − w₋`.
To avoid square roots, `(m, p, E)` ranges over rational Pythagorean shells `p² + m² = E²`.

## Results (all kernel-checked, no `sorry`)

- `weights_sum_one` — `w₊ + w₋ = 1`.
- `mean_velocity_eq_p_over_E` (Target 1) — `vbar = p/E`, and for `|p| ≤ E`, `0 ≤ w₊, w₋ ≤ 1`
  (valid convex weights).
- `drift_subluminal_from_average` (Target 2, payload) — on the shell `p² + m² = E²`,
  `vbar² = (p/E)² = 1 − m²/E²`: the subluminal drift is the square of a convex average of ±1.
- `massless_limit` (Target 3) — `m = 0` (shell `p = E`): `w₋ = 0`, `w₊ = 1`, `vbar = 1`
  (a single luminal channel, no zigzag).
- `rest_limit` (Target 3) — `p = 0` (rest, `m = E`): `w₊ = w₋ = 1/2`, `vbar = 0`
  (a 50/50 ±c zigzag averaging to zero).
- `zitterbewegung_verdict` (Target 4) — packages the above: valid convex distribution,
  `vbar = p/E`, and `vbar² = 1 − m²/E²`.
- `instance_345` — mandatory non-degeneracy at `(m, p, E) = (3, 4, 5)`:
  `w₊ = 9/10`, `w₋ = 1/10`, `vbar = 4/5`, `vbar² = 16/25 = 1 − 9/25`, `4² + 3² = 5²`.

Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check
confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

## Honest scope

This is a finite 2-channel algebraic model, not a derivation from the Dirac equation. It ties
the instantaneous-±c and drift-subluminal facts together as one exact convex-averaging
identity over rational Pythagorean triples. No `Real.sqrt`, no `Complex`; proofs use only
`ring`/`norm_num`/`linear_combination`/`field_simp`/`linarith`.
