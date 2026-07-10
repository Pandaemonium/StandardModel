# Aristotle strategy task: generic finite CAR/Fock lift

Design the smallest semantically correct Lean architecture that lifts the
finite one-particle unitary `VariablePlueckerLocalWalk.variableComplexLocalStep`
to a finite fermionic Fock-space automorphism.

Required theorem targets:

- creation and annihilation operators satisfying the CAR;
- a second-quantization map for an arbitrary finite one-particle unitary;
- preservation of CAR, parity, and particle number;
- exact agreement with the supplied unitary on the one-particle sector;
- a locality-radius theorem inherited from the one-particle causal cone;
- one explicit local quartic interaction and a Pluecker-dependent two-particle
  observable, or a precise no-go identifying the missing structure.

Consult Mathlib exterior/Clifford APIs, PhysLean, lean-quantum, and the trusted
`PhysicsSM/Spinor/SpinorTenfoldCAR.lean` only as clean-room references. Return
exact Lean-ready declarations, imports, proof decomposition, nonzero witness,
and CAR/locality kill controls. Prefer a generic finite theorem that can be
instantiated with `Position L × Fin 4`; do not solve only a two-mode toy unless
it is explicitly a first rung with a generic successor statement.

```yaml
aristotle:
  project_id: 4d62041f-b9c0-4530-975e-2fa440d9bc5b
  task_id: 0657d2e5-ea0a-46c3-ad26-832cf22a1a0a
  target_file: FiniteCARLift/Main.lean
  expected_module: FiniteCARLift.Main
  submission_project: AgentTasks/aristotle-submit/finite-car-lift-strategy-20260710-project
  output_dir: AgentTasks/aristotle-output/4d62041f-b9c0-4530-975e-2fa440d9bc5b
  status: completed-and-harvested
  report: AgentTasks/aristotle-output/4d62041f-b9c0-4530-975e-2fa440d9bc5b/extracted/finite-car-lift-strategy-20260710-project_aristotle/AgentTasks/finite-car-lift-strategy-design-2026-07-10.md
```
