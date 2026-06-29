import Mathlib

/-!
# Abstract overlap/Ginsparg-Wilson algebra

This module isolates the purely algebraic core of the overlap construction.
It does not define a functional calculus or prove locality.  It records the
finite-matrix identity used by Neuberger/Ginsparg-Wilson overlap operators:

if `gamma5^2 = 1` and the sign-like factor `eps` is an involution, then
`D = 1 + gamma5 * eps` satisfies the normalized Ginsparg-Wilson relation

`gamma5 * D + D * gamma5 = D * gamma5 * D`.

This is a downstream C1 brick: later modules must prove that the null-edge
Hermitian kernel supplies an appropriate `eps = sign(H_ne)`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace OverlapGinspargWilson

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Normalized overlap Dirac matrix from chirality `gamma5` and sign-like
involution `eps`.  The physical prefactor `rho/a` is omitted because it is a
scalar normalization outside this algebraic identity. -/
def Dov (gamma5 eps : Matrix Spin Spin ℂ) : Matrix Spin Spin ℂ :=
  1 + gamma5 * eps

/-- Pure algebraic Ginsparg-Wilson identity for the normalized overlap matrix.

No anticommutation hypothesis is required: the identity follows only from
`gamma5^2 = 1` and `eps^2 = 1`.
-/
theorem dov_ginsparg_wilson
    (gamma5 eps : Matrix Spin Spin ℂ)
    (hgamma5_sq : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (heps_sq : eps * eps = (1 : Matrix Spin Spin ℂ)) :
    gamma5 * Dov gamma5 eps + Dov gamma5 eps * gamma5 =
      Dov gamma5 eps * gamma5 * Dov gamma5 eps := by
  unfold Dov
  have hgamma5_gamma5_eps : gamma5 * (gamma5 * eps) = eps := by
    rw [← Matrix.mul_assoc, hgamma5_sq, one_mul]
  have htail :
      gamma5 * (eps * (gamma5 * (gamma5 * eps))) = gamma5 := by
    rw [hgamma5_gamma5_eps]
    rw [heps_sq, mul_one]
  simp [mul_add, add_mul, Matrix.mul_assoc, hgamma5_sq, heps_sq,
    hgamma5_gamma5_eps, htail]
  abel

end OverlapGinspargWilson
end GateC1
end NullEdge
end Draft
end PhysicsSM
