# Summary of changes for run ec8264ef-aeea-4619-b7f1-3195604c9c7b
Delivered `RequestProject/Main.lean` (namespace `SuiteD_Compton`) and `ARISTOTLE_SUMMARY.md`, built on the two–point Krein carrier from `seeds/SuiteAOp2Geom.lean`, Mathlib only. Everything is kernel-checked: no `sorry`/`admit`/`native_decide`/new axiom, and every headline theorem's footprint is verified in-file to be exactly `[propext, Classical.choice, Quot.sound]` via `#guard_msgs (whitespace := lax) in #print axioms`. The full project builds cleanly.

Setup:
- `width` used: the spread of the position observable `X = diag x` (points at their intrinsic Connes coordinates `x 0 = 0`, `x 1 = 1/m`) about the geometric midpoint `c = 1/(2m)`, i.e. the genuine positive-semidefinite quadratic form `widthSq m ψ = Σᵢ ‖ψ i‖²·(x i − c)² = ⟨ψ|(X − c·I)²|ψ⟩`, with `width = sqrt widthSq`. Closed form (`widthSq_eq`): `widthSq m ψ = (‖ψ 0‖² + ‖ψ 1‖²)/(4 m²)`.
- `J`-positive normalized sector: `JNormalized ψ := kreinForm ψ = 1`, where `kreinForm ψ = star(ψ0)·ψ1 + star(ψ1)·ψ0` is proved (`kreinForm_eq_Jc`) to be the genuine `J`-inner product `⟨ψ, Jψ⟩` for the seed's `J = σₓ`. This is simultaneously positive (=1>0) and unit; single-point states are isotropic (`kreinForm = 0`) and excluded.
- constant: `c = 1/2`, floor `c/m = 1/(2m)`.

Results proved:
1. `compton_floor`: for `m>0` and every `JNormalized ψ`, `(1/2)/m ≤ width m ψ` (core input `normSq_sum_ge_one`: on the Krein-positive unit sector `‖ψ0‖²+‖ψ1‖² ≥ 1`).
2. `compton_floor_tight`: optimizer `psiStar = (1/√2, 1/√2)` (shown `JNormalized`) saturates it, `width m psiStar = (1/2)/m`. Mandatory fixture `compton_fixture_m3`: `JNormalized psiStar ∧ width 3 psiStar = 1/6` (nonzero rational).
3. `compton_scale_eq_spectral_distance`: `width m psiStar = (1/2)·dCausal m 0 1`, identifying the floor with the Connes distance.

Kills (as theorems): `no_sub_compton` (no `JNormalized` state has `width < (1/2)/m`), `compton_floor_pos` (floor `>0`), `compton_floor_mass_dependent` (`width 3 psiStar ≠ width 1 psiStar`, i.e. `1/6 ≠ 1/2`).

Honest note on Target 3: the identification is exact up to the explicit constant `c = 1/2`. Since `dCausal m 0 1 = 1/m` (seed), `width m psiStar = (1/2)/m = (1/2)·dCausal`. The `1/2` is structural: each point lies at half the inter-point Connes distance from the midpoint, so the minimal RMS spread is exactly half the Connes distance. Full details in `ARISTOTLE_SUMMARY.md`.

# Suite D rung D5 — a finite Compton bound: the mass gap is a length floor

Deliverable: `RequestProject/Main.lean` (namespace `SuiteD_Compton`), built against
Mathlib only, on top of the two–point Krein carrier of
`seeds/SuiteAOp2Geom.lean` (`SuiteA_Op2Geom`).

All headline theorems are kernel-checked with axiom footprint exactly
`[propext, Classical.choice, Quot.sound]`, verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>`.

## The carrier and the `J`-positive normalized sector

Hilbert space `ℂ²` (`Fin 2 → ℂ`), fundamental symmetry `J = σₓ` (the seed's `Jc`).
The **Krein form** is `kreinForm ψ = star (ψ 0) * ψ 1 + star (ψ 1) * ψ 0`, and
`kreinForm_eq_Jc` proves it is literally the `J`-inner product
`⟨ψ, J ψ⟩ = star ψ ⬝ᵥ (Jc *ᵥ ψ)`.

A physical one-particle codeword lives in the **positive sector** of the indefinite
Krein metric and is **normalized** there:

```
JNormalized ψ  :=  kreinForm ψ = 1
```

This is simultaneously positive (value `= 1 > 0`) and unit. A state sharply localized
at a single point (`e₀` or `e₁`) has `kreinForm = 0`, so it is isotropic and never
`J`-positive-normalized — exactly the physics that forbids sub-Compton localization.

## The width used

The two carrier points sit, in the intrinsic (Connes) metric, at coordinates
`x 0 = 0` and `x 1 = dCausal m 0 1 = 1/m`, with geometric midpoint `c = 1/(2m)`
(`xcoord`, `xcenter`). The localization width is the spread of the position
observable `X = diag x` **about the midpoint**, a genuine positive-semidefinite
quadratic form:

```
widthSq m ψ = ∑ i, ‖ψ i‖² · (x i - c)²        (= ⟨ψ| (X - c·I)² |ψ⟩)
width   m ψ = sqrt (widthSq m ψ)
```

Closed form (`widthSq_eq`): since both points are at distance `1/(2m)` from the
midpoint, `widthSq m ψ = (‖ψ 0‖² + ‖ψ 1‖²)/(4 m²)`. The midpoint is the unique
center for which the position spread is bounded below on the (non-compact) Krein
sphere.

## The constant `c`

**`c = 1/2`.** The floor is `c/m = 1/(2m)`.

Core uncertainty input (`normSq_sum_ge_one`): on `JNormalized`, the Hilbert norm²
satisfies `‖ψ 0‖² + ‖ψ 1‖² ≥ 1` (the Krein-positive unit hyperboloid lies outside
the Hilbert unit ball). Combined with `widthSq_eq` this gives the floor.

## Targets

- **`compton_floor`** (Target 1): for every `m > 0` and every `JNormalized ψ`,
  `(1/2)/m ≤ width m ψ`.
- **`compton_floor_tight`** (Target 2): the explicit optimizer
  `psiStar = (1/√2, 1/√2)` (which is `JNormalized`, see `psiStar_JNormalized`)
  saturates the floor: `width m psiStar = (1/2)/m`.
- **`compton_scale_eq_spectral_distance`** (Target 3): the achieved floor equals
  `(1/2) · dCausal m 0 1`.

### Non-degeneracy fixture at `m = 3`

**`compton_fixture_m3`**: `JNormalized psiStar ∧ width 3 psiStar = 1/6`.
The optimizer is the fixed `psiStar = (1/√2, 1/√2)`; at `m = 3` its width is the
specific nonzero rational `1/6 = c/3`. The floor is not vacuous.

## Kills (stated as theorems)

- **`no_sub_compton`**: there is **no** `JNormalized` codeword with
  `width m ψ < (1/2)/m` — sub-Compton localization is impossible; the attempted
  kill of the floor fails.
- **`compton_floor_pos`**: `0 < (1/2)/m` — the floor is a strictly positive length,
  not `0`.
- **`compton_floor_mass_dependent`**: `width 3 psiStar ≠ width 1 psiStar`
  (`1/6 ≠ 1/2`) — the floor genuinely depends on `m`; the gap sets a length.

## Honest note on Target 3 (exact, up to the constant `c`)

The identification is **exact up to the explicit constant `c = 1/2`**:
`width m psiStar = (1/2) · dCausal m 0 1`, and since `dCausal m 0 1 = 1/m`
(seed `dCausal_01`) this is `= (1/2)/m`, the floor value. The factor `1/2` is not a
fudge: it is forced by the choice of width as the RMS deviation about the geometric
**midpoint** — each carrier point lies at half the inter-point (Connes) distance
from the midpoint, so the minimal RMS spread is exactly half the Connes distance.
With `c = 1/2` the statement "mass gap = length floor" and "mass = 1/distance" are
literally the same equation.
