import PhysicsSM.Draft.NullEdge.CarrierRigidity

/-!
# Solder-degree selector no-go on the live concrete carrier

`ChannelSelectorDescent` reduces presentation independence to preservation of
the evaluation kernel.  This module supplies the decisive live-carrier
negative control.  In the concrete `4 x 4` rational carrier, the represented
word `P = c1 * c1#` is a nonzero idempotent.  The length-two word and its
length-four square therefore evaluate to the same operator.  No additive
selector on represented operators can consistently assign solder weights two
and four to those two presentations.

This does not rule out every physical or information-theoretic selector.  It
rules out raw solder-letter degree as an intrinsic additive selector after
passing to this concrete representation.  Solder degree remains a legitimate
grading of a free algebra modulo a chosen homogeneous defining ideal.

Provenance: the mixed-degree idempotent witness was identified by Aristotle
counter-audit project `6833acfa-0112-4a83-93cb-cf496354afd7`.  The proof below
was independently integrated against the live `CarrierRigidity.Concrete`
definitions and uses ordinary kernel-checked finite matrix algebra.
-/

namespace PhysicsSM.Draft.NullEdge.ChannelSolderDegreeNoGo

open CarrierRigidity.Concrete

/-- The live represented length-two solder word `c1 * c1#`. -/
def solderProjector : N := c1 * kadj c1

theorem solderProjector_value :
    solderProjector = !![1,0,0,0; 0,1,0,0; 0,0,0,0; 0,0,0,0] := by
  rw [solderProjector, kadj_c1]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [c1, Matrix.mul_apply, Fin.sum_univ_four]

/-- The represented length-four word collapses to the length-two word. -/
theorem solderProjector_idempotent :
    solderProjector * solderProjector = solderProjector := by
  rw [solderProjector_value]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem solderProjector_nonzero : solderProjector ≠ 0 := by
  rw [solderProjector_value]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num at h00

/-- No additive map on the live represented carrier can simultaneously read
the solder-letter degrees of `P` and its equal square `P * P`. -/
theorem no_additive_solder_degree_selector :
    ¬ ∃ S : N →+ N,
      S solderProjector = (2 : ℚ) • solderProjector ∧
      S (solderProjector * solderProjector) =
        (4 : ℚ) • (solderProjector * solderProjector) := by
  rintro ⟨S, htwo, hfour⟩
  rw [solderProjector_idempotent] at hfour
  rw [htwo] at hfour
  have h00 := congrFun (congrFun hfour 0) 0
  rw [solderProjector_value] at h00
  norm_num at h00

end PhysicsSM.Draft.NullEdge.ChannelSolderDegreeNoGo
