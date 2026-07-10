# Summary of changes for run 8a3aaa82-5b60-48df-837f-3032de15c98b
Delivered `RequestProject/Main.lean` (namespace `MassPhase4Channel`) plus `ARISTOTLE_SUMMARY.md`, fully kernel-checked: no `sorry`/`admit`/`native_decide`/new axioms, no `Complex`, no `Real.sqrt`; build ≈28s. Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

The model is the real symmetric rational 3×3 block
`Bc = [[lam+E, kap, tau],[kap, lam+E, 0],[tau, 0, lam+E]]`
combining aperture `lam` (diagonal), closure `kap` (the landed off-diagonal), chiral turn `tau` (second off-diagonal), soldering `E` (diagonal shift). Its quadratic form is `Q(x)=xᵀBc x` (`Q_eq_quadForm`, `Bc_isSymm`), and everything is powered by one SOS identity `key_identity`: `d·Q = (d·x0+kap·x1+tau·x2)² + (tau·x1−kap·x2)² + (d²−kap²−tau²)(x1²+x2²)`, `d=lam+E`.

Targets:
1. `spectrum_closed_form`: `det(μI−Bc) = (μ−d)((μ−d)²−(kap²+tau²))`, so eigenvalues are `d`, `d±√(kap²+tau²)`; `eigen_d` exhibits `d` with rational eigenvector `(0,tau,−kap)`. The least eigenvalue m²=d−√(kap²+tau²) has its sign captured sqrt-free via the quadratic form.
2. `phase_predicates`: `Massive` (Q pos-def, m²>0), `Critical` (PSD with kernel, m²=0), `Ghost` (negative direction, m²<0), proved exhaustive (`phases_exhaustive`) and pairwise exclusive (`not_massive_critical`, `not_massive_ghost`, `not_critical_ghost`).
3. `phase_boundaries`: `massive_iff`/`critical_iff`/`ghost_iff` give closed-form squared criteria; the critical surface is `kap²+tau² = (lam+E)²`, `lam+E ≥ 0`, generalising the landed `|kap|=lam` (recovered at tau=E=0). Crossing it changes the phase (concrete witnesses below).
4. `channel_roles`: monotonicity of the margin `(lam+E)²−(kap²+tau²)` — `aperture_raises`, `soldering_raises` (mass generator/shift), `closure_reduces`, `turn_reduces` (mass reducers) — plus concrete crossings `aperture_generates_mass`, `closure_reduces_mass`, `turn_reduces_mass`, `soldering_shifts_mass`.

Mandatory rational witnesses with computed m²: `witness_massive` (1,0,0,0), spectrum {1,1,1}, m²=1>0; `witness_critical` (1,1,0,0), spectrum {0,1,2}, m²=0, kernel (1,−1,0); `witness_ghost` (1,2,0,0), spectrum {−1,1,3}, m²=−1<0, mode (1,−1,0). All committed and pushed.

# P-B — The multi-channel mass-phase diagram of the 4-parameter block

All results live in `RequestProject/Main.lean`, namespace `MassPhase4Channel`. The build is
kernel-checked: no `sorry`/`admit`, no `native_decide`, no new axioms, no `Complex`, no
`Real.sqrt`. Every headline declaration carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` proving its footprint is exactly
`[propext, Classical.choice, Quot.sound]`.

## Scope (honest)

This is a finite / explicit rational-linear-algebra model of **one** multi-channel block, and a
complete classification of *its* mass phases. It is not a statement about a general field theory;
it generalises the landed `3×3` result (`spectrum {lam-kap, lam, lam+kap}`, critical line
`|kap| = lam`) to a four-coupling block whose critical set is a closed-form surface.

## The model

Four channels: aperture `lam` (diagonal mass), closure `kap` (the landed off-diagonal), chiral turn
`tau` (a second off-diagonal channel), soldering `E` (a diagonal shift `lam ↦ lam + E`). The real
symmetric rational block is

```
Bc = [[lam+E, kap,   tau  ],
      [kap,   lam+E, 0    ],
      [tau,   0,     lam+E]]
```

(`Bc_isSymm` shows it is symmetric.) Its quadratic form is
`Q(x) = xᵀ Bc x = (lam+E)(x0²+x1²+x2²) + 2·kap·x0·x1 + 2·tau·x0·x2` (`Q_eq_quadForm`).

Everything is driven by one polynomial **SOS identity** (`key_identity`), with `d = lam+E`:

```
d·Q(x) = (d·x0 + kap·x1 + tau·x2)² + (tau·x1 - kap·x2)² + (d² - kap² - tau²)(x1² + x2²).
```

## Target 1 — spectrum in closed form

`spectrum_closed_form`:
`det(μ·I − Bc) = (μ − d)·((μ − d)² − (kap²+tau²))`, so the eigenvalues are `d` and
`d ± √(kap²+tau²)`; the least is `m² = d − √(kap²+tau²)`. `eigen_d` exhibits `d = lam+E` as a genuine
eigenvalue with rational eigenvector `(0, tau, −kap)`. The `√` is never introduced: the least
eigenvalue's *sign* (which is all the phase diagram needs) is captured sqrt-free below.

## Target 2 — phase predicates, exhaustive & exclusive

Defined through the quadratic form (the standard sqrt-free characterisation of the sign of `m²`):

* `Massive`  — `Q` positive definite (`m² > 0`);
* `Critical` — `Q` positive semidefinite with a non-trivial kernel (`m² = 0`);
* `Ghost`    — `Q` has a negative direction (`m² < 0`).

`phases_exhaustive` : `Massive ∨ Critical ∨ Ghost`. Exclusivity: `not_massive_critical`,
`not_massive_ghost`, `not_critical_ghost`.

## Target 3 — closed-form phase boundaries

Arithmetic criteria `critMassive`, `critCritical`, `critGhost` are proved to coincide with the
phases:

* `massive_iff`  : `Massive  ↔ (0 < lam+E ∧ kap²+tau² < (lam+E)²)`;
* `critical_iff` : `Critical ↔ (0 ≤ lam+E ∧ kap²+tau² = (lam+E)²)`;
* `ghost_iff`    : `Ghost    ↔ (lam+E < 0 ∨ (lam+E)² < kap²+tau²)`.

The **critical surface** is therefore `kap² + tau² = (lam+E)²` with `lam+E ≥ 0`, which recovers the
landed critical line `|kap| = lam` at `tau = E = 0`. `crit_exhaustive` / `crit_exclusive` give the
arithmetic trichotomy. Crossing the surface changes the phase — see the witnesses.

## Mandatory non-degeneracy witnesses (explicit rationals with computed m²)

* `witness_massive` : point `(lam,kap,tau,E) = (1,0,0,0)`, char. poly `(μ−1)³`, spectrum `{1,1,1}`,
  **m² = 1 > 0** (MASSIVE).
* `witness_critical` : point `(1,1,0,0)` (the landed `|kap|=lam`), char. poly `μ(μ−1)(μ−2)`,
  spectrum `{0,1,2}`, **m² = 0** (CRITICAL), kernel vector `(1,−1,0)`.
* `witness_ghost` : point `(1,2,0,0)`, char. poly `(μ+1)(μ−1)(μ−3)`, spectrum `{−1,1,3}`,
  **m² = −1 < 0** (GHOST), negative mode `(1,−1,0)`.

## Target 4 — qualitative role of each channel

Via the margin `margin = (lam+E)² − (kap²+tau²)` (whose sign, at `lam+E ≥ 0`, is the sign of `m²`):

* `aperture_raises`  — raising `lam` raises the margin (aperture = mass generator);
* `soldering_raises` — raising `E` raises the margin (soldering shifts the mass);
* `closure_reduces`  — raising `kap²` lowers the margin (closure = mass reducer);
* `turn_reduces`     — raising `tau²` lowers the margin (chiral turn = mass reducer).

And concrete phase crossings at rational points:

* `aperture_generates_mass` : `Ghost 1 2 0 0 ∧ Massive 3 2 0 0` (raising aperture cures the ghost);
* `closure_reduces_mass`    : `Massive 3 0 0 0 ∧ Ghost 3 4 0 0`;
* `turn_reduces_mass`       : `Massive 3 0 0 0 ∧ Ghost 3 0 4 0`;
* `soldering_shifts_mass`   : `Ghost 1 2 0 0 ∧ Massive 1 2 0 2` (soldering shifts across criticality).
