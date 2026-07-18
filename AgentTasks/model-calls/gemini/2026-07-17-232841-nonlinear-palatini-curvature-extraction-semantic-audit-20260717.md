# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-17T23:27:47`
- Finished: `2026-07-17T23:28:41`
- Timeout seconds: `600`
- Max output tokens: `8192`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
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


Ignore the failed Claude response at the end of the packet. Perform the requested independent semantic audit from the embedded verbatim Lean sources. Use the exact required output structure in the packet.
```

## Extracted response text

```text
_{MNKL} = -2 (\delta^I_M \delta^J_N - \delta^I_N \delta^J_M)$.
Let's check: $I=0, J=1, M=0, N=1$.
$\epsilon^{01KL} \epsilon_{01KL} = \epsilon^{0123}\epsilon_{0123} + \epsilon^{0132}\epsilon_{0132} = (-1)(1) + (1)(-1) = -2$.
Formula gives $-2 (1 - 0) = -2$. Matches.
So `palatiniDensity` $= \frac{1}{2} \det(E) \sum_{a,b} (-2) (\delta^I_M \delta^J_N - \delta^I_N \delta^J_M) E^a_I E^b_J R_{ab}^{MN}$
$= -\det(E) \sum_{a,b} (E^a_M E^b_N - E^a_N E^b_M) R_{ab}^{MN}$
$= -\det(E) \sum_{a,b} (E^a_M E^b_N R_{ab}^{MN} - E^a_N E^b_M R_{ab}^{MN})$.
Since $R_{ab}^{MN}$ is antisymmetric in $M,N$, this is $-2 \det(E) \sum_{
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "_{MNKL} = -2 (\\delta^I_M \\delta^J_N - \\delta^I_N \\delta^J_M)$.\nLet's check: $I=0, J=1, M=0, N=1$.\n$\\epsilon^{01KL} \\epsilon_{01KL} = \\epsilon^{0123}\\epsilon_{0123} + \\epsilon^{0132}\\epsilon_{0132} = (-1)(1) + (1)(-1) = -2$.\nFormula gives $-2 (1 - 0) = -2$. Matches.\nSo `palatiniDensity` $= \\frac{1}{2} \\det(E) \\sum_{a,b} (-2) (\\delta^I_M \\delta^J_N - \\delta^I_N \\delta^J_M) E^a_I E^b_J R_{ab}^{MN}$\n$= -\\det(E) \\sum_{a,b} (E^a_M E^b_N - E^a_N E^b_M) R_{ab}^{MN}$\n$= -\\det(E) \\sum_{a,b} (E^a_M E^b_N R_{ab}^{MN} - E^a_N E^b_M R_{ab}^{MN})$.\nSince $R_{ab}^{MN}$ is antisymmetric in $M,N$, this is $-2 \\det(E) \\sum_{",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 16130,
    "candidatesTokenCount": 328,
    "totalTokenCount": 24318,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 16130
      }
    ],
    "thoughtsTokenCount": 7860,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "4hxbasX0EIGX-8YPhovnQQ"
}
```

## Error

```text

```
