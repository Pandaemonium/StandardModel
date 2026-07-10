# codex spinor-incidence color no-go, 2026-07-09 15:30

aristotle:
  project_id: 5f7d160c-3ddb-4abe-853b-3bc7198507b6
  target_file: PhysicsSM/Draft/NullEdge/SpinorIncidenceColorNoGo.lean
  expected_module: PhysicsSM.Draft.NullEdge.SpinorIncidenceColorNoGo
  submission_project: AgentTasks/aristotle-submit/codex-frontier-wave-1530-20260709-project
  output_dir: AgentTasks/aristotle-output/5f7d160c-3ddb-4abe-853b-3bc7198507b6
  status: submitted 2026-07-09 15:32 PDT

You are Aristotle. Follow the spinor/incidence route with a sharp positive
theorem and a sharp no-go: the primitive two-spinor geometry naturally carries
the Lorentz/SL(2) mass invariant, but it cannot by dimension alone host a
faithful color triplet without an additional internal factor.

Target:

```text
PhysicsSM/Draft/NullEdge/SpinorIncidenceColorNoGo.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.Core
import PhysicsSM.Draft.NullEdge.PauliMomentumPhysLean
import PhysicsSM.Draft.NullEdge.SigmaMapNullEdges
```

Context pack:

```text
AgentTasks/context-packs/spinor-incidence-color-nogo-20260709-152931.md
```

## Positive SL(2) payload

For two complex spinors define the projective wedge/mass
`wedge psi phi = psi 0*phi 1 - psi 1*phi 0`. For a complex `2x2` matrix `S`,
prove the exact functor law

```text
wedge (S*psi) (S*phi) = det(S) * wedge psi phi.
```

Deduce:

1. `det S = 1` preserves the wedge and its squared norm exactly;
2. invertible `S` preserves the massless/collinear locus;
3. give an exact nonidentity rational/complex determinant-one witness, such as
   a triangular shear or the `3-4-5` rotation, and prove it moves a spinor while
   preserving the two-edge mass.

This is the legitimate finite incidence-to-Lorentz symmetry content.

## Mandatory color no-go

Prove by finite dimension/rank-nullity:

```text
not exists f : (Fin 3 -> C) ->_C (Fin 2 -> C), Function.Injective f
```

and therefore no complex-linear equivalence between a color triplet and the
primitive two-spinor space. If useful, strengthen this to every map from a
three-dimensional color module into the primitive spinor being non-faithful
(nontrivial kernel), with an explicit rank/nullity inequality.

Bundle the positive and negative halves:

* the two-spinor incidence structure supports nontrivial determinant-one
  transformations preserving null-edge mass;
* a faithful three-component color action cannot be represented on that same
  two-dimensional carrier space without adding an internal tensor factor.

Preferred names:

```lean
spinorWedge
wedge_mulVec
sl2_preserves_wedge
invertible_preserves_collinearity
sl2_nondegenerate_witness
color_to_spinor_not_injective
no_color_spinor_linearEquiv
spinor_incidence_color_nogo
```

## Claim boundary and provenance

This is a dimension obstruction for the explicitly primitive `C^2` spinor
space. It does not prove that Standard Model color cannot emerge from a larger
decorated null-edge carrier, nor classify automorphism groups, nor derive
`SU(2) x U(1)`. It shows exactly why spacetime/null incidence alone is
insufficient for color and why an internal factor is mathematically required.
Use the local Pauli/mostly-minus conventions, consult PhysLean only as the
already-recorded clean-room reference, and add exact witnesses plus guard pins.
