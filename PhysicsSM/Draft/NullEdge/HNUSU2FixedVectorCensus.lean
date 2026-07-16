import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# SU(2) fixed-vector rigidity and the HNU zero-quasienergy census

This module upgrades `HNUExactCore.zero_census` from an endpoint matrix
equality to a statement about a genuine nonzero `+1` eigenvector. The key
finite-dimensional lemma says that a `2 x 2` complex unitary matrix of
determinant one that fixes a nonzero vector must be the identity.

Provenance: clean-room Aristotle formalization from project
`c626cb61-f1db-49ff-aa41-a9d96e9152ad`, task
`29712ef5-7778-455e-b9b8-416d9ec25ac7`, composed with the independently
reviewed HNU endpoint in `HNUExactCore`.

Scope: this is an exact finite fixed-vector census. It does not prove winding,
chirality, real-space locality, primitive-null support, or bulk-edge
correspondence.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.HNUExactCore

noncomputable section

/-! ## SU(2) fixed-vector rigidity -/

/-- For a `2 x 2` matrix, `det (M - 1) = det M - tr M + 1`. -/
lemma det_sub_one_fin_two (M : M2) : (M - 1).det = M.det - M.trace + 1 := by
  simp [Matrix.det_fin_two, Matrix.trace_fin_two, Matrix.sub_apply]
  ring

/-- A `2 x 2` complex unitary matrix of determinant one that fixes a nonzero
vector is the identity. -/
theorem su2_fixed_vector_eq_one {M : M2} (hU : M ∈ unitary M2) (hdet : M.det = 1)
    (hv : ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = v) : M = 1 := by
  obtain ⟨v, hv0, hvfix⟩ := hv
  have hker : (M - 1) *ᵥ v = 0 := by
    rw [sub_mulVec, one_mulVec, hvfix, sub_self]
  have hdz : (M - 1).det = 0 :=
    Matrix.exists_mulVec_eq_zero_iff.mp ⟨v, hv0, hker⟩
  have htr : M.trace = 2 := by
    rw [det_sub_one_fin_two, hdet] at hdz
    linear_combination -hdz
  exact su2_trace_two hU htr

/-- A determinant-one unitary matrix other than the identity has no nonzero
`+1` eigenvector. -/
theorem su2_ne_one_no_fixed_vector {M : M2} (hU : M ∈ unitary M2)
    (hdet : M.det = 1) (hne : M ≠ 1) :
    ¬ ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ M *ᵥ v = v :=
  fun hv => hne (su2_fixed_vector_eq_one hU hdet hv)

/-! ## HNU endpoint fixed-vector census -/

/-- The first standard basis vector is nonzero. -/
lemma e0_ne_zero : (![1, 0] : Fin 2 → ℂ) ≠ 0 := by
  intro h
  simpa using congrFun h 0

/-- On the closed Brillouin cube, the exact HNU endpoint has a nonzero `+1`
eigenvector exactly at the origin. -/
theorem endpoint_fixed_vector_iff (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    (∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint k *ᵥ v = v) ↔ ∀ i, k i = 0 := by
  constructor
  · intro hv
    exact (zero_census k hk).mp
      (su2_fixed_vector_eq_one (endpoint_unitary k) (endpoint_det k) hv)
  · intro h
    refine ⟨![1, 0], e0_ne_zero, ?_⟩
    rw [(zero_census k hk).mpr h, one_mulVec]

/-- Contrapositive form of the fixed-vector census. -/
theorem endpoint_no_fixed_vector_iff_ne_zero (k : Fin 3 → ℝ)
    (hk : ∀ i, k i ∈ Set.Icc (-Real.pi) Real.pi) :
    (¬ ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint k *ᵥ v = v) ↔ ∃ i, k i ≠ 0 := by
  rw [endpoint_fixed_vector_iff k hk]
  push_neg
  rfl

/-- Explicit nonzero fixed vector at the origin. -/
theorem endpoint_origin_fixed_vector :
    (![1, 0] : Fin 2 → ℂ) ≠ 0 ∧ endpoint ![0, 0, 0] *ᵥ ![1, 0] = ![1, 0] := by
  refine ⟨e0_ne_zero, ?_⟩
  rw [witness_zero, one_mulVec]

/-- Explicit non-origin control with no nonzero `+1` eigenvector. -/
theorem endpoint_nonorigin_no_fixed_vector :
    ¬ ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ endpoint ![Real.pi / 2, 0, 0] *ᵥ v = v := by
  intro hv
  exact witness_zero_unique
    (su2_fixed_vector_eq_one (endpoint_unitary _) (endpoint_det _) hv)

end

end PhysicsSM.Draft.NullEdge.HNUExactCore

/-! ## Build-enforced standard-three axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_fixed_vector_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_fixed_vector_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.su2_ne_one_no_fixed_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.su2_ne_one_no_fixed_vector

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_fixed_vector_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_fixed_vector_iff

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_no_fixed_vector_iff_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_no_fixed_vector_iff_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_origin_fixed_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_origin_fixed_vector

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_nonorigin_no_fixed_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUExactCore.endpoint_nonorigin_no_fixed_vector
