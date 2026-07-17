import PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalResolvent
import PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport

/-!
# Finite diagonal-plus-causal support decomposition

This module separates the diagonal contact term of a finite scalar response
from its positive-length strict-past propagation. For a massless kernel

```text
G0 = b * I + N,
```

with strict-past-supported `N`, the massive scattering response has local
contact coefficient `b / (1 + c * b)`. After subtracting that diagonal term,
the entire remainder is supported in the supplied strict past. Matrix rows are
targets and columns are sources.

The final four generic proof bodies were adapted from Aristotle project
`e96fbff2-66b7-4319-943f-07f09f5bd64d`; the repository's existing support
lemmas replace the package's duplicated first two targets. The FMS corollaries
are project-side compositions with the existing gauge-invariant radial lift.

No continuum limit, kernel normalization, or physical Green-function
identification is claimed. Claim grade: `M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalSupport

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalResolvent
open PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsStrictPastCausalSupport

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- The finite inverse differs from its diagonal contact term only by a
strict-past-supported matrix. -/
theorem nilpotentInverse_diagonalRemainder_supported
    (C : FiniteStrictRelation V) (a : Real) (N : Matrix V V Real) (H : Nat)
    (hH : 0 < H) (hN : MatrixSupportedInStrictPast C N) :
    MatrixSupportedInStrictPast C
      (nilpotentInverse a N H - a⁻¹ • (1 : Matrix V V Real)) := by
  by_cases ha : a = 0 <;> simp_all +decide [nilpotentInverse]
  · exact fun _ _ _ => rfl
  · intro target source hNotBefore
    rw [Finset.sum_eq_sum_diff_singleton_add (Finset.mem_range.mpr hH)]
    simp +decide [ha]
    ring_nf
    rw [Finset.sum_apply, Finset.sum_apply]
    simp +decide [*, Matrix.one_apply]
    rw [Finset.sum_eq_single 0] <;>
      simp_all +decide [mul_comm]
    · by_cases hTargetSource : target = source <;>
        simp_all +decide [Matrix.one_apply]
    · exact fun n hn hn0 =>
        matrixSupportedInStrictPast_pow_succ C hN (n - 1) |>
          fun hSupported => by cases n <;> aesop

/-- Headline split: the massive response has diagonal coefficient
`b / (1 + c * b)` and a strict-past-supported remainder. -/
theorem massiveScatteringResponse_diagonalRemainder_supported
    (C : FiniteStrictRelation V) (b c : Real)
    (N : Matrix V V Real) (H : Nat)
    (hH : 0 < H) (hN : MatrixSupportedInStrictPast C N) :
    MatrixSupportedInStrictPast C
      (massiveScatteringResponse b c N H -
        (b / (1 + c * b)) • (1 : Matrix V V Real)) := by
  by_cases hDen : 1 + c * b = 0
  · simp [massiveScatteringResponse, nilpotentInverse, hDen]
    exact fun _ _ _ => rfl
  intro target source hNotBefore
  have hNoTwoStep (middle : V) :
      Not (C.before source middle ∧ C.before middle target) :=
    fun hSteps => hNotBefore (C.transitive hSteps.1 hSteps.2)
  have hInverseRemainder :
      MatrixSupportedInStrictPast C
        (nilpotentInverse (1 + c * b) (c • N) H -
          (1 + c * b)⁻¹ • (1 : Matrix V V Real)) := by
    apply nilpotentInverse_diagonalRemainder_supported C
    · exact hH
    · exact fun target source hNot => by simp [hN target source hNot]
  unfold massiveScatteringResponse
  simp_all +decide [div_eq_mul_inv, Matrix.mul_apply, add_mul]
  simp_all +decide [MatrixSupportedInStrictPast, Matrix.one_apply]
  rw [Finset.sum_eq_zero] <;>
    simp_all +decide [sub_eq_iff_eq_add]
  grind

/-- Every diagonal entry of the massive response is exactly the local contact
coefficient. -/
theorem massiveScatteringResponse_diagonal_eq
    (C : FiniteStrictRelation V) (b c : Real)
    (N : Matrix V V Real) (H : Nat)
    (hH : 0 < H) (hN : MatrixSupportedInStrictPast C N) (x : V) :
    massiveScatteringResponse b c N H x x = b / (1 + c * b) := by
  have hSupported :=
    massiveScatteringResponse_diagonalRemainder_supported
      C b c N H hH hN
  simpa [sub_eq_zero, C.irrefl] using
    hSupported x x (C.irrefl x)

/-- Away from the diagonal, the response vanishes unless the source is in the
supplied strict past of the target. -/
theorem massiveScatteringResponse_offDiagonal_eq_zero_of_not_before
    (C : FiniteStrictRelation V) (b c : Real)
    (N : Matrix V V Real) (H : Nat)
    (hH : 0 < H) (hN : MatrixSupportedInStrictPast C N)
    (target source : V) (hne : source ≠ target)
    (hNotBefore : Not (C.before source target)) :
    massiveScatteringResponse b c N H target source = 0 := by
  convert massiveScatteringResponse_diagonalRemainder_supported
    C b c N H hH hN target source hNotBefore using 1
  simp [hne.symm]

/-- The leading gauge-invariant FMS radial observable has the same
contact-plus-strict-past split, with its contact coefficient multiplied by the
radial residue. -/
theorem fmsLeading_massiveScatteringResponse_diagonalRemainder_supported
    {I : Type*} [Fintype I] (vacuum : I -> Complex)
    (C : FiniteStrictRelation V) (b c : Real)
    (N : Matrix V V Real) (H : Nat)
    (hH : 0 < H) (hN : MatrixSupportedInStrictPast C N) :
    MatrixSupportedInStrictPast C
      (fmsLeadingKernel vacuum (massiveScatteringResponse b c N H) -
        (fmsRadialResidue vacuum * (b / (1 + c * b))) •
          (1 : Matrix V V Real)) := by
  have hSupported := matrixSupportedInStrictPast_smul C
    (fmsRadialResidue vacuum)
    (massiveScatteringResponse_diagonalRemainder_supported
      C b c N H hH hN)
  simpa [fmsLeadingKernel, smul_sub, smul_smul] using hSupported

/-- The diagonal contact coefficient of the leading gauge-invariant radial
observable is the elementary coefficient multiplied by its FMS residue. -/
theorem fmsLeading_massiveScatteringResponse_diagonal_eq
    {I : Type*} [Fintype I] (vacuum : I -> Complex)
    (C : FiniteStrictRelation V) (b c : Real)
    (N : Matrix V V Real) (H : Nat)
    (hH : 0 < H) (hN : MatrixSupportedInStrictPast C N) (x : V) :
    fmsLeadingKernel vacuum (massiveScatteringResponse b c N H) x x =
      fmsRadialResidue vacuum * (b / (1 + c * b)) := by
  simp [fmsLeadingKernel,
    massiveScatteringResponse_diagonal_eq C b c N H hH hN x]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalSupport.massiveScatteringResponse_diagonalRemainder_supported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveScatteringResponse_diagonalRemainder_supported

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalSupport.fmsLeading_massiveScatteringResponse_diagonalRemainder_supported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fmsLeading_massiveScatteringResponse_diagonalRemainder_supported

end PhysicsSM.Draft.NullEdge.FiniteDiagonalCausalSupport

end
