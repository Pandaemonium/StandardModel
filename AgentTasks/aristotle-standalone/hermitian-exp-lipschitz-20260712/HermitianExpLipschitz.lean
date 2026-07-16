import Mathlib

/-!
# Aristotle target: sharp Lipschitz control for finite Hermitian evolution

For Hermitian four-by-four matrices `H` and `K`, prove the sharp Duhamel bound

`||exp(-i t H) - exp(-i t K)|| <= |t| * ||H - K||`.

This is the missing analytic core for controlling variation of the exact
Dirac multiplier inside refining momentum cells. The sharp unitary estimate is
load-bearing: a generic bound with an exponential in `||H|| + ||K||` is not an
acceptable replacement because the active momentum window grows with the
refinement schedule.

Keep the target statement unchanged. A proof may introduce local lemmas for a
matrix-valued Duhamel integral, differentiability of the interpolating product,
or the operator norm of unitary left/right multiplication. Do not add new
assumptions. Run `lake env lean HermitianExpLipschitz.lean`.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace HermitianExpLipschitz

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- **TARGET.** Hermitian matrix evolution is one-Lipschitz in its generator,
with elapsed time as the exact scale factor. -/
theorem hermitian_exp_lipschitz (H K : Mat4)
    (hH : H.IsHermitian) (hK : K.IsHermitian) (t : Real) :
    ‖NormedSpace.exp ((-(t : Complex)) • (Complex.I • H)) -
        NormedSpace.exp ((-(t : Complex)) • (Complex.I • K))‖ <=
      |t| * ‖H - K‖ := by
  sorry

end HermitianExpLipschitz
