/-
# Finite particle / information capstone

This file composes the landed finite null-edge **particle** and **information**
modules into one kernel-checked theorem packet.  Everything here is a *finite
avatar*: null-edge spin / polarization counting, finite CPT / Dirac-versus-
Majorana matrix structure, and rational linear-entropy / total-variation /
compression statements.  Nothing here claims a full quantum field theory
mechanism, a physical neutrino prediction, or the full von Neumann relative
entropy data-processing inequality; the honest scope is momentum-level and
finite-dimensional linear algebra together with rational information avatars.

The packet is assembled purely from already-proved statements in:

* `PhotonHiggsCPTCapstone`        - spin-1 edge / longitudinal counting, mass as
                                    null-edge disagreement with CPT mirror;
* `MasslessParticleTableCapstone` - the full finite particle-table masslessness
                                    packet;
* `LeanQuantumDPIMass`            - rational linear-entropy mass avatar (DPI);
* `TVDistinguishabilityMass`      - mass as total-variation distinguishability;
* `KraftCompressionMass`          - mass as rational compression cost;
* `NeutrinoDiracMajorana`         - the finite Dirac / Majorana structural split.

All witnesses stay explicit; no new assumptions or placeholder declarations are
introduced.  Each headline is discharged directly from the imported theorem
terms.  The one giant eight-way bundle
(`full_particle_table_information_bridge`) is a re-export whose *type is inferred*
from the imported proofs, so its statement is provably **exactly** the
conjunction of the eight imported propositions (Lean cannot infer a `theorem`
header type, hence the `def` keyword; it is nonetheless a kernel-checked proof of
that conjunction, with the standard axiom footprint pinned below).
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.PhotonHiggsCPTCapstone
import PhysicsSM.Draft.NullEdge.MasslessParticleTableCapstone
import PhysicsSM.Draft.NullEdge.LeanQuantumDPIMass
import PhysicsSM.Draft.NullEdge.TVDistinguishabilityMass
import PhysicsSM.Draft.NullEdge.KraftCompressionMass
import PhysicsSM.Draft.NullEdge.NeutrinoDiracMajorana

open scoped Matrix

namespace ParticleInformationCapstone

open PhotonSingleEdge HiggsLongitudinalMode

/-! ## Headline 1 — the composed particle / information capstone -/

/-- **The finite particle / information capstone.**

* *Spin / longitudinal counting.* The photon carries one null edge and two
  polarizations; the massive vector carries two null edges and three
  polarizations; the Higgs longitudinal count is the extra degree of freedom
  (`physDim k_time = physDim k_null + 1`).
* *Information mass.* The pure/massless state has zero linear entropy, fully
  pinching it creates `Slin = 1/2`, and linear entropy is monotone under
  coarse-graining (the finite DPI core).
* *Dirac / Majorana split.* CPT conjugacy sends the Dirac state to a genuinely
  new independent partner (lepton number conserved, `[M_D,Q]=0`), whereas the
  Majorana sector has a self-conjugate witness on which `M_M` acts (lepton number
  violated, `[M_M,Q]≠0`). -/
theorem particle_information_capstone :
    (PhotonSingleEdge.edgesSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1 ∧
      PhotonSingleEdge.polSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 2 ∧
      PhotonSingleEdge.edgesSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2 ∧
      PhotonSingleEdge.polSpin1
        (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 3 ∧
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2 ∧
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3 ∧
      HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time =
        HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1) ∧
    (LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = 0 ∧
      LeanQuantumDPIMass.Slin
        (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2))) = 1 / 2 ∧
      (∀ p x t : ℚ, 0 ≤ t → t ≤ 1 →
        LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho p x) ≤
          LeanQuantumDPIMass.Slin
            (LeanQuantumDPIMass.Phi t (LeanQuantumDPIMass.rho p x)))) ∧
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP
        ≠ NeutrinoDiracMajorana.psiP) ∧
      NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
        NeutrinoDiracMajorana.psiDPartner ∧
      NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
      NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv =
        NeutrinoDiracMajorana.psiInv ∧
      NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
      NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
        NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
      NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
        NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) := by
  refine ⟨PhotonHiggsCPTCapstone.spin1_edge_longitudinal_agreement, ?_, ?_⟩
  · obtain ⟨hc1, _, hc3⟩ := LeanQuantumDPIMass.mass_created
    exact ⟨hc1, hc3,
      fun p x t h0 h1 => LeanQuantumDPIMass.linear_entropy_monotone p x t h0 h1⟩
  · obtain ⟨hd1, hd2, hd3⟩ := NeutrinoDiracMajorana.dirac_two_states
    obtain ⟨hm1, hm2, _, _⟩ := NeutrinoDiracMajorana.majorana_self_conjugate
    obtain ⟨hl1, hl2, _⟩ := NeutrinoDiracMajorana.lepton_number
    exact ⟨hd1, hd2, hd3, hm1, hm2, hl1, hl2⟩

/-! ## Headline 2 — information-mass guardrails -/

/-- **Information-mass guardrails.**  `mass_created` (pinching a pure state makes
`Slin` jump `0 → 1/2`), monotonicity of `Slin` under coarse-graining, the closed
form of the gain `Slin (Phi t ρ) - Slin ρ = 2 t (2 - t) x²`, and the signed
closure exception (a coherent `3-4-5` rotation strictly lowers the post-channel
entropy). -/
theorem information_mass_guardrails :
    (LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = 0 ∧
      LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = !![1 / 2, 0; 0, 1 / 2] ∧
      LeanQuantumDPIMass.Slin
        (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2))) = 1 / 2) ∧
    (∀ p x t : ℚ, 0 ≤ t → t ≤ 1 →
      LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho p x) ≤
        LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.Phi t (LeanQuantumDPIMass.rho p x))) ∧
    (∀ p x t : ℚ,
      LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.Phi t (LeanQuantumDPIMass.rho p x)) -
          LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho p x) =
        2 * t * (2 - t) * x ^ 2) ∧
    (LeanQuantumDPIMass.Slin
        (LeanQuantumDPIMass.Phi 1
          (LeanQuantumDPIMass.U345 * LeanQuantumDPIMass.rho (1 / 2) (1 / 4) *
            LeanQuantumDPIMass.U345ᵀ)) <
      LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 4)))) :=
  ⟨LeanQuantumDPIMass.mass_created,
    LeanQuantumDPIMass.linear_entropy_monotone,
    LeanQuantumDPIMass.entropy_gain,
    LeanQuantumDPIMass.signed_closure_exception⟩

/-! ## Headline 3 — distinguishability / compression guardrails -/

/-- **Distinguishability / compression guardrails.**  The packaged TV verdict and
its strict data-processing witness, together with the compression verdict and its
explicit rational witnesses (`Hlin = 5/8`, positive, Kraft-admissible). -/
theorem distinguishability_compression_guardrails :
    ((∀ (p q : Fin 2 → ℚ), TVDistinguishabilityMass.IsProb p → TVDistinguishabilityMass.IsProb q →
          TVDistinguishabilityMass.TV p q = TVDistinguishabilityMass.mass p q ∧
            0 ≤ TVDistinguishabilityMass.TV p q ∧ TVDistinguishabilityMass.TV p q ≤ 1 ∧
            (TVDistinguishabilityMass.TV p q = 0 ↔ TVDistinguishabilityMass.wedge p q = 0)) ∧
        (∀ {m n : ℕ} (K : Fin m → Fin n → ℚ), TVDistinguishabilityMass.ColStoch K →
            ∀ (p q : Fin n → ℚ),
              TVDistinguishabilityMass.TV (TVDistinguishabilityMass.applyK K p)
                  (TVDistinguishabilityMass.applyK K q) ≤ TVDistinguishabilityMass.TV p q) ∧
        TVDistinguishabilityMass.TV
            (TVDistinguishabilityMass.applyK TVDistinguishabilityMass.collapse
              (![1, 0] : Fin 2 → ℚ))
            (TVDistinguishabilityMass.applyK TVDistinguishabilityMass.collapse
              (![0, 1] : Fin 2 → ℚ)) <
          TVDistinguishabilityMass.TV (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ)) ∧
    (TVDistinguishabilityMass.TV (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) = 1 ∧
      TVDistinguishabilityMass.mass (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) = 1) ∧
    (TVDistinguishabilityMass.TV
        (TVDistinguishabilityMass.applyK TVDistinguishabilityMass.collapse (![1, 0] : Fin 2 → ℚ))
        (TVDistinguishabilityMass.applyK TVDistinguishabilityMass.collapse (![0, 1] : Fin 2 → ℚ)) <
      TVDistinguishabilityMass.TV (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ)) ∧
    ((KraftCompressionMass.Hlin (![1, 0, 0] : Fin 3 → ℚ) = 0 ∧
        ∃ i, (![1, 0, 0] : Fin 3 → ℚ) i = 1) ∧
      0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) ∧
        KraftCompressionMass.PrefixFree KraftCompressionMass.mixedCode ∧
        KraftCompressionMass.codeK KraftCompressionMass.mixedCode ≤ 1) ∧
    KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) = 5 / 8 ∧
    0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) ∧
    KraftCompressionMass.codeK KraftCompressionMass.mixedCode ≤ 1 :=
  ⟨TVDistinguishabilityMass.distinguishability_verdict,
    TVDistinguishabilityMass.witness_distinguishable,
    TVDistinguishabilityMass.witness_strict_dpi,
    KraftCompressionMass.compression_verdict,
    KraftCompressionMass.mixed_witness_Hlin,
    KraftCompressionMass.mixed_witness_massive,
    KraftCompressionMass.mixed_kraft_le⟩

/-! ## Headline 4 — the full particle-table / information bridge

The eight landed headline propositions in a single kernel-checked conjunction:
the full particle-table masslessness packet, the photon/Higgs/CPT capstone, and
the four information-mass verdicts (DPI, TV distinguishability, compression, and
the neutrino Dirac/Majorana split).

This is a pure re-export: its type is inferred from the imported proofs, so the
statement is exactly the conjunction of the eight imported propositions. -/

/-- **Full particle-table / information bridge.**  A single bundle of all eight
imported headlines; the statement is the (inferred) conjunction of exactly the
imported propositions. -/
def full_particle_table_information_bridge :=
  And.intro MasslessParticleTableCapstone.massless_particle_table_capstone
    (And.intro MasslessParticleTableCapstone.rank_edge_spin1_agreement_bundle
      (And.intro MasslessParticleTableCapstone.disagreement_mass_positive_witnesses
        (And.intro PhotonHiggsCPTCapstone.photon_higgs_cpt_capstone
          (And.intro LeanQuantumDPIMass.dpi_verdict
            (And.intro TVDistinguishabilityMass.distinguishability_verdict
              (And.intro KraftCompressionMass.compression_verdict
                NeutrinoDiracMajorana.neutrino_verdict))))))

/-! ## Headline 5 — neutrino CPT-phase guardrails -/

/-- **Neutrino CPT-phase guardrails.**  `dirac_two_states`,
`majorana_self_conjugate`, `lepton_number`, and the packaged `neutrino_verdict`,
in one conjunction. -/
theorem neutrino_cpt_phase_guardrails :
    (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
      NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
        NeutrinoDiracMajorana.psiDPartner ∧
      NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP) ∧
    (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
      NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
      NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiNI ≠ NeutrinoDiracMajorana.psiNI ∧
      NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiNI = 0) ∧
    (NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
        NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD ∧
      NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
        NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM ∧
      (NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q -
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) 0 2 = -2) ∧
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD.mulVec NeutrinoDiracMajorana.psiP =
          NeutrinoDiracMajorana.psiDPartner ∧
        NeutrinoDiracMajorana.psiDPartner ≠ NeutrinoDiracMajorana.psiP ∧
        NeutrinoDiracMajorana.MD * NeutrinoDiracMajorana.Q =
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MD) ∧
      (NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiInv = NeutrinoDiracMajorana.psiInv ∧
        NeutrinoDiracMajorana.MM.mulVec NeutrinoDiracMajorana.psiInv ≠ 0 ∧
        NeutrinoDiracMajorana.MM * NeutrinoDiracMajorana.Q ≠
          NeutrinoDiracMajorana.Q * NeutrinoDiracMajorana.MM) ∧
      (∀ v : Fin 4 → ℂ, NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta v) = v)) :=
  ⟨NeutrinoDiracMajorana.dirac_two_states,
    NeutrinoDiracMajorana.majorana_self_conjugate,
    NeutrinoDiracMajorana.lepton_number,
    NeutrinoDiracMajorana.neutrino_verdict⟩

/-! ## Bridge lemmas — the mass avatars agree on the massless/massive verdict -/

/-- **Masslessness certificates agree.**  The photon's single null edge pairs with
the zero linear entropy of the pure information state; the massive vector's two
null edges pair with the strictly positive linear entropy created by pinching. -/
theorem massless_vs_massive_information_bridge :
    (PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1 ∧
        LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = 0) ∧
    (PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2 ∧
        0 < LeanQuantumDPIMass.Slin
          (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)))) := by
  obtain ⟨he1, _, he2, _, _, _, _⟩ :=
    PhotonHiggsCPTCapstone.spin1_edge_longitudinal_agreement
  obtain ⟨hz, _, hp⟩ := LeanQuantumDPIMass.mass_created
  exact ⟨⟨he1, hz⟩, he2, by rw [hp]; norm_num⟩

/-- **Distinguishability and compression agree on the massive witness.**  The
perfectly distinguishable null-edge pair has positive total-variation mass, and
the mixed direction message has positive linear-entropy compression cost. -/
theorem distinguishability_compression_agree :
    0 < TVDistinguishabilityMass.mass (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) ∧
    0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) := by
  refine ⟨?_, KraftCompressionMass.mixed_witness_massive⟩
  rw [TVDistinguishabilityMass.witness_distinguishable.2]; norm_num

end ParticleInformationCapstone

/-! ## Dependency-footprint guard pins

Every headline of the capstone depends on exactly the standard finite axiom set
`[propext, Classical.choice, Quot.sound]`; no extra assumptions or placeholder-style
handoff markers are introduced. -/

/-- info: 'ParticleInformationCapstone.particle_information_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.particle_information_capstone

/-- info: 'ParticleInformationCapstone.information_mass_guardrails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.information_mass_guardrails

/-- info: 'ParticleInformationCapstone.distinguishability_compression_guardrails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.distinguishability_compression_guardrails

/-- info: 'ParticleInformationCapstone.full_particle_table_information_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.full_particle_table_information_bridge

/-- info: 'ParticleInformationCapstone.neutrino_cpt_phase_guardrails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.neutrino_cpt_phase_guardrails

/-- info: 'ParticleInformationCapstone.massless_vs_massive_information_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.massless_vs_massive_information_bridge

/-- info: 'ParticleInformationCapstone.distinguishability_compression_agree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleInformationCapstone.distinguishability_compression_agree
