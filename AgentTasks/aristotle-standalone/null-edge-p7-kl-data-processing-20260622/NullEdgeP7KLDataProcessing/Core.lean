import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# P7 relative-entropy data-processing inequality

The core monotonicity of the P7 recoverability program: a stochastic (Markov)
map cannot increase the finite Kullback-Leibler divergence. This is the discrete
data-processing inequality for relative entropy - an observer / coarse-graining
channel can only lose distinguishability. Its (approximate) saturation is what
"recoverability" controls.

```text
KL(T p, T q) <= KL(p, q)   for column-stochastic T.
```

Standalone (Mathlib only), `Real.log 0 = 0` convention.
-/

noncomputable section

namespace NullEdgeP7KLDataProcessing

open BigOperators

/-- Finite Kullback-Leibler divergence. -/
def kl {n : Nat} (p q : Fin n -> Real) : Real :=
  Finset.univ.sum fun i => p i * Real.log (p i / q i)

/-- Apply a finite nonnegative transition matrix. -/
def applyMap {m n : Nat} (T : Fin m -> Fin n -> Real)
    (p : Fin n -> Real) : Fin m -> Real :=
  fun i => Finset.univ.sum fun j => T i j * p j

/-- Data-processing inequality: a column-stochastic map does not increase the
relative entropy (log-sum inequality). -/
theorem kl_data_processing {m n : Nat}
    (T : Fin m -> Fin n -> Real)
    (hnonneg : ∀ i j, 0 ≤ T i j)
    (hcol : ∀ j, Finset.univ.sum (fun i => T i j) = 1)
    (p q : Fin n -> Real)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i) :
    kl (applyMap T p) (applyMap T q) ≤ kl p q := by
  sorry

end NullEdgeP7KLDataProcessing
