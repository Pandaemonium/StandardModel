# Aristotle: chirality-coupled reciprocal slice no-go

Prove the exact Gaussian-rational determinant factorizations and the two
unit-circle crossing existentials in
`codex_24h_b_coupled_reciprocal_slice_nogo.lean`. Preserve every statement.
The result kills grand strategy 7's P1 direct coupled embedding without making
a claim about enlarged-register P2 or other reciprocal architectures.

```yaml
aristotle:
  project_id: 06fe540d-54ff-423e-8595-fceeb9b54ee0
  task_id: 43032256-56ba-43c3-a1a6-035d15c5bcdf
  target_file: AgentTasks/aristotle-targets/codex_24h_b_coupled_reciprocal_slice_nogo.lean
  expected_module: PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-coupled-reciprocal-slice-nogo-20260711-project
  output_dir: AgentTasks/aristotle-output/06fe540d-54ff-423e-8595-fceeb9b54ee0
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Integrated result

Aristotle filled all thirteen proof holes without changing a theorem
signature.  The live module is
`PhysicsSM/Draft/NullEdge/CoupledReciprocalSliceNoGo.lean`.

The exact result proves:

- determinant one for the coupled reciprocal slice walk;
- closed Gaussian-rational formulas for `det(U-I)` and `det(U+I)` as squared
  reciprocal quartics;
- strict sign changes for the reduced real quadratics;
- a nonzero physical unit-circle momentum with an additional zero crossing;
- a nonzero physical unit-circle momentum with an additional pi crossing.

The existential roots are obtained by the intermediate value theorem and
`arccos`, not by numerical sampling.  The result kills only this direct
four-component coupled construction.  It does not rule out enlarged-register,
minimally doubled, or otherwise modified reciprocal architectures.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/CoupledReciprocalSliceNoGo.lean`
- `lake build PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo`

Both passed.  The flagship declarations are pinned to the standard footprint
`[propext, Classical.choice, Quot.sound]` locally and in the overnight aggregate
guard.
