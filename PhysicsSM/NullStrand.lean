import PhysicsSM.NullStrand.Conventions
import PhysicsSM.NullStrand.FiniteCore
import PhysicsSM.NullStrand.NullFiber.Basic
import PhysicsSM.NullStrand.NullFiber.FiniteDesign
import PhysicsSM.NullStrand.NullFiber.FiniteRestFrame
import PhysicsSM.NullStrand.ZigZag.ChiralCurrent
import PhysicsSM.NullStrand.ZigZag.TransferCurrent
import PhysicsSM.NullStrand.ZigZag.MinimalRates
import PhysicsSM.NullStrand.ZigZag.EntropicTraffic
import PhysicsSM.NullStrand.ZigZag.LatticeBeable
import PhysicsSM.NullStrand.ZigZag.QuantumWalk
import PhysicsSM.NullStrand.BellQFT.FiniteCurrent
import PhysicsSM.NullStrand.BellQFT.MinimalJumpRates
import PhysicsSM.NullStrand.BellQFT.FockCutoff
import PhysicsSM.NullStrand.Graph.BellSupport
import PhysicsSM.NullStrand.Clock.InternalHolonomy
import PhysicsSM.NullStrand.NullLift.FiniteResidualCurrent
import PhysicsSM.NullStrand.NullLift.FiniteEquivariance
import PhysicsSM.NullStrand.NullLift.FiniteLeastAction
import PhysicsSM.NullStrand.Synchronization.DiamondDefect
import PhysicsSM.NullStrand.Ergodic.RefreshChain
import PhysicsSM.NullStrand.Entanglement.ProductNullRepresentation
import PhysicsSM.NullStrand.Entanglement.SeparabilityObstruction
import PhysicsSM.NullStrand.Master.FiniteModel
import PhysicsSM.NullStrand.Master.FoliatedManyParticle

/-!
# NullStrand

Lean entry point for the finite null-strand core.

This file exposes a compact import surface for the staged roadmap:
- conventions and Pauli/Hermitian bridge lemmas,
- finite Dirac-square wrappers,
- null-fiber structures and finite octahedral pilot instances.
-/
