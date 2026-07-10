# codex-massless-particle-table-capstone-0740-20260709

aristotle:
  project_id: 0137b0f4-0aca-43b7-9df1-f2fecff234c1
  target_file: PhysicsSM/Draft/NullEdge/MasslessParticleTableCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.MasslessParticleTableCapstone
  submission_project: AgentTasks/aristotle-submit/codex-massless-table-wave-0740-20260709-project
  output_dir: AgentTasks/aristotle-output/0137b0f4-0aca-43b7-9df1-f2fecff234c1
  status: submitted 2026-07-09 ~07:45

You are Aristotle, proving an ambitious finite "mass from null edges" particle
table capstone in Lean. Stay in exact finite-avatar scope: rank/edge-count,
momentum and polarization counting, positive-sector taxonomy, chirality,
zigzag, and CPT finite statements. Do not claim a full dynamical QFT mechanism.
Do not add new assumptions, placeholder declarations, or Lean escape-hatch
tokens. Keep all nonzero witnesses explicit.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/MasslessParticleTableCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.MasslessEdgeCount
import PhysicsSM.Draft.NullEdge.PhotonSingleEdge
import PhysicsSM.Draft.NullEdge.HiggsLongitudinalMode
import PhysicsSM.Draft.NullEdge.PositiveSectorClass
import PhysicsSM.Draft.NullEdge.HelicityChirality
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.ZitterbewegungAverage
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag
```

Mission:
Compose the landed finite masslessness modules into one capstone theorem packet:

1. Rank/edge masslessness:
   `MasslessEdgeCount.massless_iff_one_edge`,
   `MasslessEdgeCount.massive_iff_two_edges`,
   `MasslessEdgeCount.edge_count_eq_rank`,
   `MasslessEdgeCount.mass_from_edges`,
   `MasslessEdgeCount.massless_witness`, and
   `MasslessEdgeCount.massive_witness`.
2. Spin-1 photon/massive-vector count:
   `PhotonSingleEdge.photon_one_edge`,
   `PhotonSingleEdge.massive_vector_two_edges`,
   `PhotonSingleEdge.edge_count_eq_pol_minus_one`,
   `PhotonSingleEdge.universal_verdict`.
3. Higgs/longitudinal count:
   `HiggsLongitudinalMode.massless_two_polarizations`,
   `HiggsLongitudinalMode.massive_three_polarizations`,
   `HiggsLongitudinalMode.higgs_counting_verdict`.
4. Positive/protected-null taxonomy:
   `PositiveSectorClass.physical_reading`.
5. Fermion/chiral packet:
   `HelicityChirality.verdict`, `ZigzagWeyl.zigzag_verdict 1`,
   `ZitterbewegungAverage.zitterbewegung_verdict 4 5 3 ...` if easy, and
   `CPTAntiparticleZigzag.antiparticle_verdict`.

Preferred theorem shapes, adapted if live APIs require:

```lean
namespace MasslessParticleTableCapstone

theorem massless_particle_table_capstone :
    MasslessEdgeCount.massless_witness
      ∧ MasslessEdgeCount.massive_witness
      ∧ PhotonSingleEdge.photon_one_edge
      ∧ PhotonSingleEdge.massive_vector_two_edges
      ∧ PhotonSingleEdge.edge_count_eq_pol_minus_one
      ∧ PhotonSingleEdge.universal_verdict
      ∧ HiggsLongitudinalMode.massless_two_polarizations
      ∧ HiggsLongitudinalMode.massive_three_polarizations
      ∧ HiggsLongitudinalMode.higgs_counting_verdict
      ∧ PositiveSectorClass.physical_reading
      ∧ HelicityChirality.verdict
      ∧ ZigzagWeyl.zigzag_verdict 1
      ∧ CPTAntiparticleZigzag.antiparticle_verdict := by
  ...

theorem rank_edge_spin1_agreement_bundle :
    MasslessEdgeCount.massless_witness
      ∧ MasslessEdgeCount.massive_witness
      ∧ PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1
      ∧ PhotonSingleEdge.polSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 2
      ∧ PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2
      ∧ PhotonSingleEdge.polSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 3
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3 := by
  ...

theorem disagreement_mass_positive_witnesses :
    PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
        = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2
      ∧ PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16
      ∧ (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
      ∧ MasslessEdgeCount.massive_witness := by
  ...

end MasslessParticleTableCapstone
```

If a preferred conjunction is blocked because an imported theorem is a proof
term rather than a `Prop` definition, restate the theorem's underlying
proposition exactly and discharge it with the imported proof term, as in
`HolographicResourceCapstone` and `TeleparallelWEPCapstone`.

Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/MasslessParticleTableCapstone.lean
```

Return solved targets, exact theorem names, any statement adjustments, and the
dependency-footprint guard blocks you added.
