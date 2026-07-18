import Mathlib

/-!
# Equivariant positive projector from a linear involution

This focused package isolates a basis-free route to the rank-four projector
used by the null-edge protected-core transition interface. For a real linear
involution `J`, the map `(I + J) / 2` should be an idempotent whose range is
exactly the `+1` eigenspace. Intertwining involutions should intertwine these
projectors and transport their ranges without an eigenvector choice.

The package is finite linear algebra only. It does not construct `J` from a
graph, prove a four-dimensional eigenspace, derive Lorentzian inertia, or prove
overlap compatibility.
-/

noncomputable section

namespace InvolutionProjector

variable {M N : Type*}
  [AddCommGroup M] [Module Real M]
  [AddCommGroup N] [Module Real N]

/-- The basis-free projector candidate onto the `+1` sector of `J`. -/
def plusProjector (J : M →ₗ[Real] M) : M →ₗ[Real] M :=
  (2 : Real)⁻¹ • (LinearMap.id + J)

/-- The positive projector of an involution is idempotent. -/
theorem plusProjector_idempotent
    (J : M →ₗ[Real] M) (hJ : forall x, J (J x) = x) :
    (plusProjector J).comp (plusProjector J) = plusProjector J := by
  sorry

/-- The positive projector has range exactly the `+1` eigenspace. -/
theorem range_plusProjector_eq_eigenspace_one
    (J : M →ₗ[Real] M) (hJ : forall x, J (J x) = x) :
    LinearMap.range (plusProjector J) = Module.End.eigenspace J 1 := by
  sorry

/-- An intertwiner of involutions intertwines their positive projectors. -/
theorem plusProjector_intertwines
    (E : M ≃ₗ[Real] N) (J : M →ₗ[Real] M)
    (K : N →ₗ[Real] N)
    (hintertwines : forall x, E (J x) = K (E x)) :
    forall x, E (plusProjector J x) = plusProjector K (E x) := by
  sorry

/-- Intertwining involutions transport the positive projector range exactly. -/
theorem map_range_plusProjector_eq
    (E : M ≃ₗ[Real] N) (J : M →ₗ[Real] M)
    (K : N →ₗ[Real] N)
    (hintertwines : forall x, E (J x) = K (E x)) :
    (LinearMap.range (plusProjector J)).map E.toLinearMap =
      LinearMap.range (plusProjector K) := by
  sorry

/-- A minimal standalone analogue of the program's rank-four projector
package. -/
structure RankFourProjector (M : Type*) [AddCommGroup M] [Module Real M] where
  project : M →ₗ[Real] M
  idempotent : project.comp project = project
  range_finrank_eq_four : Module.finrank Real (LinearMap.range project) = 4

/-- A graph-native involution with four-dimensional positive eigenspace gives
a canonical rank-four projector without choosing eigenvectors. -/
def rankFourProjectorOfInvolution
    (J : M →ₗ[Real] M) (hJ : forall x, J (J x) = x)
    (hrank : Module.finrank Real (Module.End.eigenspace J 1) = 4) :
    RankFourProjector M where
  project := plusProjector J
  idempotent := plusProjector_idempotent J hJ
  range_finrank_eq_four := by
    rw [range_plusProjector_eq_eigenspace_one J hJ]
    exact hrank

end InvolutionProjector
