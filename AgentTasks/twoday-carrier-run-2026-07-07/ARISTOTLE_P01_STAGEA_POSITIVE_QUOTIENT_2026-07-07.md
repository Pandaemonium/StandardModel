# Aristotle task - P01 Stage-A positive quotient interface

## Job

- Requested job name:
  `ne-hard-p01-stagea-adaptedbasis-positivequot-proof-20260707`
- Lane: Q01 / KPON / carrier physical-sector theorem
- Type: proof/strategy

```yaml
aristotle:
  project_id: 72b75f0d-99fb-4801-aa8f-86627690298c
  task_id: 44fb2b46-78d1-40ab-950a-5701dfae9516
  target_file: PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean
  expected_module: PhysicsSM.Draft.NullEdge.Carrier.KreinPositiveSectorWitness
  submission_project: AgentTasks/aristotle-submit/ne-hard-p01-stagea-adaptedbasis-positivequot-proof-20260707-project
  output_dir: AgentTasks/aristotle-output/72b75f0d-99fb-4801-aa8f-86627690298c
  status: submitted
```

## Context

The finite `(2,1)` positive-sector witness and the quotient Ward action are
landed and guard-pinned:

- `PhysicsSM/Draft/NullEdge/Carrier/KugoOjima.lean`,
- `PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean`,
- `PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean`,
- `PhysicsSM/Draft/NullEdge/Carrier/CarrierIndexProtection.lean`.

Fable's handoff proposes a staged route from finite Kugo-Ojima algebra to the
carrier physical-sector theorem.  Pro's correction strengthens Stage A: the
abstract quotient theorem must explicitly assume a nondegenerate form of
inertia `(p,q)`, `q <= p`, a `q`-dimensional isotropic subspace `Gamma'`,
`V' = Gamma' orthogonal complement`, and `N` the radical of the restricted
form on `V'`.

## Target

Prove, or isolate the exact missing Mathlib/project API for, a reusable finite
Stage-A theorem:

```text
If V has a nondegenerate Hermitian/Krein form of inertia (p,q), q <= p,
and Gamma' is q-dimensional isotropic with an adapted basis witness, then
for V' = Gamma'^perp and N = radical(form restricted to V'):
  N = Gamma',
  the quotient form on V'/N is positive definite,
  dim(V'/N) = p - q.
```

Do not build general Witt/Krein infrastructure.  Use an adapted-basis
interface hypothesis, as Fable recommends.  If an operator descent theorem is
included, require both self-adjointness of `D` and `D Gamma' <= Gamma'`; then
derive `D(V') <= V'` by adjointness.

## Desired output

- Prefer a Lean patch extending `KreinPositiveSectorWitness.lean` or adding a
  small adjacent carrier draft module.
- Reproduce the landed `(2,1)` positive-sector witness as a corollary if
  feasible; if not, explain precisely which hypothesis shape prevents it.
- Include the failure/no-go result if the adapted-basis interface is too weak.
- Preserve claim boundary: finite model algebra only, not the full carrier
  Gauss/closure completeness theorem.

## Required patch layer

Use:

- `AgentTasks/twoday-carrier-run-2026-07-07/FABLE_HANDOFF_HARDEST_PIECES.md`,
- `AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_HARDEST_PIECES_PRO_PATCHES_2026-07-07.md`.
