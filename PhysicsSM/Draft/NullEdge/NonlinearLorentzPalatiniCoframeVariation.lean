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

/-- Reversing the curvature plaquette reverses the polarized complementary
coframe coefficient. -/
theorem complementaryPalatiniFaceWeightFirstVariation_swap
    (coframe variation : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation coframe variation b a =
      fun component =>
        -complementaryPalatiniFaceWeightFirstVariation
          coframe variation a b component := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  have hSum :
      Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            spacetimeAlternatingSymbol c d b a *
              palatiniFaceWeightFirstVariation
                coframe variation c d component)) =
        -Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            spacetimeAlternatingSymbol c d a b *
              palatiniFaceWeightFirstVariation
                coframe variation c d component)) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro c _
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro d _
    rw [spacetimeAlternatingSymbol_swap_last c d a b]
    ring
  rw [hSum]
  ring

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

/-- The pointwise polarized complementary coframe field is antisymmetric in
its ordered plaquette directions. -/
theorem coframeFaceWeightFirstVariation_isAntisymmetric
    {Site : Type*} (coframe variation : CoframeField Site) :
    IsAntisymmetricFaceWeight
      (coframeFaceWeightFirstVariation coframe variation) := by
  intro site a b component
  exact congrFun
    (complementaryPalatiniFaceWeightFirstVariation_swap
      (coframe site) (variation site) b a) component

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

/-- Identity links make every local coframe Euler coefficient vanish, for any
coframe field.  This is the pointwise form of the flat-plaquette control. -/
theorem nonlinearCoframeEulerCoefficient_identityConnection
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (site : Site) (internal direction : Fin 4) :
    nonlinearCoframeEulerCoefficient shift (identityConnection Site) coframe
      site internal direction = 0 := by
  simp [nonlinearCoframeEulerCoefficient,
    nonlinearCoframeLocalEulerLinearMap,
    nonlinearCoframeLocalEulerFunctional, orderedPlaquetteActionTerm,
    plaquetteUnit, plaquetteHolonomy, twoStepTransport,
    identityConnection, unitMatrix]

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
