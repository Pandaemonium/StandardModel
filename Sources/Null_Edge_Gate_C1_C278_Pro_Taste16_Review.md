# Gate C1 C278 Review: Pro Taste16 W_branch Candidate

Date: 2026-06-29
Status: Integrated review note from Aristotle C278.

## Executive verdict

Pro's literal Taste16 proposal is mathematically sound as a branch/taste
mass-window witness, but it should not be promoted as the physical C1 release
operator as written.

The decisive issue is simple: the literal proposal places the branch mass on a
taste factor while the kinetic slash acts on the spin factor. Therefore the two
operators commute on tensor-factor grounds. The commutator term needed by the
matrix-valued branch-Wilson square vanishes, so the construction falls back into
the commuting/index-trap regime even though the mass table succeeds.

## What was checked

The new Lean module
`PhysicsSM/Draft/NullEdge/GateC1/ProTaste16Review.lean` records the
machine-checked core:

- `proMass_window`: in the symbolic window `r > 0`, `lam > 0`,
  `0 < m0 < 2 min r lam`, exactly the target sector `(0000,0000)` is negative
  and every other branch/taste sector is positive.
- `BranchTasteMassScanWitness`: a bundled mass-window witness for the literal
  Pro table.
- `proTaste_retainedIndex_ne_zero`: a deliberately mass-level-only retained
  sector marker.
- `taste_only_commutes_spin_only` and `taste_only_commutator_zero`: the literal
  pure-taste lift commutes with any spin-only slash.
- `sigmaZ_sigmaX_commutator_ne_zero`: a minimal toy showing why the next serious
  physical candidate must include spin-mixing, Adams-like structure rather than
  a pure taste spectator term.

## Consequence for candidate ranking

C277 remains the live finite witness because its Wilson mass is non-scalar on
the spin fiber and can potentially produce a nonzero commutator against the
slash. It is less symmetric and less physically elegant, but it is positioned to
escape the trap.

Pro's literal Taste16 proposal remains useful as:

- a clean branch/taste mass-window benchmark;
- a documented negative example showing that mass-table success is not enough;
- a template for a corrected Adams-style spin-taste construction.

## Next physical candidate

The next serious flavored route should not be the literal 16-state pure-taste
operator. It should be a corrected Adams-style spin-taste operator, likely with a
smaller physical taste fiber and a term of the schematic form:

```text
gamma5 tensor xi5
```

The next proof target is not only a mass window. It is a nonzero commutator and
then a true bad-sector gap through the C274 square theorem.

## Updated policy

Use the following lanes:

- Primary live witness: C277 directional-cosine `Fin 4` candidate.
- Negative/benchmark lane: literal Pro Taste16 branch/taste mass table.
- Physical-flavored lane: corrected Adams-style spin-taste mixing candidate.

Do not declare Gate C1 closed until the selected physical-flavored candidate has
a true inverse bad-sector gap, nonzero overlap/GW index, gauge covariance,
locality/quasi-locality, anomaly matching, and Krein/no-ghost audits.
