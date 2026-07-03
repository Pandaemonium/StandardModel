# Trust And Scope

This package is a finite-algebra extraction, not a completed physical theory.
The Lean kernel checks every theorem imported by `NullEdgeStandalone.lean`.

## Trusted Core

These modules were trusted in the main repo or are finite algebra identities
with no project-specific external assumptions:

- `PhysicsSM.Spinor.PluckerMass`
- `PhysicsSM.Spinor.TwistorPluckerMass`
- `PhysicsSM.NullStrand.DualSolder.DualSolderSymbolKinetic`
- `PhysicsSM.NullStrand.DualSolder.GradedSuperDiracSquare`
- `PhysicsSM.NullStrand.DualSolder.FiniteKreinDoubled`
- `PhysicsSM.NullStrand.DualSolder.SpectralSchur`

## Draft-Facing But Kernel-Checked

These modules are included because they are central to the null-edge program,
but their physical reading remains draft or conditional:

- `PhysicsSM.Draft.Checkerboard1D`
- `PhysicsSM.Draft.NullEdgeDiracSlashCore`
- `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`
- `PhysicsSM.Draft.NullEdgeFiniteTetradPostulate`
- `PhysicsSM.Draft.NullEdgeSuperDiracMassShellBridge`
- Gate C audit modules under `PhysicsSM.Draft.*`
  including `PhysicsSM.Draft.NullEdgeHyperdiamondBridge`

Draft-facing means the finite statement is checked, while the interpretation may
depend on convention review, additional physics data, or future continuum work.

## Post-Aristotle Triage

Aristotle project `b1558b4a-ab97-4522-a6d5-16f9862dc2b6` evaluated this
standalone package on 2026-07-01. Its recommended load-bearing core is:

- Pluecker mass and massless-iff-collinear theorems;
- graded super-Dirac square and `+ Phi^2` sign guardrail;
- concrete tetrahedral dual-solder frame algebra;
- `PhysicsSM.Draft.NullEdgeActualCliffordSymbol.no_full_symbol_single_chirality`.

The static slash bridge, Krein double, Schur complement, and spectral mass-shell
files are correct finite linear algebra scaffolding. Keep them as utility and
guardrail material, but do not count them as independent physics progress.

The projected/Wilson Gate C release files are frozen audit schemas. In
particular, `ProjData`-style fields are not derived from the actual
`cliffordSymbol`, and bundled release theorems are conditional packaging until
a concrete projected physical operator supplies the data. New work should not
grow the release-clause list unless it proves mutual minimality or connects the
clauses to explicit operator data.

## Non-Claims

This package does not prove:

- a released physical chiral Gate C1 operator;
- continuum convergence of the null-edge Dirac operator;
- positivity, stability, or real spectrum from Krein self-adjointness;
- a numerical Standard Model mass prediction;
- anomaly cancellation or a full physical Hilbert-space construction.

No trusted module in this extraction should contain executable Lean placeholder
or escape-hatch declarations.
