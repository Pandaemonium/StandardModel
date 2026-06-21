# Aristotle task: null-edge Yukawa gauge-legality bookkeeping

Date: 2026-06-21

## Goal

Prove the finite gauge-bookkeeping theorems for Higgs-permitted chirality
flips in the null-edge causal graph program.

Target file:

```text
PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean
```

This builds on:

```text
PhysicsSM/Draft/NullEdgeYukawaFlip.lean
PhysicsSM/StandardModel/OneGenerationTable.lean
PhysicsSM/StandardModel/AnomalyPackage.lean
```

## Why this target

The existing `NullEdgeYukawaFlip` theorem proves the `U(1)_Y` part of the
claim: the usual Higgs or conjugate-Higgs insertion makes each one-generation
Yukawa flip hypercharge neutral.

The next finite layer is to record the rest of the representation pattern:

- sources are left-handed and targets are right-handed;
- sources are weak doublets, targets are weak singlets, and Higgs insertions
  are weak doublets;
- lepton channels are color singlet-to-singlet and quark channels are
  triplet-to-triplet, so `bar(left) * right` contains a color singlet.

This is still representation bookkeeping.  It does not prove full tensor
product representation theory or mass generation dynamics.

## Target declarations

```lean
higgsInsertion_hypercharge_matches
leftMultiplet_chirality_left
rightMultiplet_chirality_right
weakYukawaPattern_all
colorNeutralPattern_all
gaugeLegalPattern_all
```

## Constraints

- Keep the module in `PhysicsSM.Draft`.
- Do not introduce `axiom`, `opaque`, `unsafe`, `admit`,
  proof-command `sorry`, or `native_decide` in the final result.
- Helper lemmas are welcome in the same file.
- Do not weaken the claim boundary: this file is only finite representation
  bookkeeping.
- This job should remain SPL-free.

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean
lake build PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle
```

Then scan the target file for proof-command placeholders and forbidden
constructs.

## Submission

```yaml
aristotle:
  project_id: 6fe6a877-4ad1-4b70-91f0-ace14eb90a13
  task_id: 8e0426ea-f39f-4038-a938-1b1553c8beab
  target_file: PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeYukawaGaugeAristotle
  submission_mode: continue
  status: integrated
  last_checked: COMPLETE
```

## Result and integration

Aristotle reported all six target theorems proved by finite case analysis over
the four `YukawaFlip` channels.

Integrated locally:

- `higgsInsertion_hypercharge_matches`
- `leftMultiplet_chirality_left`
- `rightMultiplet_chirality_right`
- `weakYukawaPattern_all`
- `colorNeutralPattern_all`
- `gaugeLegalPattern_all`

The integration keeps the original claim boundary: this is finite
representation-pattern bookkeeping only, not a proof of full tensor-product
representation theory or mass-generation dynamics.

Verification run locally:

```text
lake env lean PhysicsSM/Draft/NullEdgeYukawaGaugeAristotle.lean
```
