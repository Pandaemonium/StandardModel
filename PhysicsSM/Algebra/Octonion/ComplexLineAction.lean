import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra
import PhysicsSM.Algebra.Octonion.ComplexTripleModule

/-!
# Algebra.Octonion.ComplexLineAction

Left multiplication by an element of the chosen complex line acts on the
complement `ℂ³` as ordinary complex scalar multiplication on the three
complex coordinates.

## Mathematical context

Baez (2021) chooses a unit imaginary octonion `i = e111` and considers the
copy of the complex numbers `ℂ_i = span_ℝ {1, e111}`. The complement
`ℂ_⊥ ≅ ℂ³` carries a natural complex structure from left multiplication
by `e111`.

This module proves that left multiplication by an arbitrary element
`z ∈ ℂ_i` on a complement element `w ∈ ℂ_⊥` produces coordinate-wise
complex scalar multiplication: the `k`-th complex coordinate of the
product `z · w` (viewed in `ℂ³`) equals `z * wₖ`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021;
Dubois-Violette and Todorov, arXiv:1806.09450.

Claim boundary: explicit coordinate multiplication theorem only.
No stabilizer, SU(3), or Standard Model gauge group claims.

Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Main declarations:
- `ChosenComplex.smulComplexTriple`
- `ChosenComplex.toComplex_smulComplexTriple`
- `ChosenComplex.smulComplexTriple_toOctonion`
- `ChosenComplex.left_mul_complement_toComplexTriple`
- `ChosenComplex.one_smulComplexTriple`
- `ChosenComplex.mul_smulComplexTriple`

Status: trusted — no s o r r y.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Definition: chosen complex line action on the complement -/

/-- The action of the chosen complex line on the complement by complex
    scalar multiplication. Given `z ∈ ChosenComplex` and `w ∈ ComplexTriple`,
    the result is coordinate-wise multiplication by `z.toComplex`. -/
noncomputable def ChosenComplex.smulComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) : ComplexTriple :=
  ComplexTriple.complexSmul z.toComplex w

/-! ## Coordinate compatibility -/

/-- The complex-vector coordinates of `z.smulComplexTriple w` are given by
    pointwise multiplication: `(z · w)ₖ = z.toComplex * wₖ`. -/
theorem ChosenComplex.toComplex_smulComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) :
    (z.smulComplexTriple w).toComplexVec =
      fun k => z.toComplex * w.toComplexVec k := by
  exact List.ofFn_inj.mp rfl

/-! ## Main theorem: octonion multiplication compatibility -/

/-- Left multiplication by a chosen-complex-line element on a complement
    element, computed in the octonions, agrees with the complex scalar
    multiplication `smulComplexTriple`.

    This is the key theorem: the octonionic product `z.toOctonion * w.toOctonion`
    equals `(z.smulComplexTriple w).toOctonion`, i.e., the octonion product
    of a line element and a complement element lands back in the complement
    and acts as coordinate-wise complex multiplication. -/
theorem ChosenComplex.smulComplexTriple_toOctonion
    (z : ChosenComplex) (w : ComplexTriple) :
    (z.smulComplexTriple w).toOctonion =
      z.toOctonion * w.toOctonion := by
  unfold ChosenComplex.smulComplexTriple
  unfold ComplexTriple.complexSmul
  unfold ChosenComplex.toOctonion ComplexTriple.toOctonion
  congr <;> ring!

/-! ## Projected-coordinate version -/

/-- The complement projection of the octonionic product
    `z.toOctonion * w.toOctonion` equals `z.smulComplexTriple w`.
    This is the inverse direction of `smulComplexTriple_toOctonion`,
    using the round-trip property. -/
theorem ChosenComplex.left_mul_complement_toComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) :
    (z.toOctonion * w.toOctonion).toComplexTriple =
      z.smulComplexTriple w := by
  convert ComplexTriple.roundtrip (z.smulComplexTriple w) using 1
  rw [ChosenComplex.smulComplexTriple_toOctonion]

/-! ## Structural lemmas -/

/-- The identity element `1 : ChosenComplex` acts trivially on
    complement elements. -/
theorem ChosenComplex.one_smulComplexTriple (w : ComplexTriple) :
    (1 : ChosenComplex).smulComplexTriple w = w := by
  unfold smulComplexTriple
  rw [toComplex_one]
  apply ComplexTriple.complexSmul_one

/-- The action is compatible with multiplication in `ChosenComplex`:
    `(z₁ * z₂) · w = z₁ · (z₂ · w)`. -/
theorem ChosenComplex.mul_smulComplexTriple
    (z1 z2 : ChosenComplex) (w : ComplexTriple) :
    (z1 * z2).smulComplexTriple w =
      z1.smulComplexTriple (z2.smulComplexTriple w) := by
  simp only [smulComplexTriple, toComplex_mul]
  exact (ComplexTriple.complexSmul_complexSmul z1.toComplex z2.toComplex w).symm

end PhysicsSM.Algebra.Octonion
