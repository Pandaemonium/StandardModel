# Aristotle strategy/proof task: doubler-free local regulator

## Objective

Use `NullEdgeDoublerFree/NearestNeighborSymbol.lean` as the exact search space.
Determine whether there are explicit `4 x 4` complex matrices `A B C` such
that the degree-one Laurent symbol

`F(q) = exp(i q) A + B + exp(-i q) C`

is unitary for every real `q`, has `F(0)=I` and derivative `-i alpha`, has a
nonzero stationary amplitude `B`, and separates `q=pi` from both scalar phases
`+I` and `-I`.

Return one of the following, in priority order:

1. An explicit kernel-checked rational/algebraic witness satisfying all four
   predicates.
2. A kernel-checked no-go theorem showing that the four requirements are
   incompatible.
3. The smallest mathematically meaningful relaxation or extra internal degree
   of freedom, together with a kernel-checked witness or no-go.

Do not return a classical excluded-middle disjunction, a zero/stationary-free
witness, a theorem true only at finitely sampled momenta, or an asymptotic
unitarity statement.  Exact all-momentum unitarity is the point.  If a witness
exists, also explain how three such factors could avoid the even-parity
`(pi,pi,0)` aliases of the current ordered `3+1` product while keeping the
Pluecker mass coin as a separate onsite factor.

## Context

- Context pack:
  `AgentTasks/context-packs/null-edge-doubler-free-regulator-20260710-105027.md`
- The current cubic walk has the exact corner law
  `U(qx,qy,qz,0)=(-1)^r I` on `{0,pi}^3`, hence three nonzero origin aliases.
- Gupta and Short, arXiv:2601.15885, motivate allowing stationary local
  amplitudes.  Translate mathematics cleanly; do not copy implementation text.
- Lean version: project pin Lean 4.28.0.

## Acceptance

- At least one substantive theorem or a precise failed-statement report.
- No new assumptions hidden in a witness theorem.
- No finite-sampling replacement for all-momentum unitarity.
- Direct target build passes for every returned Lean file.

## Result and integration

Completed and audited.  Aristotle proved that within the degree-one Laurent
ansatz, all-momentum unitarity plus a Hermitian involutory tangent forces the
stationary coefficient to vanish.  The specialization `dirac_no_go` rules out
the original four requirements.  It also returned an explicit partial-channel
tangent with a stationary kernel satisfying exact unitarity, nonzero stationary
amplitude, and zone-edge separation.  This witness proves possibility after a
relaxation; it does not prove that the relaxation is uniquely minimal.

The result is integrated, with corrected scope language and axiom guards, as
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeNoGo.lean`.

```yaml
aristotle:
  project_id: 47b0fbe6-921e-4a96-80d0-f1cbf8faf671
  target_file: NullEdgeDoublerFree/NearestNeighborSymbol.lean
  expected_module: NullEdgeDoublerFree.NearestNeighborSymbol
  submission_project: AgentTasks/aristotle-submit/null-edge-doubler-free-regulator-20260710-project
  output_dir: AgentTasks/aristotle-output/47b0fbe6-921e-4a96-80d0-f1cbf8faf671
  status: integrated
```
