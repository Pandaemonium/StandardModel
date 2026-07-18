import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

noncomputable section

/-!
# Curvature extraction for the nonlinear Lorentz Palatini action

The exact plaquette action pairs each complementary coframe face with the
linear functional

`B |-> -1/2 tr(hat B (H - I))`.

Because the Lorentz bivector Krein form is nondegenerate, this functional has
a unique six-coordinate representative.  This module writes that
representative explicitly in the ordered project basis, antisymmetrizes it in
the two plaquette directions, and proves that the complete ordered action is
exactly the finite Palatini pairing with the resulting curvature field.

The extraction does not assert that `H - I` lies in the Lorentz Lie algebra.
It records precisely the six Lorentz-generator components probed by the
Palatini action.  Antisymmetrization changes no action value because the
complementary coframe face is already antisymmetric.

## Scope and provenance

These are exact finite-dimensional identities for arbitrary group-valued
links.  They provide the algebraic input expected by the determinant/scalar-
curvature bridge, but do not yet identify the extracted field with continuum
Riemann curvature or prove a continuum limit.  The dual-basis construction is
standard finite linear algebra `[import]`; its application to the exact
ordered null-edge plaquette action is `[orig/comp]`.  Claim label: finite
identity.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

/-- The standard coordinate probe in the ordered six-component bivector
fiber. -/
def bivectorCoordinateProbe (component : Fin 6) : Fiber 6 :=
  Pi.single component (1 : Real)

/-- The six Krein-dual coordinates of one exact plaquette holonomy as seen by
the Palatini trace action. -/
def orderedHolonomyCurvature (holonomy : GL4) : Fiber 6 :=
  fun component =>
    splitSixSign component *
      orderedPlaquetteActionTerm (bivectorCoordinateProbe component) holonomy

/-- A coordinate probe reads one Krein coordinate with its split-sign
factor. -/
theorem kreinPair_bivectorCoordinateProbe
    (component : Fin 6) (right : Fiber 6) :
    kreinPair lorentzBivectorFundamentalSymmetry
        (bivectorCoordinateProbe component) right =
      splitSixSign component * right component := by
  unfold kreinPair fiberPair transportApply bivectorCoordinateProbe
  rw [lorentzBivectorFundamentalSymmetry_matrix]
  simp [splitSixMatrix, Matrix.diagonal_apply, Pi.single_apply]

/-- One ordered trace term is the coordinate sum of its values on the six
standard bivector probes. -/
theorem orderedPlaquetteActionTerm_eq_coordinateSum
    (face : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm face holonomy =
      Finset.sum Finset.univ (fun component =>
        face component *
          orderedPlaquetteActionTerm
            (bivectorCoordinateProbe component) holonomy) := by
  let localMap : LinearMap (RingHom.id Real) (Fiber 6) Real :=
    { toFun := fun probe => orderedPlaquetteActionTerm probe holonomy
      map_add' := fun left right =>
        orderedPlaquetteActionTerm_add_face left right holonomy
      map_smul' := fun scalar probe => by
        change orderedPlaquetteActionTerm (scalar • probe) holonomy =
          scalar * orderedPlaquetteActionTerm probe holonomy
        exact orderedPlaquetteActionTerm_smul_face scalar probe holonomy }
  have hFace :
      face = Finset.sum Finset.univ (fun component =>
        face component • bivectorCoordinateProbe component) := by
    funext component
    simp [bivectorCoordinateProbe, Pi.single_apply]
  calc
    orderedPlaquetteActionTerm face holonomy = localMap face := rfl
    _ = localMap (Finset.sum Finset.univ (fun component =>
          face component • bivectorCoordinateProbe component)) := by
      rw [<- hFace]
    _ = Finset.sum Finset.univ (fun component =>
          localMap (face component • bivectorCoordinateProbe component)) := by
      exact map_sum localMap _ _
    _ = _ := by
      apply Finset.sum_congr rfl
      intro component _
      simp [localMap]

/-- The extracted six-vector is exactly Krein dual to the ordered trace
functional. -/
theorem orderedPlaquetteActionTerm_eq_kreinPair_curvature
    (face : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm face holonomy =
      kreinPair lorentzBivectorFundamentalSymmetry face
        (orderedHolonomyCurvature holonomy) := by
  rw [orderedPlaquetteActionTerm_eq_coordinateSum]
  unfold kreinPair fiberPair transportApply orderedHolonomyCurvature
  rw [lorentzBivectorFundamentalSymmetry_matrix]
  simp only [splitSixMatrix, Matrix.diagonal_apply]
  apply Finset.sum_congr rfl
  intro component _
  rw [Finset.sum_eq_single component]
  · rw [if_pos rfl]
    by_cases hPositive : component.val < 3 <;>
      simp [splitSixSign, hPositive]
  · intro other _ hOther
    rw [if_neg]
    · ring
    · exact Ne.symm hOther
  · intro hNotMem
    exact False.elim (hNotMem (Finset.mem_univ component))

/-- The extracted curvature is the unique six-vector representing the
ordered trace functional under the nondegenerate split-sign pairing. -/
theorem orderedHolonomyCurvature_unique
    (holonomy : GL4) (curvature : Fiber 6)
    (hRepresents : forall face,
      orderedPlaquetteActionTerm face holonomy =
        kreinPair lorentzBivectorFundamentalSymmetry face curvature) :
    curvature = orderedHolonomyCurvature holonomy := by
  funext component
  have hPair :
      kreinPair lorentzBivectorFundamentalSymmetry
          (bivectorCoordinateProbe component) curvature =
        kreinPair lorentzBivectorFundamentalSymmetry
          (bivectorCoordinateProbe component)
          (orderedHolonomyCurvature holonomy) := by
    rw [<- hRepresents]
    exact orderedPlaquetteActionTerm_eq_kreinPair_curvature _ _
  rw [kreinPair_bivectorCoordinateProbe,
    kreinPair_bivectorCoordinateProbe] at hPair
  by_cases hPositive : component.val < 3 <;>
    simpa [splitSixSign, hPositive] using hPair

/-- Pointwise antisymmetrization of a six-component ordered face field. -/
def antisymmetrizeFaceWeight
    {Site : Type*} (curvature : FaceWeight Site 6) : FaceWeight Site 6 :=
  fun site a b component =>
    (1 / 2 : Real) *
      (curvature site a b component - curvature site b a component)

/-- Antisymmetrization has the expected ordered-face orientation. -/
theorem antisymmetrizeFaceWeight_isAntisymmetric
    {Site : Type*} (curvature : FaceWeight Site 6) :
    IsAntisymmetricFaceWeight (antisymmetrizeFaceWeight curvature) := by
  intro site a b component
  unfold antisymmetrizeFaceWeight
  ring

/-- The raw exact-holonomy curvature coordinates on every ordered
plaquette. -/
def rawPlaquetteCurvature
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) : FaceWeight Site 6 :=
  fun site a b =>
    orderedHolonomyCurvature (plaquetteUnit shift connection site a b)

/-- The oriented curvature field extracted from the exact group
plaquettes. -/
def extractedPlaquetteCurvature
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) : FaceWeight Site 6 :=
  antisymmetrizeFaceWeight (rawPlaquetteCurvature shift connection)

/-- The extracted exact-plaquette curvature is antisymmetric in its two
spacetime directions. -/
theorem extractedPlaquetteCurvature_isAntisymmetric
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) :
    IsAntisymmetricFaceWeight
      (extractedPlaquetteCurvature shift connection) := by
  exact antisymmetrizeFaceWeight_isAntisymmetric _

/-- Scaling the right input scales the Krein pairing. -/
theorem kreinPair_smul_right
    {n : Nat} (fundamental : FundamentalSymmetry n)
    (left right : Fiber n) (scalar : Real) :
    kreinPair fundamental left (scalar • right) =
      scalar * kreinPair fundamental left right := by
  unfold kreinPair fiberPair
  simp only [Pi.smul_apply, smul_eq_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro component _
  ring

/-- Negating the left input negates the Krein pairing. -/
theorem kreinPair_neg_left
    {n : Nat} (fundamental : FundamentalSymmetry n)
    (left right : Fiber n) :
    kreinPair fundamental (-left) right =
      -kreinPair fundamental left right := by
  unfold kreinPair fiberPair transportApply
  simp only [Pi.neg_apply, mul_neg, Finset.sum_neg_distrib, neg_mul]

/-- Pairing an antisymmetric face with a face field depends only on the
antisymmetric part of the latter. -/
theorem orderedKreinSum_antisymmetrize
    {Site : Type*} [Fintype Site]
    (face curvature : FaceWeight Site 6)
    (hFace : IsAntisymmetricFaceWeight face) :
    Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            kreinPair lorentzBivectorFundamentalSymmetry
              (face site a b) (curvature site a b)))) =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            kreinPair lorentzBivectorFundamentalSymmetry
              (face site a b) (antisymmetrizeFaceWeight curvature site a b)))) := by
  let direct := Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        kreinPair lorentzBivectorFundamentalSymmetry
          (face site a b) (curvature site a b))))
  let reversed := Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        kreinPair lorentzBivectorFundamentalSymmetry
          (face site a b) (curvature site b a))))
  have hReversed : reversed = -direct := by
    unfold reversed direct
    rw [Finset.sum_comm]
    rw [<- Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro a _
    rw [<- Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro b _
    rw [<- Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro site _
    have hSwap : face site b a = -(face site a b) := by
      funext component
      exact hFace site b a component
    rw [hSwap, kreinPair_neg_left]
  change direct = _
  simp_rw [show antisymmetrizeFaceWeight curvature = fun site a b =>
      (1 / 2 : Real) •
        (fun component => curvature site a b component -
          curvature site b a component) by
    funext site a b component
    simp [antisymmetrizeFaceWeight]]
  simp_rw [kreinPair_smul_right, kreinPair_sub_right]
  simp only [Finset.sum_sub_distrib, <- Finset.mul_sum]
  change direct = (1 / 2 : Real) * (direct - reversed)
  rw [hReversed]
  ring

/-- The finite Palatini pairing of the complementary coframe face with the
curvature extracted from the exact plaquettes. -/
def extractedCurvaturePalatiniAction
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        kreinPair lorentzBivectorFundamentalSymmetry
          (coframeFaceWeight coframe site a b)
          (extractedPlaquetteCurvature shift connection site a b))))

/-- The concrete nonlinear holonomy action is exactly the Palatini action of
its extracted antisymmetric six-component curvature field. -/
theorem nonlinearCoframePlaquetteAction_eq_extractedCurvaturePalatiniAction
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    nonlinearCoframePlaquetteAction shift connection coframe =
      extractedCurvaturePalatiniAction shift connection coframe := by
  unfold nonlinearCoframePlaquetteAction nonlinearFacePlaquetteAction
    extractedCurvaturePalatiniAction extractedPlaquetteCurvature
    rawPlaquetteCurvature
  simp_rw [orderedPlaquetteActionTerm_eq_kreinPair_curvature]
  exact orderedKreinSum_antisymmetrize
    (coframeFaceWeight coframe)
    (fun site a b =>
      orderedHolonomyCurvature (plaquetteUnit shift connection site a b))
    (coframeFaceWeight_isAntisymmetric coframe)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction.orderedPlaquetteActionTerm_eq_kreinPair_curvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms orderedPlaquetteActionTerm_eq_kreinPair_curvature

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction.orderedHolonomyCurvature_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms orderedHolonomyCurvature_unique

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction.extractedPlaquetteCurvature_isAntisymmetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extractedPlaquetteCurvature_isAntisymmetric

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction.nonlinearCoframePlaquetteAction_eq_extractedCurvaturePalatiniAction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_eq_extractedCurvaturePalatiniAction

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
