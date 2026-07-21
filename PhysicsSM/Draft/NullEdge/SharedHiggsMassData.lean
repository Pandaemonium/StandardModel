import PhysicsSM.Draft.NullEdge.GaugeMassGram
import PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature
import PhysicsSM.Draft.NullEdge.HiggsDofConservation
import PhysicsSM.Draft.NullEdge.GateYM.YukawaTurnAmplitude
import PhysicsSM.Draft.NullEdge.SharedHiggsScalarSharingNoGo

/-!
# One supplied Higgs scale feeding three finite mass-response sectors

This module packages a convention-locked finite reconstruction theorem for the
three Standard Model mass-response sectors that share one Higgs scale:

* a Yukawa matrix scaled by `v / sqrt 2`;
* the gauge-orbit Gram matrix generated from the doublet vacuum `H0 v`;
* the radial curvature `2 * lambda * v^2` of the supplied scalar potential.

The sectors share the scalar `v`, but not all inputs. The Yukawa matrix, gauge
generators/couplings, quartic coupling, and vacuum scale remain explicit. The
independent zero controls prove that the three responses are not aliases of one
another. A single nonzero witness uses one and the same value `v = 1` in all
three sectors.

The stronger statement that the fermion response is canonically determined by
the Higgs *vector* is false under the repository types: a map from the Higgs
doublet space to the fermion operator space is additional data, and distinct
such bridges exist. `SharedHiggsScalarSharingNoGo` records that obstruction.
Accordingly, this module uses only the shared scalar `v` in the fermion sector;
the Yukawa matrix remains irreducibly free.

This is a finite reconstruction from supplied data. It does not derive the
vacuum, Yukawa texture, gauge couplings, Higgs potential, pole masses,
radiative corrections, or a continuum Standard Model. Claim grade: `M [comp]`.

Provenance: clean-room finite formalization of the shared-vacuum formulas in
Particle Data Group, "Status of Higgs Boson Physics" (2025), Sec. 11.2. The
potential and orbit API shapes were cross-checked against PhysLean declarations
`StandardModel.HiggsField.Potential` and
`StandardModel.HiggsField.EffectivePotential.IsInvariant.eq_on_orbits` at its
pinned external version; no external implementation text is copied.
-/

noncomputable section

open scoped ComplexOrder InnerProductSpace Matrix Kronecker

namespace PhysicsSM.Draft.NullEdge.SharedHiggsMassData

open PhysicsSM.Draft
open PhysicsSM.Draft.NullEdge.HiggsFMSRadialObservable
open PhysicsSM.Draft.NullEdge.HiggsTangentDecomposition
open PhysicsSM.Draft.NullEdge.HiggsDoubletRadialCurvature
open PhysicsSM.Draft.NullEdge.GaugeMassGram
open PhysicsSM.Draft.NullEdge.GateYM.YukawaTurnAmplitude

/-- Supplied finite data for three response sectors sharing one scalar vacuum
scale. The fermion Yukawa matrix is independent of the bosonic doublet data. -/
structure Data (nGauge nFlavor : Nat) where
  /-- Common electroweak vacuum scale. -/
  v : Real
  /-- Scalar quartic coupling. -/
  quartic : Real
  /-- Flavor-space Yukawa input. -/
  yukawa : Matrix (Fin nFlavor) (Fin nFlavor) Complex
  /-- Real gauge couplings in the chosen generator basis. -/
  gaugeCoupling : Fin nGauge -> Real
  /-- Gauge generators acting on the finite Higgs doublet. -/
  gaugeGenerator :
    Fin nGauge ->
      EuclideanSpace Complex (Fin 2) →ₗ[Complex] EuclideanSpace Complex (Fin 2)

namespace Data

variable {nGauge nFlavor : Nat}

/-- The convention-fixed doublet vacuum used by the bosonic sectors. -/
def vacuum (d : Data nGauge nFlavor) : Fin 2 -> Complex := H0 d.v

/-- The shared vacuum in the Euclidean-space wrapper required by the positive
Gram-matrix API. Its coordinates are definitionally those of `vacuum`. -/
def gaugeVacuum (d : Data nGauge nFlavor) : EuclideanSpace Complex (Fin 2) :=
  WithLp.toLp 2 d.vacuum

/-- The scalar-shared Yukawa matrix. The common input is `v / sqrt 2`; choosing
a map from the full doublet vector to this flavor operator would require an
additional cross-space bridge not selected by the present data. -/
def fermionMassMatrix (d : Data nGauge nFlavor) :
    Matrix (Fin nFlavor) (Fin nFlavor) Complex :=
  ((d.v : Complex) / Real.sqrt 2) • d.yukawa

/-- Chirality-changing finite fermion response. -/
def fermionTurn (d : Data nGauge nFlavor) (mu : Fin 4) :
    Matrix (Fin nFlavor × Fin 4) (Fin nFlavor × Fin 4) Complex :=
  turnAmplitude d.fermionMassMatrix mu

/-- Gauge-orbit stiffness generated from the same vacuum vector. -/
def gaugeMass (d : Data nGauge nFlavor) :
    Matrix (Fin nGauge) (Fin nGauge) Complex :=
  gaugeMassMatrix d.gaugeCoupling d.gaugeGenerator d.gaugeVacuum

/-- Radial curvature in the standard doublet normalization. -/
def radialMassSq (d : Data nGauge nFlavor) : Real :=
  radialMassSquared d.quartic d.v

/-- Replace only the common vacuum scale, leaving every independent coupling
visible and unchanged. -/
def withVacuum (d : Data nGauge nFlavor) (v : Real) : Data nGauge nFlavor :=
  { d with v := v }

@[simp] theorem gaugeVacuum_zero (d : Data nGauge nFlavor) :
    (d.withVacuum 0).gaugeVacuum = 0 := by
  ext i
  fin_cases i <;> simp [gaugeVacuum, vacuum, withVacuum, H0]

/-- The lower component of the shared vacuum is the standard `v / sqrt 2`. -/
theorem vacuum_lower (d : Data nGauge nFlavor) :
    d.vacuum 1 = (d.v : Complex) / Real.sqrt 2 := by
  simp [vacuum, H0]

/-- The scalar-shared fermion coefficient agrees numerically with evaluating
the convention-fixed lower component. This equality does not select a general
Higgs-vector-to-fermion bridge. -/
theorem fermionMassMatrix_eq_vacuum_lower (d : Data nGauge nFlavor) :
    d.fermionMassMatrix = d.vacuum 1 • d.yukawa := by
  rw [vacuum_lower]
  rfl

/-- The shared vacuum vector vanishes exactly when its supplied scale does. -/
theorem vacuum_eq_zero_iff (d : Data nGauge nFlavor) :
    d.vacuum = 0 ↔ d.v = 0 := by
  constructor
  · intro h
    have h1 := congrFun h 1
    have hsqrt : (Real.sqrt 2 : Complex) ≠ 0 := by
      exact_mod_cast Real.sqrt_ne_zero'.mpr (by norm_num : (0 : Real) < 2)
    simpa [vacuum, H0, hsqrt] using h1
  · intro hv
    funext i
    fin_cases i <;> simp [vacuum, H0, hv]

/-- The chirality-changing response is exactly the mass term built from the
vacuum-evaluated Yukawa matrix. -/
theorem fermionTurn_eq (d : Data nGauge nFlavor) (mu : Fin 4) :
    d.fermionTurn mu = flavorMassTerm d.fermionMassMatrix := by
  exact turnAmplitude_eq d.fermionMassMatrix mu

/-- At a nonzero common vacuum, the fermion response vanishes exactly when the
independent Yukawa input vanishes. -/
theorem fermionTurn_eq_zero_iff
    (d : Data nGauge nFlavor) (hv : d.v ≠ 0) (mu : Fin 4) :
    d.fermionTurn mu = 0 ↔ d.yukawa = 0 := by
  rw [fermionTurn_eq, flavorMassTerm_eq_zero_iff]
  have hScale : (d.v : Complex) / Real.sqrt 2 ≠ 0 :=
    div_ne_zero (by exact_mod_cast hv)
      (by exact_mod_cast Real.sqrt_ne_zero'.mpr (by norm_num : (0 : Real) < 2))
  simp [fermionMassMatrix, hScale]

/-- Gauge-orbit stiffness is positive semidefinite for the common vacuum. -/
theorem gaugeMass_posSemidef (d : Data nGauge nFlavor) :
    d.gaugeMass.PosSemidef := by
  exact gaugeMassMatrix_posSemidef
    d.gaugeCoupling d.gaugeGenerator d.gaugeVacuum

/-- A nonzero-coupling gauge direction is massless exactly when it stabilizes
the common vacuum. -/
theorem gaugeMass_diag_zero_iff_stabilizer
    (d : Data nGauge nFlavor) (a : Fin nGauge)
    (hg : d.gaugeCoupling a ≠ 0) :
    d.gaugeMass a a = 0 ↔ d.gaugeGenerator a d.gaugeVacuum = 0 := by
  exact diagonal_zero_iff_stabilizer
    d.gaugeCoupling d.gaugeGenerator d.gaugeVacuum a hg

/-- Positive scalar coupling and a nonzero common vacuum give positive radial
curvature. -/
theorem radialMassSq_pos
    (d : Data nGauge nFlavor) (hQuartic : 0 < d.quartic) (hv : d.v ≠ 0) :
    0 < d.radialMassSq := by
  exact radialMassSquared_pos hQuartic hv

/-- The norm of the common vacuum is `v^2 / 2`. -/
theorem vacuum_norm_sq (d : Data nGauge nFlavor) :
    vectorNormSq d.vacuum = d.v ^ 2 / 2 := by
  have h := vectorNormSq_radialDoubletField d.v 0
  rw [radialDoubletField_zero] at h
  simpa [vacuum] using h

/-- The radial response can be written directly from the norm of the bosonic
vacuum vector. The fermion sector shares its scalar scale, not a canonical map
from this vector. -/
theorem radialMassSq_eq_vacuum_norm (d : Data nGauge nFlavor) :
    d.radialMassSq = 4 * d.quartic * vectorNormSq d.vacuum := by
  rw [vacuum_norm_sq]
  simp [radialMassSq, radialMassSquared]
  ring

/-- If the common scalar vacuum scale is set to zero, all three induced
response sectors close simultaneously. -/
theorem zero_vacuum_closes_all
    (d : Data nGauge nFlavor) (mu : Fin 4) :
    (d.withVacuum 0).fermionTurn mu = 0 ∧
      (d.withVacuum 0).gaugeMass = 0 ∧
      (d.withVacuum 0).radialMassSq = 0 := by
  constructor
  · rw [fermionTurn_eq, flavorMassTerm_eq_zero_iff]
    simp [fermionMassMatrix, withVacuum]
  constructor
  · ext a b
    simp [gaugeMass, gaugeMassMatrix, orbitTangent, Matrix.gram_apply]
  · simp [radialMassSq, radialMassSquared, withVacuum]

/-! ## One shared nonzero witness -/

/-- One-flavor identity Yukawa input. -/
def witnessYukawa : Matrix (Fin 1) (Fin 1) Complex := 1

/-- One nontrivial gauge direction acting by the identity on the doublet. -/
def witnessGaugeGenerator :
    Fin 1 ->
      EuclideanSpace Complex (Fin 2) →ₗ[Complex] EuclideanSpace Complex (Fin 2) :=
  fun _ => LinearMap.id

/-- Unit coupling for the one-direction gauge witness. -/
def witnessGaugeCoupling : Fin 1 -> Real := fun _ => 1

/-- The same nonzero scalar scale `v = 1` feeds all three witness sectors. -/
def witness : Data 1 1 where
  v := 1
  quartic := 1
  yukawa := witnessYukawa
  gaugeCoupling := witnessGaugeCoupling
  gaugeGenerator := witnessGaugeGenerator

theorem witness_yukawa_ne_zero : witnessYukawa ≠ 0 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [witnessYukawa] at h00

/-- The scalar-shared witness is nondegenerate in every response sector. -/
theorem shared_higgs_nonzero_witness :
    witness.vacuum ≠ 0 ∧
      witness.fermionTurn 0 ≠ 0 ∧
      witness.gaugeMass 0 0 ≠ 0 ∧
      0 < witness.radialMassSq := by
  have hv : witness.v ≠ 0 := by norm_num [witness]
  have hVacuum : witness.vacuum ≠ 0 :=
    (vacuum_eq_zero_iff witness).not.mpr hv
  refine ⟨hVacuum, ?_, ?_, radialMassSq_pos witness (by norm_num [witness]) hv⟩
  · intro hTurn
    exact witness_yukawa_ne_zero
      ((fermionTurn_eq_zero_iff witness hv 0).mp hTurn)
  · intro hGauge
    have hStabilizer :=
      (gaugeMass_diag_zero_iff_stabilizer witness 0
        (by norm_num [witness, witnessGaugeCoupling])).mp hGauge
    have hGaugeVacuum : witness.gaugeVacuum = 0 := by
      simpa [witness, witnessGaugeGenerator] using hStabilizer
    exact hVacuum (by
      apply funext
      intro i
      have hi := congrArg (fun x : EuclideanSpace Complex (Fin 2) => x.ofLp i)
        hGaugeVacuum
      simpa [gaugeVacuum] using hi)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SharedHiggsMassData.Data.zero_vacuum_closes_all' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_vacuum_closes_all

/-- info: 'PhysicsSM.Draft.NullEdge.SharedHiggsMassData.Data.shared_higgs_nonzero_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms shared_higgs_nonzero_witness

end Data

end PhysicsSM.Draft.NullEdge.SharedHiggsMassData

end
