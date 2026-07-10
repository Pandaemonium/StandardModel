import PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
import PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary

/-!
# Positive-Hodge class value to Pluecker mass

This module composes the corrected class-invariant Hodge cost with the canonical
null-spinor mass dictionary. If the class eigenvalue `mu2` is identified with
the canonical scale `m^2`, every exact representative has the same spectral
cost and that cost equals the Pluecker invariant of `e0, m*e1`.

The equality `mu2 = m^2` remains a displayed bridge hypothesis; it is not
derived here. Two explicit `4/25` theorems distinguish the older degenerate
three-dimensional fixture from the nondegenerate four-dimensional quartet. The
latter is the relevant controlled bridge for physical interpretation.

Provenance: keystone composition target selected by Aristotle focused strategy
`823a61ad-00ed-4a32-97a3-4ad694aa5fa8`; clean-room proof by Codex from the
landed class-cost and canonical Pluecker declarations.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- **Conditional Hodge-Pluecker mass bridge.** Once the class eigenvalue is
identified with the canonical turn scale squared, the class-invariant cost of
every exact representative equals the canonical null-direction disagreement. -/
theorem class_cost_eq_canonical_plucker
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h : V) (hclosed : Q h = 0) (mu2 : ℝ)
    (heig : S h = mu2 • h) (hnorm : B h h = 1)
    (m : ℝ) (hmu : mu2 = m ^ 2) (chi : V) :
    ((B (h + Q chi) (S (h + Q chi)) : ℝ) : ℂ) =
      complexAbsSq (spinorWedge edge0 (edge1 m)) := by
  rw [class_cost_constant B Q S hrad hQQ hcomm h hclosed mu2 heig hnorm chi,
    hmu, canonical_plucker_mass]

/-- The landed nilpotent positive-Hodge fixture and canonical spinor pair at
`m=2/5` assign exactly the same nonzero mass-squared `4/25`, for every exact
representative. -/
theorem matched_four_twentyfive_witness :
    witnessQ ≠ 0 ∧
      spinorWedge edge0 (edge1 (2 / 5)) ≠ 0 ∧
      ∀ chi : Fin 3 → ℝ,
        ((witnessB ((![0, 0, 1] : Fin 3 → ℝ) + witnessQ chi)
            (witnessS ((![0, 0, 1] : Fin 3 → ℝ) + witnessQ chi)) : ℝ) : ℂ) =
          complexAbsSq (spinorWedge edge0 (edge1 (2 / 5))) := by
  have hw := nilpotent_positive_class_witness
  refine ⟨hw.1, ?_, ?_⟩
  · norm_num [edge0, edge1, spinorWedge]
  · intro chi
    have hcost := hw.2.2.2.2.2.2.2 chi
    rw [hcost, canonical_plucker_mass]
    norm_num

/-- The nondegenerate four-dimensional Hodge quartet and the canonical spinor
pair at `m=2/5` assign exactly the same nonzero class value `4/25` to every
exact representative. This closes the fixture-level wiring defect left by
`matched_four_twentyfive_witness`, which uses the older degenerate form. -/
theorem quartet_class_cost_eq_canonical_plucker (chi : Quartet) :
    ((quartetB (qe2 + quartetQ chi)
        (quartetS (qe2 + quartetQ chi)) : ℝ) : ℂ) =
      complexAbsSq (spinorWedge edge0 (edge1 (2 / 5))) := by
  rw [(nondegenerate_quartet_witness).2.2.2.2.2.2.2.2 chi,
    canonical_plucker_mass]
  norm_num

/-- **Parameterized nondegenerate Hodge-Pluecker bridge.** The decoder family
`quartetSAt m` derives the same `m^2` carried by the canonical spinor pair for
every real scale and every exact representative. Unlike
`class_cost_eq_canonical_plucker`, this theorem has no separate `mu2=m^2`
hypothesis; the equality is built into and proved for the explicit decoder
family. -/
theorem parameterized_quartet_class_cost_eq_canonical_plucker
    (m : ℝ) (chi : Quartet) :
    ((quartetB (qe2 + quartetQ chi)
        (quartetSAt m (qe2 + quartetQ chi)) : ℝ) : ℂ) =
      complexAbsSq (spinorWedge edge0 (edge1 m)) := by
  rw [quartetSAt_class_cost, canonical_plucker_mass]

/-- The parameterized bridge realizes two distinct nonzero mass scales in the
same nondegenerate Hodge architecture. -/
theorem parameterized_bridge_two_scale_control :
    (∀ chi : Quartet,
        ((quartetB (qe2 + quartetQ chi)
            (quartetSAt (2 / 5) (qe2 + quartetQ chi)) : ℝ) : ℂ) =
          complexAbsSq (spinorWedge edge0 (edge1 (2 / 5)))) ∧
      (∀ chi : Quartet,
        ((quartetB (qe2 + quartetQ chi)
            (quartetSAt (3 / 5) (qe2 + quartetQ chi)) : ℝ) : ℂ) =
          complexAbsSq (spinorWedge edge0 (edge1 (3 / 5)))) ∧
      complexAbsSq (spinorWedge edge0 (edge1 (2 / 5))) ≠
        complexAbsSq (spinorWedge edge0 (edge1 (3 / 5))) := by
  refine ⟨parameterized_quartet_class_cost_eq_canonical_plucker (2 / 5),
    parameterized_quartet_class_cost_eq_canonical_plucker (3 / 5), ?_⟩
  rw [canonical_plucker_mass, canonical_plucker_mass]
  norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge.class_cost_eq_canonical_plucker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms class_cost_eq_canonical_plucker

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge.matched_four_twentyfive_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms matched_four_twentyfive_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge.quartet_class_cost_eq_canonical_plucker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartet_class_cost_eq_canonical_plucker

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge.parameterized_quartet_class_cost_eq_canonical_plucker' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parameterized_quartet_class_cost_eq_canonical_plucker

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge.parameterized_bridge_two_scale_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parameterized_bridge_two_scale_control

end PhysicsSM.Draft.NullEdge.Carrier.HodgePluckerMassBridge
