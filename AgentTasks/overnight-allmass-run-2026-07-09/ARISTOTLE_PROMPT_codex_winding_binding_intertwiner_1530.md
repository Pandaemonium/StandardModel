# codex winding-to-binding intertwiner, 2026-07-09 15:30

aristotle:
  project_id: 2a093e44-ee88-49e1-9d13-b34521cb3e87
  target_file: PhysicsSM/Draft/NullEdge/WindingBindingIntertwiner.lean
  expected_module: PhysicsSM.Draft.NullEdge.WindingBindingIntertwiner
  submission_project: AgentTasks/aristotle-submit/codex-frontier-wave-1530-20260709-project
  output_dir: AgentTasks/aristotle-output/2a093e44-ee88-49e1-9d13-b34521cb3e87
  status: submitted 2026-07-09 15:32 PDT

You are Aristotle. Strengthen the landed structured-holonomy packet by building
an actual explicit finite intertwiner between its protected winding kernel and
its exact bound eigenspace. This is the missing theorem the previous capstone
carefully did not claim.

Target:

```text
PhysicsSM/Draft/NullEdge/WindingBindingIntertwiner.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.StructuredHolonomyBindingCapstone
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.Carrier.CarrierClosurePlane
```

Context pack:

```text
AgentTasks/context-packs/winding-binding-intertwiner-20260709-152910.md
```

## Exact witness data

Use `N=3`, `w=1`, `dW=![0,1,1]`, and `kW=2` from
`StructuredHolonomyBindingCapstone`.

The winding operator

```text
Kw 3 1 : (Fin 4 -> C) ->_C (Fin 3 -> C)
```

is coordinate truncation, so its kernel is the last coordinate. Define the
explicit protected vector `z = Pi.single 3 1`; prove `Kw 3 1 z = 0`, `z != 0`,
and preferably that every kernel vector is a scalar multiple of `z`.

The real interacting Hamiltonian at the witness has bound eigenvalue `-1` and
real eigenvector proportional to `![1,1,0]`. The actual carrier Hamiltonian is
the phase-gauged complex matrix `carrierH2 dW kW`; use the landed
`H2der_conj` convention `U=diag(1,-i,1)` to define an explicit complex bound
vector proportional to `![1,-i,0]`. Prove directly:

```text
carrierH2 dW kW * boundVec = (-1) * boundVec
boundVec != 0.
```

## Intertwiner target

Define a linear map from the winding kernel to the carrier two-body space by
reading the protected last coordinate and multiplying `boundVec`:

```text
T x = x.1 3 * boundVec
```

with the exact subtype/coercion syntax required by Lean. Prove:

1. `T` is nonzero and injective.
2. Its image is exactly the `-1` eigenspace of `carrierH2 dW kW`, if the finite
   eigenspace calculation is tractable; at minimum prove image containment and
   that the target eigenspace is one-dimensional.
3. The operator intertwining equation on the protected sector:

```text
carrierH2 dW kW * T(x) = (-1) * T(x).
```

4. A linear equivalence between `ker(Kw 3 1)` and the `-1` eigenspace, if clean.
5. Preserve the exact index-one and below-threshold facts in a final theorem.

Preferred names:

```lean
protectedBasis
protectedBasis_mem_ker
windingKernel_eq_span
carrierBoundVec
carrierBoundVec_eigen
windingToBound
windingToBound_injective
windingToBound_intertwines
windingToBound_range_eq_eigenspace
windingKernel_equiv_boundEigenspace
winding_binding_intertwiner_verdict
```

## Claim boundary

This would be a genuine intertwiner for one explicit finite witness. It would
not prove that arbitrary winding causes binding, QCD confinement, a continuum
index-to-hadron theorem, or uniqueness of this intertwiner. If the eigenspace
has unexpected dimension or the proposed phase-gauged vector is wrong, report
the exact counterexample instead of weakening the statement invisibly. Add
nondegeneracy witnesses and in-file guard pins.
