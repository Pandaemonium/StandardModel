# Null-edge checkerboard/Borici-Creutz next-step Lean job

You are working in a standalone Lean 4 package, `NullEdgeStandalone`, extracted
from the `PhysicsSM` null-edge program. The Lean kernel is the source of truth:
do not weaken theorem statements to get proofs through, and do not claim a named
physics equivalence unless the convention data is explicit.

## Build commands

Run the narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
```

If those pass, run:

```powershell
lake build NullEdgeStandalone
```

## Current verified state

The checkerboard endpoint layer now has:

- `spacetimeEndpointTurnClassCount`;
- zero/impossibility theorems for right/left totals, parity mismatch, and too
  many turns;
- boundary cases `spacetimeEndpointTurnClassCount_length_zero`,
  `spacetimeEndpointTurnClassCount_left_zero`, and
  `spacetimeEndpointTurnClassCount_right_zero`;
- `spacetimeEndpointTurnClassCount_sum_eq_velocity`;
- `runCount` and its basic closed forms;
- the Earle/Jacobson-Schulman closed form
  `spacetimeEndpointTurnClassCount_eq`;
- `spacetimeEndpointTurnClassCount_eq_of_right_le_length`;
- `spacetimeEndpointTurnClassCount_sum_eq_choose`;
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`.

The hyperdiamond/operator layer now has:

- `HyperdiamondFirstOrderStencil`;
- `GateCPrincipalCrosswalk`;
- inherited square/kernel/no-go theorems for any crosswalk;
- concrete `gateCStencil`, `gateCStencil_crosswalk`,
  `gateCStencil_no_single_chirality`;
- `BoriciCreutzConventionData`;
- `BoriciCreutzNearestPrincipalCrosswalk`;
- `boriciCreutzNearest_no_single_chirality`;
- `ProjectorPhysicalAudit` as a schema over explicit physical predicates.

## Literature context

Use the included literature review:

```text
NullEdgeStandalone/docs/HYPERDIAMOND_BORICI_CREUTZ_LITERATURE_REVIEW.md
```

Main sources recorded there:

- Creutz, *Four-dimensional graphene and chiral fermions*, arXiv:0712.1201.
- Borici, *Creutz fermions on an orthogonal lattice*, arXiv:0712.4401.
- Bedaque, Buchoff, Tiburzi, Walker-Loud, *Search for Fermion Actions on
  Hyperdiamond Lattices*, arXiv:0804.1145.
- Kimura and Misumi, *Characters of Lattice Fermions Based on the Hyperdiamond
  Lattice*, arXiv:0907.1371.
- Kimura and Misumi, *Lattice Fermions Based on Higher-Dimensional Hyperdiamond
  Lattices*, arXiv:0907.3774.
- Creutz and Misumi, *Classification of Minimally Doubled Fermions*,
  arXiv:1007.3328.
- Kishore, *Eigenspectra of Minimally Doubled Fermions*, arXiv:2501.10336.
- Earle, *Notes on The Feynman Checkerboard Problem*, arXiv:1012.1564.

Key caution: `gateCStencil` is the Gate C principal symbol repackaged as a
four-edge first-order stencil. It is not a Borici-Creutz equivalence. The
literature suggests signs, phases, normalization, fifth-vector/shifted onsite
terms, pole locations, and modified/flavored chirality data matter.

## Requested work, ranked

1. Checkerboard proof-library cleanup.

   Add any useful small kernel-checked lemmas around `runCount` and
   `spacetimeEndpointTurnClassCount_eq` that make the closed-form theorem easier
   to audit. High-value examples:

   - zero when the number of positive parts exceeds the total;
   - one-part and all-one-parts special cases;
   - right/left count too large implies zero;
   - a theorem rewriting the explicit closed-form marginal sum to
     `velocityEndpointTurnClassCount` rather than directly to `Nat.choose`;
   - small checked examples for path lengths `0`, `1`, `2`, or `3`, using
     kernel proofs, not evaluator-trust shortcuts.

   Please keep these as ordinary Lean theorems in:

   ```text
   PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
   ```

2. Borici-Creutz convention instantiation or precise mismatch.

   If you can confidently instantiate a source convention into
   `BoriciCreutzConventionData`, do so and prove one of:

   ```lean
   BoriciCreutzNearestPrincipalCrosswalk data
   ```

   or a precise mismatch theorem explaining the failed sign/phase/basis or
   normalization match.

   If the included package lacks enough source data to instantiate the operator
   honestly, do not fake it. Instead, improve the Lean scaffold with additional
   convention fields or predicates that make the missing data explicit, and add
   a short report saying exactly what source equations/conventions are needed
   next.

3. Best next steps.

   At the end, include a ranked list of the most important next Lean targets for
   the null-edge program from the current state. Please distinguish:

   - finite identity;
   - no-go theorem;
   - reconstruction target;
   - analytic scaffold;
   - physical non-claim.

## Constraints

- Do not introduce new assumptions or fake placeholders in trusted-looking code.
- Keep draft code honest: if a proof cannot be closed, leave the theorem out or
  put the failed plan in a task report rather than weakening it.
- Preserve the distinction between the null-edge difference direction and the
  dual covector/Clifford soldering direction.
- Do not revive the diagonal null operator as the continuum Dirac-symbol
  operator.
- Keep spacetime chirality, internal grading, and cochain/form degree separate.

## Desired output

Return:

1. the modified Lean/docs files;
2. exact commands run and whether they passed;
3. a short semantic review of any new theorem statements;
4. a ranked next-step list.
