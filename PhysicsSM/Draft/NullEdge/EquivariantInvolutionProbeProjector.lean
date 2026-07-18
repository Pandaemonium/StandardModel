import PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector

/-!
# Equivariant positive projectors from real linear involutions

For a real-linear involution `J`, the polynomial `(I + J) / 2` is an
idempotent whose range is exactly the `+1` eigenspace. Intertwining
involutions therefore intertwine these projectors and transport their ranges
without choosing or ordering eigenvectors. A four-dimensional positive sector
packages directly as the rank-four projector interface used by the null-edge
carrier transition layer.

The reverse construction is equally important: every idempotent `P` gives the
involution `2P - I`, and the two polynomial constructions are inverse. An
involution is therefore not free graph structure. This route has physical
content only when the graph supplies the involution independently of already
knowing the desired projector.

This is finite linear algebra. It does not construct an involution from a
causal graph, prove a four-mode gap, derive Lorentzian inertia, or establish
overlap/refinement compatibility.

Claim grade: `M [orig/comp]`. Provenance: the four forward projector and range
proofs were returned by Aristotle project
`e7204f14-dcb9-4f2d-b116-f46a250b67d3` from unchanged Mathlib-only
statements and verified locally. The reverse polynomial identities are a
program-internal companion audit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector

open EquivariantProbeSectorSelector
open AlexandrovAlgebraGerm
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace

variable {M N : Type*}
  [AddCommGroup M] [Module ℝ M]
  [AddCommGroup N] [Module ℝ N]

/-- The basis-free projector candidate onto the `+1` sector of `J`. -/
def positiveProjector (J : M →ₗ[ℝ] M) : M →ₗ[ℝ] M :=
  (2 : ℝ)⁻¹ • (LinearMap.id + J)

/-- The positive projector of an involution is idempotent. -/
theorem positiveProjector_idempotent
    (J : M →ₗ[ℝ] M) (hJ : ∀ x, J (J x) = x) :
    (positiveProjector J).comp (positiveProjector J) =
      positiveProjector J := by
  ext x
  simp [positiveProjector, hJ]
  module

/-- The positive projector has range exactly the `+1` eigenspace. -/
theorem range_positiveProjector_eq_eigenspace_one
    (J : M →ₗ[ℝ] M) (hJ : ∀ x, J (J x) = x) :
    LinearMap.range (positiveProjector J) = Module.End.eigenspace J 1 := by
  apply le_antisymm
  · intro y hy
    obtain ⟨x, rfl⟩ := hy
    simp_all [positiveProjector]
    exact add_comm _ _
  · intro x hx
    simp_all [positiveProjector]
    exact ⟨x, by rw [hx, ← add_smul]; norm_num⟩

/-- An intertwiner of involutions intertwines their positive projectors. -/
theorem positiveProjector_intertwines
    (E : M ≃ₗ[ℝ] N) (J : M →ₗ[ℝ] M)
    (K : N →ₗ[ℝ] N)
    (hintertwines : ∀ x, E (J x) = K (E x)) :
    ∀ x, E (positiveProjector J x) = positiveProjector K (E x) := by
  unfold positiveProjector
  simp [hintertwines, smul_add]

/-- Intertwining involutions transport the positive-projector range exactly. -/
theorem map_range_positiveProjector_eq
    (E : M ≃ₗ[ℝ] N) (J : M →ₗ[ℝ] M)
    (K : N →ₗ[ℝ] N)
    (hintertwines : ∀ x, E (J x) = K (E x)) :
    (LinearMap.range (positiveProjector J)).map E.toLinearMap =
      LinearMap.range (positiveProjector K) := by
  apply le_antisymm
  · rintro _ ⟨x, ⟨y, rfl⟩, rfl⟩
    exact ⟨E y, by unfold positiveProjector; simp [hintertwines]⟩
  · rintro x ⟨y, rfl⟩
    refine ⟨positiveProjector J (E.symm y), ?_, ?_⟩ <;>
      simp [positiveProjector_intertwines E J K, hintertwines]

/-- The involution polynomial associated with an arbitrary endomorphism. -/
def involutionOfProjector (P : M →ₗ[ℝ] M) : M →ₗ[ℝ] M :=
  (2 : ℝ) • P - LinearMap.id

/-- An idempotent projector produces a genuine involution. -/
theorem involutionOfProjector_involutive
    (P : M →ₗ[ℝ] M) (hP : P.comp P = P) :
    ∀ x, involutionOfProjector P (involutionOfProjector P x) = x := by
  intro x
  have hp : P (P x) = P x := by
    change (P.comp P) x = P x
    rw [hP]
  simp [involutionOfProjector, hp]
  module

/-- Projector-to-involution-to-projector is exactly the identity. -/
theorem positiveProjector_involutionOfProjector
    (P : M →ₗ[ℝ] M) :
    positiveProjector (involutionOfProjector P) = P := by
  ext x
  simp [positiveProjector, involutionOfProjector]

/-- Involution-to-projector-to-involution is exactly the identity. -/
theorem involutionOfProjector_positiveProjector
    (J : M →ₗ[ℝ] M) :
    involutionOfProjector (positiveProjector J) = J := by
  ext x
  simp [positiveProjector, involutionOfProjector]

/-- A carrier involution with four-dimensional positive eigenspace supplies
the existing rank-four projector package without an eigenvector choice. -/
def rankFourProbeProjectorOfInvolution
    {V : Type} [Fintype V]
    {C : FiniteCausalOrder V}
    (A : MarkedDiamond C)
    (J : carrierProbeSubspace A →ₗ[ℝ] carrierProbeSubspace A)
    (hJ : ∀ x, J (J x) = x)
    (hrank : Module.finrank ℝ (Module.End.eigenspace J 1) = 4) :
    RankFourProbeProjector A where
  project := positiveProjector J
  idempotent := positiveProjector_idempotent J hJ
  range_finrank_eq_four := by
    rw [range_positiveProjector_eq_eigenspace_one J hJ]
    exact hrank

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.positiveProjector_idempotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.positiveProjector_idempotent

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.range_positiveProjector_eq_eigenspace_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.range_positiveProjector_eq_eigenspace_one

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.involutionOfProjector_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.involutionOfProjector_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.rankFourProbeProjectorOfInvolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector.rankFourProbeProjectorOfInvolution

end PhysicsSM.Draft.NullEdge.EquivariantInvolutionProbeProjector
