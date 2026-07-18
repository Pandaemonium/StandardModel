import Mathlib
import PhysicsSM.Algebra.Octonion.Norm

/-!
# The project octonions are a division algebra (composition => no zero divisors)

SM-branch foundation, item 5 (derive the octonionic algebra from the substrate),
2026-07-17. The null-edge mass mechanism is `mass^2 = |wedge|^2`, a MULTIPLICATIVE
norm - the composition law `normSq (x * y) = normSq x * normSq y`
(`Octonion.normSq_mul`, Degen's eight-square identity, landed in `Norm.lean`).
A positive-definite composition norm forces the algebra to have NO zero divisors,
i.e. to be a DIVISION algebra: this is the concrete-octonion instance of the
abstract `PhysicsSM.Algebra.Division.compAlg_no_zero_divisors`, proved here
directly from the landed octonion lemmas without the bundled `EuclideanCompAlg`
typeclass (the `Octonion` type carries `Mul/Add/Neg/SMul` but not the packaged
`NonAssocRing/Module ℝ/Star` the class needs).

This is the item-5 chain made concrete on the project octonions:

  composition (`normSq_mul`) + positive-definite (`normSq_eq_zero`)
    ==> no zero divisors (`octonion_no_zero_divisors`)  ==> a DIVISION algebra.

By Hurwitz's theorem [import; not in Mathlib] the only finite-dimensional real
normed division algebras are `R, C, H, O`, so the mass mechanism CONSTRAINS the
internal algebra to these four - the choice is not free. What is DERIVED here is
the division-algebra property of the octonions from their composition law; what
remains SUPPLIED is Hurwitz's classification itself.

Trusted module: no `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`,
`u n s a f e`, or `n a t i v e _ d e c i d e`. Standard-three axiom guard below.
Clean-room; [orig] formalization, [comp] Hurwitz/Baez for the surrounding theory.
-/

namespace PhysicsSM.Algebra.Octonion

/-- The squared norm of the zero octonion is zero. -/
theorem normSq_zero : normSq (0 : Octonion) = 0 :=
  (normSq_eq_zero 0).mpr rfl

/-- **The composition norm detects zero products.** `normSq (x * y) = 0` iff one
factor vanishes - the norm-level statement of no zero divisors. -/
theorem normSq_mul_eq_zero_iff (x y : Octonion) :
    normSq (x * y) = 0 ↔ x = 0 ∨ y = 0 := by
  rw [normSq_mul, mul_eq_zero, normSq_eq_zero, normSq_eq_zero]

/-- **The project octonions have no zero divisors.** If `x * y = 0` then `x = 0`
or `y = 0`. This is the DIVISION-algebra property, derived from the composition
law `normSq_mul` and positive-definiteness `normSq_eq_zero` - the item-5
mass-mechanism consequence made concrete on the octonions. -/
theorem octonion_no_zero_divisors {x y : Octonion} (h : x * y = 0) :
    x = 0 ∨ y = 0 := by
  refine (normSq_mul_eq_zero_iff x y).mp ?_
  rw [h, normSq_zero]

/-! ### Explicit multiplicative inverses (the full division structure)

The `Octonion` type carries only bare `Mul/Add/Neg/SMul ℝ` operations (no bundled
`MulAction`/`Module`), so the real-scalar/product interactions are proved here at
the coordinate level rather than via Mathlib's `smul_mul` API. -/

/-- Real scalars pull out of the octonion product on the right (`ℝ`-bilinearity of
multiplication). Proved coordinatewise since `Octonion` is not a bundled
`Module ℝ`-algebra. -/
theorem octonion_mul_smul (c : ℝ) (x y : Octonion) :
    x * (c • y) = c • (x * y) := by
  ext <;> simp <;> ring

/-- The multiplicative inverse of an octonion: `x⁻¹ = (1 / normSq x) • conj x`.
For `x = 0` this is `0`; the inverse property holds for `x ≠ 0`. -/
noncomputable def octonionInv (x : Octonion) : Octonion := (1 / normSq x) • conj x

/-- **Every nonzero octonion has a right inverse.** `x * x⁻¹ = 1` for `x ≠ 0`,
with `x⁻¹ = (1 / normSq x) • conj x`. Together with `octonion_no_zero_divisors`
this is the full (non-associative) division-algebra structure - the item-5
mass-mechanism consequence in its strongest concrete form. Uses the landed
norm-form identity `x * conj x = normSq x • 1`. -/
theorem octonion_mul_inv (x : Octonion) (hx : x ≠ 0) :
    x * octonionInv x = 1 := by
  have hN : normSq x ≠ 0 := fun h => hx ((normSq_eq_zero x).mp h)
  have key : x * conj x = normSq x • (1 : Octonion) := (normSq_eq_mul_conj x).symm
  unfold octonionInv
  rw [octonion_mul_smul, key]
  ext <;> simp [hN] <;> exact inv_mul_cancel₀ hN

end PhysicsSM.Algebra.Octonion

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Algebra.Octonion.octonion_no_zero_divisors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Octonion.octonion_no_zero_divisors

/-- info: 'PhysicsSM.Algebra.Octonion.octonion_mul_inv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Algebra.Octonion.octonion_mul_inv
