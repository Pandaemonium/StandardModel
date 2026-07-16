# Claude review: NullMicrostepHyperdiamond (d2d33e0e)

- Reviewer: interactive Claude Code (claude family)
- Source: `PhysicsSM/Draft/NullEdge/NullMicrostepHyperdiamond.lean` (252 lines),
  sha d8451f5d... verified
- Date: 2026-07-13

## Verdict: ACCEPT

An exemplary, honestly-scoped module - the model of the finite/pointwise scope
discipline (it states exactly what it proves and denies what it does not). It
directly realizes my earlier heads-up: the depth-two route escapes the degree-one
scoped no-go, but the doublers relocate rather than vanish, and the module
records that self-refutation honestly.

## The four overreach checks (all pass)

1. **"Primitive null microsteps," not a physical 3+1 solution.** Docstring
   cleanly separates primitive locality (each substep `factor q g` is a
   nearest-neighbor null shift, or the onsite mass coin) from effective range
   (the complete period's degree-two Laurent support). It presents a CANDIDATE
   with completed N0/N1 and finite N3 controls; N2 (tangent) and the full N3
   torus census are explicitly OPEN. No physical-solution claim.
2. **`period_x_slice_not_degree_one` is a GENUINE escape, not hollow.**
   `laurentStep_degree_one_obstruction` proves a UNIVERSAL 4-point identity for
   the whole degree-one class: `F(0)+F(pi) = F(pi/2)+F(-pi/2) = 2B` for ALL
   `A,B,C`. The x-slice `period q 0 0 0 = factor (2q) alpha1` violates it
   (`period` at `0,pi,pi/2,-pi/2` = `1,1,-1,-1`, so `1+1=2 != -2 = -1+-1`),
   refuting membership in the degree-one class for EVERY `A,B,C`. This is the
   correct non-membership proof (violate a class invariant), not a point-sample
   restatement. `period_x_slice = factor (2q) alpha1` (via `factor_add`) carries
   the genuine `e^{+-2iq}` degree-two component.
3. **Determinant claims are SAMPLED controls only.** `census_origin_zero`
   (`det(U(0)-I)=0`), `census_origin_pi` (`det(U(0)+I)=16 != 0`, the mandatory
   pi-branch check), and `census_x_edge_massless_zero` (`det(U(pi,0,0,0)-I)=0`)
   are point samples at the origin and x zone edge. The docstring states "The full
   torus classification of both determinants is left as the stated open target
   N3_census_target." Both `det(U-I)` and `det(U+I)` are inspected - the census is
   not zero-only. Correctly scoped.
4. **No docstring overstatement.**
   - Unitarity: `period_mem_unitary` PROVES exact all-momentum unitarity (product
     of unitary factors) - claimed because proved.
   - Locality: honestly primitive (nearest-neighbor substeps) with effective
     range two - NOT claimed as range one.
   - Isotropy / Dirac tangent: the isotropic generator `-2i(kx a1 + ...)` is
     stated as a PREDICTION for the OPEN N2 rung; "the derivative proof is
     intentionally not exported." Not claimed.
   - Alias removal: explicitly DENIED. `census_x_edge_massless_zero` records that
     "the naive symmetric depth-two candidate is not alias-free at theta = 0" -
     the doubling reappears at the x zone edge. The module does not claim to
     remove the aliases; it proves it does not.

## Math spot-check (correct)

`factor a g * factor b g = factor (a+b) g` for `g^2=1` (`factor_add`, via
cos/sin addition + `I_sq`); so `period q 0 0 0 = factor (2q) alpha1`.
`period` at the four probe momenta = `1,1,-1,-1`; `det(U(0)+I) = det(2 . I) = 2^4
= 16`. All correct.

## Significance

This is the honest outcome of the second lateral route: N1 confirms the depth-two
circuit genuinely leaves the degree-one nearest-neighbor no-go class (a real
escape), while N3's `census_x_edge_massless_zero` shows the doublers RELOCATE (to
the massless x zone edge) rather than vanish - exactly the prediction I sent
(degree-two buys past the scoped corner-alias no-go, but the doublers move,
plausibly requiring a mass or a broken symmetry to gap). The decisive N2 tangent
and full 0-and-pi torus census remain the open gates. As a completed-rung module
it is correct, kernel-clean, and free of the prose-outruns-kernel overreach that
this session's Lab Manager audit flagged.

## Footprint

`lake build` exit 0 (8028 jobs); three `#guard_msgs` (`period_mem_unitary`,
`period_x_slice_not_degree_one`, `census_x_edge_massless_zero`) all
`[propext, Classical.choice, Quot.sound]`. No `sorry`/`native_decide`/axioms.

## Narrowest defensible claim

The symmetric depth-two hyperdiamond period `U(qx,qy,qz,theta)` (seven
nearest-neighbor null-shift/mass-coin substeps) is exactly unitary at every
momentum, has effective range two along each axis (`factor (2q) alpha1`), and its
x-slice provably is NOT any degree-one nearest-neighbor Laurent symbol (violates
the universal degree-one 4-point identity) - a genuine escape from the range-one
single-factor no-go class. At sampled momenta the origin carries a zero-quasienergy
(Dirac) crossing and no pi crossing, and the massless x zone edge carries a
zero-quasienergy crossing (so the candidate is NOT alias-free at theta=0). The
isotropic Dirac tangent and the full torus 0-and-pi census are stated open
targets, not results.
