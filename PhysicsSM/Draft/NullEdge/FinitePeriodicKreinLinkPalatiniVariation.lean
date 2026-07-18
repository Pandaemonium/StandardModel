import PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge

/-!
# Krein-paired finite link/face Palatini variation

This module combines the complete transported finite-fiber link/face
variation with the indefinite pairing and predecessor adjoint established by
`FinitePeriodicKreinLinkAdjoint`.  For a finite fundamental symmetry `J`, the
face response is paired by

`[u,v]_J = <J u,v>`,

and periodic summation by parts puts `U^sharp = J U^T J` on the predecessor
link.  The full ordered-face response is proved to equal the pairing with a
local link Euler coefficient.  `J`-raised component probes show that
stationarity is equivalent to pointwise vanishing of every ordinary fiber
component of that coefficient.

For antisymmetric face data, the equation reduces exactly to vanishing Krein
covariant backward face divergence.  Identity transport and site-constant
face data provide a nonvacuous stationary control.  The final specialization
uses the spacetime-derived rotation/boost fundamental symmetry from
`LorentzBivectorKreinBridge`.

## Scope and provenance

This is the complete finite linearized Krein link/face Euler chain.  It is not
yet the variation of nonlinear Lorentz-group plaquette holonomy, and the face
weight remains an input rather than a derived null-coframe `e wedge e` field
with dual-cell volume.  The finite adjoint calculus is standard `[import]`;
its ordered-face assembly, separating probes, and null-edge specialization are
`[orig]`.  Claim label: finite identity and linearized consistency check.
-/

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge

variable {Site : Type*} [Fintype Site] [DecidableEq Site]
variable {n : Nat}

/-- Krein-paired first response of an ordered face field to a finite link
variation. -/
def kreinLinkFaceFirstVariation
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun site =>
        kreinPair fundamental (faceWeight site a b)
          (covariantLinearizedPlaquetteCurvature shift transport variation
            site a b))))

omit [DecidableEq Site] in
/-- Periodic Krein summation by parts applied to both ordered face branches.
-/
theorem kreinLinkFaceFirstVariation_eq_branches
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n) :
    kreinLinkFaceFirstVariation fundamental shift transport faceWeight
        variation =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            kreinPair fundamental
              (kreinCovariantBackwardAdjoint shift fundamental transport
                (fun nextSite => faceWeight nextSite a b) site a)
              (variation site b)) -
          Finset.sum Finset.univ (fun site =>
            kreinPair fundamental
              (kreinCovariantBackwardAdjoint shift fundamental transport
                (fun nextSite => faceWeight nextSite a b) site b)
              (variation site a)))) := by
  unfold kreinLinkFaceFirstVariation
    covariantLinearizedPlaquetteCurvature
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro b _
  simp_rw [kreinPair_sub_right]
  rw [Finset.sum_sub_distrib,
    sum_kreinPair_covariantForwardDifference_periodic,
    sum_kreinPair_covariantForwardDifference_periodic]

/-- Matrix action commutes with a finite sum of fiber fields. -/
theorem transportApply_sum_fin4
    (matrix : Matrix (Fin n) (Fin n) Real) (summand : Fin 4 -> Fiber n) :
    transportApply matrix
        (fun component => Finset.sum Finset.univ (fun a => summand a component)) =
      fun component =>
        Finset.sum Finset.univ (fun a => transportApply matrix (summand a) component) := by
  funext component
  unfold transportApply
  calc
    Finset.sum Finset.univ (fun fiberComponent =>
        matrix component fiberComponent *
          Finset.sum Finset.univ (fun a => summand a fiberComponent)) =
      Finset.sum Finset.univ (fun fiberComponent =>
        Finset.sum Finset.univ (fun a =>
          matrix component fiberComponent * summand a fiberComponent)) := by
        apply Finset.sum_congr rfl
        intro fiberComponent _
        rw [Finset.mul_sum]
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun fiberComponent =>
            matrix component fiberComponent * summand a fiberComponent)) := by
        exact Finset.sum_comm

/-- Krein pairing a finite sum of left fields commutes with that sum. -/
theorem kreinPair_sum_left
    (fundamental : FundamentalSymmetry n)
    (summand : Fin 4 -> Fiber n) (right : Fiber n) :
    kreinPair fundamental
        (fun component => Finset.sum Finset.univ (fun a => summand a component))
        right =
      Finset.sum Finset.univ (fun a => kreinPair fundamental (summand a) right) := by
  unfold kreinPair
  rw [transportApply_sum_fin4]
  exact fiberPair_sum_left _ _

/-- Local link Euler coefficient with the Krein predecessor adjoint. -/
def kreinLinkEulerCoefficient
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (site : Site)
    (direction : Fin 4) : Fiber n :=
  fun component =>
    Finset.sum Finset.univ (fun a =>
        kreinCovariantBackwardAdjoint shift fundamental transport
          (fun nextSite => faceWeight nextSite a direction) site a component) -
      Finset.sum Finset.univ (fun b =>
        kreinCovariantBackwardAdjoint shift fundamental transport
          (fun nextSite => faceWeight nextSite direction b) site b component)

omit [Fintype Site] [DecidableEq Site] in
/-- Pairing the local Krein Euler coefficient expands into its two ordered
covariant-divergence branches. -/
theorem kreinPair_kreinLinkEulerCoefficient
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n)
    (site : Site) (direction : Fin 4) :
    kreinPair fundamental
        (kreinLinkEulerCoefficient fundamental shift transport faceWeight site
          direction)
        (variation site direction) =
      Finset.sum Finset.univ (fun a =>
        kreinPair fundamental
          (kreinCovariantBackwardAdjoint shift fundamental transport
            (fun nextSite => faceWeight nextSite a direction) site a)
          (variation site direction)) -
      Finset.sum Finset.univ (fun b =>
        kreinPair fundamental
          (kreinCovariantBackwardAdjoint shift fundamental transport
            (fun nextSite => faceWeight nextSite direction b) site b)
          (variation site direction)) := by
  unfold kreinLinkEulerCoefficient
  rw [kreinPair_sub_left, kreinPair_sum_left, kreinPair_sum_left]

omit [DecidableEq Site] in
/-- The complete Krein link/face response pairs arbitrary link variations
with the local `J U^T J`-transported Euler coefficient. -/
theorem kreinLinkFaceFirstVariation_eq_eulerPairing
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (variation : LinkPotential Site n) :
    kreinLinkFaceFirstVariation fundamental shift transport faceWeight
        variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          kreinPair fundamental
            (kreinLinkEulerCoefficient fundamental shift transport faceWeight
              site direction)
            (variation site direction))) := by
  rw [kreinLinkFaceFirstVariation_eq_branches]
  simp_rw [Finset.sum_sub_distrib]
  have hFirst :
      (Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            kreinPair fundamental
              (kreinCovariantBackwardAdjoint shift fundamental transport
                (fun nextSite => faceWeight nextSite a b) site a)
              (variation site b))))) =
        Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun b =>
            Finset.sum Finset.univ (fun a =>
              kreinPair fundamental
                (kreinCovariantBackwardAdjoint shift fundamental transport
                  (fun nextSite => faceWeight nextSite a b) site a)
                (variation site b)))) := by
    exact sum_sum_sum_rotate _
  have hSecond :
      (Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun site =>
            kreinPair fundamental
              (kreinCovariantBackwardAdjoint shift fundamental transport
                (fun nextSite => faceWeight nextSite a b) site b)
              (variation site a))))) =
        Finset.sum Finset.univ (fun site =>
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              kreinPair fundamental
                (kreinCovariantBackwardAdjoint shift fundamental transport
                  (fun nextSite => faceWeight nextSite a b) site b)
                (variation site a)))) := by
    exact sum_sum_sum_cycle _
  rw [hFirst, hSecond]
  simp_rw [kreinPair_kreinLinkEulerCoefficient,
    Finset.sum_sub_distrib]

/-! ## Separating Krein probes and stationarity -/

/-- A site/link/component probe raised by `J` in its fiber slot. -/
def kreinLinkFiberComponentProbe
    (fundamental : FundamentalSymmetry n)
    (site : Site) (direction : Fin 4) (component : Fin n) :
    LinkPotential Site n :=
  Pi.single site
    (Pi.single direction
      (transportApply fundamental.matrix
        (Pi.single component (1 : Real))))

/-- A `J`-raised unit probe extracts the unraised component under the Krein
pairing. -/
theorem kreinPair_raised_piSingle_right
    (fundamental : FundamentalSymmetry n) (left : Fiber n)
    (component : Fin n) :
    kreinPair fundamental left
        (transportApply fundamental.matrix
          (Pi.single component (1 : Real))) = left component := by
  unfold kreinPair
  rw [fiberPair_transportApply, fundamental.selfAdjoint,
    fundamental.involutive, fiberPair_piSingle_right]

/-- Pairing with a zero right field vanishes. -/
theorem kreinPair_zero_right
    (fundamental : FundamentalSymmetry n) (left : Fiber n) :
    kreinPair fundamental left 0 = 0 := by
  simp [kreinPair, fiberPair]

/-- The complete Krein response on a raised component probe extracts one
ordinary local Euler component. -/
theorem kreinLinkFaceFirstVariation_kreinLinkFiberComponentProbe
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (site : Site) (direction : Fin 4)
    (component : Fin n) :
    kreinLinkFaceFirstVariation fundamental shift transport faceWeight
        (kreinLinkFiberComponentProbe fundamental site direction component) =
      kreinLinkEulerCoefficient fundamental shift transport faceWeight site
        direction component := by
  rw [kreinLinkFaceFirstVariation_eq_eulerPairing]
  rw [Finset.sum_eq_single site]
  · rw [Finset.sum_eq_single direction]
    · rw [show kreinLinkFiberComponentProbe fundamental site direction
            component site direction =
          transportApply fundamental.matrix
            (Pi.single component (1 : Real)) by
        simp [kreinLinkFiberComponentProbe]]
      exact kreinPair_raised_piSingle_right _ _ _
    · intro otherDirection _ hDirection
      rw [show kreinLinkFiberComponentProbe fundamental site direction
          component site otherDirection = 0 by
        simp [kreinLinkFiberComponentProbe, hDirection]]
      exact kreinPair_zero_right _ _
    · simp
  · intro otherSite _ hSite
    simp [kreinLinkFiberComponentProbe, hSite, kreinPair, fiberPair]
  · simp

/-- Stationarity under every finite-fiber link variation for the Krein-paired
face response. -/
def KreinLinkConnectionEulerLagrange
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) : Prop :=
  forall variation,
    kreinLinkFaceFirstVariation fundamental shift transport faceWeight
      variation = 0

omit [DecidableEq Site] in
/-- Krein-paired link stationarity is equivalent to vanishing of every local
ordinary fiber component of the Euler coefficient. -/
theorem kreinLinkConnectionEulerLagrange_iff_coefficients
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) :
    KreinLinkConnectionEulerLagrange fundamental shift transport faceWeight <->
      forall site direction component,
        kreinLinkEulerCoefficient fundamental shift transport faceWeight site
          direction component = 0 := by
  classical
  constructor
  · intro hStationary site direction component
    simpa [kreinLinkFaceFirstVariation_kreinLinkFiberComponentProbe] using
      hStationary
        (kreinLinkFiberComponentProbe fundamental site direction component)
  · intro hCoefficients variation
    rw [kreinLinkFaceFirstVariation_eq_eulerPairing]
    simp [kreinPair, transportApply, fiberPair, hCoefficients]

/-! ## Antisymmetric faces and backward divergence -/

/-- Krein backward face divergence in the free link direction. -/
def kreinFaceBackwardDivergence
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n) (site : Site)
    (direction : Fin 4) : Fiber n :=
  fun component =>
    Finset.sum Finset.univ (fun b =>
      kreinCovariantBackwardAdjoint shift fundamental transport
        (fun nextSite => faceWeight nextSite direction b) site b component)

/-- The finite Krein adjoint action commutes with pointwise negation. -/
theorem kreinAdjointApply_neg
    (fundamental : FundamentalSymmetry n)
    (matrix : Matrix (Fin n) (Fin n) Real) (field : Fiber n) :
    kreinAdjointApply fundamental matrix (fun component => -field component) =
      fun component => -kreinAdjointApply fundamental matrix field component := by
  funext component
  unfold kreinAdjointApply transportApply transportAdjointApply
  simp only [mul_neg, Finset.sum_neg_distrib]

omit [Fintype Site] [DecidableEq Site] in
/-- The Krein backward adjoint commutes with pointwise negation of a site
field. -/
theorem kreinCovariantBackwardAdjoint_neg
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (covector : Site -> Fiber n) (site : Site) (direction : Fin 4) :
    kreinCovariantBackwardAdjoint shift fundamental transport
        (fun nextSite component => -covector nextSite component) site direction =
      fun component =>
        -kreinCovariantBackwardAdjoint shift fundamental transport covector site
          direction component := by
  funext component
  unfold kreinCovariantBackwardAdjoint
  rw [kreinAdjointApply_neg]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- Antisymmetry combines the two ordered Krein curl branches into minus
twice the Krein covariant backward face divergence. -/
theorem kreinLinkEulerCoefficient_eq_neg_two_divergence
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n)
    (hAntisymmetric : IsAntisymmetricFaceWeight faceWeight)
    (site : Site) (direction : Fin 4) (component : Fin n) :
    kreinLinkEulerCoefficient fundamental shift transport faceWeight site
        direction component =
      -2 * kreinFaceBackwardDivergence fundamental shift transport faceWeight
        site direction component := by
  have hBackward (a : Fin 4) :
      kreinCovariantBackwardAdjoint shift fundamental transport
          (fun nextSite => faceWeight nextSite a direction) site a =
        fun i =>
          -kreinCovariantBackwardAdjoint shift fundamental transport
            (fun nextSite => faceWeight nextSite direction a) site a i := by
    have hCovector :
        (fun nextSite => faceWeight nextSite a direction) =
          fun nextSite i => -faceWeight nextSite direction a i := by
      funext nextSite i
      exact hAntisymmetric nextSite a direction i
    rw [hCovector, kreinCovariantBackwardAdjoint_neg]
  unfold kreinLinkEulerCoefficient kreinFaceBackwardDivergence
  simp_rw [hBackward]
  rw [Finset.sum_neg_distrib]
  ring

omit [DecidableEq Site] in
/-- For an antisymmetric Krein-paired face bivector, the link equation is
exactly vanishing Krein covariant backward face divergence. -/
theorem kreinLinkConnectionEulerLagrange_iff_divergence
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site n)
    (faceWeight : FaceWeight Site n)
    (hAntisymmetric : IsAntisymmetricFaceWeight faceWeight) :
    KreinLinkConnectionEulerLagrange fundamental shift transport faceWeight <->
      forall site direction component,
        kreinFaceBackwardDivergence fundamental shift transport faceWeight site
          direction component = 0 := by
  rw [kreinLinkConnectionEulerLagrange_iff_coefficients]
  constructor
  · intro hCoefficients site direction component
    have hCoefficient := hCoefficients site direction component
    rw [kreinLinkEulerCoefficient_eq_neg_two_divergence fundamental shift
      transport faceWeight hAntisymmetric] at hCoefficient
    linarith
  · intro hDivergence site direction component
    rw [kreinLinkEulerCoefficient_eq_neg_two_divergence fundamental shift
      transport faceWeight hAntisymmetric,
      hDivergence site direction component]
    ring

/-! ## Nonvacuous identity-transport control -/

/-- The Krein adjoint of identity transport is the identity action. -/
theorem kreinAdjointApply_one
    (fundamental : FundamentalSymmetry n) (field : Fiber n) :
    kreinAdjointApply fundamental (1 : Matrix (Fin n) (Fin n) Real) field =
      field := by
  unfold kreinAdjointApply
  rw [transportAdjointApply_one, fundamental.involutive]

omit [Fintype Site] [DecidableEq Site] in
/-- A site-constant fiber field has zero Krein backward difference under
identity transport. -/
theorem kreinCovariantBackwardAdjoint_identity_siteConstant
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site) (covector : Fiber n)
    (site : Site) (direction : Fin 4) :
    kreinCovariantBackwardAdjoint shift fundamental
        (identityLinkTransport : LinkTransport Site n)
        (fun _ => covector) site direction = 0 := by
  funext component
  unfold kreinCovariantBackwardAdjoint identityLinkTransport
  rw [show kreinAdjointApply fundamental
      (1 : Matrix (Fin n) (Fin n) Real) covector component =
        covector component by
    rw [kreinAdjointApply_one]]
  simp

omit [DecidableEq Site] in
/-- Identity link transport and any site-constant face field give a
nonvacuous stationary Krein-paired control. -/
theorem identity_siteConstant_kreinLinkConnectionEulerLagrange
    (fundamental : FundamentalSymmetry n)
    (shift : Fin 4 -> Equiv Site Site)
    (faceMatrix : Fin 4 -> Fin 4 -> Fiber n) :
    KreinLinkConnectionEulerLagrange fundamental shift identityLinkTransport
      (fun _ => faceMatrix) := by
  classical
  rw [kreinLinkConnectionEulerLagrange_iff_coefficients]
  intro site direction component
  unfold kreinLinkEulerCoefficient
  simp_rw [kreinCovariantBackwardAdjoint_identity_siteConstant]
  simp

/-! ## Physical Lorentz-bivector specialization -/

/-- Full face response specialized to the spacetime-derived six-component
Lorentz-bivector pairing. -/
abbrev lorentzBivectorLinkFaceFirstVariation
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site 6)
    (faceWeight : FaceWeight Site 6) (variation : LinkPotential Site 6) : Real :=
  kreinLinkFaceFirstVariation lorentzBivectorFundamentalSymmetry shift transport
    faceWeight variation

omit [DecidableEq Site] in
/-- The physical Lorentz-bivector response has the exact local Krein Euler
pairing. -/
theorem lorentzBivectorLinkFaceFirstVariation_eq_eulerPairing
    (shift : Fin 4 -> Equiv Site Site) (transport : LinkTransport Site 6)
    (faceWeight : FaceWeight Site 6) (variation : LinkPotential Site 6) :
    lorentzBivectorLinkFaceFirstVariation shift transport faceWeight variation =
      Finset.sum Finset.univ (fun site =>
        Finset.sum Finset.univ (fun direction =>
          kreinPair lorentzBivectorFundamentalSymmetry
            (kreinLinkEulerCoefficient lorentzBivectorFundamentalSymmetry shift
              transport faceWeight site direction)
            (variation site direction))) := by
  exact kreinLinkFaceFirstVariation_eq_eulerPairing _ _ _ _ _

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation.kreinLinkFaceFirstVariation_eq_eulerPairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinLinkFaceFirstVariation_eq_eulerPairing

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation.kreinLinkConnectionEulerLagrange_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinLinkConnectionEulerLagrange_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation.kreinLinkConnectionEulerLagrange_iff_divergence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinLinkConnectionEulerLagrange_iff_divergence

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation.identity_siteConstant_kreinLinkConnectionEulerLagrange' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identity_siteConstant_kreinLinkConnectionEulerLagrange

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation.lorentzBivectorLinkFaceFirstVariation_eq_eulerPairing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzBivectorLinkFaceFirstVariation_eq_eulerPairing

end PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
