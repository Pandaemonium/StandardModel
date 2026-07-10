# Summary of changes for run 5ba162a8-8867-438f-993c-fe1e0d085ff3
Delivered `RequestProject/Main.lean` (namespace `RankCeiling`) plus `ARISTOTLE_SUMMARY.md`. The project builds cleanly with Mathlib only, no `sorry`/`admit`/`native_decide` and no new axioms; every headline theorem has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

Model: three null edges via the 3×3 zero-diagonal rational Gram `G a b c = !![0,a,b; a,0,c; b,c,0]`, with two `mass²` readings — physical pairwise `massPair a b c = 2*(a+b+c)` and naive determinant `detG a b c = (G a b c).det`.

Theorems proved:
- `massPair_closed`: `massPair a b c = 2*(a+b+c)`.
- `detG_closed`: `detG a b c = 2*a*b*c` (via `Matrix.det_fin_three` + `ring`).
- `rank2_ok`: for `P = !![p,x;x,q]`, `det P = p*q - x^2` (genuine 2×2 determinant — the exact rank-2 reading), with `rank2_massive_witness` (`p=q=1,x=0` → 1).
- `rank3_det_ne_pairwise` (payload): the readings disagree at rank 3 — witness `a=b=c=1` gives `6 ≠ 2`, and witness `a=b=1,c=0` gives `massPair=4 ≠ 0` while `detG=0` (determinant vanishes on a nonzero-mass configuration).
- `rank_ceiling_verdict`: packages the boundary — the determinant equals `mass²` at rank 2 but is a different function at rank 3.

This is stated honestly as a negative/boundary result: the `mass² = det P` reading is intrinsically two-edge and is not extended to higher spin. All work is committed and pushed.

# RankCeiling — the rank-2 ceiling of the determinant reading of `mass²`

All results live in `RequestProject/Main.lean`, namespace `RankCeiling`.
The file builds cleanly (Mathlib only), with no `sorry`/`admit`/`native_decide`
and no new axioms. Every headline theorem carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is
exactly `[propext, Classical.choice, Quot.sound]`.

## Model

Three null "edges" are encoded by the `3×3` zero-diagonal rational Gram
`G a b c = !![0, a, b; a, 0, c; b, c, 0]` (diagonal `0` = null `pᵢ·pᵢ = 0`,
off-diagonal `g_ij = pᵢ·pⱼ`). Two candidate `mass²` readings:

* `massPair a b c = 2*(a+b+c)` — the physical rest-mass² of `p = p₁+p₂+p₃`,
  since `p·p = Σ pᵢ·pᵢ + 2 Σ_{i<j} pᵢ·pⱼ = 0 + 2(a+b+c)`.
* `detG a b c = (G a b c).det` — the naive `3×3` Gram-determinant reading.

## Results

- `massPair_closed`, `detG_closed`: closed forms `massPair = 2*(a+b+c)` and
  `detG = 2*a*b*c` (via `Matrix.det_fin_three` + `ring`).
- `rank2_ok` (sanity anchor): the honest rank-2 fact the program actually uses —
  for the spinor matrix `P = !![p,x;x,q]`, `det P = p*q - x²` (a genuine `2×2`
  determinant), i.e. at rank 2 the determinant reading of `mass²` is exact.
  `rank2_massive_witness`: `p=q=1, x=0` gives `mass² = 1 ≠ 0`.
- `rank3_det_ne_pairwise` (payload): the two readings disagree at rank 3.
  Witness 1 (`a=b=c=1`): `massPair = 6` but `detG = 2`. Witness 2 (`a=b=1,c=0`):
  `massPair = 4` while `detG = 0` — the determinant vanishes (degenerate Gram)
  on a nonzero-mass configuration.
- `rank_ceiling_verdict`: packages the above — rank 2 the determinant *is* the
  `mass²`; rank 3 the naive `det P3` is a genuinely different function from the
  physical pairwise mass.

## Scope

This is an honest **negative / boundary** result: it marks where the `mass² = det P`
reading stops (an `r×r` Gram determinant scales as `mass^{2r}`, so it can only
read `mass²` at `r = 2`). It does not extend the mechanism to higher spin.
