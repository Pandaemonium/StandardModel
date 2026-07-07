import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.SolderedSquareGram

/-!
# Move-2 IDENTIFICATION - the aperture block `Q_A` IS the invariant mass `Q(∑ α)`

The first Move-2 identification lemma: it ties the abstract aperture block `Q_A` of the
Weitzenböck decomposition to the **aperture functional** (the invariant mass of a sum of
null momenta), which is the actual physics content the `D²` decomposition was scaffolding.

With unit weights (`x ≡ 1`), the null-soldered square is the scalar image of the quadratic
form evaluated on the **total** soldering:

>   `(∑ₑ c(αₑ))² = algebraMap R _ (Q (∑ₑ αₑ))`.

Because `(∑ₑ c(αₑ))² = Q_A` (brick 2a, `nullSoldered_square_isScalar`: with unit weights the
soldered square is exactly the aperture Gram scalar, `Q_C` absent), this says
**`Q_A = Q(∑ₑ αₑ)`** — the aperture block equals `minkowskiSq` of the summed null momenta.
Hence `Q_A = 0` iff the total soldering is null, which — in the Minkowski specialization
`Q = minkowskiSq`, `αₑ = ` future-null momenta — is exactly the landed aperture theorem
`NBodyAperture.nbody_aperture_massless_iff_collinear` (`minkowskiSq (∑ pᵢ) = 0 ↔` collinear).

So the chain is: abstract `Q_A` block  =  `Q(∑ α)`  =  aperture invariant mass, and its
vanishing locus is the collinear locus. This is the honest identification the decomposition
needed; the `Q_A` naming is now a theorem, not a convention.

## Scope / honesty (draft)

Over a field `R` (so `algebraMap` into the Clifford algebra is injective and `Q_A = 0 ↔
Q(∑α) = 0`). The bridge to `NBodyAperture` is stated as a docstring correspondence here and
made a literal `↔` only in the Minkowski specialization (a follow-up, since `NBodyAperture`
uses the concrete `Momentum4`/`minkowskiSq` API rather than an abstract `QuadraticForm`).
Provenance: corollary of brick 2a (`SolderedSquareGram`); Move-2 of the carrier program.

Proof handoff (for Aristotle):
- `Q_A_eq_totalSq`: from `nullSoldered_square_eq_algebraMap Q alpha (fun _ => 1) h2`
  (brick 2a) the square is `algebraMap (2⁻¹ * ∑ₑ ∑_f (1*1) * polar Q αₑ α_f)`. Simplify the
  scalar: `∑ₑ ∑_f polar Q αₑ α_f = polar Q (∑ₑ αₑ) (∑_f α_f)` by bilinearity of `polar`
  (`QuadraticMap.polar_sum` / `map_sum` on each slot), `= polar Q (∑α) (∑α) = 2 • Q (∑α)`
  (`QuadraticMap.polar_self`), so `2⁻¹ * (2 * Q(∑α)) = Q(∑α)`.
- `Q_A_zero_iff`: `algebraMap` is injective over a field (`algebraMap_eq_zero_iff` /
  `NoZeroDivisors` + `FaithfulSMul`), so the square is `0` iff `Q (∑ₑ αₑ) = 0`.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R V : Type*} [Field R] [AddCommGroup V] [Module R V]

/-- **Move-2 aperture identification (core).**  With unit weights, the null-soldered square
is the scalar image of the quadratic form on the total soldering: `(∑ₑ c(αₑ))² =
algebraMap R _ (Q (∑ₑ αₑ))`.  Since the LHS is the aperture block `Q_A` (brick 2a), this is
`Q_A = Q(∑ₑ αₑ)` — the aperture block equals the invariant mass of the summed null momenta. -/
theorem Q_A_eq_totalSq {E : Type*} [Fintype E] (Q : QuadraticForm R V) (alpha : E → V)
    (h2 : (2 : R) ≠ 0) :
    nullSoldered Q alpha (fun _ => 1) ^ 2
      = algebraMap R (CliffordAlgebra Q) (Q (∑ e, alpha e)) := by
  rw [nullSoldered_square_eq_algebraMap Q alpha (fun _ => 1) h2]
  congr 1
  -- The double sum of the polar form is the polar of the total soldering.
  have hbil : (∑ e, ∑ f, QuadraticMap.polar (⇑Q) (alpha e) (alpha f))
      = QuadraticMap.polar (⇑Q) (∑ e, alpha e) (∑ f, alpha f) := by
    conv_rhs => rw [← QuadraticMap.polarBilin_apply_apply]
    simp only [map_sum, LinearMap.sum_apply, QuadraticMap.polarBilin_apply_apply]
    rw [Finset.sum_comm]
  simp only [one_mul, mul_one]
  rw [hbil, QuadraticMap.polar_self, nsmul_eq_mul, Nat.cast_ofNat, ← mul_assoc,
    inv_mul_cancel₀ h2, one_mul]

/-- **The aperture block vanishes iff the total soldering is null.**  `Q_A = 0 ↔
Q(∑ₑ αₑ) = 0` — the carrier form of "the composite is massless iff the total momentum is
null", whose collinear characterization is `NBodyAperture.nbody_aperture_massless_iff_collinear`
in the Minkowski specialization. -/
theorem Q_A_zero_iff_totalSq_zero {E : Type*} [Fintype E] (Q : QuadraticForm R V)
    (alpha : E → V) (h2 : (2 : R) ≠ 0) :
    nullSoldered Q alpha (fun _ => 1) ^ 2 = 0 ↔ Q (∑ e, alpha e) = 0 := by
  rw [Q_A_eq_totalSq Q alpha h2]
  haveI : Invertible (2 : R) := invertibleOfNonzero h2
  constructor
  · intro h
    by_contra hne
    have hu : IsUnit (algebraMap R (CliffordAlgebra Q) (Q (∑ e, alpha e))) :=
      (Ne.isUnit hne).map (algebraMap R (CliffordAlgebra Q))
    rw [h] at hu
    exact not_isUnit_zero hu
  · intro h; rw [h, map_zero]

end PhysicsSM.Draft.NullEdge.Carrier
