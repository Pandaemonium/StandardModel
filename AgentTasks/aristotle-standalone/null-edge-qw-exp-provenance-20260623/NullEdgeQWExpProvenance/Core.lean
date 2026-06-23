import Mathlib

/-!
# Null-step quantum-walk exponential provenance

This focused handoff asks Aristotle to connect the closed-form rotation gates
used in the null-step quantum-walk core to literal matrix exponentials of Pauli
generators.

The already-integrated core deliberately defines `Rz` and `Rx` by Euler closed
forms because those are enough for trace, determinant, quasienergy, and
continuum-coherence theorems. These two provenance lemmas are optional, but they
make the paper-facing notation

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x)
```

match the formal definitions directly.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace NullEdgeQWExpProvenance

abbrev CMat2 := Matrix (Fin 2) (Fin 2) ℂ

/-- Pauli `sigma_x`. -/
def sigmaX : CMat2 :=
  !![(0 : ℂ), 1; 1, 0]

/-- Pauli `sigma_z`. -/
def sigmaZ : CMat2 :=
  !![(1 : ℂ), 0; 0, -1]

/-- Closed-form `z` rotation gate. -/
def Rz (theta : ℝ) : CMat2 :=
  !![Complex.exp (-(theta : ℂ) * I), 0; 0, Complex.exp ((theta : ℂ) * I)]

/-- Closed-form `x` rotation gate. -/
def Rx (theta : ℝ) : CMat2 :=
  !![Complex.cos (theta : ℂ), -(I * Complex.sin (theta : ℂ));
     -(I * Complex.sin (theta : ℂ)), Complex.cos (theta : ℂ)]

/-- The closed-form `Rz` gate is the matrix exponential of `-i theta sigma_z`. -/
theorem Rz_eq_exp (theta : ℝ) :
    Rz theta = NormedSpace.exp (((-(theta : ℂ) * I) : ℂ) • sigmaZ) := by
  sorry

/-- The closed-form `Rx` gate is the matrix exponential of `-i theta sigma_x`. -/
theorem Rx_eq_exp (theta : ℝ) :
    Rx theta = NormedSpace.exp (((-(theta : ℂ) * I) : ℂ) • sigmaX) := by
  sorry

/-- Exponential provenance for the one-step walk. -/
theorem Ua_eq_exp_product (a k mu : ℝ) :
    Rz (k * a) * Rx (mu * a)
      =
    NormedSpace.exp (((-(k * a : ℝ) : ℂ) * I) • sigmaZ)
      * NormedSpace.exp (((-(mu * a : ℝ) : ℂ) * I) • sigmaX) := by
  rw [Rz_eq_exp, Rx_eq_exp]

end NullEdgeQWExpProvenance
