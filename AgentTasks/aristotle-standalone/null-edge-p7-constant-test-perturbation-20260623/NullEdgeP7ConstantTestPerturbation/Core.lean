import Mathlib.Tactic

noncomputable section

namespace NullEdgeP7ConstantTestPerturbation

open BigOperators

def constantTest {N : Nat} (source : Fin N -> Real) : Real :=
  Finset.univ.sum source

theorem constantTest_add_invisible_eq {N : Nat}
    (background residual : Fin N -> Real)
    (hinv : constantTest residual = 0) :
    constantTest (fun i => background i + residual i) =
      constantTest background := by
  sorry

end NullEdgeP7ConstantTestPerturbation
