# Summary of changes for run 3fc92d99-63a4-4428-9f39-80abde865de5
Delivered `RequestProject/Main.lean` (namespace `Goal3ExactRG`) + `ARISTOTLE_SUMMARY.md`. Clean-room, Mathlib-only; builds with no `sorry`/`admit`/`native_decide`/new `axiom`, and every headline theorem carries an in-file `#guard_msgs ... #print axioms` block pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]`.

**Closed form of R.** From the two-site Schur complement of the tridiagonal chain carrier (on-site aperture `lam`, nearest-neighbour closure edge `kap`), decimating every second site gives the exact rational map
`R(lam, kap) = ( lam − 2·kap²/lam , −kap²/lam )` on `ℚ×ℚ`, well defined off the single codimension-1 locus `lam = 0` (where the middle-site block `lam·I` is not invertible).

**All four rungs landed:**
- (a) `R_schur_derivation`: R is the Schur complement `lam·I₃ − B·D⁻¹·Bᵀ` (centre = Rlam, edges = Rkap; middle block invertible iff `lam ≠ 0`).
- (b) `massless_line_invariant_and_nondegenerate`: the critical line `|kap| = |lam|` is R-invariant (maps to `(−lam,−lam)`), with the non-degeneracy witness stated in-theorem: `R(1, 1/2) = (1/2, −1/4) ≠ (1, 1/2)`.
- (c) `jacobian_is_derivative` + `linearized_mass_eigenvalue_eq_two`: the linearization at the critical point `(lam,lam)` is `J = !![3,−4;1,−2]` (entries proved to be the four partials), with relevant mass eigenvalue exactly `2` (eigenvector `(4,1)`, transverse to the critical tangent `(1,1)` carrying the marginal `−1`); with `b = 2`, `y_t = log₂2 = 1`, hence `ν = 1`.
- (d) `conical_dispersion_z_eq_one`: on the massless line the Dirac mass shell is conical `(k·σz)² = k²·1` (ω = ±k, z = 1) and the group velocity saturates the light cone (`v_g² = 1`).

**Non-degeneracy witness value:** `R(1, 1/2) = (1/2, −1/4)`.

**Codimension-1 locus honestly excluded:** `lam = 0`. Honest note recorded in the summary: on the critical line R acts as a sign-flip period-2 orbit `(lam,lam) ↦ (−lam,−lam)`; the genuine fixed line of R is the massive/decoupled line `kap = 0`, and the critical relevant eigenvalue 2 is read from J at `(lam,lam)`.

No kill conditions triggered (critical line is invariant, mass eigenvalue is exactly 2, and R is not the identity).

# Goal III — Relativity is born at the fixed point (exact rational RG)

All work is in `RequestProject/Main.lean`, namespace `Goal3ExactRG`. It is a
clean-room, Mathlib-only development (the `seeds/` files are ported/reused as
statements, not imported). It builds with no `sorry`/`admit`/`native_decide` and
no new `axiom`; every headline theorem is pinned in-file with a
`#guard_msgs ... #print axioms` block to footprint
`[propext, Classical.choice, Quot.sound]`.

## The decimation map `R` (closed rational form)

The chain carrier is the 1D tridiagonal operator with on-site *aperture* `lam`
and nearest-neighbour *closure* edge `kap`. Real-space decimation removes every
second site; integrating out the middle sites (two-site Schur complement) gives
the **exact rational map** `R : ℚ×ℚ → ℚ×ℚ`

```
R(lam, kap) = ( lam - 2·kap²/lam ,  -kap²/lam )
```

(`Rlam`, `Rkap`, `R`). Each surviving site is flanked by two removed sites (hence
the factor `2` in the on-site self-energy `-2·kap²/lam`); the two removed sites
also bridge each pair of survivors by an effective edge `-kap²/lam`.

## Rungs landed (all four)

- **(a) The recursion — `R_schur_derivation`.** `R` is realised as the two-site
  Schur complement `chainCore = lam·I₃ − B·D⁻¹·Bᵀ` of the three-survivor block:
  its centre entry is `Rlam`, its two edge entries are `Rkap`, and the removed
  block `D = lam·I₂` is invertible (inverse `Dinv lam`) exactly when `lam ≠ 0`.
- **(b) Massless-line invariance — `massless_line_invariant_and_nondegenerate`.**
  For `lam ≠ 0`, `|kap| = |lam|` implies `|Rkap| = |Rlam|`; concretely the whole
  critical line maps by `R(lam, kap) = (−lam, −lam)`, again critical. The
  **non-degeneracy fixture is stated in the theorem**: `R(1, 1/2) = (1/2, −1/4)`
  and `R(1, 1/2) ≠ (1, 1/2)`, so `R` is a genuine nontrivial flow (not the
  identity), making the invariance non-vacuous.
- **(c) Correlation exponent `ν = 1` — `jacobian_is_derivative` +
  `linearized_mass_eigenvalue_eq_two`.** The linearization of `R` at the critical
  point `(lam, lam)` (`lam ≠ 0`) is the constant matrix `J = !![3,−4; 1,−2]`
  (its entries proved to be the four partial derivatives of `R`). `J` has
  **relevant (mass-direction) eigenvalue exactly `2`**, with eigenvector `(4,1)`
  transverse to the critical tangent `(1,1)`, which carries the marginal
  eigenvalue `−1` (`trace = 1`, `det = −2`, char. poly `(X−2)(X+1)`). With
  rescale `b = 2` the thermal exponent is `y_t = log₂ 2 = 1`, hence
  `ν = 1/y_t = 1` as exact arithmetic; `ξ ~ (lam − kap)^{−1}`.
- **(d) Conical dispersion `z = 1` — `conical_dispersion_z_eq_one`.** On the
  massless line the pinned Dirac mass shell is conical: `(k·σz)² = k²·1`
  (eigenvalues `±k`, i.e. `ω = ±k`, linear ⇒ dynamical exponent `z = 1`), and the
  group velocity saturates the light cone (luminal deficit
  `sin²ω − (sin k·cos 0)² = 1 − cos² 0 = 0`, so `v_g² = 1`).

## Non-degeneracy witness value

`R(1, 1/2) = (1/2, −1/4) ≠ (1, 1/2)` (stated inside
`massless_line_invariant_and_nondegenerate`).

## Codimension-1 locus honestly excluded

`R` involves division by `lam`, so it is well defined (and the middle-site block
`lam·I` invertible) exactly off the line **`lam = 0`**. This is the single
codimension-1 excluded locus. Note also that on the critical line `R` acts as a
sign-flip period-2 orbit `(lam, lam) ↦ (−lam, −lam) ↦ (lam, lam)`; the genuine
fixed line of `R` itself is the massive/decoupled line `kap = 0`, while the
critical relevant eigenvalue `2` is read off the linearization `J` at the
critical point `(lam, lam)` (the marginal eigenvalue `−1` reflects the sign flip
along the critical line).

## Kill conditions

None triggered: the critical line **is** `R`-invariant, the linearized mass
eigenvalue **is** exactly `2`, and `R` is **not** the identity (guarded by the
in-theorem witness).
