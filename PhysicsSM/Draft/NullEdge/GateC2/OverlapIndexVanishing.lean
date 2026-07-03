import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.FluxOverlapIndex

/-!
# Gate C2: the vanishing theorem - topological protection of masslessness

Harvested from Aristotle job 2b9ab4ce (package
`AgentTasks/aristotle-standalone/gate-c2-index-vanishing-20260703`) and
rewired onto the repo's `Dov` / `overlapIndex` (via `overlapIndex_eq`).  The
statements were authored in-repo; Aristotle proved them with NO statement
change, and found a purely ALGEBRAIC route that needs only the involution
identities - the Hermiticity hypotheses of the original statements were
unused, so the ported statements drop them (a strict generalization, not a
weakening).

**The theorems.**  For involutions `gamma5` (chirality) and `eps` (sign) with
overlap operator `Dov = 1 + gamma5 * eps`:

* `overlapIndex_eq_zero_of_isUnit_dov` (gapped form): if `Dov` is invertible,
  the chiral index vanishes.
* `exists_zero_mode_of_overlapIndex_ne_zero` (zero-mode form): a nonzero
  chiral index forces an exact zero mode of `Dov` - **masslessness is
  topologically protected**: no configuration with nonzero index can be
  gapped.
* `flux_witness_has_zero_mode`: instantiation at the pi-flux triangle
  (`FluxOverlapIndex`): since its index is `-1 != 0`, its overlap operator
  has an exact zero mode.  The C2 layer now exhibits, in one chain, a genuine
  gauge flux, its nonzero integer index, and the zero mode that index forces.

**The proof mechanism** (Aristotle's algebraic route, reviewed and verified
by hand): `A = gamma5 - eps` and `B = gamma5 + eps` anticommute; the identity
`(eps * gamma5) * Dov^2 = B^2` makes `B` invertible whenever `Dov` is; then
`B^{-1} A B = -A` gives `Tr A = -Tr A = 0`, i.e. `Tr gamma5 = Tr eps`, and
the index `(1/2)(Tr gamma5 - Tr eps)` vanishes.  The zero-mode form is the
contrapositive plus the determinant characterization of singular matrices.

This completes the free/regulator chirality-substrate story of the
origin-of-mass program (P1 manuscript, layer 3): the index is an integer
(`OverlapIndexIntegrality`), it is computed by eigenvalue-sign counts
(`GaugeIndexInertiaForm`), it responds to genuine gauge flux
(`FluxOverlapIndex`), and - now - it obstructs the mass gap.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (index-forced zero modes).
Prerequisites: `GateC1.OverlapIndexToy` (index algebra), `FluxOverlapIndex`
(concrete witness).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexVanishing

open Matrix
open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Algebraic keystone: `A = g - e` and `B = g + e` anticommute, using only
the involution identities. -/
private lemma anticomm_gsub_gadd (g e : Matrix Spin Spin ℂ)
    (hg2 : g * g = 1) (he2 : e * e = 1) :
    (g - e) * (g + e) + (g + e) * (g - e) = 0 := by
  simp +decide [ sub_mul, mul_add, add_mul, mul_sub, hg2, he2 ];
  abel1

/-- Key invertibility fact: `(e * g) * (1 + g e)^2 = (g + e)^2`, hence if the
overlap operator is a unit so is `g + e`. -/
private lemma gadd_isUnit_of_isUnit_one_add (g e : Matrix Spin Spin ℂ)
    (hg2 : g * g = 1) (he2 : e * e = 1) (hunit : IsUnit (1 + g * e)) :
    IsUnit (g + e) := by
  have h_inv : IsUnit ((g + e) * (g + e)) := by
    have h_inv : (g + e) * (g + e) = (e * g) * ((1 + g * e) * (1 + g * e)) := by
      simp +decide [ mul_add, add_mul, hg2, he2 ] ;
      grind +extAll;
    rw [ h_inv ];
    refine' IsUnit.mul _ _;
    · exact Matrix.isUnit_iff_isUnit_det _ |>.2 ( isUnit_iff_ne_zero.2 fun h => by simpa [ h ] using congr_arg Matrix.det he2 ) |> IsUnit.mul <| Matrix.isUnit_iff_isUnit_det _ |>.2 ( isUnit_iff_ne_zero.2 fun h => by simpa [ h ] using congr_arg Matrix.det hg2 );
    · exact hunit.mul hunit;
  simp_all +decide [ Matrix.isUnit_iff_isUnit_det ]

/-- With `B = g + e` invertible, `B^{-1} (g - e) B = -(g - e)`, so the trace
of `g - e` equals its own negative and hence vanishes. -/
private lemma trace_gsub_eq_zero (g e : Matrix Spin Spin ℂ)
    (hg2 : g * g = 1) (he2 : e * e = 1) (hB : IsUnit (g + e)) :
    (g - e).trace = 0 := by
  have h_anticomm : (g - e) * (g + e) + (g + e) * (g - e) = 0 :=
    anticomm_gsub_gadd g e hg2 he2
  have h_inv : (g + e)⁻¹ * (g - e) * (g + e) = -(g - e) := by
    simp_all +decide [ mul_assoc, add_eq_zero_iff_eq_neg ];
    cases hB.nonempty_invertible ; aesop;
  replace h_inv := congr_arg Matrix.trace h_inv ; simp_all +decide;
  rw [ Matrix.trace_mul_comm ] at h_inv;
  simp_all +decide [ ← mul_assoc, Matrix.isUnit_iff_isUnit_det ];
  grind

/-- **Vanishing theorem (gapped form).**  For involutions `gamma5`, `eps`
(no Hermiticity needed): if the overlap operator `Dov = 1 + gamma5 eps` is
invertible - a "gapped", mass-admitting operator - the chiral index
vanishes. -/
theorem overlapIndex_eq_zero_of_isUnit_dov (gamma5 eps : Matrix Spin Spin ℂ)
    (hg2 : gamma5 * gamma5 = 1) (heps2 : eps * eps = 1)
    (hunit : IsUnit (Dov gamma5 eps)) :
    overlapIndex gamma5 eps = 0 := by
  have hunit' : IsUnit (1 + gamma5 * eps) := hunit
  have hB : IsUnit (gamma5 + eps) :=
    gadd_isUnit_of_isUnit_one_add gamma5 eps hg2 heps2 hunit'
  have ht : (gamma5 - eps).trace = 0 :=
    trace_gsub_eq_zero gamma5 eps hg2 heps2 hB
  rw [Matrix.trace_sub] at ht
  rw [overlapIndex_eq gamma5 eps hg2, ht, mul_zero]

/-- **Vanishing theorem (zero-mode form).**  A nonzero chiral index forces an
exact zero mode of the overlap operator: masslessness is topologically
protected. -/
theorem exists_zero_mode_of_overlapIndex_ne_zero (gamma5 eps : Matrix Spin Spin ℂ)
    (hg2 : gamma5 * gamma5 = 1) (heps2 : eps * eps = 1)
    (hidx : overlapIndex gamma5 eps ≠ 0) :
    ∃ psi : Spin → ℂ, psi ≠ 0 ∧ (Dov gamma5 eps) *ᵥ psi = 0 := by
  have hnu : ¬ IsUnit (Dov gamma5 eps) := fun hu =>
    hidx (overlapIndex_eq_zero_of_isUnit_dov gamma5 eps hg2 heps2 hu)
  have hdet : (Dov gamma5 eps).det = 0 := by
    by_contra hd
    exact hnu ((Matrix.isUnit_iff_isUnit_det _).2 (isUnit_iff_ne_zero.2 hd))
  exact Matrix.exists_mulVec_eq_zero_iff.2 hdet

/-- **The flux witness has an exact zero mode.**  The pi-flux triangle's
overlap index is `-1 != 0`, so its overlap operator `Dov gamma5U epsU` has a
genuine zero mode: the gauge flux does not merely shift a bookkeeping
integer - it pins an exactly massless mode.  (Index -> zero mode, at the
concrete witness.) -/
theorem flux_witness_has_zero_mode :
    ∃ psi : Fin 3 × Fin 2 → ℂ, psi ≠ 0 ∧
      (Dov FluxOverlapIndex.gamma5U FluxOverlapIndex.epsU) *ᵥ psi = 0 := by
  refine exists_zero_mode_of_overlapIndex_ne_zero _ _
    FluxOverlapIndex.gamma5U_sq FluxOverlapIndex.signCert_HU.involution ?_
  rw [FluxOverlapIndex.overlapIndex_flux]
  norm_num

end OverlapIndexVanishing
end GateC2
end NullEdge
end Draft
end PhysicsSM
