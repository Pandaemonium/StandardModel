# Proof job: theta-family involution protection (Paper C stability, rank-1 target)

Kernel-only Lean 4 (standard three axioms; NO native_decide anywhere in
this file - the whole point is replacing finite-fixture decisions with
symbolic identities). Import Mathlib + the three context modules
(ModeInvariantHalfWinding for the walk builders + engine,
HalfPeriodInvariant for the {1,3} chart predicates, PinnedMirrorChart
for the {0,2} chart). Do not modify context modules. Namespace
PhysicsSM.Draft.NullEdge.ThetaFamilyProtection.

## Oracle-verified mathematics (sympy, symbolic theta, this morning)

Parametrize the coin by a real angle: the walk
W(b, theta) = walkQ (cos theta) (fun x => sign(b x) * sin theta)
(the context's walkQ with c = cos theta, sitewise signed sin theta;
sign(b x) = if b x then 1 else -1). All identities below reduce to
sin^2 + cos^2 = 1 (Real.sin_sq_add_cos_sq) - the oracle confirmed each
is an exact trig-polynomial identity, and each control fails by an
explicit 2*sin(theta) entry.

Theorem ladder (all quantified over ALL theta : Real):

T1 block_involution_family: for each of the four block fields b
   (wallCount 2, not a singleton - use the context predicates or
   enumerate the four explicitly), W(b,theta) is symmetric
   (transpose = itself) and W(b,theta) * W(b,theta) = 1.
T2 chart13_involution_family: for every protected singleton b
   (protectedField b && isSingleton-style; the four explicit fields are
   acceptable as separate theorems if the quantified Bool form fights),
   the compression M13(b,theta) = Bfixᵀ * W(b,theta) * Bfix satisfies
   M13ᵀ = M13, M13 * M13 = 1, trace M13 = 0, and the intertwining
   W(b,theta) * Bfix = Bfix * M13(b,theta).
T3 chart02_involution_family: same four facts for blind singletons in
   the {0,2} chart (Bfix0, from PinnedMirrorChart).
T4 modes_persist: compose T1-T3 with the landed InvolutiveCompression
   engine (context: involutive_compression_fixed_mode / flip_mode,
   toC transport) to conclude: for every theta, every two-wall field's
   complete walk W(b,theta) over C has a nonzero +1 eigenvector and a
   nonzero -1 eigenvector. THIS IS THE HEADLINE: the certified modes
   persist for the ENTIRE coin/mass family theta - protection is an
   exact identity family, no gap or continuity hypothesis.
T5 negative controls (exact failure): for the blind singleton
   [+,+,+,-] in the WRONG chart {1,3}: (M13 - M13ᵀ) (0,1) entry =
   -2 * sin theta (oracle-verified exact form), hence self-adjointness
   fails for every theta with sin theta != 0. Same-form failure for the
   zero-wall and four-wall fields in chart {1,3}. State these as
   explicit entry identities (they are single matrix entries - light).
T6 massless boundary: at sin theta = 0 the walk degenerates (coin = +-1,
   W becomes a signed shift); state the boundary honestly: the negative
   controls vanish there, so chart-failure claims are scoped to
   sin theta != 0 (the massive family).

## Discipline

- Symbolic Real trig only; expected closers: Matrix.ext + Fin cases +
  ring_nf + Real.sin_sq_add_cos_sq. No decide/native_decide.
- If the context's walkQ signature makes the theta-parametrization
  awkward, define Wth (b) (theta) locally as the explicit 8x8 matrix
  (entries cos/sin with the context's block layout) and prove ONE
  compatibility lemma Wth b theta = walkQ (cos theta) (...) so the
  engine transport applies - do not fork definitions silently.
- Kill condition: if any T1-T3 identity does NOT reduce to the
  Pythagorean identity (an extra theta-term survives), REPORT the exact
  residual - the family claim would be false and the fixture-only
  landing stands.
Deliverable: one Lean file + memo with the exact statement list.
