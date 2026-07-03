import Mathlib

/-!
# Gate D3.0 finite shadow: half-sided inclusion cannot shrink under a bijection

This Draft module records the finite combinatorial core behind Gate D3.0 from
`Sources/Null_Edge_Dynamics_Gate_D.md`: in a finite setting, a reversible
"modular step" that maps a finite carrier into itself cannot produce a proper
half-sided inclusion.  Because the step is a bijection, cardinality forces
image containment to be equality.

This is **not** the full finite-dimensional von Neumann algebra statement with
almost-periodic modular flow.  It is the Lean-clean finite recurrence skeleton:
for a finite carrier `s : Finset alpha` and a permutation `e`, the assumption
`e(s) subset s` implies `e(s) = s`, and hence also `e^-1(s) = s`.  The second
section records the parallel finite-dimensional linear-subspace statement:
an invertible linear map cannot send a finite-dimensional subspace into a
proper subspace of itself.

Claim label: **finite identity / structural skeleton**.  It is suitable as a
building block and statement check for the more ambitious D3.0 Aristotle job.

Status: draft-trust; no `s o r r y`, no `n a t i v e _ d e c i d e`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateD
namespace FiniteHalfSidedInclusion

/-- Image of a finite carrier under a permutation. -/
def permImage {α : Type*} (e : Equiv.Perm α) (s : Finset α) : Finset α :=
  s.map e.toEmbedding

/-- A permutation preserves the cardinality of a finite carrier. -/
theorem permImage_card {α : Type*} (e : Equiv.Perm α) (s : Finset α) :
    (permImage e s).card = s.card := by
  simp [permImage]

/--
Finite half-sided containment under a reversible step collapses to equality.

This is the cardinality core of the finite no-go: a bijective step cannot send
a finite carrier into a proper subcarrier.
-/
theorem permImage_eq_of_subset {α : Type*} (e : Equiv.Perm α) (s : Finset α)
    (h : permImage e s ⊆ s) :
    permImage e s = s := by
  exact Finset.eq_of_subset_of_card_le h (by simp [permImage])

/--
The inverse step also preserves the carrier once the forward half-sided
containment holds.
-/
theorem permImage_symm_eq_of_subset {α : Type*} (e : Equiv.Perm α) (s : Finset α)
    (h : permImage e s ⊆ s) :
    permImage e.symm s = s := by
  have heq : permImage e s = s := permImage_eq_of_subset e s h
  calc
    permImage e.symm s = permImage e.symm (permImage e s) := by rw [heq]
    _ = s := by
      simp [permImage, Finset.map_map]

/--
If every nonnegative iterate of a reversible finite step is half-sided, then
every such iterate actually preserves the carrier.
-/
theorem permImage_pow_eq_of_halfSided {α : Type*} (e : Equiv.Perm α)
    (s : Finset α)
    (h : ∀ n : ℕ, permImage (e ^ n) s ⊆ s) (n : ℕ) :
    permImage (e ^ n) s = s :=
  permImage_eq_of_subset (e ^ n) s (h n)

/-- There is no proper one-step finite half-sided inclusion under a bijection. -/
theorem no_proper_halfSided_step {α : Type*} (e : Equiv.Perm α) (s : Finset α)
    (h : permImage e s ⊆ s) :
    ¬ permImage e s ⊂ s := by
  rw [permImage_eq_of_subset e s h]
  exact lt_irrefl s

/-! ## Finite-dimensional subspace version -/

/-- Image of a subspace under an invertible linear map. -/
def subspaceImage {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (e : V ≃ₗ[K] V) (S : Submodule K V) : Submodule K V :=
  S.map e.toLinearMap

/-- An invertible linear map preserves finite rank of subspaces. -/
theorem subspaceImage_finrank {K V : Type*} [Field K] [AddCommGroup V]
    [Module K V] (e : V ≃ₗ[K] V) (S : Submodule K V) :
    Module.finrank K (subspaceImage e S) = Module.finrank K S := by
  simpa [subspaceImage] using LinearEquiv.finrank_map_eq e S

/--
Finite-dimensional linear half-sided containment under an invertible step
collapses to equality.

This is the vector-space analogue of `permImage_eq_of_subset`, and is the
closer finite shadow of a finite-dimensional algebra automorphism preserving a
subalgebra half-sidedly.
-/
theorem subspaceImage_eq_of_le {K V : Type*} [Field K] [AddCommGroup V]
    [Module K V] [FiniteDimensional K V]
    (e : V ≃ₗ[K] V) (S : Submodule K V)
    (h : subspaceImage e S ≤ S) :
    subspaceImage e S = S := by
  exact Submodule.eq_of_le_of_finrank_eq h (subspaceImage_finrank e S)

/-- The inverse linear step also preserves the subspace after forward containment. -/
theorem subspaceImage_symm_eq_of_le {K V : Type*} [Field K] [AddCommGroup V]
    [Module K V] [FiniteDimensional K V]
    (e : V ≃ₗ[K] V) (S : Submodule K V)
    (h : subspaceImage e S ≤ S) :
    subspaceImage e.symm S = S := by
  have heq : subspaceImage e S = S := subspaceImage_eq_of_le e S h
  calc
    subspaceImage e.symm S = subspaceImage e.symm (subspaceImage e S) := by
      rw [heq]
    _ = S := by
      ext x
      simp [subspaceImage]

/--
If every nonnegative iterate of an invertible finite-dimensional linear step is
half-sided, then every such iterate actually preserves the subspace.
-/
theorem subspaceImage_pow_eq_of_halfSided {K V : Type*} [Field K]
    [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (e : V ≃ₗ[K] V) (S : Submodule K V)
    (h : ∀ n : ℕ, subspaceImage (e ^ n) S ≤ S) (n : ℕ) :
    subspaceImage (e ^ n) S = S :=
  subspaceImage_eq_of_le (e ^ n) S (h n)

end FiniteHalfSidedInclusion
end GateD
end NullEdge
end Draft
end PhysicsSM
