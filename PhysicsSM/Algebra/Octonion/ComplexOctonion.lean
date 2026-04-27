import Mathlib.Data.Complex.Basic
import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Octonion.ComplexOctonion

The complexified octonion algebra ℂ ⊗_ℝ 𝕆.

ℂ ⊗_ℝ 𝕆 is the 8-dimensional ℂ-algebra (16-dimensional over ℝ) obtained by
extending scalars from ℝ to ℂ. It is the central algebraic arena for Furey's
Standard Model construction.

## Representation

A complexified octonion is a pair `(re, im) : Octonion × Octonion` representing
  x = re + i·im
where `re` and `im` are ordinary (real) octonions and `i` is the complex unit.

Equivalently it can be viewed as an `Octonion` with coefficients in `ℂ`,
i.e. a function `Fin 8 → ℂ`. We use the pair representation here to keep
the connection to the real octonion structure explicit.

## Key structures inside ℂ ⊗ 𝕆

- The **left-multiplication algebra** L_x (left action of ℂ⊗𝕆 on itself)
  generates a subalgebra isomorphic to ℂl(6) ⊗_ℂ ℂl(2) (Furey 2018).
- The **minimal left ideal** J ⊂ ℂ⊗𝕆 of ℂ-dimension 8 carries a single
  generation of Standard Model fermions.
- The **ladder operators** α₁, α₂, α₃ ∈ ℂ⊗𝕆 generate a Clifford algebra
  Cl(6) by anticommutation.

## Convention

All basis elements are labeled in the project XOR convention.
See `PhysicsSM.Algebra.Octonion.Basic` and
`PhysicsSM.Algebra.Octonion.ConventionBridge` for translation from Baez/Furey.

## Sources

- Furey, "Standard model physics from an algebra?", PhD thesis, 2016.
  arXiv:1611.09182
- Furey, "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of division
  algebraic ladder operators", EPJC 78 (2018) 375. arXiv:1806.00612

## Status

Stub — `ComplexOctonion` structure and basic operations to be defined.

## Successor modules

- `PhysicsSM.Algebra.Furey.LadderOperators`
- `PhysicsSM.Algebra.Furey.MinimalLeftIdeal`
-/

namespace PhysicsSM.Algebra.Octonion.ComplexOctonion

/-- A complexified octonion: a pair of real octonions representing `re + i·im`. -/
@[ext]
structure ComplexOctonion where
  re : Octonion
  im : Octonion
  deriving Inhabited

/-- The imaginary unit `i` embedded as a complexified octonion scalar. -/
def I : ComplexOctonion := ⟨⟨0,0,0,0,0,0,0,0⟩, ⟨1,0,0,0,0,0,0,0⟩⟩

/-- Embed a real octonion into the complexified algebra. -/
def ofOctonion (x : Octonion) : ComplexOctonion := ⟨x, ⟨0,0,0,0,0,0,0,0⟩⟩

/-- Embed a complex scalar into the complexified algebra. -/
def ofComplex (z : ℂ) : ComplexOctonion :=
  ⟨⟨z.re, 0, 0, 0, 0, 0, 0, 0⟩, ⟨z.im, 0, 0, 0, 0, 0, 0, 0⟩⟩

/-- Complex conjugation (conjugates the complex scalar, not the octonion).
    (re + i·im)* = re - i·im -/
def complexConj (x : ComplexOctonion) : ComplexOctonion :=
  ⟨x.re, ⟨-x.im.c0, -x.im.c1, -x.im.c2, -x.im.c3,
           -x.im.c4, -x.im.c5, -x.im.c6, -x.im.c7⟩⟩

instance : Neg ComplexOctonion where
  neg a := ⟨-a.re, -a.im⟩

instance : Add ComplexOctonion where
  add a b := ⟨a.re + b.re, a.im + b.im⟩

instance : Zero ComplexOctonion where
  zero := ⟨0, 0⟩

/-- ComplexOctonion multiplication: (a + i·b)(c + i·d) = (a·c - b·d) + i·(a·d + b·c)
    where · is octonion multiplication (non-associative, non-commutative). -/
instance : Mul ComplexOctonion where
  mul a b := ⟨a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re⟩

@[simp] theorem ComplexOctonion.mul_re (a b : ComplexOctonion) :
    (a * b).re = a.re * b.re - a.im * b.im := rfl
@[simp] theorem ComplexOctonion.mul_im (a b : ComplexOctonion) :
    (a * b).im = a.re * b.im + a.im * b.re := rfl
@[simp] theorem ComplexOctonion.add_re (a b : ComplexOctonion) :
    (a + b).re = a.re + b.re := rfl
@[simp] theorem ComplexOctonion.add_im (a b : ComplexOctonion) :
    (a + b).im = a.im + b.im := rfl
@[simp] theorem ComplexOctonion.zero_re : (0 : ComplexOctonion).re = 0 := rfl
@[simp] theorem ComplexOctonion.zero_im : (0 : ComplexOctonion).im = 0 := rfl

end PhysicsSM.Algebra.Octonion.ComplexOctonion
