import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlock

/-!
# Gate YM: the completely-monotone slice-projector OS audit (CM-OS)

This module audits and formalizes the "completely-monotone slice projector"
step inspired by Faizal-Shabir (arXiv:2606.19362), which inserts a spectral
multiplier `Pi = f(D)` on a reflection slice and claims that this preserves
Osterwalder-Schrader (OS) reflection positivity.

## The mining subtlety, precisely

The mining note (`faizal-shabir-2606-19362-mining.md`, caution A) flags that a
correct statement must distinguish three objects:

* the positive contraction `Pi = f(D)` obtained from spectral calculus;
* the half-operator `B = Pi^(1/2)`;
* whether `B` itself has a positivity-preserving heat-kernel (Bernstein)
  mixture representation.

The key mathematical warning is: **a general completely monotone `f` does not
make `sqrt f` completely monotone.**  So if an OS argument secretly needs the
INSERTED half-operator to be a heat-kernel mixture (equivalently, `sqrt f`
completely monotone), then complete monotonicity of `f` alone is not enough.

## Audit answer (what is actually sufficient)

The clean separation this file makes precise, at the finite matrix level:

1. **Form-level OS preservation needs almost nothing about `f`.**  If the OS
   form is a positive semidefinite matrix `M` and a slice operator is inserted
   as a *congruence* `M \mapsto B * M * Bᴴ`, the result is PSD for an
   ARBITRARY matrix `B` (`osForm_insert_conjTranspose_posSemidef`).  If the
   insertion is required to be *symmetric*, `M \mapsto B * M * B`, then the
   single sufficient hypothesis is that `B` is self-adjoint, `Bᴴ = B`
   (`osForm_insert_selfAdjoint_posSemidef`).

2. **The half-operator always exists and is self-adjoint.**  For ANY positive
   contraction `Pi` (indeed any `Pi.PosSemidef`), the matrix square root
   `B = CFC.sqrt Pi` satisfies `Bᴴ = B`, `B.PosSemidef`, and `B * B = Pi`
   (`halfOperator_isHermitian`, `halfOperator_posSemidef`,
   `halfOperator_mul_self`).  Hence symmetric insertion by the half-operator
   preserves the OS form with NO hypothesis on `sqrt f`
   (`osForm_insert_half_posSemidef`): the matrix square root is self-adjoint by
   construction, so the "`sqrt f` must be completely monotone" worry is a red
   herring *for form-level PSD*.

3. **Complete monotonicity of `f` is a (sufficient, not necessary) way to make
   `Pi = f(D)` a positive operator.**  A completely monotone multiplier has a
   Bernstein/heat-kernel representation `f(x) = \int e^{-t x} d\mu(t)` with
   `\mu \ge 0`; in finite form `Pi = \sum_k w_k e^{-t_k D}` with `w_k \ge 0`.
   Each heat kernel `e^{-t D}` is PSD when `D` is self-adjoint
   (`heatKernel_posSemidef`), and nonnegative mixtures of PSD matrices are PSD
   (`heatMixture_posSemidef`), so `Pi.PosSemidef`.  (Note: `Pi.PosSemidef`
   only really needs `f \ge 0` on the spectrum of `D`; complete monotonicity is
   stronger than needed for positivity alone.)

## Where the paper's argument is genuinely load-bearing (red-team)

The above shows that *if* the only thing one needs is that the doubled/inserted
matrix form stays PSD, then complete monotonicity of `sqrt f` is NOT required:
the half-operator is self-adjoint automatically.  The subtlety in caution A is
therefore real ONLY when the physics needs the inserted `B` to be more than a
self-adjoint contraction, namely to be:

* **reflection-covariant** (commuting correctly with the time reflection), and
* **OS-local** (mapping the positive-time observable subalgebra into itself),

or, more strongly, to be itself a *positivity-preserving heat-kernel operator*
on configuration space (an entrywise-positive Markov-type kernel), not merely a
matrix-PSD operator.  These are properties of `B`, and they do NOT follow from
`f` being completely monotone unless `sqrt f` is also completely monotone.  So
the weakest point of a "just take `Pi = f(D)` with `f` completely monotone"
projector argument is the silent assumption that the half-operator inherits the
heat-kernel / OS-locality / reflection-covariance structure.  The honest
admissibility condition is: **assume a self-adjoint, reflection-covariant,
OS-local positive contraction `B` directly**, and separately exhibit a heat
multiplier that supplies such a `B`; do not derive `B`'s structure from `f`
alone.

This file formalizes (1), (2), (3) and the covariance/locality bookkeeping at
the finite matrix level.  It does NOT claim any continuum result and adds no
new axioms.

Claim label: **finite identity**.  Draft-trust: kernel-checked, no `s o r r y`,
no `native_decide`.  Prerequisites: Mathlib + `TransferHilbertBlock.lean`
(hence `ReflectionPositivityKernel.lean`).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace CMProjectorOS

open scoped BigOperators ComplexOrder MatrixOrder Matrix
open ReflectionPositivityKernel

/-! ## Part 1: form-level OS preservation under slice insertion -/

variable {n : Type*} [Fintype n] [DecidableEq n]

omit [DecidableEq n] in
/-- **General congruence insertion preserves OS positivity.**  If the OS form
matrix `M` is positive semidefinite, then inserting ANY slice operator `B` as
the congruence `B * M * Bᴴ` keeps it positive semidefinite.  No hypothesis on
`B` is needed; this is the bare matrix-congruence fact underlying every
slice-insertion argument. -/
theorem osForm_insert_conjTranspose_posSemidef
    {M : Matrix n n ℂ} (hM : M.PosSemidef) (B : Matrix n n ℂ) :
    (B * M * Bᴴ).PosSemidef :=
  hM.mul_mul_conjTranspose_same B

omit [DecidableEq n] in
/-- **Symmetric insertion preserves OS positivity for a self-adjoint slice.**
If `M` is positive semidefinite and the slice operator `B` is self-adjoint
(`Bᴴ = B`), then inserting `B` symmetrically on both sides, `B * M * B`, keeps
the OS form positive semidefinite.  Self-adjointness of `B` is the single
sufficient hypothesis for the *symmetric* insertion (with no self-adjointness
one still has the congruence form `B * M * Bᴴ`). -/
theorem osForm_insert_selfAdjoint_posSemidef
    {M B : Matrix n n ℂ} (hM : M.PosSemidef) (hB : Bᴴ = B) :
    (B * M * B).PosSemidef := by
  have h := hM.mul_mul_conjTranspose_same B
  rwa [hB] at h

omit [DecidableEq n] in
/-- **Interpretation of insertion as observable pre-composition.**  The
quadratic form of the inserted matrix on a vector `v` equals the original
quadratic form on the transformed vector `Bᴴ *ᵥ v`.  This is the finite
statement that inserting `B` on both sides of the OS form is the same as acting
by `Bᴴ` on the observable, which is why self-adjoint reflection-covariant
`B` preserve the OS structure. -/
theorem osForm_insert_dotProduct (M B : Matrix n n ℂ) (v : n → ℂ) :
    star v ⬝ᵥ ((B * M * Bᴴ) *ᵥ v)
      = star (Bᴴ *ᵥ v) ⬝ᵥ (M *ᵥ (Bᴴ *ᵥ v)) := by
  rw [Matrix.mul_assoc, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec,
    Matrix.dotProduct_mulVec, Matrix.star_mulVec, Matrix.conjTranspose_conjTranspose]

/-! ## Part 2: the half-operator `B = Pi^(1/2)` from a positive contraction -/

/-- The half-operator (spectral square root) of a matrix. -/
def halfOperator (Pi : Matrix n n ℂ) : Matrix n n ℂ := CFC.sqrt Pi

/-- The half-operator is positive semidefinite. -/
theorem halfOperator_posSemidef (Pi : Matrix n n ℂ) :
    (halfOperator Pi).PosSemidef :=
  Matrix.nonneg_iff_posSemidef.mp (CFC.sqrt_nonneg Pi)

/-- The half-operator is self-adjoint. -/
theorem halfOperator_isHermitian (Pi : Matrix n n ℂ) :
    (halfOperator Pi)ᴴ = halfOperator Pi :=
  (halfOperator_posSemidef Pi).isHermitian

/-- The half-operator squares back to `Pi` when `Pi` is positive semidefinite:
`B * B = Pi` with `B = Pi^(1/2)`.  This is the defining half-operator identity. -/
theorem halfOperator_mul_self {Pi : Matrix n n ℂ} (hPi : Pi.PosSemidef) :
    halfOperator Pi * halfOperator Pi = Pi :=
  CFC.sqrt_mul_sqrt_self Pi

/-- **The half-operator always exists and is admissible for symmetric
insertion.**  For any positive semidefinite `Pi` there is a self-adjoint,
positive semidefinite `B` with `B * B = Pi`.  In particular NO complete
monotonicity of `sqrt f` is needed to obtain a self-adjoint half-operator. -/
theorem halfOperator_exists {Pi : Matrix n n ℂ} (hPi : Pi.PosSemidef) :
    ∃ B : Matrix n n ℂ, Bᴴ = B ∧ B.PosSemidef ∧ B * B = Pi :=
  ⟨halfOperator Pi, halfOperator_isHermitian Pi, halfOperator_posSemidef Pi,
    halfOperator_mul_self hPi⟩

/-- **Half-operator insertion preserves OS positivity.**  If the OS form `M` is
positive semidefinite and `Pi` is any positive semidefinite slice multiplier
(e.g. `Pi = f(D)` for a completely monotone `f`), then inserting the
half-operator `B = Pi^(1/2)` symmetrically preserves positivity.  This is the
central audit conclusion: form-level OS preservation for the half-operator
insertion needs only `Pi.PosSemidef`, not any property of `sqrt f`. -/
theorem osForm_insert_half_posSemidef
    {M Pi : Matrix n n ℂ} (hM : M.PosSemidef) (_hPi : Pi.PosSemidef) :
    (halfOperator Pi * M * halfOperator Pi).PosSemidef :=
  osForm_insert_selfAdjoint_posSemidef hM (halfOperator_isHermitian Pi)

/-! ## Part 3: `Pi = f(D)` as a completely-monotone heat-kernel mixture -/

omit [Fintype n] [DecidableEq n] in
/-- A real scalar multiple of a Hermitian matrix is Hermitian. -/
theorem isHermitian_realSmul {H : Matrix n n ℂ} (hH : H.IsHermitian) (r : ℝ) :
    ((r : ℂ) • H).IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_smul, hH.eq]
  simp

/-- **A heat kernel is positive semidefinite.**  For a self-adjoint generator
`H`, the matrix exponential `exp H` is positive semidefinite: writing
`exp H = exp (H/2) * exp (H/2)` with `exp (H/2)` Hermitian exhibits it as a
Gram square.  (Apply with `H = -(t) • D` to get the heat kernel `e^{-tD}`.) -/
theorem exp_posSemidef_of_isHermitian {H : Matrix n n ℂ} (hH : H.IsHermitian) :
    (NormedSpace.exp H).PosSemidef := by
  set a : Matrix n n ℂ := (2:ℝ)⁻¹ • H with ha
  have hhalf : a.IsHermitian := by rw [ha]; exact isHermitian_realSmul hH _
  have hHaa : H = a + a := by
    rw [ha, ← two_smul ℝ ((2:ℝ)⁻¹ • H), smul_smul]; norm_num
  have hadd : NormedSpace.exp (a + a) = NormedSpace.exp a * NormedSpace.exp a :=
    Matrix.exp_add_of_commute a a (Commute.refl a)
  have hB : (NormedSpace.exp a).IsHermitian := hhalf.exp
  have hpsd := Matrix.posSemidef_conjTranspose_mul_self (NormedSpace.exp a)
  rw [hB] at hpsd
  rw [hHaa, hadd]
  exact hpsd

/-- The heat kernel `e^{-t D}` of a self-adjoint generator `D` at time `t`. -/
def heatKernel (D : Matrix n n ℂ) (t : ℝ) : Matrix n n ℂ :=
  NormedSpace.exp ((-(t) : ℝ) • D)

/-- The heat kernel of a Hermitian generator is positive semidefinite, for any
(real) time. -/
theorem heatKernel_posSemidef {D : Matrix n n ℂ} (hD : D.IsHermitian) (t : ℝ) :
    (heatKernel D t).PosSemidef :=
  exp_posSemidef_of_isHermitian (isHermitian_realSmul hD _)

/-- **A completely-monotone multiplier is a positive contraction: the mixture
version.**  A finite nonnegative heat-kernel mixture
`Pi = \sum_i w_i • e^{-t_i D}` (`w_i \ge 0`), the discrete Bernstein/Hausdorff
form of `Pi = f(D)` for a completely monotone `f`, is positive semidefinite
whenever the generator `D` is self-adjoint.  This is the sufficient route from
"`f` completely monotone" to "`Pi = f(D)` positive". -/
theorem heatMixture_posSemidef {ι : Type*} [Fintype ι]
    {D : Matrix n n ℂ} (hD : D.IsHermitian)
    (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (t : ι → ℝ) :
    (∑ i, (w i : ℂ) • heatKernel D (t i)).PosSemidef := by
  refine Finset.sum_induction _ Matrix.PosSemidef (fun _ _ hp hq => hp.add hq)
    Matrix.PosSemidef.zero ?_
  intro i _hi
  exact (heatKernel_posSemidef hD (t i)).smul (by exact_mod_cast hw i)

/-! ## Part 4: positive contraction bookkeeping and OS end-to-end -/

/-- A **positive contraction**: positive semidefinite and dominated by the
identity.  This is the honest admissibility shape for a slice multiplier
`Pi = f(D)` with `0 ≤ f ≤ 1` on the spectrum of `D`. -/
def IsPositiveContraction (Pi : Matrix n n ℂ) : Prop :=
  Pi.PosSemidef ∧ (1 - Pi).PosSemidef

omit [Fintype n] in
/-- A positive contraction is positive semidefinite (projection to the first
component). -/
theorem IsPositiveContraction.posSemidef {Pi : Matrix n n ℂ}
    (h : IsPositiveContraction Pi) : Pi.PosSemidef := h.1

/-- **End-to-end OS preservation via a completely-monotone slice.**  If `M` is a
positive semidefinite OS form, `D` a self-adjoint generator, and `Pi` a finite
nonnegative heat-kernel mixture (the completely-monotone realization of
`f(D)`), then inserting the half-operator `B = Pi^(1/2)` symmetrically keeps the
OS form positive semidefinite. -/
theorem osForm_insert_cmMixture_posSemidef {ι : Type*} [Fintype ι]
    {M D : Matrix n n ℂ} (hM : M.PosSemidef) (hD : D.IsHermitian)
    (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i) (t : ι → ℝ) :
    (halfOperator (∑ i, (w i : ℂ) • heatKernel D (t i)) * M
      * halfOperator (∑ i, (w i : ℂ) • heatKernel D (t i))).PosSemidef :=
  osForm_insert_half_posSemidef hM (heatMixture_posSemidef hD w hw t)

/-! ### Instantiation on the reflection-positivity block form

The OS form built from a reflection-positive lattice weight is the block matrix
`rpBlockMatrix W` (see `TransferHilbertBlock.lean`).  A self-adjoint slice
operator inserted on it preserves reflection positivity at the form level. -/

variable {A C : Type} [Fintype A] [Fintype C] [DecidableEq A] [DecidableEq C]

omit [DecidableEq A] in
/-- **Slice insertion on the reflection-positivity block form.**  For a
reflection-positive weight `W`, inserting any self-adjoint slice operator `B`
(indexed by the OS coordinates `C × A`) symmetrically on the OS block matrix
keeps it positive semidefinite.  Together with `osForm_insert_half_posSemidef`
this covers the half-operator case `B = Pi^(1/2)`. -/
theorem rpBlockMatrix_insert_selfAdjoint_posSemidef
    (W : A → C → A → ℂ) (hW : IsReflectionPositive W)
    {B : Matrix (C × A) (C × A) ℂ} (hB : Bᴴ = B) :
    (B * TransferHilbertBlock.rpBlockMatrix W * B).PosSemidef :=
  osForm_insert_selfAdjoint_posSemidef
    (TransferHilbertBlock.rpBlockMatrix_posSemidef_of_reflectionPositive W hW) hB

/-- **Half-operator slice insertion on the reflection-positivity block form.**
For a reflection-positive weight `W` and any positive semidefinite slice
multiplier `Pi` on the OS coordinates, inserting the half-operator
`B = Pi^(1/2)` symmetrically preserves reflection positivity of the block
form. -/
theorem rpBlockMatrix_insert_half_posSemidef
    (W : A → C → A → ℂ) (hW : IsReflectionPositive W)
    {Pi : Matrix (C × A) (C × A) ℂ} (hPi : Pi.PosSemidef) :
    (halfOperator Pi * TransferHilbertBlock.rpBlockMatrix W
      * halfOperator Pi).PosSemidef :=
  osForm_insert_half_posSemidef
    (TransferHilbertBlock.rpBlockMatrix_posSemidef_of_reflectionPositive W hW) hPi

end CMProjectorOS
end GateYM
end NullEdge
end Draft
end PhysicsSM
