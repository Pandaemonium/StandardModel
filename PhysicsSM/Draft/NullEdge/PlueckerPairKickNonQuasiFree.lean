import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction
import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization

/-!
# The Pluecker pair kick is not a one-particle exterior lift

The phase-sensitive pair kick fixes every one-particle occupation-basis state
but changes an explicit two-particle state. This module proves that no
one-particle matrix has determinant-minor second quantization equal to that
kick on the full finite Fock space.

The argument is exact. Agreement on all singleton states forces the
one-particle matrix to be the identity; `Gamma_one` would then fix every Fock
state, contradicting the nontrivial pair witness. Thus the interaction is not
the number-preserving determinant-minor exterior lift of any one-particle
matrix.

This statement does not exclude number-nonconserving Bogoliubov
transformations, affine fermionic maps, or general Gaussian channels. The
unqualified phrase "not quasi-free" would therefore be broader than the Lean
theorem.

This does not prove spacetime locality, derive a continuum quartic vertex, or
compute a scattering cross section. It separates the landed Pluecker pair
operation from every free one-particle exterior lift.

Provenance: theorem designed and proved locally from the kernel-checked
`pairKick_singleton`, `witnessPairKick_two_particle_nontrivial`,
`Gamma_apply_singleton`, and `Gamma_one` APIs. Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree

/-- No one-particle matrix has exterior lift equal to the explicit
Pluecker-phase pair kick on the full finite Fock space. -/
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

/-- Scope-explicit publication alias: the kick is not the determinant-minor
exterior lift of any one-particle matrix. -/
theorem witnessPairKick_not_oneParticleExteriorLift :
    ¬ ∃ U : Matrix (Fin 4) (Fin 4) Complex,
      ∀ psi, PlueckerQuarticInteraction.pairKick
        PlueckerQuarticInteraction.witnessUnitPhase psi =
          FiniteCARSecondQuantization.Gamma U psi :=
  witnessPairKick_not_secondQuantization

/-- Compatibility capstone: the kick is invisible on the one-particle basis,
nontrivial on the displayed pair, and not a `Gamma(U)` lift. The historical
declaration name is not a claim about general Bogoliubov or Gaussian maps. -/
theorem witnessPairKick_nonQuasiFree_boundary :
    (∀ i : Fin 4,
      PlueckerQuarticInteraction.pairKick
        PlueckerQuarticInteraction.witnessUnitPhase
          (PlueckerQuarticInteraction.basisVec {i}) =
            PlueckerQuarticInteraction.basisVec {i}) ∧
    PlueckerQuarticInteraction.pairKick
      PlueckerQuarticInteraction.witnessUnitPhase
        (PlueckerQuarticInteraction.basisVec
          PlueckerQuarticInteraction.highPair) ≠
            PlueckerQuarticInteraction.basisVec
              PlueckerQuarticInteraction.highPair ∧
    ¬ ∃ U : Matrix (Fin 4) (Fin 4) Complex,
      ∀ psi, PlueckerQuarticInteraction.pairKick
        PlueckerQuarticInteraction.witnessUnitPhase psi =
          FiniteCARSecondQuantization.Gamma U psi := by
  exact ⟨PlueckerQuarticInteraction.pairKick_singleton _,
    PlueckerQuarticInteraction.witnessPairKick_two_particle_nontrivial,
    witnessPairKick_not_secondQuantization⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree.witnessPairKick_not_secondQuantization' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_not_secondQuantization

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree.witnessPairKick_not_oneParticleExteriorLift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_not_oneParticleExteriorLift

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree.witnessPairKick_nonQuasiFree_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witnessPairKick_nonQuasiFree_boundary

end PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree
