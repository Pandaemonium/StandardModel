import PhysicsSM.Draft.NullEdge.D4NullShellLattice
import PhysicsSM.Spinor.PluckerMass

/-!
# Explicit spinor decorations for the future D4 null rays

Each of the six future axial rays in the selected D4 null shell is assigned an
explicit Gaussian-integer two-spinor. Its rank-one Hermitian matrix is exactly
the half-Pauli image of the corresponding positively scaled root. This is a
direct finite arrow from selected primitive null directions to the spinor
decorations used by the Gram/Pluecker mass layer.

The time axis and finite axial alphabet remain selected data. This module does
not choose amplitudes or gates, derive Lorentz covariance of the finite set, or
cover arbitrary continuum null directions.

Provenance: PhysLean Pauli conventions consulted during the 2026-07-10 01:24
package pass; clean-room proof completed by Aristotle project
`a7666500-fdf4-4b4a-9872-4325eb958ae7` and ported to the project Pluecker API.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.D4NullRaySpinorFactorization

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.D4NullShellLattice

inductive FutureRay where
  | xPos | xNeg | yPos | yNeg | zPos | zNeg
  deriving DecidableEq, Fintype, Repr

def root : FutureRay -> Vec4
  | .xPos => ![1, 1, 0, 0]
  | .xNeg => ![1, -1, 0, 0]
  | .yPos => ![1, 0, 1, 0]
  | .yNeg => ![1, 0, -1, 0]
  | .zPos => ![1, 0, 0, 1]
  | .zNeg => ![1, 0, 0, -1]

def rayScale : FutureRay -> ℤ
  | .xPos | .xNeg | .yPos | .yNeg => 2
  | .zPos | .zNeg => 1

def scaledRoot (r : FutureRay) : Vec4 := fun i => rayScale r * root r i

def spinor : FutureRay -> CSpinor
  | .xPos => ![1, 1]
  | .xNeg => ![1, -1]
  | .yPos => ![1, I]
  | .yNeg => ![1, -I]
  | .zPos => ![1, 0]
  | .zNeg => ![0, 1]

/-- Half-Pauli map for signature `(+---)` and coordinates `(t,x,y,z)`. -/
noncomputable def pauliHalf (v : Vec4) : Matrix (Fin 2) (Fin 2) ℂ :=
  ((1 / 2 : ℝ) : ℂ) •
    !![((v 0 + v 3 : ℤ) : ℂ),
       ((v 1 : ℂ) - I * (v 2 : ℂ));
       ((v 1 : ℂ) + I * (v 2 : ℂ)),
       ((v 0 - v 3 : ℤ) : ℂ)]

theorem roots_are_selected_future_null :
    ∀ r : FutureRay, root r 0 = 1 ∧ root r ∈ nullRoots := by
  intro r
  fin_cases r <;> exact ⟨rfl, by decide⟩

theorem scales_positive : ∀ r : FutureRay, 0 < rayScale r := by
  intro r
  fin_cases r <;> decide

/-- Every future axial D4 null ray has an explicit Gaussian-integer spinor
factor, up to the displayed positive projective scale. -/
theorem all_d4_null_rays_factor :
    ∀ r : FutureRay,
      rankOneHermitian (spinor r) = pauliHalf (scaledRoot r) := by
  intro r
  fin_cases r <;>
    (ext i j
     fin_cases i <;> fin_cases j <;>
       simp [rankOneHermitian, pauliHalf, spinor, scaledRoot, rayScale, root,
         Matrix.vecMulVec, Complex.ext_iff])

/-- Distinct axial rays are not collapsed to one spinor direction. -/
theorem noncollinear_spinor_control :
    spinorWedge (spinor .xPos) (spinor .yPos) ≠ 0 := by
  simp [spinorWedge, spinor, Complex.ext_iff]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.D4NullRaySpinorFactorization.all_d4_null_rays_factor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms all_d4_null_rays_factor

/-- info: 'PhysicsSM.Draft.NullEdge.D4NullRaySpinorFactorization.noncollinear_spinor_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms noncollinear_spinor_control

end PhysicsSM.Draft.NullEdge.D4NullRaySpinorFactorization
