import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferSpectrum
import PhysicsSM.Draft.NullEdge.GateYM.FiniteGapAssembly

/-!
# Gate YM: two-state finite-gap witness adapter

This draft module connects the tiny two-state transfer-spectrum payload from
`TwoStateTransferSpectrum` to the abstract `FiniteGapSpectralWitness` API.

The construction is deliberately a toy descriptor bridge:

* the state space is `Fin 2 -> C`;
* the local algebra is the full endomorphism algebra;
* the sector is the whole two-state space;
* cyclicity is proved by an explicit rank-one endomorphism that sends the
  vacuum vector `(1,1)` to any target vector;
* the transfer operator is the `Matrix.mulVecLin` wrapper around
  `Descriptor.matrix`.

This makes the witness interface non-vacuous on a tiny finite model, but it
does **not** construct the full Wilson slab transfer operator, Gauss projection,
physical sector, Hamiltonian, infinite-volume state, or physical mass-gap
theorem.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: finite identity / descriptor bridge.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TwoStateTransferSpectrum

open CyclicityPrereq
open FiniteGapAssembly

/-- The concrete two-state vector space used by the descriptor bridge. -/
abbrev State : Type :=
  Fin 2 -> ℂ

/-- Rank-one endomorphism sending the two-state vacuum vector to `v`.

It evaluates a vector at coordinate `0` and uses that scalar to scale `v`.
Since `vacuumVec 0 = 1`, this map sends `vacuumVec` exactly to `v`. -/
def rankOneFromVacuum (v : State) : Module.End ℂ State where
  toFun := fun w => w 0 • v
  map_add' := by
    intro x y
    ext i
    simp
    ring
  map_smul' := by
    intro c x
    ext i
    simp
    ring

/-- The rank-one map sends the vacuum vector to the prescribed target. -/
theorem rankOneFromVacuum_vacuum (v : State) :
    rankOneFromVacuum v vacuumVec = v := by
  ext i
  simp [rankOneFromVacuum, vacuumVec]

/-- With the full endomorphism algebra and the whole two-state sector, the
vacuum vector is cyclic. This is a tiny finite testbed for the Q9 cyclicity
field, not a physical local-algebra theorem. -/
theorem topLocalAlgebraCyclic :
    LocalAlgebraCyclicInSector
      (⊤ : Subalgebra ℂ (Module.End ℂ State))
      vacuumVec
      (⊤ : Submodule ℂ State) := by
  refine le_antisymm le_top ?_
  intro v _hv
  refine Submodule.subset_span ?_
  exact ⟨⟨rankOneFromVacuum v, by simp⟩, by
    simpa using rankOneFromVacuum_vacuum v⟩

/-- The complete cyclicity prerequisite for the tiny two-state descriptor
bridge: full endomorphism algebra, whole-space sector, and vacuum `(1,1)`. -/
def topCyclicityPrereq : LocalCyclicityPrereq State where
  localAlgebra := ⊤
  vacuum := vacuumVec
  sector := ⊤
  vacuum_mem := by trivial
  local_preserves_sector := by
    intro _T _v _hv
    trivial
  cyclic := topLocalAlgebraCyclic

namespace Descriptor

/-- The descriptor matrix as a linear endomorphism of `Fin 2 -> C`. -/
def transferEnd (D : Descriptor) : Module.End ℂ State :=
  D.matrix.mulVecLin

/-- The descriptor transfer endomorphism has the vacuum eigenvector with the
named leading eigenvalue. -/
theorem transferEnd_vacuum (D : Descriptor) :
    D.transferEnd vacuumVec =
      ((D.vacuumEigenvalue : ℝ) : ℂ) • vacuumVec := by
  simpa [transferEnd, Matrix.mulVecLin_apply] using D.matrix_mulVec_vacuum

/-- The descriptor transfer endomorphism has the local/flux eigenvector with
the named local eigenvalue. -/
theorem transferEnd_local (D : Descriptor) :
    D.transferEnd localVec =
      ((D.localEigenvalue : ℝ) : ℂ) • localVec := by
  simpa [transferEnd, Matrix.mulVecLin_apply] using D.matrix_mulVec_local

/-- The finite-gap prerequisite package induced by a positive two-state
descriptor. The cyclicity/sector fields are the explicit toy fields from
`topCyclicityPrereq`; the spectral fields are the descriptor eigenvalue
branches. -/
def finiteGapPrereq (D : Descriptor) :
    FiniteGapPrereq State where
  cyclicity := topCyclicityPrereq
  lambda0 := D.vacuumEigenvalue
  lambdaLocal := D.localEigenvalue
  lambda0_pos := D.vacuumEigenvalue_pos
  lambdaLocal_pos := D.localEigenvalue_pos
  lambdaLocal_lt_lambda0 := D.localEigenvalue_lt_vacuumEigenvalue

/-- The tiny two-state finite-gap spectral witness.

This is the first concrete consumer of `FiniteGapSpectralWitness`: it proves
that the abstract witness interface can be filled by an explicit finite
transfer endomorphism and eigenvector equations. It remains a toy whole-sector
bridge, not a Wilson slab construction. -/
def spectralWitness (D : Descriptor) :
    FiniteGapSpectralWitness State where
  prereq := D.finiteGapPrereq
  transfer := D.transferEnd
  transfer_preserves_sector := by
    intro _v _hv
    trivial
  vacuum_ne_zero := by
    simpa [finiteGapPrereq, topCyclicityPrereq] using vacuumVec_ne_zero
  vacuum_eigen := by
    change D.transferEnd vacuumVec =
      ((D.vacuumEigenvalue : ℝ) : ℂ) • vacuumVec
    exact D.transferEnd_vacuum
  localExcitation := localVec
  localExcitation_mem_sector := by
    trivial
  localExcitation_ne_zero := localVec_ne_zero
  localExcitation_ne_vacuum := by
    simpa [finiteGapPrereq, topCyclicityPrereq] using localVec_ne_vacuumVec
  localExcitation_eigen := by
    change D.transferEnd localVec =
      ((D.localEigenvalue : ℝ) : ℂ) • localVec
    exact D.transferEnd_local

/-- The spectral witness exposes the descriptor's positive finite gap. -/
theorem spectralWitness_gap_pos (D : Descriptor) :
    0 < D.spectralWitness.localGap := by
  exact D.spectralWitness.localGap_pos

/-- The spectral witness contraction factor is the descriptor contraction
factor. -/
theorem spectralWitness_exp_neg_gap_eq_contractionFactor (D : Descriptor) :
    Real.exp (-D.spectralWitness.localGap) = D.contractionFactor := by
  simpa [spectralWitness, finiteGapPrereq, FiniteGapPrereq.localSpectralRatio,
    contractionFactor] using
    D.spectralWitness.exp_neg_localGap_eq_lambdaLocal_div_lambda0

end Descriptor

end TwoStateTransferSpectrum
end GateYM
end NullEdge
end Draft
end PhysicsSM
