import Mathlib

/-!
# Finite second-quantization square identity

This module formalizes the Q08 finite identity

`dGamma(D)^2 = dGamma(D^2) + 2 dGammaTwo(D)`.

The statement is made on decomposable fermionic Fock states in the exterior
algebra.  The global derivation on all of `ExteriorAlgebra` is not built here;
instead, the theorem pins the faithful Leibniz action on a tuple
`v : Fin k -> V`, whose wedge represents a decomposable `k`-particle state.

Claim boundary: this is finite algebra only.  It does not prove positivity of
the Gupta-Bleuler quotient or construct a global `dGamma` operator on all of
the exterior algebra.

Provenance: Aristotle project
`7067efa0-9755-482a-8d74-9c0b9a8318c7`
(`ne-q08-dgamma-square-identity-20260707`), clean-room formalization of
`AgentTasks/fable_parallel/Q08_answer.md` target L-Q8-3 / T-I1.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare

variable {R : Type*} [CommRing R]
variable {V : Type*} [AddCommGroup V] [Module R V]
variable {k : ℕ}

/-- Apply the one-body operator `D` in slot `i`. -/
def applyAt (D : V →ₗ[R] V) (i : Fin k) (v : Fin k -> V) : Fin k -> V :=
  Function.update v i (D (v i))

/-- Applying `D` twice in the same slot inserts `D^2` there. -/
theorem applyAt_same (D : V →ₗ[R] V) (i : Fin k) (v : Fin k -> V) :
    applyAt D i (applyAt D i v) = Function.update v i (D (D (v i))) := by
  unfold applyAt
  simp [Function.update_idem, Function.update_self]

/-- Applying `D` in two distinct slots commutes. -/
theorem applyAt_comm (D : V →ₗ[R] V) {i j : Fin k} (hij : i ≠ j)
    (v : Fin k -> V) :
    applyAt D i (applyAt D j v) = applyAt D j (applyAt D i v) := by
  unfold applyAt
  rw [Function.update_comm hij, Function.update_of_ne hij,
    Function.update_of_ne (Ne.symm hij)]

/-- The exterior-algebra wedge of a tuple as an ordered product of generators. -/
noncomputable def wedge (v : Fin k -> V) : ExteriorAlgebra R V :=
  (List.ofFn (fun i => ExteriorAlgebra.ι R (v i))).prod

section Core

variable {M : Type*} [AddCommGroup M]

/-- Combinatorial core: a double Leibniz sum splits into the diagonal part plus
twice the strict-upper-triangular off-diagonal part. -/
theorem double_sum_split (D : V →ₗ[R] V) (W : (Fin k -> V) -> M) (v : Fin k -> V) :
    (∑ i, ∑ j, W (applyAt D i (applyAt D j v)))
      = (∑ i, W (applyAt D i (applyAt D i v)))
        + 2 • (∑ p ∈ Finset.univ.filter (fun p : Fin k × Fin k => p.1 < p.2),
                  W (applyAt D p.1 (applyAt D p.2 v))) := by
  rw [← Finset.sum_product']
  rw [show (Finset.univ ×ˢ Finset.univ : Finset (Fin k × Fin k)) =
      Finset.image (fun i => (i, i)) Finset.univ ∪
        Finset.filter (fun p : Fin k × Fin k => p.1 < p.2) Finset.univ ∪
        Finset.filter (fun p : Fin k × Fin k => p.2 < p.1) Finset.univ from ?_,
    Finset.sum_union, Finset.sum_union]
  · simp +decide [two_smul]
    rw [Finset.sum_image] <;> simp +decide [add_assoc]
    · apply Finset.sum_bij (fun p hp => (p.2, p.1))
      · grind
      · grind
      · aesop
      · intro a ha
        simp only [Finset.mem_filter] at ha
        exact congr_arg W (applyAt_comm D ha.2.ne' v)
    · exact fun i j h => by injection h
  · simp +decide [Finset.disjoint_left]
  · simp +decide [Finset.disjoint_left]
    exact fun a b h => h.elim (fun h => h.le) fun h => h.le
  · grind

end Core

/-- One-body second quantization on a decomposable state. -/
noncomputable def dGamma (K : V →ₗ[R] V) (v : Fin k -> V) : ExteriorAlgebra R V :=
  ∑ i, wedge (applyAt K i v)

/-- The Leibniz action of `dGamma(D)^2` on a decomposable state. -/
noncomputable def dGammaSq (D : V →ₗ[R] V) (v : Fin k -> V) :
    ExteriorAlgebra R V :=
  ∑ i, ∑ j, wedge (applyAt D i (applyAt D j v))

/-- Two-body second quantization of the pair kernel on a decomposable state. -/
noncomputable def dGammaTwo (D : V →ₗ[R] V) (v : Fin k -> V) :
    ExteriorAlgebra R V :=
  ∑ p ∈ Finset.univ.filter (fun p : Fin k × Fin k => p.1 < p.2),
    wedge (applyAt D p.1 (applyAt D p.2 v))

/-- `dGammaSq` is the Leibniz sum iterated. -/
theorem dGammaSq_eq_iterate (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaSq D v = ∑ j, dGamma D (applyAt D j v) := by
  unfold dGammaSq dGamma
  rw [Finset.sum_comm]

/-- `dGamma(D^2)` is the diagonal of the double Leibniz sum. -/
theorem dGamma_sq_op (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGamma (D ∘ₗ D) v = ∑ i, wedge (applyAt D i (applyAt D i v)) := by
  unfold dGamma
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [applyAt_same]
  rfl

/-- Finite second-quantization square identity on decomposable Fock states. -/
theorem dGamma_sq_identity (D : V →ₗ[R] V) (v : Fin k -> V) :
    dGammaSq D v = dGamma (D ∘ₗ D) v + 2 • dGammaTwo D v := by
  rw [dGammaSq, dGamma_sq_op, dGammaTwo]
  exact double_sum_split D wedge v

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.double_sum_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms double_sum_split

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dGamma_sq_identity

end PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare
