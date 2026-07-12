import Mathlib
import PhysicsSM.Draft.JordanCliffordExteriorCoverAction
import PhysicsSM.Draft.JordanCliffordBlockKernelCore
import PhysicsSM.Gauge.StandardModelProductCoveringTrueZ6Kernel

/-!
# Exact kernel of the continuous even-exterior action

The generic exterior-square minor identity converts identity of the full
even-exterior action into an entrywise Kronecker relation between its weak and
color blocks. The pure block theorem then forces both blocks to be identity,
so the trusted product-cover kernel theorem gives the exact six-element fiber.

Claim boundary: algebraic action kernel on the true Standard Model product
cover only. No topological quotient, Lie-group smoothness, Jordan derivation of
the weak/color split, Furey-module intertwiner, chirality, or dynamics.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordExactExteriorKernel

open PhysicsSM.Gauge.StandardModelSubgroup
open PhysicsSM.Draft.JordanCliffordExteriorCoverAction
open PhysicsSM.Gauge.QunitQubitQutritDictionary

/-- Restrict the landed continuous even-exterior representation to a true
`U(1) x SU(2) x SU(3)` product-cover element. -/
def productEvenExteriorAction (x : SMProductCoveringTriple) :
    Module.End Complex EvenExterior :=
  evenExteriorRepresentation x.toSMCoveringTriple.toUnitCoveringTriple

/-- Generic degree-two minor relation extracted from identity of an exterior
square map. -/
lemma exteriorSquare_minor_relation
    {K ι : Type*} [Field K] [Finite ι] [DecidableEq ι]
    (g : (ι → K) →ₗ[K] (ι → K))
    (hg : exteriorPower.map 2 g = LinearMap.id)
    (p q r s : ι) :
    g (Pi.single r (1 : K)) p * g (Pi.single s 1) q -
        g (Pi.single r 1) q * g (Pi.single s 1) p =
      (if p = r then (1 : K) else 0) *
          (if q = s then 1 else 0) -
      (if q = r then 1 else 0) *
          (if p = s then 1 else 0) := by
  letI := Fintype.ofFinite ι
  have h_exterior :
      exteriorPower.map 2 g
          (exteriorPower.ιMulti K 2
            ![Pi.single r 1, Pi.single s 1]) =
        exteriorPower.ιMulti K 2
          ![g (Pi.single r 1), g (Pi.single s 1)] := by
    convert exteriorPower.map_apply_ιMulti g
      ![Pi.single r 1, Pi.single s 1] using 1
  replace h_exterior := congr_arg
    (fun x =>
      (exteriorPower.pairingDual K (ι → K) 2)
        (exteriorPower.ιMulti K 2
          ![(Pi.basisFun K ι).coord p, (Pi.basisFun K ι).coord q]) x)
    h_exterior
  simp_all +decide [Matrix.det_fin_two]
  grind

/-- Equality of the full even-exterior action implies identity on exterior
degree two. -/
lemma exteriorMap2_id_of_identity
    (x : SMProductCoveringTriple)
    (h : productEvenExteriorAction x = 1) :
    exteriorPower.map 2
        (generationActLinear x.toSMCoveringTriple.toUnitCoveringTriple) =
      LinearMap.id := by
  exact LinearMap.ext fun w => by
    simpa using congr_arg (fun f => f (0, w, 0) |>.2.1) h

/-- The induced degree-two identity gives the entrywise identity Kronecker
relation between the qubit and qutrit blocks. -/
lemma star_relation
    (u : UnitCoveringTriple)
    (hg : exteriorPower.map 2 (generationActLinear u) = LinearMap.id)
    (i i' : Fin 2) (j j' : Fin 3) :
    u.image.1.val i' i * u.image.2.val j' j =
      (if i' = i then (1 : Complex) else 0) *
        (if j' = j then 1 else 0) := by
  have hLL :
      (generationActLinear u) (Pi.single (Sum.inl i) 1) (Sum.inl i') =
        u.image.1.val i' i := by
    change
      (u.image.1.val.mulVec
        (fun k =>
          (Pi.single (Sum.inl i) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inl k))) i' = _
    have hv :
        (fun k : Fin 2 =>
          (Pi.single (Sum.inl i) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inl k)) =
          Pi.single i 1 := by
      funext k
      simp [Pi.single_apply]
    rw [hv, Matrix.mulVec_single_one]
    rfl
  have hRR :
      (generationActLinear u) (Pi.single (Sum.inr j) 1) (Sum.inr j') =
        u.image.2.val j' j := by
    change
      (u.image.2.val.mulVec
        (fun k =>
          (Pi.single (Sum.inr j) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inr k))) j' = _
    have hv :
        (fun k : Fin 3 =>
          (Pi.single (Sum.inr j) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inr k)) =
          Pi.single j 1 := by
      funext k
      simp [Pi.single_apply]
    rw [hv, Matrix.mulVec_single_one]
    rfl
  have hLR :
      (generationActLinear u) (Pi.single (Sum.inl i) 1) (Sum.inr j') = 0 := by
    change
      (u.image.2.val.mulVec
        (fun k =>
          (Pi.single (Sum.inl i) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inr k))) j' = 0
    have hv :
        (fun k : Fin 3 =>
          (Pi.single (Sum.inl i) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inr k)) = 0 := by
      funext k
      simp
    rw [hv, Matrix.mulVec_zero]
    rfl
  have hRL :
      (generationActLinear u) (Pi.single (Sum.inr j) 1) (Sum.inl i') = 0 := by
    change
      (u.image.1.val.mulVec
        (fun k =>
          (Pi.single (Sum.inr j) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inl k))) i' = 0
    have hv :
        (fun k : Fin 2 =>
          (Pi.single (Sum.inr j) (1 : Complex) :
            (Fin 2 ⊕ Fin 3) → Complex) (Sum.inl k)) = 0 := by
      funext k
      simp
    rw [hv, Matrix.mulVec_zero]
    rfl
  have hminor := exteriorSquare_minor_relation (generationActLinear u) hg
    (Sum.inl i') (Sum.inr j') (Sum.inl i) (Sum.inr j)
  rw [hLL, hRR, hLR, hRL] at hminor
  simp at hminor
  simpa [mul_comm] using hminor

/-- The qubit block of the true covering image is `phase^3` times the `SU(2)`
part. -/
lemma imageBlock1_eq (x : SMProductCoveringTriple) :
    x.toSMCoveringTriple.toUnitCoveringTriple.image.1.val =
      ((x.phase : Complex) ^ 3) • x.su2Part.unit.val := by
  change (matrixScalarUnit (x.phase ^ 3) * x.su2Part.unit).val = _
  simp

/-- The qutrit block of the true covering image is `phase^-2` times the
`SU(3)` part. -/
lemma imageBlock2_eq (x : SMProductCoveringTriple) :
    x.toSMCoveringTriple.toUnitCoveringTriple.image.2.val =
      (((x.phase : Complex)⁻¹) ^ 2) • x.su3Part.unit.val := by
  change (matrixScalarUnit (x.phase⁻¹ ^ 2) * x.su3Part.unit).val = _
  simp

/-- Identity of both concrete blocks is identity in the trusted block-units
target. -/
lemma blockUnits_eq_one_of_blocks
    (x : SMProductCoveringTriple)
    (hA : x.toSMCoveringTriple.image.1.val = 1)
    (hB : x.toSMCoveringTriple.image.2.val = 1) :
    smTrueProductCoveringTripleToSMBlockUnits x = 1 := by
  apply Subtype.ext
  apply Units.ext
  simp_all [smTrueProductCoveringTripleToSMBlockUnits]

/-- Identity of the complete even-exterior action forces identity of the
underlying true product-cover block image. -/
theorem evenExterior_identity_implies_trueImage_identity
    (x : SMProductCoveringTriple)
    (h : productEvenExteriorAction x = 1) :
    smTrueProductCoveringTripleToSMBlockUnits x = 1 := by
  let u := x.toSMCoveringTriple.toUnitCoveringTriple
  have hg : exteriorPower.map 2 (generationActLinear u) = LinearMap.id :=
    exteriorMap2_id_of_identity x h
  have hstar := star_relation u hg
  have hA : u.image.1.val = ((x.phase : Complex) ^ 3) •
      x.su2Part.unit.val := imageBlock1_eq x
  have hB : u.image.2.val = (((x.phase : Complex)⁻¹) ^ 2) •
      x.su3Part.unit.val := imageBlock2_eq x
  have hp : (x.phase : Complex) ≠ 0 := x.phase.ne_zero
  obtain ⟨hA1, hB1⟩ :=
    JordanCliffordBlockKernelCore.blocks_are_identity
      (x.phase : Complex) hp u.image.1.val u.image.2.val
      x.su2Part.unit.val x.su3Part.unit.val hA hB
      x.su2Part.det_one x.su3Part.det_one hstar
  exact blockUnits_eq_one_of_blocks x hA1 hB1

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
    exact sixKernelElements_evenExteriorRepresentation_eq_one i

/-- Every explicit standard kernel element acts identically. -/
theorem standard_kernel_family_acts_identically (i : Fin 6) :
    productEvenExteriorAction (smProductCoveringKernelElt i) = 1 := by
  exact (productEvenExteriorAction_eq_one_iff _).2 ⟨i, rfl⟩

/-- Every element outside the six-element standard family acts
nontrivially. -/
theorem outside_standard_kernel_acts_nontrivially
    (x : SMProductCoveringTriple)
    (hx : ∀ i : Fin 6, x ≠ smProductCoveringKernelElt i) :
    productEvenExteriorAction x ≠ 1 := by
  intro h
  obtain ⟨i, hi⟩ := (productEvenExteriorAction_eq_one_iff x).1 h
  exact hx i hi

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordExactExteriorKernel.productEvenExteriorAction_eq_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms productEvenExteriorAction_eq_one_iff

/-- info: 'PhysicsSM.Draft.JordanCliffordExactExteriorKernel.outside_standard_kernel_acts_nontrivially' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms outside_standard_kernel_acts_nontrivially

end PhysicsSM.Draft.JordanCliffordExactExteriorKernel
