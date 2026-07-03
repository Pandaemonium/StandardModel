# Checkerboard Continuum-Next Report

Date: 2026-07-01

Source Aristotle project:
`d063b327-2800-413e-b7bb-4a49aff33ec0`, task
`5ca2110b-8fc7-438e-984a-054299ecdb6d`.

Integrated module:
`PhysicsSM.Draft.CheckerboardContinuumNext`.

## Integrated Lean facts

The following finite identities are now in the standalone package:

- `turnCountVec_mod_two_eq_endpoint`: turn-count parity is exactly the endpoint
  velocity-change indicator.
- `endpoint_eq_iff_turnCountVec_even`: equal endpoint velocities are equivalent
  to even turn count.
- `velocityEndpointTurnClassCount_eq_choose`: fixed initial/final velocity and
  exact turn count have count `Nat.choose n k` when parity matches, and zero
  otherwise.
- `isotropicStep_mul`: the unitary isotropic checkerboard step obeys the
  one-parameter group law.
- `isotropicStep_pow_eq`: powers of the unitary isotropic step add the angle.
- `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`: powers of the
  isotropic step equal the identity plus the scaled generator plus the packaged
  first-order remainder at angle `n * theta`.

These are finite identities. They do not assert a continuum Dirac limit.

## Convention audit

The current endpoint convention is internally consistent but deliberately
coarser than the Earle/Jacobson-Schulman spacetime-endpoint convention.

`velocityEndpointTurnClassCount` fixes:

- total path length,
- initial velocity,
- final velocity,
- total turn count.

It does not fix displacement. Therefore the closed form is the single binomial
`Nat.choose n k`, summing over all right/left step-count splittings compatible
with those data.

The scaffold already has the missing refinement data:

- `outgoingRightCount`,
- `outgoingLeftCount`,
- `outgoingDisplacement`.

The next checkerboard theorem should add these as constraints and prove the
binomial-product formulas used in the spacetime endpoint literature.

`PhysicsSM.Draft.CheckerboardSpacetimeCounts` now adds the refined count
`spacetimeEndpointTurnClassCount` and proves the endpoint-count layer:

- right/left outgoing-edge counts must add to the path length;
- turn-count parity must match endpoint velocity parity;
- turn count cannot exceed the number of edge slots.
- boundary closed forms for length zero, no-left-edge, and no-right-edge paths;
- marginalization back to `velocityEndpointTurnClassCount`;
- `runCount`, the positive-composition count used in the closed form;
- `spacetimeEndpointTurnClassCount_eq`, the full
  Earle/Jacobson-Schulman binomial-product formula;
- `spacetimeEndpointTurnClassCount_eq_of_right_le_length`, the common
  marginalization specialization with `l = n - r`;
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`, the direct
  consistency corollary saying that summing the explicit closed form over
  right/left splits recovers the coarser binomial endpoint count.
- `spacetimeEndpointTurnClassCount_closed_form_sum_eq_velocity`, the direct
  closed-form marginalization to `velocityEndpointTurnClassCount`.
- small direct-count examples through path length `3`, plus reusable `runCount`
  and over-count vanishing lemmas.
- `checkerStep_pow_apply_isotropic_velocityEndpoint`, the entrywise finite
  propagator as a generating function over velocity endpoint turn classes.
- `checkerStep_pow_apply_isotropic_spacetimeEndpoint`, the same entrywise
  propagator recovered by summing refined spacetime endpoint counts over
  right-edge splits and turn classes.
- `spacetimeEndpointTurnClassClosedForm` and
  `checkerStep_pow_apply_isotropic_spacetimeClosedForm`, the packaged
  binomial-product closed-form propagator formula.
- `isotropicGenerator`, `isotropicGenerator_sq`,
  `isotropicStep_eq_cos_smul_one_add_sin_smul_generator`, and
  `isotropicStep_eq_one_add_sin_generator_add_cos_remainder`, the exact finite
  generator setup for the next derivative/asymptotic theorem.
- `isotropicStepFirstOrderRemainder` and
  `isotropicStep_eq_one_add_theta_generator_add_remainder`, the exact
  zero-angle first-order expansion with the scalar sine/cosine remainders
  separated.
- `isotropicStepFirstOrderRemainder_hasDerivAt_zero`, the finite
  zero-derivative check for the packaged first-order remainder.
- `sin_sub_id_div_tendsto_zero`, `cos_sub_one_div_tendsto_zero`,
  `sin_sub_id_isLittleO`, `cos_sub_one_isLittleO`, and
  `isotropicStepFirstOrderRemainder_div_tendsto_zero`, the scalar and entrywise
  quotient/asymptotic estimates for the packaged first-order remainder.
- `isotropicStep_hasDerivAt_zero`, the finite-dimensional real derivative
  statement identifying `isotropicGenerator` as the zero-angle generator.
- `hasDerivAt_isotropicStep`, the arbitrary-angle derivative formula
  `-sin(theta) * 1 + cos(theta) * isotropicGenerator`, integrated from the
  generator-expansion Aristotle job.
- `isotropicGenerator_commutes_isotropicStep`, the finite commutation identity
  between the generator and each unitary isotropic step.

## Next finite theorem

Define a refined count, morally:

```lean
spacetimeEndpointTurnClassCount n r l k inc out
```

This count, its closed form, the basic closed-form marginal consistency
corollaries, a small normalization/example library, the entrywise
generating-function bridge, and the packaged closed-form propagator formula now
exist in Lean. The derivative part of the unitary-generator target also now
exists in Lean. The next target is a quantitative first-order or product
estimate that prepares a later analytic Dirac-limit statement.

This is the next best finite Aristotle target because it is still pure
combinatorics and it settles the dictionary between the standalone convention
and the Earle/Jacobson-Schulman endpoint-count convention.

## Analytic boundary

The natural analytic successor is a momentum-space per-mode limit:

```text
(stepMatrix p N) ^ steps(N) -> exp(-i T H(p))
```

in a finite-dimensional matrix norm, with the checkerboard angle scaled by the
mass. A full `L2` field convergence theorem should wait until the finite
endpoint formulas and a quantitative matrix-exponential/Trotter estimate are in
place.
