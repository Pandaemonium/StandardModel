import Mathlib

/-!
# Gate F2 (Koide) cheapest falsification: the invariant-potential no-go

The Round 7 parameter audit (`Sources/nrqg-round7-parameters.md`) proposed
Gate F2: the Koide charged-lepton relation `Q = 2/3` as an EXTREMAL ORBIT of
conjugation-invariant potentials on the rank-3 Jordan algebra (real form
`Herm_3(R)` first).  The Round 8 gate lifecycle requires the cheapest
falsification to run first.  This module IS that falsification, and it FIRES:

**No conjugation-invariant potential has a critical point with three distinct
eigenvalues.**

Reduction (prose; standard chain rule, not formalized here): a
conjugation-invariant potential is a function `V = F(s1, s2, s3)` of the
elementary symmetric functions of the eigenvalues `(x, y, z)` (for `Herm_3`
over `R`, `C`, or the Albert algebra alike, via the respective spectral
theorems).  Invariance makes orbit directions flat, so criticality is
criticality in the eigenvalue directions, where the chain rule gives

    dV/dx = f1 + f2 * (y + z) + f3 * (y * z)     (and cyclically),

with `f_i = dF/ds_i` evaluated at the point - the SAME constants in all three
equations.  Lagrange-constrained versions (critical subject to invariant
constraints) have the same form with shifted constants.  The formalized
content below is the algebraic core: any solution of that system with not all
coefficients zero has a repeated eigenvalue; equivalently three distinct
eigenvalues force `f1 = f2 = f3 = 0`.

Consequence for Gate F2 (recorded in
`AgentTasks/nerd-gate-f2-koide-preregistration-2026-07-03.md`): the NAIVE
formulation F2.0 ("the Koide configuration - three distinct sqrt-masses - is
a critical point of an invariant potential") is DEAD for the entire class of
fully invariant potentials, constrained or not.  Any surviving F2 must break
full invariance - e.g. potentials invariant only under the stabilizer of the
democratic direction (the spurion class F2.1 named in the pre-registration).
This is a filed null in the Round 8 sense: a deliverable, not a failure.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **finite identity** (algebraic no-go core; the calculus
reduction from matrix space to eigenvalue coordinates is standard and cited
in prose only).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateF2
namespace InvariantPotentialNogo

/-- **Distinct spectrum kills an invariant gradient.**  If the three
eigenvalue-direction gradient components of an invariant potential vanish at
a point with three pairwise-distinct eigenvalues, then all three invariant
derivatives vanish: the potential is critical there only if it is (to first
order) the trivial potential. -/
theorem distinct_spectrum_kills_invariant_gradient
    (f1 f2 f3 x y z : ℝ)
    (hx : f1 + f2 * (y + z) + f3 * (y * z) = 0)
    (hy : f1 + f2 * (x + z) + f3 * (x * z) = 0)
    (hz : f1 + f2 * (x + y) + f3 * (x * y) = 0)
    (hxy : x ≠ y) (hyz : y ≠ z) (hxz : x ≠ z) :
    f1 = 0 ∧ f2 = 0 ∧ f3 = 0 := by
  have hyx : y - x ≠ 0 := sub_ne_zero.mpr (Ne.symm hxy)
  have hzy : z - y ≠ 0 := sub_ne_zero.mpr (Ne.symm hyz)
  have hzx : z - x ≠ 0 := sub_ne_zero.mpr (Ne.symm hxz)
  -- pairwise differences of the gradient equations factor cleanly
  have d1 : (y - x) * (f2 + f3 * z) = 0 := by linear_combination hx - hy
  have d2 : (z - y) * (f2 + f3 * x) = 0 := by linear_combination hy - hz
  have d3 : (z - x) * (f2 + f3 * y) = 0 := by linear_combination hx - hz
  have e1 : f2 + f3 * z = 0 := by
    rcases mul_eq_zero.mp d1 with h | h
    · exact absurd h hyx
    · exact h
  have e2 : f2 + f3 * x = 0 := by
    rcases mul_eq_zero.mp d2 with h | h
    · exact absurd h hzy
    · exact h
  -- the two linear relations force f3 = 0 (since z != x), then f2, then f1
  have hf3 : f3 = 0 := by
    have hzx' : f3 * (z - x) = 0 := by linear_combination e1 - e2
    rcases mul_eq_zero.mp hzx' with h | h
    · exact h
    · exact absurd h hzx
  have hf2 : f2 = 0 := by
    have := e1
    rw [hf3] at this
    simpa using this
  have hf1 : f1 = 0 := by
    have := hx
    rw [hf2, hf3] at this
    simpa using this
  exact ⟨hf1, hf2, hf3⟩

/-- **The no-go, critical-point form.**  Any critical point of a nontrivial
invariant potential (gradient data `(f1, f2, f3) != 0`) has a repeated
eigenvalue.  In particular the Koide configuration - three DISTINCT
charged-lepton sqrt-masses - is never such a critical point: the naive Gate
F2.0 is dead, and its kill-condition has fired. -/
theorem invariant_critical_point_has_repeated_eigenvalue
    (f1 f2 f3 x y z : ℝ)
    (hx : f1 + f2 * (y + z) + f3 * (y * z) = 0)
    (hy : f1 + f2 * (x + z) + f3 * (x * z) = 0)
    (hz : f1 + f2 * (x + y) + f3 * (x * y) = 0)
    (hnz : ¬(f1 = 0 ∧ f2 = 0 ∧ f3 = 0)) :
    x = y ∨ y = z ∨ x = z := by
  by_contra h
  push_neg at h
  obtain ⟨hxy, hyz, hxz⟩ := h
  exact hnz (distinct_spectrum_kills_invariant_gradient f1 f2 f3 x y z hx hy hz hxy hyz hxz)

end InvariantPotentialNogo
end GateF2
end NullEdge
end Draft
end PhysicsSM
