# codex-photon-higgs-cpt-capstone-0720-20260709

aristotle:
  project_id: b4ebecee-58de-4b36-a5b8-1199dfed205b
  target_file: PhysicsSM/Draft/NullEdge/PhotonHiggsCPTCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.PhotonHiggsCPTCapstone
  submission_project: AgentTasks/aristotle-submit/codex-proof-wave-0720-20260709-project
  output_dir: AgentTasks/aristotle-output/b4ebecee-58de-4b36-a5b8-1199dfed205b
  status: harvested + ported 2026-07-09 ~08:15

You are Aristotle, proving an ambitious finite photon/Higgs/CPT capstone in
Lean. Stay in the exact finite-avatar scope: momentum, polarization/counting,
chirality, zigzag, and CPT finite matrix statements only. Do not claim a full
dynamical QFT mechanism. Do not add new assumptions, placeholder declarations,
or Lean escape-hatch tokens. Keep all witnesses explicit.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/PhotonHiggsCPTCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.PhotonSingleEdge
import PhysicsSM.Draft.NullEdge.HiggsLongitudinalMode
import PhysicsSM.Draft.NullEdge.HelicityChirality
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.ZitterbewegungAverage
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag
```

Mission:
Compose the landed finite null-edge mass-generation modules into one capstone:

1. Spin-1 photon witness: one null edge, rank one, two polarizations
   (`PhotonSingleEdge.photon_one_edge`).
2. Massive vector witness: two null edges, mass-squared equals disagreement,
   rank two, three polarizations (`PhotonSingleEdge.massive_vector_two_edges`).
3. Spin-1 arithmetic payload: `edges = pol - 1` and the universal null-edge
   disagreement law (`PhotonSingleEdge.edge_count_eq_pol_minus_one`,
   `PhotonSingleEdge.universal_verdict`).
4. Higgs/longitudinal count: massless vector has two physical polarizations;
   timelike vector has three; the extra longitudinal mode is the mass-count
   witness (`HiggsLongitudinalMode.massless_two_polarizations`,
   `massive_three_polarizations`, `longitudinal_is_mass`,
   `higgs_counting_verdict`).
5. Chiral/zigzag/CPT packet: massless helicity equals chirality; massive
   coupling flips chirality; the Weyl zigzag verdict holds; the CPT
   antiparticle mirror verdict holds
   (`HelicityChirality.verdict`, `ZigzagWeyl.zigzag_verdict 1`,
   `CPTAntiparticleZigzag.antiparticle_verdict`).
6. Optional if easy: include a rational zitterbewegung-average witness with
   simple positive hypotheses, e.g. `ZitterbewegungAverage.zitterbewegung_verdict
   3 5 4 ...`.

Preferred theorem shapes, adapted if the live API needs:

```lean
namespace PhotonHiggsCPTCapstone

theorem photon_higgs_cpt_capstone :
    PhotonSingleEdge.photon_one_edge
      ∧ PhotonSingleEdge.massive_vector_two_edges
      ∧ PhotonSingleEdge.edge_count_eq_pol_minus_one
      ∧ PhotonSingleEdge.universal_verdict
      ∧ HiggsLongitudinalMode.massless_two_polarizations
      ∧ HiggsLongitudinalMode.massive_three_polarizations
      ∧ HiggsLongitudinalMode.higgs_counting_verdict
      ∧ HelicityChirality.verdict
      ∧ ZigzagWeyl.zigzag_verdict 1
      ∧ CPTAntiparticleZigzag.antiparticle_verdict := by
  ...

theorem spin1_edge_longitudinal_agreement :
    PhotonSingleEdge.edgesSpin1 (PhotonSingleEdge.mink PhotonSingleEdge.kgamma
      PhotonSingleEdge.kgamma) = 1
      ∧ PhotonSingleEdge.polSpin1 (PhotonSingleEdge.mink PhotonSingleEdge.kgamma
          PhotonSingleEdge.kgamma) = 2
      ∧ PhotonSingleEdge.edgesSpin1 (PhotonSingleEdge.mink PhotonSingleEdge.kmass
          PhotonSingleEdge.kmass) = 2
      ∧ PhotonSingleEdge.polSpin1 (PhotonSingleEdge.mink PhotonSingleEdge.kmass
          PhotonSingleEdge.kmass) = 3
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time
          = HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1 := by
  ...

theorem mass_from_disagreement_with_cpt_symmetry :
    PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
        = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2
      ∧ PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16
      ∧ (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
      ∧ CPTAntiparticleZigzag.antiparticle_verdict := by
  ...

end PhotonHiggsCPTCapstone
```

If one imported statement is too heavy to elaborate, split helpers or omit the
optional zitterbewegung clause, but keep the photon/massive-vector edge count,
Higgs longitudinal count, chirality/zigzag, and CPT mirror claims together.

Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/PhotonHiggsCPTCapstone.lean
```

Return solved targets, exact theorem names, any statement adjustments, and the
dependency-footprint guard blocks you added.
