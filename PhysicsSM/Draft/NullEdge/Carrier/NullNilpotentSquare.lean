import Mathlib

/-!
# Null Clifford nilpotency and the zero-diagonal soldered square

**Move-1's first finite brick of the null-edge Weitzenbock carrier program.**

This module establishes the ALGEBRA-LEVEL keystone of the discrete Weitzenbock
decomposition `D^#D = Q_A + Q_C + Q_T + E`.  Concretely it proves:

* the keystone `c(α)² = 0` (**null Clifford nilpotency**): the Clifford image of a
  null vector squares to zero, so a lone lightlike generator carries no algebraic
  mass; and
* the **zero-diagonal identity** for the soldered square: if `D0 = ∑ e, xₑ · c(αₑ)`
  is built out of null generators, then `D0²` has NO diagonal term — every summand
  of the square is a PAIRWISE relation between DISTINCT null edges.  This is the
  literal matrix/algebra content of the slogan **"mass is relational"**.

## Scope / honesty (draft-trust, finite algebraic identity)

This is the ALGEBRA-LEVEL skeleton only.  It is *not yet* the full carrier:

* there is no gauge-covariant difference operator — the scalar coefficients `x e`
  are commuting stand-ins for the covariant derivatives `∇_e` (the "scalar-∇
  simplification"), so no non-commuting connection data enters here;
* there is no Krein `#`-adjoint;
* there is no potential `Φ`; and
* there is no 2-complex / plaquette (closure) structure.

Those are the later bricks.  What is proved here is a finite algebraic identity over
a commutative ring, kernel-checked and free of `sorry`/`axiom`/`native_decide`.

## Main results

* `null_clifford_sq_zero` : `Q v = 0 → (ι Q v) ^ 2 = 0`.
* `null_clifford_mul_self_zero` : `Q v = 0 → ι Q v * ι Q v = 0`.
* `nullSoldered_square_expand` : the square of the soldered element expands to the
  full double sum `∑ e, ∑ f, (xₑ xf) • (c(αₑ) c(αf))`.
* `nullSoldered_square_diagonal_zero` : each diagonal summand vanishes.
* `nullSoldered_square_offDiagonal` : **the headline** — `D0²` equals the
  off-diagonal double sum (inner index ranging over `univ.erase e`).
* `lone_edge_massless` : a single null-soldered generator squares to zero.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier

variable {R V : Type*} [CommRing R] [AddCommGroup V] [Module R V]

/-- **Null Clifford nilpotency (masslessness of a lone null edge).**
For a null vector `v` (i.e. `Q v = 0`) the Clifford generator `ι Q v` squares to
zero.  This is the algebraic keystone `c(α)² = 0`.  Proof: `ι_sq_scalar` rewrites
the square to `algebraMap R _ (Q v)`, which is `0` since `Q v = 0`. -/
theorem null_clifford_sq_zero (Q : QuadraticForm R V) {v : V} (h : Q v = 0) :
    (CliffordAlgebra.ι Q v) ^ 2 = 0 := by
  rw [pow_two, CliffordAlgebra.ι_sq_scalar, h, map_zero]

/-- The `mul_self` form of null Clifford nilpotency: `ι Q v * ι Q v = 0` when
`Q v = 0`. -/
theorem null_clifford_mul_self_zero (Q : QuadraticForm R V) {v : V} (h : Q v = 0) :
    CliffordAlgebra.ι Q v * CliffordAlgebra.ι Q v = 0 := by
  rw [CliffordAlgebra.ι_sq_scalar, h, map_zero]

section Soldered

variable {E : Type*} [Fintype E]

/-- The soldered element `D0 = ∑ e, xₑ • c(αₑ)`, the abstract null-edge Dirac
operator with commuting scalar weights `x e` standing in for the covariant
derivatives `∇_e`. -/
def nullSoldered (Q : QuadraticForm R V) (alpha : E → V) (x : E → R) :
    CliffordAlgebra Q :=
  ∑ e, x e • CliffordAlgebra.ι Q (alpha e)

/-- **Expansion of the soldered square.**  Squaring the finite sum and factoring
the (central) scalars out yields the full double sum
`∑ e, ∑ f, (xₑ xf) • (c(αₑ) c(αf))`.  No nullity is used yet. -/
theorem nullSoldered_square_expand (Q : QuadraticForm R V) (alpha : E → V) (x : E → R) :
    nullSoldered Q alpha x ^ 2
      = ∑ e, ∑ f,
          (x e * x f) • (CliffordAlgebra.ι Q (alpha e) * CliffordAlgebra.ι Q (alpha f)) := by
  unfold nullSoldered
  rw [pow_two, Finset.sum_mul_sum]
  refine Finset.sum_congr rfl (fun e _ => Finset.sum_congr rfl (fun f _ => ?_))
  rw [smul_mul_smul_comm]

omit [Fintype E] in
/-- **The diagonal terms vanish.**  For each edge `e`, the `f = e` summand
`(xₑ xₑ) • (c(αₑ) c(αₑ))` is zero, an immediate consequence of null Clifford
nilpotency `null_clifford_mul_self_zero`. -/
theorem nullSoldered_square_diagonal_zero (Q : QuadraticForm R V) (alpha : E → V)
    (hα : ∀ e, Q (alpha e) = 0) (x : E → R) (e : E) :
    (x e * x e) • (CliffordAlgebra.ι Q (alpha e) * CliffordAlgebra.ι Q (alpha e)) = 0 := by
  rw [null_clifford_mul_self_zero Q (hα e), smul_zero]

/-- **Headline: the relational-mass identity (zero edge-diagonal).**
The square of the null-soldered element has NO diagonal term: it equals the
off-diagonal double sum, where the inner index ranges over `Finset.univ.erase e`.
Every term of `D0²` is therefore a PAIRWISE relation between DISTINCT null edges —
the literal algebraic content of "mass is relational".

Proof: expand via `nullSoldered_square_expand`, split each inner sum into its
diagonal (`f = e`) summand plus the rest via `Finset.add_sum_erase`, and drop the
diagonal summand using `nullSoldered_square_diagonal_zero`. -/
theorem nullSoldered_square_offDiagonal [DecidableEq E] (Q : QuadraticForm R V)
    (alpha : E → V) (hα : ∀ e, Q (alpha e) = 0) (x : E → R) :
    nullSoldered Q alpha x ^ 2
      = ∑ e, ∑ f ∈ Finset.univ.erase e,
          (x e * x f) • (CliffordAlgebra.ι Q (alpha e) * CliffordAlgebra.ι Q (alpha f)) := by
  rw [nullSoldered_square_expand]
  refine Finset.sum_congr rfl (fun e _ => ?_)
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ e),
    nullSoldered_square_diagonal_zero Q alpha hα x e, zero_add]

end Soldered

/-- **Interpretation corollary: a lone null edge is massless.**
With a single edge (`E := Fin 1`) the soldered square vanishes: a lone lightlike
excitation carries no (algebraic) mass. -/
theorem lone_edge_massless (Q : QuadraticForm R V) (alpha : Fin 1 → V)
    (hα : ∀ e, Q (alpha e) = 0) (x : Fin 1 → R) :
    nullSoldered Q alpha x ^ 2 = 0 := by
  unfold nullSoldered
  rw [Fintype.sum_eq_single (0 : Fin 1) (fun y hy => absurd (Subsingleton.elim y 0) hy),
    smul_pow, null_clifford_sq_zero Q (hα 0), smul_zero]

end PhysicsSM.Draft.NullEdge.Carrier
