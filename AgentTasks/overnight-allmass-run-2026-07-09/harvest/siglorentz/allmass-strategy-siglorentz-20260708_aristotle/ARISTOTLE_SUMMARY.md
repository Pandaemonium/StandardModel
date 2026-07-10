# Summary of changes for run 6c57c19a-29ff-4963-8eea-5e93cafea86d
**Verdict: landed.** I built the smallest explicit Osterwalder–Schrader reflection-positivity toy and proved the rung-2 selection statement — reflection positivity + a nondegenerate physical sector picks out exactly one time direction. Everything is in `RequestProject/Main.lean` (namespace `NullEdgeRP`), builds cleanly, and is kernel-checked with no `sorry`/`admit`/`axiom`/`native_decide`; the in-file `#print axioms` guard confirms all results have footprint `[propext, Classical.choice, Quot.sound]`. Mathlib only.

**The toy.** Directions `Fin 4`; signature `sig : Fin 4 → Bool` (`true` = time); reflection across direction `0` on the smallest two-site lattice `{+,-}`. A single Gaussian mode has action kernel `K = !![a,-1;-1,a]` with on-site energy² `a = onSite = 1 + m² + Σ_{μ≠0} σ(μ)·k μ`, where each further time direction enters with a **negative** sign. The covariance is `C = K⁻¹`, and the OS reflection Gram is the reflected cross two-point `reflGram = C 1 0`, shown in closed form to equal `(a²−1)⁻¹` (`reflGram_eq`).

**Theorems proved.**
- `oneTime_reflectionPositive` — the `(1,3)` toy (direction 0 the only time, `m ≠ 0`) is reflection positive with a strictly positive, nondegenerate physical sector.
- `twoTime_reflectionPositive_fails` — the kill: any signature with a second time direction (in particular `(2,2)`) has an admissible momentum where `reflGram < 0`, so no `(2,2)` toy passes OS positivity with a nondegenerate physical sector.
- Bonus stability: `oneTime_actionKernel_posDef` (kernel positive definite for `(1,3)`) and `twoTime_actionKernel_not_posDef` (kernel indefinite at the `(2,2)` counterexample).

**Honesty notes** (also in `ARISTOTLE_SUMMARY.md`): this is a deliberately minimal single-mode, two-site toy — faithful to the OS structure (reflection, Gaussian action, covariance = inverse action, reflected cross two-point = reflection Gram) and isolating the signature mechanism (an extra time direction makes the physical energy² negative, driving the reflection Gram below zero), but not a full lattice OS reconstruction. The hypothesis `sig 0 = true` in the `(1,3)` theorem pins the signature and records that we reflect across a time direction; it is unused by the proof (a harmless unused-variable warning remains) and kept for a faithful statement, as documented in the docstring.

# ARISTOTLE_SUMMARY — Reflection positivity selects Lorentzian (signature rung 2)

## Verdict

**Landed.** The finite Osterwalder–Schrader (OS) reflection-positivity toy is built
explicitly for arbitrary signatures, and both target theorems are proved, kernel-checked,
`sorry`/`admit`/`axiom`/`native_decide`-free, with the requested axiom footprint
`[propext, Classical.choice, Quot.sound]` verified in-file. Mathlib only.

All results are in `RequestProject/Main.lean` (namespace `NullEdgeRP`).

## What "exactly one time" now is

Rung 1 (prior work) showed a nonzero null edge forces an *indefinite* Gram, without
distinguishing `(1,3)` from `(2,2)`. Rung 2 asks *why exactly one time*. This file turns
that probe into a finite RP-selection statement: the `(1,3)` toy is reflection positive
with a nondegenerate physical sector, and **any** signature with a second time direction
(in particular `(2,2)`) fails reflection positivity.

## The toy (the smallest one that carries the distinction)

* Directions `Dir := Fin 4`. A signature is `sig : Dir → Bool` (`true` = time). Direction
  `0` is the distinguished direction we reflect across (Euclidean time); we assume
  `sig 0 = true`.
* Smallest lattice along the reflected direction: **two sites** `{+, -}` with the
  reflection swapping them.
* Single physical mode with Gaussian action kernel `K = !![a, -1; -1, a]`, where the
  on-site term is the discrete energy²
  `a = onSite m sig k = 1 + m² + Σ_{μ ≠ 0} σ(μ)·k μ`, with `σ(μ) = -1` for a time
  direction and `+1` for a space direction, at momenta `k ≥ 0`. **Each extra time
  direction contributes with a negative sign** — the whole mechanism.
* Covariance `C = K⁻¹`; the OS **reflection Gram** is the reflected cross two-point value
  `reflGram = C 1 0` (the `1×1` physical-sector reflection form).
* `reflGram_eq`: in closed form `reflGram = (a² − 1)⁻¹`.

Definitions: `ReflectionPositive m sig := ∀ k ≥ 0, 0 ≤ reflGram` and
`Nondegenerate m sig := ∀ k ≥ 0, 0 < reflGram`.

## Theorems proved

* `oneTime_reflectionPositive` — **(1,3) passes.** If `m ≠ 0`, `sig 0 = true`, and every
  other direction is space, then `ReflectionPositive m sig ∧ Nondegenerate m sig`: the
  reflection Gram is strictly positive at every admissible momentum (`a ≥ 1 + m² > 1`, so
  `(a²−1)⁻¹ > 0`). Nondegenerate physical sector.
* `twoTime_reflectionPositive_fails` — **(2,2) fails (the kill).** If there is a second
  time direction `j ≠ 0` with `sig j = true`, then there is an admissible momentum
  (`k j = 1 + m²`, else `0`) at which `reflGram < 0` (there `a = 0`, so
  `reflGram = -1`). Reflection positivity is violated; no such toy passes OS positivity
  with a nondegenerate physical sector. This covers `(2,2)` (and any signature with ≥ 2
  times).

### Stability (bonus)

* `oneTime_actionKernel_posDef` — for `(1,3)` the action kernel is positive definite at
  every admissible momentum (stable Gaussian measure).
* `twoTime_actionKernel_not_posDef` — at the counterexample momentum the action kernel is
  not positive definite (its determinant `a² − 1 = −1 < 0`), so it is indefinite.

## Honesty / scope notes

* This is a deliberately minimal toy: a single physical mode on the smallest two-site
  reflected lattice. It is faithful to the OS structure (reflection across a distinguished
  direction, Gaussian action, covariance = inverse action, reflected cross two-point =
  reflection Gram), and it isolates the signature mechanism: an additional time direction
  enters the physical energy² with a negative sign, pushing the on-site term below the
  stability threshold `a = 1` and driving the reflection Gram negative. It is not a
  full-lattice OS reconstruction; it is the smallest object in which "exactly one time"
  becomes an RP-positivity fact.
* The hypothesis `sig 0 = true` in `oneTime_reflectionPositive` records that we reflect
  across a time direction and pins the signature to exactly `(1,3)`; it is not needed by
  the proof (a harmless unused-variable warning remains) but is kept for a faithful
  statement, as noted in the docstring.
* Axiom footprint is checked in-file via `#print axioms` for all five results; each
  reports exactly `[propext, Classical.choice, Quot.sound]`.
