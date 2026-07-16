# Phase-covariant operator S2 capstone

Prove all three holes in `PhaseCovariantS2Capstone.lean` without changing any
statement, definition, namespace, or import.

The source already provides the accepted `z = 1` noncommuting qubit capstone
and the explicit phase-gauge conjugation/Gibbs/modular-flow ladder.  Compose
those APIs.  The main technical helper is spectral entropy invariance under the
explicit unitary conjugation; in dimension two it may be proved from trace and
determinant if a general unitary-invariance API is awkward.

Required controls:

- keep `z ≠ 0` wherever division by `norm z` occurs;
- use `betaZ z e = -artanh(e) / norm z`, so the rescaled inverse temperature is
  exactly `-artanh e`;
- prove the normalized-energy identity, not just entropy transport;
- do not call the common single-site phase operational or spatial;
- do not weaken the strict equality condition.

Run `lake env lean
AgentTasks/aristotle-standalone/phase-covariant-s2-capstone-20260713/PhaseCovariantS2Capstone.lean`
before returning.  Report any theorem that is mathematically false rather than
changing it.
