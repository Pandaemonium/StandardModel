import PhysicsSM.Draft.NullEdge.GateYM.SlabTransferGap
import PhysicsSM.Draft.NullEdge.GateYM.SlabSignRepGap
import PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction
import PhysicsSM.Draft.NullEdge.GateYM.SlabClustering

/-!
# SlabGapAssembly: the lane-C (closure/Yang-Mills) finite gap chain as ONE theorem

This is the CONVERGENCE module for the closure-mass / Yang-Mills lane of the
overnight all-mass run (2026-07-06).  The wide run produced the finite
Osterwalder-Seiler-regime gap chain as scattered lemmas across
`SlabTransferGap`, `SlabSignRepGap`, and `OSReconstruction` (several motivated by
the Faizal-Shabir reflection-positive lattice SU(N) blueprint,
arXiv:2606.19362).  Here we bundle the LANDED pieces into a single citable finite
theorem on the connected `Z2` Wilson slab, so the wide output CONVERGES instead
of staying scattered.

## What is assembled (`slabGapAssembly`)

For inverse coupling `beta > 0`, on the connected `Z2` (center-sector) Wilson
slab with the flux-sensitive sign representation `signRho`, the following hold
SIMULTANEOUSLY and are each already kernel-checked elsewhere:

1. **Reflection positivity.** The slab transfer block `slabTransferBlock beta
   signRho` is positive semidefinite (`SlabTransferGap.slabTransferBlock_posSemidef`).
   This is the reflection-positivity link: the mirror-doubled Wilson slab weight
   is a Gram matrix.
2. **Self-adjoint transfer.** The same block is Hermitian
   (`SlabTransferGap.slabTransferBlock_isHermitian`); the OS/GNS-reconstructed
   transfer operator built from it is self-adjoint and positive on the finite GNS
   inner-product space (`OSReconstruction.slabOsTransfer_isSelfAdjoint`,
   `slabOsTransfer_posSemidef`; not re-embedded here — cited).
3. **Strictly positive spectral gap.** The OS Hamiltonian gap `H = -log T`
   between the vacuum and the lightest center-flux excitation is strictly positive
   (`OSReconstruction.osSpectralGap_pos`).
4. **Explicit strong-coupling value.** That gap equals `-log(tanh beta)`, the
   one-link flux cost / string-tension-per-plaquette (`osSpectralGap_eq_neg_log_tanh`).
5. **Vacuum separation.** The lightest center-flux transfer eigenvalue lies
   strictly below the vacuum eigenvalue (`OSReconstruction.osVacuum_separated`).
6. **Exponential clustering.** The connected two-point function of the
   OS-reconstructed transfer operator decays exponentially at exactly the gap
   rate, `‖connected(n)‖ ≤ C · exp(-(n · gap))`
   (`SlabClustering.slab_exponential_clustering`).  This is the area-law /
   clustering endpoint of the chain, now landed on the same slab (harvested
   2026-07-06).

## Honest scope (claim label: finite identity / OS-regime gap, draft)

This is a FINITE, kernel-checked statement about the exactly-solvable `Z2`
center-sector slab.  It is NOT:
- a nonabelian SU(2)/SU(3) result (the group here is the abelian `Z2`; the
  nonabelian generalization is open and is what the character-expansion and
  Tomboulis-Yaffe routes target),
- a continuum or physical mass gap (no continuum limit is claimed; `beta` is
  fixed),
- the cluster-expansion route: this chain reaches the gap AND the exponential
  clustering via OS/GNS reconstruction of the finite transfer operator, which does
  NOT depend on the parked Kotecky-Preiss convergence crux (`pairSum_le_expBound`).
  The clustering conjunct (field 6) is the EXACT two-state Z2 result from
  `SlabClustering`, not the abstract sequence lemmas in `AreaLawTransport` /
  `SummableDefectGap` (those remain abstract and are not used here).

**Three-objects honesty note (semantic audit 2026-07-06, job `029b8cd3`).**  The
six fields are all pinned to the same number `tanh β` and are mutually consistent,
but they are statements about THREE related-but-distinct objects: fields 1-2
(RP-PSD, Hermitian) are about the transfer *matrix* `slabTransferBlock signRho`;
fields 3-4 (`gap_pos`, `gap_value`) are about the OS *Hamiltonian* gap
`osSpectralGap`; field 5 about the eigenvalue pair `lambdaFlux/lambda0`; field 6
about the normalised transfer `slabNormTransfer`.  This module does NOT in itself
prove that `osSpectralGap` is the spectral gap OF the RP-PSD block - that
identification lives in the underlying `OSReconstruction`/`SlabTransferGap`
modules.  So "one gap chain" is a bundling of consistent facts, not a single-object
theorem; read it as "these finite Z2-slab quantities all cohere at `tanh β`",
NOT as "area law = transfer gap = Hamiltonian gap" in general.

No new `axiom`, no `native_decide`, no `sorry`; every field is discharged by an
existing kernel-checked lemma.  Axiom-guarded in `SlabAxiomGuard`.

Provenance: overnight all-mass WIDE run, lane-C convergence, 2026-07-06.
Prerequisites: `SlabTransferGap`, `SlabSignRepGap`, `OSReconstruction`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SlabGapAssembly

open scoped BigOperators ComplexOrder Matrix

/-- **The assembled lane-C finite gap chain on the connected `Z2` slab.**  A
record bundling the five simultaneously-holding facts (reflection positivity,
self-adjoint/Hermitian transfer, strictly positive spectral gap, its explicit
`-log(tanh beta)` value, and vacuum separation) for the flux-sensitive sign
representation at inverse coupling `beta`.  Each field is a landed,
kernel-checked statement; this structure only makes the CONJUNCTION citable as
one object.  See the module docstring for the honest scope. -/
structure SlabGapChain (beta : ℝ) (hbeta : 0 < beta) : Prop where
  /-- Reflection positivity: the sign-rep slab transfer block is PSD. -/
  rp_posSemidef :
    (SlabTransferGap.slabTransferBlock beta SlabSignRepGap.signRho).PosSemidef
  /-- Self-adjoint transfer: the same block is Hermitian (the OS transfer
  operator built from it is self-adjoint on the GNS space, per
  `OSReconstruction.slabOsTransfer_isSelfAdjoint`). -/
  transfer_isHermitian :
    (SlabTransferGap.slabTransferBlock beta SlabSignRepGap.signRho).IsHermitian
  /-- Strictly positive OS spectral gap above the vacuum. -/
  gap_pos : 0 < OSReconstruction.osSpectralGap beta hbeta
  /-- The gap equals the strong-coupling flux cost `-log(tanh beta)`. -/
  gap_value :
    OSReconstruction.osSpectralGap beta hbeta = -Real.log (Real.tanh beta)
  /-- The lightest center-flux eigenvalue is strictly below the vacuum. -/
  vacuum_separated :
    TwoStateTransferZ2Sector.lambdaFlux beta
      < TwoStateTransferZ2Sector.lambda0 beta
  /-- Exponential clustering: for all states `v, w` the connected two-point
  function decays as `exp(-(m · gap))` with a constant that is the flux-sector
  overlap and is **independent of the step count `m`** (genuine uniform-in-`m`
  decay - the `m`-free constant is essential; an `m`-dependent constant would be
  vacuous).  This is exactly `SlabClustering.slab_exponential_clustering`. -/
  clustering : ∀ (m : ℕ) (v w : Fin 2 → ℂ),
    ‖SlabClustering.slabConnectedCorrelation beta m v w‖
      ≤ ‖(star v ⬝ᵥ TwoStateTransferSpectrum.localVec) *
          (star TwoStateTransferSpectrum.localVec ⬝ᵥ w) / 2‖
        * Real.exp (-(m * OSReconstruction.osSpectralGap beta hbeta))

/-- **Assembly theorem.**  The connected `Z2` Wilson slab satisfies the full
finite lane-C gap chain for every `beta > 0`.  Every field is discharged by the
corresponding landed lemma; the sign representation supplies the unitarity
hypotheses via `SlabSignRepGap.signRho_mul` / `signRho_one` / `signRho_unit`. -/
theorem slabGapAssembly (beta : ℝ) (hbeta : 0 < beta) :
    SlabGapChain beta hbeta where
  rp_posSemidef :=
    SlabTransferGap.slabTransferBlock_posSemidef beta hbeta.le SlabSignRepGap.signRho
      SlabSignRepGap.signRho_mul SlabSignRepGap.signRho_one SlabSignRepGap.signRho_unit
  transfer_isHermitian :=
    SlabTransferGap.slabTransferBlock_isHermitian beta hbeta.le SlabSignRepGap.signRho
      SlabSignRepGap.signRho_mul SlabSignRepGap.signRho_one SlabSignRepGap.signRho_unit
  gap_pos := OSReconstruction.osSpectralGap_pos beta hbeta
  gap_value := OSReconstruction.osSpectralGap_eq_neg_log_tanh beta hbeta
  vacuum_separated := OSReconstruction.osVacuum_separated beta
  clustering := SlabClustering.slab_exponential_clustering beta hbeta

/-- Corollary read-off: on the connected `Z2` slab the finite OS gap is both
strictly positive and equal to `-log(tanh beta)` — a positive, explicitly-valued
closure-mass gap at fixed lattice spacing. -/
theorem slab_gap_pos_and_value (beta : ℝ) (hbeta : 0 < beta) :
    0 < OSReconstruction.osSpectralGap beta hbeta ∧
      OSReconstruction.osSpectralGap beta hbeta = -Real.log (Real.tanh beta) :=
  ⟨(slabGapAssembly beta hbeta).gap_pos, (slabGapAssembly beta hbeta).gap_value⟩

end SlabGapAssembly
end GateYM
end NullEdge
end Draft
end PhysicsSM
