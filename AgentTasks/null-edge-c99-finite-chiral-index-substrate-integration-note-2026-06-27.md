# C99 integration note: finite chiral-index substrate fallback

Date: 2026-06-27.

Aristotle project: `4fd2e530-eb89-4e94-83c1-dc97b254e0c4`.

Integrated file:

```text
PhysicsSM/Draft/NullEdgeFiniteChiralIndexSubstrate.lean
```

## Status

Integrated as:

```text
draft / planning fallback substrate
```

Do not cite this module as:

- Gate C1 release;
- overlap/Ginsparg-Wilson release;
- domain-wall release;
- ghost-zero safety;
- regulator-removal stability;
- physical anti-vectorialization.

## What C99 gives

C99 improves over C98's arbitrary-count `InterfaceToy` by defining:

- `FiniteChiralData` with finite dimension `n`, basis grading
  `chirality : Fin n -> Bool`, and finite operator
  `D : Matrix (Fin n) (Fin n) Rat`;
- `IsKernelState` as the column-zero predicate for `D`;
- plus/minus kernel-state sets derived from `(D, chirality)`;
- `ChiralIndex` computed from those derived finite sets;
- explicit zero-index and nonzero-index examples;
- a C98-style non-implication showing interface shape does not force nonzero
  index.

## Known limitations

Record these in every downstream use:

- no explicit grading involution `Gamma`;
- no `D` / `Gamma` compatibility law;
- plus/minus sectors are basis labels, not eigenspaces;
- kernel is coordinate-basis only, not `LinearMap.ker`;
- the nonzero example is hand-set by choosing `D = diag(0, 1)` and the plus
  label on the zero column;
- headline index examples use `n a t i v e _ d e c i d e`, so the axiom footprint includes
  `Lean.ofReduceBool` / `Lean.trustCompiler`.

## Review

Claude review:

```text
AgentTasks/model-calls/claude/2026-06-27-113127-c99-return-review.md
```

Verdict:

```text
Integrate as fallback / planning infrastructure, then queue C99-v2.
```

## Follow-up

C99-v2 should require:

- `Gamma : Matrix (Fin n) (Fin n) Rat` or equivalent;
- `Gamma * Gamma = 1`;
- sectors as `Gamma` eigenspaces or a proof that chirality fibers match those
  eigenspaces;
- strict anticommutation `Gamma * D + D * Gamma = 0` or finite
  Ginsparg-Wilson-style relation `Gamma * D + D * Gamma = D * Gamma * D`;
- kernel via `LinearMap.ker` intersected with sectors, or a proof that the
  column-zero predicate equals the true kernel for chosen examples;
- nonzero-index witness whose asymmetry is forced by structure, not merely
  hand-set by label choice;
- no trusted index-value proof via `n a t i v e _ d e c i d e`.
