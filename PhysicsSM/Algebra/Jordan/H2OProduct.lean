import Mathlib
import PhysicsSM.Algebra.Octonion.Basic
import PhysicsSM.Algebra.Octonion.Conjugation
import PhysicsSM.Algebra.Octonion.Norm
import PhysicsSM.Algebra.Jordan.Basic
import PhysicsSM.Algebra.Jordan.H2O

/-!
# Algebra.Jordan.H2OProduct

The Jordan product on `h₂(𝕆)` and the Jordan identity.

## Mathematical context

The 2×2 octonionic Hermitian matrices form a spin factor Jordan algebra.
The spin-factor Jordan product is:

```text
(t₁, x₁, y₁) ○ (t₂, x₂, y₂)
  = (t₁t₂ + x₁x₂ + ⟨y₁, y₂⟩, t₁x₂ + t₂x₁, t₁·y₂ + t₂·y₁)
```

where `⟨y₁, y₂⟩` is the Euclidean inner product on the octonion coordinates.

This module proves:
- Commutativity of the Jordan product.
- `one` is the identity element.
- `proj₁` and `proj₂` are Jordan idempotents.
- The Jordan identity: `(a ○ b) ○ a² = a ○ (b ○ a²)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 7–11.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H2OProduct

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H2O

/-! ## Octonion inner product -/

/--
The real Euclidean inner product on octonions, defined as the sum of
coordinate products. This equals `Re(conj(a) * b)`.
-/
def octonionInner (a b : Octonion) : ℝ :=
  a.c0 * b.c0 + a.c1 * b.c1 + a.c2 * b.c2 + a.c3 * b.c3 +
  a.c4 * b.c4 + a.c5 * b.c5 + a.c6 * b.c6 + a.c7 * b.c7

@[simp] theorem octonionInner_def (a b : Octonion) :
    octonionInner a b =
      a.c0 * b.c0 + a.c1 * b.c1 + a.c2 * b.c2 + a.c3 * b.c3 +
      a.c4 * b.c4 + a.c5 * b.c5 + a.c6 * b.c6 + a.c7 * b.c7 := rfl

/-! ## Jordan product on H2O -/

/--
The Jordan product on `h₂(𝕆)` in spin-factor coordinates.

```text
(t₁, x₁, y₁) ○ (t₂, x₂, y₂)
  = (t₁t₂ + x₁x₂ + ⟨y₁, y₂⟩, t₁x₂ + t₂x₁, t₁·y₂ + t₂·y₁)
```
-/
def jordanProductH2O (a b : H2O) : H2O where
  t := a.t * b.t + a.x * b.x + octonionInner a.y b.y
  x := a.t * b.x + b.t * a.x
  y := a.t • b.y + b.t • a.y

local infixl:70 " ○ " => jordanProductH2O

/-! ### Simp lemmas for the product -/

@[simp] theorem jordanProductH2O_t (a b : H2O) :
    (a ○ b).t = a.t * b.t + a.x * b.x + octonionInner a.y b.y := rfl

@[simp] theorem jordanProductH2O_x (a b : H2O) :
    (a ○ b).x = a.t * b.x + b.t * a.x := rfl

@[simp] theorem jordanProductH2O_y (a b : H2O) :
    (a ○ b).y = a.t • b.y + b.t • a.y := rfl

/-! ### Commutativity -/

/-- The Jordan product on `h₂(𝕆)` is commutative. -/
theorem jordanProductH2O_comm (a b : H2O) : a ○ b = b ○ a := by
  ext <;> simp [jordanProductH2O, octonionInner] <;> ring

/-! ### Identity element -/

/-- `one` is a left identity for the Jordan product. -/
theorem jordanProductH2O_one_left (a : H2O) :
    one ○ a = a := by
  ext <;> simp [jordanProductH2O, one, octonionInner] <;> ring

/-- `one` is a right identity for the Jordan product. -/
theorem jordanProductH2O_one_right (a : H2O) :
    a ○ one = a := by
  rw [jordanProductH2O_comm]; exact jordanProductH2O_one_left a

/-! ### Projections are idempotent -/

/-- `proj₁` is a Jordan idempotent: `proj₁ ○ proj₁ = proj₁`. -/
theorem jordanProductH2O_proj₁_idempotent :
    proj₁ ○ proj₁ = proj₁ := by
  ext <;> simp [jordanProductH2O, proj₁, octonionInner] <;> ring

/-- `proj₂` is a Jordan idempotent: `proj₂ ○ proj₂ = proj₂`. -/
theorem jordanProductH2O_proj₂_idempotent :
    proj₂ ○ proj₂ = proj₂ := by
  ext <;> simp [jordanProductH2O, proj₂, octonionInner] <;> ring

/-! ### Jordan identity -/

/-
The Jordan identity for `h₂(𝕆)`:

```text
(a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))
```

This follows because `h₂(𝕆)` is a spin factor, and the spin-factor product
formula produces only real-polynomial expressions in coordinates. After
expanding all components, each coordinate equation is a polynomial identity
verifiable by `ring`.
-/
theorem jordanIdentityH2O (a b : H2O) :
    (a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a)) := by
  obtain ⟨t₁, x₁, y₁⟩ := a
  obtain ⟨t₂, x₂, y₂⟩ := b
  simp [jordanProductH2O, octonionInner];
  constructor;
  · grobner;
  · constructor;
    · ring;
    · ext <;> norm_num <;> ring

end PhysicsSM.Algebra.Jordan.H2OProduct
