import PhysicsSM.Draft.NullEdge.PlueckerGeometricCone

/-!
# Pairwise-disjoint layer-depth cone for Pluecker gates

Handoff target for Paper E.  The imported theorem counts sequential gates.
This file asks for the exact upgrade in which pairwise-disjoint local gates are
one layer and support expands by at most one neighborhood step per layer.
-/

noncomputable section

open Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerLayerCone

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.PlueckerCausalCone

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

abbrev Layer (ι : Type*) [DecidableEq ι] := List (Block ι)

/-- Distinct gates in one layer have disjoint mode supports. -/
def LayerDisjoint (layer : Layer ι) : Prop :=
  layer.Pairwise fun m n => Disjoint (block m) (block n)

/-- If a block is disjoint from all blocks in a layer and from `R`, then it is
disjoint from the layer cone over `R`. -/
theorem disjoint_coneRegion_of_disjoint_blocks (m : Block ι) (ms : List (Block ι))
    (R : Finset ι) (hR : Disjoint (block m) R)
    (hms : ∀ n ∈ ms, Disjoint (block m) (block n)) :
    Disjoint (block m) (coneRegion ms R) := by
  induction ms generalizing R with
  | nil => simpa [coneRegion] using hR
  | cons n ms ih =>
      have htail : Disjoint (block m) (coneRegion ms R) := ih R hR (by
        intro k hk
        exact hms k (by simp [hk]))
      have hn : Disjoint (block m) (block n) := hms n (by simp)
      simpa [coneRegion] using (Finset.disjoint_union_right.mpr ⟨hn, htail⟩)

/-- The pruned cone of a pairwise-disjoint local layer lies inside one
neighborhood step from the initial region. -/
theorem reachCone_subset_ballStep_of_layerDisjoint
    (N : ι -> Finset ι) (hN : ∀ i, i ∈ N i)
    (layer : Layer ι) (hdisj : LayerDisjoint layer)
    (hloc : ∀ m ∈ layer, BlockLocal N m)
    (R : Finset ι) :
    reachCone layer R ⊆ ballStep N R := by
  induction layer generalizing R with
  | nil =>
      simpa [reachCone, ballStep] using subset_ballStep N hN R
  | cons m ms ih =>
      have hms : LayerDisjoint ms := hdisj.tail
      have hmem : ∀ n ∈ ms, Disjoint (block m) (block n) := by
        intro n hn
        exact hdisj.rel_head_tail hn
      have hlocTail : ∀ n ∈ ms, BlockLocal N n := by
        intro n hn
        exact hloc n (by simp [hn])
      by_cases hcone : Disjoint (block m) (reachCone ms R)
      · simpa [reachCone_cons, reachStep, hcone] using (ih (R := R) hms hlocTail)
      · have hR : ¬ Disjoint (block m) R := by
          intro hdisjR
          have hconeRegion : Disjoint (block m) (coneRegion ms R) :=
            disjoint_coneRegion_of_disjoint_blocks m ms R hdisjR hmem
          have hcone' : Disjoint (block m) (reachCone ms R) :=
            Disjoint.mono le_rfl (reachCone_subset_coneRegion ms R) hconeRegion
          exact hcone hcone'
        have hm : block m ⊆ ballStep N R := (hloc m (by simp)) R hR
        have htail : reachCone ms R ⊆ ballStep N R := ih (R := R) hms hlocTail
        simpa [reachCone_cons, reachStep, hcone] using Finset.union_subset hm htail

/-- One pairwise-disjoint local layer expands support by at most one graph
neighborhood step, independent of the number of gates in that layer. -/
theorem heisenLayer_geometric_cone
    (N : ι -> Finset ι) (hN : ∀ i, i ∈ N i)
    {u : Complex} (hu : u * (starRingEnd Complex) u = 1)
    (layer : Layer ι) (hdisj : LayerDisjoint layer)
    (hloc : ∀ m ∈ layer, BlockLocal N m)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A) :
    CARSupported (ballStep N R) (heisenFoldBlocks u layer A) := by
  have hcone : CARSupported (reachCone layer R) (heisenFoldBlocks u layer A) :=
    heisenFoldBlocks_reachCone hu layer hA
  exact hcone.mono (reachCone_subset_ballStep_of_layerDisjoint N hN layer hdisj hloc R)

/-- A schedule of pairwise-disjoint local layers expands support by at most one
neighborhood step per layer. -/
theorem heisenLayers_geometric_cone
    (N : ι -> Finset ι) (hN : ∀ i, i ∈ N i)
    {u : Complex} (hu : u * (starRingEnd Complex) u = 1)
    (layers : List (Layer ι))
    (hdisj : ∀ layer ∈ layers, LayerDisjoint layer)
    (hloc : ∀ layer ∈ layers, ∀ m ∈ layer, BlockLocal N m)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (hA : CARSupported R A) :
    CARSupported (ballIter N layers.length R)
      (layers.foldr (fun layer acc => heisenFoldBlocks u layer acc) A) := by
  induction layers generalizing R A with
  | nil =>
      simpa [ballIter] using hA
  | cons layer layers ih =>
      have hdisjTail : ∀ l ∈ layers, LayerDisjoint l := by
        intro l hl
        exact hdisj l (by simp [hl])
      have hlocTail : ∀ l ∈ layers, ∀ m ∈ l, BlockLocal N m := by
        intro l hl m hm
        exact hloc l (by simp [hl]) m hm
      have ihResult :
          CARSupported (ballIter N layers.length R)
            (layers.foldr (fun layer acc => heisenFoldBlocks u layer acc) A) := by
        exact ih (R := R) (A := A) hdisjTail hlocTail hA
      have hlayer :
          CARSupported (ballStep N (ballIter N layers.length R))
            (heisenFoldBlocks u layer
              (layers.foldr (fun layer acc => heisenFoldBlocks u layer acc) A)) := by
        exact heisenLayer_geometric_cone N hN hu layer (hdisj layer (by simp))
          (hloc layer (by simp)) ihResult
      simpa [List.foldr, ballIter] using hlayer

end PhysicsSM.Draft.NullEdge.PlueckerLayerCone
