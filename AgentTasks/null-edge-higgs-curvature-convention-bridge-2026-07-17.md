# Null-edge Higgs curvature convention bridge

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: implemented

## Objective

Make the curvature sign and normalization translation explicit when a supplied
retarded scalar operator already has continuum convention
`B_beta -> Box - beta R`. Distinguish the operator's built-in coefficient from
an added curvature counterterm and from the resulting physical coupling.

## Result

`PhysicsSM/Draft/NullEdge/HiggsCurvatureConventionBridge.lean` proves:

- `physicalXi = operatorBeta + countertermXi`;
- a target `xi` requires counterterm `xi - operatorBeta`;
- for the four-dimensional Benincasa--Dowker value `operatorBeta = 1/2`, no
  counterterm gives `xi = 1/2`, minimal coupling requires `-1/2`, and conformal
  coupling `1/6` requires `-1/3`; and
- the built-in/counterterm split is globally unidentifiable from finite scalar
  propagation because a nonzero affine trade preserves every curvature
  profile, insertion matrix, and retarded series.

Claim grade: `M [orig/comp]` for the finite algebra and `T|H [import]` for its
continuum reading.

## Scope boundary

The continuum convention is supplied. The result does not prove convergence
of the present null-edge kernel to the Benincasa--Dowker operator, derive graph
curvature, select a physical `xi`, or predict a Higgs mass.

## Provenance

The value `operatorBeta = 1/2` is motivated by D. M. T. Benincasa and F. Dowker,
"The Scalar Curvature of a Causal Set," arXiv:1001.2725. No source
implementation or proof text was copied.

## Verification

- Production SHA-256:
  `EAD5856024259C075D5C9F478B935718245623937995C247108E88BEA6A0CABB`
- `lake env lean PhysicsSM/Draft/NullEdge/HiggsCurvatureConventionBridge.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge`
  (8,027 jobs)
- Lean LSP error diagnostics: empty
- `lean_verify` on `benincasaDowker_conformal_counterterm` and
  `curvatureSplit_nontrivial_propagator_degeneracy`: standard three axioms, no
  source warnings

There are no proof holes or linter warnings. An initial targeted build shell
timed out while compilation was still running; the repeated command completed
successfully.
