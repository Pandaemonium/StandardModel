# Aristotle C99: finite operator-theoretic substrate for the chiral index guardrail

Dependency class: Independent.

Does not depend on:

- C89 regulator/removal handle.
- C92 ghost-safety API.
- C93 overlap/Ginsparg-Wilson interface.
- C94 domain-wall interface.
- C97 Wilson-release Boolean `GaugeData` API.

Hard dependencies:

- None. This should be a finite algebra / finite-dimensional linear substrate
  job using Mathlib and, if helpful, a self-contained Lean file.

Decision changed if this returns:

- If successful, C98's forgeable `InterfaceToy` guardrail can be replaced in
  future C1 planning by a finite operator-theoretic index substrate.
- If impossible or awkward in Lean, keep C98 as planning-only and ask a smaller
  C99a job for a hand-coded finite branch-table substrate instead.

## Background

The null-edge Gate C program is separating:

- Gate C0: external species health / regulator legality.
- Gate C1: physical chiral release.

Recent C98 produced a useful but toy guardrail:

```lean
structure InterfaceToy where
  hasInterfaceShape : Bool
  plusCount : Nat
  minusCount : Nat

def InterfaceShape (T : InterfaceToy) : Prop := T.hasInterfaceShape = true
def ChiralIndexWitness (T : InterfaceToy) : Prop := T.plusCount ≠ T.minusCount
def ZeroIndex (T : InterfaceToy) : Prop := T.plusCount = T.minusCount
```

It proves that interface shape alone does not imply a nonzero chiral/index
witness. That is valuable, but forgeable: `hasInterfaceShape` is a Boolean tag
and `plusCount`/`minusCount` are unconstrained numbers, not kernels of an
operator.

Claude's review recommends replacing that toy with a finite operator-theoretic
substrate, independent of the still-running Gate C jobs.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeFiniteChiralIndexSubstrate.lean
```

The module should define a finite, operator-theoretic chiral index substrate and
prove C98-like guardrails there.

## Desired API shape

Use the smallest Lean-friendly representation that supports concrete
kernel-checked examples. Options are acceptable:

1. A finite branch-table model where plus/minus kernel states are actual finite
   sets selected by predicates, not arbitrary counts.
2. A finite-dimensional linear-algebra model over `Fin n -> ℂ` with an explicit
   grading and operator.
3. A hybrid explicit matrix model if Mathlib kernel/rank APIs are too heavy.

Prefer the smallest version that is mathematically honest and compiles.

Ideal structure if feasible:

```lean
structure FiniteChiralData where
  -- finite state space or finite-dimensional vector space
  -- grading / chirality splitting
  -- finite operator D
  -- structural interface predicate, not a Boolean tag when feasible
```

Define:

```lean
ChiralIndex data : Int
ChiralIndexNonzero data : Prop
ZeroChiralIndex data : Prop
```

If using vector spaces, the intended index is:

```text
dim ker(D restricted to plus sector) - dim ker(D restricted to minus sector)
```

If using a finite branch-table fallback, the intended index is:

```text
number of actual plus kernel states - number of actual minus kernel states
```

The important upgrade over C98 is that the counts must be derived from the
finite substrate, not arbitrary fields supplied by the user.

## Required theorems

Prove analogues of the C98 guardrails:

```lean
zero_index_blocks_chiral_index_nonzero :
  ZeroChiralIndex data -> not (ChiralIndexNonzero data)
```

Concrete zero-index countermodel:

```lean
exists_interface_zero_index :
  exists data, InterfaceShape data and ZeroChiralIndex data
```

Concrete nonzero-index witness:

```lean
exists_interface_nonzero_index :
  exists data, InterfaceShape data and ChiralIndexNonzero data
```

Non-implication:

```lean
interface_shape_does_not_imply_chiral_index_nonzero :
  not (forall data, InterfaceShape data -> ChiralIndexNonzero data)
```

If `InterfaceShape` cannot be made nontrivial without importing C93, make it a
structural predicate such as "operator respects the grading convention" or
"operator has the declared finite chiral substrate shape"; do not use a bare
Boolean tag if avoidable. If a Boolean tag is unavoidable, document why this
module is only an intermediate hardening over C98, not a true C1 substrate.

## Explicit non-goals

Do not claim:

- C1 release.
- ghost-zero safety.
- regulator-removal stability.
- overlap/Ginsparg-Wilson release.
- domain-wall release.
- any relation to the actual null-edge operator.

Do not import or depend on C97's `GaugeData` Boolean Wilson-release scaffold.

This is a finite substrate for the index half of C1 only. It should be useful
for later jobs to instantiate with the actual C93/C94 operator interfaces.

## Acceptance criteria

- Lean file compiles.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- The module docstring states that this is draft/planning infrastructure, not a
  C1 release theorem.
- Counts or index values are computed from finite substrate data rather than
  arbitrary user-supplied plus/minus count fields.
- The non-implication theorem is backed by an explicit zero-index countermodel.
- The non-vacuity theorem is backed by an explicit nonzero-index example.

## Review warning

The main semantic trap is laundering a toy predicate into C1 release language.
The file should make that hard by naming and docstrings. Prefer names like
`FiniteChiralIndexNonzero` over generic `ChiralIndexWitness` if the latter would
be confused with the eventual full C1 witness.
