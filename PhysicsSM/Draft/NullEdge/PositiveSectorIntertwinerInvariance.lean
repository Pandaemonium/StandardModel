import Mathlib

/-!
# Positive-sector invariance under pairing-preserving intertwiners

A linear equivalence preserving a real pairing transports its positive cone and
therefore preserves nonemptiness of that cone. A nontrivial rational Lorentz
boost gives an exact finite witness with positive and negative controls.

This is presentation invariance only. It does not select a preferred physical
sector among inequivalent pairings, derive the intertwiner from carrier
dynamics, or supply a Born/probability rule.

Provenance: focused target selected by Aristotle grand strategy
`223b4858-a66c-4516-a15d-9cbdc354b70d`; proof completed by Aristotle project
`203562ea-6e60-4248-b8ef-330eb533bad6` and clean-room ported on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.PositiveSectorIntertwinerInvariance

variable {V W : Type*} [AddCommGroup V] [Module ℝ V]
  [AddCommGroup W] [Module ℝ W]

/-- The strictly positive cone of a supplied real pairing. -/
def Sector (B : V -> V -> ℝ) := {x : V // 0 < B x x}

/-- A pairing-preserving linear equivalence induces an equivalence of positive
cones. -/
noncomputable def sectorEquiv (B : V -> V -> ℝ) (B' : W -> W -> ℝ)
    (phi : V ≃ₗ[ℝ] W) (hpres : ∀ x y, B' (phi x) (phi y) = B x y) :
    Sector B ≃ Sector B' where
  toFun x := ⟨phi x.1, by rw [hpres]; exact x.2⟩
  invFun y := ⟨phi.symm y.1, by
    have h := hpres (phi.symm y.1) (phi.symm y.1)
    rw [phi.apply_symm_apply] at h
    rw [← h]
    exact y.2⟩
  left_inv x := Subtype.ext (by simp)
  right_inv y := Subtype.ext (by simp)

theorem positive_sector_nonempty_invariant
    (B : V -> V -> ℝ) (B' : W -> W -> ℝ)
    (phi : V ≃ₗ[ℝ] W) (hpres : ∀ x y, B' (phi x) (phi y) = B x y)
    (hpos : Nonempty (Sector B)) :
    Nonempty (Sector B') := by
  exact ⟨⟨phi hpos.some.1, by simpa [hpres] using hpos.some.2⟩⟩

abbrev V2 := Fin 2 -> ℝ

def minkowskiB (x y : V2) : ℝ := x 0 * y 0 - x 1 * y 1

/-- A nontrivial rational Lorentz boost with coefficients `5/4,3/4`. -/
noncomputable def boost : V2 ≃ₗ[ℝ] V2 := by
  let f : V2 →ₗ[ℝ] V2 :=
    Matrix.toLin' !![(5 / 4 : ℝ), 3 / 4; 3 / 4, 5 / 4]
  refine LinearEquiv.ofBijective f ?_
  convert (LinearEquiv.bijective (LinearMap.equivOfDetNeZero f ?_));
    norm_num at *
  erw [LinearMap.det_toLin']
  norm_num [Matrix.det_fin_two]

def timeUnit : V2 := ![1, 0]
def spaceUnit : V2 := ![0, 1]

theorem boost_apply (z : V2) :
    boost z = ![5 / 4 * z 0 + 3 / 4 * z 1,
      3 / 4 * z 0 + 5 / 4 * z 1] := by
  funext i
  fin_cases i <;>
    simp [boost, Matrix.mulVec, Matrix.toLin'_apply,
      Matrix.vecHead, Matrix.vecTail]

theorem boost_preserves_pairing (x y : V2) :
    minkowskiB (boost x) (boost y) = minkowskiB x y := by
  simp only [minkowskiB, boost_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-- The boost moves a positive vector while preserving its norm, and the
negative direction remains negative. -/
theorem rational_boost_sector_controls :
    boost timeUnit ≠ timeUnit ∧
      minkowskiB (boost timeUnit) (boost timeUnit) = 1 ∧
      minkowskiB (boost spaceUnit) (boost spaceUnit) = -1 ∧
      Nonempty (Sector minkowskiB) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h
    have h0 := congrFun h 0
    rw [boost_apply] at h0
    norm_num [timeUnit] at h0
  · rw [boost_preserves_pairing]
    simp [minkowskiB, timeUnit]
  · rw [boost_preserves_pairing]
    norm_num [minkowskiB, spaceUnit]
  · exact ⟨⟨timeUnit, by norm_num [minkowskiB, timeUnit]⟩⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorIntertwinerInvariance.sectorEquiv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sectorEquiv

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorIntertwinerInvariance.positive_sector_nonempty_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_sector_nonempty_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.PositiveSectorIntertwinerInvariance.rational_boost_sector_controls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_boost_sector_controls

end PhysicsSM.Draft.NullEdge.PositiveSectorIntertwinerInvariance
