import PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

/-!
# Family-internal gapped homotopy for massive HNU updates

This module joins any two positive nontrivial Pluecker mass angles by their
linear interpolation. Every update on the path is the exact massive HNU
family already defined in `HNUPlueckerMassiveStay`; throughout the closed
Brillouin cube it remains unitary and avoids both Floquet eigenvalues `+1` and
`-1`.

The result is deliberately family-internal. It does not classify arbitrary
Floquet QCAs or identify a global Floquet topological invariant.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
open PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy

/-- Linear interpolation between two Pluecker mass angles. -/
def massAnglePath (a0 a1 t : Real) : Real :=
  (1 - t) * a0 + t * a1

/-- The exact massive HNU family along the linear angle path. -/
def massiveHNUAngleHomotopy (a0 a1 t : Real) (k : Fin 3 -> Real) :
    Matrix (Fin 4) (Fin 4) Complex :=
  massiveHNU 1 (massAnglePath a0 a1 t) k

/-- Convex interpolation preserves the open nontrivial mass-angle interval. -/
theorem massAnglePath_mem_openInterval (a0 a1 t : Real)
    (ha0 : 0 < a0) (ha0pi : a0 < Real.pi)
    (ha1 : 0 < a1) (ha1pi : a1 < Real.pi)
    (ht : t ∈ Set.Icc (0 : Real) 1) :
    0 < massAnglePath a0 a1 t ∧ massAnglePath a0 a1 t < Real.pi := by
  constructor <;> unfold massAnglePath <;>
    cases eq_or_lt_of_le ht.1 <;> cases eq_or_lt_of_le ht.2 <;> nlinarith

/-- For fixed momentum, the exact HNU interpolation is continuous in its
homotopy parameter. -/
theorem continuous_massiveHNUAngleHomotopy (a0 a1 : Real)
    (k : Fin 3 -> Real) :
    Continuous (fun t : Real => massiveHNUAngleHomotopy a0 a1 t k) := by
  refine' Continuous.matrix_mul _ _
  · unfold Pluecker3Plus1ComplexMass.massCoin4
    norm_num [massAnglePath]
    continuity
  · exact continuous_const

/-- Every point of the angle interpolation is an exact unitary update with
both the zero and pi quasienergy gaps open on the closed Brillouin cube. -/
theorem massiveHNUAngleHomotopy_unitary_zero_pi_gapped
    (a0 a1 : Real) (ha0 : 0 < a0) (ha0pi : a0 < Real.pi)
    (ha1 : 0 < a1) (ha1pi : a1 < Real.pi)
    (t : Real) (ht : t ∈ Set.Icc (0 : Real) 1)
    (k : Fin 3 -> Real) (hk : InBZ k) :
    massiveHNUAngleHomotopy a0 a1 t k ∈
        Matrix.unitaryGroup (Fin 4) Complex ∧
      (massiveHNUAngleHomotopy a0 a1 t k - 1).det != 0 ∧
      (massiveHNUAngleHomotopy a0 a1 t k + 1).det != 0 := by
  obtain ⟨a, ha⟩ :
      ∃ a : Real, 0 < a ∧ a < Real.pi ∧ massAnglePath a0 a1 t = a := by
    exact ⟨_,
      (massAnglePath_mem_openInterval a0 a1 t ha0 ha0pi ha1 ha1pi ht).1,
      (massAnglePath_mem_openInterval a0 a1 t ha0 ha0pi ha1 ha1pi ht).2,
      rfl⟩
  unfold massiveHNUAngleHomotopy
  rw [ha.2.2]
  exact ⟨massiveHNU_unitary 1 (by norm_num) a k,
    by simpa using massiveHNU_zero_pi_gap a ha.1 ha.2.1 k hk⟩

/-- All positive nontrivial Pluecker mass angles lie in one zero/pi-gapped
homotopy class inside the exact massive HNU family. This is not a
classification theorem for general Floquet QCAs. -/
theorem positive_nontrivial_mass_angles_same_internal_gapped_homotopy
    (a0 a1 : Real) (ha0 : 0 < a0) (ha0pi : a0 < Real.pi)
    (ha1 : 0 < a1) (ha1pi : a1 < Real.pi) :
    (∀ t ∈ Set.Icc (0 : Real) 1,
      0 < massAnglePath a0 a1 t ∧ massAnglePath a0 a1 t < Real.pi) ∧
    Continuous (fun t : Real => massiveHNUAngleHomotopy a0 a1 t) ∧
    massiveHNUAngleHomotopy a0 a1 0 = massiveHNU 1 a0 ∧
    massiveHNUAngleHomotopy a0 a1 1 = massiveHNU 1 a1 ∧
    (∀ t ∈ Set.Icc (0 : Real) 1, ∀ k, InBZ k ->
      massiveHNUAngleHomotopy a0 a1 t k ∈
          Matrix.unitaryGroup (Fin 4) Complex ∧
        (massiveHNUAngleHomotopy a0 a1 t k - 1).det != 0 ∧
        (massiveHNUAngleHomotopy a0 a1 t k + 1).det != 0) := by
  refine' ⟨_, _, _, _, _⟩
  · exact fun t ht =>
      massAnglePath_mem_openInterval a0 a1 t ha0 ha0pi ha1 ha1pi ht
  · exact continuous_pi_iff.mpr fun k =>
      continuous_massiveHNUAngleHomotopy a0 a1 k
  · unfold massiveHNUAngleHomotopy massAnglePath
    aesop
  · unfold massiveHNUAngleHomotopy massAnglePath
    norm_num
  · exact fun t ht k hk => by
      simpa using massiveHNUAngleHomotopy_unitary_zero_pi_gapped
        a0 a1 ha0 ha0pi ha1 ha1pi t ht k hk

/-- Exact nonvacuity witness: the midpoint is in the parameter interval and
its origin update is the corresponding exact Pluecker mass coin, with both
shifted determinants nonzero. -/
theorem midpoint_origin_nonvacuity
    (a0 a1 : Real) (ha0 : 0 < a0) (ha0pi : a0 < Real.pi)
    (ha1 : 0 < a1) (ha1pi : a1 < Real.pi) :
    (1 / 2 : Real) ∈ Set.Icc (0 : Real) 1 ∧
    massiveHNUAngleHomotopy a0 a1 (1 / 2) 0 =
      PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4 1
        (massAnglePath a0 a1 (1 / 2)) ∧
    (massiveHNUAngleHomotopy a0 a1 (1 / 2) 0 - 1).det != 0 ∧
    (massiveHNUAngleHomotopy a0 a1 (1 / 2) 0 + 1).det != 0 := by
  unfold massiveHNUAngleHomotopy
  grind +suggestions

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massAnglePath_mem_openInterval' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massAnglePath_mem_openInterval

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.continuous_massiveHNUAngleHomotopy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms continuous_massiveHNUAngleHomotopy

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.massiveHNUAngleHomotopy_unitary_zero_pi_gapped' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNUAngleHomotopy_unitary_zero_pi_gapped

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.positive_nontrivial_mass_angles_same_internal_gapped_homotopy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_nontrivial_mass_angles_same_internal_gapped_homotopy

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy.midpoint_origin_nonvacuity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms midpoint_origin_nonvacuity

end PhysicsSM.Draft.NullEdge.HNUMassiveGapHomotopy
