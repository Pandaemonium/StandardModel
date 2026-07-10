# codex-c3-index-anomaly-capstone-0800-20260709

aristotle:
  project_id: 998e717e-8ec3-4f6d-934e-1da0e4807120
  target_file: PhysicsSM/Draft/NullEdge/C3IndexAnomalyCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
  submission_project: AgentTasks/aristotle-submit/codex-proof-wave-0800-20260709-project
  output_dir: AgentTasks/aristotle-output/998e717e-8ec3-4f6d-934e-1da0e4807120
  status: submitted 2026-07-09 ~08:00

You are Aristotle, proving an ambitious finite Suite C3 bridge in Lean. The
target is the exact finite-index/anomaly bridge between the Goal II KM phase
count and the structured winding low-mode theorem. Stay in finite linear
algebra scope. Do not claim a continuum anomaly theorem, spectral density, or
full Standard Model derivation. Do not add new assumptions, placeholder
declarations, or Lean escape-hatch tokens. Keep all nonzero witnesses explicit.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/C3IndexAnomalyCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.IncidenceCorank
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone
```

Mission:
Compose the landed Goal II and winding-index modules into a theorem packet:

1. Goal II has no physical CP phase at `N = 2`, exactly one at `N = 3`, and the
   `3-4-5` witness is unitary with nonzero Jarlskog invariant.
2. The general incidence/corank theorem identifies the arithmetic phase count
   with the signed-incidence corank over any field.
3. The finite winding operator has analytic index `w`, kernel dimension `w`,
   zero cokernel, and refinement-stable protected low-mode count.
4. At the explicit C3 witness `N = 3`, `w = 1`, the KM phase count and winding
   protected-count both equal one; at the control `N = 2`, `w = 0`, both
   protections vanish. This is a finite bridge, not a continuum anomaly claim.

Preferred theorem shapes, adapted if live APIs require:

```lean
namespace C3IndexAnomalyCapstone

theorem km_winding_lowN_bridge :
    FiniteKM.physicalPhases 2 = 0
      /\ FiniteKM.physicalPhases 3 = 1
      /\ FiniteKM.Vwitness.conjTranspose * FiniteKM.Vwitness = 1
      /\ FiniteKM.jarlskog FiniteKM.Vwitness = 6912 / 78125
      /\ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0
      /\ ((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
          - Module.finrank ℂ
              ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
          = (1 : ℤ))
      /\ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1
      /\ Module.finrank ℂ
          ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1)) = 0
      /\ Module.finrank ℂ
          (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0 := by
  ...

theorem general_incidence_index_packet
    (K : Type*) [Field K] (N : Nat) (hN : 1 <= N) (w : Nat) :
    FiniteKM.physicalPhases N =
        Module.finrank K (IncidenceCorank.Edge N -> K)
          - Module.finrank K
              (LinearMap.range (IncidenceCorank.coboundary K N))
      /\ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) = w
      /\ ((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)) : ℤ)
          - Module.finrank ℂ
              ((Fin N → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac N w))
          = (w : ℤ))
      /\ F4Winding.winding_count_refinement_stable N w := by
  ...

theorem c3_nondegenerate_witness :
    (FiniteKM.physicalPhases 3 = 1 /\ FiniteKM.jarlskog FiniteKM.Vwitness ≠ 0)
      /\ (((Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 3 1)) : ℤ)
          - Module.finrank ℂ
              ((Fin 3 → ℂ) ⧸ LinearMap.range (F4Winding.windingDirac 3 1))
          = (1 : ℤ))
          /\ Module.finrank ℂ
              (LinearMap.ker (F4Winding.windingDirac 3 1)) = 1)
      /\ ((FiniteKM.physicalPhases 3 : ℤ) - (FiniteKM.physicalPhases 2 : ℤ)
          = (1 : ℤ))
      /\ F4Winding.winding_count_refinement_stable 3 1 := by
  ...

theorem c3_control_zero :
    FiniteKM.physicalPhases 2 = 0
      /\ Module.finrank ℂ (IncidenceCorank.Edge 2 -> ℂ)
          - Module.finrank ℂ
              (LinearMap.range (IncidenceCorank.coboundary ℂ 2)) = 0
      /\ Module.finrank ℂ
          (LinearMap.ker (LinearMap.id : (Fin 2 → ℂ) →ₗ[ℂ] (Fin 2 → ℂ))) = 0
      /\ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac 2 0)) = 0 := by
  ...

end C3IndexAnomalyCapstone
```

Use Lean's actual namespace/import conventions as required by the local files.
If a theorem name is a proof of an equality rather than a closed proposition,
restate the equality and close it by the imported theorem. Preserve the semantic
payload: C3 has an explicit one-phase/nonzero-Jarlskog witness and an explicit
one-index/protected low-mode witness, while the zero controls stay zero.

Add guard pins for headline theorem axiom footprints. Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/C3IndexAnomalyCapstone.lean
```

Return solved targets, exact theorem names, any statement adjustments, and any
dependency-footprint guard blocks you added.
