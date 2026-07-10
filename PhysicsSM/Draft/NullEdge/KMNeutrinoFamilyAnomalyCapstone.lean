import Mathlib
import PhysicsSM.Draft.NullEdge.KMC3FlagshipCapstone
import PhysicsSM.Draft.NullEdge.NeutrinoCPSeesawBridge
import PhysicsSM.Draft.NullEdge.NeutrinoMassMechanismCapstone
import PhysicsSM.Draft.NullEdge.KMFamilyRankBridge
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge

open scoped BigOperators F4Winding ComplexOrder
open Module Matrix

/-!
# Goal II / neutrino family-anomaly master capstone

This file composes, into one auditable theorem surface, the four already-landed
finite packets of the Goal II / neutrino programme:

* the finite Kobayashi–Maskawa CP phase-counting witness
  (`KMC3FlagshipCapstone.km_c3_flagship_capstone`, itself bundling the explicit
  KM/CP witness, the family-rank bridge, and the C3 winding/index anomaly
  packet), and
* the finite neutrino mass-mechanism verdict
  (`NeutrinoMassMechanismCapstone.neutrino_mass_mechanism_verdict`, bundling the
  Dirac/Majorana branch, the type-I seesaw inequalities, and the Schur-complement
  seesaw suppression payload).

Everything below is a thin re-export / bundling of already-proved theorems from
the imported modules; no new mathematical content and no new assumptions are
introduced.  The explicit nondegenerate witnesses are preserved verbatim:
`FiniteKM.physicalPhases 2 = 0`, `FiniteKM.physicalPhases 3 = 1`, the exact
nonzero rational Jarlskog witness `6912 / 78125`, the C3 nondegenerate
index/anomaly witness at `N = 3`, `w = 1`, the `N = 2`, `w = 0` control, and the
Schur/type-I seesaw suppression payload.

## Results

* `cp_rank_anomaly_packet` — over any field `K`, for `1 ≤ N` and winding `w`,
  the finite KM/CP witness packet, the family-rank bridge packet, and the C3
  index/anomaly packet (re-export of `km_c3_flagship_capstone`).
* `neutrino_mass_packet` — the Dirac/Majorana branch, type-I seesaw
  inequalities, and Schur-complement seesaw suppression payload (re-export of
  `neutrino_mass_mechanism_verdict`).
* `km_neutrino_family_anomaly_capstone` — the conjunction of the two above, over
  any field `K`, for every `1 ≤ N` and winding `w`.

## Finite claim boundary

This is finite arithmetic and finite-dimensional rank-nullity bookkeeping only.
Every "index" is `dim ker − dim coker` for a linear map between
finite-dimensional vector spaces; every "seesaw" bound is a finite real
inequality or a finite Schur-complement estimate.  There is no Fredholm theory,
Atiyah–Singer index theorem, spectral flow, heat-kernel/eta invariant,
continuum-anomaly claim, physical PMNS fit, or measured neutrino mass anywhere
in the mesh.
-/

namespace KMNeutrinoFamilyAnomalyCapstone

/-- **CP / rank / anomaly packet.**  Over any field `K`, for `1 ≤ N` and winding
`w`, this re-exports `KMC3FlagshipCapstone.km_c3_flagship_capstone`: the explicit
KM/CP witness packet (`physicalPhases 2 = 0`, `physicalPhases 3 = 1`, the unitary
`3-4-5` witness with exact Jarlskog `6912 / 78125` and nonzero Jarlskog), the
family-rank bridge packet, and the C3 winding/index anomaly packet with its
explicit nondegenerate (`N = 3`, `w = 1`) and control (`N = 2`, `w = 0`)
witnesses. -/
theorem cp_rank_anomaly_packet (K : Type*) [Field K] (N w : Nat) (hN : 1 ≤ N) :
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
  KMC3FlagshipCapstone.km_c3_flagship_capstone K N w hN

/-- **Neutrino mass-mechanism packet.**  Re-exports
`NeutrinoMassMechanismCapstone.neutrino_mass_mechanism_verdict`: the
Dirac/Majorana branch verdict, the finite type-I seesaw inequalities (general
suppression, strong-hierarchy nondegenerate witness, no-hierarchy control), and
the Schur-complement seesaw suppression bound with its zero-overlap protection
criterion. -/
theorem neutrino_mass_packet :
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
        (_hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      (star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = 0 ↔ Bᴴ *ᵥ v = 0))) :=
  NeutrinoMassMechanismCapstone.neutrino_mass_mechanism_verdict

/-- **KM / neutrino family-anomaly master capstone.**  The finite CP
phase-counting / family-rank / C3 winding-index anomaly packet
(`cp_rank_anomaly_packet`) and the finite neutrino mass-mechanism packet
(`neutrino_mass_packet`) hold simultaneously, over any field `K`, for every
`1 ≤ N` and winding `w`.  Scope: finite structural bridge only — no continuum
anomaly, no physical PMNS fit, no measured neutrino mass. -/
theorem km_neutrino_family_anomaly_capstone (K : Type*) [Field K] (N w : Nat) (hN : 1 ≤ N) :
    ((FiniteKM.physicalPhases 2 = 0
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
              ∧ w ≤ Module.finrank ℂ (LinearMap.ker (F4Winding.windingDirac N w)))))
    ∧
    (((NeutrinoDiracMajorana.Theta NeutrinoDiracMajorana.psiP ≠ NeutrinoDiracMajorana.psiP ∧
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
        (_hM : M.PosDef) (v : nv → ℂ), A *ᵥ v = 0 →
      (star v ⬝ᵥ (A - B * M⁻¹ * Bᴴ) *ᵥ v = 0 ↔ Bᴴ *ᵥ v = 0)))) :=
  ⟨cp_rank_anomaly_packet K N w hN, neutrino_mass_packet⟩

/-! ## Kernel-footprint guard pins

Each headline theorem is kernel-checked and depends only on the standard
Lean/Mathlib logical basis `propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'KMNeutrinoFamilyAnomalyCapstone.cp_rank_anomaly_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cp_rank_anomaly_packet

/-- info: 'KMNeutrinoFamilyAnomalyCapstone.neutrino_mass_packet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms neutrino_mass_packet

/-- info: 'KMNeutrinoFamilyAnomalyCapstone.km_neutrino_family_anomaly_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms km_neutrino_family_anomaly_capstone

end KMNeutrinoFamilyAnomalyCapstone
