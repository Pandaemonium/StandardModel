import Mathlib

/-!
# Helper: algebraic identity for the Hamming theta polynomial

This file proves the pure algebraic identity underlying the connection
between the Hamming weight-enumerator theta polynomial and the E4 theta
polynomial `H₂² + H₂·H₄ + H₄²`.

## Mathematical content

Given the theta-constant duplication formulas:
* `Θ₂(τ)² = 2·Θ₂(2τ)·Θ₃(2τ)`
* `Θ₄(τ)² = Θ₃(2τ)² − Θ₂(2τ)²`

setting `a = Θ₃(2τ)` and `b = Θ₂(2τ)`, we get:
* `H₂ = Θ₂(τ)⁴ = (2ab)² = 4a²b²`
* `H₄ = Θ₄(τ)⁴ = (a²−b²)²`

The Hamming weight-enumerator polynomial evaluates to:
```
a⁸ + 14a⁴b⁴ + b⁸
```

The E₄ theta polynomial is:
```
H₂² + H₂·H₄ + H₄²
= (4a²b²)² + (4a²b²)(a²−b²)² + ((a²−b²)²)²
= 16a⁴b⁴ + 4a²b²(a⁴−2a²b²+b⁴) + (a⁴−2a²b²+b⁴)²
= a⁸ + 14a⁴b⁴ + b⁸
```

This file proves this algebraic identity, which is the core of the
theta-constant proof that the Hamming polynomial equals `E₄`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.setOption false

namespace PhysicsSM.Coding.E8ThetaDuplicationHelper

/--
Pure algebraic identity: the E4 theta polynomial `(2ab)⁴ + (2ab)²(a²−b²)² + (a²−b²)⁴`
equals the Hamming weight-enumerator polynomial `a⁸ + 14a⁴b⁴ + b⁸`.

This is the core algebraic content of the classical identity
`E₄ = Θ₃(2τ)⁸ + 14·Θ₃(2τ)⁴·Θ₂(2τ)⁴ + Θ₂(2τ)⁸`, modulo the theta-constant
duplication formulas.
-/
theorem hamming_theta_algebraic_identity (a b : ℂ) :
    ((2 * b * a) ^ 2) ^ 2 + ((2 * b * a) ^ 2) * ((a ^ 2 - b ^ 2) ^ 2) +
    ((a ^ 2 - b ^ 2) ^ 2) ^ 2 =
    a ^ 8 + 14 * a ^ 4 * b ^ 4 + b ^ 8 := by
  ring

/--
The algebraic identity in the opposite direction (matching the theta-polynomial
convention `H₂² + H₂·H₄ + H₄²`).
-/
theorem hamming_theta_algebraic_identity' (a b : ℂ) :
    a ^ 8 + 14 * a ^ 4 * b ^ 4 + b ^ 8 =
    ((2 * b * a) ^ 2) ^ 2 + ((2 * b * a) ^ 2) * ((a ^ 2 - b ^ 2) ^ 2) +
    ((a ^ 2 - b ^ 2) ^ 2) ^ 2 := by
  ring

end PhysicsSM.Coding.E8ThetaDuplicationHelper
