# Summary of changes for run 81d339b8-478a-47fd-b1b2-c28f482634f2
Delivered `RequestProject/Main.lean` (namespace `LongitudinalGoldstone`) and `ARISTOTLE_SUMMARY.md`. The file builds cleanly under Mathlib with no `sorry`/`admit`/`native_decide`/new axioms; every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms` check confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

Model: rational `Fin 4 → ℚ` Minkowski algebra in the (+,-,-,-) convention with `mdot u v = u0 v0 - u1 v1 - u2 v2 - u3 v3`, momentum `pMom E k = ![E,0,0,k]` (`E²-k²=m²`), longitudinal `epsL E k m = ![k/m,0,0,E/m]`, transverse `epsT1=![0,1,0,0]`, `epsT2=![0,0,1,0]`.

Proved targets:
- `pMom_mdot`: `mdot p p = m²` on-shell.
- `epsL_normalized` (Target 1): `mdot epsL epsL = -1`.
- `epsL_orthogonal_p` (Target 2): `mdot epsL p = 0`.
- `transverse_normalized_orthogonal` (Target 3): both transverse modes unit spacelike, orthogonal to `p`, all three mutually orthogonal.
- `longitudinal_singular` (Target 4): `m • epsL = ![k,0,0,E]` (finite, so `epsL ~ 1/m` diverges) and at `m=0` (`E=k`) the momentum is null (`mdot p p = 0`).
- `witness`: non-degeneracy at `E=5,k=3,m=4` (`epsL=![3/4,0,0,5/4]`, `mdot epsL epsL=-1`, `mdot epsL p=0`, `4•epsL=![3,0,0,5]`) and massless contrast `E=k=1,m=0` (`p=![1,0,0,1]` null).
- `longitudinal_is_mass_verdict` (Target 5): packages the full 3-polarization frame plus the `m→0` singularity — the third polarization is the mass.

Proofs use only `field_simp`/`ring`/`linear_combination`/`norm_num`/`fin_cases`/`simp`; no Real transcendentals, no Complex, no high-degree nlinarith. Scope (a single on-shell momentum, finite rational avatar of the Goldstone-equivalence fact) is stated honestly in the docstrings and summary. All work committed and pushed.

# Longitudinal Goldstone: the massive vector's third polarization IS the mass

`RequestProject/Main.lean`, namespace `LongitudinalGoldstone`. Finite, rational
`Fin 4 → ℚ` Minkowski linear algebra in the `(+,-,-,-)` convention. Builds under
Mathlib only; no `sorry`/`admit`/`native_decide`/new axioms. Axiom footprint on
every headline is exactly `[propext, Classical.choice, Quot.sound]`, checked
in-file with `#guard_msgs (whitespace := lax) in #print axioms <thm>`.

## Model

* Metric `η = diag(1,-1,-1,-1)`; product `mdot u v = u0 v0 - u1 v1 - u2 v2 - u3 v3`.
* On-shell momentum `pMom E k = ![E,0,0,k]` with `E² - k² = m²`.
* Longitudinal polarization `epsL E k m = ![k/m, 0, 0, E/m]`.
* Transverse polarizations `epsT1 = ![0,1,0,0]`, `epsT2 = ![0,0,1,0]`.

## Results

* `pMom_mdot` — `mdot p p = m²` (on-shell).
* `epsL_normalized` (Target 1) — `mdot epsL epsL = -1` (spacelike, unit): uses
  `(k² - E²)/m² = -1` via `E² - k² = m²` and `m ≠ 0`.
* `epsL_orthogonal_p` (Target 2) — `mdot epsL p = 0`.
* `transverse_normalized_orthogonal` (Target 3) — `epsT1, epsT2` are unit
  spacelike, orthogonal to `p`, and all three polarizations are mutually
  orthogonal: a valid 3-polarization spacelike frame.
* `longitudinal_singular` (Target 4) — `m • epsL = ![k,0,0,E]` stays finite so
  unscaled `epsL` diverges like `1/m`; and at `m = 0` (i.e. `E = k`) the momentum
  `![k,0,0,k]` is null (`mdot p p = 0`), leaving only the 2 transverse modes.
* `witness` — non-degeneracy at `E=5,k=3,m=4`: `epsL = ![3/4,0,0,5/4]`,
  `mdot epsL epsL = -1`, `mdot epsL p = 0`, `4 • epsL = ![3,0,0,5]`; and the
  massless contrast `E=k=1,m=0`: `p = ![1,0,0,1]` null.
* `longitudinal_is_mass_verdict` (Target 5) — packages the above: a massive
  vector carries 3 mutually-orthogonal spacelike polarizations (2 transverse + 1
  longitudinal), the longitudinal one `mdot = -1` and orthogonal to `p`; it is
  singular as `m → 0` (scales as `1/m`, direction collapses onto the null
  momentum), so the massless limit keeps only 2 transverse modes —
  `pol = 2 (massless) + [m ≠ 0] = 3`.

## Scope

A single on-shell momentum, a finite rational avatar of the
Goldstone-equivalence / longitudinal-enhancement fact; not the full field theory.
Proofs use only `field_simp`/`ring`/`linear_combination`/`norm_num`/`fin_cases`/
`simp`; no `Real` transcendentals, no `Complex`, no high-degree `nlinarith`.
