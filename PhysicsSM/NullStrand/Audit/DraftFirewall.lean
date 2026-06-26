import PhysicsSM.Draft.NullEdgeDiracSlashCore
import PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore
import PhysicsSM.Draft.SpinorHelicityRankOneAristotle
import PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore

/-!
# NullStrand.Audit.DraftFirewall

Explicit *audit guard* for the only place where the trusted NullStrand surface
depends on `PhysicsSM.Draft.*` code. The trusted NullStrand files import exactly
four draft cores, and only through narrow wrappers:

| Draft core (module / namespace)                         | Trusted importer                                  |
| ------------------------------------------------------- | ------------------------------------------------- |
| `PhysicsSM.Draft.NullEdgeDiracSlashCore`                | `PhysicsSM.NullStrand.Conventions`                |
| `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`        | `PhysicsSM.NullStrand.FiniteCore`                 |
| `PhysicsSM.Draft.SpinorHelicityRankOne` (file `...Aristotle`) | `PhysicsSM.NullStrand.ZigZag.ChiralCurrent`  |
| `PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore`       | `PhysicsSM.NullStrand.ZigZag.QuantumWalk`         |

Firewall policy (documented, enforced by review + this audit):

1. Trusted NullStrand code may depend on draft code only via these four cores.
   To verify the surface has not grown, run, from the repo root:

   ```bash
   grep -rn "import PhysicsSM.Draft" PhysicsSM/NullStrand --include=*.lean
   ```

   It must list exactly the four importers above. A new line is a firewall
   breach and needs an explicit audit entry here before it is trusted.

2. Each trusted importer must use the draft core only through its own thin
   wrapper definitions/lemmas (e.g. `Conventions.pauliHermitianEquiv`,
   `FiniteCore.bundleMomentum`, `ChiralCurrent.rightCurrent`,
   `QuantumWalk.quantumWalkOperator`), never re-exporting raw draft internals.

This module contains no new mathematics: every line below `#check`s a real
public draft declaration actually consumed by a trusted wrapper. If a draft core
renames or drops one of these, the audit fails to build, surfacing the drift
before it silently breaks the trusted layer.

Companion module: `PhysicsSM.NullStrand.Audit.Inventory` (audits the trusted
public surface itself).

Provenance: clean-room audit scaffold for the G0 firewall+dedup hardening task,
integrated 2026-06-25. No `s o r r y`/`a x i o m`; `#check` only.
-/

namespace PhysicsSM.NullStrand.Audit.DraftFirewall

/-! ## Core 1: NullEdgeDiracSlashCore (used by `NullStrand.Conventions`) -/

#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.minkowskiNorm
#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum
#check @PhysicsSM.Draft.NullEdgeDiracSlashCore.sigmaMomentum_det_eq_minkowskiNorm

/-! ## Core 2: NullEdgeBundleDiracPluckerCore (used by `NullStrand.FiniteCore`) -/

#check @PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore.matrixWeylCoords
#check @PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore.chiralDiracSlash
#check @PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore.chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass

/-! ## Core 3: SpinorHelicityRankOne (used by `NullStrand.ZigZag.ChiralCurrent`) -/

#check @PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf
#check @PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf_nonneg
#check @PhysicsSM.Draft.SpinorHelicityRankOne.momentumOf_null

/-! ## Core 4: NullEdgeNullStepQuantumWalkCore (used by `NullStrand.ZigZag.QuantumWalk`) -/

#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.Ua
#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.trace_Ua
#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.det_Ua
#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.IsQuasienergy
#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.isQuasienergy_iff_trace
#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.coherenceSq
#check @PhysicsSM.Draft.NullEdgeNullStepQuantumWalkCore.coherenceSq_continuum

end PhysicsSM.NullStrand.Audit.DraftFirewall
