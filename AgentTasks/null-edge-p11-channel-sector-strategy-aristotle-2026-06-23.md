# Aristotle task: P11 stable particle sectors strategy

```yaml
aristotle:
  project_id: 40413c03-ef9e-4692-be1e-7a60df4ce689
  target_file: NullEdgeP11ChannelSectorStrategy/Stub.lean
  expected_module: NullEdgeP11ChannelSectorStrategy.Stub
  submission_project: AgentTasks/aristotle-submit/null-edge-p11-channel-sector-strategy-20260623-project
  output_dir: AgentTasks/aristotle-output/40413c03-ef9e-4692-be1e-7a60df4ce689
  status: strategy-reviewed
```

Payload docs:

- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Interaction_Ontology.md`
- `AgentTasks/null-edge-codex-overnight-six-lane-aristotle-plan-2026-06-23.md`

Goal: design the smallest mathematically useful finite channel-sector scaffold
for particle identity in the null-edge program. Use the cited anchors
`RW63ZR9E` (preserved information / noiseless subsystems) and `KDEECE8M`
(quantum causal histories) as guardrails.

Required output:

1. Define the minimal data: finite transfer channel, calibrated momentum readout
   `P = M(rho)`, observer channel, stable/peripheral/metastable sector, and
   momentum-dependent branch.
2. Identify 5-8 small Lean theorem targets that are genuinely finite and not
   ontology-only.
3. Flag any target that would silently lose the energy scale by using only a
   normalized CPTP channel.
4. Recommend one first proof-only Aristotle package for P11.
5. If helpful, add small draft Lean scaffolds. Proof holes are allowed in this
   strategy job.

Completion report requested:

- most promising definition:
- highest-value first theorem:
- risky or misleading definitions to avoid:
- suggested next Aristotle job:

## Review / integration note

Aristotle returned a useful strategy scaffold and a clean standalone Lean file,
but the extracted report/source contains mojibake in physics notation and is not
being copied directly into the repo. The substance is integrated as guidance:

- The strongest P11 definition is a calibrated readout, not a normalized state:
  keep an unnormalized `2 x 2` momentum block `P`, its normalized celestial
  state, and the discarded trace/energy scale together.
- The best guardrail theorem is that normalized channel output alone loses
  invariant mass scale: different unnormalized momentum blocks can have the same
  normalized state but different determinants.
- Stable particle identity should be developed as a spectral sector of a finite
  transfer channel, with peripheral sectors for stable/noiseless information and
  subunit-modulus sectors for metastable lifetime.
- Avoid defining mass on a bare normalized/CPTP output; that silently turns an
  invariant mass statement into a frame-relative `m / E` statement.

Suggested follow-up if P11 becomes active again:

```text
null-edge-p11-readout-massreadout:
  Hermitian/PSD mass positivity,
  determinant invariance under the relevant frame action,
  observer-conditioned normalized state with explicit energy scale,
  and a statement separating invariant `det P` from normalized `m / E`.
```

Current priority decision: do not launch this immediately. P11 is useful as a
guardrail for ontology and particle-sector language, but the active theorem
budget is better spent on the P7/P1 observer-channel bridge and the P9
admissible coarse-map/source-visibility lane.
