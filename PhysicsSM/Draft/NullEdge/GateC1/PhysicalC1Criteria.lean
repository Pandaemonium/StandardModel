import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndex
import PhysicsSM.Draft.NullEdge.GateC1.OverlapLocalityCertificates
import PhysicsSM.Draft.NullEdge.GateC1.SpectralIslandIndexPredicates
import PhysicsSM.Draft.NullEdge.GateC1.TetraBranchWilsonSymbol

/-!
# Gate C1 physical criteria checklist

This module records the current *physical C1* target as Lean-level certificate
interfaces.  It is deliberately a checklist layer, not a claimed solution.

The finite/free overlap seed is now checked elsewhere:

* `TetraFreeOperator` supplies real-space `Kfree` and `Hfree` symbols.
* `TetraScalarWilsonSymbol` supplies scalar Wilson gap identities.
* `OverlapIndex` supplies finite overlap-index and integrality bookkeeping.
* `OverlapLocalityCertificates` supplies finite locality certificate interfaces.
* `SpectralIslandIndexPredicates` supplies the branch-retention predicate:
  separated island, nonzero chiral index, and true inverse bad-sector gap.
* `TetraBranchWilsonSymbol` supplies the matrix-valued branch Wilson facade.

What remains for physical C1 is to instantiate these interfaces with a concrete
branch selector and Standard Model anomaly data.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace PhysicalC1Criteria

open scoped ComplexOrder

open OverlapLocality
open OverlapLocalityCertificates
open SpectralIslandIndex
open TetraBranchWilsonSymbol
open TetraQMatrixSquareExact

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- Abstract anomaly matching certificate.

The intended downstream use is to replace `standardModelAnomaly` by the
appropriate value computed from the repository's Standard Model anomaly layer.
For the anomaly-free Standard Model channels this value should be `0`; this
definition keeps the matching statement explicit instead of baking in a single
normalization. -/
structure AnomalyMatchingCertificate
    (overlapAnomaly standardModelAnomaly : ℂ) : Prop where
  /-- The overlap/index-side anomaly equals the Standard Model target anomaly. -/
  anomaly_eq : overlapAnomaly = standardModelAnomaly

/-- Positivity/Krein/no-ghost audit for the physical C1 branch construction.

This is intentionally a small interface.  The true inverse bad-sector gap is
already part of `BranchRetentionCertificate`; these extra fields name the
remaining physical-health checks that are not implied by finite matrix
retention alone. -/
structure PositivityKreinAudit
    (gamma5 H K P : Matrix Idx Idx ℂ)
    (NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop) : Prop where
  /-- The sign-kernel seed is Hermitian in the finite Hilbert/Krein audit. -/
  hermitian_seed : H.IsHermitian
  /-- Mirror removal is by a true inverse gap, not by substituting a propagator
  zero or ghost branch. -/
  no_ghost_zero_substitution : NoGhostZeroSubstitution
  /-- Physical branch residue/inner-product sign has passed the chosen
  positivity audit. -/
  positive_physical_residue : PositivePhysicalResidue
  /-- The finite chirality matrix used in the audit is compatible with the
  selected physical sector. -/
  chirality_sector_compatible : ChiralitySectorCompatible

/-- The core physical C1 certificate on a finite matrix space.

This bundles exactly the obligations we now believe are needed for a physical
C1 release:

* branch retention with separated island and true mirror-sector inverse gap;
* finite overlap index/integrality input;
* anomaly matching against the Standard Model target;
* locality or controlled quasi-locality of the sign classifier;
* positivity/Krein/no-ghost audit.

No constructor for this certificate is provided here.  A future concrete
`W_branch`, overlap/domain-wall operator, or spectral projector must supply it. -/
structure PhysicalC1Certificate
    (Dsite : SiteDist Idx)
    (gamma5 eps H K P : Matrix Idx Idx ℂ)
    (hH : H.IsHermitian) (c delta : ℝ)
    (standardModelAnomaly : ℂ)
    (NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop) : Prop where
  /-- Branch retention: separated island, nonzero chiral island index, and a
  true inverse gap on the bad sector. -/
  branch_retention :
    BranchRetentionCertificate gamma5 H K P hH c delta
  /-- The overlap finite index is integer-valued. -/
  overlap_index_integral :
    ∃ z : ℤ, OverlapIndex.overlapIndex gamma5 eps = (z : ℂ)
  /-- The overlap/index-side anomaly matches the Standard Model anomaly target. -/
  anomaly_match :
    AnomalyMatchingCertificate
      (OverlapIndex.overlapIndex gamma5 eps) standardModelAnomaly
  /-- The sign classifier is local or controlled quasi-local in the finite
  certificate sense. -/
  locality :
    ∃ C q : ℝ, ExpLocalCertificate Dsite C q eps
  /-- Positivity/Krein/no-ghost physical-health audit. -/
  positivity :
    PositivityKreinAudit gamma5 H K P
      NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible

/-- A concrete branch Wilson symbol realizes the finite matrices `K` and `H` at
momentum `k`. -/
structure BranchWilsonRealization
    (gamma5 : Matrix Idx Idx ℂ)
    (Dslash : TetraEuclideanSlashData Idx)
    (a : ℝ) (BW : BranchWilsonData (Spin := Idx))
    (k : Fin 4 -> ℝ)
    (H K : Matrix Idx Idx ℂ) : Prop where
  /-- The inverse-propagator symbol is the branch Wilson symbol. -/
  K_eq : K = Kbranch Dslash a BW k
  /-- The Hermitian seed is the branch Wilson `Hbranch` symbol. -/
  H_eq : H = Hbranch gamma5 Dslash a BW k

/-- Physical C1 certificate specialized to the matrix-valued branch Wilson
architecture. -/
structure BranchWilsonPhysicalC1Certificate
    (Dsite : SiteDist Idx)
    (gamma5 eps H K P : Matrix Idx Idx ℂ)
    (hH : H.IsHermitian) (c delta : ℝ)
    (standardModelAnomaly : ℂ)
    (NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop)
    (Dslash : TetraEuclideanSlashData Idx)
    (a : ℝ) (BW : BranchWilsonData (Spin := Idx))
    (k : Fin 4 -> ℝ) : Prop where
  /-- The full physical C1 checklist. -/
  physical :
    PhysicalC1Certificate Dsite gamma5 eps H K P hH c delta
      standardModelAnomaly NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible
  /-- The matrices are realized by the proposed branch Wilson symbol. -/
  realization :
    BranchWilsonRealization gamma5 Dslash a BW k H K
  /-- Lightweight branch-Wilson audit from the symbol facade. -/
  branch_wilson_audit :
    BranchWilsonAudit gamma5 BW

/-- Any physical C1 certificate has a true inverse bad-sector gap. -/
theorem PhysicalC1Certificate.bad_sector_gap
    {Dsite : SiteDist Idx}
    {gamma5 eps H K P : Matrix Idx Idx ℂ}
    {hH : H.IsHermitian} {c delta : ℝ}
    {standardModelAnomaly : ℂ}
    {NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop}
    (cert :
      PhysicalC1Certificate Dsite gamma5 eps H K P hH c delta
        standardModelAnomaly NoGhostZeroSubstitution PositivePhysicalResidue
        ChiralitySectorCompatible) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ((1 - P) * (star K * K) * (1 - P) - (gamma : ℂ) • (1 - P)).PosSemidef :=
  cert.branch_retention.inverseBadSectorGap

/-- Any physical C1 certificate carries a nonzero chiral index on the retained
island. -/
theorem PhysicalC1Certificate.nonzero_island_index
    {Dsite : SiteDist Idx}
    {gamma5 eps H K P : Matrix Idx Idx ℂ}
    {hH : H.IsHermitian} {c delta : ℝ}
    {standardModelAnomaly : ℂ}
    {NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop}
    (cert :
      PhysicalC1Certificate Dsite gamma5 eps H K P hH c delta
        standardModelAnomaly NoGhostZeroSubstitution PositivePhysicalResidue
        ChiralitySectorCompatible) :
    chiralIndex gamma5 P ≠ 0 :=
  cert.branch_retention.nonzeroIndex

/-- Any physical C1 certificate has an integer finite overlap index. -/
theorem PhysicalC1Certificate.index_integral
    {Dsite : SiteDist Idx}
    {gamma5 eps H K P : Matrix Idx Idx ℂ}
    {hH : H.IsHermitian} {c delta : ℝ}
    {standardModelAnomaly : ℂ}
    {NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop}
    (cert :
      PhysicalC1Certificate Dsite gamma5 eps H K P hH c delta
        standardModelAnomaly NoGhostZeroSubstitution PositivePhysicalResidue
        ChiralitySectorCompatible) :
    ∃ z : ℤ, OverlapIndex.overlapIndex gamma5 eps = (z : ℂ) :=
  cert.overlap_index_integral

/-- Any branch-Wilson physical C1 certificate gives the underlying physical C1
certificate. -/
theorem BranchWilsonPhysicalC1Certificate.to_physical
    {Dsite : SiteDist Idx}
    {gamma5 eps H K P : Matrix Idx Idx ℂ}
    {hH : H.IsHermitian} {c delta : ℝ}
    {standardModelAnomaly : ℂ}
    {NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible : Prop}
    {Dslash : TetraEuclideanSlashData Idx}
    {a : ℝ} {BW : BranchWilsonData (Spin := Idx)}
    {k : Fin 4 -> ℝ}
    (cert :
      BranchWilsonPhysicalC1Certificate Dsite gamma5 eps H K P hH c delta
        standardModelAnomaly NoGhostZeroSubstitution PositivePhysicalResidue
        ChiralitySectorCompatible Dslash a BW k) :
    PhysicalC1Certificate Dsite gamma5 eps H K P hH c delta
      standardModelAnomaly NoGhostZeroSubstitution PositivePhysicalResidue
      ChiralitySectorCompatible :=
  cert.physical

end PhysicalC1Criteria
end GateC1
end NullEdge
end Draft
end PhysicsSM
