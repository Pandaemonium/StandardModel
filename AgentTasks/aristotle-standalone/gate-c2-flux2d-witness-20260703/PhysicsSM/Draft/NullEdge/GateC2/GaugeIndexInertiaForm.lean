import PhysicsSM.Draft.NullEdge.GateC2.GaugeOverlapInterface

/-!
# Gate C2: the gauge overlap index as a trace / eigenvalue-count formula

This Draft module closes the algebraic distance between the abstract gauge index
and the concrete eigenvalue-sign counts of the gauge Wilson operator `H`.

The gauge-overlap interface already gives the index in signature form
(`GaugeOverlapInterface.gaugeOverlap_index_signature_form`):
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - sig(epsCFC H))`.  Because the
certified sign `epsCFC H = |H| H^{-1}` is an involution, its signature equals its
trace (`OverlapIndexMatrixSignature.matrix_trace_eq_signature`), so:

* `gaugeOverlap_index_trace_form` (UNCONDITIONAL, kernel-checked here): the gauge
  index is `(1/2)(sig gamma5 - trace(epsCFC H))`.  The trace of the certified sign
  is manifestly "the sum of the eigenvalue signs of `H`", so this already expresses
  the index through `H`'s spectral sign data - with no functional calculus left in
  the outer formula.

* `epsCFC_trace_eq_inertia` (Aristotle job 25f0b738): the trace of the certified
  sign is the inertia `n_+ - n_-` of `H`, i.e. the number of positive minus
  negative eigenvalues of the gapped Hermitian operator.

* `gaugeOverlap_index_eigenvalue_count_form`: the gauge index is therefore
  `(1/2)(sig gamma5 - (#positive eig(H) - #negative eig(H)))`, with no functional
  calculus left in the final index formula.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (gauge index as trace / eigenvalue counts).
Prerequisites: `GaugeOverlapInterface`, `OverlapIndexMatrixSignature`,
`OverlapSignExistence`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace GaugeIndexInertiaForm

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexMatrixSignature
open PhysicsSM.Draft.NullEdge.GateC2.GaugeOverlapInterface

attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **The gauge overlap index in trace form (unconditional).**  For a gapped
Hermitian `H` and chirality involution `gamma5`, the chiral index is
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - trace(epsCFC H))`.  Since the
certified sign `epsCFC H = |H| H^{-1}` is an involution, its signature `n_+ - n_-`
coincides with its trace, and that trace is the sum of the eigenvalue signs of
`H`.  This expresses the gauge index directly through `H`'s spectral sign data. -/
theorem gaugeOverlap_index_trace_form (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) :
    overlapIndex gamma5 (epsCFC H)
      = (2 : ℂ)⁻¹ * (matrixTraceSignature gamma5 - (epsCFC H).trace) := by
  rw [gaugeOverlap_index_signature_form H gamma5 hHherm hg5,
    matrix_trace_eq_signature (epsCFC H) (certifiedSign_exists H hHherm).involution]

/-- **The gauge overlap index in eigenvalue-count form (given the inertia
identity).**  If the certified sign's trace equals the inertia `n_+ - n_-` of `H`
(number of positive minus negative eigenvalues), then
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - (n_+ - n_-))`.  The hypothesis
`hinertia` is precisely the spectral bridge lemma `epsCFC_trace_eq_inertia`; with
it discharged, the gauge chiral index is read off from the eigenvalue signs of the
gauge Wilson operator `H` alone, with no functional calculus in the formula. -/
theorem gaugeOverlap_index_inertia_form (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) (nPos nNeg : ℕ)
    (hinertia : (epsCFC H).trace = (nPos : ℂ) - (nNeg : ℂ)) :
    overlapIndex gamma5 (epsCFC H)
      = (2 : ℂ)⁻¹ * (matrixTraceSignature gamma5 - ((nPos : ℂ) - (nNeg : ℂ))) := by
  rw [gaugeOverlap_index_trace_form H gamma5 hHherm hg5, hinertia]

/- The eigenvalues of a gapped (invertible) Hermitian matrix are nonzero. -/
lemma eigenvalues_ne_zero (H : Matrix n n ℂ) [Invertible H] (hH : H.IsHermitian)
    (i : n) : hH.eigenvalues i ≠ 0 := by
  by_contra h_contra
  have hdet := Matrix.IsHermitian.det_eq_prod_eigenvalues hH
  exact absurd
    (hdet ▸ Matrix.det_ne_zero_of_left_inverse (invOf_mul_self H))
    (by simp +decide [Finset.prod_eq_zero (Finset.mem_univ i), h_contra])

/-- The square root of `H^2` is the absolute-value functional calculus of `H`. -/
lemma sqrt_sq_eq_cfc_abs (H : Matrix n n ℂ) (hH : H.IsHermitian) :
    CFC.sqrt (H ^ 2) = cfc (fun x : ℝ => |x|) H := by
  have hbb :
      (cfc (fun x : ℝ => |x|) H) * (cfc (fun x : ℝ => |x|) H) = H ^ 2 := by
    rw [← cfc_mul (fun x => |x|) (fun x => |x|) H]
    rw [show (fun x : ℝ => |x| * |x|) = (fun x : ℝ => x ^ 2) from
      funext (fun x => by rw [abs_mul_abs_self, sq])]
    rw [cfc_pow (fun x : ℝ => x) 2 H, cfc_id' ℝ H]
  have hnn : 0 ≤ cfc (fun x : ℝ => |x|) H :=
    cfc_nonneg (fun x _ => abs_nonneg x)
  exact CFC.sqrt_unique hbb hnn

/-- The inverse of a gapped Hermitian `H` is the reciprocal functional calculus. -/
lemma invOf_eq_cfc_inv (H : Matrix n n ℂ) [Invertible H] (hH : H.IsHermitian) :
    (⅟H : Matrix n n ℂ) = cfc (fun x : ℝ => x⁻¹) H := by
  have hf' : ∀ x ∈ spectrum ℝ H, (id x) ≠ 0 := by
    intro x hx
    rw [hH.spectrum_real_eq_range_eigenvalues] at hx
    obtain ⟨i, rfl⟩ := hx
    exact eigenvalues_ne_zero H hH i
  have hh := cfc_inv (id : ℝ → ℝ) H hf'
  rw [cfc_id ℝ H] at hh
  rw [show (fun x : ℝ => x⁻¹) = (fun x : ℝ => (id x)⁻¹) from rfl, hh,
    Ring.inverse_invertible]

/-- The certified sign of a gapped Hermitian `H` is sign functional calculus. -/
lemma epsCFC_eq_cfc_sign (H : Matrix n n ℂ) [Invertible H] (hH : H.IsHermitian) :
    epsCFC H = cfc (fun x : ℝ => Real.sign x) H := by
  have hcont : ContinuousOn (fun x : ℝ => x⁻¹) (spectrum ℝ H) := by
    apply continuousOn_inv₀.mono
    intro x hx
    rw [hH.spectrum_real_eq_range_eigenvalues] at hx
    obtain ⟨i, rfl⟩ := hx
    exact eigenvalues_ne_zero H hH i
  unfold epsCFC
  rw [sqrt_sq_eq_cfc_abs H hH, invOf_eq_cfc_inv H hH,
    ← cfc_mul (fun x => |x|) (fun x => x⁻¹) H (by fun_prop) hcont]
  apply cfc_congr
  intro x hx
  rw [hH.spectrum_real_eq_range_eigenvalues] at hx
  obtain ⟨i, rfl⟩ := hx
  have hne := eigenvalues_ne_zero H hH i
  show |hH.eigenvalues i| * (hH.eigenvalues i)⁻¹ = Real.sign (hH.eigenvalues i)
  rcases lt_trichotomy (hH.eigenvalues i) 0 with h | h | h
  · rw [abs_of_neg h, Real.sign_of_neg h]
    field_simp
  · exact absurd h hne
  · rw [abs_of_pos h, Real.sign_of_pos h]
    field_simp

/-- The trace of the functional calculus of a Hermitian matrix is the sum of `f`
applied to its eigenvalues. -/
lemma trace_cfc_eq_sum_eigenvalues (H : Matrix n n ℂ) (hH : H.IsHermitian)
    (f : ℝ → ℝ) :
    (cfc f H).trace = ∑ i, ((f (hH.eigenvalues i) : ℝ) : ℂ) := by
  convert congr_arg Matrix.trace (Matrix.IsHermitian.cfc_eq hH f) using 1
  convert (Matrix.trace_mul_comm _ _) using 1
  simp +decide [← mul_assoc, Matrix.trace]

/-- The sum of eigenvalue signs equals the inertia. -/
lemma sum_sign_eq_inertia (H : Matrix n n ℂ) [Invertible H] (hH : H.IsHermitian) :
    (∑ i, ((Real.sign (hH.eigenvalues i) : ℝ) : ℂ))
      = ((Finset.univ.filter fun i => 0 < hH.eigenvalues i).card : ℂ)
        - ((Finset.univ.filter fun i => hH.eigenvalues i < 0).card : ℂ) := by
  have key : ∀ i, ((Real.sign (hH.eigenvalues i) : ℝ) : ℂ)
      = (if 0 < hH.eigenvalues i then (1 : ℂ) else 0)
        - (if hH.eigenvalues i < 0 then (1 : ℂ) else 0) := by
    intro i
    rcases lt_trichotomy (hH.eigenvalues i) 0 with h | h | h
    · rw [Real.sign_of_neg h]
      simp [not_lt.mpr h.le, h]
    · rw [h]
      simp
    · rw [Real.sign_of_pos h]
      simp [h, not_lt.mpr h.le]
  simp_rw [key]
  rw [Finset.sum_sub_distrib, Finset.sum_ite, Finset.sum_ite]
  simp [Finset.sum_const]

/-- **The certified sign's trace is the inertia of `H`.**  For a gapped Hermitian
`H`, `trace(sign H) = (#positive eigenvalues) - (#negative eigenvalues)`.

Proven by Aristotle job 25f0b738, then ported onto the repo's `epsCFC`. -/
theorem epsCFC_trace_eq_inertia (H : Matrix n n ℂ) [Invertible H]
    (hH : H.IsHermitian) :
    (epsCFC H).trace
      = ((Finset.univ.filter fun i => 0 < hH.eigenvalues i).card : ℂ)
        - ((Finset.univ.filter fun i => hH.eigenvalues i < 0).card : ℂ) := by
  rw [epsCFC_eq_cfc_sign H hH, trace_cfc_eq_sum_eigenvalues H hH,
    sum_sign_eq_inertia H hH]

/-- **The gauge overlap index in eigenvalue-count form.**  For a gapped Hermitian
`H` and chirality involution `gamma5`, the overlap index is computed directly
from the signature of `gamma5` and the inertia of `H`. -/
theorem gaugeOverlap_index_eigenvalue_count_form
    (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) :
    overlapIndex gamma5 (epsCFC H)
      = (2 : ℂ)⁻¹ *
          (matrixTraceSignature gamma5
            - (((Finset.univ.filter fun i => 0 < hHherm.eigenvalues i).card : ℂ)
              - ((Finset.univ.filter fun i => hHherm.eigenvalues i < 0).card : ℂ))) := by
  rw [gaugeOverlap_index_trace_form H gamma5 hHherm hg5,
    epsCFC_trace_eq_inertia H hHherm]

end GaugeIndexInertiaForm
end GateC2
end NullEdge
end Draft
end PhysicsSM
