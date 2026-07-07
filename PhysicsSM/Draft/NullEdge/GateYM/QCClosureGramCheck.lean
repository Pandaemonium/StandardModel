import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1

/-!
# Gate YM: the closure-defect Gram normalization check

This file records the smallest algebraic check behind the `QC-GRAM` proposal in
the two-day carrier run: compare a linear plaquette/closure defect `1 - U` with
the unitary Gram square `(1 - U)^# (1 - U)`.

The conclusion is deliberately modest.  For a complex unitary scalar `u`, the
Gram square is not the linear defect `1 - u`; it is the Hermitian Laplacian
combination

`(1 - u)^* (1 - u) = 2 - u - u^*`.

In the `Z2` specialization used by the finite QC scalar prototypes, this becomes
twice the linear defect, so the half-normalized Gram square agrees with the
linear closure defect.  This is a normalization check only: it is not a carrier
expectation theorem, not a gauge-measure theorem, and not a nonabelian closure
positivity theorem.
-/

noncomputable section

open scoped Matrix

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace QCClosureGramCheck

open TwoStateTransferZ2L1

/-- The complex unitary defect Gram square is the Hermitian Laplacian
`2 - u - u^*`.

Thus an unqualified identification of a linear closure defect `1 - u` with the
Gram square `(1 - u)^* (1 - u)` is off by normalization and by the conjugate
term, unless the target `Q_C` slot was defined with this Laplacian
normalization. -/
theorem complex_unitaryDefectGram_eq_laplacian (u : ℂ)
    (hu : star u * u = 1) :
    star (1 - u) * (1 - u) = 2 - u - star u := by
  calc
    star (1 - u) * (1 - u) = (1 - star u) * (1 - u) := by
      simp
    _ = 2 - u - star u := by
      rw [show (1 - star u) * (1 - u) =
          1 - u - star u + star u * u by ring]
      rw [hu]
      ring

/-- Matrix/operator version of `complex_unitaryDefectGram_eq_laplacian`.

For a finite-dimensional unitary matrix `U`, the defect Gram square is the
Hermitian Laplacian `2 - U - U^*`, not the raw linear defect `1 - U`.
This is the operator-level normalization that any concrete Carrier-side
`Q_C = sum_p M_p^* M_p` factorization would have to match. -/
theorem matrix_unitaryDefectGram_eq_laplacian {n : Type*} [Fintype n]
    [DecidableEq n] (U : Matrix n n ℂ)
    (hU : Uᴴ * U = (1 : Matrix n n ℂ)) :
    (1 - U)ᴴ * (1 - U) =
      (2 : ℂ) • (1 : Matrix n n ℂ) - U - Uᴴ := by
  calc
    (1 - U)ᴴ * (1 - U) = (1 - Uᴴ) * (1 - U) := by
      simp
    _ = (2 : ℂ) • (1 : Matrix n n ℂ) - U - Uᴴ := by
      rw [show (1 - Uᴴ) * (1 - U) = 1 - U - Uᴴ + Uᴴ * U by
        noncomm_ring]
      rw [hU]
      ext i j
      by_cases hij : i = j
      · subst hij
        simp
        ring
      · simp [hij]

/-- In the self-adjoint involutive (`Z2`-type) operator case, the unnormalized
defect Gram square is twice the linear defect. -/
theorem matrix_selfAdjointInvolution_defectGram_eq_two_mul_linearDefect
    {n : Type*} [Fintype n] [DecidableEq n] (U : Matrix n n ℂ)
    (hself : Uᴴ = U) (hinv : U * U = (1 : Matrix n n ℂ)) :
    (1 - U)ᴴ * (1 - U) = (2 : ℂ) • (1 - U) := by
  rw [matrix_unitaryDefectGram_eq_laplacian U (by simpa [hself] using hinv),
    hself]
  ext i j
  by_cases hij : i = j
  · subst hij
    simp
    ring
  · simp [hij]
    ring

/-- The unnormalized `Z2` defect Gram square is twice the linear defect.

This is the finite `Z2` version of the same normalization warning: for
`u` equal to plus or minus one, `(1 - u)^2 = 2 * (1 - u)`. -/
theorem z2_defectGram_eq_two_mul_linearDefect (s : Fin 2) :
    (1 - bitSign s) ^ 2 = 2 * (1 - bitSign s) := by
  fin_cases s <;> norm_num [bitSign]

/-- The half-normalized `Z2` defect Gram square equals the linear closure
defect. -/
theorem z2_half_defectGram_eq_linearDefect (s : Fin 2) :
    (1 / 2 : ℝ) * (1 - bitSign s) ^ 2 = 1 - bitSign s := by
  fin_cases s <;> norm_num [bitSign]

end QCClosureGramCheck
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
