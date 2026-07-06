import PhysicsSM.Draft.NullEdge.GateYM.WilsonSlabConnected
import PhysicsSM.Draft.NullEdge.GateYM.SlabTransferGap
import PhysicsSM.Draft.NullEdge.GateYM.SlabSignRepGap
import PhysicsSM.Draft.NullEdge.GateYM.SlabCenterWitness
import PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction
import PhysicsSM.Draft.NullEdge.GateYM.SummableDefectGap
import PhysicsSM.Draft.NullEdge.GateYM.AreaLawTransport
import PhysicsSM.Draft.NullEdge.GateYM.CMProjectorOS
import PhysicsSM.Draft.NullEdge.GateYM.LocalCyclicitySector
import PhysicsSM.Draft.NullEdge.GateYM.SlabGapAssembly
import PhysicsSM.Draft.NullEdge.GateYM.SlabClustering
import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw
import PhysicsSM.Draft.NullEdge.GateYM.CharacterExpansion

/-!
# SlabAxiomGuard: build-enforced axiom-footprint guard for the lane-C (closure/YM)
gap chain

Applies the `NullStrand.Audit.CapstoneAxioms` pattern (the repo's build-enforced
"no hidden assumptions" trust idea) to the closure-mass / Yang-Mills gap-chain
flagships added in the overnight all-mass run (2026-07-06). This is the lane-C
counterpart of `GateYM/AxiomGuard.lean` (the original spine): it pins the
connected-slab RP -> transfer gap -> OS reconstruction -> defect/area-law
transport chain (the finite Osterwalder-Seiler-regime pieces, several motivated by
Faizal-Shabir arXiv:2606.19362).

Each `#guard_msgs in #print axioms ...` block FAILS TO BUILD if the audited
theorem's transitive axiom surface changes - a leaked `s o r r y`, an introduced
`n a t i v e _ d e c i d e` (`Lean.ofReduceBool` / `Lean.trustCompiler`), or a new
`a x i o m`. All flagships below rest ONLY on `[propext, Classical.choice,
Quot.sound]`. `(whitespace := lax)` only normalises line-wrapping.

Also guards the run's THIRD verified NEGATIVE
(`SlabCenterWitness.slabFullBlock_no_centerWitness` - the trivial-rep full block
has no two-state center gap), which must never silently acquire a `s o r r y`.

Provenance: overnight all-mass WIDE run, lane-V trust consolidation, 2026-07-06.
No `s o r r y`/`a x i o m`; `#print axioms` + `#guard_msgs` only.
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard

/-! ## Connected-slab reflection positivity (RP-LINK ingredient) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.WilsonSlabConnected.wilsonSlabConnected_reflectionPositive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.WilsonSlabConnected.wilsonSlabConnected_reflectionPositive

/-! ## NE-U4 "mass = cost of closure": sector gaps -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.SlabTransferGap.neU4_closure_gap_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.SlabTransferGap.neU4_closure_gap_pos

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.SlabSignRepGap.slabSignBlock_closureGap_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.SlabSignRepGap.slabSignBlock_closureGap_pos

/-! ## Verified NEGATIVE: the trivial-rep full block has no two-state center gap -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.SlabCenterWitness.slabFullBlock_no_centerWitness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.SlabCenterWitness.slabFullBlock_no_centerWitness

/-! ## OS/GNS reconstruction: self-adjoint transfer + spectral gap -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction.osSpectralGap_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction.osSpectralGap_pos

/-! ## Multiscale defect / area-law transport (Faizal-Shabir pieces) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.SummableDefectGap.pos_of_tsum_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.SummableDefectGap.pos_of_tsum_lt

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.AreaLawTransport.sig_ge_base_sub_prefix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.AreaLawTransport.sig_ge_base_sub_prefix

/-! ## CM slice-projector OS + local cyclicity prerequisite -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CMProjectorOS.osForm_insert_selfAdjoint_posSemidef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CMProjectorOS.osForm_insert_selfAdjoint_posSemidef

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.LocalCyclicitySector.localFluxAlgebra_cyclic_top' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.LocalCyclicitySector.localFluxAlgebra_cyclic_top

/-! ## Lane-C CONVERGENCE capstone: the assembled `Z2`-slab finite gap chain -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.SlabGapAssembly.slabGapAssembly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.SlabGapAssembly.slabGapAssembly

/-! ## Correct NONABELIAN strong-coupling character dominance (audit-fixed headline) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff

/-! ## Exponential clustering from the OS gap (Z2 slab) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.SlabClustering.slab_exponential_clustering' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.SlabClustering.slab_exponential_clustering

/-! ## Tomboulis-Yaffe area-law bound (TY-pivot single-gate scaffold, Z2 slab) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw.tyAreaLaw_slab_exp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw.tyAreaLaw_slab_exp

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw.partitionRatio_eq_exp_neg_osSpectralGap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw.partitionRatio_eq_exp_neg_osSpectralGap

end PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard
