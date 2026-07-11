import PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient
import PhysicsSM.Draft.NullEdge.Carrier.WardPhysicalCohomology

/-!
# Physical quotient factorization for the finite Ward automorphisms

The two existing Ward modules describe the same three-dimensional constraint
model from complementary directions: one classifies Krein-form-preserving
charge automorphisms, while the other identifies zero physical action with
constraint homotopy. This module composes them.

For Ward automorphisms `U` and `V`, equality of their induced actions on the
surviving physical line is equivalent to the exact relation
`U - V = Q H + H Q`. Thus the physical-line action is a complete invariant of
the finite Ward quotient.

Scope: this is the concrete finite Ward witness. It does not construct the
constraint, contraction, locality, gauge action, or automorphism group of the
full decorated null-edge carrier.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- The charge matrices used by the automorphism and cohomology modules agree
entrywise. -/
theorem charge_agrees : WardAutomorphismQuotient.Q = KugoOjima.Qmat := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [WardAutomorphismQuotient.Q, KugoOjima.Qmat]

/-- The physical inclusions used by the two Ward modules agree entrywise. -/
theorem physical_inclusion_agrees :
    WardAutomorphismQuotient.physI = WardPhysicalCohomology.wardPhysI := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [WardAutomorphismQuotient.physI, WardPhysicalCohomology.wardPhysI]

/-- The physical projections used by the two Ward modules agree entrywise. -/
theorem physical_projection_agrees :
    WardAutomorphismQuotient.physP = WardPhysicalCohomology.wardPhysP := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [WardAutomorphismQuotient.physP, WardPhysicalCohomology.wardPhysP]

/-- Constraint-homotopy equivalence on the concrete Ward endomorphisms. -/
def WardExactEquivalent (U V : Mat3) : Prop :=
  Exists fun H : Mat3 =>
    U - V = WardAutomorphismQuotient.Q * H + H * WardAutomorphismQuotient.Q

/-- Equality of physical-line actions is exactly constraint-homotopy
equivalence for all charge-commuting chain maps. Krein preservation and
invertibility are not needed for this quotient calculation. -/
theorem exactEquivalent_iff_same_physical_action_of_chain
    (U V : Mat3)
    (hU : U * WardAutomorphismQuotient.Q = WardAutomorphismQuotient.Q * U)
    (hV : V * WardAutomorphismQuotient.Q = WardAutomorphismQuotient.Q * V) :
    WardExactEquivalent U V <->
      WardAutomorphismQuotient.physP * U * WardAutomorphismQuotient.physI =
        WardAutomorphismQuotient.physP * V * WardAutomorphismQuotient.physI := by
  have hchain : (U - V) * KugoOjima.Qmat = KugoOjima.Qmat * (U - V) := by
    rw [← charge_agrees]
    simp only [sub_mul, mul_sub]
    rw [hU, hV]
  have hzero := WardPhysicalCohomology.ward_zero_physical_iff_nullHomotopic
    (U - V) hchain
  rw [← physical_projection_agrees, ← physical_inclusion_agrees,
    ← charge_agrees] at hzero
  have hdistrib :
      WardAutomorphismQuotient.physP * (U - V) *
          WardAutomorphismQuotient.physI =
        WardAutomorphismQuotient.physP * U * WardAutomorphismQuotient.physI -
          WardAutomorphismQuotient.physP * V *
            WardAutomorphismQuotient.physI := by
    simp only [Matrix.mul_sub, Matrix.sub_mul]
  constructor
  · intro hexact
    have hz : WardAutomorphismQuotient.physP * (U - V) *
        WardAutomorphismQuotient.physI = 0 := hzero.2 hexact
    rw [hdistrib] at hz
    exact sub_eq_zero.mp hz
  · intro hphys
    apply hzero.1
    rw [hdistrib]
    exact sub_eq_zero.mpr hphys

/-- Equality of physical-line actions is exactly constraint-homotopy
equivalence for finite Ward automorphisms. This is the physically decorated
subclass of the chain-map theorem above. -/
theorem exactEquivalent_iff_same_physical_action
    (U V : Mat3) (hU : WardAutomorphismQuotient.IsWardAutomorphism U)
    (hV : WardAutomorphismQuotient.IsWardAutomorphism V) :
    WardExactEquivalent U V <->
      WardAutomorphismQuotient.physP * U * WardAutomorphismQuotient.physI =
        WardAutomorphismQuotient.physP * V * WardAutomorphismQuotient.physI :=
  exactEquivalent_iff_same_physical_action_of_chain U V hU.1 hV.1

/-- The zero map is a charge-commuting chain map. -/
theorem zero_chain_map :
    (0 : Mat3) * WardAutomorphismQuotient.Q =
      WardAutomorphismQuotient.Q * (0 : Mat3) := by
  simp

/-- The chain-map theorem is genuinely more general: the zero chain map is
not a Ward automorphism because it does not preserve the nonzero Krein form. -/
theorem zero_chain_map_not_ward_automorphism :
    Not (WardAutomorphismQuotient.IsWardAutomorphism (0 : Mat3)) := by
  intro h
  have h22 := congrFun (congrFun h.2 (2 : Fin 3)) (2 : Fin 3)
  have hzero_one : (0 : Complex) = 1 := by
    simpa +decide [WardAutomorphismQuotient.G] using h22
  exact zero_ne_one hzero_one

/-- The existing imaginary shear witnesses a nonidentity automorphism in the
exact class of the identity. -/
theorem nontrivial_exact_class_witness :
    let U := WardAutomorphismQuotient.wardFamily 1 Complex.I 0 0 1
    WardAutomorphismQuotient.IsWardAutomorphism U /\ U ≠ 1 /\
      WardExactEquivalent U 1 := by
  rcases WardAutomorphismQuotient.nontrivial_exact_shear_witness with
    ⟨hAuto, hne, _, hExact⟩
  exact ⟨hAuto, hne, hExact⟩

/-- The existing physical phase is the negative control: it is a Ward
automorphism outside the exact class of the identity. -/
theorem physical_phase_distinct_class_control :
    let U := WardAutomorphismQuotient.wardFamily 1 0 0 0 Complex.I
    WardAutomorphismQuotient.IsWardAutomorphism U /\
      Not (WardExactEquivalent U 1) := by
  rcases WardAutomorphismQuotient.physical_phase_not_exact_control with
    ⟨hAuto, _, hNotExact⟩
  refine ⟨hAuto, ?_⟩
  rintro ⟨H, hH⟩
  exact hNotExact ⟨H, hH⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.exactEquivalent_iff_same_physical_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactEquivalent_iff_same_physical_action

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.exactEquivalent_iff_same_physical_action_of_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactEquivalent_iff_same_physical_action_of_chain

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.zero_chain_map_not_ward_automorphism' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_chain_map_not_ward_automorphism

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.nontrivial_exact_class_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_exact_class_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization.physical_phase_distinct_class_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_phase_distinct_class_control

end PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization
