# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-17T23:27:13`
- Finished: `2026-07-17T23:27:21`
- Timeout seconds: `600`
- Max budget USD: `2.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are independently auditing a speculative but convention-locked finite null-edge Palatini derivation. The concrete action is S(e,U)=sum_{x,a,b}[-1/2 tr(hat(B_ab(e))(H_ab(U)-I))], with B_ab the complementary Hodge coframe face. Lean now proves ordinary link and coframe derivatives, six plus sixteen local coefficients, and constructs the unique six-vector Krein-dual to each ordered holonomy trace functional; antisymmetrization in a,b leaves the full action unchanged. Intended reading: this extracted field is exactly the action-visible Lorentz-bivector curvature coordinate field, but is NOT yet claimed to be continuum Riemann curvature. Two Aristotle targets then seek (1) PalatiniDensity=-det(e) ScalarCurvature and (2) the coframe response equals det(e) times the coframe-index form of 2 Ric^d_c-delta^d_c R. Review the verbatim Lean for semantic alignment, vacuity, hidden assumptions, false shape, sign/factor/index errors, and prose outrunning the kernel. Check whether the extraction theorem is genuinely nontrivial and whether antisymmetrizing is mathematically legitimate for the summed action. Check the two Aristotle target statements independently for convention consistency and whether they suffice, once proved, to identify the sixteen coframe Euler equations with the vacuum mixed Einstein equation at nondegenerate coframe. Do not edit files. Required output: findings ordered by severity with exact declaration/file references; then a concise verdict; then the smallest next theorem needed after the two targets. Clearly distinguish kernel facts from your inferences.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurvatureExtraction.lean (316 lines)

```lean
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

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCoframeVariation.lean (640 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

noncomputable section

/-!
# Coframe variation of the nonlinear Lorentz Palatini action

The nonlinear ordered-holonomy action already has an exact connection
derivative.  This module differentiates the same scalar action in its coframe
argument.  Since the complementary Palatini face is quadratic in the coframe,
the line `e + t delta e` gives the exact expansion

`S(e + t delta e, U) = S(e,U) + t delta_e S + t^2 S(delta e,U)`.

Consequently the displayed first response is an ordinary derivative, not a
renamed formal functional.  The response is reorganized sitewise, expanded in
the sixteen matrix-entry probes of each local tetrad, and combined with the
six link Euler coefficients from the connection variation.

## Scope and provenance

This is an exact finite first-order Palatini identity for the concrete
coframe/holonomy action.  It supplies both partial Euler systems of one action.
It does not yet identify the sixteen tetrad coefficients with a reconstructed
Einstein tensor; that requires the curvature-contraction bridge and an
invertible coframe.  The quadratic tetrad variation is standard `[import]`;
the finite ordered-face coefficient extraction is `[orig/comp]`.  Claim label:
finite identity.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

/-- A weighted finite double sum distributes over addition. -/
theorem weightedDoubleSum_add
    {I J : Type*} [Fintype I] [Fintype J]
    (weight left right : I -> J -> Real) :
    Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * (left i j + right i j))) =
      Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * left i j)) +
      Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * right i j)) := by
  simp only [mul_add, Finset.sum_add_distrib]

/-- A weighted finite double sum commutes with real scaling. -/
theorem weightedDoubleSum_smul
    {I J : Type*} [Fintype I] [Fintype J]
    (weight field : I -> J -> Real) (scalar : Real) :
    Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * (scalar * field i j))) =
      scalar * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j => weight i j * field i j)) := by
  calc
    _ = Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
          scalar * (weight i j * field i j))) := by
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = _ := by simp only [Finset.mul_sum]

/-- Exact quadratic-line expansion under a weighted finite double sum. -/
theorem weightedDoubleSum_line
    {I J : Type*} [Fintype I] [Fintype J]
    (weight base response quadratic : I -> J -> Real) (t : Real) :
    Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j *
          (base i j + t * response i j + t ^ 2 * quadratic i j))) =
      Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * base i j)) +
      t * Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * response i j)) +
      t ^ 2 * Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * quadratic i j)) := by
  calc
    _ = Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
          weight i j * base i j +
            t * (weight i j * response i j) +
            t ^ 2 * (weight i j * quadratic i j))) := by
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = _ := by simp only [Finset.sum_add_distrib, Finset.mul_sum]

/-- Polarized first variation of the internal bivector formed by two coframe
columns. -/
def coframeWedgeFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  fun component =>
    variation (bivectorFirst component) a *
        coframe (bivectorSecond component) b +
      coframe (bivectorFirst component) a *
        variation (bivectorSecond component) b -
      variation (bivectorFirst component) b *
        coframe (bivectorSecond component) a -
      coframe (bivectorFirst component) b *
        variation (bivectorSecond component) a

/-- Exact quadratic expansion of one coframe wedge along an affine line. -/
theorem coframeWedge_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) (t : Real) :
    coframeWedge (coframe + t • variation) a b =
      coframeWedge coframe a b +
        t • coframeWedgeFirstVariation coframe variation a b +
        t ^ 2 • coframeWedge variation a b := by
  funext component
  simp [coframeWedge, coframeWedgeFirstVariation]
  ring

/-- The polarized coframe wedge is additive in its variation. -/
theorem coframeWedgeFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedgeFirstVariation coframe (left + right) a b =
      coframeWedgeFirstVariation coframe left a b +
        coframeWedgeFirstVariation coframe right a b := by
  funext component
  simp [coframeWedgeFirstVariation]
  ring

/-- The polarized coframe wedge respects scaling of its variation. -/
theorem coframeWedgeFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (a b : Fin 4) :
    coframeWedgeFirstVariation coframe (scalar • probe) a b =
      scalar • coframeWedgeFirstVariation coframe probe a b := by
  funext component
  simp [coframeWedgeFirstVariation]
  ring

/-- Hodge-dualized first variation of one internal coframe face. -/
def palatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  transportApply lorentzHodgeStar
    (coframeWedgeFirstVariation coframe variation a b)

/-- Matrix transport is additive in the transported fiber. -/
theorem transportApply_add_local
    (transport : Matrix (Fin 6) (Fin 6) Real) (left right : Fiber 6) :
    transportApply transport (left + right) =
      transportApply transport left + transportApply transport right := by
  funext component
  simp [transportApply, Finset.sum_add_distrib, mul_add]

/-- Matrix transport respects real scalar multiplication of a fiber. -/
theorem transportApply_smul_local
    (transport : Matrix (Fin 6) (Fin 6) Real)
    (scalar : Real) (field : Fiber 6) :
    transportApply transport (scalar • field) =
      scalar • transportApply transport field := by
  funext component
  simp only [transportApply, Pi.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro index _
  ring

/-- Hodge-dualized face variation is additive in its coframe probe. -/
theorem palatiniFaceWeightFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    palatiniFaceWeightFirstVariation coframe (left + right) a b =
      palatiniFaceWeightFirstVariation coframe left a b +
        palatiniFaceWeightFirstVariation coframe right a b := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_add, transportApply_add_local]

/-- Hodge-dualized face variation respects scaling of its coframe probe. -/
theorem palatiniFaceWeightFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (a b : Fin 4) :
    palatiniFaceWeightFirstVariation coframe (scalar • probe) a b =
      scalar • palatiniFaceWeightFirstVariation coframe probe a b := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_smul, transportApply_smul_local]

/-- Exact quadratic expansion survives the linear internal Hodge star. -/
theorem palatiniFaceWeight_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) (t : Real) :
    palatiniFaceWeight (coframe + t • variation) a b =
      palatiniFaceWeight coframe a b +
        t • palatiniFaceWeightFirstVariation coframe variation a b +
        t ^ 2 • palatiniFaceWeight variation a b := by
  unfold palatiniFaceWeight palatiniFaceWeightFirstVariation
  rw [coframeWedge_line, transportApply_add_local,
    transportApply_add_local, transportApply_smul_local,
    transportApply_smul_local]

/-- Polarized first variation of the complementary curvature-face
coefficient. -/
noncomputable def complementaryPalatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  fun component =>
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          palatiniFaceWeightFirstVariation coframe variation c d component))

/-- The complementary face has the same exact quadratic line expansion. -/
theorem complementaryPalatiniFaceWeight_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) (t : Real) :
    complementaryPalatiniFaceWeight (coframe + t • variation) a b =
      complementaryPalatiniFaceWeight coframe a b +
        t • complementaryPalatiniFaceWeightFirstVariation coframe variation a b +
        t ^ 2 • complementaryPalatiniFaceWeight variation a b := by
  funext component
  unfold complementaryPalatiniFaceWeight
    complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeight_line]
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  rw [weightedDoubleSum_line]
  ring

/-- Pointwise complementary-face first variation of a coframe field. -/
def coframeFaceWeightFirstVariation
    {Site : Type*} (coframe variation : CoframeField Site) :
    FaceWeight Site 6 :=
  fun site a b => complementaryPalatiniFaceWeightFirstVariation
    (coframe site) (variation site) a b

/-- Affine coframe line used for the ordinary directional derivative. -/
def coframeLine {Site : Type*}
    (coframe variation : CoframeField Site) (t : Real) : CoframeField Site :=
  fun site => coframe site + t • variation site

/-- The pointwise coframe face field has an exact quadratic line expansion. -/
theorem coframeFaceWeight_line
    {Site : Type*} (coframe variation : CoframeField Site) (t : Real) :
    coframeFaceWeight (coframeLine coframe variation t) =
      coframeFaceWeight coframe +
        t • coframeFaceWeightFirstVariation coframe variation +
        t ^ 2 • coframeFaceWeight variation := by
  funext site a b
  exact complementaryPalatiniFaceWeight_line
    (coframe site) (variation site) a b t

/-- One ordered action term is additive in its face coefficient. -/
theorem orderedPlaquetteActionTerm_add_face
    (left right : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm (left + right) holonomy =
      orderedPlaquetteActionTerm left holonomy +
        orderedPlaquetteActionTerm right holonomy := by
  simp [orderedPlaquetteActionTerm, lorentzGenerator_add,
    Matrix.add_mul, Matrix.trace_add]
  ring

/-- One ordered action term respects scalar multiplication of its face. -/
theorem orderedPlaquetteActionTerm_smul_face
    (scalar : Real) (face : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm (scalar • face) holonomy =
      scalar * orderedPlaquetteActionTerm face holonomy := by
  simp [orderedPlaquetteActionTerm, lorentzGenerator_smul,
    Matrix.trace_smul]
  ring

/-- Exact face-line expansion of one ordered action term. -/
theorem orderedPlaquetteActionTerm_face_line
    (face response quadratic : Fiber 6) (holonomy : GL4) (t : Real) :
    orderedPlaquetteActionTerm
        (face + t • response + t ^ 2 • quadratic) holonomy =
      orderedPlaquetteActionTerm face holonomy +
        t * orderedPlaquetteActionTerm response holonomy +
        t ^ 2 * orderedPlaquetteActionTerm quadratic holonomy := by
  rw [orderedPlaquetteActionTerm_add_face,
    orderedPlaquetteActionTerm_add_face,
    orderedPlaquetteActionTerm_smul_face,
    orderedPlaquetteActionTerm_smul_face]

/-- Coframe partial response of the concrete nonlinear scalar action. -/
def nonlinearCoframePlaquetteCoframeFirstResponse
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) : Real :=
  nonlinearFacePlaquetteAction shift connection
    (coframeFaceWeightFirstVariation coframe variation)

/-- Exact quadratic expansion of the complete action along a coframe line. -/
theorem nonlinearCoframePlaquetteAction_coframeLine
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) (t : Real) :
    nonlinearCoframePlaquetteAction shift connection
        (coframeLine coframe variation t) =
      nonlinearCoframePlaquetteAction shift connection coframe +
        t * nonlinearCoframePlaquetteCoframeFirstResponse
          shift connection coframe variation +
        t ^ 2 * nonlinearCoframePlaquetteAction shift connection variation := by
  unfold nonlinearCoframePlaquetteAction
    nonlinearCoframePlaquetteCoframeFirstResponse
    nonlinearFacePlaquetteAction
  simp_rw [coframeFaceWeight_line, Pi.add_apply, Pi.smul_apply,
    orderedPlaquetteActionTerm_face_line]
  simp only [Finset.sum_add_distrib, Finset.mul_sum]

/-- The displayed coframe response is the ordinary derivative of the same
nonlinear holonomy action. -/
theorem hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) :
    HasDerivAt
      (fun t => nonlinearCoframePlaquetteAction shift connection
        (coframeLine coframe variation t))
      (nonlinearCoframePlaquetteCoframeFirstResponse
        shift connection coframe variation) 0 := by
  let base := nonlinearCoframePlaquetteAction shift connection coframe
  let response := nonlinearCoframePlaquetteCoframeFirstResponse
    shift connection coframe variation
  let quadratic := nonlinearCoframePlaquetteAction shift connection variation
  have hId : HasDerivAt (fun t : Real => t) 1 0 := hasDerivAt_id 0
  have hPolynomial : HasDerivAt
      (fun t : Real => base + t * response + t ^ 2 * quadratic)
      response 0 := by
    convert ((hasDerivAt_const (x := 0) base).add
      ((hId.mul_const response).add ((hId.pow 2).mul_const quadratic))) using 1
    · funext t
      simp
      ring
    · norm_num
  apply hPolynomial.congr_of_eventuallyEq
  filter_upwards with t
  simpa [base, response, quadratic] using
    nonlinearCoframePlaquetteAction_coframeLine
      shift connection coframe variation t

/-- Local coframe response at one site. -/
def nonlinearCoframeLocalEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      orderedPlaquetteActionTerm
        (complementaryPalatiniFaceWeightFirstVariation
          (coframe site) probe a b)
        (plaquetteUnit shift connection site a b)))

/-- The global coframe response is the sum of its site-local functionals. -/
theorem nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) :
    nonlinearCoframePlaquetteCoframeFirstResponse
        shift connection coframe variation =
      Finset.sum Finset.univ (fun site =>
        nonlinearCoframeLocalEulerFunctional shift connection coframe site
          (variation site)) := by
  unfold nonlinearCoframePlaquetteCoframeFirstResponse
    nonlinearFacePlaquetteAction nonlinearCoframeLocalEulerFunctional
    coframeFaceWeightFirstVariation
  exact sum_direction_direction_site_cycle _

/-- The polarized complementary face is additive in its coframe probe. -/
theorem complementaryPalatiniFaceWeightFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation
        coframe (left + right) a b =
      complementaryPalatiniFaceWeightFirstVariation coframe left a b +
        complementaryPalatiniFaceWeightFirstVariation coframe right a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeightFirstVariation_add, Pi.add_apply]
  rw [weightedDoubleSum_add]
  ring

/-- The polarized complementary face respects scalar multiplication of its
coframe probe. -/
theorem complementaryPalatiniFaceWeightFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation
        coframe (scalar • probe) a b =
      scalar • complementaryPalatiniFaceWeightFirstVariation
        coframe probe a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeightFirstVariation_smul, Pi.smul_apply]
  simp only [smul_eq_mul]
  rw [weightedDoubleSum_smul]
  ring

/-- The site-local coframe response is additive in its matrix probe. -/
theorem nonlinearCoframeLocalEulerFunctional_add
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (left right : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional shift connection coframe site
        (left + right) =
      nonlinearCoframeLocalEulerFunctional shift connection coframe site left +
        nonlinearCoframeLocalEulerFunctional shift connection coframe site right := by
  unfold nonlinearCoframeLocalEulerFunctional
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_add,
    orderedPlaquetteActionTerm_add_face]
  simp [Finset.sum_add_distrib]

/-- The site-local coframe response respects real scalar multiplication. -/
theorem nonlinearCoframeLocalEulerFunctional_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (scalar : Real)
    (probe : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional shift connection coframe site
        (scalar • probe) =
      scalar * nonlinearCoframeLocalEulerFunctional
        shift connection coframe site probe := by
  unfold nonlinearCoframeLocalEulerFunctional
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_smul,
    orderedPlaquetteActionTerm_smul_face]
  simp [Finset.mul_sum]

/-- Site-local coframe response as a real linear map on tetrad matrices. -/
def nonlinearCoframeLocalEulerLinearMap
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) :
    Matrix (Fin 4) (Fin 4) Real →ₗ[Real] Real where
  toFun := nonlinearCoframeLocalEulerFunctional
    shift connection coframe site
  map_add' := nonlinearCoframeLocalEulerFunctional_add
    shift connection coframe site
  map_smul' := nonlinearCoframeLocalEulerFunctional_smul
    shift connection coframe site

/-- One of the sixteen explicit local tetrad Euler coefficients. -/
def nonlinearCoframeEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (internal direction : Fin 4) : Real :=
  nonlinearCoframeLocalEulerLinearMap shift connection coframe site
    (Matrix.single internal direction 1)

/-- The local coframe functional is the coordinate pairing with its sixteen
Euler coefficients. -/
theorem nonlinearCoframeLocalEulerFunctional_eq_coordinateSum
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional shift connection coframe site probe =
      Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          nonlinearCoframeEulerCoefficient shift connection coframe site
            internal direction * probe internal direction)) := by
  let localMap := nonlinearCoframeLocalEulerLinearMap
    shift connection coframe site
  calc
    nonlinearCoframeLocalEulerFunctional shift connection coframe site probe =
        localMap probe := rfl
    _ = localMap (Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun direction =>
            Matrix.single internal direction (probe internal direction)))) := by
      rw [<- Matrix.matrix_eq_sum_single probe]
    _ = Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun direction =>
            localMap (Matrix.single internal direction
              (probe internal direction)))) := by
      rw [map_sum]
      apply Finset.sum_congr rfl
      intro internal _
      rw [map_sum]
    _ = Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun direction =>
            nonlinearCoframeEulerCoefficient shift connection coframe site
              internal direction * probe internal direction)) := by
      apply Finset.sum_congr rfl
      intro internal _
      apply Finset.sum_congr rfl
      intro direction _
      have hSingle :
          Matrix.single internal direction (probe internal direction) =
            probe internal direction •
              Matrix.single internal direction (1 : Real) := by
        simp
      rw [hSingle, map_smul]
      change probe internal direction *
          nonlinearCoframeEulerCoefficient shift connection coframe site
            internal direction = _
      ring

/-- Coframe variation supported on one site and one tetrad entry. -/
def nonlinearCoframeComponentProbe
    {Site : Type*} [DecidableEq Site]
    (site : Site) (internal direction : Fin 4) : CoframeField Site :=
  Pi.single site (Matrix.single internal direction 1)

/-- A supported coframe probe extracts one local tetrad Euler coefficient. -/
theorem nonlinearCoframePlaquetteCoframeFirstResponse_componentProbe
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (internal direction : Fin 4) :
    nonlinearCoframePlaquetteCoframeFirstResponse shift connection coframe
        (nonlinearCoframeComponentProbe site internal direction) =
      nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction := by
  rw [nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler]
  rw [Fintype.sum_eq_single site]
  · change nonlinearCoframeLocalEulerLinearMap shift connection coframe site
      (nonlinearCoframeComponentProbe site internal direction site) = _
    simp [nonlinearCoframeComponentProbe, nonlinearCoframeEulerCoefficient]
  · intro otherSite hOther
    change nonlinearCoframeLocalEulerLinearMap shift connection coframe
      otherSite (nonlinearCoframeComponentProbe site internal direction
        otherSite) = 0
    simp [nonlinearCoframeComponentProbe, hOther]

/-- Formal coframe stationarity of the nonlinear plaquette action. -/
def NonlinearCoframePlaquetteCoframeStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) : Prop :=
  forall variation,
    nonlinearCoframePlaquetteCoframeFirstResponse
      shift connection coframe variation = 0

/-- Coframe stationarity is exactly vanishing of all sixteen local tetrad
Euler coefficients. -/
theorem nonlinearCoframePlaquetteCoframeStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe <->
      forall site internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0 := by
  classical
  constructor
  · intro hStationary site internal direction
    rw [<- nonlinearCoframePlaquetteCoframeFirstResponse_componentProbe]
    exact hStationary _
  · intro hCoefficients variation
    rw [nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler]
    apply Finset.sum_eq_zero
    intro site _
    rw [nonlinearCoframeLocalEulerFunctional_eq_coordinateSum]
    apply Finset.sum_eq_zero
    intro internal _
    apply Finset.sum_eq_zero
    intro direction _
    rw [hCoefficients site internal direction, zero_mul]

/-- Ordinary derivative stationarity along all affine coframe lines is
equivalent to the sixteen local tetrad Euler equations. -/
theorem nonlinearCoframePlaquetteCoframeDerivativeStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    (forall variation,
      deriv (fun t => nonlinearCoframePlaquetteAction shift connection
        (coframeLine coframe variation t)) 0 = 0) <->
      forall site internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0 := by
  rw [<- nonlinearCoframePlaquetteCoframeStationary_iff_coefficients]
  constructor
  · intro hDerivative variation
    rw [<-
      (hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine
        shift connection coframe variation).deriv]
    exact hDerivative variation
  · intro hStationary variation
    rw [(hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine
      shift connection coframe variation).deriv]
    exact hStationary variation

/-- Both partial stationarity conditions of the same nonlinear coframe/link
action. -/
def NonlinearCoframePlaquetteJointStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) : Prop :=
  NonlinearCoframePlaquetteConnectionStationary shift connection coframe /\
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe

/-- Joint stationarity is the combined six-component link and sixteen-entry
tetrad Euler system of one concrete action. -/
theorem nonlinearCoframePlaquetteJointStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteJointStationary shift connection coframe <->
      (forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0) /\
      (forall site internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0) := by
  exact and_congr
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      shift connection coframe)
    (nonlinearCoframePlaquetteCoframeStationary_iff_coefficients
      shift connection coframe)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.nonlinearCoframePlaquetteAction_coframeLine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_coframeLine

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.nonlinearCoframePlaquetteCoframeStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteCoframeStationary_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.nonlinearCoframePlaquetteJointStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteJointStationary_iff_coefficients

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

```

### AgentTasks/aristotle-standalone/null-edge-palatini-density-einstein-20260717/PalatiniDensityEinstein/Target.lean (106 lines)

```lean
import Mathlib

noncomputable section

namespace PalatiniDensityEinstein

set_option maxHeartbeats 2000000

abbrev Fiber6 := Fin 6 -> Real

/-- Ordered internal bivector basis `(12,13,23,01,02,03)`. -/
def bivectorFirst : Fin 6 -> Fin 4
  | 0 => 1 | 1 => 1 | 2 => 2 | 3 => 0 | 4 => 0 | 5 => 0

def bivectorSecond : Fin 6 -> Fin 4
  | 0 => 2 | 1 => 3 | 2 => 3 | 3 => 1 | 4 => 2 | 5 => 3

/-- Internal bivector coordinates of two ordered coframe columns. -/
def coframeWedge (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    coframe (bivectorFirst component) a *
        coframe (bivectorSecond component) b -
      coframe (bivectorFirst component) b *
        coframe (bivectorSecond component) a

/-- Lorentz Hodge star in orientation `0123`. -/
def lorentzHodgeStar : Matrix (Fin 6) (Fin 6) Real :=
  !![0, 0, 0, 0, 0, -1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, -1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, -1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0]

def transportApply
    (transport : Matrix (Fin 6) (Fin 6) Real) (field : Fiber6) : Fiber6 :=
  fun i => Finset.sum Finset.univ (fun j => transport i j * field j)

def palatiniFaceWeight (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  transportApply lorentzHodgeStar (coframeWedge coframe a b)

/-- Four-dimensional alternating symbol with `epsilon 0 1 2 3 = +1`. -/
def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Complementary coframe coefficient of curvature face `(a,b)`. -/
def complementaryPalatiniFaceWeight
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) : Fiber6 :=
  fun component =>
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          palatiniFaceWeight coframe c d component))

/-- Mostly-minus Krein pairing on ordered bivector coordinates. -/
def kreinPair (left right : Fiber6) : Real :=
  left 0 * right 0 + left 1 * right 1 + left 2 * right 2 -
    left 3 * right 3 - left 4 * right 4 - left 5 * right 5

/-- Antisymmetric internal curvature matrix represented by six coordinates. -/
def curvatureMatrix (curvature : Fiber6) : Matrix (Fin 4) (Fin 4) Real :=
  !![0, curvature 3, curvature 4, curvature 5;
     -curvature 3, 0, curvature 0, curvature 1;
     -curvature 4, -curvature 0, 0, curvature 2;
     -curvature 5, -curvature 1, -curvature 2, 0]

/-- Ordered complementary-face Palatini density. -/
def palatiniDensity
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      kreinPair (complementaryPalatiniFaceWeight coframe a b)
        (curvature a b)))

/-- Scalar curvature obtained by inverse-coframe contraction of the internal
curvature face. -/
def scalarCurvature
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            curvatureMatrix (curvature a b) i j))))

/-- The complementary tetradic Palatini density is exactly minus the oriented
coframe determinant times the inverse-coframe scalar curvature. -/
theorem palatiniDensity_eq_neg_det_mul_scalarCurvature
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensity coframe curvature =
      -coframe.det * scalarCurvature inverseCoframe curvature := by
  sorry

end PalatiniDensityEinstein

```

### AgentTasks/aristotle-standalone/null-edge-palatini-coframe-einstein-20260717/PalatiniCoframeEinstein/Target.lean (145 lines)

```lean
import Mathlib

noncomputable section

namespace PalatiniCoframeEinstein

set_option maxHeartbeats 3000000

abbrev Fiber6 := Fin 6 -> Real

/-- Ordered internal bivector basis `(12,13,23,01,02,03)`. -/
def bivectorFirst : Fin 6 -> Fin 4
  | 0 => 1 | 1 => 1 | 2 => 2 | 3 => 0 | 4 => 0 | 5 => 0

def bivectorSecond : Fin 6 -> Fin 4
  | 0 => 2 | 1 => 3 | 2 => 3 | 3 => 1 | 4 => 2 | 5 => 3

/-- Internal bivector coordinates of two ordered coframe columns. -/
def coframeWedge (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    coframe (bivectorFirst component) a *
        coframe (bivectorSecond component) b -
      coframe (bivectorFirst component) b *
        coframe (bivectorSecond component) a

/-- Polarized first response of one coframe wedge. -/
def coframeWedgeFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    variation (bivectorFirst component) a *
        coframe (bivectorSecond component) b +
      coframe (bivectorFirst component) a *
        variation (bivectorSecond component) b -
      variation (bivectorFirst component) b *
        coframe (bivectorSecond component) a -
      coframe (bivectorFirst component) b *
        variation (bivectorSecond component) a

/-- Lorentz Hodge star in orientation `0123`. -/
def lorentzHodgeStar : Matrix (Fin 6) (Fin 6) Real :=
  !![0, 0, 0, 0, 0, -1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, -1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, -1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0]

def transportApply
    (transport : Matrix (Fin 6) (Fin 6) Real) (field : Fiber6) : Fiber6 :=
  fun i => Finset.sum Finset.univ (fun j => transport i j * field j)

def palatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  transportApply lorentzHodgeStar
    (coframeWedgeFirstVariation coframe variation a b)

/-- Four-dimensional alternating symbol with `epsilon 0 1 2 3 = +1`. -/
def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Polarized first response of the complementary coframe coefficient. -/
def complementaryPalatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          palatiniFaceWeightFirstVariation coframe variation c d component))

/-- Mostly-minus Krein pairing on ordered bivector coordinates. -/
def kreinPair (left right : Fiber6) : Real :=
  left 0 * right 0 + left 1 * right 1 + left 2 * right 2 -
    left 3 * right 3 - left 4 * right 4 - left 5 * right 5

/-- Antisymmetric internal curvature matrix represented by six coordinates. -/
def curvatureMatrix (curvature : Fiber6) : Matrix (Fin 4) (Fin 4) Real :=
  !![0, curvature 3, curvature 4, curvature 5;
     -curvature 3, 0, curvature 0, curvature 1;
     -curvature 4, -curvature 0, 0, curvature 2;
     -curvature 5, -curvature 1, -curvature 2, 0]

/-- Ordinary first coframe response of the ordered Palatini density. -/
def palatiniDensityFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      kreinPair
        (complementaryPalatiniFaceWeightFirstVariation
          coframe variation a b)
        (curvature a b)))

/-- Scalar curvature obtained by inverse-coframe contraction of the internal
curvature face. -/
def scalarCurvature
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            curvatureMatrix (curvature a b) i j))))

/-- Coframe-index form of twice the mixed Ricci tensor minus its scalar
trace. Multiplication by the coframe converts this to
`2 Ric^d_c - delta^d_c R`. -/
def mixedEinsteinCoframeCoefficient
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6)
    (internal direction : Fin 4) : Real :=
  2 * Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a internal * inverseCoframe direction i *
            inverseCoframe b j * curvatureMatrix (curvature a b) i j)))) -
    inverseCoframe direction internal *
      scalarCurvature inverseCoframe curvature

/-- The exact tetrad response of the ordered Palatini density is the
determinant-weighted mixed Einstein coefficient paired with the arbitrary
coframe variation. -/
theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (coframe inverseCoframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation coframe variation curvature =
      coframe.det * Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction * variation internal direction)) := by
  sorry

end PalatiniCoframeEinstein

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
