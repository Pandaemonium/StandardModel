# Aristotle C99-v2: finite grading-involution chiral-index substrate

Dependency class: Independent.

Does not depend on:

- C93 overlap/Ginsparg-Wilson interface.
- C92 ghost-safety API.
- C89 regulator/removal handle.
- C97 Boolean Wilson-release scaffold.

Soft dependency:

- C99 return is integrated as fallback substrate. C99-v2 should improve it, not
  treat it as release evidence.

Hard dependencies:

- None.

Decision changed if this returns:

- If successful, it becomes the stronger finite index-substrate layer.
- If unsuccessful, C99 remains fallback and C99b may serve as benchmark.

## Background

C99 `NullEdgeFiniteChiralIndexSubstrate.lean` improved over C98 by computing
plus/minus counts from finite substrate data rather than arbitrary count fields.

But C99 is still only fallback/planning infrastructure because:

- there is no explicit grading involution `Gamma`;
- there is no compatibility relation between `D` and `Gamma`;
- plus/minus sectors are basis labels, not eigenspaces;
- kernel is coordinate-basis column-zero only, not `LinearMap.ker`;
- the nonzero example is hand-set;
- headline examples use `native_decide`.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeFiniteGradingInvolutionIndex.lean
```

The module should define a finite substrate with an explicit grading operator or
involution and a finite operator compatible with it.

## Desired API

Use the simplest Lean-friendly finite model. A rational matrix model over
`Fin n` is preferred if feasible.

Suggested shape:

```lean
structure FiniteGradingInvolutionData where
  n : Nat
  Gamma : Matrix (Fin n) (Fin n) Rat
  D : Matrix (Fin n) (Fin n) Rat
  gamma_sq : Gamma * Gamma = 1
  compatible :
    Gamma * D + D * Gamma = 0
    -- or a clearly named finite GW relation
```

If full matrix/eigenspace linear algebra is too heavy, use a smaller
Lean-friendly representation, but keep these semantic requirements:

- `Gamma` is explicit and distinct from `D`;
- `Gamma^2 = 1` is a theorem/field;
- plus/minus sectors are derived from `Gamma` or proven equivalent to its
  eigenspaces;
- `D` is compatible with `Gamma` by anticommutation or a named GW-style
  deformation.

## Kernel / index target

Preferred:

```text
index(D, Gamma) =
  dim (ker D intersect Gamma=+1 eigenspace)
  -
  dim (ker D intersect Gamma=-1 eigenspace)
```

If full `LinearMap.ker` is too heavy, use a basis-level kernel only with an
explicit theorem for the examples proving the basis-level kernel equals the
true linear kernel for those examples.

## Required examples and theorems

Provide one common substrate datatype/framework and explicit examples:

1. zero-index example with interface/substrate shape and index zero;
2. nonzero-index example with index nonzero, where the asymmetry is forced by
   the operator/grading structure rather than merely by hand-setting labels.

Theorems:

```lean
zero_index_blocks_nonzero_index
exists_shape_zero_index
exists_shape_nonzero_index
shape_does_not_imply_nonzero_index
```

Names may vary, but meanings should be present.

## Explicit non-goals

Do not claim:

- Gate C1 release;
- ghost-zero safety;
- regulator-removal stability;
- overlap/Ginsparg-Wilson release;
- domain-wall release;
- anomaly cancellation;
- physical anti-vectorialization;
- continuum Atiyah-Singer index theorem.

Do not import C97's `GaugeData` scaffold as evidence.

## Acceptance criteria

- Lean file compiles.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- No `n a t i v e _ d e c i d e` for trusted index-value examples.
- Module docstring says this is finite draft/planning substrate, not C1 release.
- `Gamma` is explicit and distinct from `D`.
- `Gamma^2 = 1` appears as data or theorem.
- A `D` / `Gamma` compatibility law appears as data or theorem.
- Index is computed from finite substrate data.
- Zero-index and nonzero-index examples share one common substrate framework.
- The grading is not spacetime `Gamma_s`, Furey `chi_E`, or cochain degree.
