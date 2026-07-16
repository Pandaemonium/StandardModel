# Anomaly-ledger and 3-4-5-0 harvest audit

## Verdict

Both Aristotle returns contain useful finite theorem clusters.  Neither closes
the 3+1 regulator problem or the interacting mirror-gap problem.  The live
modules preserve the algebra and make the missing physical steps explicit.

## Anomaly/index ledger

Live module: `PhysicsSM/Draft/NullEdge/AnomalyIndexLedger.lean`

Accepted:

- Exact one-generation Standard Model hypercharge anomaly identities in the
  displayed all-left-handed convention.
- An independently defined oriented integer-weight ledger and its zeroth,
  first, and cubic moments.
- Explicit counterexample: first and cubic moments vanish while the zeroth
  oriented count is `15`.
- Additivity, orientation reversal, and an abstract characterization of any
  index normalized to return a channel's integer weight.

Narrowed:

- `sink = <0,-15>` is one **aggregate ledger entry**, not one elementary
  fermion.  Since `Channel.weight` is any integer, the claimed minimality is
  only minimal list-entry count under this API.
- The result does not derive the ledger weight from a local lattice operator,
  prove a bulk-edge theorem, or produce a physical mirror sector.
- Anomaly moments and the stabilized boundary count are deliberately distinct;
  the theorem is a no-implication result, not anomaly inflow.

## Finite 3-4-5-0 quartic resonance

Live module: `PhysicsSM/Draft/NullEdge/Finite3450QuarticResonance.lean`

Accepted:

- Exact `3-4-5-0` quadratic anomaly identities in the displayed chirality
  convention.
- A 32-dimensional finite fermionic occupation space with Jordan-Wigner signs.
- A nonzero charge-conserving quartic operator not representable by the stated
  bilinear API and not diagonal.
- Exact eigenvalues `+1` and `-1` and a norm identity on the selected
  two-configuration subspace.

Narrowed:

- This is an exact **quartic resonance**, not symmetric mass generation for the
  complete mirror sector.
- The full Hamiltonian annihilates the vacuum and every one-particle basis
  state.  The new theorem `full_hamiltonian_has_zero_mode` packages an explicit
  nonzero zero mode, proving that the full finite operator is not gapped at
  zero.
- No spatial locality, scalable volume family, uniform thermodynamic gap,
  ground-state uniqueness, absence of spontaneous symmetry breaking, or
  continuum mirror decoupling is proved.

## Successor gates

The interacting route must next define an actual target/mirror tensor or local
lattice decomposition and prove a full mirror-sector lower bound after
quotienting only the intended protected sector.  The anomaly route must derive
the integer orientation weights from the same local operator and gap labels
used by the Floquet construction.  Until then, the two ledgers are compatible
constraints, not one theorem.
