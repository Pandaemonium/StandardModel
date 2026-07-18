# Null-edge periodic vacuum-Weyl mean obstruction

Date: 2026-07-18
Status: implemented and verified

## Objective

Determine whether the nonzero algebraic vacuum-Weyl target can be realized as
the first-order curl of globally defined links on the finite periodic carrier
used by the current null-edge Palatini program.

## Landed results

`PeriodicVacuumWeylMeanObstruction.lean` proves:

1. every component of every periodic additive plaquette curl has zero site
   sum;
2. every periodically realized additive curvature inherits the exact
   three-direction discrete Bianchi identity;
3. a site-independent additive curvature on a nonempty finite carrier is
   zero;
4. a fixed-carrier componentwise limit that approaches the same target at
   every site is also zero;
5. the nonzero unit vacuum-Weyl target therefore has neither realization;
6. a site-dependent common scalar multiplying the diagonal unit Weyl shape
   remains pointwise mixed-vacuum, but Bianchi forces that scalar to be shift
   invariant;
7. both parameters of the full site-decorated diagonal Weyl family are shift
   invariant whenever its bivector eigenplanes remain fixed;
8. the explicit zero-mean `2 x 2` checkerboard flips under a shift and is not
   an additive periodic curvature.

## Interpretation boundary

This is a first-order periodic-trivialization no-go. It does not exclude
curved null-edge gravity. It proves that the next ansatz needs genuine local
frame/component mixing, boundary data, a twisted bundle sector, or a
nonlinear scaling whose leading curvature is not globally additive.

## Verification

- Direct Lean check passed cleanly.
- Targeted module build passed (8083 jobs).
- GR foundations facade build passed (8138 jobs).
- Strict token scan passed with no forbidden proof mechanisms.
- `pre-commit run --all-files` and `git diff --check` passed.
- Full `lake build` passed (8319 jobs); replayed warnings were pre-existing and
  outside this task's files.
