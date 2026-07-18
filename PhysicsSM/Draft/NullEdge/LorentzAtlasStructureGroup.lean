import PhysicsSM.Draft.NullEdge.LorentzComponentCharacter

/-!
# Lorentz atlas structure group

`CarrierProbeOverlapTransition.lean` produces concrete four-by-four matrices
and `LorentzComponentCharacter.lean` proves that their determinant and
time-orientation signs are multiplicative.  This module packages the missing
group-level bridge.

The eta-preserving matrices are bundled as a subgroup of `GL(4, Real)`.
Eta-orthogonality itself supplies the inverse `eta * M.transpose * eta`, so the
lift from a graph-derived transition matrix needs no extra invertibility
hypothesis.  The determinant and time signs then become honest homomorphisms
to `Multiplicative (ZMod 2)`, ready for the generic Cech obstruction algebra in
`AtlasComponentCharacter.lean`.

The two characters are independent.  Their simultaneous kernels are exactly
the proper-orthochronous, or restricted, Lorentz component.  This is finite
structure-group algebra only: the graph still owes a rank-four selector,
triviality of both global component classes, a concrete spin lift, curvature
convergence, and Einstein dynamics.

Claim grade: `M [orig/comp]`, finite matrix and group algebra only.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup

open Matrix
open PhysicsSM.Draft.NullEdge.AtlasComponentCharacter
open PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.LorentzComponentCharacter

noncomputable section

/-- The eta-adjoint of a concrete four-by-four matrix. -/
def etaAdjoint (M : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  MinkowskiConvention.eta * M.transpose * MinkowskiConvention.eta

/-- Eta-orthogonality makes the eta-adjoint a left inverse. -/
theorem etaAdjoint_mul
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    etaAdjoint M * M = 1 := by
  calc
    etaAdjoint M * M =
        MinkowskiConvention.eta *
          (M.transpose * MinkowskiConvention.eta * M) := by
      simp [etaAdjoint, Matrix.mul_assoc]
    _ = MinkowskiConvention.eta * MinkowskiConvention.eta := by
      rw [hM]
    _ = 1 := MinkowskiConvention.eta_mul_eta

/-- Over finite square matrices, the same eta-adjoint is also a right inverse. -/
theorem mul_etaAdjoint
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    M * etaAdjoint M = 1 := by
  exact mul_eq_one_comm.mp (etaAdjoint_mul M hM)

/-- Eta-orthogonality alone canonically supplies a unit matrix. -/
def matrixUnitOfIsEtaLorentz
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    GL (Fin 4) Real where
  val := M
  inv := etaAdjoint M
  val_inv := mul_etaAdjoint M hM
  inv_val := etaAdjoint_mul M hM

@[simp]
theorem coe_matrixUnitOfIsEtaLorentz
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    (matrixUnitOfIsEtaLorentz M hM : Matrix (Fin 4) (Fin 4) Real) = M := by
  rfl

/-- Eta-preserving invertible four-by-four real matrices. -/
def EtaLorentzGroup : Subgroup (GL (Fin 4) Real) where
  carrier := {g | IsEtaLorentz (g : Matrix (Fin 4) (Fin 4) Real)}
  one_mem' := by
    simp [IsEtaLorentz]
  mul_mem' := by
    intro g h hg hh
    change IsEtaLorentz
      ((g : Matrix (Fin 4) (Fin 4) Real) *
        (h : Matrix (Fin 4) (Fin 4) Real))
    exact isEtaLorentz_mul _ _ hg hh
  inv_mem' := by
    intro g hg
    let A : Matrix (Fin 4) (Fin 4) Real := g
    let B : Matrix (Fin 4) (Fin 4) Real :=
      ((g⁻¹ : GL (Fin 4) Real) : Matrix (Fin 4) (Fin 4) Real)
    have hAB : A * B = 1 := by
      change (g : Matrix (Fin 4) (Fin 4) Real) *
        ((g⁻¹ : GL (Fin 4) Real) : Matrix (Fin 4) (Fin 4) Real) = 1
      exact congrArg
        (fun u : GL (Fin 4) Real =>
          (u : Matrix (Fin 4) (Fin 4) Real))
        (mul_inv_cancel g)
    change IsEtaLorentz
      (((g⁻¹ : GL (Fin 4) Real) : Matrix (Fin 4) (Fin 4) Real))
    change IsEtaLorentz B
    unfold IsEtaLorentz
    calc
      B.transpose * MinkowskiConvention.eta * B =
          B.transpose *
            ((A.transpose * MinkowskiConvention.eta) * A) * B := by
        rw [hg]
      _ = (B.transpose * A.transpose) * MinkowskiConvention.eta *
          (A * B) := by
        simp only [Matrix.mul_assoc]
      _ = (A * B).transpose * MinkowskiConvention.eta * (A * B) := by
        rw [Matrix.transpose_mul]
      _ = MinkowskiConvention.eta := by
        rw [hAB]
        simp

/-- The underlying concrete matrix of a bundled eta-Lorentz element. -/
def toMatrix (g : EtaLorentzGroup) : Matrix (Fin 4) (Fin 4) Real :=
  (g.1 : Matrix (Fin 4) (Fin 4) Real)

@[simp]
theorem toMatrix_one : toMatrix (1 : EtaLorentzGroup) = 1 := by
  rfl

@[simp]
theorem toMatrix_mul (g h : EtaLorentzGroup) :
    toMatrix (g * h) = toMatrix g * toMatrix h := by
  rfl

/-- Every bundled element satisfies the eta-Lorentz identity. -/
theorem toMatrix_isEtaLorentz (g : EtaLorentzGroup) :
    IsEtaLorentz (toMatrix g) := by
  exact g.property

/-- Canonical lift of any eta-preserving matrix into the structure group. -/
def ofMatrix (M : Matrix (Fin 4) (Fin 4) Real)
    (hM : IsEtaLorentz M) : EtaLorentzGroup :=
  ⟨matrixUnitOfIsEtaLorentz M hM, by simpa using hM⟩

@[simp]
theorem toMatrix_ofMatrix
    (M : Matrix (Fin 4) (Fin 4) Real) (hM : IsEtaLorentz M) :
    toMatrix (ofMatrix M hM) = M := by
  rfl

/-- Time orientation as a group character. -/
def timeCharacter : MonoidHom EtaLorentzGroup ComponentGroup where
  toFun g := Multiplicative.ofAdd (timeSign (toMatrix g))
  map_one' := by
    change timeSign (1 : Matrix (Fin 4) (Fin 4) Real) = 0
    exact componentSigns_one.1
  map_mul' := by
    intro g h
    change timeSign (toMatrix g * toMatrix h) =
      timeSign (toMatrix g) + timeSign (toMatrix h)
    exact timeSign_mul _ _ g.property h.property

/-- Determinant orientation as a group character. -/
def determinantCharacter : MonoidHom EtaLorentzGroup ComponentGroup where
  toFun g := Multiplicative.ofAdd (determinantSign (toMatrix g))
  map_one' := by
    change determinantSign (1 : Matrix (Fin 4) (Fin 4) Real) = 0
    exact componentSigns_one.2
  map_mul' := by
    intro g h
    change determinantSign (toMatrix g * toMatrix h) =
      determinantSign (toMatrix g) + determinantSign (toMatrix h)
    exact determinantSign_mul _ _ g.property h.property

/-- The time character is trivial exactly on the future-preserving component. -/
theorem timeCharacter_eq_one_iff (g : EtaLorentzGroup) :
    timeCharacter g = 1 <-> 0 <= toMatrix g 0 0 := by
  by_cases htime : 0 <= toMatrix g 0 0 <;>
    simp [timeCharacter, timeSign, htime]

/-- The determinant character is trivial exactly on the nonnegative
determinant component. -/
theorem determinantCharacter_eq_one_iff (g : EtaLorentzGroup) :
    determinantCharacter g = 1 <-> 0 <= (toMatrix g).det := by
  by_cases hdet : 0 <= (toMatrix g).det <;>
    simp [determinantCharacter, determinantSign, hdet]

/-- The simultaneous kernels of the two component characters are exactly the
proper-orthochronous Lorentz component. -/
theorem isRestricted_iff_characters_eq_one (g : EtaLorentzGroup) :
    IsRestrictedLorentz (toMatrix g) <->
      determinantCharacter g = 1 /\ timeCharacter g = 1 := by
  constructor
  · rintro ⟨_, hproper, htime⟩
    constructor
    · apply (determinantCharacter_eq_one_iff g).mpr
      rw [hproper]
      norm_num
    · exact (timeCharacter_eq_one_iff g).mpr htime
  · rintro ⟨hdet, htime⟩
    refine ⟨g.property, ?_, (timeCharacter_eq_one_iff g).mp htime⟩
    exact isProper_of_det_nonnegative (toMatrix g) g.property
      ((determinantCharacter_eq_one_iff g).mp hdet)

/-- The proper-orthochronous Lorentz group, bundled as the simultaneous kernel
of the determinant and time component characters. -/
def RestrictedLorentzGroup : Subgroup EtaLorentzGroup where
  carrier := {g | determinantCharacter g = 1 /\ timeCharacter g = 1}
  one_mem' := by simp
  mul_mem' := by
    intro g h hg hh
    constructor
    · simp [map_mul, hg.1, hh.1]
    · simp [map_mul, hg.2, hh.2]
  inv_mem' := by
    intro g hg
    constructor
    · simp [hg.1]
    · simp [hg.2]

/-- Membership in the bundled restricted group is exactly the existing matrix
predicate for the proper-orthochronous component. -/
theorem mem_restrictedLorentzGroup_iff (g : EtaLorentzGroup) :
    g ∈ RestrictedLorentzGroup <-> IsRestrictedLorentz (toMatrix g) := by
  exact (isRestricted_iff_characters_eq_one g).symm

/-- Apply the time-orientation character to every Lorentz atlas transition. -/
def timeComponentTransition {I : Type*}
    (T : TransitionField I EtaLorentzGroup) :
    TransitionField I ComponentGroup :=
  componentTransition timeCharacter T

/-- Apply the determinant-orientation character to every Lorentz atlas
transition. -/
def determinantComponentTransition {I : Type*}
    (T : TransitionField I EtaLorentzGroup) :
    TransitionField I ComponentGroup :=
  componentTransition determinantCharacter T

/-- Every exact eta-Lorentz Cech atlas induces an exact time-orientation
component cocycle. -/
theorem timeComponentTransition_isCech {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : TransitionField I EtaLorentzGroup}
    (S : IsCechTransition pairOverlap tripleOverlap T) :
    IsCechTransition pairOverlap tripleOverlap
      (timeComponentTransition T) := by
  exact componentTransition_isCech S timeCharacter

/-- Every exact eta-Lorentz Cech atlas induces an exact determinant-orientation
component cocycle. -/
theorem determinantComponentTransition_isCech {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : TransitionField I EtaLorentzGroup}
    (S : IsCechTransition pairOverlap tripleOverlap T) :
    IsCechTransition pairOverlap tripleOverlap
      (determinantComponentTransition T) := by
  exact componentTransition_isCech S determinantCharacter

end


end PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.etaAdjoint_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.etaAdjoint_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.isRestricted_iff_characters_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.isRestricted_iff_characters_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.mem_restrictedLorentzGroup_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.mem_restrictedLorentzGroup_iff

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.timeComponentTransition_isCech' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup.timeComponentTransition_isCech
