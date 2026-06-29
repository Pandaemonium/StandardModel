Project name: gate-c1-determinant-ghost-certificate-c182

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C171R keeps determinant-line control and ghost-zero exclusion as first-class certificate fields. C178 formalizes that propagator-zero removal cannot replace a true inverse-propagator gap. Gate C1 must not remove a gauge-charged mirror by a propagator zero.

Task:
Develop a sharper determinant-line and ghost-zero certificate package for the C159 import theorem.

Requested results:
1. Define `TrueInverseGap` for the bad sector and prove it excludes zero modes/poles in the relevant finite spectral model.
2. Define `PropagatorZeroMirrorRemoval` and prove it does not imply `TrueInverseGap`.
3. Define a determinant-line control certificate suitable for a reference-homotopy import: trivial determinant winding or transported determinant-line class plus no crossing.
4. State how anomaly/index import, determinant line, and ghost-zero exclusion interact but remain logically independent.
5. Give Lean-ready theorem/API statements and a concise physical audit checklist.

If possible, provide a standalone finite formalization of the inverse-gap vs propagator-zero distinction.

Do not assert full quantum measure construction unless it is an explicit certificate/hypothesis.
