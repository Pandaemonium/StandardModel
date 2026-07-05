import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111MonoidHom
import PhysicsSM.Algebra.Octonion.G2C3Unitary
import PhysicsSM.Algebra.Octonion.G2AutomorphismSU3ActionPackage

/-!
# Algebra.Octonion.G2FixingE111SpecialUnitaryGroup

Identifies the octonion-derived `SU(3)` with Mathlib's canonical
`Matrix.specialUnitaryGroup (Fin 3) ℂ`.

The octonion program derives `SU(3)` as `su3Submonoid`, the submonoid of
`Matrix (Fin 3) (Fin 3) ℂ` whose elements satisfy `MatrixActsAsSU3OnC3`
(the induced action on the `ℂ³` complement of the complex line is unitary with
determinant 1). This module proves that predicate is exactly Mathlib's
special-unitary condition, so `su3Submonoid` is literally
`Matrix.specialUnitaryGroup (Fin 3) ℂ`, and lifts the existing group
isomorphism `OctonionMulAutFixingE111 ≃* su3Submonoid` to a group isomorphism
onto Mathlib's `SU(3)`.

This is step 1a of the lane-A consolidation
(`AgentTasks/project-strategic-assessment-2026-07.md`): it connects the
octonion-automorphism `SU(3)` (`G2AutomorphismSU3ActionPackage`) to the
canonical Mathlib `SU(3)`, so downstream work (the `Gauge/` `G_SM`, the GUT
square) can use the standard special-unitary API on the octonion-derived group.

Source: the octonion `SU(3)` construction of Furey / Dixon (`G2ComplexLine`);
the identification here is a clean-room match of `MatrixActsAsSU3OnC3` to
`Matrix.mem_specialUnitaryGroup_iff`. Trusted, kernel-checked, `s o r r y`-free.
-/

open Matrix

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

/-- **1a core**: an element of the octonion `su3Submonoid` is exactly a Mathlib
special-unitary matrix. `MatrixActsAsSU3OnC3 M` unfolds to
`M^dag * M = 1 ∧ det M = 1`, which is `Matrix.mem_specialUnitaryGroup_iff`. -/
theorem mem_su3Submonoid_iff_specialUnitaryGroup (M : Matrix (Fin 3) (Fin 3) ℂ) :
    M ∈ su3Submonoid ↔ M ∈ Matrix.specialUnitaryGroup (Fin 3) ℂ := by
  rw [Matrix.mem_specialUnitaryGroup_iff, Matrix.mem_unitaryGroup_iff']
  constructor
  · intro hM
    refine ⟨?_, hM.det_one⟩
    rw [Matrix.star_eq_conjTranspose]
    exact (matrixActsUnitaryOnC3_iff_conjTranspose_mul M).mp hM.unitary
  · rintro ⟨hu, hd⟩
    refine ⟨?_, hd⟩
    rw [matrixActsUnitaryOnC3_iff_conjTranspose_mul]
    rwa [Matrix.star_eq_conjTranspose] at hu

/-- **1a (headline)**: the octonion-derived `SU(3)` submonoid EQUALS Mathlib's
`Matrix.specialUnitaryGroup (Fin 3) ℂ`. Not merely isomorphic - the same
submonoid of `3 x 3` complex matrices. -/
theorem su3Submonoid_eq_specialUnitaryGroup :
    su3Submonoid = Matrix.specialUnitaryGroup (Fin 3) ℂ := by
  ext M
  exact mem_su3Submonoid_iff_specialUnitaryGroup M

/-- **1a (group isomorphism)**: the octonion automorphisms fixing the complex
structure `e111` are Mathlib's `SU(3)`, as a group isomorphism. Composes the
octonion group iso `OctonionMulAutFixingE111 ≃* su3Submonoid` with the submonoid
equality. This is "`SU(3)` = stabilizer of the complex structure in `Aut(𝕆)`",
landed on the canonical Mathlib `SU(3)`. -/
noncomputable def octonionMulAutFixingE111MulEquivSpecialUnitary :
    OctonionMulAutFixingE111 ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
  octonionMulAutFixingE111MulEquivSU3.trans
    (MulEquiv.submonoidCongr su3Submonoid_eq_specialUnitaryGroup)

end PhysicsSM.Algebra.Octonion.G2ComplexLine
