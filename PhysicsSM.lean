import PhysicsSM.Prelude
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal
import PhysicsSM.Algebra.Division.CayleyDickson
import PhysicsSM.Algebra.Division.CayleyDicksonOctonionBridge
import PhysicsSM.Algebra.Octonion.TrialityCompanions
import PhysicsSM.Lie.Exceptional.G2
import PhysicsSM.Lie.Exceptional.E8
import PhysicsSM.Lie.Exceptional.OctonionSymmetry
import PhysicsSM.StandardModel.AnomalyCancellation
import PhysicsSM.Algebra.Octonion.ComplexLine
import PhysicsSM.Algebra.Octonion.ComplexSplitting
import PhysicsSM.Algebra.Octonion.IntegralOctonion
import PhysicsSM.Algebra.Jordan.Basic
import PhysicsSM.Algebra.Jordan.SpinFactor
import PhysicsSM.Algebra.Jordan.H2O
import PhysicsSM.Algebra.Jordan.H2OProduct
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.H3OJordan
import PhysicsSM.Algebra.Jordan.Automorphism
import PhysicsSM.Algebra.Jordan.Derivation
import PhysicsSM.Algebra.Jordan.ProjectiveGeometry
import PhysicsSM.Algebra.Jordan.TraceForm
import PhysicsSM.Algebra.Jordan.Stabilizer
import PhysicsSM.Algebra.Jordan.StabilizerDerivation
import PhysicsSM.Algebra.Jordan.DVTAction
import PhysicsSM.Algebra.Jordan.BioctonionicPlane
import PhysicsSM.Gauge.BlockEmbeddings
import PhysicsSM.Gauge.StandardModelGroup
import PhysicsSM.Gauge.StandardModelSubgroup
import PhysicsSM.Gauge.GUTSquare
import PhysicsSM.Spinor.OctonionicQubit
import PhysicsSM.Spinor.KrasnovComplexStructure
import PhysicsSM.Spinor.PureSpinor10
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.OneGenerationTable
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.OperatorAlgebra
import PhysicsSM.Algebra.Furey.TrialityTriple
import PhysicsSM.Coding.ConstructionA
import PhysicsSM.Coding.HammingE8

/-!
# PhysicsSM

Root import file for the PhysicsSM formalization project.

Individual files should import only the specific modules they depend on.
See `PhysicsSM.Prelude` for an orientation to available mathlib infrastructure
and project-wide conventions.

The root file imports the currently trusted milestone modules that should be
checked by the default `lake build` target.
-/
