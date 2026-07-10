import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.KMPhaseCounting
import PhysicsSM.Draft.NullEdge.KMFamilyRankBridge
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge

open scoped BigOperators F4Winding
open Module

/-!
# Goal II / Suite C3 — KM / CP / family-rank / anomaly flagship capstone

This file consolidates the landed Goal II Kobayashi–Maskawa phase-count story,
the family-rank bridge, and the Suite C3 winding/index anomaly bridge into four
citable, kernel-checked theorem packets, so the manuscript can point at a single
audit surface.

The payload is a **finite linear-algebra / arithmetic mesh**, not a continuum
anomaly theorem, spectral-flow statement, or full Standard Model derivation.
Everything below is a thin re-export / bundling of already-proved theorems from
the imported modules; no new mathematical content and no new axioms are
introduced.

## Results

* `km_cp_witness_packet` — explicit `N = 2` no-phase control, `N = 3`
  one-phase result, the `3-4-5` rational unitary witness `FiniteKM.Vwitness`,
  its exact rational Jarlskog value `6912 / 78125`, and nonzero Jarlskog.
* `family_rank_bridge_packet` — bundles the `KMFamilyRankBridge` rank-fixing
  datum with the `KMFlagship` low-`N` generation-structure rung.
* `c3_index_anomaly_packet` — bundles the C3 KM/winding low-`N` bridge, the
  general incidence/index packet, the C3 nondegenerate witness, the C3 zero
  control, and the `IndexProtectionBridge` winding-anomaly protection theorem.
* `km_c3_flagship_capstone` — finite KM phase counting, the family-rank bridge,
  and the C3 winding/index anomaly assembled into a single kernel-checked finite
  theorem mesh with explicit nondegenerate and control witnesses.

## Caveat

This is finite arithmetic and finite-dimensional rank-nullity bookkeeping only.
Every "index" is `dim ker − dim coker` for a linear map between
finite-dimensional complex vector spaces; there is no Fredholm theory,
Atiyah–Singer index theorem, spectral flow, heat-kernel/eta invariant, or
continuum-anomaly claim anywhere in the mesh.
-/

namespace KMC3FlagshipCapstone

/-- **KM / CP explicit witness packet.**  The `N = 2` control has no physical CP
phase, `N = 3` has exactly one, and the concrete `3-4-5` rational witness
`FiniteKM.Vwitness` is genuinely unitary, has the exact rational Jarlskog
invariant `6912 / 78125`, and hence nonzero Jarlskog. -/
theorem km_cp_witness_packet :
    FiniteKM.physicalPhases 2 = 0
      ∧ FiniteKM.physicalPhases 3 = 1
      ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
      ∧ FiniteKM.jarlskog FiniteKM.Vwitness = 6912 / 78125
      ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0 :=
  ⟨FiniteKM.physicalPhases_two, FiniteKM.physicalPhases_three,
    FiniteKM.Vwitness_unitary, FiniteKM.jarlskog_Vwitness,
    FiniteKM.jarlskog_Vwitness_ne_zero⟩

/-- **Family-rank bridge packet.**  Bundles the `KMFamilyRankBridge` rank-fixing
datum (`cp_one_is_rankfixing_datum`: the CP-phase predicate forces and realizes
strand rank `n = 2`, equivalently is logically equivalent to `n = 2`) with the
`KMFlagship` low-`N` generation-structure rung (`goalII_lowN_summary`: `N = 2`
has no physical CP phase and every unitary `2×2` is real-rephasable, while
`N = 3` has exactly one physical CP phase realized by the unitary `3-4-5`
witness with nonzero Jarlskog invariant). -/
theorem family_rank_bridge_packet :
    ((FamilyRankNoGo.Forces (fun n => FiniteKM.physicalPhases (n + 1) = 1) ∧
          FiniteKM.physicalPhases (2 + 1) = 1) ∧
        (∀ n, FiniteKM.physicalPhases (n + 1) = 1 ↔ n = 2))
      ∧ (FiniteKM.physicalPhases 2 = 0
          ∧ (∀ V : Matrix (Fin 2) (Fin 2) Complex, V.conjTranspose * V = 1 →
                ∃ dL dR : Fin 2 → Complex,
                  FiniteKM.IsPhase dL ∧ FiniteKM.IsPhase dR ∧
                    ∀ i j, ((FiniteKM.rephase dL dR V) i j).im = 0)
          ∧ FiniteKM.physicalPhases 3 = 1
          ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
          ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0) :=
  ⟨KMFamilyRankBridge.cp_one_is_rankfixing_datum, KMFlagship.goalII_lowN_summary⟩

/-- **C3 index / anomaly packet.**  Over any field `K`, for `1 ≤ N` and winding
`w`, this bundles:

* the C3 low-`N` KM/winding bridge (`km_winding_lowN_bridge`),
* the general incidence/index packet (`general_incidence_index_packet`),
* the C3 nondegenerate witness at `N = 3`, `w = 1`
  (`c3_nondegenerate_witness`),
* the C3 zero control at `N = 2`, `w = 0` (`c3_control_zero`), and
* the `IndexProtectionBridge` winding-anomaly protection theorem
  (`winding_anomaly_protects_modes`): the relative signed finite index equals
  the winding and the same winding lower-bounds the protected kernel modes. -/
theorem c3_index_anomaly_packet (K : Type*) [Field K] (N w : ℕ) (hN : 1 ≤ N) :
    -- C3 low-`N` KM / winding bridge
    (FiniteKM.physicalPhases 2 = 0
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
            (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0)
    -- general incidence / index packet over `K`
    ∧ (FiniteKM.physicalPhases N =
            Module.finrank K (IncidenceCorank.Edge N → K)
              - Module.finrank K
                  (LinearMap.range (IncidenceCorank.coboundary K N))
        ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) = w
        ∧ ((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) : ℤ)
            - Module.finrank ℂ
                ((Fin N → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac N w))
            = (w : ℤ))
        ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w))
            = Module.finrank ℂ
                (LinearMap.ker (F4Winding.windingDirac (2 * N) w)))
    -- C3 nondegenerate witness at `N = 3`, `w = 1`
    ∧ ((FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
        ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
            - Module.finrank ℂ
                ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
            = (1 : ℤ))
            ∧ Module.finrank ℂ
                (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
        ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ)
            = (1 : ℤ))
        ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
            = Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1)))
    -- C3 zero control at `N = 2`, `w = 0`
    ∧ (FiniteKM.physicalPhases 2 = 0
        ∧ Module.finrank ℂ (IncidenceCorank.Edge 2 → ℂ)
            - Module.finrank ℂ
                (LinearMap.range (IncidenceCorank.coboundary ℂ 2)) = 0
        ∧ Module.finrank ℂ
            (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0
        ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 2 0)) = 0)
    -- IndexProtectionBridge winding-anomaly protection
    ∧ (F4Winding.toyIndex (F4Winding.windingDirac N w)
          - F4Winding.toyIndex (F4Winding.windingDirac N 0) = (w : ℤ)
        ∧ w ≤ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w))) :=
  ⟨C3IndexAnomalyCapstone.km_winding_lowN_bridge,
    C3IndexAnomalyCapstone.general_incidence_index_packet K N hN w,
    C3IndexAnomalyCapstone.c3_nondegenerate_witness,
    C3IndexAnomalyCapstone.c3_control_zero,
    F4Winding.winding_anomaly_protects_modes N w⟩

/-- **KM / C3 flagship capstone.**  Finite KM phase counting, the family-rank
bridge, and the C3 winding/index anomaly assembled into a single kernel-checked
finite theorem mesh: the explicit KM/CP witness packet, the family-rank bridge
packet, and the C3 index/anomaly packet (with explicit nondegenerate `N = 3`,
`w = 1` and control `N = 2`, `w = 0` witnesses) all hold simultaneously, over
any field `K`, for every `1 ≤ N` and winding `w`. -/
theorem km_c3_flagship_capstone (K : Type*) [Field K] (N w : ℕ) (hN : 1 ≤ N) :
    (FiniteKM.physicalPhases 2 = 0
        ∧ FiniteKM.physicalPhases 3 = 1
        ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
        ∧ FiniteKM.jarlskog FiniteKM.Vwitness = 6912 / 78125
        ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
      ∧ (((FamilyRankNoGo.Forces (fun n => FiniteKM.physicalPhases (n + 1) = 1) ∧
              FiniteKM.physicalPhases (2 + 1) = 1) ∧
            (∀ n, FiniteKM.physicalPhases (n + 1) = 1 ↔ n = 2))
          ∧ (FiniteKM.physicalPhases 2 = 0
              ∧ (∀ V : Matrix (Fin 2) (Fin 2) Complex, V.conjTranspose * V = 1 →
                    ∃ dL dR : Fin 2 → Complex,
                      FiniteKM.IsPhase dL ∧ FiniteKM.IsPhase dR ∧
                        ∀ i j, ((FiniteKM.rephase dL dR V) i j).im = 0)
              ∧ FiniteKM.physicalPhases 3 = 1
              ∧ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
              ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0))
      ∧ ((FiniteKM.physicalPhases 2 = 0
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
                (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0)
          ∧ (FiniteKM.physicalPhases N =
                  Module.finrank K (IncidenceCorank.Edge N → K)
                    - Module.finrank K
                        (LinearMap.range (IncidenceCorank.coboundary K N))
              ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) = w
              ∧ ((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) : ℤ)
                  - Module.finrank ℂ
                      ((Fin N → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac N w))
                  = (w : ℤ))
              ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w))
                  = Module.finrank ℂ
                      (LinearMap.ker (F4Winding.windingDirac (2 * N) w)))
          ∧ ((FiniteKM.physicalPhases 3 = 1 ∧ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
              ∧ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
                  - Module.finrank ℂ
                      ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
                  = (1 : ℤ))
                  ∧ Module.finrank ℂ
                      (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
              ∧ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ)
                  = (1 : ℤ))
              ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1))
                  = Module.finrank ℂ
                      (LinearMap.ker (F4Winding.windingDirac (2 * 3) 1)))
          ∧ (FiniteKM.physicalPhases 2 = 0
              ∧ Module.finrank ℂ (IncidenceCorank.Edge 2 → ℂ)
                  - Module.finrank ℂ
                      (LinearMap.range (IncidenceCorank.coboundary ℂ 2)) = 0
              ∧ Module.finrank ℂ
                  (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0
              ∧ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 2 0)) = 0)
          ∧ (F4Winding.toyIndex (F4Winding.windingDirac N w)
                - F4Winding.toyIndex (F4Winding.windingDirac N 0) = (w : ℤ)
              ∧ w ≤ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)))) :=
  ⟨km_cp_witness_packet, family_rank_bridge_packet,
    c3_index_anomaly_packet K N w hN⟩

end KMC3FlagshipCapstone

/-! ## Kernel-footprint guard pins

Each headline theorem depends only on the standard Lean/Mathlib axioms
`propext`, `Classical.choice`, `Quot.sound`; no extra axioms or proof
placeholders are introduced. -/

/-- info: 'KMC3FlagshipCapstone.km_cp_witness_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMC3FlagshipCapstone.km_cp_witness_packet

/-- info: 'KMC3FlagshipCapstone.family_rank_bridge_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMC3FlagshipCapstone.family_rank_bridge_packet

/-- info: 'KMC3FlagshipCapstone.c3_index_anomaly_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMC3FlagshipCapstone.c3_index_anomaly_packet

/-- info: 'KMC3FlagshipCapstone.km_c3_flagship_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms KMC3FlagshipCapstone.km_c3_flagship_capstone
