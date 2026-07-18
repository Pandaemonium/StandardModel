import PhysicsSM.Draft.NullEdge.NullEdgeSpinorSolderingAristotle
import PhysicsSM.Spinor.PluckerMass
import PhysicsSM.Draft.NullEdge.SL2CLorentzAction
import PhysicsSM.Spinor.SpinCornerBargmann

/-!
# Bridge: the null-edge soldering IS both landed islands

The soldering capstone (`NullEdgeSpinorSolderingAristotle`) was written as a
self-contained Mathlib-only package. This module proves it is not a parallel
redefinition: it coincides with BOTH landed islands it was built to join.

Pluecker (mass) side: its rank-one Hermitian, its spinor wedge, and its
emergent Minkowski mass coincide with the landed `Spinor.PluckerMass`
objects. The headline `soldering_mass_eq_plucker_det`: the Minkowski invariant
mass squared of the timelike sum of two null edges equals the determinant
Pluecker mass of their summed momenta - one is the spacetime-geometry face and
the other the spinor-algebra face of the SAME number.

SL(2,C) (Lorentz) side: `nullEdgeVector_eq_hermitianCoords` proves the
soldered null-edge 4-vector IS the project's Pauli coordinate map
`SL2CLorentzAction.hermitianCoords` applied to `psi psi-dagger`. So the null
edges are literally the future-null directions in the same Minkowski space on
which the landed SL(2,C) -> SO+(1,3) action operates: the capstone's abstract
soldering and the project's Lorentz representation are the same map.

Claim grade: `M [orig]`, finite definitional bridges. Standard-three axioms.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge

open NullEdgeSpinorSoldering

/-- The soldering rank-one Hermitian is the Pluecker `rankOneHermitian`. -/
theorem rankOne_eq_rankOneHermitian (psi : Fin 2 → ℂ) :
    rankOne psi = PhysicsSM.Spinor.PluckerMass.rankOneHermitian psi := by
  ext i j
  simp [rankOne, PhysicsSM.Spinor.PluckerMass.rankOneHermitian, Matrix.vecMulVec,
    Pi.star_apply]

/-- The soldering spinor wedge is the Pluecker `spinorWedge`. -/
theorem spinorWedge_eq (psi chi : Fin 2 → ℂ) :
    spinorWedge psi chi = PhysicsSM.Spinor.PluckerMass.spinorWedge psi chi := rfl

/-- **The two islands carry the same mass.** The emergent Minkowski invariant
mass squared of the timelike sum of two null edges equals the determinant
Pluecker mass of their summed rank-one momenta. -/
theorem soldering_mass_eq_plucker_det (psi chi : Fin 2 → ℂ) :
    ((minkowskiSq (nullEdgeVector psi + nullEdgeVector chi) : ℝ) : ℂ) =
      (PhysicsSM.Spinor.PluckerMass.twoEdgeMomentum psi chi).det := by
  rw [twoEdge_minkowskiSq_eq_wedge,
    PhysicsSM.Spinor.PluckerMass.two_edge_plucker_mass_identity,
    PhysicsSM.Spinor.PluckerMass.complexAbsSq_eq_ofReal_normSq, spinorWedge_eq]

/-- **The soldered null-edge vector is the project's Pauli coordinate.** On the
Hermitian `psi psi-dagger` the soldering `nullEdgeVector` coincides with
`SL2CLorentzAction.hermitianCoords`, so a null edge is a future-null direction
in the SAME Minkowski space carrying the landed SL(2,C) -> SO+(1,3) action. -/
theorem nullEdgeVector_eq_hermitianCoords (psi : Fin 2 → ℂ) :
    nullEdgeVector psi =
      PhysicsSM.Draft.NullEdge.SL2CLorentzAction.hermitianCoords (rankOne psi) := by
  ext i
  fin_cases i <;>
    simp [nullEdgeVector, vecOfHerm,
      PhysicsSM.Draft.NullEdge.SL2CLorentzAction.hermitianCoords, rankOne,
      Complex.add_re, Complex.sub_re, Complex.mul_re, Complex.mul_im,
      Complex.conj_re, Complex.conj_im] <;> ring

open PhysicsSM.Spinor.SpinCornerBargmann in
/-- Bloch (celestial-sphere) direction of a null edge. -/
def bloch (psi : Fin 2 → ℂ) : Vec3 :=
  ![2 * (psi 0 * (starRingEnd ℂ) (psi 1)).re,
    -2 * (psi 0 * (starRingEnd ℂ) (psi 1)).im,
    Complex.normSq (psi 0) - Complex.normSq (psi 1)]

open PhysicsSM.Spinor.SpinCornerBargmann in
/-- **The spiral corner projector IS the soldered null edge.** For a unit null
edge, `psi psi-dagger` equals the spiral-layer spin-coherent corner projector
`proj` at the Bloch/celestial direction. So the spiral corner calculus
(`SpinCornerBargmann`) is the exact calculus of null-edge DIRECTIONS on the
celestial sphere: the pair trace is a two-edge overlap, and the three-cycle
oriented-volume phase is a geometric phase of three null directions. Proof
obtained from Aristotle project 9b778014 against identical definitions. -/
theorem rankOne_eq_proj_bloch (psi : Fin 2 → ℂ)
    (h : Complex.normSq (psi 0) + Complex.normSq (psi 1) = 1) :
    rankOne psi = proj (bloch psi) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp_all +decide [ rankOne, proj, bloch, pauli, sigmaX, sigmaY, sigmaZ, Complex.normSq_apply, Complex.mul_re, Complex.mul_im, Complex.conj_re, Complex.conj_im ] ; ring_nf at *;
  · norm_num [ Complex.ext_iff, sq ] at * ; constructor <;> linarith;
  · simp +decide [ Complex.ext_iff, mul_two, two_mul ] ; ring;
    norm_num;
  · norm_num [ Complex.ext_iff ] ; ring;
    norm_num;
  · norm_num [ Complex.ext_iff ] at * ; constructor <;> linarith!;

end PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge.soldering_mass_eq_plucker_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge.soldering_mass_eq_plucker_det

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge.nullEdgeVector_eq_hermitianCoords' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge.nullEdgeVector_eq_hermitianCoords

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge.rankOne_eq_proj_bloch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge.rankOne_eq_proj_bloch

end
