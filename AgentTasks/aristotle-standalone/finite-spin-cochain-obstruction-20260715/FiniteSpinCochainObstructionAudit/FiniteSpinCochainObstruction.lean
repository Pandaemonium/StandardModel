import Mathlib

/-!
# Finite cochain obstruction for graph spin-lift signs

This module generalizes the glued-square sign obstruction to an arbitrary
finite face-edge incidence matrix over `ZMod 2`.

An edge correction `s` changes face defects by the face coboundary `B * s`.
A formal sum of faces `z` is closed when `z * B = 0`. Associativity of matrix
and vector multiplication then gives the necessary compatibility condition

```text
z . defect = 0
```

for every correctable defect. A closed cycle with nonzero pairing is therefore
an exact obstruction certificate. The two square disks glued along one common
boundary provide a nonzero finite witness.

Finite-dimensional duality also proves the converse: a defect is correctable
exactly when every closed-cycle pairing vanishes.

This is finite cochain linear algebra. It does not derive a cell complex from a
bare graph, identify the defect cochain with transition functions of a Lorentz
bundle, prove that the resulting class is the second Stiefel--Whitney class, or
establish refinement and continuum compatibility. Claim grade: `M [orig]`.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction

variable {Edge Face : Type*}
variable [Fintype Edge]
variable [Fintype Face]

/-- Face-edge incidence matrix over the central sign field. -/
abbrev FaceBoundary (Face Edge : Type*) := Matrix Face Edge (ZMod 2)

/-- Edge-sign correction cochain. -/
abbrev EdgeCorrection (Edge : Type*) := Edge -> ZMod 2

/-- Face-defect cochain. -/
abbrev FaceDefect (Face : Type*) := Face -> ZMod 2

/-- Coboundary of an edge-sign correction on faces. -/
def faceCoboundary
    (boundary : FaceBoundary Face Edge) (s : EdgeCorrection Edge) :
    FaceDefect Face :=
  boundary *ᵥ s

/-- A formal face sum is closed when every edge occurs with zero total
coefficient. -/
def IsClosedFaceCycle
    (boundary : FaceBoundary Face Edge) (z : FaceDefect Face) : Prop :=
  z ᵥ* boundary = 0

/-- Mod-two evaluation of a face defect on a formal face cycle. -/
def defectPairing (z defect : FaceDefect Face) : ZMod 2 :=
  z ⬝ᵥ defect

/-- A defect is correctable when it is the face coboundary of one edge-sign
assignment. -/
def Correctable
    (boundary : FaceBoundary Face Edge) (defect : FaceDefect Face) : Prop :=
  exists s : EdgeCorrection Edge, faceCoboundary boundary s = defect

/-- Every closed face cycle pairs trivially with every correctable defect. -/
theorem defectPairing_eq_zero_of_correctable
    (boundary : FaceBoundary Face Edge) (z defect : FaceDefect Face)
    (hcycle : IsClosedFaceCycle boundary z)
    (hcorrectable : Correctable boundary defect) :
    defectPairing z defect = 0 := by
  obtain ⟨s, rfl⟩ := hcorrectable
  unfold IsClosedFaceCycle at hcycle
  unfold defectPairing faceCoboundary
  rw [dotProduct_mulVec, hcycle]
  simp

/-- **Finite annihilator converse.** If a defect pairs trivially with every
closed face cycle, then it is an edge-sign coboundary. This uses finite
dimensionality of the face function space over the field `ZMod 2`. -/
theorem correctable_of_forall_closedCycle_pairing_eq_zero
    (boundary : FaceBoundary Face Edge) (defect : FaceDefect Face)
    (hpairing : forall z : FaceDefect Face,
      IsClosedFaceCycle boundary z -> defectPairing z defect = 0) :
    Correctable boundary defect := by
  classical
  by_contra hnot
  have hnotmem :
      defect ∉ LinearMap.range boundary.mulVecLin := by
    simpa [Correctable, faceCoboundary, Matrix.mulVecLin_apply] using hnot
  obtain ⟨functional, hfunctional, hrange⟩ :=
    Submodule.exists_le_ker_of_notMem hnotmem
  let z : FaceDefect Face :=
    (dotProductEquiv (ZMod 2) Face).symm functional
  have hzrepr :
      dotProductEquiv (ZMod 2) Face z = functional :=
    (dotProductEquiv (ZMod 2) Face).apply_symm_apply functional
  have hzclosed : IsClosedFaceCycle boundary z := by
    unfold IsClosedFaceCycle
    funext edge
    have hcolmem :
        boundary.col edge ∈ LinearMap.range boundary.mulVecLin := by
      refine ⟨Pi.single edge 1, ?_⟩
      simp
    have hzero : functional (boundary.col edge) = 0 :=
      (LinearMap.mem_ker.mp (hrange hcolmem))
    rw [← hzrepr] at hzero
    simpa [Matrix.vecMul, dotProductEquiv_apply_apply] using hzero
  have hzdefect : defectPairing z defect = functional defect := by
    rw [← hzrepr]
    simp [defectPairing, dotProductEquiv_apply_apply]
  exact hfunctional (hzdefect.symm.trans (hpairing z hzclosed))

/-- Correctability is exactly vanishing of every closed-cycle obstruction
pairing. -/
theorem correctable_iff_forall_closedCycle_pairing_eq_zero
    (boundary : FaceBoundary Face Edge) (defect : FaceDefect Face) :
    Correctable boundary defect <->
      forall z : FaceDefect Face,
        IsClosedFaceCycle boundary z -> defectPairing z defect = 0 := by
  constructor
  · intro hcorrectable z hcycle
    exact defectPairing_eq_zero_of_correctable
      boundary z defect hcycle hcorrectable
  · exact correctable_of_forall_closedCycle_pairing_eq_zero boundary defect

/-- A nonzero closed-cycle pairing is an explicit obstruction certificate. -/
def HasDetectedObstruction
    (boundary : FaceBoundary Face Edge) (defect : FaceDefect Face) : Prop :=
  exists z : FaceDefect Face,
    IsClosedFaceCycle boundary z ∧ defectPairing z defect ≠ 0

/-- A detected obstruction rules out every edge-sign correction. -/
theorem not_correctable_of_detectedObstruction
    (boundary : FaceBoundary Face Edge) (defect : FaceDefect Face)
    (hobs : HasDetectedObstruction boundary defect) :
    ¬ Correctable boundary defect := by
  rintro hcorrectable
  obtain ⟨z, hcycle, hpair⟩ := hobs
  exact hpair
    (defectPairing_eq_zero_of_correctable
      boundary z defect hcycle hcorrectable)

/-- Correctability is equivalent to absence of a detected closed-cycle
obstruction. -/
theorem correctable_iff_not_detectedObstruction
    (boundary : FaceBoundary Face Edge) (defect : FaceDefect Face) :
    Correctable boundary defect <->
      ¬ HasDetectedObstruction boundary defect := by
  constructor
  · intro hcorrectable
    rintro ⟨z, hcycle, hpair⟩
    exact hpair
      (defectPairing_eq_zero_of_correctable
        boundary z defect hcycle hcorrectable)
  · intro hnoObstruction
    apply correctable_of_forall_closedCycle_pairing_eq_zero boundary defect
    intro z hcycle
    by_contra hne
    exact hnoObstruction ⟨z, hcycle, hne⟩

/-! ## Exact glued-square obstruction -/

/-- Both faces use the same four-edge square boundary. Over `ZMod 2`, the
opposite geometric orientations have the same incidence coefficients. -/
def doubleSquareBoundary : FaceBoundary (Fin 2) (Fin 4) :=
  fun _ _ => 1

/-- Sum of the front and back faces, representing the closed two-face cycle. -/
def doubleSquareFaceCycle : FaceDefect (Fin 2) := ![1, 1]

/-- Mismatched central defects on the two glued faces. -/
def doubleSquareMismatch : FaceDefect (Fin 2) := ![0, 1]

/-- Each boundary edge occurs twice in the sum of the two faces, hence the
two-face sum is closed modulo two. -/
theorem doubleSquareFaceCycle_closed :
    IsClosedFaceCycle doubleSquareBoundary doubleSquareFaceCycle := by
  funext e
  change (1 : ZMod 2) + 1 = 0
  exact ZMod.natCast_self 2

/-- The closed two-face cycle evaluates to one on the mismatched defect. -/
theorem doubleSquareMismatch_pairing :
    defectPairing doubleSquareFaceCycle doubleSquareMismatch = 1 := by
  norm_num [defectPairing, doubleSquareFaceCycle, doubleSquareMismatch,
    dotProduct, Fin.sum_univ_two]

/-- The mismatch has a concrete nonzero obstruction certificate. -/
theorem doubleSquareMismatch_detected :
    HasDetectedObstruction doubleSquareBoundary doubleSquareMismatch := by
  exact ⟨doubleSquareFaceCycle, doubleSquareFaceCycle_closed,
    by rw [doubleSquareMismatch_pairing]; norm_num⟩

/-- **Generic-cochain nonvacuity control.** No shared four-edge sign correction
can produce defects zero and one on the two glued square faces. -/
theorem doubleSquareMismatch_not_correctable :
    ¬ Correctable doubleSquareBoundary doubleSquareMismatch := by
  exact not_correctable_of_detectedObstruction
    doubleSquareBoundary doubleSquareMismatch doubleSquareMismatch_detected

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction.defectPairing_eq_zero_of_correctable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms defectPairing_eq_zero_of_correctable

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction.not_correctable_of_detectedObstruction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_correctable_of_detectedObstruction

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction.correctable_iff_forall_closedCycle_pairing_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctable_iff_forall_closedCycle_pairing_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction.correctable_iff_not_detectedObstruction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctable_iff_not_detectedObstruction

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction.doubleSquareMismatch_not_correctable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubleSquareMismatch_not_correctable

end PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction
