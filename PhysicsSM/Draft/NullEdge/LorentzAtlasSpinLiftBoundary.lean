import PhysicsSM.Draft.NullEdge.SL2CLorentzAction

/-!
# Lorentz-atlas spin-lift boundary

This module connects three finite layers of the null-edge gravity program:

1. exact eta-Lorentz Cech transitions on chart overlaps;
2. chosen local `SL(2,C)` preimages under the concrete Hermitian action;
3. the central `ZMod 2` face defects used by the existing finite spin-cochain
   obstruction theory.

The product of chosen spin lifts around every occupied Cech triangle lies in
the kernel of the concrete Lorentz action.  The concrete kernel is proved to
be exactly `{+I, -I}`, so the triangle product is a unique central sign and
therefore determines the required face-defect bit.  Changing a local lift by
either central sign leaves its Lorentz transition unchanged.

Surjectivity onto the proper-orthochronous Lorentz group remains a separate
finite covering statement.  This module also assumes that local edge lifts
have been chosen.  It does not derive a Lorentz atlas or its lifts from a bare
graph, prove the obstruction class vanishes, identify it with continuum `w2`,
or establish refinement compatibility.

Claim grade: `M [orig/comp]`, finite group and Cech algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary

open PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy
open PhysicsSM.Draft.NullEdge.LorentzAtlasStructureGroup
open PhysicsSM.Draft.NullEdge.SL2CCentralSign
open PhysicsSM.Draft.NullEdge.SL2CLorentzAction
open PhysicsSM.Draft.NullEdge.SpinLiftDefectFromTransport

/-- Eta-Lorentz transition data on ordered chart pairs. -/
abbrev LorentzTransitionField (I : Type*) :=
  TransitionField I EtaLorentzGroup

/-- Chosen `SL(2,C)` transition lifts on ordered chart pairs. -/
abbrev SpinTransitionField (I : Type*) :=
  TransitionField I SL2C

/-- A chosen spin transition projects to the supplied Lorentz transition on
every occupied pair overlap. -/
def IsSpinLiftOn {I : Type*}
    (pairOverlap : I -> I -> Prop)
    (T : LorentzTransitionField I)
    (lift : SpinTransitionField I) : Prop :=
  forall i j, pairOverlap i j -> sl2ToEtaLorentz (lift i j) = T i j

/-- Ordered product of chosen spin lifts around a chart triangle. -/
def triangleLiftProduct {I : Type*}
    (lift : SpinTransitionField I) (i j k : I) : SL2C :=
  lift i j * lift j k * lift k i

/-- The exact-kernel gate for the concrete Hermitian Lorentz action. -/
def HasExactCentralKernel : Prop :=
  forall A : SL2C,
    sl2ToEtaLorentz A = 1 <-> Or (A = 1) (A = minusIdentity)

/-- It is enough to prove that the kernel contains no elements beyond the two
already-known central signs. -/
def KernelContainedInCentralPair : Prop :=
  forall A : SL2C,
    sl2ToEtaLorentz A = 1 -> Or (A = 1) (A = minusIdentity)

/-- The reverse inclusion in the exact-kernel statement is already proved by
the identity law and the explicit `-I` kernel witness. -/
theorem hasExactCentralKernel_iff_kernelContainedInCentralPair :
    HasExactCentralKernel <-> KernelContainedInCentralPair := by
  constructor
  · intro h A hA
    exact (h A).1 hA
  · intro h A
    constructor
    · exact h A
    · rintro (rfl | rfl)
      · exact map_one sl2ToEtaLorentz
      · exact minusIdentity_mem_kernel

/-- The production Hermitian action satisfies the exact central-kernel gate. -/
theorem concreteHasExactCentralKernel : HasExactCentralKernel :=
  sl2ToEtaLorentz_eq_one_iff

/-- Both central signs project to the identity Lorentz transformation. -/
theorem sl2ToEtaLorentz_centralSign (b : ZMod 2) :
    sl2ToEtaLorentz (centralSign centralSignData b) = 1 := by
  fin_cases b
  · simp
  · simpa [centralSignData] using minusIdentity_mem_kernel

/-- Change each chosen local lift by an independently selected central sign. -/
def reSignSpinLift {I : Type*}
    (sign : I -> I -> ZMod 2) (lift : SpinTransitionField I) :
    SpinTransitionField I :=
  fun i j => centralSign centralSignData (sign i j) * lift i j

/-- Central re-signing does not change the projected Lorentz transition. -/
theorem isSpinLiftOn_reSign {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (hLift : IsSpinLiftOn pairOverlap T lift)
    (sign : I -> I -> ZMod 2) :
    IsSpinLiftOn pairOverlap T (reSignSpinLift sign lift) := by
  intro i j hij
  rw [reSignSpinLift, map_mul, sl2ToEtaLorentz_centralSign, one_mul]
  exact hLift i j hij

/-- A locally liftable Lorentz transition is necessarily time oriented. -/
theorem timeCharacter_eq_one_of_spinLift {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i j : I} (hij : pairOverlap i j) :
    timeCharacter (T i j) = 1 := by
  rw [<- hLift i j hij]
  exact timeCharacter_sl2ToEtaLorentz (lift i j)

/-- A chosen lift on an occupied diagonal overlap differs from the identity by
an element of the concrete Lorentz kernel. -/
theorem diagonalLift_mem_kernel {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i : I} (hii : pairOverlap i i) :
    sl2ToEtaLorentz (lift i i) = 1 := by
  calc
    sl2ToEtaLorentz (lift i i) = T i i := hLift i i hii
    _ = 1 := S.normalized i hii

/-- The product of chosen lifts in the two orientations of an occupied overlap
lies in the concrete Lorentz kernel.  No inverse coherence of the chosen lifts
is silently assumed. -/
theorem inverseLiftProduct_mem_kernel {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i j : I} (hij : pairOverlap i j)
    (pair_symmetric : pairOverlap i j -> pairOverlap j i) :
    sl2ToEtaLorentz (lift i j * lift j i) = 1 := by
  have hji := pair_symmetric hij
  calc
    sl2ToEtaLorentz (lift i j * lift j i) = T i j * T j i := by
      simp [hLift i j hij, hLift j i hji]
    _ = 1 := S.inverse i j hij

/-- Failure of the two oriented overlap lifts to be literal inverses is
exactly one central sign. -/
theorem inverseLiftProduct_isCentral {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i j : I} (hij : pairOverlap i j)
    (pair_symmetric : pairOverlap i j -> pairOverlap j i) :
    Or (lift i j * lift j i = 1)
      (lift i j * lift j i = minusIdentity) := by
  apply (concreteHasExactCentralKernel (lift i j * lift j i)).1
  exact inverseLiftProduct_mem_kernel S hLift hij pair_symmetric

/-- **Cech-to-kernel bridge.** The product of chosen spin lifts around every
occupied Lorentz Cech triangle lies in the kernel of the concrete action. -/
theorem triangleLiftProduct_mem_kernel {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i j k : I} (hijk : tripleOverlap i j k)
    (triple_implies_pairs :
      tripleOverlap i j k ->
        pairOverlap i j /\ pairOverlap j k /\ pairOverlap k i /\
          pairOverlap i k) :
    sl2ToEtaLorentz (triangleLiftProduct lift i j k) = 1 := by
  obtain ⟨hij, hjk, hki, hik⟩ := triple_implies_pairs hijk
  calc
    sl2ToEtaLorentz (triangleLiftProduct lift i j k) =
        triangleProduct T i j k := by
      simp [triangleLiftProduct, triangleProduct,
        hLift i j hij, hLift j k hjk, hLift k i hki]
    _ = 1 := cech_triangle_holonomy_trivial S hijk (fun _ => hik)

/-- Every lifted Cech triangle product is one of the two central spin signs. -/
theorem triangleLiftProduct_isCentral {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i j k : I} (hijk : tripleOverlap i j k)
    (triple_implies_pairs :
      tripleOverlap i j k ->
        pairOverlap i j /\ pairOverlap j k /\ pairOverlap k i /\
          pairOverlap i k) :
    Or (triangleLiftProduct lift i j k = 1)
      (triangleLiftProduct lift i j k = minusIdentity) := by
  apply (concreteHasExactCentralKernel
    (triangleLiftProduct lift i j k)).1
  exact triangleLiftProduct_mem_kernel S hLift hijk triple_implies_pairs

/-- The central face-defect bit extracted from one chosen lifted triangle. -/
def triangleSpinDefect {I : Type*}
    (lift : SpinTransitionField I) (i j k : I) : ZMod 2 :=
  centralDefect (triangleLiftProduct lift i j k)

/-- The extracted bit reconstructs the literal spin-lift product around the
occupied Cech triangle. -/
theorem centralSign_triangleSpinDefect {I : Type*}
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : LorentzTransitionField I}
    {lift : SpinTransitionField I}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (hLift : IsSpinLiftOn pairOverlap T lift)
    {i j k : I} (hijk : tripleOverlap i j k)
    (triple_implies_pairs :
      tripleOverlap i j k ->
        pairOverlap i j /\ pairOverlap j k /\ pairOverlap k i /\
          pairOverlap i k) :
    centralSign centralSignData (triangleSpinDefect lift i j k) =
      triangleLiftProduct lift i j k := by
  exact centralSign_centralDefect centralSignData _
    (triangleLiftProduct_isCentral S hLift hijk
      triple_implies_pairs)

end PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.hasExactCentralKernel_iff_kernelContainedInCentralPair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.hasExactCentralKernel_iff_kernelContainedInCentralPair

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.inverseLiftProduct_isCentral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.inverseLiftProduct_isCentral

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.triangleLiftProduct_mem_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.triangleLiftProduct_mem_kernel

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.centralSign_triangleSpinDefect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LorentzAtlasSpinLiftBoundary.centralSign_triangleSpinDefect
