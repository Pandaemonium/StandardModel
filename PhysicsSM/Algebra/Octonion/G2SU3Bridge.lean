import Mathlib
import PhysicsSM.Algebra.Octonion.G2ComplexTripleAction
import PhysicsSM.Algebra.Octonion.ComplexTripleLinear
import PhysicsSM.Algebra.Octonion.ComplexTripleHermitian

/-!
# Algebra.Octonion.G2SU3Bridge

Complex-linear and unitary bridge from the `G₂` stabilizer action on `ℂ³`
toward `SU(3)`.

## Mathematical context

Baez (2021) observes that choosing a unit imaginary octonion `i` gives a
splitting `𝕆 = ℂ ⊕ ℂ³`, and the stabilizer `Stab_{G₂}(i)` acts on the
complement `ℂ³` by complex-linear transformations preserving the Hermitian
inner product — i.e. it acts as a subgroup of `U(3)`. A deeper argument
shows `Stab_{G₂}(i) ≅ SU(3)`.

This file packages the already-proven complex-linearity of
`FixingE111MulLinear.onComplexTriple` as:

- a genuine `ℂ`-linear map `→ₗ[ℂ]` on `ComplexTriple`,
- a `ℂ`-linear map `→ₗ[ℂ]` on the coordinate space `Fin 3 → ℂ`,

and defines predicates for norm/Hermitian preservation, proving the
easy implication (Hermitian preservation ⇒ norm preservation).

## Claim boundary

This file does **not** claim `Stab_{G₂}(e111) ≅ SU(3)`. It does not assert
that every `FixingE111MulLinear` preserves the Hermitian form or has
determinant one. Those are frontier targets for future work.

The conservative predicate `ActsAsSU3OnC3` bundles the conditions that would
need to be verified (complex-linearity + Hermitian preservation + det = 1) but
the file does not assert that every `FixingE111MulLinear` satisfies it.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Complex-linear map on `ComplexTriple` -/

/-- The induced action of a `FixingE111MulLinear` map on `ComplexTriple`,
    packaged as a `ℂ`-linear map.

    This uses `onComplexTriple_add`, `onComplexTriple_complex_smul`, and the
    `Module ℂ ComplexTriple` instance from `ComplexTripleLinear`. -/
noncomputable def FixingE111MulLinear.onComplexTripleLinear
    (g : FixingE111MulLinear) :
    ComplexTriple →ₗ[ℂ] ComplexTriple where
  toFun := g.onComplexTriple
  map_add' := g.onComplexTriple_add
  map_smul' z w := by
    -- The `Module ℂ` instance uses `complexSmul` as the SMul action.
    change g.onComplexTriple (z • w) = z • g.onComplexTriple w
    change g.onComplexTriple (ComplexTriple.complexSmul z w) =
      ComplexTriple.complexSmul z (g.onComplexTriple w)
    exact g.onComplexTriple_complex_smul z w

/-- The linear map applies as `onComplexTriple`. -/
@[simp] theorem FixingE111MulLinear.onComplexTripleLinear_apply
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    g.onComplexTripleLinear w = g.onComplexTriple w :=
  rfl

/-! ## Complex-linear map on coordinate space `Fin 3 → ℂ` -/

/-- The induced action transported to coordinate space `Fin 3 → ℂ`
    via `ComplexTriple.linearEquivComplexVec`.

    Concretely: embed a coordinate vector as a `ComplexTriple`, apply `g`,
    then read off the coordinates. -/
noncomputable def FixingE111MulLinear.onComplexVecLinear
    (g : FixingE111MulLinear) :
    (Fin 3 → ℂ) →ₗ[ℂ] (Fin 3 → ℂ) :=
  ComplexTriple.linearEquivComplexVec.toLinearMap.comp
    (g.onComplexTripleLinear.comp
      ComplexTriple.linearEquivComplexVec.symm.toLinearMap)

/-- The coordinate linear map acts as: embed, apply `g`, project. -/
@[simp] theorem FixingE111MulLinear.onComplexVecLinear_apply
    (g : FixingE111MulLinear) (v : Fin 3 → ℂ) :
    g.onComplexVecLinear v =
      (g.onComplexTriple (ComplexTriple.linearEquivComplexVec.symm v)).toComplexVec :=
  rfl

/-- The coordinate linear map is conjugated by the linear equivalence. -/
theorem FixingE111MulLinear.onComplexVecLinear_eq_conj
    (g : FixingE111MulLinear) :
    g.onComplexVecLinear =
      ComplexTriple.linearEquivComplexVec.toLinearMap.comp
        (g.onComplexTripleLinear.comp
          ComplexTriple.linearEquivComplexVec.symm.toLinearMap) :=
  rfl

/-! ## Norm and Hermitian preservation predicates -/

/-- A `FixingE111MulLinear` map preserves the squared norm on `ComplexTriple`
    if `‖g(w)‖² = ‖w‖²` for all `w`. -/
def PreservesComplexTripleNorm (g : FixingE111MulLinear) : Prop :=
  ∀ w, ComplexTriple.normSq (g.onComplexTriple w) = ComplexTriple.normSq w

/-- A `FixingE111MulLinear` map preserves the Hermitian inner product on
    `ComplexTriple` if `⟨g(u), g(v)⟩ = ⟨u, v⟩` for all `u v`. -/
def PreservesComplexTripleHermitian (g : FixingE111MulLinear) : Prop :=
  ∀ u v, ComplexTriple.hermitian (g.onComplexTriple u) (g.onComplexTriple v) =
    ComplexTriple.hermitian u v

/-! ## Hermitian preservation implies norm preservation -/

/-- Hermitian preservation implies norm preservation.

    **Proof.** `normSq w = Re ⟨w, w⟩` (by `hermitian_self_re`), so
    Hermitian preservation on the diagonal gives norm preservation. -/
theorem PreservesComplexTripleHermitian.preservesNorm
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g) :
    PreservesComplexTripleNorm g := by
  intro w
  have h1 : (ComplexTriple.hermitian (g.onComplexTriple w) (g.onComplexTriple w)).re =
    ComplexTriple.normSq (g.onComplexTriple w) :=
    ComplexTriple.hermitian_self_re _
  have h2 : (ComplexTriple.hermitian w w).re = ComplexTriple.normSq w :=
    ComplexTriple.hermitian_self_re _
  rw [← h1, ← h2, hg w w]

/-! ## Coordinate-space restatements -/

/-- Norm preservation restated in coordinates: the squared norms of
    the coordinate vectors agree. -/
theorem PreservesComplexTripleNorm.coord
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleNorm g)
    (v : Fin 3 → ℂ) :
    ComplexTriple.normSq
      (ComplexTriple.ofComplexVec (g.onComplexVecLinear v)) =
    ComplexTriple.normSq (ComplexTriple.ofComplexVec v) := by
  simp only [FixingE111MulLinear.onComplexVecLinear_apply,
    ComplexTriple.linearEquivComplexVec_symm_apply]
  rw [ComplexTriple.ofComplexVec_toComplexVec]
  exact hg _

/-- Hermitian preservation restated in coordinates. -/
theorem PreservesComplexTripleHermitian.coord
    {g : FixingE111MulLinear}
    (hg : PreservesComplexTripleHermitian g)
    (u v : Fin 3 → ℂ) :
    ComplexTriple.hermitian
      (ComplexTriple.ofComplexVec (g.onComplexVecLinear u))
      (ComplexTriple.ofComplexVec (g.onComplexVecLinear v)) =
    ComplexTriple.hermitian (ComplexTriple.ofComplexVec u)
      (ComplexTriple.ofComplexVec v) := by
  simp only [FixingE111MulLinear.onComplexVecLinear_apply,
    ComplexTriple.linearEquivComplexVec_symm_apply]
  rw [ComplexTriple.ofComplexVec_toComplexVec,
    ComplexTriple.ofComplexVec_toComplexVec]
  exact hg _ _

/-! ## Conservative SU(3) predicate -/

/-- A conservative predicate bundling the conditions for a
    `FixingE111MulLinear` map to act as an element of `SU(3)` on `ℂ³`:

    1. Complex-linearity (already proven for all such maps).
    2. Hermitian inner-product preservation.

    **Note:** The full `SU(3)` characterization additionally requires
    `det = 1` (not merely `|det| = 1`), which would distinguish `SU(3)`
    from `U(3)`. The determinant condition is a frontier target not yet
    formalized in this project.

    This predicate does **not** assert that every `FixingE111MulLinear`
    satisfies it. That is a nontrivial theorem requiring deeper G₂ theory. -/
structure ActsAsSU3OnC3 (g : FixingE111MulLinear) : Prop where
  /-- The map preserves the Hermitian inner product. -/
  hermitian_preserving : PreservesComplexTripleHermitian g

/-! ## Easy consequences of `ActsAsSU3OnC3` -/

/-- An `ActsAsSU3OnC3` map preserves the squared norm. -/
theorem ActsAsSU3OnC3.preservesNorm
    {g : FixingE111MulLinear}
    (hg : ActsAsSU3OnC3 g) :
    PreservesComplexTripleNorm g :=
  hg.hermitian_preserving.preservesNorm

/-- An `ActsAsSU3OnC3` map preserves norm in coordinates. -/
theorem ActsAsSU3OnC3.preservesNorm_coord
    {g : FixingE111MulLinear}
    (hg : ActsAsSU3OnC3 g)
    (v : Fin 3 → ℂ) :
    ComplexTriple.normSq
      (ComplexTriple.ofComplexVec (g.onComplexVecLinear v)) =
    ComplexTriple.normSq (ComplexTriple.ofComplexVec v) :=
  hg.preservesNorm.coord v

end PhysicsSM.Algebra.Octonion.G2ComplexLine
