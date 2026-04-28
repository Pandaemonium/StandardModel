import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Module.Basic
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

Trusted arithmetic layer — `ComplexOctonion` is represented as a pair of real
octonions with explicitly defined pointwise addition and Cayley-style
complexified multiplication.  The operations below are deliberately concrete:
the current Furey files prove identities by expanding all coordinates down to
real polynomial equalities, so we avoid abstract algebraic instances beyond the
small additive and scalar structure needed by those statements.

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

@[simp] theorem ComplexOctonion.neg_re (a : ComplexOctonion) :
    (-a).re = -a.re := rfl
@[simp] theorem ComplexOctonion.neg_im (a : ComplexOctonion) :
    (-a).im = -a.im := rfl

/-- The multiplicative identity of ComplexOctonion: the real scalar 1,
    embedded as ⟨1_Octonion, 0_Octonion⟩. -/
instance : One ComplexOctonion where
  one := ⟨1, 0⟩

@[simp] theorem ComplexOctonion.one_re : (1 : ComplexOctonion).re = 1 := rfl
@[simp] theorem ComplexOctonion.one_im : (1 : ComplexOctonion).im = 0 := rfl

instance : SMul ℝ ComplexOctonion where
  smul r x := ⟨r • x.re, r • x.im⟩

instance : SMul ℂ ComplexOctonion where
  smul z x := ⟨z.re • x.re - z.im • x.im, z.re • x.im + z.im • x.re⟩

@[simp] theorem ComplexOctonion.smul_re (r : ℝ) (x : ComplexOctonion) :
    (r • x).re = r • x.re := rfl
@[simp] theorem ComplexOctonion.smul_im (r : ℝ) (x : ComplexOctonion) :
    (r • x).im = r • x.im := rfl

@[simp] theorem ComplexOctonion.complex_smul_re (z : ℂ) (x : ComplexOctonion) :
    (z • x).re = z.re • x.re - z.im • x.im := rfl
@[simp] theorem ComplexOctonion.complex_smul_im (z : ℂ) (x : ComplexOctonion) :
    (z • x).im = z.re • x.im + z.im • x.re := rfl

/-!
## Additive group and module structure

We need `AddCommGroup` (not merely `AddMonoid`) and `Module ℂ` so that
`LinearIndependent ℂ` statements about the 8 basis states of the minimal
left ideal J are well-typed.

The `nsmul`/`zsmul` implementations use component-wise integer arithmetic via
the `nsmulOct`/`zsmulOct` helpers below.  The Furey charge theorems prove
`n • v = v + ... + v` by `ext <;> norm_num [state_def]`, which evaluates
each ℝ-component numerically and is independent of the nsmul implementation.
-/

/-- Component-wise ℕ-scaling of an octonion.  Used to give an explicit,
    simp-friendly implementation of `nsmul` on `ComplexOctonion`. -/
def nsmulOct (n : ℕ) (x : Octonion) : Octonion :=
  ⟨n * x.c0, n * x.c1, n * x.c2, n * x.c3,
   n * x.c4, n * x.c5, n * x.c6, n * x.c7⟩

/-- Component-wise ℤ-scaling of an octonion.  Used for `zsmul`. -/
def zsmulOct (n : ℤ) (x : Octonion) : Octonion :=
  ⟨n * x.c0, n * x.c1, n * x.c2, n * x.c3,
   n * x.c4, n * x.c5, n * x.c6, n * x.c7⟩

-- Eight simp lemmas for nsmulOct, one per component.
@[simp] theorem nsmulOct_c0 (n : ℕ) (x : Octonion) : (nsmulOct n x).c0 = n * x.c0 := rfl
@[simp] theorem nsmulOct_c1 (n : ℕ) (x : Octonion) : (nsmulOct n x).c1 = n * x.c1 := rfl
@[simp] theorem nsmulOct_c2 (n : ℕ) (x : Octonion) : (nsmulOct n x).c2 = n * x.c2 := rfl
@[simp] theorem nsmulOct_c3 (n : ℕ) (x : Octonion) : (nsmulOct n x).c3 = n * x.c3 := rfl
@[simp] theorem nsmulOct_c4 (n : ℕ) (x : Octonion) : (nsmulOct n x).c4 = n * x.c4 := rfl
@[simp] theorem nsmulOct_c5 (n : ℕ) (x : Octonion) : (nsmulOct n x).c5 = n * x.c5 := rfl
@[simp] theorem nsmulOct_c6 (n : ℕ) (x : Octonion) : (nsmulOct n x).c6 = n * x.c6 := rfl
@[simp] theorem nsmulOct_c7 (n : ℕ) (x : Octonion) : (nsmulOct n x).c7 = n * x.c7 := rfl

-- Eight simp lemmas for zsmulOct.
@[simp] theorem zsmulOct_c0 (n : ℤ) (x : Octonion) : (zsmulOct n x).c0 = n * x.c0 := rfl
@[simp] theorem zsmulOct_c1 (n : ℤ) (x : Octonion) : (zsmulOct n x).c1 = n * x.c1 := rfl
@[simp] theorem zsmulOct_c2 (n : ℤ) (x : Octonion) : (zsmulOct n x).c2 = n * x.c2 := rfl
@[simp] theorem zsmulOct_c3 (n : ℤ) (x : Octonion) : (zsmulOct n x).c3 = n * x.c3 := rfl
@[simp] theorem zsmulOct_c4 (n : ℤ) (x : Octonion) : (zsmulOct n x).c4 = n * x.c4 := rfl
@[simp] theorem zsmulOct_c5 (n : ℤ) (x : Octonion) : (zsmulOct n x).c5 = n * x.c5 := rfl
@[simp] theorem zsmulOct_c6 (n : ℤ) (x : Octonion) : (zsmulOct n x).c6 = n * x.c6 := rfl
@[simp] theorem zsmulOct_c7 (n : ℤ) (x : Octonion) : (zsmulOct n x).c7 = n * x.c7 := rfl

/-- `ComplexOctonion` is an abelian group under component-wise addition.
    This subsumes the earlier `AddMonoid` and is required for `Module ℂ`.
    The `nsmul` and `zsmul` fields use `nsmulOct`/`zsmulOct`, which expand
    cleanly under `simp` and `norm_num` via the component lemmas above. -/
instance : AddCommGroup ComplexOctonion where
  add_assoc    := by intros; ext <;> simp [add_assoc]
  zero_add     := by intros; ext <;> simp
  add_zero     := by intros; ext <;> simp
  neg_add_cancel := by intros; ext <;> simp
  add_comm     := by intros; ext <;> simp [add_comm]
  sub_eq_add_neg := by intros; ext <;> simp [sub_eq_add_neg]
  nsmul        := fun n x => ⟨nsmulOct n x.re, nsmulOct n x.im⟩
  nsmul_zero   := by intros; ext <;> simp
  nsmul_succ   := by intro n x; ext <;> simp <;> ring
  zsmul        := fun n x => ⟨zsmulOct n x.re, zsmulOct n x.im⟩
  zsmul_zero'  := by intros; ext <;> simp
  zsmul_succ'  := by intro n x; ext <;> simp [add_comm] <;> ring
  zsmul_neg'   := by intro n x; ext <;> simp <;> ring

-- Simp lemmas giving component access to ℕ- and ℤ-scalings of ComplexOctonion.
@[simp] theorem ComplexOctonion.nsmul_re (n : ℕ) (x : ComplexOctonion) :
    (n • x).re = nsmulOct n x.re := rfl
@[simp] theorem ComplexOctonion.nsmul_im (n : ℕ) (x : ComplexOctonion) :
    (n • x).im = nsmulOct n x.im := rfl
@[simp] theorem ComplexOctonion.zsmul_re (n : ℤ) (x : ComplexOctonion) :
    (n • x).re = zsmulOct n x.re := rfl
@[simp] theorem ComplexOctonion.zsmul_im (n : ℤ) (x : ComplexOctonion) :
    (n • x).im = zsmulOct n x.im := rfl

/-- `ComplexOctonion` is a ℂ-module via the existing `SMul ℂ` instance.
    This is the key structure needed for `LinearIndependent ℂ` statements
    about the 8 basis states of the minimal left ideal J. -/
instance : Module ℂ ComplexOctonion where
  smul        := (· • ·)
  one_smul    := by intros; ext <;> simp
  mul_smul    := by intros; ext <;> simp [mul_sub, mul_add, sub_mul, add_mul] <;> ring
  smul_zero   := by intros; ext <;> simp
  smul_add    := by intros; ext <;> simp [mul_add] <;> ring
  add_smul    := by intros; ext <;> simp [add_mul] <;> ring
  zero_smul   := by intros; ext <;> simp

/-- `ComplexOctonion` is also an ℝ-module, with ℝ acting by uniform real scaling
    of both the real and imaginary octonionic components. -/
instance : Module ℝ ComplexOctonion where
  smul        := fun r x => ⟨r • x.re, r • x.im⟩
  one_smul    := by intros; ext <;> simp
  mul_smul    := by intros; ext <;> simp [mul_assoc]
  smul_zero   := by intros; ext <;> simp
  smul_add    := by intros; ext <;> simp [mul_add]
  add_smul    := by intros; ext <;> simp [add_mul]
  zero_smul   := by intros; ext <;> simp

end PhysicsSM.Algebra.Octonion.ComplexOctonion
