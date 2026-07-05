# Frontier job: finite-gap witness toward physical-sector transfer

Advance or sharply narrow Lane 6: make the finite-gap witness pathway less
toy-like while staying honest about missing Wilson-slab and cyclicity inputs.

## Included context

This package includes the current `PhysicsSM/` tree plus:

- `AgentTasks/context-packs/ym-finite-gap-frontier-20260705-20260705-142650.md`
- `AgentTasks/paper-units/dynamical-simulation-layer-brief.md`
- `AgentTasks/fourday-ym-run-2026-07-05/GOAL_STATEMENT_ACHIEVABLE_WORK.md`

Key files:

- `PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferWitness.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferSpectrum.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert*.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/CyclicityPrereq.lean`

## Desired result

Try to produce one of the following, in order of preference:

1. A small kernel-checked Lean helper connecting the existing one-link Z2
   transfer bridge more tightly to `FiniteGapSpectralWitness` or the
   `FiniteGapAssembly` API.
2. A precise partial witness structure or theorem statement for the smallest
   honest physical-sector consumer, with cyclicity/sector preservation clearly
   separated as hypotheses.
3. A design report identifying the exact field or theorem that prevents a
   physical-sector witness instantiation.

Do not claim a full Wilson slab transfer, Hamiltonian, infinite-volume theorem,
or physical mass gap.

## Output format

Return:

- `Patch or no-patch verdict`
- `Semantic alignment`
- `Smallest honest witness target`
- `Exact missing fields/hypotheses`
- `Next theorem statement`
