import PhysicsSM.Draft.Spin10VacuumChartReconstruction

/-!
# Denormalization of the Spin(10) vacuum chart

A nonzero vacuum coordinate can be normalized, reconstructed by the finite
creation-root chart, and restored by an algebraic scalar unit.

Provenance: Aristotle project `1d659a0a-5b2f-4c60-9b3f-2622a76e96d3` under
the project Fock, Chevalley-pairing, and algebraic `GSpin(10, C)` conventions.
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StandardizablePairs

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.Spin10StabilizerTransitivity

/-- A nonzero vacuum coordinate can be normalized, reconstructed by creation
roots, and restored by an algebraic scalar unit. -/
theorem exists_evenCliffordGroup_vacuum_eq_of_nonzero_quadric_chart
    (ψ : FockSpinor) (heven : IsEvenSpinor ψ)
    (hquad : gammaBilinear ψ ψ = 0) (h0 : ψ ∅ ≠ 0) :
    ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = ψ := by
  -- Let c = ψ ∅ and normalize φ = c⁻¹ • ψ.
  set c := ψ ∅
  set φ := c⁻¹ • ψ with hφ_def;
  obtain ⟨g, hg⟩ : ∃ g : evenCliffordGroup, g.val.val vacuumSpinor = φ := by
    apply exists_creationRoots_vacuum_eq_of_quadric_chart φ (heven.smul _) (by
    rw [ show gammaBilinear φ φ = c⁻¹ • c⁻¹ • gammaBilinear ψ ψ from ?_ ] ; aesop;
    rw [ ← gammaBilinear_smul_left, ← gammaBilinear_smul_right ]) (by
    aesop);
  refine' ⟨ ⟨ scalarUnit c h0 * g, _ ⟩, _ ⟩ <;> simp_all +decide [ Units.val_mul ];
  exact Subgroup.mul_mem _ ( scalarUnit_mem _ _ ) g.2

/-- info: 'PhysicsSM.Draft.Spin10StandardizablePairs.exists_evenCliffordGroup_vacuum_eq_of_nonzero_quadric_chart' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_evenCliffordGroup_vacuum_eq_of_nonzero_quadric_chart

end PhysicsSM.Draft.Spin10StandardizablePairs
