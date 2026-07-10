# codex-particle-information-capstone-0825-20260709

aristotle:
  project_id: 46dde441-bcac-4409-a836-1910de748154
  target_file: PhysicsSM/Draft/NullEdge/ParticleInformationCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.ParticleInformationCapstone
  submission_project: AgentTasks/aristotle-submit/codex-proof-wave-ready-0825-20260709-project
  output_dir: pending
  status: submitted 2026-07-09 08:13 PDT after refresh with
    TV/Kraft/massless-table harvests

You are Aristotle, proving a finite particle/information capstone in Lean.
Stay in exact finite-avatar scope: null-edge spin/counting, finite CPT/Dirac
versus Majorana structure, and rational linear-entropy/coarse-graining. Do not
claim a full QFT mechanism, a physical neutrino prediction, or the full von
Neumann relative-entropy DPI. Do not add new assumptions, placeholder
declarations, or Lean escape-hatch tokens. Keep all nonzero witnesses explicit.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/ParticleInformationCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.PhotonHiggsCPTCapstone
import PhysicsSM.Draft.NullEdge.MasslessParticleTableCapstone
import PhysicsSM.Draft.NullEdge.LeanQuantumDPIMass
import PhysicsSM.Draft.NullEdge.TVDistinguishabilityMass
import PhysicsSM.Draft.NullEdge.KraftCompressionMass
import PhysicsSM.Draft.NullEdge.NeutrinoDiracMajorana
```

Mission:
Compose the newly landed finite particle and information modules into one
kernel-checked theorem packet. This is a capstone composition job: restate the
underlying propositions of imported theorem terms when needed, prove the bundle
from the imports, and add one or two genuinely useful bridge lemmas if they are
within reach.

1. `PhotonHiggsCPTCapstone.spin1_edge_longitudinal_agreement`: photon has one
   null edge/two polarizations; massive vector has two edges/three
   polarizations; the Higgs longitudinal count is the extra degree of freedom.
2. `PhotonHiggsCPTCapstone.mass_from_disagreement_with_cpt_symmetry`: finite
   massive-vector mass-squared is null-edge disagreement and is compatible with
   the CPT antiparticle mirror theorem.
3. `LeanQuantumDPIMass.mass_created`,
   `LeanQuantumDPIMass.linear_entropy_monotone`,
   `LeanQuantumDPIMass.entropy_gain`,
   `LeanQuantumDPIMass.channel_is_state`, and
   `LeanQuantumDPIMass.signed_closure_exception`: finite linear entropy is the
   rational mass-squared information avatar; pinching is state-preserving and
   monotone, but coherent signed closure is not merely noise.
4. `NeutrinoDiracMajorana.neutrino_verdict`,
   `NeutrinoDiracMajorana.dirac_two_states`,
   `NeutrinoDiracMajorana.majorana_self_conjugate`, and
   `NeutrinoDiracMajorana.lepton_number`: the finite Dirac/Majorana split is
   exactly whether CPT conjugacy produces a new independent zigzag or the same
   self-conjugate zigzag, with lepton-number conservation/violation separated.
5. `MasslessParticleTableCapstone.massless_particle_table_capstone`,
   `rank_edge_spin1_agreement_bundle`, and
   `disagreement_mass_positive_witnesses`: the full finite particle-table
   masslessness packet.
6. `TVDistinguishabilityMass.distinguishability_verdict`,
   `mass_is_distinguishability`, `witness_distinguishable`, and
   `witness_strict_dpi`: mass as finite total-variation distinguishability,
   monotone under coarse-graining with strict collapse witness.
7. `KraftCompressionMass.compression_verdict`,
   `mass_is_compressibility`, `mixed_witness_Hlin`, and `mixed_kraft_le`: mass
   as finite rational compression cost / linear-entropy cost with explicit
   prefix-code witness.

Preferred theorem shapes, adapted if live APIs require:

```lean
namespace ParticleInformationCapstone

open PhotonSingleEdge HiggsLongitudinalMode

theorem particle_information_capstone :
    -- spin/longitudinal finite counting
    (PhotonSingleEdge.edgesSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1 /\
      PhotonSingleEdge.polSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 2 /\
      PhotonSingleEdge.edgesSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2 /\
      PhotonSingleEdge.polSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 3 /\
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2 /\
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3 /\
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time =
        HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1) /\
    -- information mass monotonicity and nondegeneracy
    (LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1/2) (1/2)) = 0 /\
      LeanQuantumDPIMass.Slin
        (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1/2) (1/2))) = 1/2 /\
      (forall p x t : Q, 0 <= t -> t <= 1 ->
        LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho p x) <=
          LeanQuantumDPIMass.Slin
            (LeanQuantumDPIMass.Phi t (LeanQuantumDPIMass.rho p x)))) /\
    -- Dirac/Majorana structural split
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP
        <> NeutrinoDiracMajorana.psiP) /\
      NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
        NeutrinoDiracMajorana.psiDPartner /\
      NeutrinoDiracMajorana.psiDPartner <> NeutrinoDiracMajorana.psiP /\
      NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv =
        NeutrinoDiracMajorana.psiInv /\
      NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv <> 0 /\
      NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
        NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD /\
      NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q <>
        NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) := by
  ...

theorem information_mass_guardrails :
    LeanQuantumDPIMass.mass_created /\
    (forall p x t : Q, 0 <= t -> t <= 1 ->
      LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho p x) <=
        LeanQuantumDPIMass.Slin
          (LeanQuantumDPIMass.Phi t (LeanQuantumDPIMass.rho p x))) /\
    (forall p x t : Q,
      LeanQuantumDPIMass.Slin
          (LeanQuantumDPIMass.Phi t (LeanQuantumDPIMass.rho p x)) -
        LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho p x) =
          2 * t * (2 - t) * x ^ 2) /\
    LeanQuantumDPIMass.signed_closure_exception := by
  ...

theorem distinguishability_compression_guardrails :
    TVDistinguishabilityMass.distinguishability_verdict /\
      TVDistinguishabilityMass.witness_distinguishable /\
      TVDistinguishabilityMass.witness_strict_dpi /\
      KraftCompressionMass.compression_verdict /\
      KraftCompressionMass.mixed_witness_Hlin = 5 / 8 /\
      0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 -> Q) /\
      KraftCompressionMass.codeK KraftCompressionMass.mixedCode <= 1 := by
  ...

theorem full_particle_table_information_bridge :
    MasslessParticleTableCapstone.massless_particle_table_capstone /\
      MasslessParticleTableCapstone.rank_edge_spin1_agreement_bundle /\
      MasslessParticleTableCapstone.disagreement_mass_positive_witnesses /\
      PhotonHiggsCPTCapstone.photon_higgs_cpt_capstone /\
      LeanQuantumDPIMass.dpi_verdict /\
      TVDistinguishabilityMass.distinguishability_verdict /\
      KraftCompressionMass.compression_verdict /\
      NeutrinoDiracMajorana.neutrino_verdict := by
  ...

theorem neutrino_cpt_phase_guardrails :
    NeutrinoDiracMajorana.dirac_two_states /\
      NeutrinoDiracMajorana.majorana_self_conjugate /\
      NeutrinoDiracMajorana.lepton_number /\
      NeutrinoDiracMajorana.neutrino_verdict := by
  ...

end ParticleInformationCapstone
```

The preferred shapes intentionally include a few proof-term shorthand lines such
as `LeanQuantumDPIMass.mass_created`,
`TVDistinguishabilityMass.distinguishability_verdict`, or
`KraftCompressionMass.compression_verdict`; if those do not typecheck as
propositions, restate the exact proposition proved by that theorem and discharge
it with the imported theorem. That is the desired adjustment, not a weakening.
Use Lean's actual symbols for rationals/integers/inequality in the target file.

Add guard pins for headline theorem axiom footprints. Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/ParticleInformationCapstone.lean
```

Return solved targets, exact theorem names, statement adjustments, and the
dependency-footprint guard blocks you added.
