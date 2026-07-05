# Load-bearing audit: finite dynamics oracle and Lean transfer bridge

Audit the finite dynamics layer: the descriptor-driven Z2 transfer oracle, the
one-link Lean bridge, and the finite-gap witness surfaces. This is a semantic
and claim-boundary audit, not a request to prove continuum physics.

## Included context

This package includes the current `PhysicsSM/` tree and `Scripts/` tree, plus:

- `AgentTasks/context-packs/ym-dynamics-load-bearing-audit-20260705-20260705-142627.md`
- `AgentTasks/paper-units/dynamical-simulation-layer-brief.md`
- `AgentTasks/fourday-ym-run-2026-07-05/GOAL_STATEMENT_ACHIEVABLE_WORK.md`

Key files:

- `Scripts/oracle/z2_transfer_oracle.py`
- `Scripts/oracle/validate_lgt_core.py`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferSpectrum.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferWitness.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert*.lean`

## Audit questions

1. Are the Lean theorem surfaces semantically aligned with the oracle records?
2. Does any prose overclaim a physical transfer matrix, Hamiltonian,
   infinite-volume limit, continuum limit, or physical mass gap?
3. Are the one-link `L = 1` theorem surfaces honest prototypes for a larger
   finite transfer layer, or are there hidden assumptions that will not scale?
4. Is `FiniteGapSpectralWitness` instantiated in a non-vacuous but claim-safe
   way?
5. What is the smallest next Lean target that would move from toy one-link
   evidence toward a genuine finite physical-sector Wilson slab consumer?

## Optional checks

If feasible, run:

```text
python -m py_compile Scripts/oracle/z2_transfer_oracle.py Scripts/oracle/validate_lgt_core.py
python Scripts/oracle/validate_lgt_core.py
lake env lean PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean
lake env lean PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean
```

Skip slow commands rather than spending the whole job on build latency.

## Output format

Return:

- `Verdict`
- `Claim-boundary issues`
- `Semantic alignment findings`
- `Load-bearing gaps`
- `Next Lean target`
- `Suggested theorem statement(s)`
