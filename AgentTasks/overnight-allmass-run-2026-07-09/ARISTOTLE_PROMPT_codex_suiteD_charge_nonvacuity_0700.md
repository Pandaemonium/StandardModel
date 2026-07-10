# codex-suiteD-charge-nonvacuity-0700-20260709

aristotle:
  project_id: 1a4d58e1-5f80-40ad-9a2d-534414caae3d
  target_file: PhysicsSM/Draft/NullEdge/SuiteDChargeNonvacuity.lean
  expected_module: PhysicsSM.Draft.NullEdge.SuiteDChargeNonvacuity
  submission_project: AgentTasks/aristotle-submit/codex-next-round-0700-20260709-project
  output_dir: AgentTasks/aristotle-output/1a4d58e1-5f80-40ad-9a2d-534414caae3d
  status: harvested and ported 2026-07-09 ~07:35

You are Aristotle, proving a small Suite D audit/nonvacuity theorem in Lean.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/SuiteDChargeNonvacuity.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.ModularSelection
import PhysicsSM.Draft.NullEdge.SuiteCDNextRungs
```

Context:
- `SuiteCDNextRungs.channel_charges_pairwise_commute` proves the four
  coordinate-basis channel charges commute pairwise.
- `SuiteCDNextRungs.channel_charges_commute_with_Bsum` proves each commutes with
  the total generator `Bsum`.
- The audit wants a nonvacuity / false-shape guard: the charges are not all the
  same zero/central object, and the commutativity theorem is a finite diagonal
  fact rather than an empty-index artifact.

Task:
Create `SuiteDChargeNonvacuity.lean` with small concrete witness lemmas.

Preferred theorem shapes, adjusted only if the current API needs it:

```lean
namespace SuiteDChargeNonvacuity

open ModularSelection

theorem channel_charges_distinct :
    QA <> QC /\ QA <> QT /\ QA <> EE /\ QC <> QT /\ QC <> EE /\ QT <> EE := ...

theorem channel_charges_nonzero :
    QA <> 0 /\ QC <> 0 /\ QT <> 0 /\ EE <> 0 := ...

theorem commuting_product_nonzero_witness :
    QA * QC = QC * QA /\ QA * QC <> 0 := ...

theorem bsum_noncentral_witness :
    Bsum <> 0 /\ Bsum <> (Bsum.trace / 5) • (1 : Matrix (Fin 5) (Fin 5) Complex) := ...

end SuiteDChargeNonvacuity
```

The goal is an audit guardrail, not new physics. Keep statements finite,
coordinate-basis, and honest. Add guard pins for the headline theorems.

Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/SuiteDChargeNonvacuity.lean
```

Return a short summary of solved targets, any statement changes, and
a x i o m
footprints.
