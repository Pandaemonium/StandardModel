import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.NeutrinoDiracMajorana
import PhysicsSM.Draft.NullEdge.NeutrinoSeesaw
import PhysicsSM.Draft.NullEdge.SchurSeesaw
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag

/-!
# Neutrino CP / seesaw bridge

This file composes three previously landed finite modules into a single
structural bridge:

* **CP / family sector** (`FiniteKMCP`, `C3IndexAnomalyCapstone`): the explicit
  `3-4-5` KM witness `FiniteKM.Vwitness` is unitary with nonzero Jarlskog
  invariant, the arithmetic physical-phase count jumps from `0` at `N = 2` to
  `1` at `N = 3`, and the C3 index/anomaly witness is nondegenerate.
* **Neutrino mass-mechanism sector** (`NeutrinoDiracMajorana`, `NeutrinoSeesaw`,
  `SchurSeesaw`): the Dirac-vs-Majorana branch verdict, the finite `2×2`
  type-I seesaw suppression inequalities, and the Schur-complement seesaw
  suppression / zero-overlap facts.

The payload is a **finite structural bridge only**: it contains no physical PMNS
fit and no measured neutrino mass.  Every headline statement is assembled from
the exact imported theorem statements; see the guard pins at the end for the
a x i o m footprint.
-/

open scoped Matrix ComplexOrder

namespace NeutrinoCPSeesawBridge

universe u v

/-! ## 1. CP / family witness packet -/

/-- **CP / family witness packet.**  Bundles the unitarity of the KM witness
`FiniteKM.Vwitness`, its nonzero Jarlskog invariant, the physical-phase counts
`physicalPhases 2 = 0` and `physicalPhases 3 = 1`, and the full C3 nondegenerate
index/anomaly witness `C3IndexAnomalyCapstone.c3_nondegenerate_witness`. -/
theorem cp_family_witness_packet :
    (FiniteKM.Vwitnessᴴ * FiniteKM.Vwitness = 1) ∧
    (FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0) ∧
    (FiniteKM.physicalPhases 2 = 0) ∧
    (FiniteKM.physicalPhases 3 = 1) ∧
    ((FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
      ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
          - Module.finrank ℂ
              ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
          = (1 : ℤ))
          ∧ Module.finrank ℂ
              (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
      ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ)
          = (1 : ℤ))
      ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
          = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1))) :=
  ⟨FiniteKM.Vwitness_unitary, FiniteKM.jarlskog_Vwitness_ne_zero,
    FiniteKM.physicalPhases_two, FiniteKM.physicalPhases_three,
    C3IndexAnomalyCapstone.c3_nondegenerate_witness⟩

/-! ## 2. Dirac / Majorana / seesaw packet -/

/-- **Dirac / Majorana / seesaw packet.**  Bundles the Dirac-vs-Majorana branch
verdict (`NeutrinoDiracMajorana.neutrino_verdict`), the finite type-I seesaw
inequalities (`NeutrinoSeesaw.seesaw_verdict`, `nondegen_suppressed`,
`nondegen_control`), and the Schur-complement seesaw suppression bound and
zero-overlap characterisation (`SchurSeesaw.seesaw_suppression`,
`seesaw_zero_iff_no_overlap`). -/
theorem dirac_majorana_seesaw_packet :
    -- Dirac / Majorana branch verdict
    (((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD *ᵥ NeutrinoDiracMajorana.psiP = NeutrinoDiracMajorana.psiDPartner ∧
          NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
            NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q
              = NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
          NeutrinoDiracMajorana.MM *ᵥ NeutrinoDiracMajorana.psiInv ≠ 0 ∧
            NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q
              ≠ NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
        ∀ (w : Fin 4 → ℂ),
          NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta w) = w)) ∧
    -- type-I seesaw inequalities
    (∀ (mD MR lp ln : ℝ), 0 < mD → 0 < MR → lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
        0 < lp ∧ ln < 0 ∧ lp * -ln = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
    (∀ (lp ln : ℝ), lp * ln = -1 ^ 2 → lp + ln = 100 → ln < 0 →
        100 < lp ∧ -ln < 1 ^ 2 / 100) ∧
    (∀ (lp ln : ℝ), lp * ln = -1 ^ 2 → lp + ln = 1 → ln < 0 → -ln < 1 ^ 2 / 1) ∧
    -- Schur-complement seesaw suppression
    (∀ {nv : Type u} {nh : Type v} [Fintype nv] [Fintype nh] [DecidableEq nh] [Nonempty nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ) (hM : M.PosDef)
        (x : nv → ℂ), A *ᵥ x = 0 →
        |(star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x).re| ≤
          (star (Bᴴ *ᵥ x) ⬝ᵥ Bᴴ *ᵥ x).re / PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
    -- Schur-complement zero-overlap characterisation
    (∀ {nv : Type u} {nh : Type v} [Fintype nv] [Fintype nh] [DecidableEq nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ),
        M.PosDef → ∀ (x : nv → ℂ), A *ᵥ x = 0 →
        (star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x = 0 ↔ Bᴴ *ᵥ x = 0)) :=
  ⟨NeutrinoDiracMajorana.neutrino_verdict,
    NeutrinoSeesaw.seesaw_verdict,
    NeutrinoSeesaw.nondegen_suppressed,
    NeutrinoSeesaw.nondegen_control,
    PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_suppression,
    PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_zero_iff_no_overlap⟩

/-! ## 3. The neutrino CP / seesaw bridge -/

/-- **Neutrino CP / seesaw bridge.**  Finite CP/family rank and index/anomaly
data (`cp_family_witness_packet`) coexist with a finite neutrino mass-mechanism
hierarchy (`dirac_majorana_seesaw_packet`).  Scope: structural finite bridge
only — no physical PMNS fit and no measured neutrino mass. -/
theorem neutrino_cp_seesaw_bridge :
    ((FiniteKM.Vwitnessᴴ * FiniteKM.Vwitness = 1) ∧
      (FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0) ∧
      (FiniteKM.physicalPhases 2 = 0) ∧
      (FiniteKM.physicalPhases 3 = 1) ∧
      ((FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
        ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
            - Module.finrank ℂ
                ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
            = (1 : ℤ))
            ∧ Module.finrank ℂ
                (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
        ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ)
            = (1 : ℤ))
        ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
            = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1)))) ∧
    ((((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
          NeutrinoDiracMajorana.MD *ᵥ NeutrinoDiracMajorana.psiP
            = NeutrinoDiracMajorana.psiDPartner ∧
            NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
              NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q
                = NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
        (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv
              = NeutrinoDiracMajorana.psiInv ∧
            NeutrinoDiracMajorana.MM *ᵥ NeutrinoDiracMajorana.psiInv ≠ 0 ∧
              NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q
                ≠ NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
          ∀ (w : Fin 4 → ℂ),
            NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta w) = w)) ∧
      (∀ (mD MR lp ln : ℝ), 0 < mD → 0 < MR → lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
          0 < lp ∧ ln < 0 ∧ lp * -ln = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
      (∀ (lp ln : ℝ), lp * ln = -1 ^ 2 → lp + ln = 100 → ln < 0 →
          100 < lp ∧ -ln < 1 ^ 2 / 100) ∧
      (∀ (lp ln : ℝ), lp * ln = -1 ^ 2 → lp + ln = 1 → ln < 0 → -ln < 1 ^ 2 / 1) ∧
      (∀ {nv : Type u} {nh : Type v} [Fintype nv] [Fintype nh] [DecidableEq nh] [Nonempty nh]
          (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ) (hM : M.PosDef)
          (x : nv → ℂ), A *ᵥ x = 0 →
          |(star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x).re| ≤
            (star (Bᴴ *ᵥ x) ⬝ᵥ Bᴴ *ᵥ x).re
              / PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
      (∀ {nv : Type u} {nh : Type v} [Fintype nv] [Fintype nh] [DecidableEq nh]
          (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ),
          M.PosDef → ∀ (x : nv → ℂ), A *ᵥ x = 0 →
          (star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x = 0 ↔ Bᴴ *ᵥ x = 0))) :=
  ⟨cp_family_witness_packet, dirac_majorana_seesaw_packet⟩

/-! ## Axiom-footprint guard pins

Each headline theorem is kernel-checked and depends only on the standard
Lean/Mathlib axioms `propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'NeutrinoCPSeesawBridge.cp_family_witness_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cp_family_witness_packet

/-- info: 'NeutrinoCPSeesawBridge.dirac_majorana_seesaw_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dirac_majorana_seesaw_packet

/-- info: 'NeutrinoCPSeesawBridge.neutrino_cp_seesaw_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms neutrino_cp_seesaw_bridge

end NeutrinoCPSeesawBridge
