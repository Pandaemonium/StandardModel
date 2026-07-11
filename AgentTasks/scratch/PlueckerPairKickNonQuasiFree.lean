import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction
import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree

theorem witnessPairKick_not_secondQuantization :
    ¬ ∃ U : Matrix (Fin 4) (Fin 4) Complex,
      ∀ psi, PlueckerQuarticInteraction.pairKick
        PlueckerQuarticInteraction.witnessUnitPhase psi =
          FiniteCARSecondQuantization.Gamma U psi := by
  rintro ⟨U, hUall⟩
  have hU : U = 1 := by
    ext j k
    have h := congrFun
      (hUall (PlueckerQuarticInteraction.basisVec {k})) {j}
    rw [PlueckerQuarticInteraction.pairKick_singleton] at h
    change FiniteCARSecondQuantization.basisVec {k} {j} =
      FiniteCARSecondQuantization.Gamma U
        (FiniteCARSecondQuantization.basisVec {k}) {j} at h
    rw [FiniteCARSecondQuantization.Gamma_apply_singleton] at h
    simpa [FiniteCARSecondQuantization.basisVec, Matrix.one_apply] using h.symm
  have hpair := hUall
    (PlueckerQuarticInteraction.basisVec PlueckerQuarticInteraction.highPair)
  rw [hU, FiniteCARSecondQuantization.Gamma_one] at hpair
  exact PlueckerQuarticInteraction.witnessPairKick_two_particle_nontrivial hpair

end PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree
