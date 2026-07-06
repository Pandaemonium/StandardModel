# FINDING: the fermionic RP-F N5 Gram crux is FALSE on the periodic time circle

Date: 2026-07-06 (overnight all-mass run). Discovered by Aristotle job
`sm-fermionic-gram-crux` (`322b9f72`), which - like the Q6-downstream job - refused
to fabricate and instead produced a kernel-checked DISPROOF.

## The finding

The RP-F node N5 crux `reflectedWilsonBlock_eq_gram` (the claim that the reflected
positive-half Wilson-Dirac block factors as a Gram matrix `M^H M`, hence is PSD)
is **FALSE as formulated over the PERIODIC time circle**.

Mechanism: with periodic time the two-sided `posHalf` sandwich is bounded by BOTH
reflection planes, so TWO cross-mirror temporal hopping terms survive, carrying
OPPOSITE-chirality projectors (`+P_+` and `-P_-`). Their sum is INDEFINITE
(non-PSD), so no Gram factorization exists.

## Kernel-checked disproof (verified negative)

- `reflectedWilsonBlock_not_gram_L2` (+ helper `reflectedWilsonBlock_apply`):
  for the concrete instance `L=2, nc=1, U == 1`, the reflected block reduces on
  each Dirac spin factor to `-gamma_0`, which is indefinite - so no `M^H M`
  factorization can exist. Kernel-checked in the job's copy.

## Consequence for the fermionic RP-F lane (NE-U5 fermion track)

The whole A7 scaffold (`8684c341`: N5 + the N6-N12 assembly +
`finite_fermionic_RP`) was CONDITIONAL on N5. Since N5 is false on the periodic
circle, that entire conditional chain is not merely unproved but UNPROVABLE as
formulated. This VINDICATES the earlier decision (harvest wave 2) to NOT integrate
A7's conditional scaffold and to keep `FermionicReflection.lean` `s o r r y`-free.

## What this does NOT kill, and the corrected direction

Fermionic reflection positivity is a STANDARD, true fact of lattice gauge theory -
the falsity is specifically an artifact of the PERIODIC-time reflection convention
used in the scaffold (two reflection planes). The correct setup uses an OPEN /
reflected-boundary time direction (a single reflection plane / a genuine
time-reflection across one cut, as in the bosonic `WilsonSlabConnected` /
`ReflectionCutPlaquetteFamily` geometry), where only ONE cross-mirror hopping
survives and the Gram factorization holds. The corrected N5 should be re-stated
over the SINGLE-cut reflection geometry, mirroring the bosonic cut-slab
construction, NOT the periodic circle.

## Integration decision

- The DISPROOF is a genuine verified negative but requires the scaffold setup
  (`posHalf`, `reflectedWilsonBlock`) to state; rather than add a false-crux +
  scaffold to the currently-`s o r r y`-free `FermionicReflection.lean`, this
  finding is RECORDED here and the disproof is preserved in the
  `sm-fermionic-gram-crux` harvest. `FermionicReflection.lean` stays clean.
- FOLLOW-UP: re-state fermionic RP-F over the single-cut reflection geometry
  (reuse the bosonic cut-slab reflection), then the Gram factorization is
  expected to hold. This is the corrected NE-U5 fermion-track direction.

## Discipline note

Second verified-negative of the night (with the Q6-downstream falsity). Both came
from Aristotle jobs correctly refusing to fabricate a proof of a false statement.
Do not resurrect the periodic-circle fermionic Gram claim.
