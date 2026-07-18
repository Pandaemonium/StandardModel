import Mathlib

/-!
# Rank-four no-go for a fully permutation-symmetric vertex probe

A completely symmetric bare graph, such as a complete or edgeless finite
graph, has every vertex permutation as an automorphism. A canonical projector
on scalar vertex probes must therefore commute with the natural permutation
action. Over the reals, an idempotent in this commutant can select only the
constant sector, the zero-sum sector, both, or neither. Its possible ranks are
therefore `0`, `1`, `n - 1`, and `n`.

This file asks for the direct coordinate-free consequence needed by the
null-edge reconstruction audit: for at least six vertices, no such projector
has rank four. The statement concerns the natural scalar vertex-probe module.
It does not rule out rank four after adding graph decorations, breaking the
full permutation symmetry, or using a richer local probe representation.
-/

noncomputable section

namespace PermutationProjectorNoGo

/-- The natural action of a permutation on real-valued vertex probes. -/
def permuteCoordinates {n : Nat} (sigma : Equiv.Perm (Fin n)) :
    (Fin n -> Real) ≃ₗ[Real] (Fin n -> Real) where
  toFun x i := x (sigma.symm i)
  invFun x i := x (sigma i)
  left_inv x := by
    funext i
    simp
  right_inv x := by
    funext i
    simp
  map_add' x y := by
    rfl
  map_smul' c x := by
    rfl

/-- A vertex-probe endomorphism is fully permutation-equivariant when it
commutes with every coordinate permutation. -/
def IsFullyPermutationEquivariant {n : Nat}
    (P : (Fin n -> Real) →ₗ[Real] (Fin n -> Real)) : Prop :=
  forall sigma : Equiv.Perm (Fin n),
    P.comp (permuteCoordinates sigma).toLinearMap =
      (permuteCoordinates sigma).toLinearMap.comp P

/-- No fully permutation-equivariant idempotent on the natural real vertex
probe module can have rank four once there are at least six vertices. -/
theorem no_rank_four_fully_permutation_equivariant_idempotent
    {n : Nat} (hn : 6 <= n)
    (P : (Fin n -> Real) →ₗ[Real] (Fin n -> Real))
    (hP : P.comp P = P)
    (hequiv : IsFullyPermutationEquivariant P) :
    Module.finrank Real (LinearMap.range P) ≠ 4 := by
  sorry

end PermutationProjectorNoGo
