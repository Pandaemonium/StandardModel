# Aristotle prompt: null-edge next wave after checkerboard/operator scaffold

You are working in a focused standalone Lean package extracted from
`C:\Projects\StandardModel\NullEdgeStandalone`.

## Project context

This package formalizes the finite null-edge spine of the `PhysicsSM`
NullStrand program. The current claim boundaries are:

- 1+1D checkerboard dynamics are a finite dynamical seed, not yet a continuum
  Dirac-limit theorem.
- 3+1D hyperdiamond/Gate C currently has a bare-symbol chirality no-go and an
  exact frame/covector/symbol-square bridge, but no named physical
  finite-difference operator.
- Gate C release predicates remain frozen until concrete operator data supply
  locality, gauge covariance, Krein compatibility, projected branch data, and
  anomaly/index transport.

## New Codex setup before this submission

Codex integrated the completed checkerboard continuum-next Aristotle result:

- `PhysicsSM.Draft.CheckerboardContinuumNext`
  - `turnCountVec_mod_two_eq_endpoint`
  - `endpoint_eq_iff_turnCountVec_even`
  - `velocityEndpointTurnClassCount_eq_choose`
  - `isotropicStep_mul`
  - `isotropicStep_pow_eq`

Codex also added two new scaffold modules:

- `PhysicsSM.Draft.CheckerboardSpacetimeCounts`
  - `spacetimeEndpointTurnClassCount`
  - zero theorem for impossible `r + l`
  - zero theorem for endpoint/turn parity mismatch
  - zero theorem for turn count greater than path length

- `PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold`
  - `HyperdiamondFirstOrderStencil`
  - `fourierSymbol`, `linearSymbol`
  - `GateCPrincipalCrosswalk`
  - `crosswalk_linearSymbol_sq`
  - `crosswalk_branch_kernel_balanced`
  - `crosswalk_no_single_chirality`
  - `ProjectorAlgebraicAudit`, `chiralProj_algebraicAudit`
  - `ProjectorPhysicalAudit` obligation schema

The package builds locally with:

```powershell
lake build NullEdgeStandalone
```

## Your tasks

Please do as much Lean as possible, without weakening statements or making
physical release claims.

### Task 1: checkerboard spacetime endpoint closed forms

Work in or near:

```text
PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
```

Target the refined count:

```lean
spacetimeEndpointTurnClassCount n r l k inc out
```

This fixes total length, initial/final velocity, outgoing right/left edge
counts, and exact turn count.

Prove the strongest clean finite closed forms you can. The ideal result is the
Earle/Jacobson-Schulman binomial-product formula obtained by decomposing paths
into alternating right/left runs, with boundary cases for `r = 0`, `l = 0`, and
`n = 0` handled explicitly.

If the fully general theorem is too large, prioritize this order:

1. diagonal endpoint cases `inc = out` with even turn count;
2. off-diagonal endpoint cases `inc != out` with odd turn count;
3. boundary cases `r = 0` or `l = 0`;
4. a marginalization theorem showing the refined count sums back to
   `velocityEndpointTurnClassCount`.

You may add helper definitions for runs/compositions if useful. Keep all
theorems finite and kernel-checked.

### Task 2: hyperdiamond operator crosswalk or mismatch

Work in or near:

```text
PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
```

Use the new `HyperdiamondFirstOrderStencil` API to push toward the exact
operator-level crosswalk target.

Please either:

1. instantiate a concrete first-order stencil whose `linearSymbol` proves
   `GateCPrincipalCrosswalk`, or
2. prove a precise mismatch theorem showing why the current four-edge stencil
   API cannot represent the intended Borici-Creutz/hyperdiamond convention
   without extra phases, a fifth vector, a shifted onsite term, a different
   basis, or another named datum.

Do not claim Borici-Creutz equivalence unless the signs, phases, normalization,
and basis order are explicit.

### Task 3: physical projector audit next steps

Use the new `ProjectorPhysicalAudit` schema to recommend the next Lean
definitions that would turn locality, gauge covariance, Krein compatibility,
and operator-derived branch data from free proposition fields into concrete
predicates attached to a position-space operator.

Add Lean only if it is clean and useful. Otherwise write a concise report.

### Task 4: ranked next-step recommendation

Finish with a report answering:

1. What are the most important next pieces after your work?
2. Which should be handled by Lean proof work versus literature/convention
   review?
3. Which theorem is the best next Aristotle job?
4. Are there any statements in the current package whose intended physics
   reading is stronger than the Lean theorem actually proves?

## Verification requirements

Run at least:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
lake build NullEdgeStandalone
```

Before finalizing, scan changed Lean files for placeholder/escape-hatch tokens
and report the result. Do not introduce new trusted placeholders, fake
assumptions, or unreviewed physical release claims.

## Requested output

Return:

- modified Lean files, if any;
- a Markdown report, preferably
  `AgentTasks/NULL_EDGE_NEXT_WAVE_AFTER_SCAFFOLD_REPORT.md`;
- exact verification commands and outcomes;
- a clear statement of any unproved targets and why they remain hard.
