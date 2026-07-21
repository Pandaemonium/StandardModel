# Job: resolvent response pole vs propagator zero (gate A4, correlator level)

Prove the two theorems in
`PhysicsSM/Draft/NullEdge/ResolventResponsePole.lean` (statements unchanged).
They make explicit, at the level of the actual two-point response function
`G_H(z) = ⟨e0, (z • 1 - H)⁻¹ e0⟩ = ((z • 1 - H)⁻¹) 0 0`, that two Hermitian
involutions with the identical spectrum `{-1,+1}` have different analytic
structure at the lower gap edge `z = -1`: `Hpole = diag(-1,1)` has a unit-residue
pole there, `Hdark = diag(1,-1)` is regular there.

Route: for `z ∉ {-1,+1}`, `z • 1 - Hpole = diag(z+1, z-1)` and
`z • 1 - Hdark = diag(z-1, z+1)` are invertible diagonal matrices. Use the
`2 x 2` inverse (`Matrix.inv_def`, `Matrix.adjugate_fin_two`,
`Matrix.det_fin_two`, or the diagonal-inverse lemma) to compute the `(0,0)`
entry: `(z+1)⁻¹` and `(z-1)⁻¹` respectively. The determinants are
`(z+1)(z-1) ≠ 0` under the hypotheses. The residue theorem then follows by
`(z+1) * (z+1)⁻¹ = 1` (needs `z + 1 ≠ 0`) and
`(z+1) * (z-1)⁻¹ = (z+1)/(z-1)`.

Constraints: Mathlib only; no new `axiom`/`opaque`/`unsafe`; no `native_decide`;
standard axioms `[propext, Classical.choice, Quot.sound]`. Verify with
`lake env lean PhysicsSM/Draft/NullEdge/ResolventResponsePole.lean`. Report axioms.
