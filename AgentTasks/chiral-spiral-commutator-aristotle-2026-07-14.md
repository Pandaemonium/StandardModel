# Aristotle job: chiral spiral commutators (spiral-layer wave 1, job A)

Date: 2026-07-14
Requested by: user ("submit a round of Aristotle jobs" for the spiral-layer
targets from the 2026-07-14 zigzag-vs-spiral analysis session).

```yaml
aristotle:
  project_id: 9858b0d2-baf3-42d1-b939-142dfbef45cb
  task_id: 51681b5a-b233-463d-af33-d8f28942c624
  target_file: AgentTasks/aristotle-standalone/chiral-spiral-commutator-20260714/ChiralSpiralCore/ChiralSpiralCommutator.lean
  expected_module: ChiralSpiralCore.ChiralSpiralCommutator
  submission_project: AgentTasks/aristotle-submit/chiral-spiral-commutator-20260714-project
  source_root: AgentTasks/aristotle-standalone/chiral-spiral-commutator-20260714
  output_dir: AgentTasks/aristotle-output/9858b0d2-baf3-42d1-b939-142dfbef45cb
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/ChiralSpiralCommutatorAristotle.lean
```

## Goal

Land the finite commutator core of the "null edges form chiral spirals"
picture in the fixed-momentum chiral-basis Dirac avatar (4x4 over C, unit
momentum along +z): the transverse-velocity ladders A_pm satisfy
[D0, A_pm] = pm 2 (g5 * A_pm) (rotation sense = chirality), the double
commutator is 4 A_pm (zitterbewegung rate 2E), and the mass matrix's
commutator with the ladder is nonzero and purely chirality-off-diagonal
(mass couples the two counter-rotating spirals). Plus two scalar
helix-dictionary lemmas: on-shell transverse momentum squared = m^2, and
r * m = 1/2 iff r = 1/(2m).

## Statements (11, all placeholder-proof targets, do not weaken)

`g5_sq`, `comm_D0_g5`, `comm_D0_APlus`, `comm_D0_AMinus`,
`zitter_double_comm_APlus`, `zitter_double_comm_AMinus`,
`mass_comm_g5_odd`, `mass_comm_ne_zero`,
`transverse_momentum_sq_eq_mass_sq`, `spin_half_iff_zitter_radius`.

## Preflight

- Statements typechecked 2026-07-14 via
  `lake env lean AgentTasks/aristotle-standalone/chiral-spiral-commutator-20260714/ChiralSpiralCore/ChiralSpiralCommutator.lean`
  (only placeholder warnings).
- Focused standalone package (Mathlib-only imports); no context pack needed -
  the file is tiny and self-contained, conventions declared in the module
  docstring.
- Hand-verified entries: [D0, APlus] entry (0,1) = 4 = 2 * (g5*APlus)(0,1);
  lower block (2,3) = 4 = 2 * (+2); [betaM, APlus] entry (0,3) = -4 (nonzero,
  off-diagonal block).

## Semantic review checklist (for integration)

- Block convention: chirality +1 = indices 0,1; D0 = diag(1,-1,-1,1);
  g5 = diag(1,1,-1,-1). Check statements were not restated in a different
  block order.
- The ladder normalization sigmaPlus = !![0,2;0,0] (i.e. sigma1 + i sigma2,
  NOT the unit ladder) - factors of 2 in the commutators depend on it.
- Scalar lemmas: hypotheses must remain exactly hE : E /= 0 and the shell
  condition; no positivity strengthening.
- Axiom audit per theorem; no compiled-evaluator decision tactic.

## Integration plan

Copy proved file to `PhysicsSM/Draft/NullEdge/ChiralSpiralCommutatorAristotle.lean`
under the `PhysicsSM.Draft.NullEdge` namespace conventions, cross-reference
`HelicityChirality.lean` (block-order note), run targeted `lake env lean`,
then the usual placeholder scan and axiom audit.

## Integration result

Aristotle marked the remote task `COMPLETE_WITH_ERRORS`, but the returned file
was placeholder-free, preserved every declaration statement, and passed the
pinned local Lean kernel.  It was copied to the standalone target and promoted
to `PhysicsSM/Draft/NullEdge/ChiralSpiralCommutatorAristotle.lean` with the
project namespace and explicit convention notes.  Both `lake env lean` and
`lake build PhysicsSM.Draft.NullEdge.ChiralSpiralCommutatorAristotle` pass.
Every theorem has only the standard `propext`, `Classical.choice`, and
`Quot.sound` dependencies.
