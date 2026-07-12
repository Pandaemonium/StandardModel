import Mathlib

/-!
# Quadratic chirality-mixing regulator

This module formalizes a concrete escape resource for a chirally split
three-dimensional Dirac tangent. The regulator is zero at the origin and has
zero Frechet derivative there, but is nonzero and chirality-odd away from the
origin. It is not a unitary walk, a no-doubling theorem, or a strict Laurent
construction.

Provenance: theorem statements and fixtures prepared locally from the corrected
July 11, 2026 3+1 strategy; proofs completed without statement changes by
Aristotle project `f6609f77-513e-4315-a990-9c04e1f5f5cf`, task
`189ec6f8-ebf7-4ee3-abf0-56b4320bf8c5`.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.QuadraticChiralityRegulator

abbrev V := Fin 3 -> Real
abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

noncomputable def q (k : V) : Real :=
  ∑ i, k i ^ 2

noncomputable def regulator (R : M4) (k : V) : M4 :=
  (q k : Complex) • R

def XiFixture : M4 :=
  !![1,0,0,0;0,1,0,0;0,0,-1,0;0,0,0,-1]

def RFixture : M4 :=
  !![0,0,1,0;0,0,0,1;1,0,0,0;0,1,0,0]

theorem q_zero : q 0 = 0 := by
  simp [q]

theorem q_single_one (j : Fin 3) : q (Pi.single j 1) = 1 := by
  simp only [q]
  rw [Finset.sum_eq_single j]
  · simp
  · intro b _ hb
    simp [Pi.single_eq_of_ne hb]
  · intro h
    exact absurd (Finset.mem_univ j) h

/-- The regulator is invisible to the constant term of the Dirac tangent. -/
theorem regulator_zero (R : M4) : regulator R 0 = 0 := by
  simp [regulator, q_zero]

/-- The regulator is invisible to the complete first jet at the origin. -/
theorem regulator_hasFDerivAt_zero (R : M4) :
    HasFDerivAt (𝕜 := Real) (regulator R) 0 0 := by
  have hq : HasFDerivAt (𝕜 := Real) (fun k : V => (q k : Complex)) 0 0 := by
    have hqr : HasFDerivAt (𝕜 := Real) (fun k : V => q k) 0 0 := by
      simp only [q]
      rw [show (fun k : V => ∑ i, k i ^ 2) =
          ∑ i : Fin 3, (fun k : V => k i ^ 2) from by funext k; simp]
      have hs : HasFDerivAt (𝕜 := Real) (∑ i : Fin 3, fun k : V => k i ^ 2)
          (∑ i : Fin 3, (0 : V →L[Real] Real)) 0 := by
        apply HasFDerivAt.sum
        intro i _
        have hproj : HasFDerivAt (𝕜 := Real) (fun k : V => k i)
            (ContinuousLinearMap.proj i) 0 :=
          (ContinuousLinearMap.proj (R := Real)
            (φ := fun _ : Fin 3 => Real) i).hasFDerivAt
        have h := hproj.pow 2
        simpa using h
      simpa using hs
    have h := (Complex.ofRealCLM.hasFDerivAt (x := q 0)).comp 0 hqr
    simpa using h
  letI : NormedAddCommGroup M4 :=
    inferInstanceAs (NormedAddCommGroup (Fin 4 → Fin 4 → Complex))
  letI : NormedSpace Real M4 :=
    inferInstanceAs (NormedSpace Real (Fin 4 → Fin 4 → Complex))
  letI : NormedSpace Complex M4 :=
    inferInstanceAs (NormedSpace Complex (Fin 4 → Fin 4 → Complex))
  letI : IsBoundedSMul Complex M4 :=
    inferInstanceAs (IsBoundedSMul Complex (Fin 4 → Fin 4 → Complex))
  have h := hq.smul_const R
  have e : ContinuousLinearMap.smulRight (0 : V →L[Real] Complex) R = 0 := by
    ext
    simp
  rw [e] at h
  exact h

/-- A one-axis unit fixture sees the regulator exactly, so the construction is
not the zero function. -/
theorem regulator_single_one (R : M4) (j : Fin 3) :
    regulator R (Pi.single j 1) = R := by
  simp [regulator, q_single_one]

theorem XiFixture_sq : XiFixture * XiFixture = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [XiFixture, Matrix.mul_apply, Fin.sum_univ_four]

theorem fixture_anticommutes :
    XiFixture * RFixture = -(RFixture * XiFixture) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [XiFixture, RFixture, Matrix.mul_apply, Fin.sum_univ_four]

theorem fixture_product_ne_zero : XiFixture * RFixture ≠ 0 := by
  intro h
  have h02 := congrFun (congrFun h 0) 2
  simp [XiFixture, RFixture, Matrix.mul_apply, Fin.sum_univ_four] at h02

/-- The exact higher-order escape fixture: no constant or linear change at the
origin, but genuine chirality mixing at a finite momentum. -/
theorem explicit_nonzero_chirality_mixing :
    XiFixture * regulator RFixture (Pi.single 0 1) ≠
      regulator RFixture (Pi.single 0 1) * XiFixture := by
  rw [regulator_single_one]
  intro h
  have hanti := fixture_anticommutes
  rw [h] at hanti
  have hzero : RFixture * XiFixture = 0 := by
    have h2 : RFixture * XiFixture + RFixture * XiFixture = 0 := by
      rw [eq_neg_iff_add_eq_zero] at hanti
      exact hanti
    have hsmul : (2 : Complex) • (RFixture * XiFixture) = 0 := by
      rw [two_smul]
      exact h2
    simpa using hsmul
  rw [← h] at hzero
  exact fixture_product_ne_zero hzero

end PhysicsSM.Draft.NullEdge.QuadraticChiralityRegulator
