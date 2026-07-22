# Aristotle task: derive a live HNU band selector by inverse Cayley transform

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated after two-hour partial harvest and local closure

## Objective

Eliminate every proof handoff in
`PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean` without changing its
definitions or theorem statements.

The target converts the already-gapped live massive HNU Floquet fiber to the
Hermitian matrix

```text
A(U) = i (U - 1) (U + 1)^-1.
```

The landed HNU theorem excludes both `+1` and `-1` throughout the closed
Brillouin cube for every mass angle in `(0, pi)`. The `-1` gap makes the inverse
Cayley transform well-defined and Hermitian; the `+1` gap makes it invertible.
The existing Gate-C2 certified-sign modules then supply a self-adjoint
involution and an orthogonal negative-sign projector.

Semantic context:
`AgentTasks/context-packs/hnu-cayley-band-selector-20260721-20260721-103444.md`.

## Exact targets

1. `cayleyGenerator_isHermitian`
2. `cayleyGenerator_isUnit`
3. `hnuCayleyGenerator_isHermitian`
4. `hnuCayleyGenerator_isUnit`
5. `hnuCayley_certifiedSign_exists`
6. `hnuCayley_negativeProjector_exists`

Run this narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean
```

## Available anchors

- `HNUPlueckerMassiveStay.massiveHNU_unitary`
- `HNUMassiveGlobalGap.massiveHNU_zero_pi_gap`
- `OverlapSignExistence.certifiedSign_exists`
- `OverlapSignHermitian.signCertificate_isHermitian`
- `Matrix.isUnit_iff_isUnit_det`
- `Matrix.invertibleOfIsUnitDet`

For a pointwise HNU generator, construct the local `Invertible` instance from
`hnuCayleyGenerator_isUnit`, then invoke the certified-sign API. The final
projector algebra follows from `eps * eps = 1` and `eps.IsHermitian`.

## Semantic and honesty gates

- Do not change or weaken any theorem statement.
- Do not add assumptions or new escape-hatch declarations.
- Do not replace the live `massiveHNU` fiber by a supplied unitary family.
- Preserve the inverse-Cayley sign and factor order exactly.
- The result is a finite momentum-space band-selector existence theorem. It is
  not a strict-locality theorem: matrix inversion can produce a nonlocal
  position-space kernel.
- It does not choose the physically occupied sector, prove adiabatic transport,
  or derive an observed mass scale.
- If the generic Hermiticity statement is false under the displayed unitary
  convention, return the exact sign/order correction and a counterexample;
  do not silently edit the definition.

## Provenance

C. Bourne, "Index Theory of Chiral Unitaries and Split-Step Quantum Walks,"
SIGMA 19 (2023) 053, DOI 10.3842/SIGMA.2023.053. This is a clean-room finite
matrix formalization of the Cayley-transform strategy, not copied source code.

## Completion report

The two-hour cutoff was reached while the Aristotle project remained running.
An in-progress snapshot was downloaded before cancellation. It contained
hole-free proofs of `cayleyGenerator_isHermitian` and
`cayleyGenerator_isUnit`; the four HNU-facing wrappers were still open. Codex
integrated those two proofs and closed the remaining four targets locally with
no statement changes.

Verification completed:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean
lake build PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector
lake env lean PhysicsSM/Draft/NullEdge/HNUCayleyBandSelectorAxiomGuard.lean
lake build PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorAxiomGuard
lake env lean PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean
```

The dedicated guard pins the generic Cayley bridge, live certified sign, and
negative-sign projector to `[propext, Classical.choice, Quot.sound]`. The
aggregate overnight guard also passed after the new import was added. A peer's
subsequent root build passed all 8580 jobs; its earlier missing-object failure
occurred during the non-atomic file/import landing window and was reproduced as
a build race, not a source defect.

```yaml
aristotle:
  project_id: 19f45c37-0a02-4c70-9f98-bb6f9dcdf227
  task_id: d462650b-f0bd-462f-90dd-c0190e6377c5
  target_file: PhysicsSM/Draft/NullEdge/HNUCayleyBandSelector.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector
  submission_project: AgentTasks/aristotle-submit/hnu-cayley-band-selector-20260721-project
  output_dir: AgentTasks/aristotle-output/19f45c37-0a02-4c70-9f98-bb6f9dcdf227
  status: integrated-after-partial-harvest
```
