# Aristotle prompt: relative-entropy observer-channel design

You are working inside a curated context package from the `PhysicsSM` null-edge
research program. This is a strategy/design job, not a full proof-completion
job.

## Goal

Design a finite observer-channel and relative-entropy API that can serve as the
shared information-theoretic spine for two null-edge branches:

1. visible/internal reduction and mass-as-celestial-mixedness;
2. causal-diamond source visibility, ANEC/QNEC-style positivity, and
   recoverability.

The output should help us decide which exact finite theorems are ready for Lean
proof and which are still definition-risky.

## Read first

Use these files in the package as primary context:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Bibliography.md`
- `AgentTasks/null-edge-overnight-run-plan-2026-06-21.md`
- `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`
- `AgentTasks/null-edge-grand-strategy-v2-output.md`
- `AgentTasks/null-edge-physics-audit-report-aristotle-20260622.md`
- `LeanContext/Draft/NullEdgeQubitConcurrence.lean`
- `LeanContext/Draft/NullEdgeDecoherenceChannelAristotle.lean`
- `LeanContext/Draft/NullEdgeQuantumMeasureFiniteAristotle.lean`

## Desired deliverables

Please create a written design note at:

```text
AgentTasks/null-edge-relative-entropy-observer-channel-output.md
```

The design note should include:

- a minimal finite API for observer/coarse-graining maps;
- a staged proof route starting with classical finite KL divergence if full
  quantum matrix relative entropy is too heavy;
- exact statement sketches for data processing and recoverability;
- how the API should interface with the current qubit concurrence theorem
  without confusing single-qubit linear entropy with Wootters mixed two-qubit
  concurrence;
- how the API should interface with P9 source visibility without making ANEC,
  QNEC, or continuum modular-Hamiltonian claims prematurely;
- confidence scores from 1 to 10 for each proposed definition and theorem;
- a ranked list of proof jobs ready for Aristotle.

Optionally create a clearly labelled non-imported scaffold file at:

```text
PhysicsSM/Draft/NullEdgeRelativeEntropyObserverRoadmap.lean
```

If you create Lean-looking declarations, they may be proof skeletons or contain
spaced handoff markers, but do not pretend they compile unless you actually
checked them. This job does not require a full repository build.

## Candidate theorem targets

Please refine, split, or reject these:

```lean
klDataProcessing_for_finitePartition
relativeEntropyDataProcessing_for_finiteObserver
observerLoss_nonneg
loss_zero_if_exactObserverRecovery
visibleObserver_concurrenceMonotonicity_boundary
diamondObserver_monotonicity_handoff
sjDiamondReferenceState_def
petzRecoverabilityGap_controls_sourceVisibility
```

For quantum relative entropy, be explicit about positivity, trace-one,
support-inclusion, finite-dimensional Hilbert-space, and channel hypotheses.
If these are too heavy for immediate Lean, propose the classical finite
partition version first.

## Physics boundary

Treat ANEC/QNEC, modular Hamiltonians, Petz recovery, and Sorkin-Johnston
diamond entropy as source-backed continuum motivation. The finite Lean program
should first prove data-processing and observer-loss facts in a controlled
finite setting, then use those as honest analogues.

## Output style

Be concrete and selective. The best answer would tell us which two or three
finite theorems to prove next, which hypotheses must be bundled into the
definitions, and which high-level physics slogans are not yet justified.
