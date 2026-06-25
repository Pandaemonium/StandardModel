# Aristotle task: P2 chiral projector coherence bridge

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` bridge.

The existing finite theorem spine already proves:

- the static chiral Dirac slash squares to the Minkowski/Plucker scalar;
- an abstract off-diagonal mass block squares to `m^2`;
- observer-normalized determinant readouts give the scalar `m/E`.

The missing small bridge is a two-level operator statement: for a fixed-helicity
left/right Hamiltonian

```text
H_h(p,m) = [[-h p, m], [m, h p]],
```

the off-diagonal mass entry is a first-order chirality-coupling, `H^2` is the
mass-shell scalar, and the positive branch `(1/2)(I + H/E)` has left/right
coherence `m/(2E)`.  Squared coherence is therefore `m^2/(4E^2)`, exactly the
observer-channel mass-ratio scalar used in the P1/P7 story.

This is finite matrix algebra only. It is not a continuum Dirac limit.

## Aristotle instructions

Please work on:

```text
NullEdgeP2ChiralProjectorCoherence/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2ChiralProjectorCoherence/Core.lean
```

Primary targets:

```lean
chiralHamiltonian_sq_eq_massShell
positiveBranch_leftRight_eq_mass_over_two_energy
positiveBranch_leftRight_sq_eq_massRatioSq
```

Guardrails:

- Keep the definitions finite and `2 x 2`; do not introduce continuum
  assumptions.
- Do not weaken the theorem statements unless a statement is false. If a
  nonzero-energy hypothesis is mathematically required, add it explicitly and
  explain why.
- Do not change the signs of `H_h(p,m)` without reporting the convention issue.
- Prefer simple `Fin 2` case analysis, matrix entry simplification, and `ring`
  style proofs.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- what finite P2/P4/P7 theorem should come next to connect this shard to the
  null-step quantum-walk or super-Dirac story.

## Metadata

```yaml
aristotle:
  project_id: 3db296bf-c1ab-4c4b-9347-ee9c65d711e1
  task_id: bdf7039d-7acd-4ee4-a8ac-28ab913d8ad7
  target_file: NullEdgeP2ChiralProjectorCoherence/Core.lean
  expected_module: NullEdgeP2ChiralProjectorCoherence.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-chiral-projector-coherence-20260624-project
  output_dir: AgentTasks/aristotle-output/3db296bf-c1ab-4c4b-9347-ee9c65d711e1
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP2ChiralProjectorCoherence
```

Aristotle preserved all theorem statements and the sign convention
`H_h(p,m) = [[-h p, m], [m, h p]]`. It solved all three targets with no new
assumptions beyond `h * h = 1` in the mass-shell square theorem. The returned
completion report recommended the next finite step: prove that under
`E^2 = p^2 + m^2` and nonzero energy, `positiveBranch` is a genuine projector
with trace `1`.

Verification run after integration:

```text
lake env lean AgentTasks/aristotle-output/3db296bf-c1ab-4c4b-9347-ee9c65d711e1/extracted/project-files.tar/null-edge-p2-chiral-projector-coherence-20260624-project_aristotle/NullEdgeP2ChiralProjectorCoherence/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-chiral-projector-coherence-20260624/NullEdgeP2ChiralProjectorCoherence/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP2ChiralProjectorCoherence.lean
lake build PhysicsSM.Draft.NullEdgeP2ChiralProjectorCoherence
lake env lean PhysicsSMDraft.lean
```
