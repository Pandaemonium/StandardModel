# The overnight `3+1` result, in plain language

Date: 2026-07-21
Role: Codex / Educator
Work item: `EDU-OVERVIEW-001`

## The short version

We have been testing whether a world built from finite, exactly local quantum
updates can reproduce ordinary relativistic motion when its grid becomes
finer. Overnight, the answer became substantially stronger for one important
case.

The actual four-component HNU update now has a machine-checked theorem saying
that, as the lattice is refined, its motion approaches the ordinary free
massive Dirac equation in three space dimensions and one time dimension. The
comparison is made on full wavefunctions in position space, not only on an
energy formula or a small-momentum sketch.

## Why that is a real advance

A lattice model can easily imitate the first few terms of a familiar equation
without reproducing its dynamics. The new proof follows the complete evolution
for any fixed finite time and any fixed square-integrable initial wavefunction.
It controls three sources of error:

1. repeating the finite update instead of the exact Dirac flow;
2. representing momentum by finer and finer cells; and
3. the high-momentum tail outside a bounded comparison region.

All three errors vanish in the changing-lattice limit. The limiting Dirac
Hamiltonian is also proved to be a legitimate self-adjoint, closed operator,
which is the mathematical condition needed for consistent unitary time
evolution.

## Where mass enters

The update contains a complex oriented area made from the model's primitive
null-spinor data. Its magnitude supplies the rest gap and its phase records
orientation information. The continuum proof uses that same area as the mass
term; it does not quietly insert a second unrelated mass parameter at the end.

This explains the structural origin of the rest term inside the model. It does
not yet explain why nature chooses the electron's numerical mass, or the ratios
among particle masses.

## The strongest accurate sentence

> A finite-depth local-unitary `3+1` walk with a Pluecker-derived rest operator
> converges strongly to free massive Dirac evolution as its lattice is refined.

## What is still missing

The theorem describes a free one-particle field with fixed mass. It does not
yet include gauge interactions, particle creation, a complete many-particle
quantum field theory, or a derivation of measured mass values. The microscopic
model also contains compensating high-frequency sectors. Current work asks
whether a physically selected low-energy band remains isolated and stable as
the regulator changes.

The next empirically interesting step is not another restatement of the Dirac
equation. It is a result that distinguishes the Pluecker origin from an
ordinary fitted mass, such as a phase-winding defect mode or a phase-sensitive
two-particle scattering effect.

## Formal anchors

The main result is in
`PhysicsSM/Draft/NullEdge/HNUMassiveChangingLatticeContinuumCapstone.lean`.
Its operator-theoretic completion is in
`HNUMassiveMaximalMultiplier.lean` and
`HNUMassivePositionHamiltonian.lean` in the same directory.
