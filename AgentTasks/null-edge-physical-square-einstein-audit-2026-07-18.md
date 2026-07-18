# Null-edge physical square Einstein audit

Date: 2026-07-18
Status: implemented and verified

## Objective

Test the exact proper eta-Lorentz periodic-square refinement against both
Euler sectors of the nonlinear Palatini action. Determine whether it can be a
nonflat stationary vacuum witness or isolate the obstruction precisely.

## Landed theorem chain

1. `squareIdentityMixedVacuum_iff` classifies the mixed vacuum Einstein
   equation for the square target at the identity coframe. Components `0`,
   `1`, `3`, `4`, and `5` must vanish; component `2` is unconstrained.
2. `complementaryRotationTarget_not_pairExchange` proves that the remaining
   internal `23` mode on the spacetime `01` face violates curvature pair
   exchange when nonzero.
3. `complementaryRotation_linkEulerCoefficient` evaluates one exact nonlinear
   local link Euler coefficient as a four-entry polynomial in the exponential
   transport and its inverse.
4. `normalized_rotationEulerObstruction_tendsto` proves that this coefficient,
   divided by plaquette area, converges to twice the remaining amplitude.
5. `complementaryRotation_eventually_not_connectionStationary` converts that
   nonzero limit into eventual failure of exact link stationarity.
6. `nonzero_squareTarget_not_jointStationary_identityCoframe` combines the
   coframe and link equations: no nonzero target can be jointly stationary at
   every shrinking level while the coframe is held at the identity.

## Claim boundary

This is a conditional asymptotic no-go for one explicit static ansatz. It does
not rule out nonflat null-edge gravity. It shows that the successful branch
must use a varying coframe and a richer curvature pattern. Pair exchange is
audited but not derived from a discrete Levi-Civita theorem.

The physical square remains useful as a nonzero proper eta-Lorentz curvature
refinement and as a regression fixture for the action-visible continuum
interface. It is not a stationary vacuum solution.

## Provenance

The coefficient layout was checked with a local symbolic matrix calculation.
The live result is proved from the repository definitions and checked by the
Lean kernel. The mixed Einstein and Lorentz-exponential infrastructure is
project-local; the underlying Palatini and Lorentz exponential identities are
standard.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/PhysicalLorentzPlaquetteEinsteinAudit.lean`
  passed without warnings.
- `lake build PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit`
  passed: 8,081 jobs.
- `lake build PhysicsSM.Draft.NullEdge.GRFoundations` passed: 8,136 jobs.
- Strict draft token scan passed for the new module and facade.
- `pre-commit run --all-files` and `git diff --check` passed.
- Full `lake build` passed: 8,319 jobs.

## Next gate

Construct the smallest varying-coframe periodic refinement whose limiting
curvature has Riemann pair symmetry, then evaluate both exact Euler sectors.
The preferred target is a multi-face vacuum-Weyl pattern rather than a single
plaquette component.
