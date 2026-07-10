# Codex audit job: physical mass and bounded-continuum corrections

Read all source and prior-report files under `Audit/Inputs`. This is an
independent follow-up audit after the prior reports found a degenerate Hodge
witness, missing positivity, weak mass-scale control, implicit turn counts, and
pointwise-only continuum convergence.

Audit whether the new code actually closes those findings:

- `PositiveHodgePhysicalMass`: quotient-level eigenvalue well-definedness,
  conditional nonnegativity, nondegenerate quartet, genuine exact/non-closed
  pairing, positive/negative directions, and class cost `4/25`;
- `HodgePluckerMassBridge`: whether the shared `4/25` fixture is truly shared
  and exactly what remains assumed in `mu2 = m^2`;
- `CanonicalGramTurnDictionary`: squared-scale and nonnegative-scale uniqueness;
- `CheckerboardAmplitudeGluing`: explicit turn counts;
- `BoundedMomentumManyStepContinuum`: whether one explicit box constant really
  gives uniform bounded-parameter control and what is still missing for a PDE.

Return `PHYSICAL_MASS_CONTINUUM_AUDIT_02.md` with findings first, ordered by
severity. For each prior finding, mark CLOSED, PARTIALLY CLOSED, or OPEN with
exact declaration names. Check for vacuity, hidden assumptions, false shape,
normalization errors, degenerate forms, and docstring overreach. End with the
strongest manuscript paragraph now supported and the single next exact theorem.

```yaml
aristotle:
  project_id: cf75bf98-a78d-4cff-9366-81124d01fe25
  target_file: PHYSICAL_MASS_CONTINUUM_AUDIT_02.md
  submission_project: AgentTasks/aristotle-submit/codex-physical-mass-continuum-audit-20260710-02-project
  output_dir: AgentTasks/aristotle-output/cf75bf98-a78d-4cff-9366-81124d01fe25
  status: running
```
