# Design note: three-family rephasing Jarlskog (C2 successor)

Author: claude / research_scientist. Date: 2026-07-16.
Status: DESIGN ONLY - successor preregistration draft for the spiral
layer after the C1/C2/C3 closure. No theorem claimed; grade C rows
proposed with gates and kill conditions displayed. Wave-8 candidate.

## Why a successor at all

The landed two-family toy (SPIRAL-CP-JARLSKOG-TOY) shows CP-odd
interference = oriented-volume functional, with SO(3) frame invariance.
What it cannot exhibit is the CKM-defining phenomenon: REPHASING
invariance with three families, where the CP-odd invariant is unique up
to sign (the Jarlskog determinant) and vanishes iff any two families
are degenerate. The corner-calculus analog needs a third path family
and a per-family phase freedom to quotient by.

## The proposed toy

Three corner families A, B, C (three-corner each, as in wave 6), with
the per-family "rephasing" freedom being an azimuthal rotation of each
family about a common axis z (the corner-calculus stand-in for quark
phase redefinitions): family X -> R_z(theta_X) X.

PREFLIGHT RESULT (numpy, 2026-07-16, decisive): the wave-6 observable
jarlskogObs(X, Y) is EXACTLY INERT under family-wise rotations - each
famTrace depends only on the family's internal dots and triple, which
rigid rotations preserve. Family-internal invariants cannot see
rephasing at all; the naive T1'/T2' (pairwise-obs covariance and cyclic
sums) are dead on arrival. The rephasing analog requires MIXED
(interleaved) objects. Verified numerically: the interleaved hexagon
tr(P a1 P b1 P a2 P b2 P a3 P b3) is (i) invariant under a COMMON
rotation of both families, (ii) changed by a relative rotation, and
(iii) dependent on the relative angle only ((iii) follows from (i) for
the abelian z-rotation action; confirmed numerically anyway).

Corrected targets (freeze only after one more preflight fixes the
three-family invariant's exact form):

- **T1'' (family-internal inertness; the no-go half).** Kernel-check
  the inertness itself: jarlskogObs(R X, S Y) = jarlskogObs(X, Y) for
  arbitrary proper rotations R, S applied family-wise. This is a
  strengthening of the landed common-rotation invariance and proves
  WHY mixed objects are necessary - a small honest theorem, wave-6
  proof shape (dots/triples internally invariant).
- **T2'' (mixed-trace rephasing covariance).** For the interleaved
  hexagon: invariance under common z-rotation, plus explicit
  relative-angle covariance under family-wise z-rotations (the exact
  functional form to be fixed by preflight - expected: a finite
  Fourier polynomial in (a - b) with coefficients from the two
  families' internal data). Gate: numeric form-fixing then kernel
  identity. Kill: no closed covariance form (would indicate the
  hexagon is the wrong mixing object; fall back to the four-corner
  interleave tr(Pa1 Pb1 Pa2 Pb2)).
- **T3'' (three-family invariant + degeneracy vanishing).** A cyclic
  Im-combination of interleaved objects over (A,B), (B,C), (C,A),
  invariant under ALL family-wise z-rotations, vanishing when two
  families coincide up to z-rotation (degenerate-mass analog) and
  vanishing on coplanar configurations. Gate: preflight form-fixing,
  then kernel proof. Kill: a nonvanishing value on a degenerate pair
  (falsifies the CKM analogy, not the algebra).
- **W'' (witness).** A rational three-family configuration with
  nonvanishing invariant plus both controls (planar -> 0; degenerate
  pair -> 0).

## Honest framing

The z-axis choice makes rephasing an SO(2) subgroup action, not the
full U(3) x U(3) quark story; the toy tests whether the corner
calculus REPRODUCES the invariant-theory shape (relative-phase-only
dependence, unique cyclic invariant, degeneracy vanishing), not
whether it derives the CKM matrix. Any manuscript use stays inside the
claim boundary of the skeleton's section 6.

## Sequencing

Numeric preflight (T2' form selection) -> freeze statements ->
Mathlib-only Aristotle package (wave 8) -> the usual verbatim/guard
integration. Preflight and packaging are one session's work; not
urgent, and should not preempt GR-lane review duty. Register as a
C-grade successor row only after the preflight fixes the T2' form.
