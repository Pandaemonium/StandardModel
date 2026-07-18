import PhysicsSM.Gauge.CausalDiamondHolonomy

/-!
# Group-valued link connections on periodic directed carriers

The pointwise affine-connection discretization used by the first finite
Palatini experiment is not selected by its torsion-free Euler equation on a
varying conformal null-edge frame.  This module records the smallest corrected
curvature substrate: transport lives on directed links and curvature is the
holonomy around a two-direction plaquette.

For a periodic shift system `shift`, a link field `U x a` transports from `x`
to `shift a x`.  The two paths across an `a,b` plaquette are

`U x a * U (shift a x) b` and `U x b * U (shift b x) a`.

When the shifts commute, the paths have a common endpoint.  Their comparison
is a closed group-valued holonomy, transforms by conjugation at the base site,
and is trivial exactly when the two transports agree.

## Scope and provenance

These are finite group identities, not an Einstein equation or a completed
discrete Palatini action.  They specialize the link and typed-walk convention
of `GateYM.GaugeCoreGeneral` to the periodic four-direction carrier used by the
null-edge GR modules.  They also match the path-comparison principle in the
trusted `PhysicsSM.Gauge.CausalDiamondHolonomy` module and the plaquette
curvature substrate of `Carrier.WeitzenbockQC_Torus` and
`GraphPlaquetteCurvatureLimit`.

The gravitational successor still has to specify the frame representation,
the face/dual-cell volume pairing, the action, and its connection variation.
Claim label: finite identity.  Originality tag: `[comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection

open PhysicsSM.Gauge.CausalDiamondHolonomy

/-- A group-valued transporter on each positively oriented carrier link. -/
abbrev LinkConnection (Site G : Type*) := Site -> Fin 4 -> G

/-- Vertex-gauge action in the convention
`U'(x,a) = g(x) U(x,a) g(shift_a x)^(-1)`. -/
def gaugeTransform {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (g : Site -> G)
    (U : LinkConnection Site G) : LinkConnection Site G :=
  fun site direction =>
    g site * U site direction * (g (shift direction site))⁻¹

/-- Ordered transport first in direction `a`, then in direction `b`. -/
def twoStepTransport {Site G : Type*} [Mul G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) : G :=
  U site a * U (shift a site) b

/-- The four directed shifts commute as maps on the periodic carrier. -/
def ShiftsCommute {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) : Prop :=
  forall site a b,
    shift b (shift a site) = shift a (shift b site)

/-- Group-valued holonomy comparing the two ordered paths across one
plaquette. -/
def plaquetteHolonomy {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) : G :=
  twoStepTransport shift U site a b *
    (twoStepTransport shift U site b a)⁻¹

/-- The same elementary plaquette regarded as two directed causal-diamond
branches with common initial and final sites. -/
def plaquetteDiamond {Site G : Type*}
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) : DiamondLabels G where
  bottomLeft := U site a
  leftTop := U (shift a site) b
  bottomRight := U site b
  rightTop := U (shift b site) a

/-- The left branch of the plaquette diamond is the `a`-then-`b` transport. -/
theorem leftHolonomy_plaquetteDiamond {Site G : Type*} [Mul G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) :
    leftHolonomy (plaquetteDiamond shift U site a b) =
      twoStepTransport shift U site a b := rfl

/-- The right branch of the plaquette diamond is the `b`-then-`a` transport. -/
theorem rightHolonomy_plaquetteDiamond {Site G : Type*} [Mul G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) :
    rightHolonomy (plaquetteDiamond shift U site a b) =
      twoStepTransport shift U site b a := rfl

/-- The periodic loop and trusted causal-diamond curvature carriers contain
the same path-pair data. Their displayed group elements differ only by
orientation, inversion, and transport of the basepoint from the top back to
the initial site. -/
theorem plaquetteHolonomy_eq_conjugate_diamondDefect_inv
    {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) :
    plaquetteHolonomy shift U site a b =
      leftHolonomy (plaquetteDiamond shift U site a b) *
        (diamondDefect (plaquetteDiamond shift U site a b))⁻¹ *
        (leftHolonomy (plaquetteDiamond shift U site a b))⁻¹ := by
  simp [plaquetteHolonomy, plaquetteDiamond, leftHolonomy, rightHolonomy,
    diamondDefect, twoStepTransport, mul_assoc]

/-- A link connection is flat when every ordered plaquette holonomy is the
identity. -/
def IsFlat {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G) : Prop :=
  forall site a b, plaquetteHolonomy shift U site a b = 1

/-- Two-step transport is gauge covariant at its initial and final sites. -/
theorem twoStepTransport_gaugeTransform {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (g : Site -> G)
    (U : LinkConnection Site G) (site : Site) (a b : Fin 4) :
    twoStepTransport shift (gaugeTransform shift g U) site a b =
      g site * twoStepTransport shift U site a b *
        (g (shift b (shift a site)))⁻¹ := by
  simp [twoStepTransport, gaugeTransform, mul_assoc]

/-- With commuting shifts, plaquette holonomy transforms by conjugation at
the base site. -/
theorem plaquetteHolonomy_gaugeTransform {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (g : Site -> G) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) :
    plaquetteHolonomy shift (gaugeTransform shift g U) site a b =
      g site * plaquetteHolonomy shift U site a b * (g site)⁻¹ := by
  rw [plaquetteHolonomy, twoStepTransport_gaugeTransform,
    twoStepTransport_gaugeTransform, hCommute site a b]
  simp [plaquetteHolonomy, mul_assoc]

/-- Plaquette holonomy is trivial exactly when the two ordered transports
agree. -/
theorem plaquetteHolonomy_eq_one_iff {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) :
    plaquetteHolonomy shift U site a b = 1 <->
      twoStepTransport shift U site a b =
        twoStepTransport shift U site b a := by
  exact mul_inv_eq_one

/-- Flatness is path independence across every elementary two-direction
plaquette. -/
theorem isFlat_iff_twoStepTransport_eq {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (U : LinkConnection Site G) :
    IsFlat shift U <->
      forall site a b,
        twoStepTransport shift U site a b =
          twoStepTransport shift U site b a := by
  constructor
  · intro hFlat site a b
    exact (plaquetteHolonomy_eq_one_iff shift U site a b).mp
      (hFlat site a b)
  · intro hPath site a b
    exact (plaquetteHolonomy_eq_one_iff shift U site a b).mpr
      (hPath site a b)

/-- Commuting-shift gauge transformations preserve link flatness. -/
theorem isFlat_gaugeTransform {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (g : Site -> G) (U : LinkConnection Site G)
    (hFlat : IsFlat shift U) :
    IsFlat shift (gaugeTransform shift g U) := by
  intro site a b
  rw [plaquetteHolonomy_gaugeTransform shift hCommute, hFlat site a b]
  simp

/-- A function on the transport group is invariant under conjugation. -/
def IsClassFunction {G A : Type*} [Group G] (observable : G -> A) : Prop :=
  forall g holonomy,
    observable (g * holonomy * g⁻¹) = observable holonomy

/-- Every class-function observable of plaquette holonomy is gauge invariant.
-/
theorem classFunction_plaquetteHolonomy_gauge_invariant
    {Site G A : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (observable : G -> A) (hClass : IsClassFunction observable)
    (g : Site -> G) (U : LinkConnection Site G)
    (site : Site) (a b : Fin 4) :
    observable
        (plaquetteHolonomy shift (gaugeTransform shift g U) site a b) =
      observable (plaquetteHolonomy shift U site a b) := by
  rw [plaquetteHolonomy_gaugeTransform shift hCommute]
  exact hClass (g site) (plaquetteHolonomy shift U site a b)

/-- Identity transport on every link is a nonvacuous flat control. -/
theorem trivial_isFlat {Site G : Type*} [Group G]
    (shift : Fin 4 -> Equiv Site Site) :
    IsFlat shift (fun _ _ => (1 : G)) := by
  intro site a b
  simp [plaquetteHolonomy, twoStepTransport]

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection.plaquetteHolonomy_gaugeTransform' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plaquetteHolonomy_gaugeTransform

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection.plaquetteHolonomy_eq_conjugate_diamondDefect_inv' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plaquetteHolonomy_eq_conjugate_diamondDefect_inv

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection.isFlat_iff_twoStepTransport_eq' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms isFlat_iff_twoStepTransport_eq

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection.classFunction_plaquetteHolonomy_gauge_invariant' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms classFunction_plaquetteHolonomy_gauge_invariant

end PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
