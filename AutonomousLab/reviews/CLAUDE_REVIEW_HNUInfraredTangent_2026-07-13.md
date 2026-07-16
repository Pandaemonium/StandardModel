# Claude review: HNUInfraredTangent (Weyl infrared tangent, Bridge B1)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-190858-30573d3e, item QCA-3PLUS1-001
- Source: `.../c626cb61-.../infrared/.../HNUInfraredTangent.lean` (247, sha
  d2331c17 MATCH). Imports `HNUExactCore` (bundled; bare import).
- Date: 2026-07-13
- Context: this closes the "continuum Weyl tangent" open target that my earlier
  HNU/FiniteTransverse reviews consistently listed as NOT proved.

## Verdict: APPROVE (integrate the whole module)

Genuine, kernel-clean, non-vacuous, correctly scoped. All four `HasDerivAt`
theorems are real Frechet derivatives in the matrix operator norm with the exact
`-i sigma_j` coefficients, the imported HNU conventions are used unmodified, and
the scope is a first-order infrared tangent only. Independent build: EXITCODE=0,
7 guards pass at the standard three.

## Independent build (bare import worked around)

The module imports `HNUExactCore` BARE (line 35), which the repo cannot resolve
directly (repo module is `PhysicsSM.Draft.NullEdge.HNUExactCore`). I confirmed the
bundled `HNUExactCore` key defs (`endpoint`, `Uplus`, `Uminus`, `Pplus`, `Pminus`,
`sigma1/2/3`) are IDENTICAL to the repo's, retargeted the import to
`PhysicsSM.Draft.NullEdge.HNUExactCore`, and built: **EXITCODE=0**, no error, no
`#guard_msgs` mismatch, no `ofReduceBool`/`sorryAx`. So the 7 `#guard_msgs`
(endpoint_ray, axis0/1/2, zero_ray, axis1_deriv_ne_zero) pass at
`[propext, Classical.choice, Quot.sound]`. (At integration: retarget the import.)

## Requested checks (all pass)

- **Each `HasDerivAt` genuine in the Matrix operator norm - YES.** Works in
  `M2 = Matrix (Fin 2) (Fin 2) C` under `Matrix.Norms.Operator` (a genuine
  `NormedRing`/`NormedAlgebra R`), so `HasDerivAt.mul`/`.smul_const` apply. The
  substep derivatives (`hasDerivAt_Uplus/Uminus` via `Complex.exp` and
  `hasDerivAt_expsmul`) and the product (`hasDerivAt_mul_at_one`, `f'+g'` at the
  identity) are all real `HasDerivAt`, not formal coefficients.
- **`-i sigma_j` signs - CORRECT.** `hasDerivAt_Uplus` gives `((-I) phi') • Pplus`,
  `hasDerivAt_Uminus` gives `(I phi') • Pminus`; combined via
  `Pplus_sub_Pminus : Pplus s - Pminus s = s`, the axis-j sum is `-i q_j sigma_j`.
- **Multiplication order - CORRECT.** The eight substeps are folded in the exact
  `endpoint` order (Uminus s1, Uminus s3, Uminus s2, Uplus s3, Uplus s1, Uminus s3,
  Uplus s2, Uplus s3), and `hfun` identifies the product with `endpoint (t·q)` by
  `rw [endpoint]` - the imported definition, unmodified.
- **Arbitrary-ray linear combination - CORRECT.** `endpoint_ray_hasDerivAt (q)`:
  `d/dt endpoint(t·q)|0 = -i (q0 sigma1 + q1 sigma2 + q2 sigma3)`. The axis-3
  half-step is handled correctly: the FOUR `sigma3` substeps at `q2/2` (two Uminus
  `+i q2/2 Pminus`, two Uplus `-i q2/2 Pplus`) combine to `-i q2 sigma3` (net full
  `q2`). Axis specialisations give `-i sigma1/sigma2/sigma3`.
- **Nonzero witness - YES.** `endpoint_axis1_deriv_ne_zero : ((-I) • sigma2) != 0`
  (checked at entry `(0,1)`). Plus the zero-ray control
  `endpoint_zero_ray_hasDerivAt` (derivative `0` along the constant zero ray).
- **Standard-three footprint - YES** (build EXITCODE=0, 7 `#guard_msgs` pass).

## Over-claim modes - all clear

- Vacuity: none (nonzero-tangent witness; zero-ray control).
- False shape: none - genuine `HasDerivAt` in the real matrix operator norm, not a
  symbolic O(k^2) restatement (this UPGRADES HNUExactCore's `O(k^2)` expansion to a
  true first derivative).
- Imported conventions: clean - "HNU definitions, signs, and rightmost-first
  ordering used WITHOUT modification (this file only imports them)"; no convention
  drift, the `-i` coefficient matches HNUExactCore's linearisation `sigma0 - i
  k·sigma`.
- Scope: correct - purely first-order (`HasDerivAt` at `k=0`); no error bound, PDE,
  topology (winding), or primitive-null completion is claimed.

## Exact subset for live integration

The whole module integrates: the four headline `HasDerivAt` theorems
(`endpoint_ray_hasDerivAt`, `endpoint_axis0/1/2_hasDerivAt`), the two controls
(`endpoint_zero_ray_hasDerivAt`, `endpoint_axis1_deriv_ne_zero`), and the helper
lemmas (`hasDerivAt_expsmul`, `hasDerivAt_Uplus/Uminus`, `hasDerivAt_mul_at_one`,
`Pplus_sub_Pminus`, `Uplus_zero`, `Uminus_zero`, `axisRay`). Only integration edit:
retarget `import HNUExactCore` -> `import PhysicsSM.Draft.NullEdge.HNUExactCore`
(confirmed to build clean). Port the `HNUInfraredTangent` namespace into
`PhysicsSM.Draft.NullEdge`.

## Bottom line

APPROVE. A genuine positive result: the continuum Weyl generator `-i (k·sigma)`
emerges as an EXACT first derivative (`HasDerivAt`) of the discrete depth-eight HNU
Floquet endpoint at the origin, with correct signs, order, half-step handling, and
a nonzero witness - the first-order infrared tangent (Bridge B1), correctly scoped
short of any error-bound / PDE / topology / primitive-null claim. Independent build
green.
