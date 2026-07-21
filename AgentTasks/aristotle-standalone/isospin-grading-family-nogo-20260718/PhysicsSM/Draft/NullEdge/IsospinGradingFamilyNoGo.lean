import PhysicsSM.Draft.NullEdge.IsospinGradingSearch

/-!
# The eq-36 grading family no-go (linear span of the killed candidates)

Target statements for the Aristotle job `isospin-grading-family-nogo-20260718`.

Context. `IsospinGradingSearch` (Aristotle 8f0f1d95, integrated) killed three
point candidates for the eq-36 doublet grading `(0, +1, -1, 0)` on the ideal
operators `(vwHat, X1, X2, X3)`:

  `G_R`  (quaternionic right rotation `i R3`):     vector `(0, 2, 2, 0)`,
  `G_PL` (`co hatTau3 o PL`, the landed `T3`):     vector `(0, 1, 1, 2)`,
  `G_R_normalized`:                                vector `(0, 1, 1, 0)`.

The obstruction in every case is SAME-SIGN: `X1` and `X2` receive equal
grades.  This module upgrades the three point kills to a family no-go: the
adjoint grading `adG` is linear in the grading operator `G`, the generators'
`X1`/`X2` grades are equal, hence NO element of the linear span
`a G_PL + b G_R + e id` separates `X1` from `X2` with opposite signs; in
particular none realizes `(0, +1, -1, 0)`.

Statement shape notes for Aristotle:
- `adG` and the candidate family are already definitionally available; the
  family is bundled here as `famG`.
- The scalar-extraction step needs a nonzero witness for `X1` and `X2`
  applied to a concrete state; adding small nonzero-witness lemmas (pattern:
  `slotVL_ne_zero` in `CompositionTransitionCensus`) is permitted and
  expected.
- Do not weaken the final no-go statement.  If some auxiliary identity below
  is false as stated, prove the corrected identity, rename it, and record
  the mismatch prominently; then still derive the strongest true no-go.

Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IsospinGradingFamilyNoGo

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionSU2
open PhysicsSM.Draft.NullEdge.CompositionIdealRepContent
open PhysicsSM.Draft.NullEdge.IsospinGradingSearch

set_option maxHeartbeats 64000000

/-- The three-parameter candidate family spanned by the killed generators
and the identity. -/
def famG (a b e : ℂ) (d : Dixon) : Dixon :=
  a • G_PL d + b • G_R d + e • d

/-- `adG` is additive in the grading operator (pointwise). -/
theorem adG_add (G H X : Dixon → Dixon) (d : Dixon) :
    adG (fun z => G z + H z) X d = adG G X d + adG H X d := by
  sorry

/-- `adG` of a scalar multiple of the grading operator (pointwise, for
operators `X` commuting with scalar action; `X1`, `X2` qualify). -/
theorem adG_smul_X1 (c : ℂ) (G : Dixon → Dixon) (d : Dixon) :
    adG (fun z => c • G z) X1 d = c • adG G X1 d := by
  sorry

/-- The identity component contributes nothing to any grade. -/
theorem adG_id (X : Dixon → Dixon) (d : Dixon) :
    adG (fun z => z) X d = 0 := by
  sorry

/-- Family grade on `X1`: the affine combination of the generator grades. -/
theorem famG_X1 (a b e : ℂ) (d : Dixon) :
    adG (famG a b e) X1 d = (a + 2 * b) • X1 d := by
  sorry

/-- Family grade on `X2`: the SAME affine combination (this equality of
coefficients is the obstruction). -/
theorem famG_X2 (a b e : ℂ) (d : Dixon) :
    adG (famG a b e) X2 d = (a + 2 * b) • X2 d := by
  sorry

/-- **Family no-go.**  No member of the candidate family grades `X1` and
`X2` by scalars of opposite sign; in particular the eq-36 doublet pattern
`(+1, -1)` is unrealizable in this family. -/
theorem famG_no_sign_separation :
    ¬ ∃ (a b e : ℂ) (lam mu : ℂ),
      (∀ d, adG (famG a b e) X1 d = lam • X1 d) ∧
      (∀ d, adG (famG a b e) X2 d = mu • X2 d) ∧
      lam = 1 ∧ mu = -1 := by
  sorry

end PhysicsSM.Draft.NullEdge.IsospinGradingFamilyNoGo
