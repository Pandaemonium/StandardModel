# Aristotle grand-strategy job: exact HNU Floquet micromotion invariant

## Objective

Determine the correct formal topological invariant for the exact depth-eight
HNU schedule. The repository proves a unique zero-quasienergy node at the
origin, a positive local Weyl Jacobian there, and an exact pi-quasienergy
boundary. Endpoint values alone are proved insufficient to assign global
signed charge. The missing object must therefore use micromotion, Berry data,
or an equivalent oriented construction.

## Literature constraints

- Higashikawa, Nakagawa, and Ueda (arXiv:1806.06868) use anomalous Floquet
  winding to realize a single Weyl cone.
- Sun et al. (arXiv:1806.09296) distinguish apparently unbalanced low-energy
  chirality from the accounting of the full Floquet unitary.
- Static Nielsen-Ninomiya reasoning must not be applied to the zero sector
  while discarding the pi sector and micromotion.

## Required deliverable

Audit the exact definitions in `HNUExactCore.lean`, `HNURealSpaceCore.lean`,
`HNUInfraredTangent.lean`, and `HNUGlobalZeroPiChargeLedger.lean`, then provide
one of:

1. a typechecking Lean scaffold for the correct finite or continuum Floquet
   invariant, including the exact theorem that would identify its value for the
   HNU schedule;
2. a smaller kernel-checkable algebraic invariant that composes the zero node
   and pi boundary and comes with a precise reconstruction theorem still to be
   proved; or
3. a no-go memo proving that the current finite endpoint/schedule data omit a
   required datum, naming the minimal additional API.

Prefer a theorem/counterexample over prose. Search Mathlib and PhysLean before
inventing a degree, winding, or Berry API. If the analytic topological-degree
layer is too large for one job, isolate the first nontrivial reusable lemma and
give an exact dependency ladder.

## Honesty gate

Do not assign a `-1` charge to the pi boundary by definition and call the sum a
theorem. Do not claim anomaly cancellation from a two-entry fixture. State
which claims are finite algebra, which require smooth topology, and which use
external Floquet results.

## Aristotle metadata

```yaml
aristotle:
  project_id: 0fec57cf-2d61-4b56-b703-a075d6587977
  submission_project: AgentTasks/aristotle-submit/codex-hnu-floquet-micromotion-strategy-20260719-project
  output_dir: AgentTasks/aristotle-output/0fec57cf-2d61-4b56-b703-a075d6587977
  status: submitted
  owner: Codex
  role: strategy-and-formalization
```

Submitted on 2026-07-19.
