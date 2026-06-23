import Mathlib.Tactic

set_option linter.unusedVariables false

/-!
# NullEdgeP3CrossedModule

This module formalizes crossed-module transport and vertical/horizontal
composition. It integrates Aristotle project
`1f2a340d-e077-4dfe-a682-c018f5e99fea`.

It defines:
* A `CrossedModule` structure representing a group homomorphism `H -> G`.
* A `FakeFlat` predicate on path pairs.
* Vertical/horizontal compositions of 2-cells.
* Proofs that composition preserves fake-flatness and satisfies the 2-cell
  interchange law.

Scientific role: this is the finite higher-gauge handoff for the causal-diamond
layer. Fake-flatness says that an `H`-valued 2-cell maps to the boundary
path-comparison defect in `G`; the interchange theorem is the double-category
law needed before treating diamond defects as a crossed-module 2-connection.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP3CrossedModule

/-- The path-pair of a causal diamond, representing left and right branch holonomies. -/
structure PathPair (G : Type*) where
  left : G
  right : G

/-- Path-comparison defect. -/
def pathPairDefect [Group G] (P : PathPair G) : G :=
  Inv.inv P.left * P.right

def verticalComposePathPair [Mul G] (P Q : PathPair G) : PathPair G where
  left := P.left * Q.left
  right := P.right * Q.right

def horizontalComposePathPair [Mul G] (P Q : PathPair G) : PathPair G where
  left := P.left
  right := Q.right

theorem pathPairDefect_verticalCompose [Group G] (P Q : PathPair G) :
    pathPairDefect (verticalComposePathPair P Q) =
      Inv.inv Q.left * pathPairDefect P * Q.left * pathPairDefect Q := by
  simp [pathPairDefect, verticalComposePathPair, mul_assoc]

theorem pathPairDefect_horizontalCompose [Group G] (P Q : PathPair G)
    (h : P.right = Q.left) :
    pathPairDefect (horizontalComposePathPair P Q) =
      pathPairDefect P * pathPairDefect Q := by
  simp [pathPairDefect, horizontalComposePathPair, h, mul_assoc]

/-- A crossed module of groups `H -> G`. -/
structure CrossedModule (G H : Type*) [Group G] [Group H] where
  toHom : MonoidHom H G
  act : G -> H -> H
  act_mul : forall (g : G) (h1 h2 : H), act g (h1 * h2) = act g h1 * act g h2
  act_one : forall (g : G), act g 1 = 1
  act_mul_assoc : forall (g1 g2 : G) (h : H),
    act (g1 * g2) h = act g1 (act g2 h)
  act_one_assoc : forall (h : H), act 1 h = h
  toHom_act : forall (g : G) (h : H),
    toHom (act g h) = g * toHom h * Inv.inv g
  peiffer : forall (h1 h2 : H), act (toHom h1) h2 = h1 * h2 * Inv.inv h1

variable {G H : Type*} [Group G] [Group H]

/-- Fake-flatness condition: the 2-cell label maps to the boundary path-pair defect. -/
def FakeFlat (X : CrossedModule G H) (P : PathPair G) (h : H) : Prop :=
  X.toHom h = pathPairDefect P

def verticalCompose2Cell (X : CrossedModule G H) (_P Q : PathPair G)
    (hP hQ : H) : H :=
  X.act (Inv.inv Q.left) hP * hQ

def horizontalCompose2Cell (hP hQ : H) : H :=
  hP * hQ

/-- Vertical composition preserves fake-flatness. -/
theorem fakeFlat_verticalCompose (X : CrossedModule G H) (P Q : PathPair G) (hP hQ : H)
    (hfP : FakeFlat X P hP) (hfQ : FakeFlat X Q hQ) :
    FakeFlat X (verticalComposePathPair P Q) (verticalCompose2Cell X P Q hP hQ) := by
  unfold verticalComposePathPair verticalCompose2Cell FakeFlat at *
  simp +decide [hfP, hfQ, X.toHom_act, pathPairDefect]
  group

/-- Horizontal composition preserves fake-flatness. -/
theorem fakeFlat_horizontalCompose (X : CrossedModule G H) (P Q : PathPair G) (hP hQ : H)
    (hcomp : P.right = Q.left) (hfP : FakeFlat X P hP) (hfQ : FakeFlat X Q hQ) :
    FakeFlat X (horizontalComposePathPair P Q) (horizontalCompose2Cell hP hQ) := by
  unfold FakeFlat horizontalComposePathPair horizontalCompose2Cell
  rw [map_mul, hfP, hfQ]
  simp +decide [pathPairDefect, hcomp]
  simp +decide [<- mul_assoc]

/-- The double-category interchange law holds for fake-flat 2-cells. -/
theorem crossedModule_2cell_interchange (X : CrossedModule G H)
    (A B C D : PathPair G) (hAB : A.right = B.left) (hCD : C.right = D.left)
    (hA : H) (hB : H) (hC : H) (hD : H)
    (hfA : FakeFlat X A hA) (hfB : FakeFlat X B hB)
    (hfC : FakeFlat X C hC) (hfD : FakeFlat X D hD) :
    horizontalCompose2Cell (verticalCompose2Cell X A C hA hC)
        (verticalCompose2Cell X B D hB hD) =
      verticalCompose2Cell X (horizontalComposePathPair A B) (horizontalComposePathPair C D)
        (horizontalCompose2Cell hA hB) (horizontalCompose2Cell hC hD) := by
  unfold horizontalCompose2Cell verticalCompose2Cell
  -- The middle commutation follows from fake-flatness of `C` and Peiffer.
  have h_eq : hC * X.act (Inv.inv D.left) hB = X.act (Inv.inv C.left) hB * hC := by
    have h_tohom : X.toHom hC * Inv.inv D.left = Inv.inv C.left := by
      simp_all [FakeFlat, pathPairDefect]
    rw [<- h_tohom, X.act_mul_assoc]
    simp [X.peiffer, mul_assoc]
  simp_all [<- mul_assoc, CrossedModule.act_mul]
  simp_all [mul_assoc, horizontalComposePathPair]

end PhysicsSM.Draft.NullEdgeP3CrossedModule

end
