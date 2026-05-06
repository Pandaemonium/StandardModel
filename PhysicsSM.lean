import PhysicsSM.Prelude
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal
import PhysicsSM.Algebra.Division.CayleyDickson
import PhysicsSM.Algebra.Octonion.TrialityCompanions
import PhysicsSM.Lie.Exceptional.G2
import PhysicsSM.Lie.Exceptional.E8
import PhysicsSM.Lie.Exceptional.OctonionSymmetry
import PhysicsSM.StandardModel.AnomalyCancellation
import PhysicsSM.Algebra.Octonion.ComplexLine
import PhysicsSM.Algebra.Octonion.ComplexSplitting
import PhysicsSM.Algebra.Jordan.Basic
import PhysicsSM.Algebra.Jordan.SpinFactor
import PhysicsSM.Algebra.Jordan.H2O
import PhysicsSM.Algebra.Jordan.H2OProduct
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.H3OJordan
import PhysicsSM.Algebra.Jordan.Automorphism
import PhysicsSM.Algebra.Jordan.ProjectiveGeometry
import PhysicsSM.Gauge.BlockEmbeddings
import PhysicsSM.Gauge.StandardModelGroup
import PhysicsSM.Spinor.OctonionicQubit
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.OperatorAlgebra

/-!
# PhysicsSM

Root import file for the PhysicsSM formalization project.

Individual files should import only the specific modules they depend on.
See `PhysicsSM.Prelude` for an orientation to available mathlib infrastructure
and project-wide conventions.

The root file imports the currently trusted milestone modules that should be
checked by the default `lake build` target.
-/
