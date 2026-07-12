# Aristotle audit: stationary-Weyl off-axis elimination

Review only the exact stationary-amplitude source, oracle, elimination memo,
and algebraic witness target. Do not edit files and do not run a broad build.
Return `B_OFFAXIS_ELIMINATION_AUDIT_REPORT.md`.

## Sources

- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeProjectorWalk.lean`;
- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`;
- `Scripts/oracle/analyze_stationary_amplitude_weyl.py`;
- `B_STATIONARY_WEYL_TANGENT_ELIMINATION_2026-07-12.md`;
- `codex_24h_b_stationary_weyl_algebraic_offaxis_alias.lean`.

## Required verdicts

1. Verify the phase convention and tangent-half-angle map; flag any sign or
   orientation mismatch.
2. Independently check that the three displayed integer numerator polynomials
   equal the live matrix's Pauli-vector equations after cancelling only
   nonzero real denominators.
3. Check the quintic branch Groebner identities for `tangentX` and `tangentY`.
4. Check the rational sign interval and whether it forces all three tangent
   coordinates nonzero.
5. Decide whether every theorem statement in the algebraic witness target is
   mathematically true as written, especially the actual `weylStep = I` claim.
6. Audit the statement “fully off-axis”: identify exactly which phases differ
   from one and whether any chart boundary is hidden.
7. Explain why the witness does not yet imply a complete four-root census;
   enumerate the `t_z=0`, sextic, and omitted-pi chart obligations.
8. Run the four overclaim checks and give the strongest manuscript-safe
   sentence if the target lands.

```yaml
aristotle:
  project_id: 43157e22-ae11-476b-b4fb-fc9c77223cc2
  task_id: d4ebffd1-81b1-4b17-8d61-15bc01584aeb
  target_file: review-only
  expected_module: B_OFFAXIS_ELIMINATION_AUDIT_REPORT.md
  expected_report: AgentTasks/24h-publication-run-2026-07-12/B_OFFAXIS_ELIMINATION_AUDIT_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-offaxis-elimination-audit-20260712-project
  output_dir: AgentTasks/aristotle-output/43157e22-ae11-476b-b4fb-fc9c77223cc2
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Harvest

The independent report was downloaded to
`B_OFFAXIS_ELIMINATION_AUDIT_REPORT.md`. It confirms the phase convention,
integer numerator scales, triangular identities, `+I` matrix sign, and
fully-off-axis reading. It also records the omitted real-root-free
`(1+t_z^2)^2` factor and rejects any complete-census claim until the converse
elimination and boundary charts are kernel checked. The proof and real-root
successors have since landed; the report's statement that their target still
contained handoff markers is historical at audit time.
