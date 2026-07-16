# Aristotle target: variable pointwise isometries lift to vector-valued L2

## Strategic role

This is continuum rung F2-A2. The live null-edge theorem
`ChangingCellFourierPDE.momMult_isometry` proves that the exact Dirac
momentum multiplier preserves the Euclidean spinor norm at each momentum. The
missing bridge is to package a measurable variable operator family as an
honest complex-linear isometry on vector-valued `L2`, without assigning
physical point values to an `Lp` quotient class.

The theorem is deliberately generic and Mathlib-only. Once landed, the live
Dirac specialization needs only continuity, hence almost-everywhere strong
measurability, of `k |-> momMult m t k`.

## Immutable target

Prove `variablePointwiseL2Isometry`,
`variablePointwiseL2Isometry_coeFn`,
`variablePointwiseL2Isometry_id`, and
`variablePointwiseL2Isometry_neg` in `VariablePointwiseL2Isometry.lean`
without changing their definitions, hypotheses, scalar field, exponent, or
conclusions.

## Required route

1. Use `appliedRepresentative_memLp` and `MemLp.toLp` to define the map.
2. Prove additivity and complex homogeneity by `Lp.ext`, combining
   `MemLp.coeFn_toLp`, `Lp.coeFn_add`, and `Lp.coeFn_smul`. Do not evaluate an
   `Lp` class as a physical pointwise function.
3. Prove norm preservation through `Lp.norm_toLp` and
   `eLpNorm_congr_norm_ae`, using the supplied `hIso`.
4. Prove the almost-everywhere representative theorem.
5. Close both identity and negative-identity controls. The latter prevents a
   vacuous construction that always returns the input or zero.

Small reusable helper lemmas are welcome. Keep the public target names and
types fixed.

## Trust and boundary

- No new assumptions, trust-expanding evaluator, or placeholder declarations
  may remain in the returned file.
- This proves an `L2` linear isometry, not surjectivity, an isometric
  equivalence, strong continuity in time, a Fourier identity, or a PDE.
- The almost-everywhere coe theorem is the representative-safety contract. It
  is not license to assign invariant point values to arbitrary `Lp` classes.

## Verification

Run this narrow command before any broad build:

```text
lake env lean VariablePointwiseL2Isometry.lean
```

## Provenance

- Mathlib `MemLp.toLp`, `Lp.ext`, `Lp.norm_toLp`, and the continuous bilinear
  evaluation API.
- AFPL continuum strategy project `5d4f2be5-f731-40ea-9dee-d5716b20be69`.
- Exact pointwise physics input: Aristotle project
  `e790e78a-eab4-4ddd-bfa6-719a302efb5f`, integrated as
  `ChangingCellFourierPDE.momMult_isometry`.
