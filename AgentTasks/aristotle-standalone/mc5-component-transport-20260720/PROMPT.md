# Lemma job: componentwise L2 transport for the four-component lift (MC5 item 2)

Mathlib-only, abstract. A changing-lattice L2 argument proved for two-component
fields is being lifted to four components. The audit
`OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md` flags that representatives and
measurability must be TRANSPORTED componentwise, not assumed. Make it exact.

Work with `Lp` functions valued in a finite product / `EuclideanSpace C (Fin n)`.
Prove:
1. **Componentwise measurability transport**: `f : X -> EuclideanSpace C (Fin n)` is
   (a.e.strongly) measurable iff each component `fun x => f x i` is; state the
   `AEStronglyMeasurable` form actually usable in an `L2` argument.
2. **Norm assembly**: `||f||_{L2}^2 = sum_i ||fun x => f x i||_{L2}^2`, so an
   `L2` bound on each component gives an `L2` bound on the vector with the
   Pythagorean constant (NOT a factor `n`).
3. **Multiplier transport**: if a matrix-valued multiplier `M : X -> Matrix (Fin n)
   (Fin n) C` acts pointwise and `||M x|| <= C` in the L2 operator norm for a.e. `x`,
   then `|| fun x => (M x).mulVec (f x) ||_{L2} <= C * ||f||_{L2}`. This is the step
   that actually moves a pointwise operator-norm bound to the L2 estimate.
State every measurability hypothesis explicitly; the point is that none of these
are free. No new axioms/native_decide; standard axioms; report axioms.
