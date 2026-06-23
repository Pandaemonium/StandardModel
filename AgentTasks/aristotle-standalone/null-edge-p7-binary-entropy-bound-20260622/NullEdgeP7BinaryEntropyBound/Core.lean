import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# P7 qubit entropy bound

The binary (von Neumann) entropy of a qubit eigenvalue distribution is bounded by
`log 2`, attained at the maximally mixed state. This is the finite entropy bound
underlying the observer-channel / mixedness side of the P7 relative-entropy
program: an observer's coarse-grained qubit cannot be more uncertain than the
maximally mixed reference.

```text
H(x) = -x log x - (1-x) log(1-x) <= log 2   for x in [0,1].
```

Standalone (Mathlib only), with the `Real.log 0 = 0` convention.
-/

noncomputable section

namespace NullEdgeP7BinaryEntropyBound

/-- Binary entropy. -/
def binEntropy (x : Real) : Real := -x * Real.log x - (1 - x) * Real.log (1 - x)

/-- The binary entropy is bounded by `log 2`. -/
theorem binEntropy_le_log2 (x : Real) (h0 : 0 ≤ x) (h1 : x ≤ 1) :
    binEntropy x ≤ Real.log 2 := by
  sorry

/-- The maximally mixed qubit attains entropy `log 2`. -/
theorem binEntropy_half : binEntropy (1 / 2) = Real.log 2 := by
  sorry

end NullEdgeP7BinaryEntropyBound
