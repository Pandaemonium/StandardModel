# Aristotle task: canonical live HNU Cayley band selector

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated

## Objective

Close every proof handoff in
`PhysicsSM/Draft/NullEdge/HNUCayleyBandSelectorCanonical.lean` without changing
any theorem statement. This package composes the landed massive HNU zero/pi
gap, inverse Cayley generator, and certified-sign uniqueness into a canonical
live endpoint selector.

## Exact targets

1. `certifiedSign_commutes_cayleyUnitary`
2. `hnuCayley_certifiedSign_commutes_endpoint`
3. `hnuCayleyGenerator_rest`
4. `beta_signCertificate_rest`
5. `hnuCayley_certifiedSign_rest_unique`
6. `hnuCayley_negativeProjector_rest`

## Mathematical content

For `U + 1` invertible, reconstruct `U` rationally from
`A = i (U - 1) (U + 1)^-1`; hence every matrix commuting with `A` commutes with
`U`. At the live rest fiber,

```text
U(a,0) = cos(a) 1 - i sin(a) beta,
A(U(a,0)) = tan(a/2) beta.
```

Since `0 < a < pi`, `tan(a/2) > 0`, so `beta` is the unique certified sign and
the negative projector is `(1 - beta)/2`.

## Honesty gates

- Preserve the inverse-Cayley order and sign exactly.
- Do not change the mass interval or add a simple-spectrum hypothesis.
- Do not replace the live `massiveHNU` endpoint by a supplied unitary.
- Do not infer companion removal, physical occupation, continuity,
  quasi-locality, or interaction stability.
- If the rest identity has the opposite sign, return the exact calculation and
  smallest counterexample; do not silently edit the statement.

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUCayleyBandSelectorCanonical.lean
```

On success, add a dedicated guard and report the final assumption footprint.

The live statements typecheck with exactly the six declared proof handoffs.
Semantic context:
`AgentTasks/context-packs/hnu-cayley-band-selector-canonical-20260721-20260721-130922.md`.

## Integration result

Aristotle returned kernel-checked proofs of the generic inverse-Cayley
commutation lemma and the exact rest-frame tangent formula. These were adapted
to the live definitions without changing any target statement. The remaining
HNU wrapper, positive `beta` sign certificate, certified-sign uniqueness, and
negative-projector identity were closed locally.

Verified commands:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUCayleyBandSelectorCanonical.lean
lake build PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical
lake env lean PhysicsSM/Draft/NullEdge/HNUCayleyBandSelectorCanonicalAxiomGuard.lean
```

The dedicated guard pins all six theorems to
`[propext, Classical.choice, Quot.sound]`. No physical-sector completeness,
companion-removal, continuity, or position-space locality is inferred.

```yaml
aristotle:
  project_id: 9006d3df-ecea-499c-b996-5b08b948f312
  task_id: a5f71bfa-4de3-4e1f-9878-139c6bc295c9
  target_file: PhysicsSM/Draft/NullEdge/HNUCayleyBandSelectorCanonical.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical
  submission_project: AgentTasks/aristotle-submit/hnu-cayley-canonical-20260721-project
  status: integrated
```
