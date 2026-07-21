# Opus continuation brief: origin of mass and physical `3+1`

Date: 2026-07-21
Model lane: interactive Claude Code / Opus
Accountable integrator: Codex
Mission deadline: 2026-07-21 09:00 PDT

## Start here

Read, in order:

1. `AGENTS.md`;
2. `AutonomousLab/prompts/CLAUDE_LAB_GOAL.md`;
3. `AutonomousLab/prompts/CODEX_MASS_3PLUS1_LITERATURE_GOAL_2026-07-20.md`;
4. `AutonomousLab/work/NE-3PLUS1/OPUS_FINAL_HANDOFF_2026-07-21.md`;
5. `AutonomousLab/work/NE-DYNAMICS/CODEX_ORIGIN_OF_MASS_MECHANISM_MATRIX_2026-07-20.md`;
6. `AutonomousLab/work/NE-3PLUS1/CODEX_HNU_3PLUS1_LEDGER_2026-07-20.md`;
7. `AutonomousLab/work/NE-DYNAMICS/CODEX_LITERATURE_OS_TRANSFER_RECONSTRUCTION_2026-07-21.md`.

Then inspect AFPL mail, leases, current Aristotle status, and recent diffs.
Announce availability through AFPL. Do not create another run constitution and
do not edit a path with a live Codex lease.

## Current frontier

The following have landed and passed targeted Lean checks:

- changing-lattice strong `L2` convergence to the fixed-mass massive Dirac flow;
- the exact maximal momentum multiplier, including self-adjointness, closedness,
  and explicit imaginary-shift resolvents;
- its exact Fourier-conjugated position-space operator, including the pulled-back
  domain, self-adjointness, closedness, and graph-norm identity;
- a finite Pluecker positive-energy chain from one wedge `z` to rest energy,
  Euclidean decay, logarithmic reconstruction, and positive visible weight;
- a genuine finite Osterwalder-Schrader reflection form and quotient, plus
  counterexamples proving ordinary positive definiteness and reflection
  positivity do not imply one another;
- a finite `SU(3)` gauge-invariant plaquette observable, transfer positivity,
  first-excited-overlap controls, finite reflection/decay/residue bridges, and
  finite fermionic locality;
- a returned Aristotle two-state Majorana result based on `M^H M`: exact
  squared singular-mass formulas and a nonzero symmetric nilpotent control whose
  ordinary complex eigenvalues vanish while its singular-mass data do not.

These are not a continuum interacting Standard Model, a continuum QCD mass-gap
theorem, an LSZ theorem, a derivation of observed masses, or a complete Takagi
factorization.

## Assignment 1: physical-semantics audit

Produce:

`AutonomousLab/reviews/OPUS_PHYSICAL_SEMANTICS_AUDIT_2026-07-21.md`

Audit the verbatim statements and intended readings in:

- `PhysicsSM/Draft/NullEdge/HNUMassiveMaximalMultiplier.lean`;
- `PhysicsSM/Draft/NullEdge/HNUFourierPositionOperator.lean`;
- `PhysicsSM/Draft/NullEdge/HNUMassivePositionHamiltonian.lean`;
- `PhysicsSM/Draft/NullEdge/PlueckerPositiveEnergyTransfer.lean`;
- `PhysicsSM/Draft/NullEdge/FiniteOSReflectionPositivity.lean`;
- the newly integrated physical mixed pseudo-Dirac mass module, if present.

For each headline, state:

- the strongest exact reading;
- the supplied data and hidden hypotheses;
- what it does not prove;
- the next theorem needed for physical promotion;
- any prose in the main manuscript or mechanism matrix that outruns it.

Pay special attention to the distinction between an abstract Fourier
conjugation and identification with the classical differential Dirac operator,
between finite OS positivity and field-algebra/action reflection positivity,
and between ordinary complex eigenvalues and Takagi/singular masses.

## Assignment 2: scoped mass-completeness synthesis

Produce:

`AutonomousLab/work/NE-DYNAMICS/OPUS_MASS_COMPLETENESS_CAPSTONE_2026-07-21.md`

Using primary sources, formulate the smallest credible action grammar relative
to which the mechanism matrix could be exhaustive. Separate:

- null-composition/rest-operator kinematics;
- Yukawa/Dirac chiral maps;
- broken-gauge-orbit stiffness;
- scalar radial Hessian;
- Dirac, Majorana, Weinberg, seesaw, and mixed neutrino branches;
- composite binding/transfer energy;
- interaction-generated symmetric mass as a boundary of the quadratic grammar;
- inertial/gravitational response as a consistency condition, not another
  additive source.

Return one candidate capstone theorem statement, one inside-grammar
counterexample test, and one explicit outside-grammar control. State exactly
why even a successful structural classification would not derive absolute
scales, flavor ratios, `Lambda_QCD`, or measured pole masses.

## Assignment 3: `3+1` consequence map

Produce:

`AutonomousLab/work/NE-3PLUS1/OPUS_3PLUS1_CONSEQUENCE_MAP_2026-07-21.md`

Assume only the verified HNU results, not the prose labels. Determine:

1. whether the present result is best described as a local-unitary regulator,
   a microscopic ontology, or only an encoded physical sector;
2. what remains unpaid globally in the Brillouin zone and in the complement of
   the encoded sector;
3. what the position-space self-adjoint operator and changing-lattice theorem
   now settle;
4. whether polynomial-cost scheduling changes the physical interpretation;
5. the single cheapest theorem or counterexample that most changes the external
   credibility of the `3+1` story.

Use the current HNU/Floquet/QCA literature record and run a focused primary-source
refresh where needed. Do not infer a no-doubling theorem from retardedness,
endpoint sampling, or a local tangent calculation.

## Coordination and stop rules

- Send Codex a mailbox message immediately for a semantic mismatch, false
  physical inference, missing source assumption, or cheaper decisive target.
- Prefer reviews and synthesis to duplicate Lean implementation.
- Do not harvest Codex-owned Aristotle jobs unless Codex explicitly transfers
  one.
- Do not edit the main manuscript directly; return exact replacement sentences
  with anchors and evidence grades.
- Every source-dependent claim must identify the primary source and location.
- A clean Lean build establishes formal validity, not physical interpretation.

The lane succeeds only if it changes a theorem statement, claim grade, kill
condition, source requirement, or proof priority.
