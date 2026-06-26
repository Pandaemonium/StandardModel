import PhysicsSM.NullStrand.Conventions
import PhysicsSM.NullStrand.FiniteCore
import PhysicsSM.NullStrand.NullFiber.Barycentric
import PhysicsSM.NullStrand.NullFiber.RegulatorMeanNorm
import PhysicsSM.NullStrand.NullFiber.RegulatorNoGo
import PhysicsSM.NullStrand.NullFiber.BoundaryNoGo
import PhysicsSM.NullStrand.NullLift.FiniteResidualCurrent
import PhysicsSM.NullStrand.NullLift.FiniteEquivariance
import PhysicsSM.NullStrand.ZigZag.ChiralCurrent
import PhysicsSM.NullStrand.ZigZag.QuantumWalk

/-!
# NullStrand.Audit.Inventory

Lightweight, kernel-checked *audit* module for the G0/G1 public surface of the
finite null-strand core. It contains no new mathematics: every line is a
`#check` of a real public declaration (by fully-qualified name). The module
compiles iff each listed declaration still exists with a type-compatible
signature, so renames or accidental deletions of the trusted public API become
visible as a build failure here instead of silently downstream.

This module deliberately imports both `RegulatorMeanNorm` and `RegulatorNoGo`
at once. Before the 2026-06-25 de-duplication that co-import would have been
ambiguous, because both files declared
`PhysicsSM.NullStrand.NullFiber.uniformComponent_bounds_meanNorm`. The orphan
`RegulatorNoGo` variant is now
`PhysicsSM.NullStrand.NullFiber.expectation_uniformComponent_bounds_meanNorm`,
so the two coexist and both are checked below.

Companion module: `PhysicsSM.NullStrand.Audit.DraftFirewall` (audits the exact
`PhysicsSM.Draft.*` surface that trusted NullStrand files depend on).

Provenance: clean-room audit scaffold for the G0 firewall+dedup hardening task,
integrated 2026-06-25. No `s o r r y`/`a x i o m`; `#check` only.
-/

namespace PhysicsSM.NullStrand.Audit.Inventory

/-! ## Conventions (metric, nullity, Pauli/Hermitian bridge) -/

#check @PhysicsSM.NullStrand.minkowskiInner
#check @PhysicsSM.NullStrand.minkowskiSq
#check @PhysicsSM.NullStrand.IsFuture
#check @PhysicsSM.NullStrand.IsNull
#check @PhysicsSM.NullStrand.IsTimelike
#check @PhysicsSM.NullStrand.IsUnitFutureTimelike
#check @PhysicsSM.NullStrand.pauliHermitianEquiv
#check @PhysicsSM.NullStrand.pauliHermitianEquiv_apply
#check @PhysicsSM.NullStrand.hermitian_det_eq_minkowskiSq
#check @PhysicsSM.NullStrand.sl2_congruence_preserves_det

/-! ## FiniteCore (finite Plucker mass -> chiral Dirac square root) -/

#check @PhysicsSM.NullStrand.bundleMomentum
#check @PhysicsSM.NullStrand.finiteCore_staticMassSquareRoot

/-! ## NullFiber.Barycentric (DEF-004 / KIN-004 PMF-style null resolution) -/

#check @PhysicsSM.NullStrand.NullFiber.Barycentric.minkowskiInner
#check @PhysicsSM.NullStrand.NullFiber.Barycentric.FiniteNullResolution
#check @PhysicsSM.NullStrand.NullFiber.Barycentric.octaDir
#check @PhysicsSM.NullStrand.NullFiber.Barycentric.octahedralResolution

/-! ## NullFiber regulator no-go family (KIN-010 / KIN-011) -/

#check @PhysicsSM.NullStrand.NullFiber.uniformComponent_bounds_meanNorm
#check @PhysicsSM.NullStrand.NullFiber.meanNorm_eq_one_implies_support_collinear
#check @PhysicsSM.NullStrand.NullFiber.expectation
#check @PhysicsSM.NullStrand.NullFiber.expectation_uniformComponent_bounds_meanNorm

/-! ## NullLift finite residual current (distinct `FiniteNullResolution`) -/

#check @PhysicsSM.NullStrand.NullLift.FiniteNullResolution
#check @PhysicsSM.NullStrand.NullLift.extendedDensity
#check @PhysicsSM.NullStrand.NullLift.residualCurrent
#check @PhysicsSM.NullStrand.NullLift.residualDivergence
#check @PhysicsSM.NullStrand.NullLift.extendedDensity_sum_eq
#check @PhysicsSM.NullStrand.NullLift.residualCurrent_divergence_eq

/-! ## ZigZag chiral current (finite one-spinor currents) -/

#check @PhysicsSM.NullStrand.ZigZag.rightCurrent
#check @PhysicsSM.NullStrand.ZigZag.leftCurrent
#check @PhysicsSM.NullStrand.ZigZag.rightCurrent_null
#check @PhysicsSM.NullStrand.ZigZag.leftCurrent_null
#check @PhysicsSM.NullStrand.ZigZag.rightCurrent_futureNull_of_ne_zero

/-! ## ZigZag null-step quantum walk (quasienergy / coherence) -/

#check @PhysicsSM.NullStrand.ZigZag.quantumWalkOperator
#check @PhysicsSM.NullStrand.ZigZag.quantumWalk_trace
#check @PhysicsSM.NullStrand.ZigZag.quantumWalk_det_one
#check @PhysicsSM.NullStrand.ZigZag.quantumWalk_quasienergy_relation
#check @PhysicsSM.NullStrand.ZigZag.quantumWalk_coherenceSq_continuum

end PhysicsSM.NullStrand.Audit.Inventory
