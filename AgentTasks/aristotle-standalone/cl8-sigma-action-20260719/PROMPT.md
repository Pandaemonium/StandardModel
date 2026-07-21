# Task: the sigma action completes S3 on the Cl(8) colour generators (P5)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, P5 lane.
Self-contained package (17 modules). BOTH anchors landed tonight and are
included PROVEN: `Cl8TrialityAction` (all nine rho3 theorems; its proof
patterns - coordinate `ext <;> simp [rho3c, rho3o, c_i, c_j]` for images,
`rw [C_i, rho3c_mul, image] ; ext <;> simp <;> ring` for conjugations,
`fin_cases a <;> simp [...] <;> ext <;> simp <;> ring` for the packaging -
transfer DIRECTLY to sigma) and the seed's `sigmac` layer (`sigmao_sq`,
`sigmao_mul`, `sigma_rho3_braid`, alpha images).

## Target

`PhysicsSM/Draft/NullEdge/Cl8SigmaAction.lean` - eight theorems ending in
a hole:

1. `sigmac_c1 .. sigmac_c6` - the six hand-computed images
   (`(c2 c3)(c5 c6)` with all signs `-1`; c1, c4 map to their negatives).
   Same coordinate pattern as the landed rho3 images.
2. `sigma_conj_colourGen` - the indexed packaging with
   `sigmaPerm = ![0, 2, 1, 3, 5, 4]`, `sigmaSign = all -1`; use
   `sigmac_mul` (or lift `sigmao_mul` if the complex version is missing -
   adding that lift lemma is in-scope).
3. `s3_braid_on_colourGen` - the S3 relation at the index level
   (finite check over `Fin 6`; `decide`/`fin_cases`).

## Pre-registered honesty license

If any sign differs at the kernel, prove the true value, rename, record
prominently, propagate through the tables; the permutation structure
should survive. If the braid relation as stated at the index level has
the composition order reversed, fix the order honestly and record it.

## Constraints

- Do not modify included modules. No new axioms/escapes; standard axioms
  only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/Cl8SigmaAction.lean`.

## Success criteria

All eight theorems (with honestly-corrected signs/order if needed) proven,
zero holes, completion report: corrections made, axioms used.

## RESTART ADDENDUM (2026-07-19 08:25)

First harvest applied: all six sigma-image computations are PROVEN.
Remaining holes are the job: `sigmac_mul` (multiplicativity of the
complexified sigma action - reduce to the real octonion automorphism
property of the underlying triality map) and the downstream packaging
pair. All other instructions unchanged.
