import Mathlib
import PhysicsSM.Algebra.Jordan.ComplementJordanModule

/-!
# Counterexample: complement ○ complement ⊄ h₃(ℂ)

The complement of `h₃(ℂ)` in `h₃(𝕆)` is a Jordan module over `h₃(ℂ)`
(proved in `ComplementJordanModule.lean`), but the complement is **not**
closed into `h₃(ℂ)` under the Jordan product of two complement elements.

This file provides a trusted, explicit counterexample: two elements
`X, Y ∈ InComplementOfB` whose Jordan product `X ○ Y` is not in
`InStandardB`.

## The counterexample

- `X` has `z = e₀₀₁` (the `c1` basis vector) and all other coordinates zero.
- `Y` has `y = e₀₁₀` (the `c2` basis vector) and all other coordinates zero.

Both lie in the complement (zero diagonal, off-diagonal entries have
`c0 = c7 = 0`). Their Jordan product has `x`-coordinate equal to
`(1/2) · e₀₁₁`, which has nonzero `c3` and therefore does not lie in the
chosen complex line `span_ℝ{1, e₁₁₁}`.

## Claim boundary

This file records a coordinate-level negative result for the project's
chosen `InComplementOfB` predicate and octonion convention. It does not
claim anything about the full Dubois-Violette–Todorov group theorem.

## Status

Trusted module — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

local infixl:70 " ○ " => jordanProduct

/-! ## Counterexample elements -/

/-- Complement element with `z = e₀₀₁` (`c1 = 1`), all else zero. -/
def complementCounterexampleX : H3O where
  alpha := 0
  beta := 0
  gamma := 0
  x := 0
  y := 0
  z := ⟨0, 1, 0, 0, 0, 0, 0, 0⟩

/-- Complement element with `y = e₀₁₀` (`c2 = 1`), all else zero. -/
def complementCounterexampleY : H3O where
  alpha := 0
  beta := 0
  gamma := 0
  x := 0
  y := ⟨0, 0, 1, 0, 0, 0, 0, 0⟩
  z := 0

/-! ## Membership proofs -/

/-- `complementCounterexampleX` lies in the complement of `h₃(ℂ)`. -/
theorem complementCounterexampleX_mem :
    InComplementOfB complementCounterexampleX := by
  refine ⟨rfl, rfl, rfl, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- `complementCounterexampleY` lies in the complement of `h₃(ℂ)`. -/
theorem complementCounterexampleY_mem :
    InComplementOfB complementCounterexampleY := by
  refine ⟨rfl, rfl, rfl, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-! ## The counterexample theorem -/

/-- The Jordan product of the two complement counterexample elements
    is **not** in `InStandardB`. The `x`-coordinate of the product
    has `c3 = 1/2 ≠ 0`, violating `InChosenComplexLine`. -/
theorem complementCounterexample_product_not_standardB :
    ¬ InStandardB (complementCounterexampleX ○ complementCounterexampleY) := by
  intro ⟨hx, _, _⟩
  simp only [jordanProduct, complementCounterexampleX, complementCounterexampleY,
    octonionInner, conj, InChosenComplexLine] at hx
  simp +decide at hx

/-- There exist complement elements whose Jordan product is not in `h₃(ℂ)`.
    This refutes the claim that complement ○ complement ⊆ h₃(ℂ). -/
theorem not_forall_complement_complement_product_standardB :
    ¬ (∀ X Y : H3O,
      InComplementOfB X → InComplementOfB Y →
        InStandardB (X ○ Y)) := by
  intro h
  exact complementCounterexample_product_not_standardB
    (h _ _ complementCounterexampleX_mem complementCounterexampleY_mem)

/-! ## Conservative decomposition: the product still splits canonically -/

/-- Any Jordan product decomposes as its `h₃(ℂ)` part plus its complement
    part. This gives the paper a clean way to express the failed closure:
    the complement ○ complement product always has a canonical
    standard/complement decomposition, even though it does not land
    entirely in `h₃(ℂ)`. -/
theorem complement_product_decomposes (X Y : H3O) :
    X ○ Y = toH3CPart (X ○ Y) + toComplementPart (X ○ Y) :=
  decomp_sum (X ○ Y)

end PhysicsSM.Algebra.Jordan.H3O
