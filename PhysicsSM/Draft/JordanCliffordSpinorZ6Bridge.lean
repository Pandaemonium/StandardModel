import PhysicsSM.Draft.JordanCliffordFermionKernel
import PhysicsSM.StandardModel.SpinorFockHypercharge
import PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage

/-!
# Five-mode spinor hypercharge and the finite cover kernel

This module composes the five-mode exterior/Fock hypercharge convention with
the finite central-phase arithmetic used by `JordanCliffordFermionKernel`.
It proves the equality `6Y = 3 N_W - 2 N_V` on every five-mode occupation
state and transfers it to the trusted one-generation multiplet table on the
even sector. It also records, without conflating underlying types or actions,
that the finite bidegree kernel and the trusted gauge covering kernel both have
six elements.

Scope: these are finite occupation-number and cardinality statements. They do
not identify the two kernel types, construct a Lie-group action, derive the
weak/color split from a Jordan flag, or prove Furey/exterior equivariance.

Provenance: proofs synthesized by Aristotle project
`14528672-95da-4707-9ef2-d814a587c9ce` and independently reviewed and compiled
against the pinned repository toolchain on 2026-07-11. The proof uses kernel
evaluation only, not compiled evaluation.
-/

namespace PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge

open PhysicsSM.Draft.JordanCliffordFermionKernel
open PhysicsSM.StandardModel.SpinorFockHypercharge
open PhysicsSM.Gauge.StandardModelSubgroup

/-- The five-mode Fock hypercharge is exactly `3 N_W - 2 N_V`, represented as
the primitive `U(1)` term in the finite center phase. -/
theorem fockHypercharge6_eq_centralPhase (S : Finset (Fin 5)) :
    fockHypercharge6 S =
      centralPhase 0 0 1 (weakCount S) (colorCount S) := by
  revert S
  decide

/-- On every even Fock state, the trusted Standard Model multiplet table and
the finite center phase carry the same integral hypercharge. -/
theorem spinorTableHypercharge6_eq_centralPhase
    (S : Finset (Fin 5)) (hS : S.card % 2 = 0) :
    multipletHypercharge6 (toMultiplet S) =
      centralPhase 0 0 1 (weakCount S) (colorCount S) := by
  exact (hypercharge6_matches S hS).trans (fockHypercharge6_eq_centralPhase S)

/-- Central cover labels whose phase is trivial on every actual even
five-mode Fock occupation. Unlike `fermionCentralKernel`, this definition does
not enumerate bidegrees by hand. -/
def evenFockCentralKernel : Finset (Fin 3 × Fin 2 × Fin 6) :=
  Finset.univ.filter (fun t =>
    forall S : Finset (Fin 5), S.card % 2 = 0 ->
      centralPhase t.1.val t.2.1.val t.2.2.val
        (weakCount S) (colorCount S) % 6 = 0)

set_option maxHeartbeats 2000000 in
/-- Quantifying over every even five-mode occupation gives exactly the same
finite phase kernel as the six explicit weak/color bidegrees. This closes the
finite occupation-to-bidegree bridge; it is still not a Lie-group action
kernel theorem. -/
theorem evenFockCentralKernel_eq_fermionCentralKernel :
    evenFockCentralKernel = fermionCentralKernel := by
  decide

/-- Therefore the phase-trivial labels on all actual even occupations are
exactly the six standard powers. -/
theorem evenFockCentralKernel_eq_standardPowers :
    evenFockCentralKernel = Finset.univ.image standardKernelPower := by
  rw [evenFockCentralKernel_eq_fermionCentralKernel,
    fermionCentralKernel_eq_standardPowers]

/-- Mixed near-miss control: the correct primitive `U(1)` power and `SU(3)`
center without the compensating `SU(2)` center does not act trivially on all
even occupations. -/
theorem mixed_missing_su2_control_not_mem :
    ((1 : Fin 3), (0 : Fin 2), (1 : Fin 6)) ∉ evenFockCentralKernel := by
  decide

/-- Every finite label trivial on all even occupations has a unique
standard-power index. The trusted family element at that index has identity
covering image, a uniform property of the full family rather than the source of
uniqueness. This links the finite labels to the trusted covering family without
identifying kernel types or claiming a complete representation kernel. -/
theorem evenFockKernel_unique_unitCovering_witness
    (t : Fin 3 × Fin 2 × Fin 6) (ht : t ∈ evenFockCentralKernel) :
    ExistsUnique (fun m : Fin 6 =>
      t = standardKernelPower m ∧
        unitCoveringTripleImageGroupHom
          ((sixUnitCoveringKernelElts m).toUnitCoveringTriple) = 1) := by
  have ht' : t ∈ Finset.univ.image standardKernelPower := by
    rw [← evenFockCentralKernel_eq_standardPowers]
    exact ht
  obtain ⟨m, _, hm⟩ := Finset.mem_image.mp ht'
  refine ⟨m, ⟨hm.symm, unitKernelFamily_maps_to_one m⟩, ?_⟩
  intro n hn
  exact (standardKernelPower_injective (hm.trans hn.1)).symm

/-- Alignment without type conflation: both the fermion bidegree kernel and
the trusted gauge covering kernel have six elements. This does not identify
their underlying types or actions. -/
theorem z6_kernel_cardinality_alignment :
    fermionCentralKernel.card = 6 /\
      Fintype.card CoveringKernelElt = 6 :=
  ⟨fermionCentralKernel_card, coveringKernelElt_card⟩

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.fockHypercharge6_eq_centralPhase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fockHypercharge6_eq_centralPhase

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.spinorTableHypercharge6_eq_centralPhase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spinorTableHypercharge6_eq_centralPhase

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.evenFockCentralKernel_eq_fermionCentralKernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evenFockCentralKernel_eq_fermionCentralKernel

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.evenFockCentralKernel_eq_standardPowers' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evenFockCentralKernel_eq_standardPowers

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.mixed_missing_su2_control_not_mem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixed_missing_su2_control_not_mem

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.evenFockKernel_unique_unitCovering_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evenFockKernel_unique_unitCovering_witness

/-- info: 'PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge.z6_kernel_cardinality_alignment' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms z6_kernel_cardinality_alignment

end PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge
