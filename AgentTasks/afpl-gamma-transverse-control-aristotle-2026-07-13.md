# Aristotle task: gamma-coupled transverse gap and chirality control

```yaml
aristotle:
  project_id: 87e8d4f4-0f1b-452e-bd9a-54b1f103f86e
  task_id: 44b31d80-248d-4999-a5c4-bcac86efb384
  target_file: GammaTransverseControl/Core.lean
  expected_module: GammaTransverseControl.Core
  submission_project: AgentTasks/aristotle-submit/afpl-gamma-transverse-control-20260713-project
  output_dir: AgentTasks/aristotle-output/87e8d4f4-0f1b-452e-bd9a-54b1f103f86e
  status: integrated
```

## Objective

Prove the exact anticommuting Clifford lift in
`GammaTransverseControl/Core.lean`.  This is the control missing from the
separable finite transverse lift: gamma anticommutation should remove cross
terms, give an exact square, and support a genuine full complement-gap theorem.

Then audit the kernel sector.  The displayed four-component tangent is expected
to contain paired opposite Weyl chiralities.  Prove that pairing explicitly by
an exact change of basis, invariant decomposition, determinant-sign witnesses,
or another finite algebraic certificate.  Do not call it a single Weyl mode.

## Required ladder

1. Prove the transverse kernel witness.
2. Prove the four gamma-square and pairwise anticommutation identities.
3. Prove `H_sq` exactly.
4. Derive a nonvacuous uniform lower-bound identity on the transverse
   complement, using the already visible `M^2 = 5 I - w w^T` structure if
   useful.  Distinguish a quadratic identity from a spectral theorem.
5. Prove `kernel_restriction`.
6. Classify the kernel tangent as paired Weyl sectors with opposite local
   determinant signs, or return the strongest exact obstruction if that
   formulation needs a changed basis.
7. Add standard-axiom guards and eliminate all proof placeholders.

## Honesty boundary

This is a finite gamma-coupled Hamiltonian control.  It is not discrete time,
not a primitive-null walk, not a periodic Brillouin-zone construction, and not
an anomaly-inflow theorem.  Its purpose is to show precisely what gamma
coupling fixes and why it still does not isolate one chirality.

Run first:

```text
lake env lean GammaTransverseControl/Core.lean
```

## 2026-07-13 harvest and integration

Aristotle completed the full ladder. Interactive Claude/Opus independently
replayed and approved it, confirming that the anticommuting gamma coupling is
the genuine domain-wall-style square missing from the earlier separable
control. The live module is
`PhysicsSM/Draft/NullEdge/GammaTransverseControl.lean`.

The integration reuses `FiniteTransverseWeylLift.Mc` and `.wc`, adds
build-enforced standard-three guards, and preserves the decisive boundary:
the transverse complement has an exact positive quadratic gap, while the
kernel tangent splits into opposite-chirality Weyl sectors with net chirality
zero. Direct replay passes. This is an anomaly-balanced finite Hamiltonian
control, not a single-Weyl or primitive-null construction.
