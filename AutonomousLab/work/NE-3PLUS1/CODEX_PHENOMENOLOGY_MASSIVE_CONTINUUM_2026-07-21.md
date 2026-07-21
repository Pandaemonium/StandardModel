# Observable card: what the massive continuum theorem buys

Date: 2026-07-21
Role: Codex / Phenomenologist
Work item: `QCA-3PLUS1-001`

## Result being cashed out

The live changing-lattice HNU walk converges strongly in position-space `L2`
to free massive Dirac evolution for fixed complex Pluecker area `z`, finite
physical time, and fixed square-integrable initial data. The limiting
Hamiltonian is self-adjoint and closed on its maximal Fourier-multiplier
domain. The same `z` determined by the finite null-spinor data supplies the
rest operator; no second mass coefficient is introduced in the walk.

This is a regulator-recovery theorem, not yet a prediction of a new measured
number.

## Observable dictionary

| Quantity | Status | Units after scale restoration | Role |
| --- | --- | --- | --- |
| Lattice spacing `a` | regulator input | length | sent to zero |
| Step duration | regulator input | time, with null support fixing `c a` | tied to `a` |
| Complex Pluecker area `z` | derived within the finite kinematics, fixed in the limit | inverse length / energy after choosing units | rest gap and phase |
| Physical time `t` | externally selected | time | held fixed in convergence |
| Initial spinor `f` | externally prepared | normalized `L2` field | held fixed |
| Dirac flow `exp(-it H_z)` | established-physics baseline | unitary evolution | theorem's limit |
| Strong `L2` error | derived and bounded | dimensionless after state normalization | primary benchmark |

The theorem establishes that the error tends to zero. It does not yet turn
`z` into the electron mass, fix an absolute unit, or produce a flavor ratio.

## Baseline and controls

**Baseline.** The conventional free massive Dirac propagator with the same
fixed mass and initial state.

**Positive control.** Nonzero momentum and nonzero rational Pluecker data show
that both kinetic and rest generators are active; the result is not a static
or massless collapse.

**Boundary control.** At collinearity, `z = 0` and the rest gap closes. This is
the exact massless boundary of the finite construction.

**Adversarial control.** The full microscopic register retains compensating
high-frequency structure. The continuum theorem cannot be presented as a
global one-particle classification or a no-doubling theorem.

## What could become observable

The free convergence result chiefly licenses later calculations. It makes the
following tests meaningful, in descending order of discriminating value:

1. **Phase-defect response.** Prescribe a spatially varying Pluecker phase,
   derive the induced link field, and hold out the existence, multiplicity,
   and localization length of a defect mode. A result depending on winding or
   orientation can distinguish Pluecker data from a renamed constant mass.
2. **Two-particle phase-sensitive scattering.** Complete the local Fock lift
   and hold out a scattering phase or selection rule that depends separately
   on `z` and its conjugate, not only on `|z|`.
3. **Finite-regulator correction.** With the microscopic schedule fixed before
   comparison, calculate the leading correction to free Dirac propagation and
   test whether its coefficient is derived rather than fitted.
4. **Moving-band stability.** Show that the physical low-energy Floquet band
   remains gapped and that accumulated leakage vanishes along the changing
   lattice. This is a consistency gate, not by itself an experimental signal.

## Preregistered next experiment

The highest-value held-out target is the phase-defect response:

- **Input:** a fixed finite profile with nonzero bulk `|z|` and one unit of
  patched phase winding;
- **baseline:** a constant-phase profile with the same bulk `|z|`;
- **held out:** zero/near-zero mode count and localization length;
- **success:** a proved stable spectral distinction forced by the winding;
- **kill condition:** every gauge-invariant spectral and scattering quantity
  depends only on `|z|` once endpoint conventions are removed.

## Claim ceiling

The overnight theorem justifies calling the HNU construction a mathematically
controlled regulator candidate for free massive Dirac dynamics. It does not
yet justify calling it a completed particle theory, an origin of the measured
mass scale, or an empirically distinct theory of nature.

## Formal anchors

- `PhysicsSM/Draft/NullEdge/HNUMassiveChangingLatticeContinuumCapstone.lean`
- `PhysicsSM/Draft/NullEdge/HNUMassiveChangingCellL2.lean`
- `PhysicsSM/Draft/NullEdge/HNUMassiveContinuumReduction.lean`
- `PhysicsSM/Draft/NullEdge/HNUMassiveSchwartzPDE.lean`
- `PhysicsSM/Draft/NullEdge/HNUMassiveMaximalMultiplier.lean`
- `PhysicsSM/Draft/NullEdge/HNUMassivePositionHamiltonian.lean`
