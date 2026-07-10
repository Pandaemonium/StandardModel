# Summary of changes for run 42739749-c48f-4a95-a254-49ac904021ae
Delivered `RequestProject/Main.lean` (namespace `SuiteD_ComptonSq`) and `ARISTOTLE_SUMMARY.md`, re-deriving the D5 Compton length floor entirely through the **squared** width `widthSq` over `ℚ`. No `Real.sqrt`, `Complex`, or transcendentals appear; every proof is `ring`/`norm_num`/`nlinarith`/`field_simp`/`gcongr` on rationals. The file builds in-project in ~16 s.

Formulation: two-point Connes carrier with `x0 = 0`, `x1 = 1/m`, `midc = 1/(2m)`, `dCausal m = 1/m`. States are given by probabilities `p i = ψ i²`; `widthSq m p = p0*(x0-midc)² + p1*(x1-midc)² = (p0+p1)/(4m²)`; the `J`-positive unit sector is `UnitSector p = 0 ≤ p0 ∧ 0 ≤ p1 ∧ kreinFormSq p = 1` where `kreinFormSq p = 4 p0 p1 = (2ψ₀ψ₁)²`. The optimizer is the rational `psiStar = (1/2,1/2)` (amplitudes would be the irrational `(1/√2,1/√2)`), which is exactly why the squared formulation stays rational.

Proved (all kernel-checked, no sorry/admit/native_decide/new axiom):
1. `normSq_sum_ge_one`: `1 ≤ p0 + p1` on the unit sector (AM–GM via `sq_nonneg (p0-p1)`).
2. `compton_floor_sq`: `1/(4m²) ≤ widthSq m p` for every unit-sector state (the length floor).
3. `compton_floor_tight_sq`: `widthSq m psiStar = 1/(4m²)` (tight), plus `psiStar_unitSector` and the mandatory fixture `widthSq_three_psiStar : widthSq 3 psiStar = 1/36`.
4. `compton_scale_eq_spectral_distance_sq`: `widthSq m psiStar = (1/4)*(dCausal m)²`.
Kill target `no_sub_compton_sq`: no unit-sector state has `widthSq m p < 1/(4m²)`.

Each headline theorem has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` audit; the footprint of every one is exactly `[propext, Classical.choice, Quot.sound]`. Work committed and pushed.

# Suite D rung D5 — Compton length floor via `widthSq` (squared, rational)

**File:** `RequestProject/Main.lean`, namespace `SuiteD_ComptonSq`.

This is the re-derivation of the finite Compton bound stated **entirely through the
squared localization width `widthSq`** over `ℚ`. There is **no `Real.sqrt`, no
`Complex`, and no transcendental** anywhere; every proof is `ring` / `norm_num` /
`nlinarith` / `field_simp` / `gcongr` on rationals. The file builds in-project in
about 16 seconds.

## Formulation

A two-point Connes carrier of mass `m > 0` has points at coordinates `x0 = 0`,
`x1 = 1/m`, midpoint `midc = 1/(2 m)`, and Connes distance `dCausal m = 1/m`.

A state is given by its **probabilities** `p : Fin 2 → ℚ`, with `p i = ψ i ²` the
squared amplitude. Working with squared amplitudes is what keeps everything
rational: the optimizer, whose amplitudes are the irrational `(1/√2, 1/√2)`, has
the perfectly rational probability vector `psiStar = (1/2, 1/2)`.

- `widthSq m p = p 0 * (x0 - midc)² + p 1 * (x1 - midc)² = (p 0 + p 1) / (4 m²)`.
- `kreinFormSq p = 4 * p 0 * p 1` is `(2 ψ₀ ψ₁)²`; the `J`-positive unit sector
  `UnitSector p` is `0 ≤ p 0 ∧ 0 ≤ p 1 ∧ kreinFormSq p = 1`. (Single-point states
  have `kreinFormSq = 0` and are excluded.)

## Results (all proved, kernel-checked)

1. `normSq_sum_ge_one` — on the unit sector, `1 ≤ p 0 + p 1` (i.e. `ψ₀² + ψ₁² ≥ 1`),
   via AM–GM `sq_nonneg (p 0 - p 1)`.
2. `compton_floor_sq` — for every unit-sector state, `1/(4 m²) ≤ widthSq m p`
   (`width ≥ (1/2)/m`): the mass gap is a length floor.
3. `compton_floor_tight_sq` — the optimizer saturates it: `widthSq m psiStar = 1/(4 m²)`.
   - `psiStar_unitSector` — `psiStar` lies in the unit sector.
   - `widthSq_three_psiStar` — mandatory fixture `widthSq 3 psiStar = 1/36`.
4. `compton_scale_eq_spectral_distance_sq` — `widthSq m psiStar = (1/4) * (dCausal m)²`,
   a quarter of the squared Connes distance (the `1/2` structural constant, squared).

Kill target: `no_sub_compton_sq` — no unit-sector state has `widthSq m p < 1/(4 m²)`.

## Soundness

No `sorry`/`admit`/`native_decide`/new axiom/`@[implemented_by]`. Each headline
theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …`
audit; the axiom footprint of every one is exactly
`[propext, Classical.choice, Quot.sound]`.
