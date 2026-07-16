# Aristotle strategy job: continuum F2/F3 Fourier-to-PDE completion

## Context

The AFPL continuum chain now has kernel-checked changing-cell projection,
coefficient, exact multiplier, and inverse-Fourier norm convergence. The new
F1 capstone is `PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean`, ending in
`positionErrorLp_norm_tendsto_zero`. It deliberately does not identify the
position-space limit as a solution of the Dirac PDE or prove a generator-domain
statement.

## Task

Act as Aristotle Visionary plus proof architect. Read the complete relevant
Lean modules, Mathlib Fourier/Schwartz/Sobolev APIs, and the AFPL continuum work
item. Design the strongest honest F2/F3 theorem ladder that closes the actual
position-space Dirac-flow claim.

Required output:

1. Exact typechecking Lean theorem statements for:
   - inverse Fourier transport of the exact momentum multiplier flow;
   - the spatial derivative / momentum multiplication correspondence with all
     constants and Fourier conventions explicit;
   - strong continuity and the generator identity on a stated dense domain;
   - the final PDE solution statement and uniqueness scope.
2. The shortest proof dependency graph using declarations that exist in Lean
   4.28 Mathlib. Name every critical declaration and import.
3. A representative-safety audit: distinguish `MemLp` representatives from
   `Lp` classes and do not evaluate an `Lp` class pointwise.
4. A convention audit for sign, `2*pi`, Euclidean-space measure, and spinor
   norm.
5. A prove-or-kill verdict. If the required Fourier derivative API is absent,
   isolate the smallest clean-room lemma rather than inventing an assumption.

Do not edit the landed F1 theorem or weaken the PDE claim to mere norm
preservation. Write `AFPL_CONT_F2_F3_STRATEGY.md` in the returned project.

## Primary files

- `PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean`
- `PhysicsSM/Draft/NullEdge/ChangingCellScaledLiveWalk.lean`
- `PhysicsSM/Draft/NullEdge/ExactFlowCellIntegral.lean`
- `PhysicsSM/Draft/NullEdge/Compact3Plus1DiracRate.lean`
- `AutonomousLab/work/NE-CONTINUUM/CODEX_CONT-FOURIER-001_REVIEW_PACKET_2026-07-12.md`

## Success and kill conditions

Success means exact theorem shapes and a declaration-level route, not generic
advice. Kill means a precise missing API or false normalization claim, with the
minimal replacement theorem stated.

## Submission metadata

- Aristotle project: `5d4f2be5-f731-40ea-9dee-d5716b20be69`
- Submitted: 2026-07-12 by Codex
- Lab work item: `CONT-FOURIER-001`
