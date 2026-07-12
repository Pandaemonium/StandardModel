# Paper F stabilizer/selector successor

Date: 2026-07-12  
Owner: Codex  
Status: integrated kernel theorem; scope audit complete

## Decision

The smallest material successor to the Paper F capstone is an explicit orbit
theorem for a residual symmetry already visible in the exact six-coordinate
normal form. The Gram pairing is

```text
a*a' + d*d' + e*e' + g*g' - 2*b*b' - 2*f*f'.
```

Thus the rational involution `(b,f) |-> (f,b)` is an exact isometry. The named
channels `apertureC`, `closureC`, and `turnC` all have `b=f=0`, so the involution
fixes them pointwise. On the classified positive-complement disk it acts by

```text
(u,v) |-> (v,u).
```

This identifies a concrete residual orbit without assuming a physical selector
or inventing a full carrier-automorphism group.

## Lean target

Target file:
`AgentTasks/aristotle-targets/codex_24h_f_stabilizer_selector_successor.lean`

Expected namespace:
`PhysicsSM.Draft.NullEdge.ChannelStabilizerSelectorSuccessor`

The target defines `swapNegativeNormal`, the disk reflection `swapDisk`, and
its exact order-two orbit relation `SameSwapOrbit`, then asks for:

1. the exact coordinate-swap formula;
2. involutivity on the even Krein-self-adjoint normal-form sector;
3. preservation of the full bilinear Gram pairing;
4. pointwise stabilization of all three named channels;
5. the disk action `diskVector u v |-> diskVector v u`; and
6. an invariant-selector obstruction with explicit rational witnesses.

The sixth theorem uses

```text
X = diskVector (3/5) 0
Y = diskVector 0 (3/5).
```

Both witnesses have exact positive norm `32/25`. They lie in distinct tilted
positive sectors, each is excluded from the other's sector, and `Y` is the
swap of `X`. Hence any `N -> A` selector invariant under this one involution on
the even self-adjoint sector must satisfy `selector X = selector Y`.

## Why this narrows canonicity

The capstone proves that distinct disk points give distinct positive sectors,
but it does not compute an automorphism orbit on that disk. This successor
adds the first nontrivial orbit control: at least the reflection-related points
`(u,v)` and `(v,u)` cannot be separated by a selector that treats the two
equally weighted negative normal-form directions symmetrically.

Therefore a successful selector must do one of two explicit things:

- descend to the quotient by this reflection, accepting the two points as
  equivalent; or
- use additional structure that breaks the reflection and justify why that
  structure is intrinsic.

The witness pair is nondegenerate: neither point is the disk center, the two
represented matrices are unequal, both norms are strictly positive, and the
two sectors are separated in both directions.

## Honest scope

This is a coordinate quadratic-space stabilizer theorem. `SameSwapOrbit` is
defined on rational disk coordinates, where the swap is genuinely an
involution; the represented witness equation is stated separately. The target
does not prove that `swapNegativeNormal` preserves matrix multiplication, the
full carrier operator, source-word presentation, locality, edge data, gauge
data, a constraint complex, or dynamics. It therefore does not make
`SameSwapOrbit` a physical equivalence relation.

The result also does not classify the full rational stabilizer or its complete
orbit decomposition. In particular, no transitivity claim on circles or on the
open disk is made. The theorem only supplies one explicit order-two subgroup
and one explicit nontrivial orbit.

Claim status: `M [orig/comp]`. Aristotle filled all six proof bodies without
changing any statement; the live targeted build passed.

## Aristotle handoff

Fill all six proof holes without changing statements or adding assumptions.
The intended route is coordinate-level:

- reduce the swap formula by `simp` on `normalForm` entries;
- obtain involutivity by the exact normal-form existence theorem;
- use `normalForm_gram_bilinear` for bilinear isometry;
- rewrite the named-channel normal forms already proved in
  `ChannelPositiveComplementDisk`;
- reduce the disk action to the swap formula; and
- use `tiltedSectors_distinct`, `diskVector_mem_tiltedSector`, and
  `normalForm_gram` for the capstone witness.

Do not upgrade the result to a carrier-algebra automorphism, gauge symmetry, or
physical selector theorem. A blocked proof should preserve the theorem shapes
and report the exact missing lemma.

```yaml
aristotle:
  project_id: fe5f57dd-2d4e-4047-b881-4aae2c6cac05
  task_id: 00609114-7fff-48ed-98e9-a8f8275f24dd
  target_file: AgentTasks/aristotle-targets/codex_24h_f_stabilizer_selector_successor.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChannelStabilizerSelectorSuccessor
  submission_project: AgentTasks/aristotle-submit/codex-24h-f-stabilizer-selector-20260712-project
  output_dir: PhysicsSM/Draft/NullEdge/ChannelStabilizerSelectorSuccessor.lean
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Provenance

- `PhysicsSM/Draft/NullEdge/ChannelDecompositionModuliCapstone.lean`
- `PhysicsSM/Draft/NullEdge/ChannelPositiveComplementDisk.lean`
- `PhysicsSM/Draft/NullEdge/ChannelKreinSectorSignature.lean`
- `Sources/Null_Edge_Channel_Decomposition_Classification_Draft_2026-07-12.md`

No external code or literature statement is used. The theorem is a direct
successor analysis of the repository's exact rational carrier model.
