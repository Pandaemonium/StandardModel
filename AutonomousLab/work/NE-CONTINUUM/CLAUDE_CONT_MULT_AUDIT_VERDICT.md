# Claude-family skeptic audit verdict: CONT-MULT-001

- Reviewer: interactive Claude Code / skeptic, independent of builder Codex.
- Work item: `CONT-MULT-001`.
- Source reviewed: `PhysicsSM/Draft/NullEdge/ExactFlowCellIntegral.lean`.
- Source SHA-256:
  `830F6A58804660F391511BD21E1C3E3ACA1220F84EEA5E4D1A64A6B685ABE59C`.
- Verdict: **ACCEPT_WITH_SCOPE**.

## Findings

1. `exactCellVariationAt` evaluates the exact flow at the continuously varying
   momentum `x`; it is not a sampled-cell surrogate.
2. Continuity and integrability of the cellwise variation field are derived in
   the module rather than supplied as convergence assumptions.
3. `exactCellVariationField_energy_eq` identifies the global integral with the
   disjoint scheduled-cell sum, including the vanishing contribution outside
   the scheduled union.
4. The normalization identity
   `physicalSpacing ^ 3 * cellScale ^ 2 = 1` cancels cell volume in the energy
   estimate. The final bound uses the original componentwise `MemLp` hypotheses.
5. The limit follows from a genuine squeeze between nonnegativity and the
   vanishing squared cell rate. It does not assume the desired multiplier
   convergence.
6. Independent replay with
   `lake build PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral` passed. The three
   local axiom guards report only the kernel-accepted project footprint.

The four over-claim checks pass: the statement is non-vacuous, is not hollow
telescoping, matches the intended continuously varying multiplier integral, and
the module prose does not outrun the kernel statement.

## Permitted scope

For every fixed four-component momentum-space `L2` field satisfying the stated
componentwise hypotheses, the total scheduled-cell integral of the difference
between exact Dirac evolution at the continuously varying momentum and exact
evolution frozen at that cell's center tends to zero under the declared coupled
refinement schedule.

This result closes the intra-cell multiplier-variation gate and composes with
the previously integrated live-walk cell-center theorem in momentum space.

## Boundaries that must remain explicit

- No inverse Fourier reconstruction is proved here.
- No position-space Dirac PDE convergence is proved here.
- No Lorentz-restoration theorem follows from this finite scheduled limit.

Those are successor work items, not prose corollaries of `CONT-MULT-001`.
