# Aristotle task: equal-magnitude phase-profile interferometer

## Objective

Complete all four proof holes in
`AgentTasks/aristotle-targets/afpl_equal_magnitude_phase_interferometer.lean`
without changing any definitions or theorem statements.

The target must prove that the trivial square edge field and the landed
`squareEdgeField` have equal local complex norm squared on every edge, while
their gauge-invariant two-path interference scores are exactly `4` and `2`.

## Semantic requirements

- Use the existing closed-loop gauge-invariance theorem; do not assume score
  invariance.
- Preserve exact values `4` and `2`.
- Preserve the universal local-magnitude equality.
- Do not claim that the supplied edge fields have already been derived from a
  Pluecker field or pair-transfer experiment.

## Useful landed inputs

- `U1HistoryClosureHolonomy.closed_pathHolonomy_gauge_invariant`
- `U1HistoryClosureHolonomy.square_loop_closes`
- `U1HistoryClosureHolonomy.square_nontrivial_gauge_invariant_witness`
- `Complex.normSq`

## Success criteria

- Target builds under the pinned Lean toolchain.
- No proof holes or trust-expanding declarations remain.
- Every statement and definition is unchanged.
- Report the narrowest physical reading: finite equal-magnitude `U(1)` loop
  phases can be operationally distinguished by interference.

## Aristotle metadata

- Work item: `DYN-MODULAR-001`
- Hat: Builder/Assassin
- Priority: P1
- Requested trust: kernel-checked standard-three footprint only
- Aristotle project: `e2cc5463-a4f5-4f23-9a4a-a16592cffc22`
