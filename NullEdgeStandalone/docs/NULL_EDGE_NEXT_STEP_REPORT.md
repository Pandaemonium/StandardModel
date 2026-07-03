# Null-Edge Next-Step Job Report

Date: 2026-07-01

Source Aristotle project:
`f88a6a21-d397-4880-961f-eeb4b3f5a918`, task
`4dccd792-6cfc-4a25-8ae7-3695fc1def54`.

## Commands Reported By Aristotle

- `lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean` passed.
- `lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean`
  passed.
- `lake build NullEdgeStandalone` passed.

Aristotle reported that all new theorems were assumption-audited against only the
standard kernel background used elsewhere in the package, and that no proof
placeholders were present in the edited files.

## Integrated Checkerboard Results

The checkerboard proof-library cleanup added:

- `runCount_eq_zero_of_lt`;
- `runCount_one_part`;
- `runCount_self`;
- `spacetimeEndpointTurnClassCount_eq_zero_of_right_gt_length`;
- `spacetimeEndpointTurnClassCount_eq_zero_of_left_gt_length`;
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_velocity`;
- small direct-count examples
  `spacetimeEndpointTurnClassCount_example_len0`,
  `spacetimeEndpointTurnClassCount_example_len1`,
  `spacetimeEndpointTurnClassCount_example_len2`,
  `spacetimeEndpointTurnClassCount_example_len2_zero`,
  `spacetimeEndpointTurnClassCount_example_len3`;
- closed-form cross-check
  `spacetimeEndpointTurnClassCount_example_len3_closed_form`.

Codex local follow-up after integration added:

- `checkerStep_pow_apply_isotropic_velocityEndpoint`;
- `checkerStep_pow_apply_isotropic_spacetimeEndpoint`.
- `spacetimeEndpointTurnClassClosedForm`;
- `spacetimeEndpointTurnClassCount_eq_closedForm`;
- `checkerStep_pow_apply_isotropic_spacetimeClosedForm`.
- `isotropicGenerator` and its exact finite decomposition theorems in
  `CheckerboardContinuumScaffold`.

These theorems recover the finite isotropic checkerboard propagator entrywise as
a generating function over turn classes, first at the velocity endpoint level and
then through the refined spacetime endpoint counts and their packaged
binomial-product closed form.

These are finite combinatorial checks. The examples evaluate the real
`Fintype.card` count with kernel `decide`; they are not continuum claims.

## Integrated Hyperdiamond Result

The hyperdiamond/operator scaffold added:

- `BoriciCreutzConventionData.RequiresFifthVector`;
- `BoriciCreutzConventionData.fullFirstOrderSymbol`;
- `HyperdiamondFirstOrderStencil.linearSymbol_zero`;
- `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`.

This is an honest truncation mismatch: if the fifth-vector coefficient is
nonzero, the full first-order symbol differs from the nearest-neighbor symbol.
It does not claim a named Borici-Creutz equivalence or refute a specific source
operator.

## Ranked Next Lean Targets

1. Reconstruction target: fill `BoriciCreutzConventionData` from one fixed
   source and basis, then settle the nearest-neighbor Gate C crosswalk as a
   concrete matrix identity.
2. No-go theorem: strengthen the fifth-vector truncation mismatch into a
   theorem that no four-edge nearest-neighbor stencil realizes the required
   pole or excitation structure.
3. Finite consistency check / analytic scaffold: prove
   `HasDerivAt isotropicStep isotropicGenerator 0` and related
   unitary-generator expansion facts.
4. Analytic scaffold: state the continuum scaling limit connecting
   `isotropicStep_pow_eq` to Dirac evolution as a limit theorem for later
   analysis.
5. Physical non-claim: keep `ProjectorPhysicalAudit` frozen until a concrete
   operator supplies locality, gauge covariance, Krein compatibility, and
   operator-derived branch data.
