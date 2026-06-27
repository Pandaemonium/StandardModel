# Track B cycle 18: observer erasure is not ghost-zero safety

Date: 2026-06-27
Cycle: 18
Track: B - information/generalization guardrail

## Trigger

Cycle 18 integrated the original C90 Aristotle payload, which sharply separates scalar/Krein residue positivity from full Golterman-Shamir ghost-zero safety. The literature refresh hit Golterman-Shamir propagator-zero chunks directly, especially the warning that gauge-coupled propagator zeros can behave like ghost states rather than harmless removed mirrors.

## Named failure mode

**Erasure-as-release fallacy.** An information-theoretic statement says an observer channel hides, erases, or coarse-grains a mirror branch, and that statement is then treated as if it proved physical ghost-zero safety for a gauge-charged mirror sector.

## Finite theorem target

State a finite guardrail with two independent predicates:

```lean
structure ObserverChannelToy where
  branch : Type
  visible : branch -> Bool
  gaugeCharged : branch -> Bool
  ghostZero : branch -> Bool

def ObserverHidden (d : ObserverChannelToy) : Prop := ...
def NoGaugeCoupledGhostZeros (d : ObserverChannelToy) : Prop := ...
```

Prove a concrete counterexample:

```lean
theorem observerHidden_not_noGaugeCoupledGhostZeros :
    exists d, ObserverHidden d /\ not NoGaugeCoupledGhostZeros d
```

This is the Track B analogue of C90's Gate C guardrail: information loss or observer invisibility can be useful language, but it is not a substitute for the gauge-coupled ghost audit.

## Claim boundary

This note supports the obstruction-calculus framing without changing the headline physics. Mixedness, erasure, and observer-channel language remain interpretive/diagnostic unless paired with the Gate C release audits: physical line, mirror-sector gap, anomaly, Krein/spectral health, and locality.
