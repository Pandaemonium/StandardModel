# Summary of changes for run 96cd8f7f-7c1a-4349-8b61-4a7fc9d830e3
Delivered the full chained "verified toy hadron" in `RequestProject/Main.lean` (namespace `Goal1Hadron`), a self-contained, Mathlib-only, clean-room development, plus `ARISTOTLE_SUMMARY.md`. It builds with `lake build RequestProject.Main` and is kernel-checked: no `sorry`/`admit`/`native_decide`/new `axiom`. Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]`.

All five rungs landed:

- Rung 1 (`confinement_dichotomy_12`): the 12-dim carrier `Cl(4) ⊗ C^3` on `Fin 4 × Fin 3` with Krein spin metric `eta4 = diag(1,1,-1,-1)` and hollow all-ones color form `Gcolor`, full form `M12 = eta4 ⊗ₖ Gcolor`. The color-singlet sector is positive-definite and the colored (traceless) sector is negative-definite; both sectors are genuine submodules with `0 < Module.finrank` pinned in the statement, and explicit nonzero witnesses are exhibited: singlet-positive vector `(1,1,1)` in physical spin 0, colored-negative vector `(1,-1,0)` in physical spin 0. The 2×3 toy lifts faithfully (no kill).
- Rung 2 (`H2_isHermitian`): the interacting two-body color-singlet-channel Hamiltonian `H2 = freeH2 + interaction` is constructed and proved Hermitian.
- Rung 3 (`rung3_bound_below_threshold`): for the explicit rational witness `d = (0,1,7)`, `κ = 4 ≠ 0` (a 3-4-5 holonomy, discriminant 25), the bound ground energy is exactly `-1`, is the least eigenvalue, and lies strictly below the two-constituent threshold `1`.
- Rung 4 (`rung4_positive_gap`): the exact spectrum is `{-1, 8, 9}`; `-1` is least, `8` and `9` are eigenvalues, every eigenvalue is `-1` or `≥ 8`, giving a strictly positive gap of `9` above the bound state (no gap closing).
- Rung 5 (`rung5_signed_budget`): the abstract signed budget `signed_budget_sum_one` plus a concrete witness using the indefinite Krein-weighted trace realizes shares summing to `1` with closure share exactly `b_C = -1/2 < 0` (binding as a negative closure share, the Ji-shaped statement), with `b_A = 3/2`, `b_T = 0`.

Scope/honesty (also in the summary file): this is a finite machine-verified toy, not a physical pion/rho prediction and no continuum claim. Rung 2's interaction form and Rung 5's budget blocks are modelled/witness-level constructions; Rung 5 is not dynamically tied to the Rung-3 eigenvector (that linkage would need the full Weitzenböck carrier-square assembly, outside the self-contained seeds). None of the four "kills" occurred. A few harmless `unusedSimpArgs` linter warnings remain in the matrix computations. All work is committed and pushed to `origin/main`.

# Goal I — The verified toy hadron

All work is in `RequestProject/Main.lean` (namespace `Goal1Hadron`), a
self-contained, Mathlib-only, clean-room port of the definitions needed from
`seeds/`. It is kernel-checked: **no `sorry` / `admit` / `native_decide` / new
`axiom`**. Every headline theorem is guarded in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>`, pinning the footprint to
exactly `[propext, Classical.choice, Quot.sound]`.

Build: `lake build RequestProject.Main`.

## Scope note (honest boundary)

This is a **machine-verified finite toy hadron**: a linear-algebra / small-matrix
spectral model on `Cl(4) ⊗ C^3`. It is **not** a physical pion/rho prediction and
makes **no continuum claim**. The interaction's attractive *form* and the Rung-5
budget blocks are *modelled* (constructed witnesses), not derived from first
principles; where a construction is witness-level rather than dynamically derived
it is flagged below.

## Rungs landed (all 5)

### Rung 1 — confinement dichotomy on the 12-dim carrier (`confinement_dichotomy_12`)
Carrier `Cl(4) ⊗ C^3` on `Fin 4 × Fin 3` (12-dim) with Krein spin metric
`eta4 = diag(1,1,-1,-1)` and the hollow all-ones color form `Gcolor`; full form
`M12 = eta4 ⊗ₖ Gcolor`, quadratic form `qval`.

Two sectors are defined as genuine submodules (`singletSector`, `coloredSector`),
each supported on the two physical (positive-signature) spins `{0,1}`:
- **Positive-definite** on the color-singlet sector (`singlet_posDef`).
- **Negative-definite** on the colored (traceless) sector (`colored_negDef`).

Mandatory non-degeneracy fixtures, all in the theorem statement:
- `0 < Module.finrank ℝ singletSector` and `0 < Module.finrank ℝ coloredSector`.
- Explicit **nonzero singlet witness** `singletWitness` = color `(1,1,1)` in
  physical spin `0`, with `0 < qval M12 singletWitness`.
- Explicit **nonzero colored witness** `coloredWitness` = color `(1,-1,0)` in
  physical spin `0`, with `qval M12 coloredWitness < 0`.

The `2×3` toy lifts faithfully to the 12-dim carrier (no kill).

### Rung 2 — the singlet two-particle sector (`H2_isHermitian`)
The interacting two-body (color-singlet channel) Hamiltonian
`H2 d κ = freeH2 d + interaction κ` on the 3 pair-occupation states over `Fin 3`
one-particle modes (pairs `{0,1},{0,2},{1,2}`); the closure interaction couples
the two pairs sharing the lowest mode. `H2_isHermitian` proves it is Hermitian.

### Rung 3 — below-threshold bound ground state (`rung3_bound_below_threshold`)
Explicit rational witness `d = (0,1,7)`, `κ = 4 ≠ 0` (a 3-4-5 holonomy:
discriminant `= 9 + 16 = 25`, `√ = 5`). Results, all exactly rational:
- ground/bound energy `boundEnergy dW kW = -1` (an `IsLeast` of the spectrum),
- two-constituent threshold `pairThreshold dW = 1`,
- strict binding `-1 < 1`.

### Rung 4 — positive many-body gap (`rung4_positive_gap`)
For the same witness, `H2 = !![1,-4,0; -4,7,0; 0,0,8]` has exact spectrum
`{-1, 8, 9}`:
- `-1` is the least eigenvalue (ground state), and `8`, `9` are eigenvalues,
- every eigenvalue is `-1` or `≥ 8`.
Hence a strictly positive gap `8 - (-1) = 9` above the bound state. (No gap
closing → no kill.)

### Rung 5 — signed channel budget with `b_C < 0` (`rung5_signed_budget`)
Abstract `signed_budget_sum_one` (over ℝ, any linear expectation `ev` with
`ev(D²) ≠ 0`): the aperture/closure/turn shares of `M² = 4·ev(D²)` sum to `1`,
shares signed.

Concrete witness realizing the **signed generality** with the indefinite
**Krein-weighted trace** `krTrace X = X₀₀ - X₁₁`:
- `Db = !![1,0;0,0]`, `QAb = !![5,0;0,-1]`, `QCb = !![-1,0;0,1]`, `QTb = 0`,
- Weitzenböck-type identity `4•(D²) = QA + QC + 4•QT` (`witness_id`),
- shares exactly rational: `b_A = 3/2`, **`b_C = -1/2 < 0`**, `b_T = 0`, summing
  to `1` — binding realized as a **negative closure share** (the Ji-shaped
  statement).

## Non-degeneracy witnesses / key data (summary)

- Singlet-positive vector: `singletWitness` = `(1,1,1)` color in physical spin 0.
- Colored-negative vector: `coloredWitness` = `(1,-1,0)` color in physical spin 0.
- Bound witness: `(d, κ) = ((0,1,7), 4)`, `κ ≠ 0`; `boundEnergy = -1 < 1 =` threshold.
- Bound-state channel budget: `b_C = -1/2 < 0`, with `b_A + b_C + b_T = 1`.

## Honesty flags

- Rung 2's interaction *form* (single off-diagonal coupling of scale `κ`) is
  modelled, matching the closure scale; it is not derived from the carrier's
  closure geometry.
- Rung 5 is a **witness-level** realization of the signed budget: the Krein
  expectation and the `QA/QC/QT` blocks are constructed to satisfy the identity
  and exhibit `b_C < 0` with exactly rational shares. It is not dynamically tied
  to the Rung-3 bound eigenvector; producing that linkage would require the
  full carrier-square (Weitzenböck) assembly, which is outside the available
  self-contained seeds.
