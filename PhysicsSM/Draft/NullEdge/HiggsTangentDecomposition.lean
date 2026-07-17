import PhysicsSM.Draft.NullEdgeElectroweakStabilizer
import PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable

/-!
# Electroweak Higgs tangent decomposition

This module isolates the finite linear-algebra statement behind the familiar
`4 = 3 + 1` Higgs degree-of-freedom split.  At the supplied nonzero reference
section `H0 v`, an infinitesimal complex-doublet fluctuation decomposes into:

* one real radial fluctuation, normalized as `(0, h / sqrt 2)`; and
* one physical gauge-orbit fluctuation `i * B_EW v x`.

The gauge coordinate is fixed below by setting its `T3` component to zero.
Without that choice it is unique only modulo the electromagnetic stabilizer
`span {Qgen}`, exactly as proved by `ew_stabilizer_kernel`.

This is finite tangent-space geometry.  It does not prove dynamical vacuum
selection, Goldstone equivalence, a continuum propagator, or a Higgs pole mass.
Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition

open PhysicsSM.Draft
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable

/-- The real radial tangent in the standard doublet normalization. -/
def radialTangent (h : Real) : Fin 2 -> Complex :=
  ![0, (h : Complex) / Real.sqrt 2]

/-- The physical, anti-Hermitian gauge-orbit tangent. -/
def physicalOrbitTangent (v : Real) (x : Fin 4 -> Real) : Fin 2 -> Complex :=
  Complex.I • B_EW v x

/-- The real scalar represented by the complex quantity `kappa v`. -/
def realKappa (v : Real) : Real :=
  v / (2 * Real.sqrt 2)

/-- The radial coordinate extracted from a complex-doublet fluctuation. -/
def radialCoordinate (z : Fin 2 -> Complex) : Real :=
  Real.sqrt 2 * (z 1).re

/-- A representative gauge coordinate with its `T3` component fixed to zero. -/
def gaugeFixedOrbitCoordinate (v : Real) (z : Fin 2 -> Complex) : Fin 4 -> Real :=
  ![(z 0).im / realKappa v,
    (z 0).re / realKappa v,
    0,
    (z 1).im / realKappa v]

lemma realKappa_ne_zero {v : Real} (hv : v ≠ 0) : realKappa v ≠ 0 := by
  unfold realKappa
  exact div_ne_zero hv (mul_ne_zero (by norm_num) (Real.sqrt_ne_zero'.mpr (by norm_num)))

lemma realKappa_cast (v : Real) : (realKappa v : Complex) = kappa v := by
  simp [realKappa, kappa]

lemma physicalOrbitTangent_zero (v : Real) (x : Fin 4 -> Real) :
    physicalOrbitTangent v x 0 =
      ((realKappa v * x 1 : Real) : Complex) +
        Complex.I * ((realKappa v * x 0 : Real) : Complex) := by
  rw [physicalOrbitTangent, Pi.smul_apply, B_EW_apply, <- realKappa_cast]
  simp
  ring_nf
  simp [Complex.I_sq]

lemma physicalOrbitTangent_one (v : Real) (x : Fin 4 -> Real) :
    physicalOrbitTangent v x 1 =
      Complex.I * ((realKappa v * (x 3 - x 2) : Real) : Complex) := by
  rw [physicalOrbitTangent, Pi.smul_apply, B_EW_apply, <- realKappa_cast]
  simp

lemma radialTangent_radialCoordinate_one (z : Fin 2 -> Complex) :
    radialTangent (radialCoordinate z) 1 = ((z 1).re : Complex) := by
  simp [radialTangent, radialCoordinate]

/-- Every infinitesimal Higgs-doublet fluctuation is the sum of one radial
direction and one physical gauge-orbit direction. -/
theorem tangent_eq_radial_add_physicalOrbit
    {v : Real} (hv : v ≠ 0) (z : Fin 2 -> Complex) :
    z = radialTangent (radialCoordinate z) +
      physicalOrbitTangent v (gaugeFixedOrbitCoordinate v z) := by
  have hk : realKappa v ≠ 0 := realKappa_ne_zero hv
  ext i
  fin_cases i
  · change z 0 = radialTangent (radialCoordinate z) 0 +
      physicalOrbitTangent v (gaugeFixedOrbitCoordinate v z) 0
    rw [physicalOrbitTangent_zero]
    apply Complex.ext
    · simp [radialTangent, gaugeFixedOrbitCoordinate]
      field_simp
    · simp [radialTangent, gaugeFixedOrbitCoordinate]
      field_simp
  · change z 1 = radialTangent (radialCoordinate z) 1 +
      physicalOrbitTangent v (gaugeFixedOrbitCoordinate v z) 1
    rw [radialTangent_radialCoordinate_one,
      physicalOrbitTangent_one]
    apply Complex.ext
    · simp [gaugeFixedOrbitCoordinate]
    · simp [gaugeFixedOrbitCoordinate]
      field_simp

/-- A radial tangent can equal a physical orbit tangent only trivially, up to
the electromagnetic coordinate redundancy. -/
theorem radialTangent_eq_physicalOrbit_iff
    {v : Real} (hv : v ≠ 0) (h : Real) (x : Fin 4 -> Real) :
    radialTangent h = physicalOrbitTangent v x ↔
      h = 0 ∧ x ∈ Submodule.span Real ({Qgen} : Set (Fin 4 -> Real)) := by
  rw [← ew_stabilizer_kernel hv]
  simp only [LinearMap.mem_ker]
  constructor
  · intro heq
    have hlower := congrFun heq 1
    have hre := congrArg Complex.re hlower
    rw [physicalOrbitTangent_one] at hre
    have hsqrt : Real.sqrt 2 ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
    have hh : h = 0 := by
      have hdiv : h / Real.sqrt 2 = 0 := by
        simpa [radialTangent] using hre
      exact ((div_eq_zero_iff).mp hdiv).resolve_right hsqrt
    refine ⟨hh, ?_⟩
    have hphys : physicalOrbitTangent v x = 0 := by
      rw [← heq, hh]
      simp [radialTangent]
    have hi : Complex.I • B_EW v x = 0 := by
      simpa [physicalOrbitTangent] using hphys
    rcases smul_eq_zero.mp hi with hI | hB
    · exact (Complex.I_ne_zero hI).elim
    · exact hB
  · rintro ⟨rfl, hx⟩
    simp [radialTangent, physicalOrbitTangent, hx]

/-! ## Gauge-invariant radial projection -/

/-- The leading FMS scalar observable extracts exactly `v` times the radial
coordinate in the standard doublet normalization. -/
theorem linearRadialObservable_eq_v_mul_radialCoordinate
    (v : Real) (z : Fin 2 -> Complex) :
    linearRadialObservable (H0 v) z = v * radialCoordinate z := by
  have hsqrt : Real.sqrt 2 ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
  have hsq : (Real.sqrt 2) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  unfold linearRadialObservable realHermitianBilinear radialCoordinate
  simp [H0, Fin.sum_univ_two, Complex.mul_re]
  field_simp
  rw [hsq]
  ring

/-- A physical gauge-orbit tangent is invisible to the leading gauge-invariant
radial observable. -/
theorem linearRadialObservable_physicalOrbitTangent
    (v : Real) (x : Fin 4 -> Real) :
    linearRadialObservable (H0 v) (physicalOrbitTangent v x) = 0 := by
  rw [linearRadialObservable_eq_v_mul_radialCoordinate]
  simp [radialCoordinate, physicalOrbitTangent_one]

lemma radialCoordinate_radialTangent (h : Real) :
    radialCoordinate (radialTangent h) = h := by
  have hsqrt : Real.sqrt 2 ≠ 0 := Real.sqrt_ne_zero'.mpr (by norm_num)
  simp [radialCoordinate, radialTangent]
  field_simp

/-- The leading gauge-invariant radial observable responds to a normalized
radial tangent with coefficient `v`. -/
theorem linearRadialObservable_radialTangent (v h : Real) :
    linearRadialObservable (H0 v) (radialTangent h) = v * h := by
  rw [linearRadialObservable_eq_v_mul_radialCoordinate]
  rw [radialCoordinate_radialTangent]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition.tangent_eq_radial_add_physicalOrbit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tangent_eq_radial_add_physicalOrbit

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition.radialTangent_eq_physicalOrbit_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms radialTangent_eq_physicalOrbit_iff

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition.linearRadialObservable_physicalOrbitTangent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearRadialObservable_physicalOrbitTangent

end PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition

end
