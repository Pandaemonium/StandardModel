import PhysicsSM.Draft.NullEdge.PluckerMassDynamics

/-!
# The Pluecker mass coin is a genuine matrix exponential

This module identifies the closed-form mass coin already defined in
`PluckerMassDynamics` with the exponential of the canonical Pluecker rest
operator. For nonzero `z`, it proves the exact finite Euler formula

```text
exp(-i a B(z)) = cos(a |z|) I - i sin(a |z|) B(z) / |z|.
```

This closes the two-dimensional matrix rung of the active-sector exponential
bridge. It does not yet prove that the Fock-space operation `Uop` is the
exponential of the quartic generator `Kop`; that is a separate successor.

Provenance: clean-room integration of Aristotle project
`0bf55f18-27fe-4c74-8643-5ab8f8cd5d6e`, task returned 2026-07-12. The target
statement was replayed unchanged in its standalone package before this proof
was adapted to the canonical `massOperator` API. Conventions are those of
`PluckerMassOperator`: `B(z) = [[0,z],[conj z,0]]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PluckerMassOperatorExponential

open Matrix
open PhysicsSM.Draft.NullEdge.PluckerMassOperator

/-- Matrix Euler formula for the canonical Pluecker rest operator. -/
theorem massOperator_exp_euler (z : Complex) (a : Real) (hz : z ≠ 0) :
    NormedSpace.exp ((-(a : Complex) * Complex.I) • massOperator z)
      = (Real.cos (a * ‖z‖) : Complex) • (1 : Mat)
        - (Complex.I * ((Real.sin (a * ‖z‖) / ‖z‖) : Complex)) •
            massOperator z := by
  have hUunit : IsUnit
      (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat) := by
    norm_num [Matrix.isUnit_iff_isUnit_det, Matrix.det_fin_two]
    ring_nf
    aesop
  have hUinv :
      (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat)⁻¹ =
        !![1 / (2 * z), 1 / (2 * ‖z‖);
          1 / (2 * z), -1 / (2 * ‖z‖)] := by
    rw [Matrix.inv_eq_right_inv]
    norm_num
    ring
    norm_num [hz]
    ring
    exact Matrix.one_fin_two.symm
  have hdiag :
      (-a * Complex.I) • massOperator z =
        (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat) *
          Matrix.diagonal
            ![(-a * Complex.I) * ‖z‖, -(-a * Complex.I) * ‖z‖] *
          (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat)⁻¹ := by
    simp_all +decide [massOperator, Matrix.smul_eq_diagonal_mul]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.vecMul, Matrix.vecHead, Matrix.vecTail] <;>
      ring_nf <;> norm_num [hz, Complex.ext_iff]
    norm_cast
    simp +decide [Complex.normSq_eq_norm_sq]
    ring_nf
    aesop
  have hexpDiag :
      NormedSpace.exp
          ((Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat) *
            Matrix.diagonal
              ![(-a * Complex.I) * ‖z‖, -(-a * Complex.I) * ‖z‖] *
            (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat)⁻¹) =
        (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat) *
          Matrix.diagonal
            ![Complex.exp ((-a * Complex.I) * ‖z‖),
              Complex.exp (-(-a * Complex.I) * ‖z‖)] *
          (Matrix.of ![![z, z], ![‖z‖, -‖z‖]] : Mat)⁻¹ := by
    rw [Matrix.exp_conj _ _ hUunit, Matrix.exp_diagonal]
    have hv :
        NormedSpace.exp
            (![(-a * Complex.I) * ‖z‖,
              -(-a * Complex.I) * ‖z‖] : Fin 2 -> Complex) =
          ![Complex.exp ((-a * Complex.I) * ‖z‖),
            Complex.exp (-(-a * Complex.I) * ‖z‖)] := by
      ext i
      fin_cases i <;> simp [Pi.coe_exp, Complex.exp_eq_exp_ℂ]
    rw [hv]
  rw [hdiag, hexpDiag, hUinv]
  have hp :
      Complex.exp ((-a * Complex.I) * ‖z‖) =
        (Real.cos (a * ‖z‖) : Complex) -
          (Real.sin (a * ‖z‖) : Complex) * Complex.I := by
    have h :
        (-a * Complex.I) * (‖z‖ : Complex) =
          ((-(a * ‖z‖) : Real) : Complex) * Complex.I := by
      push_cast
      ring
    rw [h, Complex.exp_mul_I, ← Complex.ofReal_cos, ← Complex.ofReal_sin]
    push_cast [Real.cos_neg, Real.sin_neg]
    ring
  have hq :
      Complex.exp (-(-a * Complex.I) * ‖z‖) =
        (Real.cos (a * ‖z‖) : Complex) +
          (Real.sin (a * ‖z‖) : Complex) * Complex.I := by
    have h :
        (-(-a * Complex.I)) * (‖z‖ : Complex) =
          ((a * ‖z‖ : Real) : Complex) * Complex.I := by
      push_cast
      ring
    rw [h, Complex.exp_mul_I, ← Complex.ofReal_cos, ← Complex.ofReal_sin]
  rw [hp, hq]
  have hnorm : (‖z‖ : Complex) ≠ 0 := by
    exact_mod_cast (norm_ne_zero_iff.2 hz)
  have hconj :
      (starRingEnd Complex) z = (‖z‖ : Complex) ^ 2 / z := by
    rw [eq_div_iff hz, mul_comm, Complex.mul_conj,
      Complex.normSq_eq_norm_sq]
    push_cast
    ring
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [massOperator, hconj, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.smul_apply, Matrix.vecMul_diagonal, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.of_apply] <;>
    field_simp <;> ring

/-- The existing closed-form mass coin is exactly `exp(-i a B(z))`. -/
theorem exp_eq_massCoin (z : Complex) (a : Real) (hz : z ≠ 0) :
    NormedSpace.exp ((-(a : Complex) * Complex.I) • massOperator z) =
      PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin z a := by
  rw [massOperator_exp_euler z a hz]
  unfold PhysicsSM.Draft.NullEdge.PluckerMassDynamics.massCoin
  have hcos :
      Complex.cos ((a : Complex) * (‖z‖ : Complex)) =
        (Real.cos (a * ‖z‖) : Complex) := by
    rw [← Complex.ofReal_mul, ← Complex.ofReal_cos]
  have hsin :
      Complex.sin ((a : Complex) * (‖z‖ : Complex)) =
        (Real.sin (a * ‖z‖) : Complex) := by
    rw [← Complex.ofReal_mul, ← Complex.ofReal_sin]
  rw [hcos, hsin]
  push_cast
  simp [div_eq_mul_inv, mul_assoc]

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassOperatorExponential.massOperator_exp_euler' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massOperator_exp_euler

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerMassOperatorExponential.exp_eq_massCoin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exp_eq_massCoin

end PhysicsSM.Draft.NullEdge.PluckerMassOperatorExponential
