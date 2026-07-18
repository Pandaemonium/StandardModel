import PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection

/-!
# Linearized link/face Palatini variation on a periodic carrier

The first finite Palatini experiment placed an affine connection at sites and
formed curvature from pointwise forward differences.  Its exact Euler
coefficient does not select the null-edge Levi-Civita candidate, even after
restricting to torsion-free variations.  This module implements the smallest
corrected control architecture:

* the independent linearized connection is a real field on directed links;
* curvature is the oriented curl around an elementary plaquette;
* an ordered face field supplies the Palatini bivector/dual-volume weight;
* periodic summation by parts sends the connection variation to the backward
  discrete divergence of that face field.

For an antisymmetric face field `B`, the exact link equation is

`sum_b backwardDifference (B^{d b})_b = 0`.

This is the finite adjoint shape expected from the continuum connection
variation `D(e wedge e) = 0`.  It is not yet the nonlinear Lorentz-group
Palatini action: the real link potential is the additive tangent control, and
the module does not yet derive `B` from a null coframe or prove that its
divergence equation uniquely selects Levi-Civita transport.

Claim labels: finite identity and linearized consistency check.
Originality tag: `[orig]`, with the standard lattice curl and periodic
summation-by-parts architecture treated as `[import]`.
-/

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation

open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- A real tangent potential attached to every positively oriented link. -/
abbrev LinearLinkPotential (Site : Type*) := Site -> Fin 4 -> Real

/-- An ordered real weight attached to every oriented two-direction face. -/
abbrev OrderedFaceWeight (Site : Type*) := Site -> Fin 4 -> Fin 4 -> Real

/-- Forward difference of a scalar field along a periodic directed link. -/
def forwardLinkDifference
    (shift : Fin 4 -> Equiv Site Site) (field : Site -> Real)
    (site : Site) (direction : Fin 4) : Real :=
  field (shift direction site) - field site

/-- Backward difference adjoint to `forwardLinkDifference` on a periodic
carrier.  The sign convention is predecessor minus current site. -/
def backwardLinkDifference
    (shift : Fin 4 -> Equiv Site Site) (field : Site -> Real)
    (site : Site) (direction : Fin 4) : Real :=
  field ((shift direction).symm site) - field site

omit [DecidableEq Site] in
/-- Exact periodic summation by parts for one scalar link component. -/
theorem sum_weight_mul_forwardLinkDifference_periodic
    (shift : Fin 4 -> Equiv Site Site) (weight field : Site -> Real)
    (direction : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      weight site * forwardLinkDifference shift field site direction)) =
      Finset.sum Finset.univ (fun site =>
        backwardLinkDifference shift weight site direction * field site) := by
  unfold forwardLinkDifference backwardLinkDifference
  rw [show (Finset.sum Finset.univ (fun site =>
      weight site * (field (shift direction site) - field site))) =
      Finset.sum Finset.univ (fun site =>
          weight site * field (shift direction site)) -
        Finset.sum Finset.univ (fun site =>
          weight site * field site) by
    simp only [mul_sub, Finset.sum_sub_distrib]]
  have hReindex := Equiv.sum_comp (shift direction)
    (fun site => weight ((shift direction).symm site) * field site)
  have hShifted :
      (Finset.sum Finset.univ (fun site =>
        weight site * field (shift direction site))) =
        Finset.sum Finset.univ (fun site =>
          weight ((shift direction).symm site) * field site) := by
    simpa using hReindex
  rw [hShifted, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro site _
  ring

/-- Additive plaquette curvature: the `a`-difference of the `b`-link
potential minus the `b`-difference of the `a`-link potential. -/
def linearizedPlaquetteCurvature
    (shift : Fin 4 -> Equiv Site Site) (potential : LinearLinkPotential Site)
    (site : Site) (a b : Fin 4) : Real :=
  forwardLinkDifference shift (fun nextSite => potential nextSite b) site a -
    forwardLinkDifference shift (fun nextSite => potential nextSite a) site b

omit [Fintype Site] [DecidableEq Site] in
/-- The additive curl is the first-order expansion of the two ordered paths
around a plaquette. -/
theorem linearizedPlaquetteCurvature_eq_four_links
    (shift : Fin 4 -> Equiv Site Site) (potential : LinearLinkPotential Site)
    (site : Site) (a b : Fin 4) :
    linearizedPlaquetteCurvature shift potential site a b =
      potential site a + potential (shift a site) b - potential site b -
        potential (shift b site) a := by
  simp [linearizedPlaquetteCurvature, forwardLinkDifference]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- Reversing the ordered face reverses linearized curvature. -/
theorem linearizedPlaquetteCurvature_swap
    (shift : Fin 4 -> Equiv Site Site) (potential : LinearLinkPotential Site)
    (site : Site) (a b : Fin 4) :
    linearizedPlaquetteCurvature shift potential site b a =
      -linearizedPlaquetteCurvature shift potential site a b := by
  simp [linearizedPlaquetteCurvature]

/-- Additive vertex-gauge shift of a real link potential. -/
def linearizedGaugeTransform
    (shift : Fin 4 -> Equiv Site Site) (gaugeScalar : Site -> Real)
    (potential : LinearLinkPotential Site) : LinearLinkPotential Site :=
  fun site direction =>
    potential site direction +
      forwardLinkDifference shift gaugeScalar site direction

omit [Fintype Site] [DecidableEq Site] in
/-- Commuting periodic shifts make the additive plaquette curvature invariant
under vertex-gauge shifts. -/
theorem linearizedPlaquetteCurvature_gaugeTransform
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (gaugeScalar : Site -> Real) (potential : LinearLinkPotential Site)
    (site : Site) (a b : Fin 4) :
    linearizedPlaquetteCurvature shift
        (linearizedGaugeTransform shift gaugeScalar potential) site a b =
      linearizedPlaquetteCurvature shift potential site a b := by
  unfold linearizedPlaquetteCurvature linearizedGaugeTransform
    forwardLinkDifference
  simp only
  rw [hCommute site a b]
  ring

/-- Ordered face-weighted linearized Palatini action.  Direction sums are
placed outside the site sum so periodic summation by parts is explicit. -/
def linkFacePalatiniAction
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (potential : LinearLinkPotential Site) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        faceWeight site a b *
          linearizedPlaquetteCurvature shift potential site a b)))

omit [DecidableEq Site] in
/-- The linearized link/face action inherits vertex-gauge invariance from the
plaquette curl. -/
theorem linkFacePalatiniAction_gaugeTransform
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (faceWeight : OrderedFaceWeight Site) (gaugeScalar : Site -> Real)
    (potential : LinearLinkPotential Site) :
    linkFacePalatiniAction shift faceWeight
        (linearizedGaugeTransform shift gaugeScalar potential) =
      linkFacePalatiniAction shift faceWeight potential := by
  unfold linkFacePalatiniAction
  simp_rw [linearizedPlaquetteCurvature_gaugeTransform shift hCommute]

/-- The exact first response in the link potential.  Linearity makes it the
same face action evaluated on the variation. -/
def linkFacePalatiniFirstVariation
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (variation : LinearLinkPotential Site) : Real :=
  linkFacePalatiniAction shift faceWeight variation

omit [Fintype Site] [DecidableEq Site] in
/-- Linearized plaquette curvature is affine-linear along a variation. -/
theorem linearizedPlaquetteCurvature_add_smul
    (shift : Fin 4 -> Equiv Site Site)
    (potential variation : LinearLinkPotential Site) (scalar : Real)
    (site : Site) (a b : Fin 4) :
    linearizedPlaquetteCurvature shift
        (fun nextSite direction =>
          potential nextSite direction + scalar * variation nextSite direction)
        site a b =
      linearizedPlaquetteCurvature shift potential site a b +
        scalar * linearizedPlaquetteCurvature shift variation site a b := by
  simp [linearizedPlaquetteCurvature, forwardLinkDifference]
  ring

omit [DecidableEq Site] in
/-- Exact action expansion under an arbitrary real link variation. -/
theorem linkFacePalatiniAction_add_smul
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (potential variation : LinearLinkPotential Site) (scalar : Real) :
    linkFacePalatiniAction shift faceWeight
        (fun site direction =>
          potential site direction + scalar * variation site direction) =
      linkFacePalatiniAction shift faceWeight potential +
        scalar * linkFacePalatiniFirstVariation shift faceWeight variation := by
  unfold linkFacePalatiniFirstVariation linkFacePalatiniAction
  simp_rw [linearizedPlaquetteCurvature_add_smul]
  simp only [mul_add, Finset.sum_add_distrib]
  congr 1
  have hTerm (a b : Fin 4) (site : Site) :
      faceWeight site a b *
          (scalar * linearizedPlaquetteCurvature shift variation site a b) =
        scalar * (faceWeight site a b *
          linearizedPlaquetteCurvature shift variation site a b) := by
    ring
  simp_rw [hTerm, ← Finset.mul_sum]

/-- Local ordered-link Euler coefficient before imposing face
antisymmetry. -/
def linkEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (site : Site) (direction : Fin 4) : Real :=
  Finset.sum Finset.univ (fun a =>
      backwardLinkDifference shift (fun nextSite =>
        faceWeight nextSite a direction) site a) -
    Finset.sum Finset.univ (fun b =>
      backwardLinkDifference shift (fun nextSite =>
        faceWeight nextSite direction b) site b)

omit [DecidableEq Site] in
/-- Periodic summation by parts applied separately to the two oriented curl
branches. -/
theorem linkFacePalatiniFirstVariation_eq_branches
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (variation : LinearLinkPotential Site) :
    linkFacePalatiniFirstVariation shift faceWeight variation =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          (Finset.sum Finset.univ (fun site =>
            backwardLinkDifference shift
                (fun nextSite => faceWeight nextSite a b) site a *
              variation site b)) -
          Finset.sum Finset.univ (fun site =>
            backwardLinkDifference shift
                (fun nextSite => faceWeight nextSite a b) site b *
              variation site a))) := by
  unfold linkFacePalatiniFirstVariation linkFacePalatiniAction
  unfold linearizedPlaquetteCurvature
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  rw [show (Finset.sum Finset.univ (fun site =>
      faceWeight site a b *
        (forwardLinkDifference shift (fun nextSite => variation nextSite b)
            site a -
          forwardLinkDifference shift (fun nextSite => variation nextSite a)
            site b))) =
      Finset.sum Finset.univ (fun site =>
          faceWeight site a b *
            forwardLinkDifference shift
              (fun nextSite => variation nextSite b) site a) -
        Finset.sum Finset.univ (fun site =>
          faceWeight site a b *
            forwardLinkDifference shift
              (fun nextSite => variation nextSite a) site b) by
    simp only [mul_sub, Finset.sum_sub_distrib]]
  rw [sum_weight_mul_forwardLinkDifference_periodic,
    sum_weight_mul_forwardLinkDifference_periodic]

omit [DecidableEq Site] in
/-- Rotating three finite sums exposes a site and link component as the two
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
/-- A cyclic permutation of three finite sums exposes the site first while
preserving the order of the two direction indices. -/
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

omit [DecidableEq Site] in
/-- The full first variation is the pairing of the local link Euler
coefficient with the arbitrary link variation. -/
theorem linkFacePalatiniFirstVariation_eq_eulerPairing
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (variation : LinearLinkPotential Site) :
    linkFacePalatiniFirstVariation shift faceWeight variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          linkEulerCoefficient shift faceWeight site direction *
            variation site direction)) := by
  rw [linkFacePalatiniFirstVariation_eq_branches]
  simp_rw [Finset.sum_sub_distrib]
  have hFirst :
      (Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            backwardLinkDifference shift
                (fun nextSite => faceWeight nextSite a b) site a *
              variation site b)))) =
        Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun b =>
            (Finset.sum Finset.univ (fun a =>
              backwardLinkDifference shift
                (fun nextSite => faceWeight nextSite a b) site a)) *
              variation site b)) := by
    rw [sum_sum_sum_rotate]
    apply Finset.sum_congr rfl
    intro site _
    apply Finset.sum_congr rfl
    intro b _
    rw [Finset.sum_mul]
  have hSecond :
      (Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            backwardLinkDifference shift
                (fun nextSite => faceWeight nextSite a b) site b *
              variation site a)))) =
        Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun a =>
            (Finset.sum Finset.univ (fun b =>
              backwardLinkDifference shift
                (fun nextSite => faceWeight nextSite a b) site b)) *
              variation site a)) := by
    rw [sum_sum_sum_cycle]
    apply Finset.sum_congr rfl
    intro site _
    apply Finset.sum_congr rfl
    intro a _
    rw [Finset.sum_mul]
  rw [hFirst, hSecond]
  unfold linkEulerCoefficient
  simp_rw [sub_mul, Finset.sum_sub_distrib]

/-- Variation supported on one directed link. -/
def linkComponentProbe (site : Site) (direction : Fin 4) :
    LinearLinkPotential Site :=
  Pi.single site (Pi.single direction (1 : Real))

/-- Evaluating the first variation on a link probe extracts exactly one local
Euler coefficient. -/
theorem linkFacePalatiniFirstVariation_linkComponentProbe
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (site : Site) (direction : Fin 4) :
    linkFacePalatiniFirstVariation shift faceWeight
        (linkComponentProbe site direction) =
      linkEulerCoefficient shift faceWeight site direction := by
  rw [linkFacePalatiniFirstVariation_eq_eulerPairing]
  rw [Finset.sum_eq_single site]
  · rw [Finset.sum_eq_single direction]
    · simp [linkComponentProbe]
    · intro otherDirection _ hDirection
      simp [linkComponentProbe, hDirection]
    · simp
  · intro otherSite _ hSite
    simp [linkComponentProbe, hSite]
  · simp

/-- Stationarity under every real link variation. -/
def LinkConnectionEulerLagrange
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site) :
    Prop :=
  forall variation,
    linkFacePalatiniFirstVariation shift faceWeight variation = 0

omit [DecidableEq Site] in
/-- Link stationarity is equivalent to vanishing of every local ordered-link
Euler coefficient. -/
theorem linkConnectionEulerLagrange_iff_coefficients
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site) :
    LinkConnectionEulerLagrange shift faceWeight <->
      forall site direction,
        linkEulerCoefficient shift faceWeight site direction = 0 := by
  classical
  constructor
  · intro hStationary site direction
    simpa [linkFacePalatiniFirstVariation_linkComponentProbe] using
      hStationary (linkComponentProbe site direction)
  · intro hCoefficients variation
    rw [linkFacePalatiniFirstVariation_eq_eulerPairing]
    simp [hCoefficients]

/-- Antisymmetry appropriate to an oriented face bivector. -/
def IsAntisymmetricFaceWeight (faceWeight : OrderedFaceWeight Site) : Prop :=
  forall site a b, faceWeight site a b = -faceWeight site b a

/-- Backward face divergence in the free link direction. -/
def faceBackwardDivergence
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (site : Site) (direction : Fin 4) : Real :=
  Finset.sum Finset.univ (fun b =>
    backwardLinkDifference shift
      (fun nextSite => faceWeight nextSite direction b) site b)

omit [Fintype Site] [DecidableEq Site] in
/-- Antisymmetry combines the two ordered curl branches into minus twice the
backward face divergence. -/
theorem linkEulerCoefficient_eq_neg_two_divergence
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (hAntisymmetric : IsAntisymmetricFaceWeight faceWeight)
    (site : Site) (direction : Fin 4) :
    linkEulerCoefficient shift faceWeight site direction =
      -2 * faceBackwardDivergence shift faceWeight site direction := by
  have hBackward (a : Fin 4) :
      backwardLinkDifference shift
          (fun nextSite => faceWeight nextSite a direction) site a =
        -backwardLinkDifference shift
          (fun nextSite => faceWeight nextSite direction a) site a := by
    unfold backwardLinkDifference
    change faceWeight ((shift a).symm site) a direction -
        faceWeight site a direction =
      -(faceWeight ((shift a).symm site) direction a -
        faceWeight site direction a)
    rw [hAntisymmetric ((shift a).symm site) a direction,
      hAntisymmetric site a direction]
    ring
  unfold linkEulerCoefficient faceBackwardDivergence
  simp_rw [hBackward]
  rw [Finset.sum_neg_distrib]
  ring

omit [DecidableEq Site] in
/-- For an antisymmetric face bivector, the link connection equation is
exactly the vanishing backward discrete divergence. -/
theorem linkConnectionEulerLagrange_iff_faceBackwardDivergence
    (shift : Fin 4 -> Equiv Site Site) (faceWeight : OrderedFaceWeight Site)
    (hAntisymmetric : IsAntisymmetricFaceWeight faceWeight) :
    LinkConnectionEulerLagrange shift faceWeight <->
      forall site direction,
        faceBackwardDivergence shift faceWeight site direction = 0 := by
  rw [linkConnectionEulerLagrange_iff_coefficients]
  constructor
  · intro hCoefficients site direction
    have hCoefficient := hCoefficients site direction
    rw [linkEulerCoefficient_eq_neg_two_divergence shift faceWeight
      hAntisymmetric] at hCoefficient
    linarith
  · intro hDivergence site direction
    rw [linkEulerCoefficient_eq_neg_two_divergence shift faceWeight
      hAntisymmetric, hDivergence site direction]
    ring

omit [Fintype Site] [DecidableEq Site] in
/-- A site-constant ordered face field has vanishing backward divergence. -/
theorem siteConstant_faceBackwardDivergence_eq_zero
    (shift : Fin 4 -> Equiv Site Site) (faceMatrix : Fin 4 -> Fin 4 -> Real)
    (site : Site) (direction : Fin 4) :
    faceBackwardDivergence shift (fun _ => faceMatrix) site direction = 0 := by
  simp [faceBackwardDivergence, backwardLinkDifference]

omit [DecidableEq Site] in
/-- Every site-constant face field is stationary in the linearized link
connection channel. -/
theorem siteConstant_linkConnectionEulerLagrange
    (shift : Fin 4 -> Equiv Site Site) (faceMatrix : Fin 4 -> Fin 4 -> Real) :
    LinkConnectionEulerLagrange shift (fun _ => faceMatrix) := by
  rw [linkConnectionEulerLagrange_iff_coefficients]
  intro site direction
  unfold linkEulerCoefficient backwardLinkDifference
  simp

/-- Explicit unit oriented area in the `0,1` coordinate face. -/
def canonicalArea01FaceMatrix (a b : Fin 4) : Real :=
  if a = 0 ∧ b = 1 then 1
  else if a = 1 ∧ b = 0 then -1
  else 0

/-- The explicit `0,1` face matrix is antisymmetric. -/
theorem canonicalArea01FaceMatrix_antisymmetric (a b : Fin 4) :
    canonicalArea01FaceMatrix a b = -canonicalArea01FaceMatrix b a := by
  fin_cases a <;> fin_cases b <;> norm_num [canonicalArea01FaceMatrix]

/-- The chosen oriented face has a visibly nonzero component. -/
theorem canonicalArea01FaceMatrix_zero_one :
    canonicalArea01FaceMatrix 0 1 = 1 := by
  norm_num [canonicalArea01FaceMatrix]

omit [DecidableEq Site] in
/-- Every nonempty periodic carrier admits an explicit nonzero antisymmetric
face field stationary in the additive link-connection channel. -/
theorem exists_nonzero_antisymmetric_stationary_faceWeight
    [Nonempty Site] (shift : Fin 4 -> Equiv Site Site) :
    ∃ faceWeight : OrderedFaceWeight Site,
      IsAntisymmetricFaceWeight faceWeight ∧
        (∃ site, faceWeight site 0 1 = 1) ∧
        LinkConnectionEulerLagrange shift faceWeight := by
  let faceWeight : OrderedFaceWeight Site :=
    fun _ => canonicalArea01FaceMatrix
  refine ⟨faceWeight, ?_, ?_, ?_⟩
  · intro site a b
    exact canonicalArea01FaceMatrix_antisymmetric a b
  · exact ⟨Classical.choice (inferInstance : Nonempty Site),
      canonicalArea01FaceMatrix_zero_one⟩
  · exact siteConstant_linkConnectionEulerLagrange shift
      canonicalArea01FaceMatrix

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation.linkFacePalatiniFirstVariation_eq_eulerPairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linkFacePalatiniFirstVariation_eq_eulerPairing

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation.linkFacePalatiniAction_gaugeTransform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linkFacePalatiniAction_gaugeTransform

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation.linkConnectionEulerLagrange_iff_faceBackwardDivergence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linkConnectionEulerLagrange_iff_faceBackwardDivergence

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation.siteConstant_linkConnectionEulerLagrange' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms siteConstant_linkConnectionEulerLagrange

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation.exists_nonzero_antisymmetric_stationary_faceWeight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_nonzero_antisymmetric_stationary_faceWeight

end PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation
