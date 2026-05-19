import PhysicsSM.Prelude
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal
import PhysicsSM.Algebra.Division.CayleyDickson
import PhysicsSM.Algebra.Division.CayleyDicksonOctonionBridge
import PhysicsSM.Algebra.Octonion.TrialityCompanions
import PhysicsSM.Lie.Exceptional.G2
import PhysicsSM.Lie.Exceptional.E8
import PhysicsSM.Lie.Exceptional.E8PositiveDefinite
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
import PhysicsSM.Coding.HammingSelfDual
import PhysicsSM.Coding.E8Scaled
import PhysicsSM.Coding.E8Basis
import PhysicsSM.Coding.E8BasisSpanning
import PhysicsSM.Coding.ConstructionALatticeProperties
import PhysicsSM.Coding.E8HalfIntegerBridge
import PhysicsSM.Coding.E8HalfIntegerBasisBridge
import PhysicsSM.Coding.HammingWeightEnumerator
import PhysicsSM.Coding.CodeEquivalence
import PhysicsSM.Coding.Hamming844UniquenessBasic
import PhysicsSM.Coding.Hamming844Classification
import PhysicsSM.Coding.HammingConstructionAE8Properties
import PhysicsSM.Coding.E8RootBridgeIsometry
import PhysicsSM.Coding.HammingConstructionAE8Final
import PhysicsSM.Coding.E8SpherePackingShape
import PhysicsSM.Coding.E8SpherePackingMatrixBridge
import PhysicsSM.Coding.E8SpherePackingCoordinateBridge
import PhysicsSM.Coding.E8ThetaSeries
import PhysicsSM.Coding.E8ThetaSigmaBridge
import PhysicsSM.Coding.E8ThetaSeriesQ5
import PhysicsSM.Coding.E8ThetaSeriesQ6
import PhysicsSM.Coding.ConstructionAThetaWeightBridge
import PhysicsSM.Coding.ConstructionAThetaConvolution
import PhysicsSM.Coding.E8RootBridge
import PhysicsSM.Coding.E8ShortVectors
import PhysicsSM.Coding.HammingConstructionAE8
import PhysicsSM.Algebra.Octonion.E8WeylBasic
import PhysicsSM.Algebra.Octonion.E8WeylOrbit
import PhysicsSM.Algebra.Octonion.E8WeylPermutations
import PhysicsSM.Algebra.Octonion.E8WeylOrbitConvergence
import PhysicsSM.Algebra.Octonion.E8WeylPublication
import PhysicsSM.Algebra.Octonion.E8RootCompleteness
import PhysicsSM.Algebra.Furey.HyperchargeBridge
import PhysicsSM.Algebra.Division.CompositionAlgebra
import PhysicsSM.Algebra.Division.CompositionClifford

/-!
# PhysicsSM

Root import file for the PhysicsSM formalization project.

Individual files should import only the specific modules they depend on.
See `PhysicsSM.Prelude` for an orientation to available mathlib infrastructure
and project-wide conventions.

The root file imports the currently trusted milestone modules that should be
checked by the default `lake build` target. Draft and frontier modules live in
`PhysicsSMDraft.lean`, which can be built explicitly with
`lake build PhysicsSMDraft`.
-/
