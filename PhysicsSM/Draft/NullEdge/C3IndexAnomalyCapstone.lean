import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.IncidenceCorank
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone

/-!
# Suite C3 — finite index/anomaly capstone bridge

This file composes the landed Goal II Kobayashi–Maskawa phase-count module
(`FiniteKMCP`), the general-`N` signed-incidence/corank theorem
(`IncidenceCorank`), and the finite winding-index / protected-low-mode theorem
(`WindingLowModes`) into a single theorem packet.

The payload is a **finite linear-algebra bridge**, not a continuum anomaly
theorem, spectral density statement, or full Standard Model derivation:

* Goal II has no physical CP phase at `N = 2`, exactly one at `N = 3`, and the
  explicit `3-4-5` witness `FiniteKM.Vwitness` is unitary with nonzero Jarlskog
  invariant.
* The general incidence/corank theorem identifies the arithmetic phase count
  `FiniteKM.physicalPhases N` with the signed-incidence corank
  `dim(edges) − rank(coboundary)` over any field.
* The finite winding operator `F4Winding.windingDirac N w` has analytic index
  `w`, kernel dimension `w`, vanishing cokernel, and a refinement-stable
  protected low-mode count.
* At the explicit C3 witness `N = 3`, `w = 1`, the KM phase count and the
  winding protected count both equal one; at the control `N = 2`, `w = 0`, both
  protections vanish.
-/

namespace C3IndexAnomalyCapstone

open scoped F4Winding

/-- **Low-`N` KM / winding bridge.**  Packages the explicit C3 witness data:
Goal II phase counts at `N = 2, 3`, unitarity and nonzero Jarlskog of the
`3-4-5` witness, and the winding operator's index/kernel/cokernel at
`N = 3, w = 1`, together with the vanishing kernel of the `N = 2` control. -/
theorem km_winding_lowN_bridge :
    FiniteKM.physicalPhases 2 = 0
      ∧ FiniteKM.physicalPhases 3 = 1
      ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
      ∧ FiniteKM.jarlskog FiniteKM.Vwitness = 6912 / 78125
      ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0
      ∧ ((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
          - Module.finrank ℂ
              ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
          = (1 : ℤ))
      ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1
      ∧ Module.finrank ℂ
          ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1)) = 0
      ∧ Module.finrank ℂ
          (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0 := by
  refine ⟨FiniteKM.physicalPhases_two, FiniteKM.physicalPhases_three,
    FiniteKM.Vwitness_unitary, FiniteKM.jarlskog_Vwitness,
    FiniteKM.jarlskog_Vwitness_ne_zero, ?_,
    F4Winding.windingDirac_kernel 3 1, F4Winding.windingDirac_coker 3 1, ?_⟩
  · simpa using F4Winding.windingDirac_index 3 1
  · simp [LinearMap.ker_id]

/-- **General incidence/index packet.**  Over any field `K`, the arithmetic CP
phase count equals the signed-incidence corank, and for the finite winding
operator the kernel dimension, analytic index, and refinement stability all hold
for arbitrary `N ≥ 1` and winding `w`. -/
theorem general_incidence_index_packet
    (K : Type*) [Field K] (N : ℕ) (hN : 1 ≤ N) (w : ℕ) :
    FiniteKM.physicalPhases N =
        Module.finrank K (IncidenceCorank.Edge N → K)
          - Module.finrank K
              (LinearMap.range (IncidenceCorank.coboundary K N))
      ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) = w
      ∧ ((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) : ℤ)
          - Module.finrank ℂ
              ((Fin N → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac N w))
          = (w : ℤ))
      ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w))
          = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * N) w)) := by
  refine ⟨?_, F4Winding.windingDirac_kernel N w,
    F4Winding.windingDirac_index N w, F4Winding.winding_count_refinement_stable N w⟩
  rw [IncidenceCorank.coboundary_corank K N hN]
  rfl

/-- **C3 nondegenerate witness.**  At `N = 3`, `w = 1` the KM phase count is one
with nonzero Jarlskog, the winding operator has index one and a one-dimensional
kernel, the phase count jumps by exactly one from the `N = 2` control, and the
protected count is refinement stable. -/
theorem c3_nondegenerate_witness :
    (FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
      ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
          - Module.finrank ℂ
              ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
          = (1 : ℤ))
          ∧ Module.finrank ℂ
              (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
      ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ)
          = (1 : ℤ))
      ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
          = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1)) := by
  refine ⟨⟨FiniteKM.physicalPhases_three, FiniteKM.jarlskog_Vwitness_ne_zero⟩,
    ⟨?_, F4Winding.windingDirac_kernel 3 1⟩, ?_,
    F4Winding.winding_count_refinement_stable 3 1⟩
  · simpa using F4Winding.windingDirac_index 3 1
  · rw [FiniteKM.physicalPhases_two, FiniteKM.physicalPhases_three]; norm_num

/-- **C3 zero control.**  At `N = 2`, `w = 0` every protection vanishes: no
physical CP phase, zero incidence corank, trivial identity kernel, and zero
winding kernel. -/
theorem c3_control_zero :
    FiniteKM.physicalPhases 2 = 0
      ∧ Module.finrank ℂ (IncidenceCorank.Edge 2 → ℂ)
          - Module.finrank ℂ
              (LinearMap.range (IncidenceCorank.coboundary ℂ 2)) = 0
      ∧ Module.finrank ℂ
          (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0
      ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 2 0)) = 0 := by
  refine ⟨FiniteKM.physicalPhases_two, IncidenceCorank.coboundary_corank_two ℂ,
    ?_, F4Winding.windingDirac_zero_winding 2⟩
  simp [LinearMap.ker_id]

/-! ## Axiom-footprint guard pins

The headline theorems depend only on the standard Lean/Mathlib axioms
`propext`, `Classical.choice`, `Quot.sound`; no extra axioms or proof
placeholders are introduced. -/

/-- info: 'C3IndexAnomalyCapstone.km_winding_lowN_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms km_winding_lowN_bridge

/-- info: 'C3IndexAnomalyCapstone.general_incidence_index_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms general_incidence_index_packet

/-- info: 'C3IndexAnomalyCapstone.c3_nondegenerate_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c3_nondegenerate_witness

/-- info: 'C3IndexAnomalyCapstone.c3_control_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c3_control_zero

end C3IndexAnomalyCapstone
