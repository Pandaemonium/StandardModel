# Track B cycle 19: deformation-dependent symmetry is not an invariant mixedness claim

Date: 2026-06-27
Cycle: 19
Track: B - information/generalization guardrail

## Trigger

The cycle 19 literature search surfaced Luscher's exact lattice chiral symmetry / Ginsparg-Wilson relation chunks and Nielsen-Ninomiya extension chunks. The useful lateral lesson is that a symmetry law can depend on the operator/deformation used to represent the lattice theory.

## Named failure mode

**Deformation-dependent-invariant leak.** A channel-dependent, regulator-dependent, or overlap-dependent symmetry law is accidentally promoted into an invariant statement about the underlying obstruction, such as `det P = m^2` or the normalized mixedness identity.

## Finite theorem target

Keep two layers separate in any future finite information API:

```lean
structure ObstructionDatum where
  invariant : Rat

structure ChannelPresentation where
  channelParameter : Rat
  effectiveChirality : Bool
```

Target theorem/counterexample:

```lean
theorem sameInvariant_differentChannelPresentation :
    exists x y,
      x.invariant = y.invariant /\
      x.channelPresentation.effectiveChirality != y.channelPresentation.effectiveChirality
```

The exact Lean shape should use real project APIs if/when available, but the point is simple: channel-presented chirality or observer symmetry can vary while the invariant obstruction remains fixed.

## Claim boundary

Track B may use observer-channel language as a diagnostic, but the invariant mass/mixedness statement must stay independent of a particular overlap, regulator, or presentation-dependent chiral transformation law.
