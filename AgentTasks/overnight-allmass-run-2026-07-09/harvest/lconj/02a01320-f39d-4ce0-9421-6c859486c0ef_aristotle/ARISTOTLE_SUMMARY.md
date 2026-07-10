# Summary of changes for run 02a01320-f39d-4ce0-9421-6c859486c0ef
Delivered `RequestProject/Main.lean` (namespace `LambdaConjugacy`) plus `ARISTOTLE_SUMMARY.md`, building kernel-checked with no `sorry`/`admit`/`native_decide` and no new axioms. Build is ~30s (well under 3 min).

## Model
Finite Fourier pair over `ZMod 4` with primitive root of unity `ω = Complex.I`, so every value lives in the Gaussian integers `ℤ[i]` (no transcendental analysis). Defined the character `w m = I^m.val`, the DFT `dft f k = ∑ j, f j * w (j*k)`, its inverse `idft`, the states `delta`/`uniform`, and `supp`. Supporting lemmas: `w_add`, `w_ne`, `normSq_w`, orthogonality `orth`, Fourier inversion `idft_dft`, and injectivity `dft_ne_zero`.

## Targets
1. `delta_maps_to_uniform` (general on `ZMod 4`): `normSq (dft (delta N0) k) = 1` — sharp count ⇒ constant-modulus (uniform) Lambda register.
2. `uniform_maps_to_delta` (general): `dft uniform k = if k = 0 then 4 else 0` — the dual, via inversion/orthogonality.
3. `support_uncertainty`: the **full Donoho–Stark theorem for n = 4** over all nonzero `f : ZMod 4 → ℂ`, `4 ≤ |supp f| * |supp (dft f)|`, proved from inversion, injectivity, and the extremal facts `supp_dft_card_of_supp_card_one` and `supp_card_of_supp_dft_card_one`. (Landed as the genuine general-`f` theorem for n = 4, not merely witness instances.)
4. `conjugacy_verdict`: packages conjugacy + dual + uncertainty.

## Non-degeneracy (explicit, entrywise, Gaussian)
`delta_one_dft_entries` = (1, i, −1, −i); `uniform_dft_entries` = (4, 0, 0, 0); `delta_saturates` (1·4 = 4 saturating); middle witness `mid` (support {0,1}) with `mid_dft_entries` = (2, 1+i, 0, 1−i) and `mid_uncertainty` (supports 2 and 3, product 6 ≥ 4).

## Constraints
Mathlib-only, `decide`/`fin_cases`/`ring`/`norm_num`/Finset support. Each headline (`delta_maps_to_uniform`, `uniform_maps_to_delta`, `support_uncertainty`, `conjugacy_verdict`, plus `delta_saturates`, `mid_uncertainty`) carries an in-file `#guard_msgs (whitespace := lax) in #print axioms ...` pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]`.

## Honest scope
The conjugacy and uncertainty are machine-checked mathematics; the identification of the conjugate variable with the physical cosmological constant and the `~1/√count` RMS reading remain imported ([C]), as documented in `conjugacy_verdict`.

# Lambda conjugate to the count, natively: a finite Fourier uncertainty theorem

All results live in `RequestProject/Main.lean`, namespace `LambdaConjugacy`. The file builds
kernel-checked with no `sorry`/`admit`/`native_decide` and no new axioms; every headline carries
an in-file `#guard_msgs (whitespace := lax) in #print axioms ...` pinning the footprint to
exactly `[propext, Classical.choice, Quot.sound]`. Build time is well under 3 minutes.

## The model

We work over `ZMod 4` with primitive 4th root of unity `ω = Complex.I`, so **every value stays
in the Gaussian integers `ℤ[i]`** — no transcendental analysis.

* character: `w m = Complex.I ^ m.val` (`w_add`, `w_ne`, `normSq_w`, orthogonality `orth`);
* DFT: `dft f k = ∑ j, f j * w (j*k)`; inverse `idft`;
* states: `delta N0` (sharp count), `uniform`;
* support: `supp f = univ.filter (fun j => f j ≠ 0)`.

## Targets delivered

1. **`delta_maps_to_uniform`** (general over `ZMod 4`): `normSq (dft (delta N0) k) = 1` for all
   `N0, k` — a sharp-count state maps to a constant-modulus (uniform) Lambda register.
2. **`uniform_maps_to_delta`** (general): `dft uniform k = if k = 0 then 4 else 0` — sharp Lambda
   from a delta count, obtained from Fourier inversion / orthogonality.
3. **`support_uncertainty`** — the **full Donoho–Stark theorem for `n = 4`**: for every nonzero
   `f : ZMod 4 → ℂ`, `4 ≤ |supp f| * |supp (dft f)|`. This is the genuine theorem over *all*
   complex functions (not just the witnesses), proved via Fourier inversion (`idft_dft`),
   injectivity (`dft_ne_zero`), and the two extremal facts
   `supp_dft_card_of_supp_card_one` (support 1 ⇒ DFT support 4) and
   `supp_card_of_supp_dft_card_one` (its dual).
4. **`conjugacy_verdict`** — packages the conjugacy, its dual, and the uncertainty bound.

## Non-degeneracy (explicit, entrywise, Gaussian-rational)

* `delta_one_dft_entries`: `dft (delta 1) = (1, i, -1, -i)` (constant modulus 1).
* `uniform_dft_entries`: `dft uniform = (4, 0, 0, 0)`.
* `delta_saturates`: the extremal pair saturates, `1 * 4 = 4`.
* `mid` (support `{0,1}`), `mid_dft_entries`: `dft mid = (2, 1+i, 0, 1-i)`.
* `mid_uncertainty`: middle witness has support sizes `2` and `3`, product `6 ≥ 4`.

## Honest scope

The conjugacy and the Donoho–Stark uncertainty are fully machine-checked mathematics (`M`).
The *identification* of the conjugate variable with the physical cosmological constant, and the
`~ 1/√count` RMS reading of the everpresent mechanism, remain imported/`[C]` as stated in the
docstring of `conjugacy_verdict`.
