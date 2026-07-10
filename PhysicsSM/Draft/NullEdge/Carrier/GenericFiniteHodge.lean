import Mathlib

/-!
# Generic finite Hilbert-Hodge representatives

For a nilpotent differential `Q` on a finite complex inner-product space, this
module proves the ordinary finite Hodge theorem for

```text
Delta_Q = Q^* Q + Q Q^*.
```

Every closed vector has a unique representative in
`ker Q intersect ker Q^*`. A separate decoder commuting with `Q` descends to
cohomology, and if it also commutes with `Q^*` it preserves harmonic
representatives.

Honest scope: `Q^*` is the auxiliary positive Hilbert adjoint. This theorem
does not use the Krein adjoint and does not select a physical positive sector.
`Carrier/KreinHodgeNoGo.lean` proves that the analogous Krein-adjoint
Laplacian can collapse even when `Q` is nilpotent and Krein-self-adjoint.

Provenance: Aristotle project `090b19dc-685b-4be7-95cb-d3305d6e5b9d`, task
`6c8dbf00-d013-4df7-96fe-0fb4b363588e`. The service reported completion with
errors, but the returned source was independently checked under the pinned
toolchain before integration. Clean-room finite-dimensional linear algebra.
-/

open scoped InnerProductSpace

namespace PhysicsSM.Draft.NullEdge.Carrier.GenericFiniteHodge

variable {n : ℕ}

local notation "V" => EuclideanSpace ℂ (Fin n)

/-- The ordinary finite constraint Hodge Laplacian. -/
noncomputable def hodgeLaplacian (Q : V →ₗ[ℂ] V) : V →ₗ[ℂ] V :=
  LinearMap.adjoint Q ∘ₗ Q + Q ∘ₗ LinearMap.adjoint Q

/-- Nilpotence makes every exact vector closed. -/
theorem range_le_ker_of_sq_zero (Q : V →ₗ[ℂ] V) (hQ2 : Q ∘ₗ Q = 0) :
    LinearMap.range Q ≤ LinearMap.ker Q := by
  exact fun x hx => by
    rcases hx with ⟨y, rfl⟩
    exact LinearMap.congr_fun hQ2 y

/-- The Hodge energy is the sum of the differential and codifferential norm
squares. -/
theorem hodge_energy (Q : V →ₗ[ℂ] V) (x : V) :
    (inner ℂ x (hodgeLaplacian Q x)).re =
      ‖Q x‖ ^ 2 + ‖LinearMap.adjoint Q x‖ ^ 2 := by
  have h_adj :
      ⟪x, Q.adjoint (Q x)⟫_ℂ = ⟪Q x, Q x⟫_ℂ ∧
        ⟪x, Q (Q.adjoint x)⟫_ℂ = ⟪Q.adjoint x, Q.adjoint x⟫_ℂ := by
    exact ⟨by rw [LinearMap.adjoint_inner_right],
      by rw [LinearMap.adjoint_inner_left]⟩
  simp_all +decide [hodgeLaplacian, inner_self_eq_norm_sq_to_K]
  norm_cast

/-- Harmonic vectors are exactly those killed by both the differential and its
Hilbert adjoint. -/
theorem ker_hodgeLaplacian (Q : V →ₗ[ℂ] V) :
    LinearMap.ker (hodgeLaplacian Q) =
      LinearMap.ker Q ⊓ LinearMap.ker (LinearMap.adjoint Q) := by
  apply le_antisymm
  · intro x hx
    have h_rel : ‖Q x‖ ^ 2 + ‖LinearMap.adjoint Q x‖ ^ 2 = 0 := by
      rw [← hodge_energy]
      aesop
    exact ⟨norm_eq_zero.mp (by contrapose! h_rel; positivity),
      norm_eq_zero.mp (by contrapose! h_rel; positivity)⟩
  · intro x hx
    simp_all +decide [hodgeLaplacian]

/-- **Generic finite Hodge representative theorem.** Every closed vector has
a unique harmonic representative modulo exact vectors. -/
theorem finite_hodge_representative (Q : V →ₗ[ℂ] V)
    (hQ2 : Q ∘ₗ Q = 0) (x : V) (hx : x ∈ LinearMap.ker Q) :
    ∃! h : V,
      h ∈ LinearMap.ker Q ⊓ LinearMap.ker (LinearMap.adjoint Q) ∧
        x - h ∈ LinearMap.range Q := by
  have h_orthogonal :
      (LinearMap.range (hodgeLaplacian Q))ᗮ =
        LinearMap.ker (hodgeLaplacian Q) := by
    apply LinearMap.IsSymmetric.orthogonal_range
    intro x y
    simp +decide [hodgeLaplacian, inner_add_right, inner_add_left]
    simp +decide [← LinearMap.adjoint_inner_left]
  have h_complemented :
      ∃ h : V, h ∈ LinearMap.ker (hodgeLaplacian Q) ∧
        x - h ∈ LinearMap.range (hodgeLaplacian Q) := by
    have h_decomp : ∀ x : V,
        ∃ h ∈ (LinearMap.range (hodgeLaplacian Q))ᗮ,
          x - h ∈ LinearMap.range (hodgeLaplacian Q) := by
      intro x
      have hx_sup :
          x ∈ LinearMap.range (hodgeLaplacian Q) ⊔
            (LinearMap.range (hodgeLaplacian Q))ᗮ := by
        rw [Submodule.sup_orthogonal_of_hasOrthogonalProjection]
        trivial
      rw [Submodule.mem_sup] at hx_sup
      obtain ⟨y, hy, z, hz, rfl⟩ := hx_sup
      exact ⟨z, hz, by simpa using hy⟩
    aesop
  obtain ⟨h, hh1, hh2⟩ := h_complemented
  have hh3 : h ∈ LinearMap.ker Q ⊓ LinearMap.ker (LinearMap.adjoint Q) := by
    exact ker_hodgeLaplacian Q ▸ hh1
  have hh4 : x - h ∈ LinearMap.range Q := by
    obtain ⟨z, hz⟩ := hh2
    simp_all +decide [hodgeLaplacian, LinearMap.ext_iff]
    have hQ_adj_Q_z : Q ((LinearMap.adjoint Q) (Q z)) = 0 := by
      apply_fun Q at hz
      simp_all +decide
    have hQ_adj_Q_z : ‖(LinearMap.adjoint Q) (Q z)‖ ^ 2 = 0 := by
      have hpair := LinearMap.adjoint_inner_right Q
        ((LinearMap.adjoint Q) (Q z)) (Q z)
      simp_all +decide [inner_self_eq_norm_sq_to_K]
    aesop
  refine ⟨h, ⟨hh3, hh4⟩, ?_⟩
  intro y hy
  have hy_eq :
      y - h ∈ LinearMap.range Q ⊓ LinearMap.ker Q ⊓
        LinearMap.ker (LinearMap.adjoint Q) := by
    simp_all +decide [LinearMap.mem_ker, Submodule.mem_inf]
    obtain ⟨z, hz⟩ := hh4
    obtain ⟨w, hw⟩ := hy.2
    use z - w
    simp_all +decide
  obtain ⟨u, hu⟩ := hy_eq.1.1
  simp_all +decide
  have hpair := LinearMap.adjoint_inner_right Q u (y - h)
  simp_all +decide
  exact sub_eq_zero.mp (norm_eq_zero.mp (by simpa using hpair.symm))

/-- A decoder commuting with the constraint differential preserves both closed
and exact representatives, hence descends to cohomology. -/
theorem commuting_decoder_descends (Q D : V →ₗ[ℂ] V)
    (hDQ : D ∘ₗ Q = Q ∘ₗ D) :
    (∀ x ∈ LinearMap.ker Q, D x ∈ LinearMap.ker Q) ∧
      (∀ x ∈ LinearMap.range Q, D x ∈ LinearMap.range Q) := by
  constructor <;> intro x <;> simp_all +decide [LinearMap.ext_iff]
  · intro hx
    rw [← hDQ, hx, map_zero]
  · grind

/-- If the decoder commutes with both the differential and codifferential, it
preserves harmonic representatives. -/
theorem commuting_decoder_preserves_harmonic (Q D : V →ₗ[ℂ] V)
    (hDQ : D ∘ₗ Q = Q ∘ₗ D)
    (hDadjQ : D ∘ₗ LinearMap.adjoint Q = LinearMap.adjoint Q ∘ₗ D) :
    ∀ x ∈ LinearMap.ker (hodgeLaplacian Q),
      D x ∈ LinearMap.ker (hodgeLaplacian Q) := by
  simp_all +decide [ker_hodgeLaplacian, LinearMap.mem_ker]
  simp_all +decide [LinearMap.ext_iff]
  grind

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GenericFiniteHodge.finite_hodge_representative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_hodge_representative

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GenericFiniteHodge.commuting_decoder_preserves_harmonic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms commuting_decoder_preserves_harmonic

end PhysicsSM.Draft.NullEdge.Carrier.GenericFiniteHodge
