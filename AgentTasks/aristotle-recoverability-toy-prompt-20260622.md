# Aristotle prompt: finite recoverability toy witness

You are working in a focused Lean package. This is a proof-fill job over the
finite relative-entropy observer scaffold.

## Target

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgeRecoverabilityToy.lean
```

It imports:

```lean
import PhysicsSM.Draft.NullEdgeRelativeEntropyObserverRoadmap
```

The imported scaffold already proves finite distributions, column-stochastic
observer channels, KL divergence, data processing, observer-loss nonnegativity,
and exact recoverability saturation.

## Goal

Prove a tiny witness showing that a non-injective observer can lose information
strictly and cannot exactly recover two distinct hidden distributions.

## Target declarations

Please prove:

```lean
deterministicObs.col_sum_one
merge_pushforward_pointMass0_eq_fairCoin
merge_observerLoss_pos
merge_no_exactRecovery
merge_recoverabilityGap_pos
```

You may add helper lemmas in the target file. Do not change the imported
relative-entropy scaffold unless there is a real bug.

## Constraints

- Keep this classical finite only.
- Do not add quantum matrix relative entropy, Petz-map continuum claims, or
  source-visibility physics claims.
- Do not weaken theorem statements unless a statement is false; if so, explain
  the counterexample.
- Run:

```text
lake env lean PhysicsSM/Draft/NullEdgeRecoverabilityToy.lean
```

Return the completed target file and a short summary.
