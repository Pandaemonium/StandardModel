import PhysicsSM.Draft.NullEdge.ChangingLatticePDECore

/-!
# Ultraviolet-tail convergence on expanding bands

Focused dominated-convergence target for the changing-lattice PDE bridge.
-/

noncomputable section

namespace ChangingLatticeUVTail

open MeasureTheory Filter Topology Set

/-- The `L2` mass outside measurable increasing bands tends to zero when the
bands exhaust the whole frequency space. -/
theorem uv_tail_tendsto_zero {X E : Type*} [MeasurableSpace X]
    [NormedAddCommGroup E] {mu : Measure X}
    (exact : X -> E) (hex : MemLp exact 2 mu)
    (B : Nat -> Set X) (hBmeas : ∀ n, MeasurableSet (B n))
    (hmono : Monotone B) (hcover : ⋃ n, B n = Set.univ) :
    Tendsto (fun n => eLpNorm ((B n)ᶜ.indicator exact) 2 mu)
      atTop (nhds 0) := by
  sorry

end ChangingLatticeUVTail
