import PhysicsSM.Draft.NullEdge.FloquetTransverseComposite
import PhysicsSM.Draft.NullEdge.HNUSU2FixedVectorCensus

/-!
# HNU selected sector with an explicit quasienergy-pi complement

This module instantiates `FloquetTransverseComposite.controlled` with the exact
HNU endpoint on the selected transverse line and `Vpi = -1` on its orthogonal
complement. It proves full finite-matrix unitarity and a state-level spectral
census: the selected sector has a nonzero `+1` eigenvector only at the origin,
while the complement supplies an explicit `-1` eigensector and no nonzero
`+1` eigenvector.

Provenance: clean-room integration of Aristotle project
`d82ea36b-490a-4e78-bc17-29e1aa3c96e9`, independently reviewed by
interactive Claude/Opus. The SU(2) rigidity step is reused from
`HNUSU2FixedVectorCensus` rather than duplicated.

Hard boundary: `Vpi = -1` is a momentum-space spectral control. It is not an
all-moving local update and does not prove primitive-null support, winding,
bulk-edge correspondence, anomaly inflow, or a physical domain wall.
-/

namespace PhysicsSM.Draft.NullEdge.HNUTransversePiComposite

open Matrix Complex
open FloquetTransverseComposite
open HNUExactCore

noncomputable section

/-- The explicit quasienergy-pi complement update. -/
def Vpi : Matrix Spin Spin ℂ := -1

/-- The pi complement is unitary. -/
theorem Vpi_isUnitary : IsUnitary Vpi := by
  constructor <;> simp [Vpi]

/-- Every complement spinor is a `-1` eigenvector of `Vpi`. -/
theorem Vpi_mulVec (x : Spin → ℂ) : Vpi *ᵥ x = -x := by
  simp [Vpi, Matrix.neg_mulVec, Matrix.one_mulVec]

/-- The only `+1` eigenvector of `Vpi` is zero. -/
theorem Vpi_plus_one_eigen_zero {x : Spin → ℂ} (h : Vpi *ᵥ x = x) : x = 0 := by
  rw [Vpi_mulVec] at h
  have h2 : (2 : ℂ) • x = 0 := by
    rw [two_smul]
    linear_combination (norm := abel) -h
  simpa using h2

/-- The exact HNU endpoint on the selected line and `Vpi` on the complement. -/
def hnuPiComposite (k : Fin 3 → ℝ) :
    Matrix (TSite × Spin) (TSite × Spin) ℂ :=
  controlled (HNUExactCore.endpoint k) Vpi

/-- Package HNU endpoint unitarity for the controlled-composite API. -/
theorem endpoint_IsUnitary (k : Fin 3 → ℝ) : IsUnitary (HNUExactCore.endpoint k) := by
  have h := Unitary.mem_iff.mp (HNUExactCore.endpoint_unitary k)
  exact ⟨h.1, h.2⟩

/-- Full finite-matrix unitarity of the controlled composite. -/
theorem hnuPiComposite_isUnitary (k : Fin 3 → ℝ) :
    IsUnitary (hnuPiComposite k) :=
  controlled_isUnitary (endpoint_IsUnitary k) Vpi_isUnitary

/-- The selected transverse embedding carries the exact HNU endpoint. -/
theorem hnuPiComposite_selected (k : Fin 3 → ℝ) (e : Spin → ℂ) :
    hnuPiComposite k *ᵥ embed e = embed (HNUExactCore.endpoint k *ᵥ e) :=
  controlled_restriction (HNUExactCore.endpoint k) Vpi e

/-- A selector-killed transverse profile carries exactly the pi complement. -/
theorem hnuPiComposite_complement (k : Fin 3 → ℝ)
    (f : TSite → ℂ) (e : Spin → ℂ) (hf : selector *ᵥ f = 0) :
    hnuPiComposite k *ᵥ (fun q => f q.1 * e q.2) =
      fun q => f q.1 * (Vpi *ᵥ e) q.2 :=
  controlled_complement_restriction (HNUExactCore.endpoint k) Vpi f e hf

/-- The complement is an exact `-1` eigensector. -/
theorem hnuPiComposite_complement_neg_one (k : Fin 3 → ℝ)
    (f : TSite → ℂ) (e : Spin → ℂ) (hf : selector *ᵥ f = 0) :
    hnuPiComposite k *ᵥ (fun q => f q.1 * e q.2) =
      -(fun q => f q.1 * e q.2) := by
  rw [hnuPiComposite_complement k f e hf, Vpi_mulVec]
  funext q
  simp

/-- The transverse embedding is injective. -/
theorem embed_injective {a b : Spin → ℂ} (h : embed a = embed b) : a = b := by
  funext j
  have h0 := congrArg (fun g => g ((0 : TSite), j)) h
  simp [embed, w] at h0
  exact h0

/-- A nonzero selected `+1` eigenvector can occur only at the HNU origin. -/
theorem selected_plus_one_only_at_zero (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi)
    (e : Spin → ℂ) (he : e ≠ 0)
    (h : hnuPiComposite k *ᵥ embed e = embed e) : ∀ i, k i = 0 := by
  apply (HNUExactCore.endpoint_fixed_vector_iff k hk).mp
  refine ⟨e, he, ?_⟩
  exact embed_injective (hnuPiComposite_selected k e ▸ h)

/-- A nonzero selector-killed product vector is never a `+1` eigenvector. -/
theorem complement_no_plus_one (k : Fin 3 → ℝ)
    (f : TSite → ℂ) (e : Spin → ℂ) (hf : selector *ᵥ f = 0)
    (hfe : (fun q : TSite × Spin => f q.1 * e q.2) ≠ 0) :
    hnuPiComposite k *ᵥ (fun q => f q.1 * e q.2) ≠
      fun q => f q.1 * e q.2 := by
  intro h
  have hneg := hnuPiComposite_complement_neg_one k f e hf
  rw [h] at hneg
  apply hfe
  funext q
  have hq := congrFun hneg q
  simp only [Pi.neg_apply] at hq
  have htwo : (2 : ℂ) * (f q.1 * e q.2) = 0 := by
    linear_combination hq
  simpa using (mul_eq_zero.mp htwo).resolve_left (by norm_num : (2 : ℂ) ≠ 0)

/-- Explicit nonzero selected `+1` eigenvector at the origin. -/
theorem witness_selected_zero :
    hnuPiComposite 0 *ᵥ embed ![1, 0] = embed ![1, 0] ∧
      embed (![1, 0] : Spin → ℂ) ≠ 0 := by
  constructor
  · rw [hnuPiComposite_selected, HNUExactCore.endpoint_zero, Matrix.one_mulVec]
  · intro h
    have h0 := congrArg (fun g => g ((0 : TSite), (0 : Spin))) h
    simp [embed, w] at h0

/-- Explicit nonzero complement `-1` eigenvector at every momentum. -/
theorem witness_complement_neg_one (k : Fin 3 → ℝ) :
    hnuPiComposite k *ᵥ
        (fun q => (![0, 1, 0] : TSite → ℂ) q.1 * (![1, 0] : Spin → ℂ) q.2) =
      -(fun q => (![0, 1, 0] : TSite → ℂ) q.1 * (![1, 0] : Spin → ℂ) q.2) := by
  apply hnuPiComposite_complement_neg_one
  rw [selector_mulVec]
  simp [w, dotProduct, Fin.sum_univ_three]

end

end PhysicsSM.Draft.NullEdge.HNUTransversePiComposite

/-! ## Build-enforced standard-three axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUTransversePiComposite.hnuPiComposite_isUnitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUTransversePiComposite.hnuPiComposite_isUnitary

/-- info: 'PhysicsSM.Draft.NullEdge.HNUTransversePiComposite.selected_plus_one_only_at_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUTransversePiComposite.selected_plus_one_only_at_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUTransversePiComposite.complement_no_plus_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUTransversePiComposite.complement_no_plus_one
