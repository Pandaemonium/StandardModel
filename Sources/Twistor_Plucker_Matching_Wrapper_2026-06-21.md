# Twistor-Plucker matching wrapper

Date: 2026-06-21

Lean anchor:

- `PhysicsSM.Draft.TwistorPluckerMass`
- depends on trusted `PhysicsSM.Spinor.PluckerMass`

Zotero/Neo4j source additions from this pass:

- `MFUJKFEA`: de Azcarraga-Fedoruk-Izquierdo-Lukierski, two-twistor particle
  models and free massive higher-spin fields.
- `2T3HC5NC`: de Azcarraga-Frydryszak-Lukierski-Miquel-Espanya, massive
  relativistic particle model from free two-twistor dynamics.
- `NFHRVF2Q`: Bars-Picon, single-twistor description of massless, massive,
  AdS, and interacting particles.
- `SZJE69PE`: Arkani-Hamed-Huang-Huang, scattering amplitudes for all masses
  and spins.
- `J5GA3CQ8`: Albonico-Geyer-Mason, from twistor-particle models to massive
  amplitudes.

## Purpose

This note records the narrow twistor/Plucker matching that should sit between
the trusted finite Plucker mass theorem and any later full twistor-incidence
formalization.

The point is not to formalize twistor space in full.  The point is to isolate
the finite-dimensional invariant-theory calculation that the null-edge program
needs:

```text
two-twistor spinor mass invariant
  =
squared Plucker wedge of the two visible null spinors.
```

Once this is separated, later work can add incidence data, projective twistor
quotients, conformal covariance, and convention bridges without disturbing the
finite mass theorem.

## Convention

Use a spinor chart for a twistor

```text
Z = (omega^A, pi_A')
```

where:

- `omega` is the incidence spinor;
- `pi` is the momentum spinor selected by the infinity-twistor pairing;
- both are represented in Lean by the concrete carrier `Fin 2 -> Complex`;
- only `pi` enters the finite mass theorem.

The wrapper defines

```text
I(Z,W) = epsilon^{A'B'} pi_A' eta_B'
```

as the project spinor wedge

```text
spinorWedge Z.pi W.pi.
```

This convention may differ by a sign, a factor of `2`, or a conjugation from
some physics papers.  Those variants should be handled by explicit
convention-bridge lemmas.  The present wrapper chooses the normalization in
which

```text
m^2 = det(P)
```

for the Hermitian momentum matrix

```text
P = sum_i pi_i pi_i^dagger.
```

## Hand proof: two twistors

Let

```text
Z = (omega, pi)
W = (xi, eta).
```

Define the spinor-chart infinity-twistor pairing by

```text
I(Z,W) = pi_0 eta_1 - pi_1 eta_0.
```

This is exactly the Plucker coordinate of the two momentum spinors.  The
visible two-twistor momentum is

```text
P = pi pi^dagger + eta eta^dagger.
```

The trusted theorem `two_edge_plucker_mass_identity` gives

```text
det(P) = |pi wedge eta|^2.
```

By the definition of `I`,

```text
|pi wedge eta|^2 = |I(Z,W)|^2.
```

Therefore

```text
det(P) = |I(Z,W)|^2.
```

No incidence equation was used.  In particular, the proof is stable under
later choices of spacetime point `x` satisfying `omega = i x pi`; incidence
data changes the geometric interpretation of the chart, not this mass
calculation.

## Hand proof: finite multi-twistor chart

For a finite family of chart twistors `Z_i = (omega_i, pi_i)`, define

```text
P = sum_i pi_i pi_i^dagger.
```

The trusted finite Plucker theorem gives

```text
det(P) = sum_{i<j} |pi_i wedge pi_j|^2.
```

But by definition of the infinity-twistor spinor pairing,

```text
pi_i wedge pi_j = I(Z_i, Z_j).
```

Hence

```text
det(P) = sum_{i<j} |I(Z_i,Z_j)|^2.
```

This is the desired multi-twistor spinor-chart matching.

## Projective rescaling

A projective twistor rescaling sends

```text
Z -> a Z,
W -> b W.
```

In the spinor chart this means

```text
pi -> a pi,
eta -> b eta.
```

By bilinearity of the antisymmetric contraction,

```text
I(aZ,bW) = ab I(Z,W).
```

Thus

```text
|I(aZ,bW)|^2 = |a|^2 |b|^2 |I(Z,W)|^2.
```

So the unnormalized mass contribution is homogeneous of bidegree `(1,1)` in
the two projective twistor representatives.  A genuinely projective angular
quantity must divide by the corresponding spinor norms, as in the normalized
wedge-spread lemmas in `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`.

## Lean wrapper status

`PhysicsSM.Draft.TwistorPluckerMass` now contains:

- `SpinorChartTwistor`
- `infinityTwistorPairing`
- `twoTwistorMassInvariant`
- `twoTwistorMomentum`
- `two_twistor_mass_invariant_eq_plucker`
- `two_twistor_momentum_det_eq_massInvariant`
- `twoTwistorMassSqDetConvention`
- `twoTwistorMassSqTraceConvention`
- `twoTwistorMassSqDetConvention_eq_massInvariant`
- `twoTwistorMassSqTraceConvention_eq_two_massInvariant`
- `rescaleTwistor`
- `infinityTwistorPairing_rescale`
- `twoTwistorMassInvariant_rescale`
- `MultiTwistorChart`
- `multiTwistorMomentum`
- `multiTwistorPairwiseMass`
- `multi_twistor_momentum_det_eq_pairwiseMass`
- `multiTwistorMassSqDetConvention`
- `multiTwistorMassSqTraceConvention`
- `multiTwistorMassSqDetConvention_eq_pairwiseMass`
- `multiTwistorMassSqTraceConvention_eq_two_pairwiseMass`

The file is draft-facing because it is convention packaging, but it contains
no `sorry`.

## Next formal targets

1. Add a projective normalized two-twistor spread theorem importing the
   normalized wedge-spread lemmas.
2. Add an incidence wrapper

   ```text
   omega^A = i x^{AA'} pi_A'
   ```

   only after a signature and matrix convention table is fixed.
3. Connect this wrapper to the massive spinor-helicity convention

   ```text
   P^{AA'} = lambda^{A I} bar(lambda)^{A'}_I
   ```

   with the little-group index `I = 1,2`.

## Local prover note

The local Qwen bridge failed to connect to Ollama during this pass, so no
local-model proof output was used.  A quick web check suggests that
DeepSeek-Prover-V2-7B remains a useful local baseline, but newer open Lean
prover families such as Goedel-Prover-V2 report stronger benchmark results,
with 8B and 32B variants that may be worth testing locally if GGUF/Ollama
builds are available.
