import Mathlib
import PhysicsSM.Algebra.Octonion.Conjugation
import PhysicsSM.Algebra.Octonion.Norm
import PhysicsSM.Algebra.Octonion.ComplexLine
import PhysicsSM.Algebra.Jordan.Basic

/-!
# Algebra.Jordan.H2O

The 2×2 octonionic Hermitian matrices `h₂(𝕆)` as a concrete Jordan algebra.

## Mathematical context

`h₂(𝕆)` consists of 2×2 Hermitian matrices over the octonions:

```text
⎡ α    y  ⎤       where α, β ∈ ℝ, y ∈ 𝕆
⎣ ȳ    β  ⎦
```

Following Baez 2021 (slides 7–11), we use the equivalent parametrization:

```text
⎡ t + x   y  ⎤     where t, x ∈ ℝ, y ∈ 𝕆
⎣ ȳ    t - x  ⎦
```

This makes the spin-factor structure explicit:
- Trace: `tr = 2t`
- Determinant: `det = t² − x² − ‖y‖²` (10-dimensional Minkowski form)
- Euclidean form: `(1/2)tr(a ∘ a) = t² + x² + ‖y‖²`

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 7–11.
Convention: `(t, x, y)` parametrization with `t = (α + β)/2`, `x = (α − β)/2`.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H2O

open PhysicsSM.Algebra.Octonion

/-! ## Concrete coordinate model -/

/--
A 2×2 octonionic Hermitian matrix in spin-factor coordinates.

Represents the matrix `[[t + x, y], [conj y, t - x]]` where:
- `t` is the half-trace (real)
- `x` is the diagonal splitting (real)
- `y` is the off-diagonal octonion entry
-/
@[ext]
structure H2O where
  /-- Half-trace: `t = (1/2) tr`. -/
  t : ℝ
  /-- Diagonal splitting: upper-left minus lower-right divided by 2. -/
  x : ℝ
  /-- Off-diagonal octonionic entry. -/
  y : Octonion
  deriving Inhabited

instance : Zero H2O where
  zero := ⟨0, 0, 0⟩

instance : Add H2O where
  add a b := ⟨a.t + b.t, a.x + b.x, a.y + b.y⟩

instance : Neg H2O where
  neg a := ⟨-a.t, -a.x, -a.y⟩

instance : Sub H2O where
  sub a b := ⟨a.t - b.t, a.x - b.x, a.y - b.y⟩

instance : SMul ℝ H2O where
  smul r a := ⟨r * a.t, r * a.x, r • a.y⟩

/-! ### Component simp lemmas -/

@[simp] theorem H2O.add_t (a b : H2O) : (a + b).t = a.t + b.t := rfl
@[simp] theorem H2O.add_x (a b : H2O) : (a + b).x = a.x + b.x := rfl
@[simp] theorem H2O.add_y (a b : H2O) : (a + b).y = a.y + b.y := rfl
@[simp] theorem H2O.zero_t : (0 : H2O).t = 0 := rfl
@[simp] theorem H2O.zero_x : (0 : H2O).x = 0 := rfl
@[simp] theorem H2O.zero_y : (0 : H2O).y = 0 := rfl
@[simp] theorem H2O.neg_t (a : H2O) : (-a).t = -a.t := rfl
@[simp] theorem H2O.neg_x (a : H2O) : (-a).x = -a.x := rfl
@[simp] theorem H2O.neg_y (a : H2O) : (-a).y = -a.y := rfl

/-! ## Trace -/

/--
The trace of a 2×2 octonionic Hermitian matrix.

`tr [[t + x, y], [ȳ, t − x]] = (t + x) + (t − x) = 2t`.
-/
def trace (a : H2O) : ℝ := 2 * a.t

@[simp] theorem trace_def (a : H2O) : trace a = 2 * a.t := rfl

theorem trace_zero : trace 0 = 0 := by simp [trace]

theorem trace_add (a b : H2O) : trace (a + b) = trace a + trace b := by
  simp [trace]; ring

theorem trace_smul (r : ℝ) (a : H2O) : trace (r • a) = r * trace a := by
  simp [trace, HSMul.hSMul, SMul.smul]; ring

/-! ## Determinant -/

/--
The determinant of a 2×2 octonionic Hermitian matrix.

`det [[t + x, y], [ȳ, t − x]] = (t + x)(t − x) − ȳ · y`
  `= t² − x² − ‖y‖²`

This is the 10-dimensional Minkowski quadratic form.
-/
def det (a : H2O) : ℝ := a.t ^ 2 - a.x ^ 2 - normSq a.y

@[simp] theorem det_def (a : H2O) :
    det a = a.t ^ 2 - a.x ^ 2 - normSq a.y := rfl

/-! ## Euclidean norm squared -/

/--
The Euclidean norm squared of a 2×2 octonionic Hermitian matrix:

`(1/2) tr(a ∘ a) = t² + x² + ‖y‖²`
-/
def euclideanNormSq (a : H2O) : ℝ :=
  a.t ^ 2 + a.x ^ 2 + normSq a.y

@[simp] theorem euclideanNormSq_def (a : H2O) :
    euclideanNormSq a = a.t ^ 2 + a.x ^ 2 + normSq a.y := rfl

/-- The Euclidean norm squared is nonnegative. -/
theorem euclideanNormSq_nonneg (a : H2O) : 0 ≤ euclideanNormSq a := by
  unfold euclideanNormSq
  have := normSq_nonneg a.y
  positivity

/-! ## Relation between trace, determinant, and Euclidean form -/

/--
`tr(a)² − 2 det(a) = 2 · euclideanNormSq(a)`.
-/
theorem trace_sq_sub_two_det (a : H2O) :
    trace a ^ 2 - 2 * det a = 2 * euclideanNormSq a := by
  simp [trace, det, euclideanNormSq]; ring

/-! ## The identity element -/

/--
The identity element of `h₂(𝕆)`: the 2×2 identity matrix `diag(1, 1)`.
-/
def one : H2O := ⟨1, 0, 0⟩

theorem trace_one : trace one = 2 := by simp [trace, one]

theorem det_one : det one = 1 := by simp [det, one, normSq]

/-! ## Diagonal embeddings -/

/--
The diagonal element `diag(α, β)` in spin-factor coordinates.
-/
noncomputable def diag (α β : ℝ) : H2O :=
  ⟨(α + β) / 2, (α - β) / 2, 0⟩

theorem trace_diag (α β : ℝ) : trace (diag α β) = α + β := by
  simp [trace, diag]; ring

theorem det_diag (α β : ℝ) : det (diag α β) = α * β := by
  simp [det, diag, normSq]; ring

/-! ## Standard projections -/

/--
The upper-left rank-one projection `diag(1, 0)`.
In spin-factor coordinates: `t = 1/2, x = 1/2, y = 0`.
-/
noncomputable def proj₁ : H2O := ⟨1/2, 1/2, 0⟩

/--
The lower-right rank-one projection `diag(0, 1)`.
In spin-factor coordinates: `t = 1/2, x = -1/2, y = 0`.
-/
noncomputable def proj₂ : H2O := ⟨1/2, -1/2, 0⟩

theorem trace_proj₁ : trace proj₁ = 1 := by simp [trace, proj₁]

theorem trace_proj₂ : trace proj₂ = 1 := by simp [trace, proj₂]

theorem det_proj₁ : det proj₁ = 0 := by
  simp [det, proj₁, normSq]

theorem det_proj₂ : det proj₂ = 0 := by
  simp [det, proj₂, normSq]
  norm_num

/-- The two standard projections sum to the identity. -/
theorem proj₁_add_proj₂ : proj₁ + proj₂ = one := by
  ext <;> simp [proj₁, proj₂, one] <;> ring

end PhysicsSM.Algebra.Jordan.H2O
