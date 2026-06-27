import Mathlib

/-!
# Gate C split API

This draft module records the June 27, 2026 strategic split of Gate C into two
separate obligations.

`GateC0SpeciesHealthy` is the external species-health layer: keep the intended
origin branch, gap all non-origin real-torus species by an inverse-propagator
mass gap rather than a point-split numerator zero, and preserve the leading
null-edge symbol.

`GateC1ChiralPhysicalRelease` is the physical chiral-release layer: choose a
positive physical sector, a legitimate chirality grading, and the ghost/gauge
clauses needed for a Standard-Model-facing release.

The point is deliberately modest: a C0 theorem is valuable, but it is not a C1
or full Gate C release. This prevents a scalar Wilson species-lifting lemma from
being misread as a chiral-gauge release theorem.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdgeGateCSplit

/-- Abstract data for the external species-health stage of Gate C. -/
structure GateC0Data where
  originRetained : Prop
  nonOriginGapped : Prop
  gappedByMassGap : Prop
  leadingSymbolUnchanged : Prop

/--
Gate C0: the external species problem is healthy in the free/regulator model.

This is intentionally weaker than chiral release: it says the origin branch is
kept, off-origin branches are gapped, the gap is a real inverse-propagator mass
gap, and the leading continuum null-edge symbol is unchanged.
-/
structure GateC0SpeciesHealthy (D : GateC0Data) : Prop where
  origin_retained : D.originRetained
  non_origin_gapped : D.nonOriginGapped
  gapped_by_mass_gap : D.gappedByMassGap
  leading_symbol_unchanged : D.leadingSymbolUnchanged

/-- Abstract data for the physical chiral-release stage of Gate C. -/
structure GateC1Data where
  physicalChiralityChosen : Prop
  retainedBranchChiral : Prop
  positivePhysicalSector : Prop
  ghostZeroSafe : Prop
  gaugeCovariant : Prop
  countertermsAudited : Prop

/--
Gate C1: the species-healthy seed has been promoted to a physical chiral
release candidate.

This layer is where a choice such as an overlap/domain-wall construction, a
projected Weyl sector, or a modified chirality grading must be justified.
-/
structure GateC1ChiralPhysicalRelease (D : GateC1Data) : Prop where
  physical_chirality_chosen : D.physicalChiralityChosen
  retained_branch_chiral : D.retainedBranchChiral
  positive_physical_sector : D.positivePhysicalSector
  ghost_zero_safe : D.ghostZeroSafe
  gauge_covariant : D.gaugeCovariant
  counterterms_audited : D.countertermsAudited

/-- Abstract data for the Gate H/internal-sector compatibility layer. -/
structure GateHData where
  internalSpectrumLegal : Prop
  anomalyInherited : Prop
  legalPhiHBlocks : Prop

/--
Gate H compatibility: the internal finite algebra supports the released
physical sector without pretending to solve the external species problem.
-/
structure GateHCompatible (D : GateHData) : Prop where
  internal_spectrum_legal : D.internalSpectrumLegal
  anomaly_inherited : D.anomalyInherited
  legal_phiH_blocks : D.legalPhiHBlocks

/-- Bundled data for the staged Gate C release statement. -/
structure StagedGateCData where
  c0 : GateC0Data
  c1 : GateC1Data
  h : GateHData

/--
Full staged Gate C release: external species health, physical chiral release,
and internal-sector compatibility all hold.
-/
structure StagedGateCReleased (D : StagedGateCData) : Prop where
  c0 : GateC0SpeciesHealthy D.c0
  c1 : GateC1ChiralPhysicalRelease D.c1
  h : GateHCompatible D.h

/-- A staged Gate C release includes the C0 species-health theorem. -/
theorem stagedGateCReleased_speciesHealthy {D : StagedGateCData}
    (h : StagedGateCReleased D) : GateC0SpeciesHealthy D.c0 :=
  h.c0

/-- A staged Gate C release includes the C1 chiral physical release theorem. -/
theorem stagedGateCReleased_chiralRelease {D : StagedGateCData}
    (h : StagedGateCReleased D) : GateC1ChiralPhysicalRelease D.c1 :=
  h.c1

/-- A staged Gate C release includes Gate H compatibility. -/
theorem stagedGateCReleased_gateHCompatible {D : StagedGateCData}
    (h : StagedGateCReleased D) : GateHCompatible D.h :=
  h.h

/-- Assemble the staged release from its three independent layers. -/
theorem stagedGateCReleased_of_layers {D : StagedGateCData}
    (h0 : GateC0SpeciesHealthy D.c0)
    (h1 : GateC1ChiralPhysicalRelease D.c1)
    (hH : GateHCompatible D.h) :
    StagedGateCReleased D :=
  ⟨h0, h1, hH⟩

/--
C0 alone is not a full Gate C release. If the C1 layer fails, then even a
species-healthy regulator cannot be promoted to `StagedGateCReleased`.
-/
theorem gateC0_alone_insufficient {D : StagedGateCData}
    (_h0 : GateC0SpeciesHealthy D.c0)
    (hnot : ¬ GateC1ChiralPhysicalRelease D.c1) :
    ¬ StagedGateCReleased D := by
  intro hrel
  exact hnot hrel.c1

/--
Gate H compatibility alone is not a full Gate C release. If the C0 layer fails,
the internal algebra cannot by itself repair the external species problem.
-/
theorem gateH_alone_insufficient {D : StagedGateCData}
    (_hH : GateHCompatible D.h)
    (hnot : ¬ GateC0SpeciesHealthy D.c0) :
    ¬ StagedGateCReleased D := by
  intro hrel
  exact hnot hrel.c0

end NullEdgeGateCSplit
end Draft
end PhysicsSM
