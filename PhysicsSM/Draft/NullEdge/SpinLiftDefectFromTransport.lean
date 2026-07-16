import PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction

/-!
# Spin-lift face defects derived from finite transport data

This module connects the finite `ZMod 2` obstruction criterion to chosen local
spin lifts on an oriented finite face complex.

An ordered boundary walk and one group-valued lift on each edge determine a
base face holonomy. When every base face holonomy lies in the central pair
`{1, c}` for a nontrivial central involution `c`, that holonomy determines a
unique face-defect bit. Multiplying edge lifts by central signs changes the
derived defect by the face-edge incidence coboundary. Consequently, one sign
correction makes every face holonomy trivial exactly when the derived defect is
correctable, equivalently exactly when no closed face cycle detects it.

The ordered faces, edge lifts, and central-holonomy hypothesis are supplied.
The module does not derive a cell complex or local `SL(2,C)` lifts from a bare
graph, prove that Lorentz-flat face holonomy is central, identify the resulting
class with `w2`, or establish refinement and continuum compatibility. Claim
grade: `M [orig]`.
-/

open Matrix BigOperators

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport

open PhysicsSM.Draft.NullEdge.FiniteSpinCochainObstruction

variable {M Edge Face : Type*}

/-! ## The central sign extension -/

/-- A distinguished nontrivial central element of order two in a group. For a
spin lift, this is the abstract role of the central matrix `-1`. -/
structure CentralSignData (M : Type*) [Group M] where
  element : M
  ne_one : element ≠ 1
  mul_self : element * element = 1
  commutes : forall x : M, element * x = x * element

variable [Group M]

/-- Group element represented by one mod-two central sign. -/
def centralSign (central : CentralSignData M) (b : ZMod 2) : M :=
  if b = 0 then 1 else central.element

@[simp] theorem centralSign_zero (central : CentralSignData M) :
    centralSign central 0 = 1 := by
  simp [centralSign]

@[simp] theorem centralSign_one (central : CentralSignData M) :
    centralSign central 1 = central.element := by
  simp [centralSign]

/-- Addition of parity bits is multiplication of their central signs. -/
theorem centralSign_add (central : CentralSignData M) (a b : ZMod 2) :
    centralSign central (a + b) =
      centralSign central a * centralSign central b := by
  have htwo : (1 : ZMod 2) + 1 = 0 := ZMod.natCast_self 2
  fin_cases a <;> fin_cases b <;>
    simp [centralSign, central.mul_self, htwo]

/-- Every represented sign commutes with every group element. -/
theorem centralSign_commutes
    (central : CentralSignData M) (b : ZMod 2) (x : M) :
    centralSign central b * x = x * centralSign central b := by
  fin_cases b
  · simp [centralSign]
  · simpa [centralSign] using central.commutes x

/-- Every represented sign is its own inverse. -/
theorem centralSign_inv
    (central : CentralSignData M) (b : ZMod 2) :
    (centralSign central b)⁻¹ = centralSign central b := by
  fin_cases b
  · simp
  · simpa [centralSign] using
      (inv_eq_of_mul_eq_one_right central.mul_self)

/-- The nontriviality hypothesis makes the parity representation faithful. -/
theorem centralSign_eq_one_iff
    (central : CentralSignData M) (b : ZMod 2) :
    centralSign central b = 1 ↔ b = 0 := by
  fin_cases b
  · simp
  · simp [centralSign, central.ne_one]

/-! ## Ordered face walks and their incidence matrix -/

/-- One use of an unoriented edge in a face boundary, with a flag recording
whether the chosen edge lift is traversed in reverse. -/
structure OrientedEdge (Edge : Type*) where
  edge : Edge
  reversed : Bool
  deriving DecidableEq

/-- Lift assigned to an oriented traversal. Reverse traversal uses the group
inverse of the chosen forward lift. -/
def orientedLift
    (lift : Edge -> M) (d : OrientedEdge Edge) : M :=
  if d.reversed then (lift d.edge)⁻¹ else lift d.edge

/-- Ordered holonomy of one finite boundary walk. -/
def walkHolonomy (lift : Edge -> M) : List (OrientedEdge Edge) -> M
  | [] => 1
  | d :: path => orientedLift lift d * walkHolonomy lift path

/-- Sum of the edge-correction bits encountered by a boundary walk. Orientation
does not affect a central sign of order two. -/
def walkSignSum
    (s : Edge -> ZMod 2) : List (OrientedEdge Edge) -> ZMod 2
  | [] => 0
  | d :: path => s d.edge + walkSignSum s path

/-- Corrected lift assigned to one oriented traversal. -/
def correctedOrientedLift
    (central : CentralSignData M) (lift : Edge -> M)
    (s : Edge -> ZMod 2) (d : OrientedEdge Edge) : M :=
  centralSign central (s d.edge) * orientedLift lift d

/-- Change the chosen forward lift on every edge by a central sign. -/
def reSignLift
    (central : CentralSignData M) (lift : Edge -> M)
    (s : Edge -> ZMod 2) (e : Edge) : M :=
  centralSign central (s e) * lift e

/-- Correcting an oriented traversal is exactly oriented transport for the
re-signed forward lift. In particular, reverse traversal remains the inverse
of the corrected forward lift. -/
theorem orientedLift_reSignLift
    (central : CentralSignData M) (lift : Edge -> M)
    (s : Edge -> ZMod 2) (d : OrientedEdge Edge) :
    orientedLift (reSignLift central lift s) d =
      correctedOrientedLift central lift s d := by
  rcases d with ⟨e, reversed⟩
  cases reversed
  · simp [orientedLift, reSignLift, correctedOrientedLift]
  · simp only [orientedLift, reSignLift, correctedOrientedLift, if_true]
    rw [_root_.mul_inv_rev]
    rw [centralSign_inv]
    exact (centralSign_commutes central (s e) (lift e)⁻¹).symm

/-- Ordered holonomy after changing each chosen edge lift by one central sign. -/
def correctedWalkHolonomy
    (central : CentralSignData M) (lift : Edge -> M)
    (s : Edge -> ZMod 2) : List (OrientedEdge Edge) -> M
  | [] => 1
  | d :: path =>
      correctedOrientedLift central lift s d *
        correctedWalkHolonomy central lift s path

/-- Centrality factors every edge correction out of the ordered product. -/
theorem correctedWalkHolonomy_factor
    (central : CentralSignData M) (lift : Edge -> M)
    (s : Edge -> ZMod 2) (path : List (OrientedEdge Edge)) :
    correctedWalkHolonomy central lift s path =
      centralSign central (walkSignSum s path) * walkHolonomy lift path := by
  induction path with
  | nil => simp [correctedWalkHolonomy, walkSignSum, walkHolonomy]
  | cons d path ih =>
      simp only [correctedWalkHolonomy, correctedOrientedLift,
        walkSignSum, walkHolonomy]
      rw [ih]
      calc
        (centralSign central (s d.edge) * orientedLift lift d) *
            (centralSign central (walkSignSum s path) *
              walkHolonomy lift path) =
          centralSign central (s d.edge) *
            (orientedLift lift d *
              centralSign central (walkSignSum s path)) *
                walkHolonomy lift path := by simp [mul_assoc]
        _ = centralSign central (s d.edge) *
            (centralSign central (walkSignSum s path) *
              orientedLift lift d) * walkHolonomy lift path := by
              rw [← centralSign_commutes central
                (walkSignSum s path) (orientedLift lift d)]
        _ = (centralSign central (s d.edge) *
              centralSign central (walkSignSum s path)) *
                (orientedLift lift d * walkHolonomy lift path) := by
              simp [mul_assoc]
        _ = centralSign central
              (s d.edge + walkSignSum s path) *
                (orientedLift lift d * walkHolonomy lift path) := by
              rw [centralSign_add]

/-- Corrected walk holonomy is literally the holonomy of the re-signed edge
lift field. -/
theorem walkHolonomy_reSignLift
    (central : CentralSignData M) (lift : Edge -> M)
    (s : Edge -> ZMod 2) (path : List (OrientedEdge Edge)) :
    walkHolonomy (reSignLift central lift s) path =
      correctedWalkHolonomy central lift s path := by
  induction path with
  | nil => simp [walkHolonomy, correctedWalkHolonomy]
  | cons d path ih =>
      simp only [walkHolonomy, correctedWalkHolonomy]
      rw [orientedLift_reSignLift, ih]

/-- Mod-two incidence row of an ordered boundary walk. Repeated uses of an edge
cancel in pairs. -/
def walkIncidenceRow [DecidableEq Edge] :
    List (OrientedEdge Edge) -> Edge -> ZMod 2
  | [], _ => 0
  | d :: path, e =>
      (if d.edge = e then 1 else 0) + walkIncidenceRow path e

/-- The incidence row acts on an edge cochain by summing its values along the
ordered walk. -/
theorem incidenceRow_mulVec_eq_walkSignSum
    [Fintype Edge] [DecidableEq Edge]
    (path : List (OrientedEdge Edge)) (s : Edge -> ZMod 2) :
    (∑ e, walkIncidenceRow path e * s e) = walkSignSum s path := by
  induction path with
  | nil => simp [walkIncidenceRow, walkSignSum]
  | cons d path ih =>
      simp only [walkIncidenceRow, walkSignSum]
      calc
        (∑ e, ((if d.edge = e then 1 else 0) +
            walkIncidenceRow path e) * s e) =
          (∑ e, (if d.edge = e then 1 else 0) * s e) +
            ∑ e, walkIncidenceRow path e * s e := by
              simp_rw [add_mul]
              exact Finset.sum_add_distrib
        _ = s d.edge + walkSignSum s path := by rw [ih]; simp

/-- Face-edge incidence matrix derived from supplied ordered face boundaries. -/
def faceBoundaryMatrix
    [DecidableEq Edge]
    (boundaryWalk : Face -> List (OrientedEdge Edge)) :
    FaceBoundary Face Edge :=
  fun f => walkIncidenceRow (boundaryWalk f)

/-- The derived matrix coboundary is exactly the sign sum along each face
boundary. -/
theorem faceCoboundary_eq_walkSignSum
    [Fintype Edge] [DecidableEq Edge]
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (s : Edge -> ZMod 2) (f : Face) :
    faceCoboundary (faceBoundaryMatrix boundaryWalk) s f =
      walkSignSum s (boundaryWalk f) := by
  change (∑ e, walkIncidenceRow (boundaryWalk f) e * s e) = _
  exact incidenceRow_mulVec_eq_walkSignSum (boundaryWalk f) s

/-! ## Defect extracted from central face holonomy -/

/-- The parity encoded by a group element known to lie in `{1, c}`. -/
def centralDefect (x : M) : ZMod 2 :=
  by
    classical
    exact if x = 1 then 0 else 1

/-- A central face holonomy is recovered exactly from its derived defect bit. -/
theorem centralSign_centralDefect
    (central : CentralSignData M) (x : M)
    (hx : x = 1 ∨ x = central.element) :
    centralSign central (centralDefect x) = x := by
  rcases hx with rfl | rfl
  · simp [centralDefect]
  · simp [centralDefect, central.ne_one]

/-- Extracting the defect of a represented central sign recovers its parity. -/
theorem centralDefect_centralSign
    (central : CentralSignData M) (b : ZMod 2) :
    centralDefect (centralSign central b) = b := by
  fin_cases b
  · simp [centralDefect]
  · simp [centralDefect, central.ne_one]

/-- Base holonomy around one supplied face boundary. -/
def faceHolonomy
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) (f : Face) : M :=
  walkHolonomy lift (boundaryWalk f)

/-- Face defect derived from the ordered product of chosen local edge lifts. -/
def derivedFaceDefect
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) : FaceDefect Face :=
  fun f => centralDefect (faceHolonomy boundaryWalk lift f)

/-- Face holonomy after one central sign correction on every edge lift. -/
def correctedFaceHolonomy
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) (s : Edge -> ZMod 2) (f : Face) : M :=
  correctedWalkHolonomy central lift s (boundaryWalk f)

/-- Face holonomy of the re-signed lift field is the corrected face holonomy. -/
theorem faceHolonomy_reSignLift
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) (s : Edge -> ZMod 2) (f : Face) :
    faceHolonomy boundaryWalk (reSignLift central lift s) f =
      correctedFaceHolonomy central boundaryWalk lift s f := by
  exact walkHolonomy_reSignLift central lift s (boundaryWalk f)

/-- Corrected face holonomy is the incidence coboundary sign times the base
face holonomy. -/
theorem correctedFaceHolonomy_factor
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) (s : Edge -> ZMod 2) (f : Face) :
    correctedFaceHolonomy central boundaryWalk lift s f =
      centralSign central
          (faceCoboundary (faceBoundaryMatrix boundaryWalk) s f) *
        faceHolonomy boundaryWalk lift f := by
  rw [correctedFaceHolonomy, faceHolonomy,
    correctedWalkHolonomy_factor,
    faceCoboundary_eq_walkSignSum]

/-- If the base face holonomy is central, the corrected holonomy is represented
by the sum of its derived defect and the incidence coboundary. -/
theorem correctedFaceHolonomy_eq_centralSign_add
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element)
    (s : Edge -> ZMod 2) (f : Face) :
    correctedFaceHolonomy central boundaryWalk lift s f =
      centralSign central
        (faceCoboundary (faceBoundaryMatrix boundaryWalk) s f +
          derivedFaceDefect boundaryWalk lift f) := by
  rw [correctedFaceHolonomy_factor]
  rw [← centralSign_centralDefect central
    (faceHolonomy boundaryWalk lift f) (hcentral f)]
  rw [← centralSign_add]
  rfl

/-- **Lift-choice equivariance.** Re-signing the chosen edge lifts changes the
derived face defect by exactly the incidence coboundary. -/
theorem derivedFaceDefect_reSignLift
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element)
    (s : Edge -> ZMod 2) :
    derivedFaceDefect boundaryWalk (reSignLift central lift s) =
      faceCoboundary (faceBoundaryMatrix boundaryWalk) s +
        derivedFaceDefect boundaryWalk lift := by
  funext f
  unfold derivedFaceDefect
  rw [faceHolonomy_reSignLift,
    correctedFaceHolonomy_eq_centralSign_add central boundaryWalk lift
      hcentral s f,
    centralDefect_centralSign]
  rfl

/-- Characteristic two turns vanishing of a two-term sum into equality. -/
theorem zmod_two_add_eq_zero_iff_eq (a b : ZMod 2) :
    a + b = 0 ↔ a = b := by
  fin_cases a <;> fin_cases b <;> norm_num
  exact ZMod.natCast_self 2

/-- One corrected face is flat exactly when its edge-sign coboundary equals the
defect derived from the chosen base lifts. -/
theorem correctedFaceHolonomy_eq_one_iff
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element)
    (s : Edge -> ZMod 2) (f : Face) :
    correctedFaceHolonomy central boundaryWalk lift s f = 1 ↔
      faceCoboundary (faceBoundaryMatrix boundaryWalk) s f =
        derivedFaceDefect boundaryWalk lift f := by
  rw [correctedFaceHolonomy_eq_centralSign_add central boundaryWalk lift
    hcentral s f, centralSign_eq_one_iff, zmod_two_add_eq_zero_iff_eq]

/-- One edge-sign correction trivializes all supplied face holonomies. -/
def AllFacesFlat
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) (s : Edge -> ZMod 2) : Prop :=
  forall f, correctedFaceHolonomy central boundaryWalk lift s f = 1

/-- **Transport-to-cochain bridge.** A global central sign correction makes all
derived face holonomies trivial exactly when the derived defect cochain lies in
the incidence coboundary range. -/
theorem allFacesFlat_nonempty_iff_correctable
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element) :
    (exists s : Edge -> ZMod 2,
      AllFacesFlat central boundaryWalk lift s) ↔
      Correctable (faceBoundaryMatrix boundaryWalk)
        (derivedFaceDefect boundaryWalk lift) := by
  constructor
  · rintro ⟨s, hs⟩
    refine ⟨s, funext fun f => ?_⟩
    exact (correctedFaceHolonomy_eq_one_iff central boundaryWalk lift
      hcentral s f).1 (hs f)
  · rintro ⟨s, hs⟩
    refine ⟨s, ?_⟩
    intro f
    exact (correctedFaceHolonomy_eq_one_iff central boundaryWalk lift
      hcentral s f).2 (congrFun hs f)

/-- **Closed-cycle criterion for chosen lifts.** A global correction makes all
central face holonomies trivial exactly when no closed face cycle has nonzero
pairing with the defect extracted from those holonomies. -/
theorem allFacesFlat_nonempty_iff_noDetectedObstruction
    [Finite Edge] [DecidableEq Edge] [Fintype Face]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element) :
    (exists s : Edge -> ZMod 2,
      AllFacesFlat central boundaryWalk lift s) ↔
      ¬ HasDetectedObstruction (faceBoundaryMatrix boundaryWalk)
        (derivedFaceDefect boundaryWalk lift) := by
  letI := Fintype.ofFinite Edge
  exact (allFacesFlat_nonempty_iff_correctable central boundaryWalk lift
    hcentral).trans
      (correctable_iff_not_detectedObstruction
        (faceBoundaryMatrix boundaryWalk)
        (derivedFaceDefect boundaryWalk lift))

/-! ## Choice-independent transport obstruction -/

/-- Quotient obstruction class derived from the chosen edge lifts. The class
becomes choice-independent only after applying the re-signing theorem below. -/
def transportObstructionClass
    [Fintype Edge] [DecidableEq Edge]
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M) :
    ObstructionSpace (faceBoundaryMatrix boundaryWalk) :=
  obstructionClass (faceBoundaryMatrix boundaryWalk)
    (derivedFaceDefect boundaryWalk lift)

/-- **Choice independence under central lift re-signing.** Every edge sign
choice gives the same quotient obstruction class. -/
theorem transportObstructionClass_reSignLift
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element)
    (s : Edge -> ZMod 2) :
    transportObstructionClass boundaryWalk
        (reSignLift central lift s) =
      transportObstructionClass boundaryWalk lift := by
  unfold transportObstructionClass
  rw [derivedFaceDefect_reSignLift central boundaryWalk lift hcentral s,
    obstructionClass_add_coboundary]

/-- The transport obstruction class vanishes exactly when one central
re-signing trivializes every supplied face holonomy. -/
theorem transportObstructionClass_eq_zero_iff_allFacesFlat
    [Fintype Edge] [DecidableEq Edge]
    (central : CentralSignData M)
    (boundaryWalk : Face -> List (OrientedEdge Edge))
    (lift : Edge -> M)
    (hcentral : forall f,
      faceHolonomy boundaryWalk lift f = 1 ∨
        faceHolonomy boundaryWalk lift f = central.element) :
    transportObstructionClass boundaryWalk lift = 0 ↔
      exists s : Edge -> ZMod 2,
        AllFacesFlat central boundaryWalk lift s := by
  exact (obstructionClass_eq_zero_iff_correctable
    (faceBoundaryMatrix boundaryWalk)
    (derivedFaceDefect boundaryWalk lift)).trans
      (allFacesFlat_nonempty_iff_correctable central boundaryWalk lift
        hcentral).symm

/-! ## Exact nonempty transport fixture -/

/-- A minimal concrete group carrying one nontrivial central sign. -/
abbrev SignGroup := Multiplicative (ZMod 2)

/-- The nonzero element of `ZMod 2`, viewed multiplicatively, is a nontrivial
central involution. This fixture establishes consistency and nonemptiness; it
is not an `SL(2,C)` realization. -/
def signGroupCentral : CentralSignData SignGroup where
  element := Multiplicative.ofAdd 1
  ne_one := by
    intro h
    have h' := congrArg Multiplicative.toAdd h
    norm_num at h'
  mul_self := by
    apply Multiplicative.toAdd.injective
    change (1 : ZMod 2) + 1 = 0
    exact ZMod.natCast_self 2
  commutes := by
    intro x
    apply Multiplicative.toAdd.injective
    exact add_comm _ _

/-- Forward use of one edge in an ordered boundary walk. -/
def forwardEdge {E : Type*} (e : E) : OrientedEdge E := ⟨e, false⟩

/-- One oriented four-edge square face. -/
def signSquareBoundaryWalk : Fin 1 -> List (OrientedEdge (Fin 4)) :=
  fun _ => [forwardEdge 0, forwardEdge 1, forwardEdge 2, forwardEdge 3]

/-- Chosen edge lifts with one nontrivial central edge. -/
def signSquareLift : Fin 4 -> SignGroup :=
  fun e => if e = 0 then signGroupCentral.element else 1

/-- Correction that changes the sign of that same edge. -/
def signSquareCorrection : Fin 4 -> ZMod 2 :=
  fun e => if e = 0 then 1 else 0

/-- The chosen square lifts have nontrivial central base holonomy. -/
theorem signSquare_baseHolonomy (f : Fin 1) :
    faceHolonomy signSquareBoundaryWalk signSquareLift f =
      signGroupCentral.element := by
  fin_cases f
  simp [faceHolonomy, signSquareBoundaryWalk, signSquareLift, forwardEdge,
    walkHolonomy, orientedLift, signGroupCentral]

/-- The nontrivial square holonomy is extracted as defect bit one. -/
theorem signSquare_derivedFaceDefect (f : Fin 1) :
    derivedFaceDefect signSquareBoundaryWalk signSquareLift f = 1 := by
  fin_cases f
  simp [derivedFaceDefect, centralDefect, faceHolonomy,
    signSquareBoundaryWalk, signSquareLift, forwardEdge, walkHolonomy,
    orientedLift, signGroupCentral]

/-- The displayed edge correction trivializes the square holonomy exactly. -/
theorem signSquare_correction_flat :
    AllFacesFlat signGroupCentral signSquareBoundaryWalk signSquareLift
      signSquareCorrection := by
  intro f
  fin_cases f
  simp [correctedFaceHolonomy, correctedWalkHolonomy,
    correctedOrientedLift, centralSign, signSquareBoundaryWalk,
    signSquareLift, signSquareCorrection, forwardEdge, orientedLift,
    signGroupCentral]
  exact ZMod.natCast_self 2

/-- The square's defect representative is nonzero, but its choice-independent
quotient obstruction class vanishes because the displayed correction flattens
the face. -/
theorem signSquare_transportObstructionClass_eq_zero :
    transportObstructionClass signSquareBoundaryWalk signSquareLift = 0 := by
  have hcentral : forall f,
      faceHolonomy signSquareBoundaryWalk signSquareLift f = 1 ∨
        faceHolonomy signSquareBoundaryWalk signSquareLift f =
          signGroupCentral.element :=
    fun f => Or.inr (signSquare_baseHolonomy f)
  exact (transportObstructionClass_eq_zero_iff_allFacesFlat signGroupCentral
    signSquareBoundaryWalk signSquareLift hcentral).2
      ⟨signSquareCorrection, signSquare_correction_flat⟩

/-- **Nonvacuity control.** A nonidentity central face product produces defect
one, and an explicit edge correction removes it. The resulting derived defect
therefore has no closed-cycle obstruction. -/
theorem signSquare_transport_bridge_nonvacuous :
    (forall f, faceHolonomy signSquareBoundaryWalk signSquareLift f =
      signGroupCentral.element) ∧
    (forall f, derivedFaceDefect signSquareBoundaryWalk signSquareLift f = 1) ∧
    AllFacesFlat signGroupCentral signSquareBoundaryWalk signSquareLift
      signSquareCorrection ∧
    ¬ HasDetectedObstruction (faceBoundaryMatrix signSquareBoundaryWalk)
      (derivedFaceDefect signSquareBoundaryWalk signSquareLift) := by
  have hcentral : forall f,
      faceHolonomy signSquareBoundaryWalk signSquareLift f = 1 ∨
        faceHolonomy signSquareBoundaryWalk signSquareLift f =
          signGroupCentral.element :=
    fun f => Or.inr (signSquare_baseHolonomy f)
  have hnoObstruction :=
    (allFacesFlat_nonempty_iff_noDetectedObstruction signGroupCentral
      signSquareBoundaryWalk signSquareLift hcentral).1
      ⟨signSquareCorrection, signSquare_correction_flat⟩
  exact ⟨signSquare_baseHolonomy, signSquare_derivedFaceDefect,
    signSquare_correction_flat, hnoObstruction⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.correctedWalkHolonomy_factor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctedWalkHolonomy_factor

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.correctedFaceHolonomy_eq_one_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctedFaceHolonomy_eq_one_iff

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.derivedFaceDefect_reSignLift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms derivedFaceDefect_reSignLift

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.transportObstructionClass_reSignLift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms transportObstructionClass_reSignLift

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.transportObstructionClass_eq_zero_iff_allFacesFlat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms transportObstructionClass_eq_zero_iff_allFacesFlat

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.signSquare_transportObstructionClass_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signSquare_transportObstructionClass_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.allFacesFlat_nonempty_iff_correctable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms allFacesFlat_nonempty_iff_correctable

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.allFacesFlat_nonempty_iff_noDetectedObstruction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms allFacesFlat_nonempty_iff_noDetectedObstruction

/-- info: 'PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport.signSquare_transport_bridge_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signSquare_transport_bridge_nonvacuous

end PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport
