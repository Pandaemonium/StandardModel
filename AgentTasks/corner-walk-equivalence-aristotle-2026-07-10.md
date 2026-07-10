# Aristotle job: exact corner-weight/unitary-walk equivalence (Pro-review integration)

Date: 2026-07-10 morning (Pro paper-review integration). The reviewer's second fix: the polynomial checkerboard kernel and the exact unitary coin are currently adjacent, not connected. This proves the exact finite relation: the two-weight kernel scaling law K[s,sw]_n = s^n K[1,w]_n; hence the unitary kernel = cos(a mu)^n x the checkerboard kernel at corner weight -i tan(a mu); the corner-to-straight ratio is exactly -i tan(a mu) (NOT i a mu at finite spacing); quarter-angle witness (ratio -i, kernels agree at n=2); degenerate boundary control at a mu = pi/2 (pure corner flip; correspondence is exactly the cos /= 0 regime). Statements hand-verified pre-submission. Anchors Paper I section 4 per the review.

```yaml
aristotle:
  project_id: 567202fe-8180-47a6-ac04-0173a844d268
  target_file: AgentTasks/aristotle-standalone/corner-walk-equivalence-20260710/CornerWalkEquivalence/TanCorrespondence.lean
  expected_module: CornerWalkEquivalence.TanCorrespondence
  submission_project: AgentTasks/aristotle-submit/claude-corner-walk-equivalence-20260710-project
  output_dir: AgentTasks/aristotle-output/567202fe-8180-47a6-ac04-0173a844d268
  status: complete; harvested, independently checked, integrated, and guarded
```

Local integration: `PhysicsSM/Draft/NullEdge/CornerWalkEquivalence.lean`.
The two renamed unused hypotheses do not alter either proposition. The exact
specialization retains the load-bearing `cos(a mu) != 0` assumption, plus a
quarter-angle witness and pure-flip boundary control.
