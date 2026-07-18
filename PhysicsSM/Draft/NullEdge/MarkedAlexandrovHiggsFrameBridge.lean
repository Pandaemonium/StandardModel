import PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia
import PhysicsSM.Draft.NullEdge.ShellAngularDualRecovery

/-!
# One marked shell frame for inertia and Higgs derivatives

This module joins two previously separate finite conclusions. At one marked
event, the same supplied radial probe and three supplied angular probes both

1. realize a conditional mostly-minus split for the project-local corrected
   pairing, and
2. provide a real-linear left inverse that recovers every complex `1+3` Higgs
   derivative vector from finite samples.

The causal order fixes the supporting layers: the angular probes live on the
immediate-predecessor shell `L_0(x)`, while the radial probe lives on
`L_1(x) union L_3(x)`. The support separation is therefore order-derived.
The probes themselves and their nondegeneracy remain explicit hypotheses;
this result does not construct a canonical angular selector from a bare graph.

Claim grade: `M [orig/comp]`, conditional finite bridge.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.MarkedAlexandrovHiggsFrameBridge

open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-- **Shared marked-shell frame bridge.** Under one set of support and rank
hypotheses, the project-local corrected pairing has conditional `(+---)`
inertia and the same four probes exactly encode every complex time-plus-space
derivative vector. -/
theorem projectLocal_shellAngular_inertia_and_complexRecovery
    {U : Type*} [Fintype U] [DecidableEq U]
    (C : FiniteCausalOrder U) (ell : Real) (hell : ell ≠ 0) (x : U)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (htimeSupport :
      ShellAngularDualRecovery.BasedSupportedOn x
        (C.pastLayer x 1 ∪ C.pastLayer x 3) time)
    (hspaceSupport : forall i,
      ShellAngularDualRecovery.BasedSupportedOn x
        (C.pastLayer x 0) (space i))
    (htimeNonzero : exists y,
      y ∈ C.pastLayer x 1 ∪ C.pastLayer x 3 ∧
        ShellAngularDualRecovery.basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ C.pastLayer x 0 ∧
        (∑ i, a i * ShellAngularDualRecovery.basedDifference
          x (space i) y) ≠ 0) :
    MarkedAlexandrovShellInertia.HasProjectLocalConditionalMostlyMinusSplit
        C ell x time space ∧
      exists recovery :
          (U -> Real) →ₗ[Real]
            (ShellAngularDualRecovery.ShellAngularIndex -> Real),
        forall derivative :
            ShellAngularDualRecovery.ShellAngularIndex -> Complex,
          ShellAngularDualRecovery.complexifyRecovery recovery
              (ShellAngularDualRecovery.shellAngularSynthesizeComplex
                x time space derivative) =
            derivative := by
  have htimeSupportInertia :
      MarkedAlexandrovShellInertia.BasedSupportedOn x
        (C.pastLayer x 1 ∪ C.pastLayer x 3) time := by
    simpa [MarkedAlexandrovShellInertia.BasedSupportedOn,
      ShellAngularDualRecovery.BasedSupportedOn,
      MarkedAlexandrovShellInertia.basedDifference,
      ShellAngularDualRecovery.basedDifference] using htimeSupport
  have hspaceSupportInertia : forall i,
      MarkedAlexandrovShellInertia.BasedSupportedOn
        x (C.pastLayer x 0) (space i) := by
    intro i
    simpa [MarkedAlexandrovShellInertia.BasedSupportedOn,
      ShellAngularDualRecovery.BasedSupportedOn,
      MarkedAlexandrovShellInertia.basedDifference,
      ShellAngularDualRecovery.basedDifference] using hspaceSupport i
  have htimeNonzeroInertia : exists y,
      y ∈ C.pastLayer x 1 ∪ C.pastLayer x 3 ∧
        MarkedAlexandrovShellInertia.basedDifference x time y ≠ 0 := by
    simpa [MarkedAlexandrovShellInertia.basedDifference,
      ShellAngularDualRecovery.basedDifference] using htimeNonzero
  have hspaceIndependentInertia : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ C.pastLayer x 0 ∧
        (∑ i, a i * MarkedAlexandrovShellInertia.basedDifference
          x (space i) y) ≠ 0 := by
    intro a ha
    simpa [MarkedAlexandrovShellInertia.basedDifference,
      ShellAngularDualRecovery.basedDifference] using hspaceIndependent a ha
  constructor
  · exact
      MarkedAlexandrovShellInertia.projectLocal_shellAngular_hasConditionalMostlyMinusSplit
        C ell hell x time space htimeSupportInertia hspaceSupportInertia
          htimeNonzeroInertia hspaceIndependentInertia
  · exact ShellAngularDualRecovery.exists_shellAngularComplexRecovery
      x (C.pastLayer x 0) (C.pastLayer x 1 ∪ C.pastLayer x 3)
        time space
        (MarkedAlexandrovShellInertia.pastLayer_zero_disjoint_one_union_three
          C x)
        htimeSupport hspaceSupport htimeNonzero hspaceIndependent

end PhysicsSM.Draft.NullEdge.MarkedAlexandrovHiggsFrameBridge

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovHiggsFrameBridge.projectLocal_shellAngular_inertia_and_complexRecovery' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovHiggsFrameBridge.projectLocal_shellAngular_inertia_and_complexRecovery
