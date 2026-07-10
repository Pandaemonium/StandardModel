import Mathlib
import PhysicsSM.Draft.NullEdge.MassNullDecomposition
import PhysicsSM.Draft.NullEdge.MassEnergyBound
import PhysicsSM.Draft.NullEdge.MassFourFaces
import PhysicsSM.Draft.NullEdge.MasslessParticleTableCapstone
import PhysicsSM.Draft.NullEdge.ParticleInformationCapstone
import PhysicsSM.Draft.NullEdge.PhotonHiggsCPTCapstone
import PhysicsSM.Draft.NullEdge.HiggsCPTCapstone
import PhysicsSM.Draft.NullEdge.NeutrinoMassMechanismCapstone
import PhysicsSM.Draft.NullEdge.NeutrinoCPSeesawBridge
import PhysicsSM.Draft.NullEdge.SigmaMapNullEdges

/-!
# The particle mass-mechanism master capstone

`PhysicsSM.Draft.NullEdge.ParticleMassMechanismMasterCapstone`

This module is the master finite composition step of the *particle mass
mechanism* run.  It bundles one honest, kernel-checked representative packet
from each landed branch and states a single master verdict that the run carries
one finite theorem mesh with explicit nonzero / control witnesses and
false-shape guardrails.

## The three packets

* `null_edge_mass_packet` — **mass as null-edge disagreement**, the mass-energy
  bound, the four faces of finite mass, and the sigma-map null-edge bridge.
  Re-exports `MassNullDecomposition.det_eq_null_edge_disagreement`,
  `MassNullDecomposition.massSq_eq_two_null_disagreement`,
  `MassEnergyBound.det_le_half_trace_sq`, `MassFourFaces.four_faces_verdict`, and
  `SigmaMapNullEdges.sigmamap_null_edge_verdict`.
* `particle_information_higgs_packet` — the massless / massive particle table's
  disagreement-mass positive witnesses, the particle-information bridge
  (massless-vs-massive information and distinguishability / compression
  agreement), the photon / Higgs / CPT disagreement-with-symmetry witness, and
  the Higgs / CPT vector-longitudinal + fermion-luminal witnesses.  Re-exports
  `MasslessParticleTableCapstone.disagreement_mass_positive_witnesses`,
  `ParticleInformationCapstone.massless_vs_massive_information_bridge`,
  `ParticleInformationCapstone.distinguishability_compression_agree`,
  `PhotonHiggsCPTCapstone.mass_from_disagreement_with_cpt_symmetry`, and
  `HiggsCPTCapstone.vector_longitudinal_plus_fermion_luminal_witnesses`.
* `neutrino_sigma_packet` — the neutrino mass-mechanism verdict (Dirac /
  Majorana, type-I seesaw, Schur seesaw payload) and the neutrino CP / seesaw
  bridge.  Re-exports `NeutrinoMassMechanismCapstone.neutrino_mass_mechanism_verdict`
  and `NeutrinoCPSeesawBridge.neutrino_cp_seesaw_bridge`.

## Honest scope / claim boundary

Every conjunct is a re-export of an already-proved, finite, kernel-checked
imported result.  This master capstone is therefore:

* **NOT** a claim about any measured particle mass value;
* **NOT** a claim of Standard Model completion;
* **NOT** continuum quantum field theory.

It is precisely the statement that the run's finite avatars of the particle
mass mechanisms — null-edge disagreement, four faces, massless / massive table,
particle information, photon / Higgs / CPT, and neutrino CP / seesaw — form one
kernel-checked theorem mesh with explicit nonzero witnesses (e.g.
`0 < mink kmass kmass`, `jarlskog Vwitness ≠ 0`) and false-shape guardrails.
Each headline theorem carries an axiom-footprint guard pin below confirming it
depends only on the standard Lean/Mathlib axioms `propext`, `Classical.choice`,
`Quot.sound`.
-/

open Matrix
open scoped Matrix ComplexOrder BigOperators
open PhysicsSM.Draft.NullEdge

universe u v

namespace ParticleMassMechanismMasterCapstone

/-! ## Packet 1 — mass as null-edge disagreement / four faces / sigma map -/

/-- Statement of the null-edge mass packet. -/
def NullEdgeMassStmt : Prop :=
  -- (1) Plücker mass = disagreement of the null-edge decomposition
  (∀ {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ), P.PosSemidef →
      ∃ M : Matrix (Fin n) (Fin n) ℂ, P = M * Mᴴ ∧
        P.det = (Complex.normSq M.det : ℂ))
  -- (2) massive momentum = two-null sum with mass² = twice the disagreement
  ∧ (∀ (p : MassNullDecomposition.Four), 0 < p 0 → 0 < MassNullDecomposition.massSq p →
      ∃ k1 k2 : MassNullDecomposition.Four, MassNullDecomposition.massSq k1 = 0 ∧
        MassNullDecomposition.massSq k2 = 0 ∧
        (∀ i, p i = k1 i + k2 i) ∧
        MassNullDecomposition.massSq p = 2 * MassNullDecomposition.mink k1 k2)
  -- (3) mass-energy bound
  ∧ (∀ (P : Matrix (Fin 2) (Fin 2) ℂ), P.IsHermitian →
      P.det.re ≤ (P.trace.re / 2) ^ 2)
  -- (4) the four faces of finite mass are one invariant, with masslessness control
  ∧ ((∀ p x : ℚ, MassFourFaces.Slin p x = 2 * MassFourFaces.detR p x) ∧
      (∀ p : ℚ, MassFourFaces.Hlin p = 2 * MassFourFaces.detR p 0 ∧
        MassFourFaces.Slin p 0 = MassFourFaces.Hlin p) ∧
      (∀ p q : ℚ, MassFourFaces.TVdiag p q = |p * (1 - q) - (1 - p) * q|) ∧
      (∀ p : ℚ, MassFourFaces.detR p 0 = 0 ↔ p = 0 ∨ p = 1) ∧
      (∀ p : ℚ, MassFourFaces.Slin p 0 = 0 ↔ p = 0 ∨ p = 1) ∧
      (∀ p : ℚ, MassFourFaces.Hlin p = 0 ↔ p = 0 ∨ p = 1) ∧
      (∀ p q : ℚ, MassFourFaces.TVdiag p q = 0 ↔ p = q))
  -- (5) sigma-map null-edge bridge, with massless / massive controls
  ∧ (∀ E kz : ℚ,
      SigmaMapNullEdges.P E kz
          = (E + kz) • SigmaMapNullEdges.edge SigmaMapNullEdges.e0
            + (E - kz) • SigmaMapNullEdges.edge SigmaMapNullEdges.e1
        ∧ (SigmaMapNullEdges.edge SigmaMapNullEdges.e0).det = 0
        ∧ (SigmaMapNullEdges.edge SigmaMapNullEdges.e1).det = 0
        ∧ (SigmaMapNullEdges.P E kz).det = (E + kz) * (E - kz)
        ∧ (SigmaMapNullEdges.P E kz).det = E ^ 2 - kz ^ 2
        ∧ ((SigmaMapNullEdges.P E kz).det = 0 ↔ E ^ 2 = kz ^ 2)
        ∧ (0 < (SigmaMapNullEdges.P E kz).det ↔ kz ^ 2 < E ^ 2))

/-- **Null-edge mass packet.**  Bundles mass as null-edge disagreement (Level A
and Level B), the mass-energy bound, the four faces of finite mass, and the
sigma-map null-edge bridge. -/
theorem null_edge_mass_packet : NullEdgeMassStmt :=
  ⟨MassNullDecomposition.det_eq_null_edge_disagreement,
    MassNullDecomposition.massSq_eq_two_null_disagreement,
    MassEnergyBound.det_le_half_trace_sq,
    MassFourFaces.four_faces_verdict,
    SigmaMapNullEdges.sigmamap_null_edge_verdict⟩

/-! ## Packet 2 — particle information / table / photon / Higgs / CPT -/

/-- Statement of the particle-information / Higgs packet. -/
def ParticleInformationHiggsStmt : Prop :=
  -- (1) disagreement = mass, with positive witnesses (table)
  (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
        = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2
      ∧ PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16
      ∧ (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
      ∧ ((!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25 ∧
          0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2 ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25])
            = MasslessEdgeCount.edge ![1, 0] + MasslessEdgeCount.edge ![3/5, 4/5]))
  -- (2) massless vs massive information bridge
  ∧ ((PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1 ∧
        LeanQuantumDPIMass.Slin (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)) = 0) ∧
      (PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2 ∧
        0 < LeanQuantumDPIMass.Slin
          (LeanQuantumDPIMass.Phi 1 (LeanQuantumDPIMass.rho (1 / 2) (1 / 2)))))
  -- (3) distinguishability and compression agree on the massive witness
  ∧ (0 < TVDistinguishabilityMass.mass (![1, 0] : Fin 2 → ℚ) (![0, 1] : Fin 2 → ℚ) ∧
      0 < KraftCompressionMass.Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ))
  -- (4) mass from null-edge disagreement together with the CPT antiparticle symmetry
  ∧ (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
        = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2 ∧
      PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16 ∧
      (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass ∧
      ((∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.Theta v) = v) ∧
        (∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.gamma5.mulVec (CPTAntiparticleZigzag.Theta v)
            = - CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.gamma5.mulVec v)) ∧
        (∀ (m : ℝ) (v : Fin 4 → ℂ),
            CPTAntiparticleZigzag.Theta
                ((CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec (CPTAntiparticleZigzag.Theta v))
              = (CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec v) ∧
        (∀ (m : ℝ) (lam : ℂ) (v : Fin 4 → ℂ), v ≠ 0 →
            (CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec v = lam • v →
            (CPTAntiparticleZigzag.Dmat (m : ℂ)).mulVec (CPTAntiparticleZigzag.Theta v)
                = (starRingEnd ℂ lam) • CPTAntiparticleZigzag.Theta v ∧
              CPTAntiparticleZigzag.Theta v ≠ 0) ∧
        ((CPTAntiparticleZigzag.Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
            = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
          CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I]
              = ![1, -Complex.I, 1, -Complex.I] ∧
          (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
          CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ≠ 0)))
  -- (5) Higgs / CPT: vector longitudinal + fermion luminal witnesses
  ∧ (HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time
          = HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1
      ∧ ZitterbewegungAverage.meanVelocity 4 5 = 4 / 5
      ∧ DiracVelocityOperator.alpha1 * DiracVelocityOperator.alpha1 = 1
      ∧ ((CPTAntiparticleZigzag.Dmat 1).mulVec ![1, Complex.I, 1, Complex.I] =
            (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
          (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
          CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] =
            ![1, -Complex.I, 1, -Complex.I] ∧
          (CPTAntiparticleZigzag.Dmat 1).mulVec
              (CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I]) =
            (starRingEnd ℂ (1 + Complex.I)) •
              CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ∧
          CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ≠ 0))

/-- **Particle-information / Higgs packet.**  Bundles the massless / massive
particle table's positive disagreement-mass witnesses, the particle-information
bridge (massless-vs-massive information and distinguishability / compression
agreement), the photon / Higgs / CPT disagreement-with-symmetry witness, and the
Higgs / CPT vector-longitudinal + fermion-luminal witnesses. -/
theorem particle_information_higgs_packet : ParticleInformationHiggsStmt :=
  ⟨MasslessParticleTableCapstone.disagreement_mass_positive_witnesses,
    ParticleInformationCapstone.massless_vs_massive_information_bridge,
    ParticleInformationCapstone.distinguishability_compression_agree,
    PhotonHiggsCPTCapstone.mass_from_disagreement_with_cpt_symmetry,
    HiggsCPTCapstone.vector_longitudinal_plus_fermion_luminal_witnesses⟩

/-! ## Packet 3 — neutrino mass mechanism + CP / seesaw bridge -/

/-- Statement of the neutrino mass-mechanism verdict. -/
def NeutrinoMassVerdictStmt : Prop :=
    ((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
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
        (∀ v : Fin 4 → ℂ, NeutrinoDiracMajorana.Theta (NeutrinoDiracMajorana.Theta v) = v))) ∧
      ((∀ mD MR lp ln : ℝ,
        0 < mD → 0 < MR →
        lp * ln = -mD ^ 2 → lp + ln = MR → ln < 0 →
        0 < lp ∧ ln < 0 ∧ lp * (-ln) = mD ^ 2 ∧ -ln < mD ^ 2 / MR) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 100 → ln < 0 →
        100 < lp ∧ -ln < (1 : ℝ) ^ 2 / 100) ∧
      (∀ lp ln : ℝ,
        lp * ln = -(1 : ℝ) ^ 2 → lp + ln = 1 → ln < 0 →
        -ln < (1 : ℝ) ^ 2 / 1)) ∧
      ((∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh] [Nonempty nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      |(star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v).re|
        ≤ (star (Bᴴ *ᵥ v) ⬝ᵥ (Bᴴ *ᵥ v)).re /
          PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) ∧
    (∀ {nv nh : Type} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh]
        (A : Matrix nv nv ℂ) (B : Matrix nv nh ℂ) (M : Matrix nh nh ℂ)
        (hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      (star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = 0 ↔ Bᴴ *ᵥ v = 0)))

/-- Statement of the neutrino CP / seesaw bridge. -/
def NeutrinoCPSeesawStmt : Prop :=
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
          (star x ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ x = 0 ↔ Bᴴ *ᵥ x = 0)))

/-- Statement of the neutrino / seesaw packet. -/
def NeutrinoSigmaStmt : Prop := NeutrinoMassVerdictStmt ∧ NeutrinoCPSeesawStmt.{u, v}

/-- **Neutrino / seesaw packet.**  Bundles the neutrino mass-mechanism verdict
(Dirac / Majorana branches, type-I seesaw, Schur seesaw payload) and the
neutrino CP / seesaw bridge (KM CP-phase witness with nonzero Jarlskog and the
`N = 2` / `N = 3` controls). -/
theorem neutrino_sigma_packet : NeutrinoSigmaStmt :=
  ⟨NeutrinoMassMechanismCapstone.neutrino_mass_mechanism_verdict,
    NeutrinoCPSeesawBridge.neutrino_cp_seesaw_bridge⟩

/-! ## The master verdict -/

/-- **The particle mass-mechanism master capstone.**  One kernel-checked finite
theorem mesh: the run carries, with explicit nonzero / control witnesses and
false-shape guardrails, the null-edge mass packet, the particle-information /
Higgs packet, and the neutrino / seesaw packet.

This is a bundle of finite, kernel-checked results.  It makes **no** claim about
measured particle masses, **no** claim of Standard Model completion, and **no**
claim of continuum quantum field theory. -/
theorem particle_mass_mechanism_master_capstone :
    NullEdgeMassStmt ∧ ParticleInformationHiggsStmt ∧ NeutrinoSigmaStmt :=
  ⟨null_edge_mass_packet, particle_information_higgs_packet, neutrino_sigma_packet⟩

end ParticleMassMechanismMasterCapstone

/-! ## Axiom-footprint guard pins

Every headline theorem depends only on the standard Lean/Mathlib axioms
`propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'ParticleMassMechanismMasterCapstone.null_edge_mass_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleMassMechanismMasterCapstone.null_edge_mass_packet

/-- info: 'ParticleMassMechanismMasterCapstone.particle_information_higgs_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleMassMechanismMasterCapstone.particle_information_higgs_packet

/-- info: 'ParticleMassMechanismMasterCapstone.neutrino_sigma_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleMassMechanismMasterCapstone.neutrino_sigma_packet

/-- info: 'ParticleMassMechanismMasterCapstone.particle_mass_mechanism_master_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms ParticleMassMechanismMasterCapstone.particle_mass_mechanism_master_capstone
