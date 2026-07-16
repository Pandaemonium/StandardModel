# Aristotle task: deterministic decoration equivariance classification

## Objective

Complete all three proof holes in
`AgentTasks/aristotle-targets/afpl_deterministic_decoration_equivariance_classification.lean`
without changing any definitions or theorem statements.

The capstone should establish a genuine law-level iff: for a full-support PMF
invariant under the object equivalence, invariance of the graph-decorated joint
law under the product action is equivalent to equivariance of the mark.

## Semantic requirements

- The forward direction must use full support to recover pointwise
  equivariance; do not assume equivariance.
- Preserve the PMF law equality, not merely set-level graph invariance.
- Preserve both nontrivial directions and the constant-mark control.
- Do not claim an infinite-volume point process or Lorentz theorem.

## Likely API

- `PMF.map_comp`, `PMF.support_map`, and PMF extensionality
- `Set.range`, `Set.image`, and injectivity/surjectivity of `Equiv`
- `decorationGraph_invariant_iff_equivariant` as the support-level bridge

## Success criteria

- Target builds under the pinned Lean toolchain.
- No proof holes or trust-expanding declarations remain.
- Statements and definitions are byte-for-byte unchanged.
- Report whether full support is used only in the converse, as intended.

## Aristotle metadata

- Work item: `L0-DIST-001`
- Hat: Builder/Assassin
- Priority: P0
- Requested trust: kernel-checked standard-three footprint only
- Aristotle project: `aa1888ab-da73-4c45-9c82-bafcee4907ed`
