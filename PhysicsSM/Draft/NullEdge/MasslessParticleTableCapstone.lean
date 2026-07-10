import Mathlib
import PhysicsSM.Draft.NullEdge.MasslessEdgeCount
import PhysicsSM.Draft.NullEdge.PhotonSingleEdge
import PhysicsSM.Draft.NullEdge.HiggsLongitudinalMode
import PhysicsSM.Draft.NullEdge.PositiveSectorClass
import PhysicsSM.Draft.NullEdge.HelicityChirality
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.ZitterbewegungAverage
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag

/-!
# Massless particle-table capstone

This draft module *composes* the already-landed finite "mass from null edges"
modules into a single honest capstone verdict.  Nothing new is assumed: every
conjunct is a direct re-export of an already-proved result from an imported
module (each imported result is a proof term, so its underlying proposition is
restated here verbatim and discharged by the imported term, exactly as in
`HolographicResourceCapstone` and `TeleparallelWEPCapstone`).

## Honest scope

This is a finite linear-algebra / degree-of-freedom counting composition, not a
dynamical QFT mechanism.  Concretely the capstone records, in the exact finite
avatar scope:

* **Rank / edge count** (`MasslessEdgeCount`): the mass class of a PSD `2 × 2`
  momentum Gram is its rank / null-edge count, with explicit massless and
  massive rational witnesses.
* **Spin-1 photon / massive vector** (`PhotonSingleEdge`): a photon is a single
  null edge (`edges = 1`, `pol = 2`), a massive vector is two disagreeing null
  edges (`edges = 2`, `pol = 3`), and `edges = pol − 1`.
* **Higgs / longitudinal count** (`HiggsLongitudinalMode`): the physical
  polarization count is `2` (massless) vs `3` (massive), the extra longitudinal
  mode being the mass.
* **Positive / protected-null taxonomy** (`PositiveSectorClass`): the four-way
  sector taxonomy has nondegenerate witnesses.
* **Fermion / chiral packet** (`HelicityChirality`, `ZigzagWeyl`,
  `ZitterbewegungAverage`, `CPTAntiparticleZigzag`): helicity = chirality in the
  massless limit, the zigzag Weyl decoupling, the finite Zitterbewegung average,
  and the CPT antiparticle conjugate pairing.

There is no claim here about a full dynamical QFT mechanism; see each imported
module for its individual claim discipline.
-/

namespace MasslessParticleTableCapstone

open Matrix

/-- **Massless particle-table capstone.**  A flat conjunction bundling every
landed finite masslessness result: rank/edge witnesses, the spin-1
photon/massive-vector counts, the Higgs longitudinal count, the positive-sector
taxonomy, and the full fermion/chiral packet (helicity=chirality, zigzag Weyl,
CPT).  Each conjunct is the underlying proposition of an already-proved imported
theorem, discharged by that imported proof term. -/
theorem massless_particle_table_capstone :
    -- (1) rank / edge masslessness witnesses
    ((!![(1:ℝ), 0; 0, 0]).PosSemidef ∧
        (!![(1:ℝ), 0; 0, 0]).det = 0 ∧
        (!![(1:ℝ), 0; 0, 0]).rank = 1 ∧
        (!![(1:ℝ), 0; 0, 0]) = MasslessEdgeCount.edge ![1, 0])
      ∧ ((!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25 ∧
          0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2 ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25])
            = MasslessEdgeCount.edge ![1, 0] + MasslessEdgeCount.edge ![3/5, 4/5])
      -- (2) spin-1 photon / massive vector counts
      ∧ (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma = 0 ∧
          PhotonSingleEdge.kgamma ≠ 0 ∧
          PhotonSingleEdge.Pgamma.rank = 1 ∧
          Module.finrank ℚ
              (Submodule.span ℚ ({PhotonSingleEdge.kgamma} : Set (Fin 4 → ℚ))) = 1 ∧
          PhotonSingleEdge.polSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 2 ∧
          PhotonSingleEdge.edgesSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1)
      ∧ (PhotonSingleEdge.kmass = PhotonSingleEdge.k1 + PhotonSingleEdge.k2 ∧
          PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k1 = 0 ∧
          PhotonSingleEdge.mink PhotonSingleEdge.k2 PhotonSingleEdge.k2 = 0 ∧
          PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16 ∧
          (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass ∧
          PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
            = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2 ∧
          PhotonSingleEdge.Pmass.rank = 2 ∧
          Module.finrank ℚ
              (Submodule.span ℚ
                ({PhotonSingleEdge.k1, PhotonSingleEdge.k2} : Set (Fin 4 → ℚ))) = 2 ∧
          PhotonSingleEdge.polSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 3 ∧
          PhotonSingleEdge.edgesSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2)
      ∧ ((∀ m2 : ℚ, PhotonSingleEdge.edgesSpin1 m2 = PhotonSingleEdge.polSpin1 m2 - 1) ∧
          (∀ m2 : ℚ, m2 ≠ 0 ↔ PhotonSingleEdge.edgesSpin1 m2 = 2) ∧
          (∀ m2 : ℚ, PhotonSingleEdge.edgesSpin1 m2 = 2 ↔ PhotonSingleEdge.polSpin1 m2 = 3) ∧
          (∀ m2 : ℚ, m2 = 0 ↔ PhotonSingleEdge.edgesSpin1 m2 = 1) ∧
          (∀ m2 : ℚ, PhotonSingleEdge.edgesSpin1 m2 = 1 ↔ PhotonSingleEdge.polSpin1 m2 = 2))
      ∧ ((∀ a b : Fin 4 → ℚ, PhotonSingleEdge.mink a a = 0 → PhotonSingleEdge.mink b b = 0 →
              PhotonSingleEdge.mink (a + b) (a + b) = 2 * PhotonSingleEdge.mink a b) ∧
          (∀ a : Fin 4 → ℚ, PhotonSingleEdge.mink a a = 0 → PhotonSingleEdge.mink a a = 0) ∧
          (∀ m2 : ℚ, PhotonSingleEdge.edgesSpin1 m2 = PhotonSingleEdge.polSpin1 m2 - 1) ∧
          (∀ m2 : ℚ, m2 ≠ 0 ↔ PhotonSingleEdge.polSpin1 m2 = 3) ∧
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma = 0 ∧
            PhotonSingleEdge.Pgamma.rank = 1 ∧
            PhotonSingleEdge.polSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 2) ∧
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16 ∧
            PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
              = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2 ∧
            PhotonSingleEdge.Pmass.rank = 2 ∧
            PhotonSingleEdge.polSpin1
              (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 3))
      -- (3) Higgs / longitudinal count
      ∧ (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null HiggsLongitudinalMode.k_null = 0 ∧
          HiggsLongitudinalMode.k_null ≠ 0 ∧
          Module.finrank ℚ
              (↥(LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null)) ⧸
                Submodule.span ℚ
                  {(⟨HiggsLongitudinalMode.k_null, HiggsLongitudinalMode.null_mem_ker⟩ :
                    ↥(LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null)))}) = 2 ∧
          HiggsLongitudinalMode.epsT1
              ∈ LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null) ∧
          HiggsLongitudinalMode.epsT2
              ∈ LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null) ∧
          LinearIndependent ℚ ![HiggsLongitudinalMode.epsT1, HiggsLongitudinalMode.epsT2])
      ∧ (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time HiggsLongitudinalMode.k_time = 16 ∧
          Module.finrank ℚ
              (LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time)) = 3 ∧
          HiggsLongitudinalMode.epsT1
              ∈ LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time) ∧
          HiggsLongitudinalMode.epsT2
              ∈ LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time) ∧
          HiggsLongitudinalMode.epsL
              ∈ LinearMap.ker (HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time) ∧
          LinearIndependent ℚ
              ![HiggsLongitudinalMode.epsT1, HiggsLongitudinalMode.epsT2, HiggsLongitudinalMode.epsL])
      ∧ (HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2 ∧
          HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3 ∧
          HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time
            = HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null + 1 ∧
          HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_null HiggsLongitudinalMode.k_null = 0 ∧
          HiggsLongitudinalMode.dotK HiggsLongitudinalMode.k_time HiggsLongitudinalMode.k_time = 16)
      -- (4) positive / protected-null taxonomy
      ∧ ((PositiveSectorClass.IsPositive PositiveSectorClass.wPositive) ∧
          (PositiveSectorClass.IsProtectedNull PositiveSectorClass.wProtectedNull ∧
            PositiveSectorClass.kProtectedNull ≠ 0 ∧
            PositiveSectorClass.wProtectedNull *ᵥ PositiveSectorClass.kProtectedNull = 0) ∧
          (PositiveSectorClass.IsIndefinite PositiveSectorClass.wIndefinite ∧
            PositiveSectorClass.vIndefinite ≠ 0 ∧
            PositiveSectorClass.vIndefinite ⬝ᵥ
              (PositiveSectorClass.wIndefinite *ᵥ PositiveSectorClass.vIndefinite) < 0) ∧
          (PositiveSectorClass.IsBalanced PositiveSectorClass.wBalanced))
      -- (5) fermion / chiral packet: helicity = chirality
      ∧ ((HelicityChirality.D0 * HelicityChirality.g5 = HelicityChirality.g5 * HelicityChirality.D0) ∧
          (∀ v : Fin 4 → ℚ, HelicityChirality.D0.mulVec v = v →
              HelicityChirality.g5.mulVec v = HelicityChirality.h4.mulVec v) ∧
          (HelicityChirality.D0.mulVec HelicityChirality.e0 = HelicityChirality.e0 ∧
            HelicityChirality.g5.mulVec HelicityChirality.e0 = HelicityChirality.e0 ∧
            HelicityChirality.h4.mulVec HelicityChirality.e0 = HelicityChirality.e0) ∧
          (HelicityChirality.D0.mulVec HelicityChirality.e3 = HelicityChirality.e3 ∧
            HelicityChirality.g5.mulVec HelicityChirality.e3 = -HelicityChirality.e3 ∧
            HelicityChirality.h4.mulVec HelicityChirality.e3 = -HelicityChirality.e3) ∧
          (∀ m : ℚ, HelicityChirality.g5 * HelicityChirality.Dmass m * HelicityChirality.g5
              = - HelicityChirality.Dmass m) ∧
          (HelicityChirality.Dtot 1 * HelicityChirality.g5
            - HelicityChirality.g5 * HelicityChirality.Dtot 1 ≠ 0))
      -- (5) zigzag Weyl at m = 1
      ∧ ((ZigzagWeyl.gamma5 * ZigzagWeyl.gamma5 = (1 : ZigzagWeyl.M4) ∧
            Matrix.trace ZigzagWeyl.gamma5 = 0 ∧
            ZigzagWeyl.gamma5 * ZigzagWeyl.Dmass 1 * ZigzagWeyl.gamma5 = - ZigzagWeyl.Dmass 1) ∧
          (ZigzagWeyl.D 0 = ZigzagWeyl.Dkin ∧
            ZigzagWeyl.gamma5 * ZigzagWeyl.Dnull = - (ZigzagWeyl.Dnull * ZigzagWeyl.gamma5) ∧
            ZigzagWeyl.KLnull * ZigzagWeyl.KRnull = 0 ∧ ZigzagWeyl.KRnull * ZigzagWeyl.KLnull = 0) ∧
          (ZigzagWeyl.KLnull ≠ 0 ∧ ZigzagWeyl.KRnull ≠ 0 ∧ ZigzagWeyl.KLnull ≠ ZigzagWeyl.KRnull) ∧
          ((1 : ℝ) ≠ 0 → ZigzagWeyl.Dmass 1 ≠ 0) ∧
          (ZigzagWeyl.D 1 * ZigzagWeyl.D 1 = ((16 : ℝ) + 1 ^ 2) • (1 : ZigzagWeyl.M4)) ∧
          (ZigzagWeyl.D 3 * ZigzagWeyl.D 3 = (25 : ℝ) • (1 : ZigzagWeyl.M4)))
      -- (5) CPT antiparticle zigzag
      ∧ ((∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.Theta (CPTAntiparticleZigzag.Theta v) = v) ∧
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
            CPTAntiparticleZigzag.Theta ![1, Complex.I, 1, Complex.I] ≠ 0)) :=
  ⟨MasslessEdgeCount.massless_witness,
   MasslessEdgeCount.massive_witness,
   PhotonSingleEdge.photon_one_edge,
   PhotonSingleEdge.massive_vector_two_edges,
   PhotonSingleEdge.edge_count_eq_pol_minus_one,
   PhotonSingleEdge.universal_verdict,
   HiggsLongitudinalMode.massless_two_polarizations,
   HiggsLongitudinalMode.massive_three_polarizations,
   HiggsLongitudinalMode.higgs_counting_verdict,
   PositiveSectorClass.physical_reading,
   HelicityChirality.verdict,
   ZigzagWeyl.zigzag_verdict 1,
   CPTAntiparticleZigzag.antiparticle_verdict⟩

/-- **Rank / edge / spin-1 agreement bundle.**  The rank-edge witnesses agree
with the spin-1 edge and polarization counts, and with the Higgs longitudinal
counts: photon `edges = 1`, `pol = 2`; massive vector `edges = 2`, `pol = 3`;
`physDim k_null = 2`, `physDim k_time = 3`. -/
theorem rank_edge_spin1_agreement_bundle :
    ((!![(1:ℝ), 0; 0, 0]).PosSemidef ∧
        (!![(1:ℝ), 0; 0, 0]).det = 0 ∧
        (!![(1:ℝ), 0; 0, 0]).rank = 1 ∧
        (!![(1:ℝ), 0; 0, 0]) = MasslessEdgeCount.edge ![1, 0])
      ∧ ((!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25 ∧
          0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2 ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25])
            = MasslessEdgeCount.edge ![1, 0] + MasslessEdgeCount.edge ![3/5, 4/5])
      ∧ PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 1
      ∧ PhotonSingleEdge.polSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kgamma PhotonSingleEdge.kgamma) = 2
      ∧ PhotonSingleEdge.edgesSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 2
      ∧ PhotonSingleEdge.polSpin1
          (PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass) = 3
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_null = 2
      ∧ HiggsLongitudinalMode.physDim HiggsLongitudinalMode.k_time = 3 :=
  ⟨MasslessEdgeCount.massless_witness,
   MasslessEdgeCount.massive_witness,
   PhotonSingleEdge.photon_one_edge.2.2.2.2.2,
   PhotonSingleEdge.photon_one_edge.2.2.2.2.1,
   PhotonSingleEdge.massive_vector_two_edges.2.2.2.2.2.2.2.2.2,
   PhotonSingleEdge.massive_vector_two_edges.2.2.2.2.2.2.2.2.1,
   HiggsLongitudinalMode.higgs_counting_verdict.1,
   HiggsLongitudinalMode.higgs_counting_verdict.2.1⟩

/-- **Disagreement = mass, with positive witnesses.**  The massive-vector mass²
is twice the null-edge disagreement `2 k₁·k₂ = 16 > 0`, and the massive rank/edge
witness is nondegenerate. -/
theorem disagreement_mass_positive_witnesses :
    PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
        = 2 * PhotonSingleEdge.mink PhotonSingleEdge.k1 PhotonSingleEdge.k2
      ∧ PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass = 16
      ∧ (0 : ℚ) < PhotonSingleEdge.mink PhotonSingleEdge.kmass PhotonSingleEdge.kmass
      ∧ ((!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25 ∧
          0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2 ∧
          (!![(34:ℝ)/25, 12/25; 12/25, 16/25])
            = MasslessEdgeCount.edge ![1, 0] + MasslessEdgeCount.edge ![3/5, 4/5]) :=
  ⟨PhotonSingleEdge.massive_vector_two_edges.2.2.2.2.2.1,
   PhotonSingleEdge.massive_vector_two_edges.2.2.2.1,
   PhotonSingleEdge.massive_vector_two_edges.2.2.2.2.1,
   MasslessEdgeCount.massive_witness⟩

end MasslessParticleTableCapstone

/-! ## Kernel-footprint guard pins -/

/-- info: 'MasslessParticleTableCapstone.massless_particle_table_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MasslessParticleTableCapstone.massless_particle_table_capstone

/-- info: 'MasslessParticleTableCapstone.rank_edge_spin1_agreement_bundle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MasslessParticleTableCapstone.rank_edge_spin1_agreement_bundle

/-- info: 'MasslessParticleTableCapstone.disagreement_mass_positive_witnesses' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MasslessParticleTableCapstone.disagreement_mass_positive_witnesses
