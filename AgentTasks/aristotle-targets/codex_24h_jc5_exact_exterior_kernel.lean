import PhysicsSM.Draft.JordanCliffordExteriorCoverAction
import PhysicsSM.Gauge.StandardModelProductCoveringTrueZ6Kernel

/-!
JC5 exactness handoff. Do not weaken the statements.

The single hard lemma is faithfulness of the even exterior action on the true
product-cover image. Mathematically, the total `5 x 5` block matrix has
determinant one; identity on exterior degree four should force the matrix to be
identity via `Lambda^4(g) = det(g) * g^(-T)`. The existing exact product-cover
kernel theorem then supplies the six-element classification.

Required scope: algebraic product cover only. No topological/Lie-group,
Jordan-flag, Furey-intertwiner, or dynamics claim.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordExactExteriorKernel

open PhysicsSM.Gauge.StandardModelSubgroup
open PhysicsSM.Draft.JordanCliffordExteriorCoverAction

/-- Restrict the landed continuous even-exterior representation to a true
`U(1) x SU(2) x SU(3)` product-cover element. -/
def productEvenExteriorAction (x : SMProductCoveringTriple) :
    Module.End Complex EvenExterior :=
  evenExteriorRepresentation x.toSMCoveringTriple.toUnitCoveringTriple

/-- Hard faithfulness core: on the true product-cover domain, identity on the
complete even exterior module forces the underlying block image to be the
identity. Prove this using the degree-four summand and determinant one. -/
theorem evenExterior_identity_implies_trueImage_identity
    (x : SMProductCoveringTriple)
    (h : productEvenExteriorAction x = 1) :
    smTrueProductCoveringTripleToSMBlockUnits x = 1 := by
  sorry

/-- Exact representation-level kernel theorem: a true product-cover element
acts identically on the complete sixteen-state even exterior module exactly
when it is one of the six standard covering-kernel elements. -/
theorem productEvenExteriorAction_eq_one_iff (x : SMProductCoveringTriple) :
    productEvenExteriorAction x = 1 ↔
      ∃ i : Fin 6, x = smProductCoveringKernelElt i := by
  constructor
  · intro h
    exact (smTrueProductCoveringTripleToSMBlockUnits_eq_one_iff x).1
      (evenExterior_identity_implies_trueImage_identity x h)
  · rintro ⟨i, rfl⟩
    rw [productEvenExteriorAction,
      smProductCoveringKernelElt_toSMCoveringTriple_eq]
    exact sixKernelElements_evenExteriorRepresentation_eq_one i

/-- Positive witness family: every explicit standard kernel element acts as
identity on the complete even exterior module. -/
theorem standard_kernel_family_acts_identically (i : Fin 6) :
    productEvenExteriorAction (smProductCoveringKernelElt i) = 1 := by
  exact (productEvenExteriorAction_eq_one_iff _).2 ⟨i, rfl⟩

/-- Boundary control: every true product-cover element outside the six-element
family acts nontrivially on at least one even exterior state. -/
theorem outside_standard_kernel_acts_nontrivially
    (x : SMProductCoveringTriple)
    (hx : ∀ i : Fin 6, x ≠ smProductCoveringKernelElt i) :
    productEvenExteriorAction x ≠ 1 := by
  intro h
  obtain ⟨i, hi⟩ := (productEvenExteriorAction_eq_one_iff x).1 h
  exact hx i hi

end PhysicsSM.Draft.JordanCliffordExactExteriorKernel
