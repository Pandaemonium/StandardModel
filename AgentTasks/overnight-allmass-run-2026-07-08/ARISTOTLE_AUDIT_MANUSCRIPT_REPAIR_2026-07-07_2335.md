# Aristotle audit job - all-mass manuscript repair plan 2026-07-07 23:35 PDT

```yaml
aristotle:
  project_id: ff8e265c-ffa8-49f3-9a16-5194467c5506
  task_id: 25364b86-0f1f-43f8-bcb7-b40e24d8fb49
  target_file: Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md
  expected_module: none
  submission_project: none
  output_dir: AgentTasks/aristotle-output/ff8e265c-ffa8-49f3-9a16-5194467c5506-extracted/25364b86-0f1f-43f8-bcb7-b40e24d8fb49_aristotle
  status: harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_MANUSCRIPT_REPAIR_2026-07-07_2335.md)
```

## Prompt

You are Aristotle, asked for a manuscript repair-plan audit, not a proof
attempt.

Context: Claude drafted `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`
for the overnight null-edge all-mass run. Codex independently audited gates
G1/G2/G4 and found blocking issues. Please review whether the findings below are
properly classified and give the minimal repair plan before MORNING_REPORT may
call the manuscript delivered.

Run spec:

```text
G1: non-drafting-agent audit for over-claim modes: vacuity, hollow telescoping,
docstring-outruns-kernel, false shape.
G2: independent anchor sweep. Section 11 must include every theorem cited in
sections 3-9 with exact declaration name, file, guard-pin status, and axiom
footprint. A nonexistent or unpinned-but-claimed-pinned declaration is P0.
G4: kill-list check: Koide, Tr E, defect-Gram-as-Q_C, one-sided GW /
retardedness-only no-doubling, and related expected dead routes must be reported.
```

Codex audit result:

```text
G2 existence sweep: current section-11 table has 28 rows and all 28 declarations
exist in their stated files.

P0: `onshell_wedge_normSq_eq_coin_sq` is cited as M-grade in section 5 and
exists in `PhysicsSM/Draft/NullEdge/GateI1/MassCoinBridge.lean`, but is missing
from section 11 and has no observed guard pin in CarrierAxiomGuard/SlabAxiomGuard.
The M label in the manuscript says axiom-audited, guard-pinned.

P1: section 11 lacks row-level grade, guard-pin status, and axiom-footprint
columns. It only has section, declaration, file, and role.

P1: section 3 is called trusted, but the table cites draft Aristotle files for
the Plucker declarations rather than `PhysicsSM/Spinor/PluckerMass.lean`, where
the same trusted declarations exist.

P1: section 6/table wording for `closure_current_square` reads too much like a
kernel-checked concrete `Q_C = L^#L` carrier theorem. The Lean theorem is the
abstract skew-pairing square; concrete two-transport identification is
MEMO/oracle/queued.

P1: section 4/table calls `carrier_square_assembly` a four-slot split, but the
landed theorem and budget are the three-block `D^2` identity
`Q_A + Q_C + 4 Q_T` and `b_A + b_C + b_T = 1`. The four-slot E-budget should be
C-grade unless a `D^#D` theorem has landed.

G4: passes on content. The manuscript reports Koide, Tr E, defect-Gram-as-Q_C,
positive-gluon-energy conflation, cyclic zero-mode forcing, retardedness-only
no-doubling / one-sided GW, and premature spectral-measure language.
```

Request:

1. Confirm, downgrade, or upgrade each P0/P1 classification.
2. Give the minimal text/table repair plan that should unblock G1/G2.
3. Say whether adding a guard row for `onshell_wedge_normSq_eq_coin_sq` is
   sufficient, or whether an actual guard pin must be added before M-grade.
4. Identify any remaining overclaim risk in the above repair plan.
5. Return a short final verdict: "deliverable after fixes" vs "needs deeper
   rewrite".

Return sections: verdict, classification audit, minimal repairs, remaining risk.

## Harvested result

Status: complete; downloaded to the `output_dir` above. Main report:
`AgentTasks/aristotle-output/pending/MANUSCRIPT_REPAIR_AUDIT_2026-07-08.md`
inside the extracted project.

Verdict:

- Deliverable after fixes; no deeper rewrite required.
- Confirms Codex's P0 for `onshell_wedge_normSq_eq_coin_sq`: M-grade means
  guard-pinned, so the manuscript must either add a real guard pin and record
  its footprint, or downgrade the claim. A table row alone is not sufficient.
- Confirms P1 findings for missing grade/guard/axiom columns, trusted §3
  anchors pointing at draft files, `closure_current_square` wording outrunning
  the abstract theorem, and four-slot language outrunning the landed three-slot
  `D^2` budget.
- Confirms G4 passes.
- Minimal repair: add row-level grade/guard/axiom columns from observed values;
  add or downgrade the missing on-shell row; repoint §3 to the trusted
  `PluckerMass.lean` declarations after rechecking; reword §4 and §6 to match
  landed kernel shapes.
