# Aristotle strategy-to-proof job: noncommuting Gibbs variational uniqueness

- Work item: `DYN-MODULAR-001`
- Role: Builder / Oracle / Assassin
- Priority: P96 thermodynamics and information theory
- Date: 2026-07-13

```yaml
aristotle:
  project_id: 799b9218-1fb2-43f6-a925-a5f34238c96b
  submission_project: AgentTasks/aristotle-submit/afpl-quantum-gibbs-variational-uniqueness-20260713-project
  output_dir: AgentTasks/aristotle-output/799b9218-1fb2-43f6-a925-a5f34238c96b
  status: submitted
```

## Mission

Compose the general finite-dimensional quantum Klein inequality and its newly
landed equality characterization into an honest noncommuting Gibbs variational
principle. The result should show both free-energy minimality and uniqueness of
the reference state, under explicit finite-dimensional hypotheses.

## Required inputs

- `PhysicsSM/Draft/NullEdge/GeneralQuantumKlein.lean`
- `PhysicsSM/Draft/NullEdge/GeneralQuantumKleinEquality.lean`
- `PhysicsSM/Draft/NullEdge/GibbsVariational.lean`
- `PhysicsSM/Draft/NullEdge/QuantumKleinShared.lean`
- `PhysicsSM/Draft/NullEdge/MassThermodynamics.lean`

## Preferred theorem shape

Let `sigma` be a positive-definite trace-one Hermitian reference state and let
`K = -logHermitian sigma`. For every Hermitian positive-semidefinite trace-one
state `rho`, define the dimensionless free-energy difference by

`Tr(rho * K).re - S(rho) - (Tr(sigma * K).re - S(sigma))`.

Prove that this difference equals `qRelEntropy rho sigma`, is nonnegative, and
vanishes if and only if `rho = sigma`. If a cleaner repository definition is
available, use it while retaining the same semantics. Add a strict-positive
corollary for `rho != sigma` and an explicit nonidentity finite witness.

## Target ladder

1. Exact algebraic free-energy/relative-entropy identity.
2. Nonnegativity from `GeneralQuantumKlein.qKlein_nonneg`.
3. Equality iff and strict uniqueness from
   `GeneralQuantumKleinEquality.qKlein_eq_zero_iff`.
4. Optional beta/Hamiltonian corollary only under an explicit displayed
   `log sigma = -beta H - log Z` hypothesis.

## Semantic constraints

- Do not assume commuting states or a shared eigenbasis.
- Preserve positive definiteness of the reference state and PSD/trace-one
  hypotheses for competitors.
- Do not call `sigma` a dynamically derived thermal state unless a Hamiltonian,
  beta, partition function, and logarithm identity are supplied explicitly.
- Do not claim infinite-volume KMS theory, arbitrary CPTP monotonicity, gravity,
  or a physical temperature selection mechanism.
- Use no trust-expanding declarations or evaluator shortcuts.

## Required output

Return a concise strategy memo plus a typechecking Lean module. Prove as much of
the ladder as possible; if an API blocker remains, isolate it as one exact
missing lemma without weakening the intended statement.
