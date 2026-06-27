import Mathlib

/-!
# Draft.NullEdgeRAWilsonGap

Aristotle task C85 (Wave 20): the finite linear-algebra core of the Gate C0
RA–Wilson species-health path.

## Mathematical content

The central accretive-gap fact is:

> If `A` is anti-Hermitian (skew-adjoint) and `m > 0` is a real Wilson mass,
> then `A + m • I` has no kernel, indeed
> `‖(A + m • I) v‖² ≥ m² ‖v‖²`.

The mechanism is that for a skew-adjoint `A` the inner product `⟪A v, v⟫` is
purely imaginary, so the cross term in
`‖A v + m • v‖² = ‖A v‖² + 2 m · re⟪A v, v⟫ + m² ‖v‖²`
vanishes, leaving `‖A v + m • v‖² = ‖A v‖² + m² ‖v‖² ≥ m² ‖v‖²`.

We work in the simplest kernel-clean setting: a complex inner product space with
a `ℂ`-linear endomorphism `A`, the anti-Hermitian condition stated directly via
the inner product.

## Theorem package

* `IsAntiHermitian`                              — the skew-adjoint predicate.
* `antiHermitian_add_posScalar_norm_lower_bound` — `m² ‖v‖² ≤ ‖A v + m • v‖²`.
* `antiHermitian_add_posScalar_injective`        — injectivity of `A + m • I`.
* `antiHermitian_add_posScalar_noKernel`         — `ker (A + m • I) = ⊥`.
* `DRA_block_antiHermitian`                       — the retarded/advanced double
  block `[[0, B], [-Bᴴ, 0]]` is skew-Hermitian, a concrete source of the
  hypothesis.
* `RAWilson_gap_schema`                           — the packaged Gate C0 schema:
  any anti-Hermitian RA double plus a positive scalar Wilson mass is injective
  and gapped off the origin.

## Scope

This is a Gate C0 (species-health) theorem, **not** a Gate C1 / full Gate C
chiral-release theorem.  We do **not** claim the concrete null-edge operator
satisfies the anti-Hermitian hypothesis; `RAWilson_gap_schema` is an abstract
statement about any skew-adjoint operator plus positive scalar Wilson mass.
-/

namespace PhysicsSM.Draft.NullEdgeRAWilsonGap

open scoped InnerProductSpace
open ComplexConjugate

section AbstractCore

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-- A `ℂ`-linear endomorphism is **anti-Hermitian** (skew-adjoint) when
`⟪A x, y⟫ = - ⟪x, A y⟫` for all `x, y`. -/
def IsAntiHermitian (A : E →ₗ[ℂ] E) : Prop :=
  ∀ x y, ⟪A x, y⟫_ℂ = - ⟪x, A y⟫_ℂ

/-- The shifted operator `A + m • I` appearing in the accretive-gap argument. -/
def addPosScalar (A : E →ₗ[ℂ] E) (m : ℝ) : E →ₗ[ℂ] E :=
  A + (m : ℂ) • LinearMap.id

@[simp] theorem addPosScalar_apply (A : E →ₗ[ℂ] E) (m : ℝ) (v : E) :
    addPosScalar A m v = A v + (m : ℂ) • v := by
  simp [addPosScalar]

/-- For an anti-Hermitian `A`, the diagonal inner product `⟪A v, v⟫` has zero
real part (it is purely imaginary). -/
theorem IsAntiHermitian.re_inner_self_eq_zero
    {A : E →ₗ[ℂ] E} (hA : IsAntiHermitian A) (v : E) :
    (⟪A v, v⟫_ℂ).re = 0 := by
  specialize hA v v
  simp_all +decide [Complex.ext_iff]
  linarith [show (⟪A v, v⟫_ℂ).re = (⟪v, A v⟫_ℂ).re by
    rw [← inner_conj_symm, Complex.conj_re]]

/-- **Accretive gap, norm form.** For an anti-Hermitian `A` and any real Wilson
mass `m`, the shifted operator satisfies `m² ‖v‖² ≤ ‖(A + m • I) v‖²`.

(The bound itself does not need `m > 0`; positivity of `m` is what later upgrades
it to injectivity / triviality of the kernel.) -/
theorem antiHermitian_add_posScalar_norm_lower_bound
    {A : E →ₗ[ℂ] E} (hA : IsAntiHermitian A) {m : ℝ} (v : E) :
    m ^ 2 * ‖v‖ ^ 2 ≤ ‖addPosScalar A m v‖ ^ 2 := by
  -- Expanding the squared norm, the cross terms cancel by anti-Hermiticity.
  have h_expand : ‖A v + (m : ℂ) • v‖ ^ 2 = ‖A v‖ ^ 2 + m ^ 2 * ‖v‖ ^ 2 := by
    rw [@norm_add_pow_two ℂ]
    have := IsAntiHermitian.re_inner_self_eq_zero hA v
    simp_all +decide [norm_smul, mul_pow]
    erw [inner_smul_right]; simp +decide [this]
  exact h_expand ▸ le_add_of_nonneg_left (sq_nonneg _)

/-- **Accretive gap, injectivity form.** For `m > 0`, `A + m • I` is injective. -/
theorem antiHermitian_add_posScalar_injective
    {A : E →ₗ[ℂ] E} (hA : IsAntiHermitian A) {m : ℝ} (hm : 0 < m) :
    Function.Injective (addPosScalar A m) := by
  have h_kernel : ∀ v : E, addPosScalar A m v = 0 → v = 0 := by
    intro v hv
    have := antiHermitian_add_posScalar_norm_lower_bound hA (m := m) v
    simp_all +decide
    exact norm_eq_zero.mp (by contrapose! this; positivity)
  exact LinearMap.ker_eq_bot.mp (eq_bot_iff.mpr h_kernel)

/-- **Accretive gap, no-kernel form.** For `m > 0`, `A + m • I` has trivial
kernel. -/
theorem antiHermitian_add_posScalar_noKernel
    {A : E →ₗ[ℂ] E} (hA : IsAntiHermitian A) {m : ℝ} (hm : 0 < m) :
    LinearMap.ker (addPosScalar A m) = ⊥ :=
  LinearMap.ker_eq_bot_of_injective (antiHermitian_add_posScalar_injective hA hm)

end AbstractCore

section DRABlock

open Matrix

variable {n : Type*}

/-- The retarded/advanced double block built from an off-diagonal generator `B`:
`[[0, B], [-Bᴴ, 0]]`. -/
def draBlock (B : Matrix n n ℂ) :
    Matrix (n ⊕ n) (n ⊕ n) ℂ :=
  Matrix.fromBlocks 0 B (-Bᴴ) 0

/-- **The RA double is skew-Hermitian.** `(draBlock B)ᴴ = - draBlock B`, so it is
a concrete matrix source of the anti-Hermitian hypothesis. -/
theorem DRA_block_antiHermitian (B : Matrix n n ℂ) :
    (draBlock B)ᴴ = - draBlock B := by
  ext i j
  cases i <;> cases j <;> simp +decide [draBlock, Matrix.fromBlocks]

end DRABlock

section Schema

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-- **Gate C0 RA–Wilson gap schema.** Any anti-Hermitian operator `A` (the RA
double) plus a positive scalar Wilson mass `m` is gapped off the origin: it is
injective and obeys the quantitative lower bound `m² ‖v‖² ≤ ‖(A + m • I) v‖²`.

This is the abstract finite-linear-algebra core only; it does not assert that the
concrete null-edge operator is anti-Hermitian. -/
theorem RAWilson_gap_schema
    {A : E →ₗ[ℂ] E} (hA : IsAntiHermitian A) {m : ℝ} (hm : 0 < m) :
    Function.Injective (addPosScalar A m) ∧
      (∀ v : E, m ^ 2 * ‖v‖ ^ 2 ≤ ‖addPosScalar A m v‖ ^ 2) :=
  ⟨antiHermitian_add_posScalar_injective hA hm,
    fun v => antiHermitian_add_posScalar_norm_lower_bound hA v⟩

end Schema

end PhysicsSM.Draft.NullEdgeRAWilsonGap
