# Null-Edge Next Wave After Scaffold Report

Date: 2026-07-01

Aristotle project:
`ecbd6315-d0c4-40a1-b1e0-feebcb8f843b`.

Completed task:
`105c1626-9698-4a44-bc90-c0778d8143e4`.

## Integrated Lean Results

Checkerboard spacetime counts:

- `spacetimeEndpointTurnClassCount_length_zero`
- `spacetimeEndpointTurnClassCount_left_zero`
- `spacetimeEndpointTurnClassCount_right_zero`
- `spacetimeEndpointTurnClassCount_sum_eq_velocity`
- `runCount`
- `runCount_zero_parts`
- `runCount_zero_of_pos_parts`
- `runCount_succ_succ`
- `spacetimeEndpointTurnClassCount_eq`
- `spacetimeEndpointTurnClassCount_eq_of_right_le_length`
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_velocity`
- `runCount_eq_zero_of_lt`, `runCount_one_part`, `runCount_self`
- small direct-count examples through path length `3`
- `checkerStep_pow_apply_isotropic_velocityEndpoint`
- `checkerStep_pow_apply_isotropic_spacetimeEndpoint`
- `checkerStep_pow_apply_isotropic_spacetimeClosedForm`
- `isotropicGenerator` and exact finite generator decomposition theorems

Hyperdiamond operator scaffold:

- `gateCStencil`
- `gateCStencil_crosswalk`
- `gateCStencil_no_single_chirality`
- `BoriciCreutzConventionData`
- `BoriciCreutzNearestPrincipalCrosswalk`
- `boriciCreutzNearest_no_single_chirality`
- `BoriciCreutzConventionData.fullFirstOrderSymbol`
- `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`

## Interpretation

The checkerboard endpoint-count layer is now a genuine finite combinatorics
result: the refined spacetime endpoint count has a binomial-product closed form
through `runCount`, it marginalizes back to the coarser velocity endpoint count,
and the explicit closed form itself sums back to the coarser binomial count.

The hyperdiamond addition is more modest. `gateCStencil` packages the existing
Gate C Clifford symbol as a first-order stencil and proves the exact
principal-symbol crosswalk. `BoriciCreutzConventionData` provides a Lean landing
zone for the named-operator convention review. This is useful reconstruction
scaffolding, but it is not a Borici-Creutz equivalence and does not construct a
physical projected operator.

## Ranked Next Steps

1. Prove `HasDerivAt isotropicStep isotropicGenerator 0` and related
   unitary-generator expansion facts preparing the analytic Dirac-limit
   statement.
2. Fill `BoriciCreutzConventionData` from one fixed source and basis, or prove a
   stronger no-four-edge pole/excitation no-go once source pole predicates are
   represented.
3. Replace the free fields in `ProjectorPhysicalAudit` with concrete predicates
   for position-space locality, gauge covariance, Krein compatibility, and
   operator-derived branch data.
4. Keep the checkerboard continuum Dirac limit as an analytic scaffold until
   the matrix-exponential/Trotter and interpolation infrastructure is explicit.

## Physics-Reading Cautions

- `coefficientSupport_card_le_four` is finite support bookkeeping for a
  `Fin 4 -> CMat4` coefficient family, not a position-space locality theorem.
- `gateCStencil_crosswalk` is not a Borici-Creutz equivalence.
- `crosswalk_no_single_chirality` is a bare principal-symbol no-go.
- `ProjectorPhysicalAudit` is still a schema over free propositions.
