/-
# Photon / Higgs / CPT finite null-edge capstone

This file composes the landed finite null-edge mass-generation modules into one
capstone.  Every claim is a **finite avatar**: momentum arithmetic,
polarization / degree-of-freedom counting, chirality/helicity matrix identities,
the Weyl zigzag, and CPT finite matrix statements.  Nothing here claims a full
dynamical quantum field theory mechanism; the honest scope is momentum-level and
finite-dimensional linear algebra.

The capstone is assembled purely from already-proved statements in:

* `PhotonSingleEdge`          - spin-1 photon / massive-vector edge counting;
* `HiggsLongitudinalMode`     - massless (2) vs. timelike (3) polarizations;
* `HelicityChirality`         - massless helicity = chirality, mass flips it;
* `ZigzagWeyl`                - the Weyl zigzag verdict;
* `ZitterbewegungAverage`     - rational convex-average drift witness;
* `CPTAntiparticleZigzag`     - CPT antiparticle mirror verdict.

All witnesses stay explicit; no new assumptions or placeholder declarations are
introduced.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.PhotonSingleEdge
import PhysicsSM.Draft.NullEdge.HiggsLongitudinalMode
import PhysicsSM.Draft.NullEdge.HelicityChirality
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.ZitterbewegungAverage
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag

open scoped Matrix

namespace PhotonHiggsCPTCapstone

open PhotonSingleEdge HiggsLongitudinalMode HelicityChirality ZigzagWeyl
  ZitterbewegungAverage CPTAntiparticleZigzag

/-- **The finite photon / Higgs / CPT capstone.**

A single conjunction bundling every landed finite null-edge result:

1. the spin-1 **photon** witness (one null edge, rank one, two polarizations);
2. the **massive vector** witness (two null edges, `m^2 =` disagreement `= 16`,
   rank two, three polarizations);
3. the spin-1 arithmetic payload `edges = pol - 1` and the universal null-edge
   disagreement law;
4. the **Higgs / longitudinal** count (2 massless, 3 timelike, the extra
   longitudinal mode as the mass witness);
5. the **helicity = chirality** massless identity with the mass-flip verdict;
6. the **Weyl zigzag** verdict at `m = 1`;
7. the rational **zitterbewegung** convex-average witness on the `(4,3,5)` shell;
8. the **CPT antiparticle** mirror verdict.

Honest scope: finite momentum / DOF counting and finite matrix identities, not a
dynamical field-theory mechanism. -/
theorem photon_higgs_cpt_capstone :
    -- (1) photon: one null edge, rank one, two polarizations
    (mink kgamma kgamma = 0 ∧
      kgamma ≠ 0 ∧
      Pgamma.rank = 1 ∧
      Module.finrank ℚ (Submodule.span ℚ ({kgamma} : Set (Fin 4 → ℚ))) = 1 ∧
      polSpin1 (mink kgamma kgamma) = 2 ∧
      edgesSpin1 (mink kgamma kgamma) = 1) ∧
    -- (2) massive vector: two null edges, mass = disagreement, three polarizations
    (kmass = k1 + k2 ∧
      mink k1 k1 = 0 ∧
      mink k2 k2 = 0 ∧
      mink kmass kmass = 16 ∧
      (0 : ℚ) < mink kmass kmass ∧
      mink kmass kmass = 2 * mink k1 k2 ∧
      Pmass.rank = 2 ∧
      Module.finrank ℚ (Submodule.span ℚ ({k1, k2} : Set (Fin 4 → ℚ))) = 2 ∧
      polSpin1 (mink kmass kmass) = 3 ∧
      edgesSpin1 (mink kmass kmass) = 2) ∧
    -- (3a) spin-1 arithmetic payload: edges = pol - 1
    ((∀ m2 : ℚ, edgesSpin1 m2 = polSpin1 m2 - 1) ∧
      (∀ m2 : ℚ, m2 ≠ 0 ↔ edgesSpin1 m2 = 2) ∧
      (∀ m2 : ℚ, edgesSpin1 m2 = 2 ↔ polSpin1 m2 = 3) ∧
      (∀ m2 : ℚ, m2 = 0 ↔ edgesSpin1 m2 = 1) ∧
      (∀ m2 : ℚ, edgesSpin1 m2 = 1 ↔ polSpin1 m2 = 2)) ∧
    -- (3b) universal null-edge disagreement verdict
    ((∀ a b : Fin 4 → ℚ, mink a a = 0 → mink b b = 0 →
        mink (a + b) (a + b) = 2 * mink a b) ∧
      (∀ a : Fin 4 → ℚ, mink a a = 0 → mink a a = 0) ∧
      (∀ m2 : ℚ, edgesSpin1 m2 = polSpin1 m2 - 1) ∧
      (∀ m2 : ℚ, m2 ≠ 0 ↔ polSpin1 m2 = 3) ∧
      (mink kgamma kgamma = 0 ∧ Pgamma.rank = 1 ∧
        polSpin1 (mink kgamma kgamma) = 2) ∧
      (mink kmass kmass = 16 ∧ mink kmass kmass = 2 * mink k1 k2 ∧
        Pmass.rank = 2 ∧ polSpin1 (mink kmass kmass) = 3)) ∧
    -- (4a) Higgs / longitudinal: massless has two physical polarizations
    (dotK k_null k_null = 0 ∧ k_null ≠ 0 ∧
      Module.finrank ℚ (↥(LinearMap.ker (dotK k_null)) ⧸
        Submodule.span ℚ {(⟨k_null, null_mem_ker⟩ :
          ↥(LinearMap.ker (dotK k_null)))}) = 2 ∧
      epsT1 ∈ LinearMap.ker (dotK k_null) ∧ epsT2 ∈ LinearMap.ker (dotK k_null) ∧
      LinearIndependent ℚ ![epsT1, epsT2]) ∧
    -- (4b) Higgs / longitudinal: timelike has three physical polarizations
    (dotK k_time k_time = 16 ∧
      Module.finrank ℚ (LinearMap.ker (dotK k_time)) = 3 ∧
      epsT1 ∈ LinearMap.ker (dotK k_time) ∧ epsT2 ∈ LinearMap.ker (dotK k_time) ∧
      epsL ∈ LinearMap.ker (dotK k_time) ∧
      LinearIndependent ℚ ![epsT1, epsT2, epsL]) ∧
    -- (4c) Higgs counting verdict: the longitudinal mode is the mass count
    (physDim k_null = 2 ∧ physDim k_time = 3 ∧
      physDim k_time = physDim k_null + 1 ∧
      dotK k_null k_null = 0 ∧ dotK k_time k_time = 16) ∧
    -- (5) helicity = chirality massless verdict, mass flips chirality
    ((D0 * g5 = g5 * D0) ∧
      (∀ v : Fin 4 → ℚ, D0.mulVec v = v → g5.mulVec v = h4.mulVec v) ∧
      (D0.mulVec e0 = e0 ∧ g5.mulVec e0 = e0 ∧ h4.mulVec e0 = e0) ∧
      (D0.mulVec e3 = e3 ∧ g5.mulVec e3 = -e3 ∧ h4.mulVec e3 = -e3) ∧
      (∀ m : ℚ, g5 * HelicityChirality.Dmass m * g5 = - HelicityChirality.Dmass m) ∧
      (Dtot 1 * g5 - g5 * Dtot 1 ≠ 0)) ∧
    -- (6) Weyl zigzag verdict at m = 1
    ((ZigzagWeyl.gamma5 * ZigzagWeyl.gamma5 = (1 : M4) ∧
        Matrix.trace ZigzagWeyl.gamma5 = 0 ∧
        ZigzagWeyl.gamma5 * ZigzagWeyl.Dmass 1 * ZigzagWeyl.gamma5
          = - ZigzagWeyl.Dmass 1) ∧
      (D 0 = Dkin ∧ ZigzagWeyl.gamma5 * Dnull = - (Dnull * ZigzagWeyl.gamma5) ∧
        KLnull * KRnull = 0 ∧ KRnull * KLnull = 0) ∧
      (KLnull ≠ 0 ∧ KRnull ≠ 0 ∧ KLnull ≠ KRnull) ∧
      ((1 : ℝ) ≠ 0 → ZigzagWeyl.Dmass 1 ≠ 0) ∧
      (D 1 * D 1 = (16 + (1 : ℝ) ^ 2) • (1 : M4)) ∧
      (D 3 * D 3 = (25 : ℝ) • (1 : M4))) ∧
    -- (7) rational zitterbewegung convex-average witness on the (4,3,5) shell
    ((wPlus 4 5 + wMinus 4 5 = 1) ∧
      (0 ≤ wPlus 4 5 ∧ wPlus 4 5 ≤ 1) ∧ (0 ≤ wMinus 4 5 ∧ wMinus 4 5 ≤ 1) ∧
      meanVelocity 4 5 = 4 / 5 ∧
      (meanVelocity 4 5) ^ 2 = 1 - (3 : ℚ) ^ 2 / 5 ^ 2) ∧
    -- (8) CPT antiparticle mirror verdict
    ((∀ v : Fin 4 → ℂ, Theta (Theta v) = v) ∧
      (∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.gamma5.mulVec (Theta v)
          = - Theta (CPTAntiparticleZigzag.gamma5.mulVec v)) ∧
      (∀ (m : ℝ) (v : Fin 4 → ℂ),
          Theta ((Dmat (m : ℂ)).mulVec (Theta v)) = (Dmat (m : ℂ)).mulVec v) ∧
      (∀ (m : ℝ) (lam : ℂ) (v : Fin 4 → ℂ), v ≠ 0 →
          (Dmat (m : ℂ)).mulVec v = lam • v →
          (Dmat (m : ℂ)).mulVec (Theta v) = (starRingEnd ℂ lam) • Theta v ∧
            Theta v ≠ 0) ∧
      ((Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
          = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
        Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] ∧
        (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
        Theta ![1, Complex.I, 1, Complex.I] ≠ 0)) := by
  exact ⟨PhotonSingleEdge.photon_one_edge,
    PhotonSingleEdge.massive_vector_two_edges,
    PhotonSingleEdge.edge_count_eq_pol_minus_one,
    PhotonSingleEdge.universal_verdict,
    HiggsLongitudinalMode.massless_two_polarizations,
    HiggsLongitudinalMode.massive_three_polarizations,
    HiggsLongitudinalMode.higgs_counting_verdict,
    HelicityChirality.verdict,
    ZigzagWeyl.zigzag_verdict 1,
    ZitterbewegungAverage.zitterbewegung_verdict 4 5 3 (by norm_num) (by norm_num)
      (by norm_num),
    CPTAntiparticleZigzag.antiparticle_verdict⟩

/-- **Spin-1 edge count aligned with the Higgs longitudinal count.**  The photon
carries one null edge and two polarizations; the massive vector carries two null
edges and three polarizations; and the Higgs longitudinal count agrees: the
timelike physical dimension (`3`) is exactly the massless one (`2`) plus the extra
eaten / longitudinal mode. -/
theorem spin1_edge_longitudinal_agreement :
    edgesSpin1 (mink kgamma kgamma) = 1 ∧
      polSpin1 (mink kgamma kgamma) = 2 ∧
      edgesSpin1 (mink kmass kmass) = 2 ∧
      polSpin1 (mink kmass kmass) = 3 ∧
      physDim k_null = 2 ∧
      physDim k_time = 3 ∧
      physDim k_time = physDim k_null + 1 := by
  obtain ⟨_, _, _, _, hp2, he1⟩ := PhotonSingleEdge.photon_one_edge
  obtain ⟨_, _, _, _, _, _, _, _, hp3, he2⟩ := PhotonSingleEdge.massive_vector_two_edges
  obtain ⟨hn, ht, hnt, _, _⟩ := HiggsLongitudinalMode.higgs_counting_verdict
  exact ⟨he1, hp2, he2, hp3, hn, ht, hnt⟩

/-- **Mass from null-edge disagreement, together with the CPT antiparticle
symmetry.**  The timelike mass-squared `m^2 = 16 = 2 k1 * k2` is exactly the
disagreement of the two null edges and is strictly positive, and the same
carrier's spectrum is CPT conjugate-paired. -/
theorem mass_from_disagreement_with_cpt_symmetry :
    mink kmass kmass = 2 * mink k1 k2 ∧
      mink kmass kmass = 16 ∧
      (0 : ℚ) < mink kmass kmass ∧
      ((∀ v : Fin 4 → ℂ, Theta (Theta v) = v) ∧
        (∀ v : Fin 4 → ℂ, CPTAntiparticleZigzag.gamma5.mulVec (Theta v)
            = - Theta (CPTAntiparticleZigzag.gamma5.mulVec v)) ∧
        (∀ (m : ℝ) (v : Fin 4 → ℂ),
            Theta ((Dmat (m : ℂ)).mulVec (Theta v)) = (Dmat (m : ℂ)).mulVec v) ∧
        (∀ (m : ℝ) (lam : ℂ) (v : Fin 4 → ℂ), v ≠ 0 →
            (Dmat (m : ℂ)).mulVec v = lam • v →
            (Dmat (m : ℂ)).mulVec (Theta v) = (starRingEnd ℂ lam) • Theta v ∧
              Theta v ≠ 0) ∧
        ((Dmat 1).mulVec ![1, Complex.I, 1, Complex.I]
            = (1 + Complex.I) • ![1, Complex.I, 1, Complex.I] ∧
          Theta ![1, Complex.I, 1, Complex.I] = ![1, -Complex.I, 1, -Complex.I] ∧
          (![1, Complex.I, 1, Complex.I] : Fin 4 → ℂ) ≠ 0 ∧
          Theta ![1, Complex.I, 1, Complex.I] ≠ 0)) := by
  obtain ⟨_, _, _, h16, hpos, hdis, _⟩ := PhotonSingleEdge.massive_vector_two_edges
  exact ⟨hdis, h16, hpos, CPTAntiparticleZigzag.antiparticle_verdict⟩

/-! ## Dependency-footprint guards

Every headline of the capstone depends on exactly the standard finite axiom set
`[propext, Classical.choice, Quot.sound]`; no extra axioms or s o r r y-style
handoff markers are introduced. -/

/-- info: 'PhotonHiggsCPTCapstone.photon_higgs_cpt_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms photon_higgs_cpt_capstone

/-- info: 'PhotonHiggsCPTCapstone.spin1_edge_longitudinal_agreement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spin1_edge_longitudinal_agreement

/-- info: 'PhotonHiggsCPTCapstone.mass_from_disagreement_with_cpt_symmetry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_from_disagreement_with_cpt_symmetry

end PhotonHiggsCPTCapstone
