
# Null-edge Aristotle Wave 14 submissions - 2026-06-26

Purpose: next batch after integrating Wave 12/13. This wave focuses on the Route-B Gate C release blockers and the concrete Furey finite-layer bridge.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`

| Job | Status | Prompt | Aristotle project ID | Submission project |
|---|---|---|---|---|
| c63-post-gauge-ghost-safety-residue | pending | `AgentTasks/aristotle-wave14-20260626-prompts/c63-post-gauge-ghost-safety-residue.md` | | |
| c64-full-nodal-set-exhaustion-audit | pending | `AgentTasks/aristotle-wave14-20260626-prompts/c64-full-nodal-set-exhaustion-audit.md` | | |
| c65-canonical-species-selector-or-nogo | pending | `AgentTasks/aristotle-wave14-20260626-prompts/c65-canonical-species-selector-or-nogo.md` | | |
| fur-h7-concrete-furey-phi-h-j-jstar | pending | `AgentTasks/aristotle-wave14-20260626-prompts/fur-h7-concrete-furey-phi-h-j-jstar.md` | | |
| fur-h8-number-parity-chi-e-actual-ideal | pending | `AgentTasks/aristotle-wave14-20260626-prompts/fur-h8-number-parity-chi-e-actual-ideal.md` | | |
| fur-h9-conjugate-ideal-live-bridge | pending | `AgentTasks/aristotle-wave14-20260626-prompts/fur-h9-conjugate-ideal-live-bridge.md` | | |

## Integration prerequisites

- Wave 12 completed jobs integrated except `c59`, which was still running at integration time.
- Wave 13 Furey/internal-spectrum jobs integrated.
- These submissions avoid depending on `c59` as a completed result.

## Intended outputs

| Job | Intended output |
|---|---|
| C63 | `PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean` plus a ghost-safety report. |
| C64 | `PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean` plus a nodal-set report. |
| C65 | `PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean` plus selector/no-go report. |
| FUR-H7 | `PhysicsSM/Draft/NullEdgeFureyConcretePhiH.lean` plus concrete finite-Higgs report if useful. |
| FUR-H8 | `PhysicsSM/Draft/NullEdgeFureyNumberParityChiE.lean` plus summary/report. |
| FUR-H9 | `PhysicsSM/Draft/NullEdgeFureyConjugateIdealBridge.lean` plus summary/report. |

## Submission results - 2026-06-26

Submission project: `AgentTasks/aristotle-submit/null-edge-wave14-route-b-furey-bridge-20260626-project`

| Job | Return code | Aristotle project ID | Raw result |
|---|---:|---|---|
| c63-post-gauge-ghost-safety-residue | 0 | `c7419da4-de69-4d5e-b326-97336952fff5` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: c7419da4-de69-4d5e-b326-97336952fff5` |
| c64-full-nodal-set-exhaustion-audit | 0 | `8f5c1a1c-f72d-4c03-ac50-7f1548c02344` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: 8f5c1a1c-f72d-4c03-ac50-7f1548c02344` |
| c65-canonical-species-selector-or-nogo | 0 | `b667cf5e-928a-4e50-aff5-f3a1c96afbfa` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: b667cf5e-928a-4e50-aff5-f3a1c96afbfa` |
| fur-h7-concrete-furey-phi-h-j-jstar | 0 | `6cb212cb-a813-407f-bde3-bd9ce4318136` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: 6cb212cb-a813-407f-bde3-bd9ce4318136` |
| fur-h8-number-parity-chi-e-actual-ideal | 0 | `2426ebbd-b926-43be-a277-0890d28b87f6` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: 2426ebbd-b926-43be-a277-0890d28b87f6` |
| fur-h9-conjugate-ideal-live-bridge | 0 | `8b107be1-a37e-4f51-9884-a0f466995d33` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: 8b107be1-a37e-4f51-9884-a0f466995d33` |

## C59 follow-up instruction - 2026-06-26

The C59 projected Gate C release API completed after Wave 14 was submitted. The new module `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` was attached to the three Gate-C Wave 14 jobs with an instruction to align their outputs to its seven-clause release certificate.

| Job | Project ID | Return code | Result |
|---|---|---:|---|
| c63-post-gauge-ghost-safety-residue | `c7419da4-de69-4d5e-b326-97336952fff5` | 2 | `usage: aristotle continue [-h] [--api-key API_KEY] [--mode {ask,instruct}] [--files [FILES ...]] [--wait] project_id prompt aristotle continue: error: the following arguments are required: project_id, prompt` |
| c64-full-nodal-set-exhaustion-audit | `8f5c1a1c-f72d-4c03-ac50-7f1548c02344` | 2 | `usage: aristotle continue [-h] [--api-key API_KEY] [--mode {ask,instruct}] [--files [FILES ...]] [--wait] project_id prompt aristotle continue: error: the following arguments are required: project_id, prompt` |
| c65-canonical-species-selector-or-nogo | `b667cf5e-928a-4e50-aff5-f3a1c96afbfa` | 2 | `usage: aristotle continue [-h] [--api-key API_KEY] [--mode {ask,instruct}] [--files [FILES ...]] [--wait] project_id prompt aristotle continue: error: the following arguments are required: project_id, prompt` |

## C59 follow-up instruction - 2026-06-26

The C59 projected Gate C release API completed after Wave 14 was submitted. The new module `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` was attached to the three Gate-C Wave 14 jobs with an instruction to align their outputs to its seven-clause release certificate.

| Job | Project ID | Return code | Result |
|---|---|---:|---|
| c63-post-gauge-ghost-safety-residue | `c7419da4-de69-4d5e-b326-97336952fff5` | 0 | `Prompt submitted to project c7419da4-de69-4d5e-b326-97336952fff5` |
| c64-full-nodal-set-exhaustion-audit | `8f5c1a1c-f72d-4c03-ac50-7f1548c02344` | 0 | `Prompt submitted to project 8f5c1a1c-f72d-4c03-ac50-7f1548c02344` |
| c65-canonical-species-selector-or-nogo | `b667cf5e-928a-4e50-aff5-f3a1c96afbfa` | 0 | `Prompt submitted to project b667cf5e-928a-4e50-aff5-f3a1c96afbfa` |


## Partial integration update - 2026-06-26

Four Wave 14 projects were idle at review time. Only `c65` produced an
integration-ready result. The three Furey bridge jobs `fur-h7`, `fur-h8`, and
`fur-h9` ended `OUT_OF_BUDGET` without `ARISTOTLE_SUMMARY.md`, so no returned
context-copy files from those packages were integrated.

| Job | Integrated files | Result |
|---|---|---|
| C65 | `PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean`; `AgentTasks/null-edge-c65-canonical-species-selector-report.md` | The retained sector `{0,2}` is canonical relative to the locked Krein-sign data, but not absolutely canonical from chirality/taste/energy/grading alone. The literal branch pair remains modulus-sensitive unless the Krein sign is declared as locked input; the structural phrase "maximal Krein-positive pair" is safe. |

Still running at this integration point: `c63-post-gauge-ghost-safety-residue`
and `c64-full-nodal-set-exhaustion-audit`.

## Follow-up integration - 2026-06-26 (C64)

`c64-full-nodal-set-exhaustion-audit` (`8f5c1a1c-f72d-4c03-ac50-7f1548c02344`)
completed and is integrated. Full-repo package; the only new file is
`PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean` (all other tree files were
unchanged context copies; `NullEdgeProjectedGateCRelease` already lives at the
relocated `PhysicsSM/Draft/` path in the repo and was byte-identical, so nothing
was relocated). `c63` status not re-checked here.

| Job | Integrated files | Result |
|---|---|---|
| C64 | `PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean`; `AgentTasks/null-edge-c64-nodal-set-exhaustion-report.md` | **Nodal-set exhaustion is FALSE.** The C43/C44 certified components (origin + four branch-line curves) do **not** exhaust the determinant-zero locus: explicit exactly-algebraic witness `q* = (2pi/3, 0, 0, 4pi/3)`, `u* = (omega-1, 0, 0, omega^2-1)` with `omega = exp(2 pi i/3)`, satisfies `qform u* = 0` (`extra_qform_zero`) and the full null-slash determinant `mink (pCov u*) = 0` (`extra_mink_zero`), is nonzero (`extra_ne_origin`), and lies on **none** of the four branch lines (`extra_not_on_branchLine`; it has two vanishing components vs a branch line's one). Crucially `extra_Msplit_g5_zero`/`g5_split_not_full_nodal_control`: the C60 `g5` species-split term `M_split = r.T_lin` **vanishes at `q*` for every `r`**, so it does not gap this off-branch zero. Stated against the seven-clause `NullEdgeProjectedGateCRelease` API: blocks **Clause 1 `NodalSetControlled`** in its faithful full-locus reading (`nodalSetControlled_does_not_imply_full_control`), other six clauses untouched. Three zero notions (scalar q-form / full Clifford determinant / projected physical-sector) kept explicitly distinct. Kernel-clean (9 theorems; `propext, Classical.choice, Quot.sound`; no `sorry`/`native_decide`). Verified `lake build PhysicsSMDraft` exit 0 (8709 jobs). |


## Missed-result integration addendum - 2026-06-26

A follow-up sweep found that `c63-post-gauge-ghost-safety-residue` had completed
after Claude's note. It has now been integrated.

| Job | File | Result |
|---|---|---|
| C63 | `PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean`; `AgentTasks/null-edge-c63-post-gauge-ghost-safety-report.md` | Instantiates the C59 ghost-safety/residue clause as far as currently possible. It proves residue control is equivalent to spectrum-level ghost-zero safety and that the full projected release follows from the other six C59 clauses plus residue control. It also proves the guardrail that projected chirality, nonzero flavored index, and gauge covariance still do not imply ghost safety. Clause 6 remains the actual operator-level residue/`PostGaugeGhostSafe` obligation. |
