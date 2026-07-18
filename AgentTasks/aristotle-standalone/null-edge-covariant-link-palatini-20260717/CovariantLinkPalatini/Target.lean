import Mathlib

/-!
# Covariant link/face Palatini adjoint target

Focused Aristotle target for the next null-edge gravity bridge.  A fiber field
is transported forward by a real link matrix.  The proposed backward operator
uses the algebraic transpose at the predecessor link.  The two target theorems
ask for exact periodic summation by parts and the resulting ordered-link Euler
pairing for an oriented face curl.

This is an ordinary Euclidean fiber pairing.  A later Lorentzian application
must replace transpose by the convention-appropriate Krein adjoint and prove
the corresponding compatibility statement.
-/

namespace CovariantLinkPalatini

variable {Site : Type*} [Fintype Site] [DecidableEq Site]
variable {n : Nat}

abbrev Fiber (n : Nat) := Fin n -> Real

abbrev LinkPotential (Site : Type*) (n : Nat) :=
  Site -> Fin 4 -> Fiber n

abbrev FaceWeight (Site : Type*) (n : Nat) :=
  Site -> Fin 4 -> Fin 4 -> Fiber n

abbrev LinkTransport (Site : Type*) (n : Nat) :=
  Site -> Fin 4 -> Matrix (Fin n) (Fin n) Real

def fiberPair (left right : Fiber n) : Real :=
  Finset.sum Finset.univ (fun i => left i * right i)

def transportApply
    (transport : Matrix (Fin n) (Fin n) Real) (field : Fiber n) : Fiber n :=
  fun i => Finset.sum Finset.univ (fun j => transport i j * field j)

def transportAdjointApply
    (transport : Matrix (Fin n) (Fin n) Real) (covector : Fiber n) : Fiber n :=
  fun j => Finset.sum Finset.univ (fun i => transport i j * covector i)

/-- The adjoint action of the identity matrix is the identity. -/
theorem transportAdjointApply_one (covector : Fiber n) :
    transportAdjointApply (1 : Matrix (Fin n) (Fin n) Real) covector =
      covector := by
  funext j
  simp [transportAdjointApply, Matrix.one_apply]

/-- Ordinary matrix transpose is adjoint for the finite Euclidean component
pairing. -/
theorem fiberPair_transportApply
    (transport : Matrix (Fin n) (Fin n) Real) (left right : Fiber n) :
    fiberPair left (transportApply transport right) =
      fiberPair (transportAdjointApply transport left) right := by
  unfold fiberPair transportApply transportAdjointApply
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro j _
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- The finite component pairing distributes over subtraction in its right
argument. -/
theorem fiberPair_sub_right (left right right' : Fiber n) :
    fiberPair left (fun i => right i - right' i) =
      fiberPair left right - fiberPair left right' := by
  unfold fiberPair
  simp only [mul_sub, Finset.sum_sub_distrib]

/-- The finite component pairing distributes over subtraction in its left
argument. -/
theorem fiberPair_sub_left (left left' right : Fiber n) :
    fiberPair (fun i => left i - left' i) right =
      fiberPair left right - fiberPair left' right := by
  unfold fiberPair
  simp only [sub_mul, Finset.sum_sub_distrib]

def covariantForwardDifference
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (field : Site -> Fiber n) (site : Site) (direction : Fin 4) : Fiber n :=
  fun i =>
    transportApply (transport site direction) (field (shift direction site)) i -
      field site i

def covariantBackwardAdjoint
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (covector : Site -> Fiber n) (site : Site) (direction : Fin 4) : Fiber n :=
  fun i =>
    transportAdjointApply
        (transport ((shift direction).symm site) direction)
        (covector ((shift direction).symm site)) i -
      covector site i

omit [Fintype Site] [DecidableEq Site] in
/-- Pointwise forward-difference pairing before periodic site reindexing. -/
theorem fiberPair_covariantForwardDifference
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (weight field : Site -> Fiber n) (site : Site) (direction : Fin 4) :
    fiberPair (weight site)
        (covariantForwardDifference shift transport field site direction) =
      fiberPair
          (transportAdjointApply (transport site direction) (weight site))
          (field (shift direction site)) -
        fiberPair (weight site) (field site) := by
  unfold covariantForwardDifference
  rw [fiberPair_sub_right, fiberPair_transportApply]

omit [Fintype Site] [DecidableEq Site] in
/-- Pointwise backward-adjoint pairing after periodic site reindexing. -/
theorem fiberPair_covariantBackwardAdjoint
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (weight field : Site -> Fiber n) (site : Site) (direction : Fin 4) :
    fiberPair
        (covariantBackwardAdjoint shift transport weight site direction)
        (field site) =
      fiberPair
          (transportAdjointApply
            (transport ((shift direction).symm site) direction)
            (weight ((shift direction).symm site)))
          (field site) -
        fiberPair (weight site) (field site) := by
  unfold covariantBackwardAdjoint
  rw [fiberPair_sub_left]

omit [DecidableEq Site] in
/-- Exact periodic covariant summation by parts. -/
theorem sum_pair_covariantForwardDifference_periodic
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (weight field : Site -> Fiber n) (direction : Fin 4) :
    Finset.sum Finset.univ (fun site =>
        fiberPair (weight site)
          (covariantForwardDifference shift transport field site direction)) =
      Finset.sum Finset.univ (fun site =>
        fiberPair
          (covariantBackwardAdjoint shift transport weight site direction)
          (field site)) := by
  simp_rw [fiberPair_covariantForwardDifference,
    fiberPair_covariantBackwardAdjoint]
  simp only [Finset.sum_sub_distrib]
  congr 1
  have hReindex := Equiv.sum_comp (shift direction)
    (fun site =>
      fiberPair
        (transportAdjointApply
          (transport ((shift direction).symm site) direction)
          (weight ((shift direction).symm site)))
        (field site))
  simpa using hReindex

def covariantLinearizedPlaquetteCurvature
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (variation : LinkPotential Site n) (site : Site) (a b : Fin 4) : Fiber n :=
  fun i =>
    covariantForwardDifference shift transport
        (fun nextSite => variation nextSite b) site a i -
      covariantForwardDifference shift transport
        (fun nextSite => variation nextSite a) site b i

def covariantLinkFaceFirstVariation
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        fiberPair (faceWeight site a b)
          (covariantLinearizedPlaquetteCurvature shift transport variation
            site a b))))

omit [DecidableEq Site] in
/-- Periodic covariant summation by parts applied to both ordered face
branches. -/
theorem covariantLinkFaceFirstVariation_eq_branches
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n) :
    covariantLinkFaceFirstVariation shift transport faceWeight variation =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            fiberPair
              (covariantBackwardAdjoint shift transport
                (fun nextSite => faceWeight nextSite a b) site a)
              (variation site b)) -
          Finset.sum Finset.univ (fun site =>
            fiberPair
              (covariantBackwardAdjoint shift transport
                (fun nextSite => faceWeight nextSite a b) site b)
              (variation site a)))) := by
  unfold covariantLinkFaceFirstVariation
    covariantLinearizedPlaquetteCurvature
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  simp_rw [fiberPair_sub_right]
  rw [Finset.sum_sub_distrib,
    sum_pair_covariantForwardDifference_periodic,
    sum_pair_covariantForwardDifference_periodic]

omit [DecidableEq Site] in
/-- Rotating three finite sums exposes the site and link direction as the two
outer indices. -/
theorem sum_sum_sum_rotate
    (summand : Fin 4 -> Fin 4 -> Site -> Real) :
    Finset.sum Finset.univ (fun a =>
      Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun site => summand a b site))) =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun a => summand a b site))) := by
  calc
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun site =>
            Finset.sum Finset.univ (fun b => summand a b site))) := by
        apply Finset.sum_congr rfl
        intro a _
        exact Finset.sum_comm
    _ = Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b => summand a b site))) := by
        exact Finset.sum_comm
    _ = _ := by
        apply Finset.sum_congr rfl
        intro site _
        exact Finset.sum_comm

omit [DecidableEq Site] in
/-- Cyclically moving the site sum outward preserves the two direction
indices. -/
theorem sum_sum_sum_cycle
    (summand : Fin 4 -> Fin 4 -> Site -> Real) :
    Finset.sum Finset.univ (fun a =>
      Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun site => summand a b site))) =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b => summand a b site))) := by
  calc
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun site =>
            Finset.sum Finset.univ (fun b => summand a b site))) := by
        apply Finset.sum_congr rfl
        intro a _
        exact Finset.sum_comm
    _ = _ := by
        exact Finset.sum_comm

/-- Pairing a finite sum of fiber covectors with one fiber vector commutes
with the finite sum. -/
theorem fiberPair_sum_left
    (summand : Fin 4 -> Fiber n) (right : Fiber n) :
    fiberPair (fun i => Finset.sum Finset.univ (fun a => summand a i)) right =
      Finset.sum Finset.univ (fun a => fiberPair (summand a) right) := by
  unfold fiberPair
  calc
    _ = Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun a => summand a i * right i)) := by
        apply Finset.sum_congr rfl
        intro i _
        rw [Finset.sum_mul]
    _ = _ := by
        exact Finset.sum_comm

def covariantLinkEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (site : Site)
    (direction : Fin 4) : Fiber n :=
  fun i =>
    Finset.sum Finset.univ (fun a =>
        covariantBackwardAdjoint shift transport
          (fun nextSite => faceWeight nextSite a direction) site a i) -
      Finset.sum Finset.univ (fun b =>
        covariantBackwardAdjoint shift transport
          (fun nextSite => faceWeight nextSite direction b) site b i)

omit [Fintype Site] [DecidableEq Site] in
/-- Pairing the local Euler coefficient expands into its two ordered
covariant-divergence branches. -/
theorem fiberPair_covariantLinkEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n)
    (site : Site) (direction : Fin 4) :
    fiberPair
        (covariantLinkEulerCoefficient shift transport faceWeight site direction)
        (variation site direction) =
      Finset.sum Finset.univ (fun a =>
        fiberPair
          (covariantBackwardAdjoint shift transport
            (fun nextSite => faceWeight nextSite a direction) site a)
          (variation site direction)) -
      Finset.sum Finset.univ (fun b =>
        fiberPair
          (covariantBackwardAdjoint shift transport
            (fun nextSite => faceWeight nextSite direction b) site b)
          (variation site direction)) := by
  unfold covariantLinkEulerCoefficient
  rw [fiberPair_sub_left, fiberPair_sum_left, fiberPair_sum_left]

omit [DecidableEq Site] in
/-- The covariant link/face response pairs arbitrary link variations with the
local transported-adjoint Euler coefficient. -/
theorem covariantLinkFaceFirstVariation_eq_eulerPairing
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n) :
    covariantLinkFaceFirstVariation shift transport faceWeight variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          fiberPair
            (covariantLinkEulerCoefficient shift transport faceWeight site
              direction)
            (variation site direction))) := by
  rw [covariantLinkFaceFirstVariation_eq_branches]
  simp_rw [Finset.sum_sub_distrib]
  have hFirst :
      (Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            fiberPair
              (covariantBackwardAdjoint shift transport
                (fun nextSite => faceWeight nextSite a b) site a)
              (variation site b))))) =
        Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun b =>
            Finset.sum Finset.univ (fun a =>
              fiberPair
                (covariantBackwardAdjoint shift transport
                  (fun nextSite => faceWeight nextSite a b) site a)
                (variation site b)))) := by
    exact sum_sum_sum_rotate _
  have hSecond :
      (Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            fiberPair
              (covariantBackwardAdjoint shift transport
                (fun nextSite => faceWeight nextSite a b) site b)
              (variation site a))))) =
        Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              fiberPair
                (covariantBackwardAdjoint shift transport
                  (fun nextSite => faceWeight nextSite a b) site b)
                (variation site a)))) := by
    exact sum_sum_sum_cycle _
  rw [hFirst, hSecond]
  simp_rw [fiberPair_covariantLinkEulerCoefficient,
    Finset.sum_sub_distrib]

/-- A variation supported on one site, one directed link, and one fiber
component. -/
def linkFiberComponentProbe
    (site : Site) (direction : Fin 4) (component : Fin n) :
    LinkPotential Site n :=
  Pi.single site
    (Pi.single direction (Pi.single component (1 : Real)))

/-- Pairing against a unit fiber-component probe extracts that component. -/
theorem fiberPair_piSingle_right (left : Fiber n) (component : Fin n) :
    fiberPair left (Pi.single component (1 : Real)) = left component := by
  unfold fiberPair
  rw [Finset.sum_eq_single component]
  · simp
  · intro other _ hOther
    simp [hOther]
  · simp

/-- The transported first variation on a component probe extracts one local
Euler component. -/
theorem covariantLinkFaceFirstVariation_linkFiberComponentProbe
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (site : Site) (direction : Fin 4)
    (component : Fin n) :
    covariantLinkFaceFirstVariation shift transport faceWeight
        (linkFiberComponentProbe site direction component) =
      covariantLinkEulerCoefficient shift transport faceWeight site direction
        component := by
  rw [covariantLinkFaceFirstVariation_eq_eulerPairing]
  rw [Finset.sum_eq_single site]
  · rw [Finset.sum_eq_single direction]
    · rw [show linkFiberComponentProbe site direction component site direction =
          Pi.single component (1 : Real) by
        simp [linkFiberComponentProbe]]
      exact fiberPair_piSingle_right _ _
    · intro otherDirection _ hDirection
      simp [linkFiberComponentProbe, hDirection, fiberPair]
    · simp
  · intro otherSite _ hSite
    simp [linkFiberComponentProbe, hSite, fiberPair]
  · simp

/-- Stationarity under every transported finite-fiber link variation. -/
def CovariantLinkConnectionEulerLagrange
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) : Prop :=
  forall variation,
    covariantLinkFaceFirstVariation shift transport faceWeight variation = 0

/-- Transported link stationarity is equivalent to vanishing of every local
fiber Euler component. -/
theorem covariantLinkConnectionEulerLagrange_iff_coefficients
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) :
    CovariantLinkConnectionEulerLagrange shift transport faceWeight <->
      forall site direction component,
        covariantLinkEulerCoefficient shift transport faceWeight site direction
          component = 0 := by
  constructor
  · intro hStationary site direction component
    simpa [covariantLinkFaceFirstVariation_linkFiberComponentProbe] using
      hStationary (linkFiberComponentProbe site direction component)
  · intro hCoefficients variation
    rw [covariantLinkFaceFirstVariation_eq_eulerPairing]
    simp [fiberPair, hCoefficients]

/-- Orientation antisymmetry of a fiber-valued ordered face weight. -/
def IsAntisymmetricFaceWeight (faceWeight : FaceWeight Site n) : Prop :=
  forall site a b component,
    faceWeight site a b component = -faceWeight site b a component

/-- Transported backward face divergence in the free link direction. -/
def covariantFaceBackwardDivergence
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (site : Site)
    (direction : Fin 4) : Fiber n :=
  fun component =>
    Finset.sum Finset.univ (fun b =>
      covariantBackwardAdjoint shift transport
        (fun nextSite => faceWeight nextSite direction b) site b component)

omit [Fintype Site] [DecidableEq Site] in
/-- Antisymmetry combines the two transported ordered curl branches into
minus twice the backward covariant face divergence. -/
theorem covariantLinkEulerCoefficient_eq_neg_two_divergence
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n)
    (hAntisymmetric : IsAntisymmetricFaceWeight faceWeight)
    (site : Site) (direction : Fin 4) (component : Fin n) :
    covariantLinkEulerCoefficient shift transport faceWeight site direction
        component =
      -2 * covariantFaceBackwardDivergence shift transport faceWeight site
        direction component := by
  have hBackward (a : Fin 4) :
      covariantBackwardAdjoint shift transport
          (fun nextSite => faceWeight nextSite a direction) site a =
        fun i =>
          -covariantBackwardAdjoint shift transport
            (fun nextSite => faceWeight nextSite direction a) site a i := by
    funext i
    unfold covariantBackwardAdjoint transportAdjointApply
    simp_rw [hAntisymmetric ((shift a).symm site) a direction, mul_neg]
    rw [Finset.sum_neg_distrib,
      hAntisymmetric site a direction i]
    ring
  unfold covariantLinkEulerCoefficient covariantFaceBackwardDivergence
  simp_rw [hBackward]
  rw [Finset.sum_neg_distrib]
  ring

/-- For an antisymmetric transported face bivector, the link equation is
exactly vanishing covariant backward face divergence. -/
theorem covariantLinkConnectionEulerLagrange_iff_divergence
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n)
    (hAntisymmetric : IsAntisymmetricFaceWeight faceWeight) :
    CovariantLinkConnectionEulerLagrange shift transport faceWeight <->
      forall site direction component,
        covariantFaceBackwardDivergence shift transport faceWeight site
          direction component = 0 := by
  rw [covariantLinkConnectionEulerLagrange_iff_coefficients]
  constructor
  · intro hCoefficients site direction component
    have hCoefficient := hCoefficients site direction component
    rw [covariantLinkEulerCoefficient_eq_neg_two_divergence shift transport
      faceWeight hAntisymmetric] at hCoefficient
    linarith
  · intro hDivergence site direction component
    rw [covariantLinkEulerCoefficient_eq_neg_two_divergence shift transport
      faceWeight hAntisymmetric,
      hDivergence site direction component]
    ring

/-- Identity transport on every directed link. -/
def identityLinkTransport : LinkTransport Site n :=
  fun _ _ => 1

omit [Fintype Site] [DecidableEq Site] in
/-- A site-constant fiber covector has zero transported backward difference
under identity link transport. -/
theorem covariantBackwardAdjoint_identity_siteConstant
    (shift : Fin 4 -> Equiv Site Site) (covector : Fiber n)
    (site : Site) (direction : Fin 4) :
    covariantBackwardAdjoint shift (identityLinkTransport : LinkTransport Site n)
        (fun _ => covector) site direction = 0 := by
  funext component
  unfold covariantBackwardAdjoint identityLinkTransport
  rw [show transportAdjointApply
      (1 : Matrix (Fin n) (Fin n) Real) covector component =
        covector component by
    rw [transportAdjointApply_one]]
  simp

omit [DecidableEq Site] in
/-- Identity link transport and any site-constant face field give a
nonvacuous stationary transported control. -/
theorem identity_siteConstant_covariantLinkConnectionEulerLagrange
    (shift : Fin 4 -> Equiv Site Site)
    (faceMatrix : Fin 4 -> Fin 4 -> Fiber n) :
    CovariantLinkConnectionEulerLagrange shift identityLinkTransport
      (fun _ => faceMatrix) := by
  classical
  rw [covariantLinkConnectionEulerLagrange_iff_coefficients]
  intro site direction component
  unfold covariantLinkEulerCoefficient
  simp_rw [covariantBackwardAdjoint_identity_siteConstant]
  simp

end CovariantLinkPalatini
