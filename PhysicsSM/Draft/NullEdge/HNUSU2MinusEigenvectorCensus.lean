import PhysicsSM.Draft.NullEdge.HNUSU2FixedVectorCensus

/-!
# SU(2) minus-eigenvector rigidity and the HNU pi-eigenspace census

This module proves the `-1` analogue of `HNUSU2FixedVectorCensus`: a `2 x 2`
complex unitary matrix of determinant one with a nonzero `-1` eigenvector is
exactly minus the identity. Composed with `HNUExactCore.pi_census`, this gives
an exact state-level census of the HNU quasienergy-pi eigenspace on the closed
Brillouin cube.

Provenance: clean-room integration of Aristotle project
`73a1d386-9910-493b-84b2-1867bdf6ef2e`, independently reviewed by
interactive Claude/Opus. The proof below reuses the shared determinant-kernel
pattern rather than the returned coordinate-level automation.

Scope: this is a finite spectral census. It does not prove real-space
locality, winding, anomaly inflow, or primitive-null support.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

/-! ## SU(2) minus-eigenvector rigidity -/

/-- For a `2 x 2` matrix, `det (M + 1) = det M + tr M + 1`. -/
lemma det_add_one_fin_two (M : M2) : (M + 1).det = M.det + M.trace + 1 := by
  simp [Matrix.det_fin_two, Matrix.trace_fin_two, Matrix.add_apply]
  ring

/-- A `2 x 2` complex unitary matrix of determinant one with a nonzero `-1`
eigenvector is minus the identity. -/
theorem su2_neg_one_eigenvector_eq_neg_one {M : M2}
    (hU : M ∈ unitary M2) (hdet : M.det = 1)
    (hv : ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = -v) : M = -1 := by
  obtain ⟨v, hv0, hvfix⟩ := hv
  have hker : (M + 1) *ᵥ v = 0 := by
    rw [add_mulVec, one_mulVec, hvfix]
    exact neg_add_cancel v
  have hdz : (M + 1).det = 0 :=
    Matrix.exists_mulVec_eq_zero_iff.mp ⟨v, hv0, hker⟩
  have htr : M.trace = -2 := by
    rw [det_add_one_fin_two, hdet] at hdz
    linear_combination hdz
  exact su2_trace_neg_two hU hdet htr

/-- For determinant-one unitaries, a nonzero `-1` eigenvector exists exactly
for minus the identity. -/
theorem su2_neg_one_eigenvector_iff {M : M2}
    (hU : M ∈ unitary M2) (hdet : M.det = 1) :
    (∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = -v) ↔ M = -1 := by
  constructor
  · exact su2_neg_one_eigenvector_eq_neg_one hU hdet
  · intro hM
    refine ⟨![1, 0], e0_ne_zero, ?_⟩
    rw [hM]
    simp [Matrix.neg_mulVec, Matrix.one_mulVec]

/-! ## HNU quasienergy-pi census -/

/-- On the closed momentum cube, the HNU endpoint has a nonzero `-1`
eigenvector exactly on a boundary face `k_i = pi` or `k_i = -pi`. -/
theorem endpoint_neg_one_eigenvector_iff (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    (∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint k *ᵥ v = -v) ↔
      ∃ i, k i = Real.pi ∨ k i = -Real.pi := by
  rw [su2_neg_one_eigenvector_iff (endpoint_unitary k) (endpoint_det k)]
  exact pi_census k hk

/-- Interior points of the closed cube have no nonzero `-1` eigenvector. -/
theorem endpoint_no_neg_one_eigenvector_of_interior (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi)
    (hint : ∀ i, k i ≠ Real.pi ∧ k i ≠ -Real.pi) :
    ∀ v : Fin 2 → ℂ, v ≠ 0 → endpoint k *ᵥ v ≠ -v := by
  intro v hv hMv
  obtain ⟨i, hi | hi⟩ :=
    (endpoint_neg_one_eigenvector_iff k hk).mp ⟨v, hv, hMv⟩
  · exact (hint i).1 hi
  · exact (hint i).2 hi

/-- Explicit nonzero `-1` eigenvector at a boundary point. -/
theorem endpoint_boundary_neg_one_eigenvector :
    ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint ![Real.pi, 1, 2] *ᵥ v = -v := by
  rw [su2_neg_one_eigenvector_iff (endpoint_unitary _) (endpoint_det _)]
  exact endpoint_pi _ (i := 0) rfl

end

end PhysicsSM.Draft.NullEdge.HNUExactCore

/-! ## Build-enforced standard-three axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_neg_one_eigenvector_eq_neg_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_neg_one_eigenvector_eq_neg_one

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_neg_one_eigenvector_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_neg_one_eigenvector_iff

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_no_neg_one_eigenvector_of_interior' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_no_neg_one_eigenvector_of_interior
