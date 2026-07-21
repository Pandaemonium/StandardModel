# A local 3+1 quantum walk is now a regulator candidate, not yet a theory

Date: 2026-07-20
Audience: scientifically literate general readers, undergraduates, and
adjacent researchers who do not know the project notation

## One-sentence result

We now have an exact finite update rule in three space dimensions that preserves
quantum probability, has the intended low-momentum Weyl behavior, has a complete
finite census of its zero- and pi-quasienergy crossings, and can be gapped by the
project's finite mass turn without closing that gap anywhere in momentum space.

That is a serious regulator result. It is not yet a derivation of physical
spacetime or a complete quantum field theory.

## The picture

Imagine one clock cycle divided into several ordered local operations. During
one operation, one internal component moves while another remains in the same
coarse cell; later operations exchange their roles. The whole cycle is exactly
reversible and probability-preserving. The apparent "stay" is therefore not a
particle deciding whether to move. It is one part of an ordered quantum update
whose complete schedule transports and mixes amplitudes.

The useful visual has three aligned panels:

1. **Within one cycle:** colored components undergo conditioned shifts and
   internal rotations in a fixed order.
2. **After one cycle:** the net local unitary has one Weyl-like cone near zero
   momentum and a fully classified set of high-momentum crossings.
3. **As the grid is refined:** the still-open theorem asks whether wave packets
   converge in position space to the continuum Weyl or Dirac evolution.

The first two panels are exact finite results. The arrow to the third is the
main analytic obligation.

## What was difficult

A naive three-dimensional checkerboard does not work. Requiring every internal
component to make a unit spatial translation at every substep, while keeping a
minimal cell and exact unitarity, creates normalization conflicts and unwanted
high-frequency copies. The successful finite construction relaxes that
microscopic picture: locality and unitarity remain exact, but motion is
conditioned on an internal register and spread across ordered micromotion.

This is not a cosmetic change. It identifies a real resource needed by the
three-dimensional problem: internal memory and time ordering can carry
topological information that a single endpoint Hamiltonian does not display.

## What has been checked

**Machine-checked finite statements:**

- The massless endpoint is unitary for every momentum.
- Its determinant is one.
- In the closed Brillouin cube, the zero-quasienergy crossing occurs only at
  the origin, and the pi crossings are exactly the classified boundary set.
- The derivative at the origin has the intended Weyl form and positive local
  orientation, with a nonzero axis witness.
- The corresponding finite real-space schedule preserves the exact inner
  product and acts on plane waves by the certified momentum-space symbol.
- A nontrivial Pluecker mass angle produces a unitary doubled walk with positive
  determinant margins at both zero and pi throughout the full zone.
- All nontrivial positive mass angles are connected inside this finite family
  without closing those determinant gaps.
- Compactness plus the no-crossing result yields a uniform separation of every
  eigenvalue from `+1` and `-1`; this general theorem has passed a targeted Lean
  build and awaits final cross-family guard integration.

## What the result means

The old question was: "Can a strictly local, exactly unitary 3+1 update even
have the right low-energy relativistic behavior without the obvious lattice
copies?" For this finite free architecture, the answer is now yes.

The new question is harder and more physical: "Does this exact regulator
converge to the intended continuum equation, and is its global topological
accounting compatible with the physical particle sector?"

Floquet literature sharpens the second question. In three dimensions, a
single low-energy Weyl charge can be balanced by winding and complementary
micromotion structure. Therefore a unique crossing at the endpoint is not
enough. We must either compute the global three-dimensional winding of the
complete HNU map, or exhibit a local invariant low-energy block and identify
the compensating charge in its complement.

## Evidence-grade map

| Statement | Grade | Boundary |
|---|---|---|
| The finite HNU update is local and exactly unitary. | Machine-checked finite result | Says nothing by itself about the continuum. |
| Its full-zone zero/pi crossing census and local Weyl orientation are exact. | Machine-checked finite result | A crossing census is not yet a global winding theorem. |
| The massive doubled family has a full-zone determinant gap. | Machine-checked finite result | It is a free finite Floquet gap, not yet a measured pole mass. |
| The finite schedule approximates Weyl/Dirac evolution in position space. | Open theorem with several landed analytic rungs | The changing-lattice integral estimate and PDE identification remain. |
| One physical Weyl species survives with correct anomaly accounting. | Open physical reconstruction | Requires winding or invariant-sector and complement theorems. |
| Every primitive process is literally lightlike. | Ontology under test | Conditioned coarse stays still need a valid moving-cover interpretation or an admitted relaxation. |

## Learning objectives

After reading the brief, a reader should be able to:

1. distinguish exact locality from "every component moves in every substep";
2. explain why a coarse stay can be part of a nontrivial local unitary cycle;
3. distinguish a finite crossing census from a global topological invariant;
4. distinguish a lattice spectral gap from a physical rest or pole mass;
5. name the continuum and sector-stability theorems still required.

## Misconception audit

**Misconception: the stay means the particle is motionless.**

Correction: the update acts on quantum amplitudes and internal components. A
coarse position can remain unchanged during one conditioned substep while the
full ordered cycle carries nontrivial transport and phase information.

**Misconception: one Weyl crossing means the doubling problem is solved.**

Correction: the complete Brillouin zone and the full micromotion topology must
be counted. Compensation may live at another quasienergy, in another block, or
in the winding of the drive.

**Misconception: a finite gap is already a particle mass.**

Correction: a physical mass claim additionally needs a positive physical
sector, nonzero observable overlap, a spectral atom or pole, continuum
persistence, and the relativistic dispersion relation.

**Misconception: convergence at each fixed momentum proves continuum physics.**

Correction: position-space convergence needs one error bound that survives the
changing lattice, including the ultraviolet tail of the initial state.

## Formal anchors

- `PhysicsSM/Draft/NullEdge/HNURegulatorCapstone.lean`
- `PhysicsSM/Draft/NullEdge/HNUExactCore.lean`
- `PhysicsSM/Draft/NullEdge/HNURealSpaceBridge.lean`
- `PhysicsSM/Draft/NullEdge/HNUQuantitativeGlobalGap.lean`
- `PhysicsSM/Draft/NullEdge/HNUMassiveGapHomotopy.lean`
- `PhysicsSM/Draft/NullEdge/HNUCompactMomentumContinuum.lean`
- `PhysicsSM/Draft/NullEdge/UniformQuasienergyGap.lean`
- `AutonomousLab/work/NE-3PLUS1/CODEX_HNU_CONTINUUM_COMPOSITION_2026-07-20.md`
- `AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_3PLUS1_STAY_FLOQUET_2026-07-20.md`

## Accuracy ceiling

The strongest responsible public statement today is:

> We have a kernel-checked, local, exactly unitary free 3+1 Floquet regulator
> with a complete finite crossing census, the intended infrared Weyl tangent,
> and a globally gapped finite massive extension. Position-space continuum
> convergence, the global micromotion charge budget, interacting sector
> stability, and literal primitive-null completion remain open.

Do not shorten this to "we derived 3+1 spacetime," "we solved fermion
doubling," or "we proved every particle moves at light speed."
