import PhysicsSM
import PhysicsSM.Draft.E8ThetaSeriesMoonshot
import PhysicsSM.Draft.E8SpherePackingIsometryHelper
import PhysicsSM.Draft.E8EvenUnimodularUniqueness
import PhysicsSM.Draft.Hamming844Uniqueness
import PhysicsSM.Draft.E8SpherePackingBridge
import PhysicsSM.Draft.E8ThetaModularAristotle
import PhysicsSM.Draft.E8ShortVectorsStructuralAristotle
import PhysicsSM.Draft.E8RootSemanticAristotle
import PhysicsSM.Draft.HammingE8E8StructuralAristotle
import PhysicsSM.Draft.ConstructionAThetaConvolutionAristotle
import PhysicsSM.Draft.ConstructionAThetaNoNativeAristotle
import PhysicsSM.Draft.ConstructionAThetaBoundedShellAristotle
import PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
import PhysicsSM.Draft.E8ThetaDuplicationHelper
import PhysicsSM.Draft.E8ThetaQExpansionBridgeAristotle
import PhysicsSM.Draft.E8ThetaCoeffGapAristotle
import PhysicsSM.Draft.E8ThetaDuplicationAristotle
import PhysicsSM.Draft.E8ThetaMFBridgeHelper
import PhysicsSM.Draft.E8ThetaMFBridgeAristotle
import PhysicsSM.Draft.ThetaDuplicationIdentities
import PhysicsSM.Draft.E8ThetaSPLBridgeAristotle
import PhysicsSM.Draft.E8WeylSemanticAristotle
import PhysicsSM.Draft.E8ShortVectorsNoNativeAristotle
import PhysicsSM.Draft.Hamming844SystematicNoNativeAristotle
import PhysicsSM.Draft.HammingWeightEnumeratorNoNativeAristotle
import PhysicsSM.Draft.E8ThetaDim8Helpers
import PhysicsSM.Draft.DualLatticeHelper
import PhysicsSM.Draft.E8ThetaDim8MF
import PhysicsSM.Draft.ConstructionATypeIIAristotle

/-!
# PhysicsSM draft root

This optional root collects draft and frontier modules that were intentionally
kept out of the trusted `PhysicsSM` root. Some imported modules may contain
documented `sorry` handoff markers.

Build this target explicitly with:

```text
lake build PhysicsSMDraft
```

The direct Sphere-Packing-Lean bridge
`PhysicsSM.Draft.E8SpherePackingImported` is not imported here because it
requires the external Sphere-Packing-Lean dependency and is platform-sensitive
on native Windows.

The general theta-convolution and no-native-grouping Aristotle results are now
imported here only as provenance wrappers.  Their useful proofs have been
promoted to `PhysicsSM.Coding.ConstructionAThetaConvolution`, where they reuse
the trusted theta-weight bridge API.

The bounded-shell bridge and conditional modular-route theta scaffold are also
imported here. They are draft-facing results: the bounded-shell bridge is
sorry-free, while the modular-route file is a conditional theorem isolating the
missing analytic modular-forms facts.
-/
