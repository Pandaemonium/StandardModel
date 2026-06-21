import Mathlib
import PhysicsSM.Spinor.KrasnovComplexStructure
import PhysicsSM.Spinor.KrasnovQubitComplexCoordinates

/-!
# Spinor.KrasnovComplexCentralizer

Real-linear endomorphisms of `𝕆²` that commute with the Krasnov complex
structure `J = rightMulE111` are exactly the complex-linear maps in the
coordinate model determined by `J`.

## Mathematical context

The complex structure `J : 𝕆² → 𝕆²` (componentwise right multiplication
by `e111`) turns `𝕆²` into an 8-dimensional complex vector space via the
scalar action `z • q = z.re • q + z.im • J(q)`. A real-linear map `T`
commutes with `J` if and only if it also commutes with this complex scalar
action for every `z ∈ ℂ`.

The proof is elementary: expand `z = a + bi`, use real-linearity to
distribute `T` over the sum and scalar multiples, and use the commutation
hypothesis `T ∘ J = J ∘ T` to handle the imaginary part.

## Claim boundary

This is a linear-algebra theorem about the Krasnov complex structure. It
does not prove a Clifford algebra representation theorem, a Standard Model
representation theorem, or a physical chirality statement.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Complex scalar action -/

/-- The complex scalar action on `OctonionicQubit` induced by the Krasnov
    complex structure `J = rightMulE111`. For `z = a + bi ∈ ℂ`,
    `complexSmul z q = a • q + b • J(q)`. -/
noncomputable def complexSmul (z : ℂ) (q : OctonionicQubit) : OctonionicQubit :=
  z.re • q + z.im • rightMulE111 q

/-! ## Real-linearity predicate -/

/-- A function `T : 𝕆² → 𝕆²` is real-linear if it preserves the
    componentwise addition and real scalar multiplication on `OctonionicQubit`. -/
def IsRealLinear (T : OctonionicQubit → OctonionicQubit) : Prop :=
  (∀ a b : OctonionicQubit, T (a + b) = T a + T b) ∧
  (∀ (r : ℝ) (q : OctonionicQubit), T (r • q) = r • T q)

/-! ## OctonionicQubit algebra helpers

The `OctonionicQubit` type has `Add`, `SMul ℝ`, `Zero`, and `Neg` instances
but not a full `Module ℝ` instance. We prove the small set of module-like
facts needed for the centralizer theorem. -/

theorem OctonionicQubit_zero_smul (q : OctonionicQubit) :
    (0 : ℝ) • q = 0 := by
  ext <;> simp

theorem OctonionicQubit_one_smul (q : OctonionicQubit) :
    (1 : ℝ) • q = q := by
  ext <;> simp

theorem OctonionicQubit_zero_add (q : OctonionicQubit) :
    (0 : OctonionicQubit) + q = q := by
  ext <;> simp [zero_add]

/-! ## The centralizer theorem -/

/-- **Forward direction**: a real-linear map that commutes with `rightMulE111`
    commutes with the complex scalar action `complexSmul`.

    Proof: expand `complexSmul z q = z.re • q + z.im • J(q)`,
    distribute `T` using real-linearity, and use `T ∘ J = J ∘ T` on the
    imaginary part. -/
theorem commutesWithRightMulE111_complexLinear
    (T : OctonionicQubit → OctonionicQubit)
    (hT_lin : IsRealLinear T)
    (hT_comm : CommutesWithRightMulE111 T)
    (z : ℂ) (q : OctonionicQubit) :
    T (complexSmul z q) = complexSmul z (T q) := by
  have := hT_comm q
  unfold complexSmul at *
  simp_all +decide [hT_lin.1, hT_lin.2]

/-- **Reverse direction**: a real-linear map that commutes with `complexSmul`
    for all `z ∈ ℂ` must commute with `rightMulE111`.

    Proof: take `z = Complex.I`, then `complexSmul I q = rightMulE111 q`,
    so `T (rightMulE111 q) = rightMulE111 (T q)`. -/
theorem complexLinear_commutesWithRightMulE111
    (T : OctonionicQubit → OctonionicQubit)
    (_hT_lin : IsRealLinear T)
    (hT_complex : ∀ z : ℂ, ∀ q : OctonionicQubit,
        T (complexSmul z q) = complexSmul z (T q)) :
    CommutesWithRightMulE111 T := by
  intro q
  convert hT_complex Complex.I q using 1
  · unfold complexSmul
    norm_num [OctonionicQubit_zero_smul,
      OctonionicQubit_one_smul, OctonionicQubit_zero_add]
  · unfold complexSmul
    norm_num
    rw [OctonionicQubit_zero_smul,
      OctonionicQubit_one_smul, OctonionicQubit_zero_add]

/-- **Iff form**: a real-linear map commutes with `rightMulE111` if and only
    if it commutes with `complexSmul` for all `z ∈ ℂ`. -/
theorem commutesWithRightMulE111_iff_complexLinear
    (T : OctonionicQubit → OctonionicQubit)
    (hT_lin : IsRealLinear T) :
    CommutesWithRightMulE111 T ↔
      ∀ z : ℂ, ∀ q : OctonionicQubit,
        T (complexSmul z q) = complexSmul z (T q) :=
  ⟨fun hc z q => commutesWithRightMulE111_complexLinear T hT_lin hc z q,
   fun hcx => complexLinear_commutesWithRightMulE111 T hT_lin hcx⟩

/-! ## Package -/

/-- A package bundling the main result: real-linear endomorphisms that
    commute with `rightMulE111` are complex-linear with respect to
    `complexSmul`. -/
structure KrasnovComplexCentralizerPackage where
  /-- Every real-linear `T` commuting with `rightMulE111` is
      complex-linear. -/
  complex_linear_of_commutes :
    ∀ (T : OctonionicQubit → OctonionicQubit),
      IsRealLinear T →
      CommutesWithRightMulE111 T →
      ∀ (z : ℂ) (q : OctonionicQubit),
        T (complexSmul z q) = complexSmul z (T q)

/-- Witness of the centralizer package. -/
def krasnovComplexCentralizerPackage :
    KrasnovComplexCentralizerPackage where
  complex_linear_of_commutes := fun T hL hC z q =>
    commutesWithRightMulE111_complexLinear T hL hC z q

end PhysicsSM.Spinor.KrasnovComplexStructure
