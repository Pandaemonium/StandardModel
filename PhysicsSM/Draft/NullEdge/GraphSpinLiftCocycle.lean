import PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary

/-!
# Graph spin-lift signs on a path and an oriented square

The local Lorentz action sees an `SL(2,C)` lift only up to its central sign.
This module records the first global compatibility layer for that sign on two
finite graph cells.

* On a three-edge path, every edge-sign assignment is removed by vertex signs.
* On an oriented square, the sum of the four edge signs in `ZMod 2` is invariant
  under vertex-sign changes.
* Two square assignments are gauge equivalent exactly when their cycle
  parities agree, so there are exactly two sectors.
* On two square faces glued along their common boundary, one shared correction
  exists exactly when the two face defects agree.
* The two sectors give the same Pauli/Hermitian Minkowski action but different
  actions on a spinor with nonzero image.

This is the central-sign cocycle algebra needed after choosing local spin
lifts. It does not prove that Lorentz transports admit lifts, construct a
four-dimensional cell complex, impose all face constraints, compute a second
Stiefel--Whitney obstruction, or derive a global continuum spin structure from
a bare graph. Claim grade: `M [orig]`.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle

open PhysicsSM.NullStrand
open PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary
open PhysicsSM.Draft.NullEdge.HermitianSpinLiftBoundary

/-! ## A tree path has no sign obstruction -/

/-- Central lift signs on the three oriented edges of a four-vertex path. -/
@[ext]
structure PathEdgeSigns where
  e01 : ZMod 2
  e12 : ZMod 2
  e23 : ZMod 2
  deriving DecidableEq

/-- Vertex signs on a four-vertex path. -/
structure PathVertexGauge where
  v0 : ZMod 2
  v1 : ZMod 2
  v2 : ZMod 2
  v3 : ZMod 2
  deriving DecidableEq

/-- Change of edge-lift signs induced by signs at path vertices. -/
def pathGaugeTransform
    (g : PathVertexGauge) (s : PathEdgeSigns) : PathEdgeSigns where
  e01 := g.v0 + s.e01 - g.v1
  e12 := g.v1 + s.e12 - g.v2
  e23 := g.v2 + s.e23 - g.v3

/-- The all-positive reference lift on the path. -/
def trivialPathSigns : PathEdgeSigns :=
  { e01 := 0, e12 := 0, e23 := 0 }

/-- **Tree control.** Every central-sign assignment on the path is vertex-gauge
equivalent to the all-positive assignment. -/
theorem path_signs_gauge_trivial (s : PathEdgeSigns) :
    exists g : PathVertexGauge,
      pathGaugeTransform g s = trivialPathSigns := by
  refine ⟨
    { v0 := 0
      v1 := s.e01
      v2 := s.e01 + s.e12
      v3 := s.e01 + s.e12 + s.e23 }, ?_⟩
  ext <;> simp [pathGaugeTransform, trivialPathSigns]

/-! ## A square has one gauge-invariant cycle bit -/

/-- Central lift signs on the four oriented edges of a square. -/
@[ext]
structure SquareEdgeSigns where
  e01 : ZMod 2
  e12 : ZMod 2
  e23 : ZMod 2
  e30 : ZMod 2
  deriving DecidableEq

/-- Vertex signs on the four corners of a square. -/
structure SquareVertexGauge where
  v0 : ZMod 2
  v1 : ZMod 2
  v2 : ZMod 2
  v3 : ZMod 2
  deriving DecidableEq

/-- Change of square edge-lift signs induced by signs at its vertices. -/
def squareGaugeTransform
    (g : SquareVertexGauge) (s : SquareEdgeSigns) : SquareEdgeSigns where
  e01 := g.v0 + s.e01 - g.v1
  e12 := g.v1 + s.e12 - g.v2
  e23 := g.v2 + s.e23 - g.v3
  e30 := g.v3 + s.e30 - g.v0

/-- Central sign accumulated around the oriented square. -/
def squareCycleParity (s : SquareEdgeSigns) : ZMod 2 :=
  s.e01 + s.e12 + s.e23 + s.e30

/-- Vertex signs cancel pairwise around a closed square. -/
theorem squareCycleParity_gauge
    (g : SquareVertexGauge) (s : SquareEdgeSigns) :
    squareCycleParity (squareGaugeTransform g s) = squareCycleParity s := by
  simp [squareCycleParity, squareGaugeTransform]
  ring

/-- Gauge equivalence of two central-sign assignments on the square. -/
def SquareGaugeEquivalent (s t : SquareEdgeSigns) : Prop :=
  exists g : SquareVertexGauge, squareGaugeTransform g s = t

/-- Explicit vertex gauge reconstructed from two assignments with equal cycle
parity. -/
def reconstructingSquareGauge
    (s t : SquareEdgeSigns) : SquareVertexGauge where
  v0 := 0
  v1 := s.e01 - t.e01
  v2 := s.e01 - t.e01 + s.e12 - t.e12
  v3 := s.e01 - t.e01 + s.e12 - t.e12 + s.e23 - t.e23

/-- Equal square parity is sufficient to reconstruct a vertex gauge. -/
theorem squareGaugeTransform_reconstruct
    (s t : SquareEdgeSigns)
    (hparity : squareCycleParity s = squareCycleParity t) :
    squareGaugeTransform (reconstructingSquareGauge s t) s = t := by
  ext
  · simp [squareGaugeTransform, reconstructingSquareGauge]
  · simp [squareGaugeTransform, reconstructingSquareGauge]
  · simp [squareGaugeTransform, reconstructingSquareGauge]
  · simp [squareGaugeTransform, reconstructingSquareGauge]
    unfold squareCycleParity at hparity
    linear_combination hparity

/-- **Square classification.** Two lift-sign assignments differ by vertex
signs exactly when their closed-cycle parities agree. -/
theorem squareGaugeEquivalent_iff_cycleParity_eq
    (s t : SquareEdgeSigns) :
    SquareGaugeEquivalent s t <->
      squareCycleParity s = squareCycleParity t := by
  constructor
  · rintro ⟨g, rfl⟩
    exact (squareCycleParity_gauge g s).symm
  · intro h
    exact ⟨reconstructingSquareGauge s t,
      squareGaugeTransform_reconstruct s t h⟩

theorem squareGaugeEquivalent_refl (s : SquareEdgeSigns) :
    SquareGaugeEquivalent s s := by
  exact (squareGaugeEquivalent_iff_cycleParity_eq s s).2 rfl

theorem squareGaugeEquivalent_symm
    {s t : SquareEdgeSigns} (h : SquareGaugeEquivalent s t) :
    SquareGaugeEquivalent t s := by
  apply (squareGaugeEquivalent_iff_cycleParity_eq t s).2
  exact ((squareGaugeEquivalent_iff_cycleParity_eq s t).1 h).symm

theorem squareGaugeEquivalent_trans
    {s t u : SquareEdgeSigns}
    (hst : SquareGaugeEquivalent s t)
    (htu : SquareGaugeEquivalent t u) :
    SquareGaugeEquivalent s u := by
  apply (squareGaugeEquivalent_iff_cycleParity_eq s u).2
  exact ((squareGaugeEquivalent_iff_cycleParity_eq s t).1 hst).trans
    ((squareGaugeEquivalent_iff_cycleParity_eq t u).1 htu)

/-- Vertex-sign gauge equivalence is an equivalence relation. -/
theorem squareGaugeEquivalent_equivalence :
    Equivalence SquareGaugeEquivalent := by
  exact ⟨squareGaugeEquivalent_refl,
    @squareGaugeEquivalent_symm,
    @squareGaugeEquivalent_trans⟩

/-- The untwisted square assignment. -/
def untwistedSquareSigns : SquareEdgeSigns :=
  { e01 := 0, e12 := 0, e23 := 0, e30 := 0 }

/-- A square assignment with one negative edge lift. -/
def twistedSquareSigns : SquareEdgeSigns :=
  { e01 := 1, e12 := 0, e23 := 0, e30 := 0 }

theorem untwistedSquareSigns_parity :
    squareCycleParity untwistedSquareSigns = 0 := by
  norm_num [squareCycleParity, untwistedSquareSigns]

theorem twistedSquareSigns_parity :
    squareCycleParity twistedSquareSigns = 1 := by
  norm_num [squareCycleParity, twistedSquareSigns]

/-- Every element of `ZMod 2` is zero or one. -/
theorem zmod_two_eq_zero_or_one (x : ZMod 2) : x = 0 ∨ x = 1 := by
  fin_cases x <;> simp

/-- Every square sign assignment belongs to the untwisted or twisted sector. -/
theorem squareGaugeEquivalent_untwisted_or_twisted (s : SquareEdgeSigns) :
    SquareGaugeEquivalent s untwistedSquareSigns ∨
      SquareGaugeEquivalent s twistedSquareSigns := by
  rcases zmod_two_eq_zero_or_one (squareCycleParity s) with h | h
  · left
    apply (squareGaugeEquivalent_iff_cycleParity_eq s
      untwistedSquareSigns).2
    simpa [untwistedSquareSigns_parity] using h
  · right
    apply (squareGaugeEquivalent_iff_cycleParity_eq s
      twistedSquareSigns).2
    simpa [twistedSquareSigns_parity] using h

/-- The two cycle sectors are genuinely gauge inequivalent. -/
theorem untwisted_not_gaugeEquivalent_twisted :
    ¬ SquareGaugeEquivalent untwistedSquareSigns twistedSquareSigns := by
  intro h
  have hparity :=
    (squareGaugeEquivalent_iff_cycleParity_eq
      untwistedSquareSigns twistedSquareSigns).1 h
  rw [untwistedSquareSigns_parity, twistedSquareSigns_parity] at hparity
  norm_num at hparity

/-! ## A prescribed face defect selects one sector -/

/-- Compatibility with the central sign already accumulated by a chosen set
of local edge lifts around a filled square. A flat face has defect zero. -/
def SquareFaceCompatible
    (defect : ZMod 2) (s : SquareEdgeSigns) : Prop :=
  squareCycleParity s = defect

/-- Face compatibility is unchanged by signs at vertices. -/
theorem squareFaceCompatible_gauge
    (defect : ZMod 2) (g : SquareVertexGauge) (s : SquareEdgeSigns) :
    SquareFaceCompatible defect (squareGaugeTransform g s) <->
      SquareFaceCompatible defect s := by
  simp [SquareFaceCompatible, squareCycleParity_gauge]

/-- Every prescribed central face defect has a correcting edge-sign
assignment on one isolated square. -/
theorem squareFaceCompatible_nonempty (defect : ZMod 2) :
    exists s : SquareEdgeSigns, SquareFaceCompatible defect s := by
  rcases zmod_two_eq_zero_or_one defect with rfl | rfl
  · exact ⟨untwistedSquareSigns, untwistedSquareSigns_parity⟩
  · exact ⟨twistedSquareSigns, twistedSquareSigns_parity⟩

/-- On one filled square, two corrections of the same prescribed defect differ
only by vertex signs. -/
theorem squareFaceCompatible_unique_up_to_gauge
    (defect : ZMod 2) (s t : SquareEdgeSigns)
    (hs : SquareFaceCompatible defect s)
    (ht : SquareFaceCompatible defect t) :
    SquareGaugeEquivalent s t := by
  apply (squareGaugeEquivalent_iff_cycleParity_eq s t).2
  exact hs.trans ht.symm

/-- Flat-face compatibility is exactly the untwisted boundary gauge class. -/
theorem squareFlatCompatible_iff_gaugeEquivalent_untwisted
    (s : SquareEdgeSigns) :
    SquareFaceCompatible 0 s <->
      SquareGaugeEquivalent s untwistedSquareSigns := by
  rw [squareGaugeEquivalent_iff_cycleParity_eq]
  simp [SquareFaceCompatible, untwistedSquareSigns_parity]

/-! ## Minimal simultaneous-face obstruction -/

/-- Central defects on the two square faces of the minimal cell decomposition
obtained by gluing two disks along their common square boundary. -/
structure DoubleSquareDefect where
  front : ZMod 2
  back : ZMod 2
  deriving DecidableEq

/-- One boundary edge-sign correction must satisfy both glued faces. -/
def DoubleSquareCompatible
    (defect : DoubleSquareDefect) (s : SquareEdgeSigns) : Prop :=
  SquareFaceCompatible defect.front s ∧
    SquareFaceCompatible defect.back s

/-- The obstruction bit obtained by evaluating the two face defects on the
closed two-face cycle. -/
def doubleSquareObstruction (defect : DoubleSquareDefect) : ZMod 2 :=
  defect.front + defect.back

/-- A shared edge-sign correction exists exactly when the two glued face
defects agree. -/
theorem doubleSquareCompatible_nonempty_iff_defects_eq
    (defect : DoubleSquareDefect) :
    (exists s : SquareEdgeSigns, DoubleSquareCompatible defect s) <->
      defect.front = defect.back := by
  constructor
  · rintro ⟨s, hfront, hback⟩
    exact hfront.symm.trans hback
  · intro h
    obtain ⟨s, hs⟩ := squareFaceCompatible_nonempty defect.front
    exact ⟨s, hs, hs.trans h⟩

/-- Over `ZMod 2`, equality of the two face defects is equivalent to vanishing
of their closed-cycle obstruction bit. -/
theorem doubleSquareObstruction_eq_zero_iff
    (defect : DoubleSquareDefect) :
    doubleSquareObstruction defect = 0 <->
      defect.front = defect.back := by
  rcases zmod_two_eq_zero_or_one defect.front with hfront | hfront <;>
    rcases zmod_two_eq_zero_or_one defect.back with hback | hback <;>
    simp [doubleSquareObstruction, hfront, hback]
  exact ZMod.natCast_self 2

/-- **Minimal global compatibility criterion.** A simultaneous correction on
the glued two-face complex exists exactly when its obstruction bit vanishes. -/
theorem doubleSquareCompatible_nonempty_iff_obstruction_zero
    (defect : DoubleSquareDefect) :
    (exists s : SquareEdgeSigns, DoubleSquareCompatible defect s) <->
      doubleSquareObstruction defect = 0 := by
  rw [doubleSquareCompatible_nonempty_iff_defects_eq,
    doubleSquareObstruction_eq_zero_iff]

/-- If simultaneous corrections exist, they form one vertex-gauge class. -/
theorem doubleSquareCompatible_unique_up_to_gauge
    (defect : DoubleSquareDefect) (s t : SquareEdgeSigns)
    (hs : DoubleSquareCompatible defect s)
    (ht : DoubleSquareCompatible defect t) :
    SquareGaugeEquivalent s t := by
  exact squareFaceCompatible_unique_up_to_gauge defect.front s t hs.1 ht.1

/-- Explicit nonzero obstruction: unequal face defects cannot be corrected by
one shared boundary sign assignment. -/
theorem doubleSquare_mismatched_defect_obstructed :
    doubleSquareObstruction { front := 0, back := 1 } = 1 ∧
      ¬ exists s : SquareEdgeSigns,
        DoubleSquareCompatible { front := 0, back := 1 } s := by
  constructor
  · norm_num [doubleSquareObstruction]
  · rw [doubleSquareCompatible_nonempty_iff_obstruction_zero]
    norm_num [doubleSquareObstruction]

/-! ## Connection to the Hermitian spin lift -/

/-- Select `A` or its central partner `-A` from one `ZMod 2` sign. -/
def signedSpinLift
    (b : ZMod 2) (A : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  if b = 0 then A else -A

@[simp] theorem signedSpinLift_zero (A : Matrix (Fin 2) (Fin 2) ℂ) :
    signedSpinLift 0 A = A := by
  simp [signedSpinLift]

@[simp] theorem signedSpinLift_one (A : Matrix (Fin 2) (Fin 2) ℂ) :
    signedSpinLift 1 A = -A := by
  simp [signedSpinLift]

/-- The selected central sign is invisible on Hermitian Minkowski matrices. -/
theorem signedSpinLift_hermitianLorentzAction
    (b : ZMod 2) (A M : Matrix (Fin 2) (Fin 2) ℂ) :
    hermitianLorentzAction (signedSpinLift b A) M =
      hermitianLorentzAction A M := by
  rcases zmod_two_eq_zero_or_one b with rfl | rfl
  · simp
  · simpa using hermitianLorentzAction_neg A M

/-- A determinant-one local lift remains determinant one after either central
sign is selected. -/
theorem signedSpinLift_det
    (b : ZMod 2) (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1) :
    (signedSpinLift b A).det = 1 := by
  rcases zmod_two_eq_zero_or_one b with rfl | rfl
  · simpa using hA
  · simpa [neg_det_eq_det] using hA

/-- The twisted central sign is visible on every spinor with nonzero image. -/
theorem signedSpinLift_one_spinorAction_ne
    (A : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ)
    (hpsi : spinorAction A psi ≠ 0) :
    spinorAction (signedSpinLift 1 A) psi ≠
      spinorAction (signedSpinLift 0 A) psi := by
  simpa using sl2_sign_pair_spinor_actions_ne A psi hpsi

/-- Central loop lift selected by the gauge-invariant square parity. -/
def squareCycleSpinLift
    (s : SquareEdgeSigns) (A : Matrix (Fin 2) (Fin 2) ℂ) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  signedSpinLift (squareCycleParity s) A

/-- Gauge-equivalent edge sign assignments select the same central loop lift. -/
theorem squareCycleSpinLift_gauge_invariant
    (s t : SquareEdgeSigns) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (h : SquareGaugeEquivalent s t) :
    squareCycleSpinLift s A = squareCycleSpinLift t A := by
  unfold squareCycleSpinLift
  rw [(squareGaugeEquivalent_iff_cycleParity_eq s t).1 h]

/-- **Nonzero two-sector control.** The untwisted and twisted square sectors
have the same Hermitian Lorentz action and determinant-one property, while a
nonzero transformed spinor distinguishes them. -/
theorem squareSpinSectors_same_minkowski_different_spinor
    (A : Matrix (Fin 2) (Fin 2) ℂ) (hA : A.det = 1)
    (M : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ)
    (hpsi : spinorAction A psi ≠ 0) :
    hermitianLorentzAction
        (squareCycleSpinLift untwistedSquareSigns A) M =
      hermitianLorentzAction
        (squareCycleSpinLift twistedSquareSigns A) M ∧
    (squareCycleSpinLift untwistedSquareSigns A).det = 1 ∧
    (squareCycleSpinLift twistedSquareSigns A).det = 1 ∧
    spinorAction (squareCycleSpinLift twistedSquareSigns A) psi ≠
      spinorAction (squareCycleSpinLift untwistedSquareSigns A) psi := by
  rw [show squareCycleSpinLift untwistedSquareSigns A = A by
      simp [squareCycleSpinLift, untwistedSquareSigns_parity],
    show squareCycleSpinLift twistedSquareSigns A = -A by
      simp [squareCycleSpinLift, twistedSquareSigns_parity]]
  exact ⟨(hermitianLorentzAction_neg A M).symm, hA,
    by simpa [neg_det_eq_det] using hA,
    sl2_sign_pair_spinor_actions_ne A psi hpsi⟩

/-- Exact nonzero instance using the identity lift and reference spinor. -/
theorem squareSpinSectors_unit_witness (M : Matrix (Fin 2) (Fin 2) ℂ) :
    hermitianLorentzAction
        (squareCycleSpinLift untwistedSquareSigns spinIdentity) M =
      hermitianLorentzAction
        (squareCycleSpinLift twistedSquareSigns spinIdentity) M ∧
    spinorAction
        (squareCycleSpinLift twistedSquareSigns spinIdentity) up ≠
      spinorAction
        (squareCycleSpinLift untwistedSquareSigns spinIdentity) up := by
  have hdet : spinIdentity.det = 1 := spinIdentity_and_neg_det.1
  have hnonzero : spinorAction spinIdentity up ≠ 0 := by
    rw [spinIdentity_action_up]
    intro h
    have h0 := congrFun h 0
    norm_num [up] at h0
  obtain ⟨haction, _hdet0, _hdet1, hspin⟩ :=
    squareSpinSectors_same_minkowski_different_spinor
      spinIdentity hdet M up hnonzero
  exact ⟨haction, hspin⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.path_signs_gauge_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.path_signs_gauge_trivial

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareGaugeEquivalent_iff_cycleParity_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareGaugeEquivalent_iff_cycleParity_eq

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareGaugeEquivalent_equivalence' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareGaugeEquivalent_equivalence

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.untwisted_not_gaugeEquivalent_twisted' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.untwisted_not_gaugeEquivalent_twisted

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareFaceCompatible_unique_up_to_gauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareFaceCompatible_unique_up_to_gauge

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.doubleSquareCompatible_nonempty_iff_obstruction_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.doubleSquareCompatible_nonempty_iff_obstruction_zero

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.doubleSquare_mismatched_defect_obstructed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.doubleSquare_mismatched_defect_obstructed

/-- info: 'PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareSpinSectors_unit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle.squareSpinSectors_unit_witness

end PhysicsSM.Draft.NullEdge.GraphSpinLiftCocycle
