import Mathlib.Tactic

/-!
# P7/P9 constant-test invisible perturbations

This module records the additive observer-test lemma: adding a source whose
constant test vanishes does not change the constant test of a background source.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7ConstantTestPerturbation

open BigOperators

def constantTest {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum source

theorem constantTest_add_invisible_eq {N : Nat}
    (background residual : Fin N -> Real)
    (hinv : constantTest residual = 0) :
    constantTest (fun i => background i + residual i) =
      constantTest background := by
  unfold constantTest at *
  rw [Finset.sum_add_distrib, hinv, add_zero]

end PhysicsSM.Draft.NullEdgeP7ConstantTestPerturbation
