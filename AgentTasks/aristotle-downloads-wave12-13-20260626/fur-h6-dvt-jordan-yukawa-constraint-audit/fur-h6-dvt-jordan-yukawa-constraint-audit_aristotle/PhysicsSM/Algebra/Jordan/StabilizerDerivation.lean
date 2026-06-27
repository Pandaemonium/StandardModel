import Mathlib
import PhysicsSM.Algebra.Jordan.H3O

/-!
# Algebra.Jordan.StabilizerDerivation

Derivation stabilizers of standard subalgebra blocks in `h₃(𝕆)`.

## Overview

A **derivation** of the exceptional Jordan algebra `h₃(𝕆)` is a real-linear
map `D : H3O → H3O` satisfying the Leibniz rule for the Jordan product:

```text
D(a ○ b) = D(a) ○ b + a ○ D(b)
```

A derivation **stabilizes** a subset `S ⊆ H3O` if `D` maps `S` into `S`.
The stabilizer of `S` in the space of derivations is the set of all
derivations stabilizing `S`; it is closed under zero, addition, negation,
and the commutator bracket `[D₁, D₂] = D₁ ∘ D₂ - D₂ ∘ D₁`.

This module defines:
- `H3ODerivation` — the type of derivations of `h₃(𝕆)`.
- `DerivationStabilizesSet` — the predicate for stabilization.
- `standardA_derivationStabilizer` — derivations stabilizing the `h₂(𝕆)` block.
- `standardB_derivationStabilizer` — derivations stabilizing the `h₃(ℂ)` block.
- `standardAInterB_derivationStabilizer` — derivations stabilizing `h₂(ℂ)`.
- Commutator-closure theorems for each stabilizer.

## Claim boundary

This is an **algebraic stabilizer precursor only**. No claims are made about
`F₄`, `Spin(9)`, or Standard Model gauge-group isomorphisms. The derivation
stabilizer is the Lie-algebraic analogue of the automorphism stabilizer
already defined in `ProjectiveGeometry.lean`.

## Status

This is a **trusted** module: all definitions and theorems are fully proved.
-/

namespace PhysicsSM.Algebra.Jordan.StabilizerDerivation

open PhysicsSM.Algebra.Jordan.H3O

local infixl:70 " ○ " => jordanProduct

/-! ## H3O scalar lemmas -/

private theorem H3O_zero_smul (a : H3O) : (0 : ℝ) • a = 0 := by
  ext <;> simp

private theorem H3O_neg_one_smul (a : H3O) : (-1 : ℝ) • a = -a := by
  ext <;> simp

/-! ## Jordan product linearity

These lemmas establish that the Jordan product is bilinear with respect
to the coordinatewise linear structure on `H3O`. Each is proved by
expanding coordinates and applying `ring`.
-/

set_option maxHeartbeats 800000 in
-- The off-diagonal octonion coordinate expressions are large after expansion.
/--
The Jordan product is additive in the left argument.
-/
theorem jordanProduct_add_left (a b c : H3O) :
    (a + b) ○ c = a ○ c + b ○ c := by
  unfold jordanProduct
  ext <;> simp [octonionInner] <;> ring

/--
The Jordan product is additive in the right argument.
-/
theorem jordanProduct_add_right (a b c : H3O) :
    a ○ (b + c) = a ○ b + a ○ c := by
  rw [jordanProduct_comm a (b + c), jordanProduct_add_left,
      jordanProduct_comm b a, jordanProduct_comm c a]

set_option maxHeartbeats 800000 in
-- The off-diagonal octonion coordinate expressions are large after expansion.
/--
The Jordan product scales in the left argument.
-/
theorem jordanProduct_smul_left (r : ℝ) (a b : H3O) :
    (r • a) ○ b = r • (a ○ b) := by
  unfold jordanProduct
  ext <;> simp [octonionInner] <;> ring

/--
The Jordan product scales in the right argument.
-/
theorem jordanProduct_smul_right (r : ℝ) (a b : H3O) :
    a ○ (r • b) = r • (a ○ b) := by
  rw [← jordanProduct_comm, jordanProduct_smul_left, jordanProduct_comm]

/-- The Jordan product with zero on the left is zero. -/
@[simp]
theorem jordanProduct_zero_left (a : H3O) : (0 : H3O) ○ a = 0 := by
  conv_lhs => rw [show (0 : H3O) = (0 : ℝ) • a from (H3O_zero_smul a).symm]
  rw [jordanProduct_smul_left, H3O_zero_smul]

/-- The Jordan product with zero on the right is zero. -/
@[simp]
theorem jordanProduct_zero_right (a : H3O) : a ○ (0 : H3O) = 0 := by
  rw [jordanProduct_comm, jordanProduct_zero_left]

/-- The Jordan product is negation-compatible on the left. -/
theorem jordanProduct_neg_left (a b : H3O) :
    (-a) ○ b = -(a ○ b) := by
  rw [show -a = (-1 : ℝ) • a from (H3O_neg_one_smul a).symm]
  rw [jordanProduct_smul_left, H3O_neg_one_smul]

/-- The Jordan product is negation-compatible on the right. -/
theorem jordanProduct_neg_right (a b : H3O) :
    a ○ (-b) = -(a ○ b) := by
  rw [jordanProduct_comm, jordanProduct_neg_left, jordanProduct_comm]

/-! ## Derivation type -/

/--
A derivation of the exceptional Jordan algebra `h₃(𝕆)`.

This is a real-linear endomorphism satisfying the Leibniz rule
`D(a ○ b) = D(a) ○ b + a ○ D(b)` for the Jordan product.
-/
structure H3ODerivation where
  /-- The underlying function. -/
  toFun : H3O → H3O
  /-- Additivity. -/
  map_add : ∀ a b, toFun (a + b) = toFun a + toFun b
  /-- Real-scalar compatibility. -/
  map_smul : ∀ (r : ℝ) a, toFun (r • a) = r • toFun a
  /-- The Leibniz rule for the Jordan product. -/
  leibniz : ∀ a b, toFun (a ○ b) = toFun a ○ b + a ○ toFun b

instance : CoeFun H3ODerivation (fun _ => H3O → H3O) where
  coe D := D.toFun

@[ext]
theorem H3ODerivation.ext {D₁ D₂ : H3ODerivation}
    (h : ∀ a, D₁ a = D₂ a) : D₁ = D₂ := by
  cases D₁; cases D₂
  simp only [mk.injEq]
  funext a
  exact h a

/-- A derivation maps zero to zero. -/
theorem H3ODerivation.map_zero (D : H3ODerivation) : D (0 : H3O) = 0 := by
  have h0 : (0 : H3O) = (0 : ℝ) • (0 : H3O) := (H3O_zero_smul _).symm
  conv_lhs => rw [h0]
  rw [D.map_smul]
  exact H3O_zero_smul _

/-- A derivation preserves negation. -/
theorem H3ODerivation.map_neg (D : H3ODerivation) (a : H3O) :
    D (-a) = -D a := by
  rw [show -a = (-1 : ℝ) • a from (H3O_neg_one_smul a).symm]
  rw [D.map_smul, H3O_neg_one_smul]

/-! ## Basic derivation operations -/

/-- The zero derivation. -/
instance : Zero H3ODerivation where
  zero :=
    { toFun := fun _ => 0
      map_add := fun _ _ => by ext <;> simp
      map_smul := fun _ _ => by ext <;> simp
      leibniz := fun a b => by
        show (0 : H3O) = (0 : H3O) ○ b + a ○ (0 : H3O)
        rw [jordanProduct_zero_left, jordanProduct_zero_right]
        ext <;> simp }

@[simp] theorem H3ODerivation.zero_apply (a : H3O) :
    (0 : H3ODerivation) a = 0 := rfl

/-- Addition of derivations. -/
instance : Add H3ODerivation where
  add D₁ D₂ :=
    { toFun := fun a => D₁ a + D₂ a
      map_add := fun a b => by
        show D₁.toFun (a + b) + D₂.toFun (a + b) =
          (D₁.toFun a + D₂.toFun a) + (D₁.toFun b + D₂.toFun b)
        rw [D₁.map_add, D₂.map_add]; ext <;> simp <;> ring
      map_smul := fun r a => by
        show D₁.toFun (r • a) + D₂.toFun (r • a) =
          r • (D₁.toFun a + D₂.toFun a)
        rw [D₁.map_smul, D₂.map_smul]; ext <;> simp <;> ring
      leibniz := fun a b => by
        show D₁.toFun (a ○ b) + D₂.toFun (a ○ b) =
          (D₁.toFun a + D₂.toFun a) ○ b + a ○ (D₁.toFun b + D₂.toFun b)
        rw [D₁.leibniz, D₂.leibniz]
        rw [jordanProduct_add_left, jordanProduct_add_right]
        ext <;> simp <;> ring }

@[simp] theorem H3ODerivation.add_apply (D₁ D₂ : H3ODerivation) (a : H3O) :
    (D₁ + D₂) a = D₁ a + D₂ a := rfl

/-- Negation of derivations. -/
instance : Neg H3ODerivation where
  neg D :=
    { toFun := fun a => -D a
      map_add := fun a b => by
        show -(D.toFun (a + b)) = -(D.toFun a) + -(D.toFun b)
        rw [D.map_add]; ext <;> simp <;> ring
      map_smul := fun r a => by
        show -(D.toFun (r • a)) = r • -(D.toFun a)
        rw [D.map_smul]; ext <;> simp
      leibniz := fun a b => by -- Leibniz: -(D(a ○ b)) = -(Da) ○ b + a ○ -(Db)
        show -(D.toFun (a ○ b)) = -(D.toFun a) ○ b + a ○ -(D.toFun b)
        rw [D.leibniz, jordanProduct_neg_left, jordanProduct_neg_right]
        ext <;> simp [add_comm] }

@[simp] theorem H3ODerivation.neg_apply (D : H3ODerivation) (a : H3O) :
    (-D) a = -D a := rfl

/-! ## Commutator of derivations -/

/--
The commutator of two derivations: `[D₁, D₂] = D₁ ∘ D₂ - D₂ ∘ D₁`.

The commutator of two derivations of a Jordan algebra is again a derivation.
This is a standard result whose proof uses bilinearity of the Jordan product
and the Leibniz rule for each factor.
-/
def commutator (D₁ D₂ : H3ODerivation) : H3ODerivation where
  toFun := fun a => D₁ (D₂ a) + -(D₂ (D₁ a))
  map_add := fun a b => by
    show D₁.toFun (D₂.toFun (a + b)) + -(D₂.toFun (D₁.toFun (a + b))) =
      (D₁.toFun (D₂.toFun a) + -(D₂.toFun (D₁.toFun a))) +
      (D₁.toFun (D₂.toFun b) + -(D₂.toFun (D₁.toFun b)))
    rw [D₂.map_add, D₁.map_add, D₁.map_add, D₂.map_add]
    ext <;> simp <;> ring
  map_smul := fun r a => by
    show D₁.toFun (D₂.toFun (r • a)) + -(D₂.toFun (D₁.toFun (r • a))) =
      r • (D₁.toFun (D₂.toFun a) + -(D₂.toFun (D₁.toFun a)))
    rw [D₂.map_smul, D₁.map_smul, D₁.map_smul, D₂.map_smul]
    ext <;> simp <;> ring
  leibniz := fun a b => by
    simp only [H3ODerivation.leibniz, jordanProduct_add_left, jordanProduct_neg_left,
        jordanProduct_add_right, jordanProduct_neg_right]
    rw [D₁.map_add, D₂.map_add]
    simp only [H3ODerivation.leibniz]
    ext <;> simp <;> ring

/-! ## Stabilizer predicate -/

/--
A derivation stabilizes a set `S ⊆ H3O` if it maps every element of `S`
back into `S`.
-/
def DerivationStabilizesSet (D : H3ODerivation) (S : Set H3O) : Prop :=
  ∀ a, a ∈ S → D a ∈ S

/-! ## Standard-block stabilizer definitions -/

/-- The set of derivations that stabilize the `h₂(𝕆)` block. -/
def standardA_derivationStabilizer : Set H3ODerivation :=
  {D | DerivationStabilizesSet D {a | InStandardA a}}

/-- The set of derivations that stabilize the `h₃(ℂ)` block. -/
def standardB_derivationStabilizer : Set H3ODerivation :=
  {D | DerivationStabilizesSet D {a | InStandardB a}}

/-- The set of derivations that stabilize the `h₂(ℂ)` intersection. -/
def standardAInterB_derivationStabilizer : Set H3ODerivation :=
  {D | DerivationStabilizesSet D {a | InStandardAInterB a}}

/-! ## Zero membership in each stabilizer -/

theorem zero_mem_standardA_derivationStabilizer :
    (0 : H3ODerivation) ∈ standardA_derivationStabilizer :=
  fun _ _ => zero_inStandardA

theorem zero_mem_standardB_derivationStabilizer :
    (0 : H3ODerivation) ∈ standardB_derivationStabilizer :=
  fun _ _ => zero_inStandardB

theorem zero_mem_standardAInterB_derivationStabilizer :
    (0 : H3ODerivation) ∈ standardAInterB_derivationStabilizer :=
  fun _ _ => zero_inStandardAInterB

/-! ## Addition closure for each stabilizer -/

theorem add_mem_standardA_derivationStabilizer
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardA_derivationStabilizer)
    (h₂ : D₂ ∈ standardA_derivationStabilizer) :
    D₁ + D₂ ∈ standardA_derivationStabilizer :=
  fun a ha => add_mem_standardA (h₁ a ha) (h₂ a ha)

theorem add_mem_standardB_derivationStabilizer
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardB_derivationStabilizer)
    (h₂ : D₂ ∈ standardB_derivationStabilizer) :
    D₁ + D₂ ∈ standardB_derivationStabilizer :=
  fun a ha => add_mem_standardB (h₁ a ha) (h₂ a ha)

theorem add_mem_standardAInterB_derivationStabilizer
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardAInterB_derivationStabilizer)
    (h₂ : D₂ ∈ standardAInterB_derivationStabilizer) :
    D₁ + D₂ ∈ standardAInterB_derivationStabilizer :=
  fun a ha => ⟨add_mem_standardA (h₁ a ha).1 (h₂ a ha).1,
               add_mem_standardB (h₁ a ha).2 (h₂ a ha).2⟩

/-! ## Negation closure for each stabilizer -/

theorem neg_mem_standardA_derivationStabilizer
    {D : H3ODerivation}
    (h : D ∈ standardA_derivationStabilizer) :
    -D ∈ standardA_derivationStabilizer :=
  fun a ha => neg_mem_standardA (h a ha)

theorem neg_mem_standardB_derivationStabilizer
    {D : H3ODerivation}
    (h : D ∈ standardB_derivationStabilizer) :
    -D ∈ standardB_derivationStabilizer :=
  fun a ha => neg_mem_standardB (h a ha)

theorem neg_mem_standardAInterB_derivationStabilizer
    {D : H3ODerivation}
    (h : D ∈ standardAInterB_derivationStabilizer) :
    -D ∈ standardAInterB_derivationStabilizer :=
  fun a ha => ⟨neg_mem_standardA (h a ha).1, neg_mem_standardB (h a ha).2⟩

/-! ## Commutator closure for each stabilizer -/

theorem commutator_mem_standardA_derivationStabilizer
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardA_derivationStabilizer)
    (h₂ : D₂ ∈ standardA_derivationStabilizer) :
    commutator D₁ D₂ ∈ standardA_derivationStabilizer :=
  fun a ha => add_mem_standardA (h₁ _ (h₂ a ha)) (neg_mem_standardA (h₂ _ (h₁ a ha)))

theorem commutator_mem_standardB_derivationStabilizer
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardB_derivationStabilizer)
    (h₂ : D₂ ∈ standardB_derivationStabilizer) :
    commutator D₁ D₂ ∈ standardB_derivationStabilizer :=
  fun a ha => add_mem_standardB (h₁ _ (h₂ a ha)) (neg_mem_standardB (h₂ _ (h₁ a ha)))

theorem commutator_mem_standardAInterB_derivationStabilizer
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardAInterB_derivationStabilizer)
    (h₂ : D₂ ∈ standardAInterB_derivationStabilizer) :
    commutator D₁ D₂ ∈ standardAInterB_derivationStabilizer :=
  fun a ha =>
    ⟨add_mem_standardA (h₁ _ (h₂ a ha)).1 (neg_mem_standardA (h₂ _ (h₁ a ha)).1),
     add_mem_standardB (h₁ _ (h₂ a ha)).2 (neg_mem_standardB (h₂ _ (h₁ a ha)).2)⟩

/-! ## Intersection characterization (stretch goal) -/

/-- The common stabilizer of `h₂(𝕆)` and `h₃(ℂ)` is contained in the
stabilizer of their intersection `h₂(ℂ)`. -/
theorem inter_stabilizer_subset_standardAInterB :
    standardA_derivationStabilizer ∩ standardB_derivationStabilizer ⊆
      standardAInterB_derivationStabilizer := by
  intro D hD a ha
  exact ⟨hD.1 a ha.1, hD.2 a ha.2⟩

end PhysicsSM.Algebra.Jordan.StabilizerDerivation
