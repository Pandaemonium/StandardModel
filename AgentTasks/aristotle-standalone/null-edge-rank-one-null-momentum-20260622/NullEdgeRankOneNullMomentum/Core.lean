import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

/-!
# Rank-one celestial momentum is null

The visible momentum extracted from a single two-spinor `psi` via `psi psi^dagger`
(Bloch / Weyl coordinates) is a null vector: a single edge carries a massless
momentum, the foundational fact behind the celestial-Plucker mass arising only
from the spread of a multi-edge bundle. With signature (+,-,-,-),

```text
pT^2 - pX^2 - pY^2 - pZ^2 = 0.
```

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeRankOneNullMomentum

open Complex

abbrev Spinor := Fin 2 -> Complex

/-- Time component `|psi0|^2 + |psi1|^2`. -/
def pT (a : Spinor) : Real := normSq (a 0) + normSq (a 1)

/-- z component `|psi0|^2 - |psi1|^2`. -/
def pZ (a : Spinor) : Real := normSq (a 0) - normSq (a 1)

/-- x component `2 Re(psi0 conj psi1)`. -/
def pX (a : Spinor) : Real := 2 * (a 0 * star (a 1)).re

/-- y component `2 Im(psi0 conj psi1)`. -/
def pY (a : Spinor) : Real := 2 * (a 0 * star (a 1)).im

/-- Minkowski norm square in signature (+,-,-,-). -/
def minkowskiSq (a : Spinor) : Real := pT a ^ 2 - pX a ^ 2 - pY a ^ 2 - pZ a ^ 2

/-- The rank-one momentum of a single spinor is null. -/
theorem rankOne_momentum_is_null (a : Spinor) : minkowskiSq a = 0 := by
  sorry

end NullEdgeRankOneNullMomentum
