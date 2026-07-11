# Aristotle proof job: finite physical channel cohomology

Name this project `codex-pub-channel-physical-cohomology-20260711`.

Run the narrow target first:

```text
lake env lean ChannelPhysicalCohomology/Main.lean
```

Prove the three stated finite-matrix theorems without weakening hypotheses or
changing matrix orientations.  The central statement must identify zero
physical compression `p X i = 0` exactly with a null-homotopic chain map
`X = Q H + H Q`, using the supplied contraction data.  Audit the proposed
explicit homotopy `sX + (ip)Xs`; if it is wrong, return the corrected formula
and smallest counterexample to the proposed one.

Add an exact low-dimensional witness/control triple:

1. a nonzero null-homotopic chain map with zero physical compression;
2. a chain map with nonzero physical compression;
3. a boundary control showing which hypothesis is load-bearing.

Do not claim locality, BRST physics, a canonical carrier constraint, or a
classification of live channel refinements.  This job proves the algebraic
quotient theorem only.  Do not introduce new assumptions to force the result.

```yaml
aristotle:
  project_id: 82b10567-ac62-4c3a-b083-401b85885588
  task_id: 28c8ef30-b194-42f1-a86f-1cc694878ada
  target_file: ChannelPhysicalCohomology/Main.lean
  expected_module: ChannelPhysicalCohomology.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-channel-physical-cohomology-20260711-project
  output_dir: AgentTasks/aristotle-output/82b10567-ac62-4c3a-b083-401b85885588
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Independent local attempt

The paper calculation was expanded independently.  No mathematical
counterexample appeared: the key derived identities are `Q(ip)=0`, `(ip)Q=0`,
`(ip)X(ip)=0`, and `(ip)XsQ=(ip)X`.  The local Lean attempt was rolled back to
the typechecking handoff statements after rectangular matrix products made
generic noncommutative-ring normalization inapplicable and explicit
`Matrix.mul_assoc` orientations became the proof-engineering bottleneck.  This
is an API/reassociation blocker, not evidence against the theorem.  Aristotle
should prefer small typed associativity lemmas over ring normalization.

## Harvest and integration

Aristotle returned a proof-complete file with the original theorem statements
unchanged and confirmed the explicit homotopy.  It added the requested rational
`Fin 3` witness/control triple and proved that the chain-map condition is
load-bearing.  The downloaded source had no proof holes or escape-hatch tokens
and compiled independently against the live project.  The result is integrated
as `PhysicsSM/Draft/NullEdge/ChannelPhysicalCohomology.lean` under the project
namespace, with standard-three per-module and consolidated guards.  The live
carrier constraint, bounded-range homotopy condition, and automorphism quotient
remain open by design.
