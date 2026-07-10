# Summary of changes for run 48afb5f0-968a-45a5-9744-f539d0a4d698
Delivered `RequestProject/Main.lean` (namespace `VacuumSequestering`) plus `ARISTOTLE_SUMMARY.md`, building cleanly with no `sorry`/`admit`/`native_decide`/new axioms.

## Model (explicit rational, n = 3)
- `Sq = Matrix (Fin 3) (Fin 3) ℚ` operators; `Vec = Fin 3 → ℚ` states.
- `Vol x = ⟨x,x⟩`, `Action A x = ⟨x, A x⟩`, `LambdaFluc N δN = δN/N`, and `physicalLambda A c N δN = LambdaFluc N δN` (built to be blind to A, c).

## Theorems proved
1. `shift_absorbed_by_multiplier` — from `A x = Λ x`, deduces `(A + c·1) x = (Λ + c) x`: the vacuum shift preserves the stationary state and is absorbed into the multiplier. `multiplier_absorbs_shift` records via `HasDerivAt` that the multiplier depends on c with derivative 1.
2. `physical_lambda_shift_invariant` (payload) — `physicalLambda` is independent of the operator A and shift c for all choices; the observable is a function of the counts only.
3. `sequestering_gap` — honest boundary in two halves: on the constraint surface the vacuum mean `a0·1` shifts the action by the pure constant `a0·v0` (gauge), while the observable is the count fluctuation blind to the operator.
4. `sequestering_verdict` — packages shift-absorption + mean-is-gauge + operator-blindness.
5. `sequestering_nondegeneracy` (mandatory non-degeneracy) — explicit `A = diag(1,2,3)`, `x0 = (1,0,0)`, `v0 = 1`, huge shift `c = 10^6`: `x0` stationary with `Λ = 1`, `Vol x0 = 1`, shift sends `Λ ↦ 1 + 10^6` (same eigenvector), while the physical residue (`N = 100`, `δN = 10`, i.e. `δN² = 100`) equals `1/10` both before and after the shift.

## Constraints met
- Real rational matrices/vectors; proofs via `ring`/`norm_num`/`simp`/`fin_cases` plus one `HasDerivAt` line; no Complex, no Real.cos/sin.
- Each of the five headlines carries `#guard_msgs (whitespace := lax) in #print axioms …`, all reporting footprint exactly `[propext, Classical.choice, Quot.sound]`; these guards pass in-build.
- Builds in well under the time budget (single module ~16s).

Honest scope (stated in the file docstring): a finite n-dimensional avatar; it does not derive the numerical value of Λ nor prove the full continuum sequestering mechanism (Kaloper–Padilla). Work committed and pushed to `origin`.

# Vacuum sequestering — the finite magnitude theorem

A self-contained, fully explicit rational (`ℚ`) avatar of *vacuum sequestering*:
a uniform local vacuum shift `A ↦ A + c·1` is absorbed by the volume/unimodular
constraint and cannot change the physical, count-fluctuation cosmological constant.

All results live in `RequestProject/Main.lean`, namespace `VacuumSequestering`.

## Model (explicit, `n = 3`)

- `Sq := Matrix (Fin 3) (Fin 3) ℚ` — dynamical operators; `Vec := Fin 3 → ℚ` — states.
- `Vol x = ⟨x, x⟩` — volume/count constraint functional.
- `Action A x = ⟨x, A x⟩` — the operator's quadratic form.
- `LambdaFluc N δN = δN / N` — the physical count-fluctuation residue.
- `physicalLambda A c N δN = LambdaFluc N δN` — physical `Λ` presented as a nominal
  function of operator/shift/counts, built to be blind to `A` and `c`.

## Theorems

1. **`shift_absorbed_by_multiplier`** — if `A x = Λ x` (the Lagrange stationarity
   condition on the constraint surface), then `(A + c·1) x = (Λ + c) x`: the vacuum
   shift preserves the stationary state and is absorbed into the multiplier.
   `multiplier_absorbs_shift` records (via `HasDerivAt`) that the multiplier depends
   on `c` with derivative `1` — absorbed exactly into the integration constant.
2. **`physical_lambda_shift_invariant`** (payload) — `physicalLambda` is independent
   of the operator `A` and shift `c` for all choices: the observable is a function of
   the counts only, so no local vacuum shift can move it.
3. **`sequestering_gap`** — the honest boundary in two halves: on the constraint
   surface the vacuum **mean** `a0·1` shifts the action by the pure constant `a0·v0`
   (gauge/unobservable, via `vacuum_mean_shifts_action`), while the **observable** is
   the count fluctuation, blind to the operator.
4. **`sequestering_verdict`** — the packaged finite magnitude theorem combining
   (i) shift absorption, (ii) mean-is-gauge, (iii) operator-blindness of the observable.

## Mandatory non-degeneracy — `sequestering_nondegeneracy`

Explicit `A = diag(1,2,3)`, `x0 = (1,0,0)`, `v0 = 1`, and a **huge** shift `c = 10^6`:
`x0` is stationary with `Λ = 1`; `Vol x0 = 1`; the shift sends `Λ = 1 ↦ 1 + 10^6`
(same eigenvector); and the physical residue (`N = 100`, `δN = 10`, i.e. `δN² = 100`)
equals `1/10` **both before and after** the huge shift. The enormous vacuum shift
leaves the physical `Λ` at `1/10`.

## Verification / constraints met

- Builds under the time budget with **no `sorry`/`admit`/`native_decide`/new axiom**.
- Real rational matrices/vectors; proofs via `ring`/`norm_num`/`simp`/`fin_cases`
  plus one `HasDerivAt` line; no `Complex`, no `Real.cos`/`sin`.
- Each headline carries `#guard_msgs (whitespace := lax) in #print axioms …`, all
  reporting footprint exactly `[propext, Classical.choice, Quot.sound]`.

## Honest scope

A finite `n`-dimensional avatar. It does **not** derive the numerical value of `Λ`,
nor prove the full continuum sequestering mechanism (Kaloper–Padilla). It isolates the
structural blindness of the observable to local vacuum shifts.
