# Mass and 3+1 synthesis after the changing-lattice theorem

Date: 2026-07-21
Owner: Codex
Claim discipline: finite identity / asymptotic theorem / reconstruction gate

## The new center of gravity

The program now has a connected free one-particle chain:

```text
finite null-spinor area z
  -> exact Hermitian rest operator B_z
  -> exact local-unitary massive 3+1 HNU walk
  -> uniform compact-momentum many-step control
  -> changing-lattice position-space strong L2 convergence
  -> free massive Dirac flow with the same supplied z
```

This is stronger than an infrared Taylor match.  For fixed finite time, fixed
supplied complex mass, and arbitrary fixed four-spinor `L2` data, the actual
cell-projected walk converges strongly in position space to the exact free
massive Dirac evolution.

The claim boundary is equally important.  The theorem does not choose `z`,
remove the compensating Floquet sector, add interactions, or prove a Standard
Model continuum limit.

## Spectral selection is now a finite ladder

The full massive-HNU characteristic determinant is reduced for every complex
spectral parameter to a two-component opposite-chirality determinant.  A new
generic theorem proves that determinant-one of both chiral blocks forces the
degree-four polynomial to be reciprocal.  Equal trace and unitarity are not
needed.  Therefore every nonzero characteristic root of the live walk is
paired with its reciprocal.  This now composes exactly with the inverse Cayley
map: the shifted determinant of the Hermitian Cayley generator is even for
every complex spectral parameter.

Remaining exact ladder:

1. Convert evenness plus Hermiticity and the global zero gap into opposite
   ordered eigenvalue pairs.
2. Deduce exactly two positive and two negative eigenvalues.
3. Prove the canonical negative-sign projector has rank two.
4. Prove continuity or quasi-local decay for the canonical projector, not only
   continuity of its generator.
5. Add a stated local interaction and quantify leakage from the moving band.

Steps 1-3 are finite algebra and spectral theory.  Steps 4-5 are the true
physical-sector bridge.  Even a successful rank-two theorem does not delete
the companion sector; it identifies a canonical band inside the complete
local unitary register.

## Origin-of-mass story: what is complete and what is not

The kinematic representation is close to complete:

- a finite null-spinor bundle has mass squared equal to total Pluecker area;
- the massless locus is exactly projective collinearity;
- every nonnegative mass value has an explicit two-edge realization;
- every positive-semidefinite `2x2` Hermitian momentum is a finite sum of
  rank-one null momenta;
- the Pauli map identifies its determinant with the Minkowski square.

The remaining cone-coverage lemma is explicit: every future non-spacelike
four-vector has a positive-semidefinite Pauli representative.  Once landed,
every forward-cone momentum is represented by null-edge data.  This completes
the representation theorem, not dynamical mass selection.

For fermion and Majorana mass matrices, the finite classification is also near
a sharp endpoint.  The Dirac/Yukawa, Weinberg/Majorana, mixed pseudo-Dirac,
confinement/transfer, and composite-pole branches have formal theorem ladders.
The arbitrary-generation complex symmetric branch still needs the full
Autonne-Takagi basis theorem.  The in-progress proof has reduced that to one
orthonormal antilinear eigenbasis lemma; a real `2n x 2n` symmetric-doubling
fallback is now literature-mapped.

What remains fundamentally underived is the value problem: why nature selects
the observed couplings, absolute scale, hierarchy, and pole locations.  The
positive homogeneous Pluecker action no-go proves that a scale cannot be
claimed from that kinematics alone.

## Strongest honest headline

> A finite null-spinor area can be carried by an exactly local unitary `3+1`
> regulator whose changing-lattice position-space limit is the free massive
> Dirac flow.  The same construction represents every nonnegative mass and is
> approaching complete forward-cone coverage.  It derives the form and
> transport of a supplied mass datum, not its observed numerical value.

## Decisive next results

1. `HNUCayleySpectralPairing`: exact `2+2` inertia and rank-two projector.
2. `ForwardConePSD`: unconditional null-bundle representation of every future
   non-spacelike four-momentum.
3. `FiniteAutonneTakagi`: arbitrary-generation complex symmetric mass
   classification, including zero and repeated singular values.
4. `HNUInteractingBandLeakage`: a local interaction with controlled leakage in
   a changing-lattice limit.
5. A scale-selection theorem or sufficiently broad no-go identifying the
   required dimensional input.

## Kill conditions

- If the canonical rank-two band cannot be made continuous or quasi-local, it
  is not a viable local physical sector.
- If the forward-cone Pauli matrix fails positivity, the proposed universal
  null-bundle representation is false in the stated conventions.
- If Takagi completion requires distinct or nonzero singular values, it does
  not cover arbitrary finite Majorana mass matrices.
- If every nonzero scale still enters as an external coefficient, the program
  has explained mass form but not mass selection.

## Formal anchors

- `PhysicsSM.Spinor.PluckerMass`
- `PhysicsSM.Draft.NullEdge.PluckerMassKinematicCompleteness`
- `PhysicsSM.Draft.NullEdge.PluckerMassOperator`
- `PhysicsSM.Draft.NullEdge.HNUMassiveChangingLatticeContinuumCapstone`
- `PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity`
- `PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical`
- `PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity`
- `PhysicsSM.Draft.NullEdge.FiniteTakagiMajoranaPartial`
- `PhysicsSM.Draft.NullEdge.FiniteAutonneTakagi`
