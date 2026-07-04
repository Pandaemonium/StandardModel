import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
import PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector

/-!
# Gate YM Q2: finite OS/GNS transfer-Hilbert layer, shift-covariant

This module freezes the Q2 statement interface: the finite
Osterwalder-Seiler / GNS transfer-Hilbert layer built from a positive
semidefinite reflection kernel, made compatible with the Q3
electric/center-shift sector decomposition (`CenterFluxSector.lean`,
`FluxSectorZ2.lean`).

## Scope and non-claims (read before citing)

This file is **finite and algebraic**. It does NOT:

* construct a physical transfer matrix, a Hamiltonian, or a spectral gap;
* build a continuum or infinite-volume Hilbert space;
* claim the square-root-conjugated operator below equals any physical
  time-evolution operator.

Everything here is a statement about a finite matrix `K : Matrix I I ℂ`
that is `PosSemidef` (in the intended instance, the block direct sum of the
cut kernels `ReflectionPositivityKernel.cutKernel W c`, whose `PosSemidef`
is delivered by `cutKernel_posSemidef_of_reflectionPositive`), together
with a finite `ShiftSystem I Shift` of configuration permutations.

## Design (finite matrix route, no quotient plumbing)

* `reflectionPairing K` is the OS pairing with the first argument in the
  antilinear slot; its diagonal is the reflection form.
* `rpHilbertSpace K = range (CFC.sqrt K)` is the concrete OS space: the
  GNS inner product `f* K g` equals the standard inner product
  `(sqrt K f)* (sqrt K g)`, so the map `f ↦ sqrt K f` realizes the OS space
  as this submodule of `I → ℂ` with the ambient Hermitian inner product.
* Center shifts act by the permutation operator `shiftOp S z`. The key
  covariance facts are proved here, not assumed:
  - `shiftOp_commute_sqrt`: shift commutes with `CFC.sqrt K` whenever it
    commutes with `K` (via `Commute.cfcₙ_nnreal`);
  - `shiftOp_preserves_rpHilbertSpace`: hence `shiftOp` preserves the OS
    space, so electric sectors survive the OS construction.
* Transfer self-adjointness/positivity are stated in the faithful OS-form
  (`reflectionPairing_transfer_symm`, `reflectionPairing_transfer_nonneg`)
  and, on the square-root model, as `compressedTransfer` facts.  The
  square-root-conjugated `compressedTransfer` is an auxiliary self-adjoint
  PSD operator on the range model; it is NOT asserted to coincide with the
  physical transfer unless the ambient `T` preserves `ker K` (documented
  handoff).

Draft-trust: kernel-checked. Claim label: **finite identity / OS layer
interface**. Prerequisites: Mathlib + `ReflectionPositivityKernel.lean` +
`CenterFluxSector.lean`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TransferHilbert

open scoped Matrix ComplexOrder MatrixOrder
open CenterFluxSector

variable {I Shift : Type*} [Fintype I] [DecidableEq I]

/-! ## OS pairing -/

/-- The finite Osterwalder-Seiler pairing of a PSD kernel `K`, antilinear in
the first slot: `⟪f, g⟫_K = star f ⬝ᵥ (K *ᵥ g)`. Its diagonal is the
reflection form. -/
def reflectionPairing (K : Matrix I I ℂ) (f g : I → ℂ) : ℂ :=
  star f ⬝ᵥ (K *ᵥ g)

omit [DecidableEq I] in
/-- The diagonal of the OS pairing is nonnegative for a PSD kernel: this is
reflection positivity in the finite matrix language. -/
theorem reflectionPairing_self_nonneg {K : Matrix I I ℂ} (hK : K.PosSemidef)
    (f : I → ℂ) : 0 ≤ reflectionPairing K f f :=
  hK.dotProduct_mulVec_nonneg f

/-! ## Shift permutation operators -/

/-- The permutation operator of a shift, as a matrix acting on `I → ℂ`. -/
def shiftMatrix (S : ShiftSystem I Shift) (z : Shift) : Matrix I I ℂ :=
  Equiv.Perm.permMatrix ℂ (S.shift z)

/-- The shift matrix acts by pre-composition with the shift permutation. -/
theorem shiftMatrix_mulVec (S : ShiftSystem I Shift) (z : Shift) (f : I → ℂ) :
    shiftMatrix S z *ᵥ f = fun i => f (S.shiftConfig z i) := by
  ext i
  simp [shiftMatrix, Equiv.Perm.permMatrix, Matrix.mulVec, PEquiv.toMatrix,
    Equiv.toPEquiv, dotProduct, ShiftSystem.shiftConfig]

/-- Matrix-level commutation of a kernel with all shift permutations. -/
def KernelCommutesShifts (S : ShiftSystem I Shift) (K : Matrix I I ℂ) : Prop :=
  ∀ z, Commute (shiftMatrix S z) K

/-
Bridge: matrix-level commutation with the shift permutations is the same
as the `CenterFluxSector.ShiftSystem.KernelInvariantUnderShifts` predicate on
the entrywise kernel.
-/
theorem kernelCommutesShifts_iff (S : ShiftSystem I Shift) (K : Matrix I I ℂ) :
    KernelCommutesShifts S K ↔
      ShiftSystem.KernelInvariantUnderShifts S (fun x y => K x y) := by
  constructor;
  · intro h z x y;
    have := h z;
    have := congr_fun ( congr_fun this x ) ( S.shiftConfig z y );
    simp_all +decide [ Matrix.mul_apply, shiftMatrix ];
    simp_all +decide [ ShiftSystem.shiftConfig ];
  · intro hK z;
    ext i j; simp +decide [ shiftMatrix, Matrix.mul_apply ] ;
    rw [ Finset.sum_eq_single ( ( S.shift z ) ⁻¹ j ) ] <;> simp +decide;
    · convert hK z i ( ( S.shift z ).symm j ) using 1;
      simp +decide [ ShiftSystem.shiftConfig ];
    · grind

/-- The shift operator on the ambient function space `I → ℂ`. -/
def shiftOp (S : ShiftSystem I Shift) (z : Shift) : (I → ℂ) →ₗ[ℂ] (I → ℂ) :=
  Matrix.mulVecLin (shiftMatrix S z)

/-! ## OS Hilbert space and shift covariance -/

/-- The finite OS/GNS space: the range of `CFC.sqrt K`, a submodule of
`I → ℂ` carrying the ambient Hermitian inner product. -/
def rpHilbertSpace (K : Matrix I I ℂ) : Submodule ℂ (I → ℂ) :=
  LinearMap.range (Matrix.mulVecLin (CFC.sqrt K))

/-- **Functional-calculus commutation.** A shift that commutes with `K`
commutes with `CFC.sqrt K`. This is the crux covariance fact; it is a direct
instance of `Commute.cfcₙ_nnreal` and needs no separate hypothesis. -/
theorem shiftOp_commute_sqrt {S : ShiftSystem I Shift} {K : Matrix I I ℂ}
    (h : KernelCommutesShifts S K) (z : Shift) :
    Commute (shiftMatrix S z) (CFC.sqrt K) := by
  have := Commute.cfcₙ_nnreal (A := Matrix I I ℂ) (h z).symm
    (fun x : NNReal => NNReal.sqrt x)
  simpa [CFC.sqrt] using this.symm

/-- **Shift covariance of the OS space.** If `K` commutes with the shift
permutations, each shift operator preserves the OS Hilbert space, so Q3
electric sectors survive the OS/GNS construction. -/
theorem shiftOp_preserves_rpHilbertSpace {S : ShiftSystem I Shift}
    {K : Matrix I I ℂ} (h : KernelCommutesShifts S K) (z : Shift) :
    ∀ v ∈ rpHilbertSpace K, shiftOp S z v ∈ rpHilbertSpace K := by
  rintro _ ⟨w, rfl⟩
  refine ⟨(Matrix.mulVecLin (shiftMatrix S z)) w, ?_⟩
  simp only [shiftOp, Matrix.mulVecLin_apply, Matrix.mulVec_mulVec,
    (shiftOp_commute_sqrt h z).eq]

/-! ## Transfer operator: OS-form self-adjointness and positivity

These are the faithful physical statements: the transfer is self-adjoint and
positive with respect to the OS inner product. They are stated on the ambient
kernel `T` via the OS pairing, and hold under explicit finite matrix
hypotheses. -/

omit [DecidableEq I] in
/-- **OS self-adjointness of the transfer.** If `K * T = Tᴴ * K` (the
ambient `T` is symmetric with respect to the OS pairing), then the transfer
is self-adjoint for `reflectionPairing K`. -/
theorem reflectionPairing_transfer_symm {K T : Matrix I I ℂ}
    (hT : K * T = Tᴴ * K) (f g : I → ℂ) :
    reflectionPairing K f (T *ᵥ g) = reflectionPairing K (T *ᵥ f) g := by
  unfold reflectionPairing
  rw [Matrix.mulVec_mulVec, Matrix.star_mulVec, ← Matrix.dotProduct_mulVec,
    Matrix.mulVec_mulVec, hT]

omit [DecidableEq I] in
/-- **OS positivity of the transfer.** If `K * T` is positive semidefinite,
the transfer has nonnegative OS expectation values. -/
theorem reflectionPairing_transfer_nonneg {K T : Matrix I I ℂ}
    (hKT : (K * T).PosSemidef) (f : I → ℂ) :
    0 ≤ reflectionPairing K f (T *ᵥ f) := by
  unfold reflectionPairing
  rw [Matrix.mulVec_mulVec]
  exact hKT.dotProduct_mulVec_nonneg f

/-! ## Square-root model: compressed transfer

The square-root-conjugated operator `CFC.sqrt K * T * CFC.sqrt K` is an
auxiliary self-adjoint / PSD operator that lands in and preserves the OS
space and inherits shift covariance. It is NOT claimed to equal the physical
transfer (that identification needs `T` to preserve `ker K`; documented
handoff). -/

/-- Square-root-conjugated ("compressed") transfer on the range model. -/
def compressedTransfer (K T : Matrix I I ℂ) : Matrix I I ℂ :=
  CFC.sqrt K * T * CFC.sqrt K

/-- The compressed transfer is Hermitian when the ambient `T` is. -/
theorem compressedTransfer_isHermitian {K T : Matrix I I ℂ}
    (hT : T.IsHermitian) : (compressedTransfer K T).IsHermitian := by
  have hs : (CFC.sqrt K).IsHermitian :=
    (Matrix.LE.le.posSemidef (CFC.sqrt_nonneg K)).isHermitian
  show (CFC.sqrt K * T * CFC.sqrt K)ᴴ = CFC.sqrt K * T * CFC.sqrt K
  rw [Matrix.conjTranspose_mul, Matrix.conjTranspose_mul, hs.eq, hT.eq,
    Matrix.mul_assoc]

/-- The compressed transfer is positive semidefinite when the ambient `T`
is. -/
theorem compressedTransfer_posSemidef {K T : Matrix I I ℂ}
    (hT : T.PosSemidef) : (compressedTransfer K T).PosSemidef := by
  have hs : (CFC.sqrt K).IsHermitian :=
    (Matrix.LE.le.posSemidef (CFC.sqrt_nonneg K)).isHermitian
  have h := hT.mul_mul_conjTranspose_same (CFC.sqrt K)
  rw [hs.eq] at h
  exact h

/-- The compressed transfer commutes with a shift that commutes with both `K`
and `T`. -/
theorem compressedTransfer_commute_shift {S : ShiftSystem I Shift}
    {K T : Matrix I I ℂ} (hK : KernelCommutesShifts S K)
    (hT : ∀ z, Commute (shiftMatrix S z) T) (z : Shift) :
    Commute (shiftMatrix S z) (compressedTransfer K T) :=
  ((shiftOp_commute_sqrt hK z).mul_right (hT z)).mul_right
    (shiftOp_commute_sqrt hK z)

/-! ## Electric-sector preservation

The Q3-facing conclusion: a transfer kernel invariant under the center shifts
preserves every electric flux sector, reusing the `CenterFluxSector` API. -/

/-- **Electric-sector preservation.** A transfer kernel invariant under the
center shifts maps each electric sector into itself. This is the direct Q3
handoff: it is exactly `ShiftSystem.inElectricSector_applyKernel` specialized
to a matrix kernel via the `kernelCommutesShifts_iff` bridge. -/
theorem compressedTransfer_preserves_electricSector
    (S : ShiftSystem I Shift) (K : Matrix I I ℂ)
    (character : Shift → ℂ) (psi : I → ℂ)
    (hK : KernelCommutesShifts S K)
    (hpsi : ShiftSystem.InElectricSector S character psi) :
    ShiftSystem.InElectricSector S character (ShiftSystem.applyKernel
      (fun x y => K x y) psi) :=
  ShiftSystem.inElectricSector_applyKernel S (fun x y => K x y) character psi
    ((kernelCommutesShifts_iff S K).mp hK) hpsi

end TransferHilbert
end GateYM
end NullEdge
end Draft
end PhysicsSM
