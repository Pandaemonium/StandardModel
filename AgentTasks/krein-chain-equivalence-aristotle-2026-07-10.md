# Aristotle job: Krein-chain equivalence of decoders (intertwiner half)

Date: 2026-07-10.  Origin: Pro moduli-theory analysis (round-8, sec 2 and
theorem program C), triaged in `Sources/Null_Edge_Future_Directions.md`.
The same-carrier homotopy half landed 2026-07-09 as
`PhysicsSM/Draft/NullEdge/Carrier/DecoderChainHomotopy.lean`; this job is
the OTHER half its honest-scope note leaves open: an invertible intertwiner
`U` with `U Q = Q' U` and Krein isometry, and the invariance of the physical
data (cohomology matching both ways, cohomology action of the decoder,
spectrum under conjugation, positive inertia with finrank).  Together the
halves make carrier non-rigidity a controlled channel-gauge freedom.

## Metadata

```yaml
aristotle:
  project_id: 2687b7bb-68d7-4511-9f4d-e7b27e30e31c
  target_file: AgentTasks/aristotle-standalone/krein-chain-equivalence-20260710/KreinChainEquivalence/DecoderEquivalence.lean
  expected_module: KreinChainEquivalence.DecoderEquivalence
  submission_project: AgentTasks/aristotle-submit/krein-chain-equivalence-20260710-project
  output_dir: AgentTasks/aristotle-output/2687b7bb-68d7-4511-9f4d-e7b27e30e31c
  status: submitted
```

Integration: port next to `DecoderChainHomotopy` in the Carrier lane with
guard blocks; update the Round-8 triage table in Future Directions.
