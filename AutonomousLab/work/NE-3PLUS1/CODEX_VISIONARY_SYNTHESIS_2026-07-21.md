# Visionary synthesis: from regulator recovery to physical selection

Date: 2026-07-21  
Role activation: `role-20260721-101611-2647c4d6`  
Scope: 3+1 HNU dynamics, origin of mass, continuum recovery, and adjacent
finite-QFT work

## Executive judgment

The program's strongest new 3+1 result changes the research bottleneck. The
live massive HNU walk now has a changing-lattice, position-space strong
convergence theorem to the free massive Dirac evolution at fixed finite time
and fixed nonzero complex Pluecker mass. The regulator-removal question is no
longer merely supported by fixed-momentum numerics or a supplied surrogate
walk.

This is a transport theorem, not yet a physical-selection theorem. It does not
derive the occupied band, an interacting field theory, an observed pole mass,
or the absolute value of the mass. The next decisive work should therefore
move from "does the walk approach Dirac?" to three sharper questions:

1. Can the live walk realize the limit with a proved polynomial microscopic
   cost?
2. Does the walk itself supply a stable, local physical band along refinement?
3. Does the Pluecker origin produce an observable not reproduced by an
   ordinary fitted Dirac mass?

## Ranked decisive gates

### 1. Live-band selection and adiabatic transport

**Objective.** Construct the spectral projector for one selected massive HNU
quasienergy band, prove a uniform neighboring-step arc gap on a compact
momentum window, and compose the exact finite adiabatic/leakage bounds along
the actual refinement schedule.

**Present limitation.** The repository has a full-zone fixed-mass gap, abstract
moving-sector leakage control, finite-difference adiabatic estimates, and an
exact supplied transporter witness. These have not been composed into a band
projector and transporter derived from the live HNU update.

**Mechanism.** Use the explicit finite-dimensional unitary fibers. Define the
projector by a Riesz contour or an equivalent polynomial spectral calculus,
control projector differences from the resolvent identity, and feed those
differences into the landed finite adiabatic bound.

**Dependencies.** Explicit HNU fiber formula; nonzero Pluecker gap; a chosen
quasienergy branch and compact window; resolvent/projector norm estimates;
`MovingSectorLeakage` and `DiscreteAdiabaticFiniteDifferences`.

**First cheap test.** At the exact rest fiber and one nonzero rational momentum
witness, compute the eigenphase separation and verify that the proposed contour
selects the intended two-dimensional sector without crossing the branch cut.

**Five-year payoff.** A physical-state selection rule tied to the same local
walk whose continuum limit is proved. This is the missing bridge between a
kinematically successful regulator and a candidate microscopic dynamics.

**Kill condition and pivot.** If the selected arc gap necessarily closes under
refinement on every useful compact window, abandon global band selection and
test local wave-packet or scattering-subspace selection. If no stable sector
survives even locally, the present HNU architecture is not a physical
microscopic model.

**Conventional alternative.** A standard Wilson or overlap-fermion projector
with a fitted mass and established spectral gap.

### 2. Polynomial-cost realization of the live continuum theorem

**Objective.** Close the exact ordered-exponential representation and prove a
polynomial step-count schedule for the live massive HNU walk, preserving the
same fixed mass and compact-window assumptions as the continuum theorem.

**Present limitation.** Strong convergence proves existence of the limit but
does not by itself give a useful microscopic resource law. The active draft
has the exact generator architecture but still contains documented proof
handoffs.

**Mechanism.** Lift the two-component chiral generators to the live four-block
fiber, use the proved block-exponential and fixed-unitary conjugation bridge,
sum the skew-Hermitian generator norms, apply the ordered-product error bound,
and telescope exact unitaries. Preserve exact cancellation at zero momentum;
the universal distance bound by two is too weak.

**Dependencies.** `MC2BlockExponentialLift`, the explicit HNU end-step factor,
the skew-Hermitian ordered-product theorem, and the existing many-step
telescoping estimate.

**First cheap test.** Kernel-check the exact factorization of `massiveWend` and
the generator-sum identity before attempting any asymptotic envelope.

**Five-year payoff.** A constructive complexity law for simulation and a
quantitative route from primitive local updates to continuum accuracy.

**Kill condition and pivot.** If every exact factorization forces
super-polynomial cost on a growing physical window, report that obstruction
and compare against higher-order product formulas or a different local cell.

**Conventional alternative.** Simulate the continuum Dirac Hamiltonian
directly or use a conventional lattice discretization with known complexity.

### 3. Phase-defect observable: origin or reparametrization?

**Objective.** Derive one held-out observable from the complex Pluecker origin
that is not fixed by the constant magnitude `|z|` alone.

**Present limitation.** The same Pluecker area supplies the rest operator and
its continuum Dirac gap, but a constant `z` can still look observationally
identical to a fitted complex mass. Absolute scales and measured mass ratios
remain underived.

**Mechanism.** Compare two profiles with the same pointwise magnitude: a
constant-phase control and a patched phase-winding defect. Derive the link
field from the local Pluecker phase, then test a protected mode count,
localization index, or phase-sensitive two-particle amplitude.

**Dependencies.** Variable-Pluecker phase connection; patched winding data;
finite index or localization theorem; a measurement/readout map; eventually
the finite Fock and local interaction layers.

**First cheap test.** On the smallest periodic complex with a genuine patched
winding, prove that no global vertex rephasing identifies it with the constant
profile and compute one exact spectral or transfer invariant.

**Five-year payoff.** A discriminating prediction from the claimed geometric
origin of mass rather than a new name for an input parameter.

**Kill condition and pivot.** If every gauge-invariant observable in the
completed local model depends only on `|z|`, demote the Pluecker construction
to a derivation/parametrization of the Dirac rest term. Retain the finite
identity, but drop claims of new empirical content.

**Conventional alternative.** A standard Dirac or Yukawa mass field with the
same magnitude and independently supplied phase texture.

## Cross-project opportunities

- **Continuum plus finite QFT.** Lift the free HNU schedule through the existing
  finite CAR construction, then add the landed local quartic pair transfer.
  The first target should be finite-time locality and norm control, not a claim
  of interacting continuum QFT.
- **Mass plus gauge/geometry.** Treat the shared Higgs datum and Pluecker datum
  as explicitly separate inputs until a theorem links them. A shared symbol is
  not shared dynamics.
- **Frame blindness plus selection.** The finite-group suppression theorem
  suggests a general design principle: define physical readouts on quotient or
  invariant sectors before interpreting raw frame-dependent quantities. Its
  extension to compact or spacetime groups is a new theorem, not an automatic
  corollary.
- **Simulation as falsifier.** The theorem-driven harness should compare the
  live HNU walk, a fitted-mass conventional control, and a phase-defect profile
  using the same held-out observables and error budget.

## Assumptions most at risk

1. A fixed nonzero mass and compact momentum window may conceal gap closure or
   branch-cut problems under a physical refinement path.
2. Strong free evolution convergence may survive while no local interacting
   Fock lift has a controlled continuum limit.
3. The Pluecker origin may supply no observable beyond an ordinary complex
   mass parameter.
4. The strict primitive-null interpretation may require extra register states,
   stay substeps, or micromotion topology. Those are admissible if the complete
   period has a null factorization and the effective causal cone is correct;
   they should not be rejected to preserve a preferred picture.
5. Finite-group frame-blindness results do not yet justify Lorentz- or
   Poincare-invariant suppression claims.

## Recommended queue change

Promote **live-band selection and adiabatic transport** above further generic
continuum strengthening. Keep the polynomial-cost proof as the active
parallel theorem lane and the phase-defect observable as the primary
phenomenology lane. Defer broader ontology prose until one of those two
physical-selection/discrimination gates lands or fails.

This ordering uses the new continuum theorem as a foundation instead of
re-proving weaker variants of it. It also makes the conventional fitted-mass
walk an explicit control, so a successful result must earn more than continuum
agreement.
