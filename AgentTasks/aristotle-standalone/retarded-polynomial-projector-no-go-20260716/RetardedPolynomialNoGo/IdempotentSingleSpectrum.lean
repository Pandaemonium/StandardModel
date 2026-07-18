import Mathlib

/-!
# Polynomial idempotents of scalar-plus-nilpotent endomorphisms

Focused algebraic target for the null-edge retarded-operator selector audit.
The intended application is an order-retarded finite operator whose diagonal
part is scalar and whose strict causal part is nilpotent.
-/

noncomputable section

namespace RetardedPolynomialNoGo

open Polynomial

variable {M : Type*}
  [AddCommGroup M] [Module Real M] [Nontrivial M]

/-- An idempotent endomorphism lying in one scalar-plus-nilpotent generalized
eigenspace is trivial. -/
theorem idempotent_eq_zero_or_id_of_sub_scalar_nilpotent
    (P : Module.End Real M) (c : Real) (k : Nat) (hk : 0 < k)
    (hidempotent : P.comp P = P)
    (hnilpotent : (P - c • LinearMap.id) ^ k = 0) :
    P = 0 ∨ P = LinearMap.id := by
  sorry

/-- Every idempotent polynomial filter of a scalar plus a nilpotent
endomorphism is zero or the identity. -/
theorem polynomial_idempotent_of_scalar_add_nilpotent_trivial
    (a : Real) (N : Module.End Real M) (k : Nat) (hk : 0 < k)
    (hN : N ^ k = 0) (p : Real[X])
    (hidempotent :
      let P : Module.End Real M := aeval (a • LinearMap.id + N) p
      P.comp P = P) :
    let P : Module.End Real M := aeval (a • LinearMap.id + N) p
    P = 0 ∨ P = LinearMap.id := by
  sorry

end RetardedPolynomialNoGo
