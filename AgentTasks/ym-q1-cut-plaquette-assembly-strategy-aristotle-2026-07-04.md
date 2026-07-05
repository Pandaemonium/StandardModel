# Aristotle task note: Q1 cut-plaquette assembly strategy

```yaml
aristotle:
  project_id: 8271a64b-c45b-4f31-8c76-5c6fdc93bcd8
  task_id: e152ffe8-6bb7-4fae-8781-f274a6a53bd9
  target_file: PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
  submission_project: AgentTasks/aristotle-submit/ym-q1-cut-plaquette-assembly-strategy-20260704-project
  output_dir: AgentTasks/aristotle-output/ym-q1-cut-plaquette-assembly-20260704.zip
  status: harvested-integrated
```

## Purpose

Ask Aristotle for a proof-design and semantic-audit artifact for Q1's actual
Wilson cut-plaquette reflection-positivity assembly, using the newly landed
product/Hadamard/PSD connector lemmas in `ReflectionPositivityKernel.lean`.

This is not a claim that full RP-LINK is closed. The target is to identify the
smallest semantically correct next Lean theorem and proof DAG for the
non-degenerate cut-plaquette geometry.

## Local preflight

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel`
- `lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM`
- Placeholder scan on `ReflectionPositivityKernel.lean`
- Stdin dependency audits for the new connector lemmas

All above passed before this submission was prepared. The aggregate build
still reports known pre-existing warnings and the intended Q6 draft proof
handoffs in `PolymerKPConclusion.lean`.

## Context pack

`AgentTasks/context-packs/ym-q1-cut-plaquette-assembly-20260704-20260704-161145.md`

The doc-index refresh attempted before generating the context pack timed out
after roughly two minutes, so the prompt explicitly names the authoritative
Lean/run-note files instead of relying on context-pack relevance.

## Submission log

- 2026-07-04: Prepared package with
  `Scripts/prepare_aristotle_submission.ps1` using `-NoRemoteSpherePacking`
  because this project has no active SpherePacking dependency to patch.
  Package structural checks passed for
  `ReflectionPositivityKernel.lean`, `WilsonReflectionPositivity.lean`, and
  `MirrorHolonomyResolution.lean`.
- 2026-07-04: Submitted with
  `aristotle submit --project-dir AgentTasks/aristotle-submit/ym-q1-cut-plaquette-assembly-strategy-20260704-project`.
  CLI warned that the package contains Lean files but no `.lake` folder; this
  is accepted for a semantic/proof-design audit package. Project
  `8271a64b-c45b-4f31-8c76-5c6fdc93bcd8`, task
  `e152ffe8-6bb7-4fae-8781-f274a6a53bd9`, initially `QUEUED`.

## Harvest record

Aristotle returned COMPLETE with verdict PROCEED.

Integrated deliverable:

```text
PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquettePositivity.lean
```

The integrated module proves the cut-plaquette kernel-algebra bridge:

- `posSemidef_map_ofReal`
- `cutKernel_posSemidef_of_wilsonFactor`
- `reflectionForm_nonneg_of_wilsonFactor`
- `reflectionForm_nonneg_of_wilsonFactor_prod`

Semantic boundary: this closes the single-factor and finite-product Wilson
cut-kernel PSD bridge by identifying each cut factor with a principal submatrix
of the Wilson one-plaquette kernel. It does not yet build the concrete
cut-plaquette lattice, the mirror-coordinate equivalence, or the proof that the
genuine cut-lattice `PlaquetteEnsemble.weight` has the required cut-factor
form. Full RP-LINK therefore remains open at the concrete geometry layer.

Returned strategy report:

```text
AgentTasks/aristotle-output/ym-q1-cut-plaquette-assembly-strategy-20260704-project_aristotle/AgentTasks/aristotle-output/ym-q1-cut-plaquette-assembly-20260705/ANALYSIS_Q1_CUT_PLAQUETTE.md
```

The returned `GateYM.lean` aggregator was stale relative to the live tree and
was not copied wholesale.

## Local verification after integration

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquettePositivity.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquettePositivity`
- `lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM`
- Diff hygiene scan for new prose/code additions
- Dependency footprint audit for `posSemidef_map_ofReal`,
  `cutKernel_posSemidef_of_wilsonFactor`, and
  `reflectionForm_nonneg_of_wilsonFactor_prod`:
  `[propext, Classical.choice, Quot.sound]`

## Follow-up local geometry slice

After integrating the returned kernel-algebra bridge, Codex added
`PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteExample.lean`.
That local follow-up supplies a minimal four-edge cut-plaquette lattice,
mirror-coordinate equivalence, holonomy factorization, and the specialized
Wilson cut-factor RP-KER theorem. A second local follow-up added
`cutPlaquette_weight_mirrorConfig_eq_wilsonKernel` and
`cutPlaquette_ensemble_reflectionPositive`, identifying the genuine singleton
`PlaquetteEnsemble.weight` and proving one-plaquette concrete RP. Full RP-LINK
still requires finite product/general cut-ensemble assembly. Codex also added
`reflectionForm_nonneg_of_factorized_mul_wilsonFactor_prod` to
`WilsonCutPlaquettePositivity.lean`, closing the mixed kernel-algebra product
shape needed before concrete finite plaquette-family instantiation. The theorem
`factorized_mul_cutPlaquette_ensemble_reflectionPositive` instantiates that
mixed product shape for the singleton concrete cut-plaquette ensemble.
