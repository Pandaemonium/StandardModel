# Summary of changes for run 26bd40d6-4659-49af-a182-e77657f3e565
Delivered the Suite D rung D1 mass resource-theory core in `RequestProject/Main.lean` (namespace `SuiteD_ResourceCore`) plus `ARISTOTLE_SUMMARY.md`. Everything is over ℝ with rational witnesses; no `Complex`, no `Real.sqrt`.

Definitions: `outer v0 v1` (the rank-one Gram `v vᵀ`), `gram a b c` (`!![a,b;b,c]`), and the `det` computations `det_outer`, `det_gram`.

Headline theorems (all four targets), each with an in-file `#guard_msgs (whitespace := lax) in #print axioms …` audit:
1. `free_states_characterized` — for a PSD symmetric Gram, `det = 0 ↔ ∃ r v0 v1, 0 ≤ r ∧ gram a b c = r • outer v0 v1`. Sqrt-free constructive witness read off the entries (`(a,b)`,`r=1/a` when `a≠0`; `(0,1)`,`r=c` when `a=0`), with the PSD hypotheses used exactly to give `r ≥ 0`.
2. `free_ops_preserve` — orthogonal congruence (`Oᵀ*O=1`) preserves `det`; instantiated at the rational 3-4-5 rotation via `rot345_orthogonal` and `free_ops_preserve_rot345`.
3. `mixing_creates` — `det (t•(u uᵀ)+(1-t)•(w wᵀ)) = t(1-t)(u0 w1 - u1 w0)^2`; `mixing_creates_pos` gives strict positivity for `t∈(0,1)` and non-collinear directions; `mixing_creates_345` is the mandatory instantiation `u=(1,0)`, `w=(3/5,4/5)`, `t=1/2` giving `det = 4/25`.
4. `resource_ordering` — packages 1–3: free operations preserve `det` and fix the zero-mass set, while mixing distinct null directions creates the exact Plücker amount of mass.

Verification: the project builds successfully (well under 3 minutes) with the target module explicitly built; a source scan confirms no `sorry`/`admit`/`native_decide`/`@[implemented_by]`/new axioms; and every headline's axiom footprint is exactly `[propext, Classical.choice, Quot.sound]` (confirmed both by the in-file guards and an independent check). Note: `free_states_characterized` was proved directly via the sqrt-free scalar decomposition, so the optional rank-≤-1 fallback route was not needed. All work is committed and pushed.

One subtlety worth flagging: the mandatory instantiation's second mixing weight must be annotated `(1 - 1/2 : ℝ)`; without the annotation Lean elaborates it as a natural-number scalar (`1 - 0 = 1`), changing the matrix. The delivered statement uses the real annotation and yields `det = 4/25`.

# Suite D rung D1 — the mass resource theory (`SuiteD_ResourceCore`)

File: `RequestProject/Main.lean`, namespace `SuiteD_ResourceCore`.

The mass of a null-edge program is read as `det P` of a REAL symmetric PSD `2×2`
direction Gram `P` (rational entries). This file develops the resource-theory core:
free states are the null (`det = 0`, rank-one) Grams, free operations are orthogonal
congruences (common rotations), and mass (`det`) is the resource monotone.

Everything is over `ℝ`; all concrete witnesses use rational entries. `Real.sqrt` and
`Complex` are avoided throughout, per the constraints.

## Definitions

- `outer v0 v1 = !![v0*v0, v0*v1; v0*v1, v1*v1]` — the rank-one Gram `v vᵀ`.
- `gram a b c = !![a, b; b, c]` — a generic symmetric `2×2` Gram.
- `det_outer`, `det_gram` — the two `det` computations (`det (outer …) = 0`,
  `det (gram a b c) = a*c - b*b`).

## Headline results (each with an in-file `#print axioms` audit)

1. **`free_states_characterized`** (Target 1). For a PSD symmetric Gram
   (`0 ≤ a`, `0 ≤ c`), `det (gram a b c) = 0 ↔ ∃ r v0 v1, 0 ≤ r ∧ gram a b c = r • outer v0 v1`.
   The free states are exactly the nonnegative multiples of a single rank-one direction
   `v vᵀ`. The witness is read off the entries with no square root: `v = (a, b)`, `r = 1/a`
   when `a ≠ 0`; `v = (0, 1)`, `r = c` when `a = 0`. This is the sqrt-free rendering of
   "rank ≤ 1 and PSD" (absorbing `√r` into `v` would reintroduce a square root). The
   PSD hypotheses are used exactly to give `r ≥ 0`.

2. **`free_ops_preserve`** (Target 2, "no free lunch"). For any orthogonal `O`
   (`Oᵀ * O = 1`) and any `P`, `det (O * P * Oᵀ) = det P`: free operations create no mass.
   Instantiated at the rational 3-4-5 rotation via `rot345_orthogonal`
   (`Oᵀ O = 1` for `O = !![3/5, -4/5; 4/5, 3/5]`) and `free_ops_preserve_rot345`.

3. **`mixing_creates`** (Target 3, the payload). For the mixture
   `P = t • (u uᵀ) + (1-t) • (w wᵀ)`,
   `det P = t (1-t) (u0 w1 - u1 w0)^2` — the `t(1-t)`-weighted squared wedge (Plücker
   disagreement). `mixing_creates_pos` gives strict positivity for `t ∈ (0,1)` and
   non-collinear directions (`u0 w1 - u1 w0 ≠ 0`). `mixing_creates_345` is the mandatory
   non-degeneracy instantiation: `u = (1,0)`, `w = (3/5, 4/5)`, `t = 1/2` yields
   `det P = 4/25 = (1/4)·(4/5)^2`.

4. **`resource_ordering`** (Target 4). Packages 1–3: free (orthogonal) operations both
   preserve `det` and fix the zero-mass (free-state) set, while mixing distinct null
   directions creates mass in the exact Plücker amount, strictly positive off the
   collinear locus.

## Constraints satisfied

- Kernel-checked only: no `sorry`/`admit`/`native_decide`, no new axioms, no
  `@[implemented_by]`. Every headline carries `#guard_msgs (whitespace := lax) in
  #print axioms …`, and all report footprint exactly `[propext, Classical.choice, Quot.sound]`.
- Mathlib only; REAL `2×2` matrices with rational entries; proofs use
  `ring`/`norm_num`/`field_simp`/`linear_combination`/`fin_cases` (the only `nlinarith`
  use is degree 2, `sq_nonneg b`). No `Complex`, no `Real.sqrt`.
- Builds in-project in well under 3 minutes.
