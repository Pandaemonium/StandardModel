# Claude adversarial review packet: cycle 16 C102/C104 Gate C pair

Date: 2026-06-27

## Project context

This repository formalizes mathematical structures for Standard Model physics in
Lean 4. The null-edge program separates:

- Gate C0: external species health / gap control.
- Gate C1: physical chiral release.
- Gate H: internal finite Dirac legality and anomaly/spectrum constraints.
- Gate F: prediction/codimension, with absence theorems preferred over mass
  magnitudes.

Recent status:

- C100 added a branch-locus / physical-sector API separating C0 scalar lifting,
  projected one-line kernel, chirality, Krein positivity, true inverse-propagator
  gap, and ghost safety.
- C103 added a scalar-on-origin no-go and was patched after review with the
  D0-aware theorem `deformed_scalar_on_origin_never_selects_weyl_line`.
- C105 report now recommends proving an overlap mass-window dichotomy before any
  Route-B projected-overlap release assembly.

## Artifacts under review

Primary Lean artifacts:

```text
PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean
PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean
```

Related API context:

```text
PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean
```

## Intended reading

C102 is intended as a conditional hazard theorem:

```text
If a bare zero branch satisfies D(q)v = 0 and crosses the shifted Wilson shell
r W(q) = rho, then the direct raw overlap shifted kernel X_rho has a nonzero
kernel vector and the sign kernel is singular. Therefore raw unprojected overlap
on full D_+ requires a mass-window theorem before use as a C1 route.
```

C104 is intended as an algebraic branch-classifier API:

```text
T_br^2 = 1, Pi_br = (1 + T_br)/2, non-scalar on the balanced origin kernel,
separates retained/mirror branch germs, and is gauge-neutral relative to a gauge
set. It is not a release: locality, physical gauge covariance, Krein positivity,
ghost safety, anomaly, and nonzero index are outside the structure.
```

## Review questions

1. Does C102's Lean statement actually support the intended mass-window hazard,
   or is `direct_overlap_requires_mass_window` too strong / too weak / too
   abstract to use as a Gate C guardrail?
2. Does C104 correctly separate an algebraic `T_br` classifier from a physical
   release, or do any names/docstrings overclaim?
3. Are there theorem or proof fragility issues in C104, especially around
   `PiBr_isProjector_of_involution`, gauge neutrality, or
   `separatesGerms_involution_labels_pm`?
4. Does the pair C102+C104 justify prioritizing projected-overlap/branch
   classifier work over raw-overlap Route A, or is another theorem needed first?
5. What exact next Aristotle target should follow if C101 remains running and
   C92/C93/C89 are still not returned?

## Requested output

Please answer with:

- findings ordered by severity;
- semantic-alignment verdict for C102;
- semantic-alignment verdict for C104;
- next-job recommendation with theorem shape, dependencies, and non-goals.
