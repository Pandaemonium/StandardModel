import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivation
import PhysicsSM.Algebra.Jordan.InnerDerivationJacobiLie
import PhysicsSM.Algebra.Jordan.TraceForm

/-!
# Algebra.Jordan.DerivationTraceAntisymmetry

Inner derivations of the exceptional Jordan algebra `h₃(𝕆)` are antisymmetric
with respect to the trace form.

## Mathematical context

The trace form `T(A, B) = tr(A ○ B)` on the Albert algebra satisfies the
**Frobenius identity**:

```text
T(A ○ B, C) = T(A, B ○ C)
```

This is the associativity of the trace form. Combined with commutativity of
`○` and symmetry of `T`, it immediately implies:

1. **Inner derivations are traceless**: `T(D_{a,b}(c), 1) = 0`.
2. **Inner derivations are trace-form antisymmetric**:
   `T(D_{a,b}(x), y) + T(x, D_{a,b}(y)) = 0`.

Both properties extend by linearity to the linear span of inner derivations.

## Main results

- `traceForm_frobenius` — the Frobenius identity for the trace form.
- `traceForm_oneH3O_right` — `T(a, 1) = tr(a)`.
- `traceForm_sub_left` — linearity of the trace form.
- `innerDerivation_trace_zero` — inner derivations are traceless.
- `innerDerivation_traceForm_antisymm` — trace-form antisymmetry.
- `innerDerivationSubspace_traceForm_antisymm` — antisymmetry for the span.
- `derivationTraceAntisymmetryPackage` — bundled package.

## Status

Trusted module — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan
open PhysicsSM.Algebra.Octonion

local infixl:70 " ○ " => jordanProduct

/-! ## Helper lemmas -/

/-- The trace form against the Jordan unit equals the trace. -/
theorem traceForm_oneH3O_right (a : H3O) : traceForm a oneH3O = trace a := by
  simp [traceForm_eq, oneH3O, octonionInner, trace]

/-- The trace form against the Jordan unit equals the trace (left). -/
theorem traceForm_oneH3O_left (a : H3O) : traceForm oneH3O a = trace a := by
  rw [traceForm_symm]; exact traceForm_oneH3O_right a

/-- The trace form is compatible with subtraction (left). -/
theorem traceForm_sub_left (a₁ a₂ b : H3O) :
    traceForm (a₁ - a₂) b = traceForm a₁ b - traceForm a₂ b := by
  rw [show a₁ - a₂ = a₁ + (-a₂) from rfl, traceForm_add_left, traceForm_neg_left]
  ring

/-- The trace form is compatible with subtraction (right). -/
theorem traceForm_sub_right (a b₁ b₂ : H3O) :
    traceForm a (b₁ - b₂) = traceForm a b₁ - traceForm a b₂ := by
  rw [show b₁ - b₂ = b₁ + (-b₂) from rfl, traceForm_add_right, traceForm_neg_right]
  ring

/-! ## Frobenius identity -/

set_option maxHeartbeats 1600000 in
-- The coordinate Frobenius identity expands all entries of `h3(O)`; after
-- expansion the goal is a large real polynomial identity discharged by `ring`.
/-- The Frobenius identity for the trace form:
`T(A ○ B, C) = T(A, B ○ C)`.

This is the associativity of the trace form on `h₃(𝕆)`. The proof
proceeds by expanding all coordinates (3 real diagonal + 3 × 8 octonion
= 27 coordinates per element) and verifying the resulting polynomial
identity with `ring`. -/
theorem traceForm_frobenius (a b c : H3O) :
    traceForm (a ○ b) c = traceForm a (b ○ c) := by
  simp only [traceForm_eq, jordanProduct,
    octonionInner, conj,
    Octonion.smul_c0, Octonion.smul_c1, Octonion.smul_c2, Octonion.smul_c3,
    Octonion.smul_c4, Octonion.smul_c5, Octonion.smul_c6, Octonion.smul_c7,
    Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3,
    Octonion.add_c4, Octonion.add_c5, Octonion.add_c6, Octonion.add_c7,
    Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2, Octonion.mul_c3,
    Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6, Octonion.mul_c7]
  ring

/-! ## Inner derivations are traceless -/

/-- Inner derivations are traceless against the Jordan unit:
`T(D_{a,b}(c), 1) = 0`.

**Proof.** By Frobenius, `T(a, b ○ c) = T(a ○ b, c)` and
`T(b, a ○ c) = T(b ○ a, c) = T(a ○ b, c)` (using commutativity).
Hence `T(D_{a,b}(c), 1) = T(a ○ (b ○ c), 1) - T(b ○ (a ○ c), 1)
= trace(a ○ (b ○ c)) - trace(b ○ (a ○ c))
= T(a, b ○ c) - T(b, a ○ c)
= T(a ○ b, c) - T(a ○ b, c) = 0`. -/
theorem innerDerivation_trace_zero (a b c : H3O) :
    traceForm ((innerDerivation a b).toFun c) oneH3O = 0 := by
  simp only [innerDerivation_apply]
  rw [traceForm_sub_left, traceForm_oneH3O_right, traceForm_oneH3O_right]
  -- Need: trace(a ○ (b ○ c)) = trace(b ○ (a ○ c))
  -- trace(u ○ v) = traceForm u v, so this is traceForm a (b ○ c) = traceForm b (a ○ c)
  -- By Frobenius: traceForm a (b ○ c) = traceForm (a ○ b) c
  --              traceForm b (a ○ c) = traceForm (b ○ a) c = traceForm (a ○ b) c
  have h1 : trace (a ○ (b ○ c)) = traceForm a (b ○ c) := by
    rw [← traceForm_oneH3O_right]; rw [traceForm_symm]; rw [traceForm_oneH3O_left]
    rfl
  have h2 : trace (b ○ (a ○ c)) = traceForm b (a ○ c) := by
    rw [← traceForm_oneH3O_right]; rw [traceForm_symm]; rw [traceForm_oneH3O_left]
    rfl
  rw [h1, h2]
  rw [← traceForm_frobenius a b c, ← traceForm_frobenius b a c]
  rw [jordanProduct_comm b a]
  ring

/-! ## Inner derivations are trace-form antisymmetric -/

/-- Inner derivations are antisymmetric for the trace form:
`T(D_{a,b}(x), y) + T(x, D_{a,b}(y)) = 0`.

**Proof.** Expanding the inner derivation and using bilinearity:
```
  T(a ○ (b ○ x), y) − T(b ○ (a ○ x), y) + T(x, a ○ (b ○ y)) − T(x, b ○ (a ○ y))
```
By Frobenius and symmetry, each pair reduces to a `T(a ○ u, b ○ v)` term,
and the four terms cancel pairwise. -/
theorem innerDerivation_traceForm_antisymm (a b x y : H3O) :
    traceForm ((innerDerivation a b).toFun x) y +
      traceForm x ((innerDerivation a b).toFun y) = 0 := by
  simp only [innerDerivation_apply]
  rw [traceForm_sub_left, traceForm_sub_right]
  -- Goal: traceForm (a ○ (b ○ x)) y - traceForm (b ○ (a ○ x)) y +
  --       (traceForm x (a ○ (b ○ y)) - traceForm x (b ○ (a ○ y))) = 0
  -- By Frobenius: traceForm (u ○ v) w = traceForm u (v ○ w)
  -- Term 1: traceForm (a ○ (b ○ x)) y = traceForm a ((b ○ x) ○ y)
  -- Term 2: traceForm (b ○ (a ○ x)) y = traceForm b ((a ○ x) ○ y)
  -- Term 3: traceForm x (a ○ (b ○ y)) = traceForm (x ○ a) (b ○ y) [reverse Frobenius]
  --       = traceForm (a ○ x) (b ○ y)
  -- Term 4: traceForm x (b ○ (a ○ y)) = traceForm (x ○ b) (a ○ y)
  --       = traceForm (b ○ x) (a ○ y)
  rw [traceForm_frobenius a (b ○ x) y,
      traceForm_frobenius b (a ○ x) y]
  rw [traceForm_symm x (a ○ (b ○ y)),
      traceForm_frobenius a (b ○ y) x]
  rw [traceForm_symm x (b ○ (a ○ y)),
      traceForm_frobenius b (a ○ y) x]
  -- Now use Frobenius again:
  -- traceForm a ((b ○ x) ○ y) = traceForm (a ○ (b ○ x)) y ... hmm circular
  -- Let me use Frobenius on the remaining terms differently
  -- After the rewrites, we have:
  -- traceForm a ((b ○ x) ○ y) - traceForm b ((a ○ x) ○ y) +
  -- (traceForm a ((b ○ y) ○ x) - traceForm b ((a ○ y) ○ x)) = 0
  -- Group: traceForm a ((b ○ x) ○ y + (b ○ y) ○ x) - traceForm b ((a ○ x) ○ y + (a ○ y) ○ x) = 0
  -- Apply Frobenius once more:
  -- traceForm a ((b ○ x) ○ y) = traceForm (a ○ (b ○ x)) y — but that's circular.
  -- Instead: traceForm a ((b ○ x) ○ y) = traceForm a (y ○ (b ○ x)) [commutativity]
  --        = traceForm (a ○ y) (b ○ x) [Frobenius reversed]
  -- And: traceForm a ((b ○ y) ○ x) = traceForm a (x ○ (b ○ y))
  --     = traceForm (a ○ x) (b ○ y) [Frobenius reversed]
  -- So sum = traceForm (a ○ y) (b ○ x) + traceForm (a ○ x) (b ○ y)
  --        - traceForm (b ○ y) (a ○ x) - traceForm (b ○ x) (a ○ y) = 0
  -- by symmetry of T.
  rw [jordanProduct_comm (b ○ x) y, ← traceForm_frobenius a y (b ○ x)]
  rw [jordanProduct_comm (a ○ x) y, ← traceForm_frobenius b y (a ○ x)]
  rw [jordanProduct_comm (b ○ y) x, ← traceForm_frobenius a x (b ○ y)]
  rw [jordanProduct_comm (a ○ y) x, ← traceForm_frobenius b x (a ○ y)]
  rw [traceForm_symm (a ○ y) (b ○ x)]
  rw [traceForm_symm (b ○ y) (a ○ x)]
  ring

/-! ## Extension to the linear span -/

/-- Trace-form antisymmetry extends to the linear span of inner derivations.

Any element of the inner derivation subspace (i.e., any finite linear
combination of inner derivations `D_{aᵢ,bᵢ}`) is antisymmetric for the
trace form. -/
theorem innerDerivationSubspace_traceForm_antisymm
    {D : H3ODerivation}
    (hD : D ∈ innerDerivationSubspace) (x y : H3O) :
    traceForm (D.toFun x) y + traceForm x (D.toFun y) = 0 := by
  refine Submodule.span_induction
    (p := fun D _ => traceForm (D.toFun x) y + traceForm x (D.toFun y) = 0)
    ?_ ?_ ?_ ?_ hD
  · -- Generator case: D = innerDerivation a b
    intro D' hD'
    obtain ⟨a, b, rfl⟩ := hD'
    exact innerDerivation_traceForm_antisymm a b x y
  · -- Zero case
    simp
  · -- Addition case
    intro D₁ D₂ _ _ h₁ h₂
    simp only [H3ODerivation.add_apply, traceForm_add_left, traceForm_add_right]
    linarith
  · -- Scalar multiplication case
    intro r D' _ h'
    simp only [H3ODerivation.smul_apply, traceForm_smul_left, traceForm_smul_right]
    have : r * traceForm (D'.toFun x) y + r * traceForm x (D'.toFun y) =
        r * (traceForm (D'.toFun x) y + traceForm x (D'.toFun y)) := by ring
    rw [this, h', mul_zero]

/-! ## Bundled package -/

/-- Bundled package of the trace-form antisymmetry results for inner
derivations of `h₃(𝕆)`. -/
structure DerivationTraceAntisymmetryPackage where
  /-- Inner derivations are traceless against the Jordan unit. -/
  inner_trace_zero :
    ∀ a b c : H3O,
      traceForm ((innerDerivation a b).toFun c) oneH3O = 0
  /-- Inner derivations are antisymmetric for the trace form. -/
  inner_antisymm :
    ∀ a b x y : H3O,
      traceForm ((innerDerivation a b).toFun x) y +
        traceForm x ((innerDerivation a b).toFun y) = 0
  /-- The span of inner derivations is trace-form antisymmetric. -/
  span_antisymm :
    ∀ (D' : H3ODerivation),
      D' ∈ innerDerivationSubspace →
      ∀ x y : H3O,
        traceForm (D'.toFun x) y + traceForm x (D'.toFun y) = 0

/-- The bundled trace-form antisymmetry package for inner derivations
of `h₃(𝕆)`. -/
noncomputable def derivationTraceAntisymmetryPackage :
    DerivationTraceAntisymmetryPackage where
  inner_trace_zero := innerDerivation_trace_zero
  inner_antisymm := innerDerivation_traceForm_antisymm
  span_antisymm _D hD x y := innerDerivationSubspace_traceForm_antisymm hD x y

end PhysicsSM.Algebra.Jordan.H3O
