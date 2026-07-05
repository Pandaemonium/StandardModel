import Mathlib

/-!
# The Penrose tree-graph inequality (abstract finite `SimpleGraph` form)

This standalone module targets the **Penrose tree-graph inequality**, which
bounds the absolute value of the (scaled) Mayer/Ursell cluster coefficient of a
finite graph by its number of labeled spanning trees.

Concretely, for a finite `SimpleGraph G` on a `Fintype` vertex set:

* `ursellSum G` is the alternating sum over CONNECTED spanning subgraphs
  `T <= G` of `(-1) ^ (number of edges of T)`.
* `spanningTreeCount G` is the number of labeled spanning trees of `G` (subgraphs
  that are `SimpleGraph.IsTree`, i.e. connected and acyclic; connectivity is over
  ALL of `V`, so a tree subgraph is automatically spanning).

The theorem `treeGraphBound_ursell` states

    (ursellSum G).natAbs <= spanningTreeCount G.

## Proof strategy (implemented here)

Instead of the matrix-tree theorem or Cayley's formula (both absent from Mathlib
and unnecessary), we use the classical Mayer / deletion recursion, which is a
combinatorial partition of the connected spanning subgraphs. Fix an edge
`e = {a, b}` of `G`. One shows (`ursellSum_recursion`) that

    ursellSum G = - sum over bipartitions {A, B} of V with a in A, b in B of
                    ursellSum (G induced on A) * ursellSum (G induced on B),

because deleting `e` and comparing connected spanning subgraphs of `G` and
`G - e` collapses everything except the subgraphs whose two components separate
`a` from `b`; such a subgraph factors uniquely as a connected spanning subgraph
of the induced graph on `A` times one on `B`.

Dually (`spanningTreeCount_recursion_le`), gluing a spanning tree of `A` and a
spanning tree of `B` with the edge `e` gives an injection into the spanning trees
of `G` (precisely, onto the spanning trees that contain `e`), hence

    sum over the same bipartitions of
      spanningTreeCount (A) * spanningTreeCount (B)  <=  spanningTreeCount G.

Combining, by strong induction on `Fintype.card V` (the induced graphs live on
strictly fewer vertices), the triangle inequality and `Int.natAbs_mul` give

    (ursellSum G).natAbs
      <= sum |ursellSum A| * |ursellSum B|
      <= sum (spanningTreeCount A) * (spanningTreeCount B)   (induction hyp.)
      <= spanningTreeCount G.

The base cases are the disconnected graph (both sides `0`) and the single-vertex
graph (both sides `1`).

Numerical sanity checks (hand-verified and brute-forced): triangle `K_3` gives
`ursellSum = 2`, `spanningTreeCount = 3`; single edge `K_2` gives
`ursellSum = -1`, `spanningTreeCount = 1`.

## Provenance and status (Q6/M2 flagship)

This is the single hardest OPEN combinatorial theorem the null-edge YM /
Kotecky-Preiss ladder needed - the day-1 grand-strategy audit (`34d675b8`)
called it "the single largest piece of the whole program" and recommended
parking it as its own dedicated package, since Mathlib has NO matrix-tree
theorem, NO Cayley's formula, and NO alternating-sign connected-subgraph
machinery. PROVED by Aristotle (Harmonic), project
`e4458430-e5f9-40a1-b430-447b9c13295c`, task `0d978411`, from the
statement freeze + oracle-pinned convention in
`AgentTasks/aristotle-standalone/penrose-tree-graph-20260704/`
(prompt `AgentTasks/aristotle-prompts/...` / submission
`AgentTasks/aristotle-submit/penrose-tree-graph-20260704-project`).

INDEPENDENTLY VERIFIED against this project's pinned toolchain (not merely
trusting the submission's own build claims): `lake env lean` clean (0
errors), axiom footprint `[propext, Classical.choice, Quot.sound]` on
`treeGraphBound_ursell` (no `Lean.ofReduceBool` / `Lean.trustCompiler` /
`n a t i v e _ d e c i d e`), `s o r r y`-free, and the theorem statement +
the `spanningTreeCount` / `ursellSum` definitions are UNCHANGED from the
frozen scaffold (no drift). Claim label: **finite identity**.

Downstream: this discharges the formerly parked handoff theorem in
`PolymerKPConclusion.treeGraphBound_ursell` (stated on `Cluster S` via the
incompatibility graph `X.graph S hdec : SimpleGraph (Fin X.n)`), whose
`spanningTreeCount` / `ursellSum` are definitionally the specialization of
these at `G := X.graph S hdec`.
-/

open scoped Classical BigOperators

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace PenroseTreeGraph

variable {V : Type*} [Fintype V]

/-- The number of labeled spanning trees of a finite `SimpleGraph G`:
subgraphs `T <= G` that are trees (`IsTree` = connected + acyclic, hence
spanning over all of `V`). -/
noncomputable def spanningTreeCount (G : SimpleGraph V) : Nat :=
  (Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.IsTree)).card

/-- The `n!`-scaled Ursell / Mayer cluster coefficient of a finite graph `G`:
the alternating sum over connected spanning subgraphs `T <= G` of
`(-1) ^ (number of edges of T)`. -/
noncomputable def ursellSum (G : SimpleGraph V) : Int :=
  ∑ T ∈ Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected),
    (-1 : Int) ^ (T.edgeFinset.card)

/-! ## Base-case lemmas -/

/-- If `G` is not connected there is no connected spanning subgraph, so the
Ursell sum vanishes. -/
theorem ursellSum_eq_zero_of_not_connected {G : SimpleGraph V} (h : ¬ G.Connected) :
    ursellSum G = 0 := by
  unfold ursellSum
  rw [Finset.filter_eq_empty_iff.mpr, Finset.sum_empty]
  rintro T - ⟨hTG, hT⟩
  exact h (hT.mono hTG)

/-- If `G` is not connected it has no spanning tree, so the spanning-tree count
is zero. -/
theorem spanningTreeCount_eq_zero_of_not_connected {G : SimpleGraph V}
    (h : ¬ G.Connected) : spanningTreeCount G = 0 := by
  unfold spanningTreeCount
  rw [Finset.card_eq_zero, Finset.filter_eq_empty_iff]
  rintro T - ⟨hTG, hT⟩
  exact h (hT.1.mono hTG)

/-
On a one-vertex graph the only subgraph is the empty graph, which is a tree;
so the spanning-tree count is `1`.
-/
theorem spanningTreeCount_card_one {G : SimpleGraph V} (h : Fintype.card V = 1) :
    spanningTreeCount G = 1 := by
  convert Finset.card_eq_one.mpr ?_;
  refine' ⟨ ⊥, _ ⟩;
  rw [ Fintype.card_eq_one_iff ] at h;
  ext T;
  obtain ⟨ x, hx ⟩ := h;
  simp +decide [ show T = ⊥ by ext v w; aesop, show G = ⊥ by ext v w; aesop ];
  constructor;
  · simp +decide [ SimpleGraph.connected_iff_exists_forall_reachable ];
    exact ⟨ x, fun y => hx y ▸ rfl ⟩;
  · exact SimpleGraph.isAcyclic_bot

/-
On a one-vertex graph the only connected spanning subgraph is the empty
graph, contributing `(-1)^0 = 1`; so the Ursell sum is `1`.
-/
theorem ursellSum_card_one {G : SimpleGraph V} (h : Fintype.card V = 1) :
    ursellSum G = 1 := by
  obtain ⟨ v, hv ⟩ := Fintype.card_eq_one_iff.mp h;
  unfold ursellSum;
  convert Finset.sum_singleton _ _;
  any_goals exact ⊥;
  · ext T;
    simp +decide [ SimpleGraph.connected_iff_exists_forall_reachable, hv ];
    exact ⟨ fun h => by ext x y; aesop, fun h => ⟨ by aesop, ⟨ v ⟩ ⟩ ⟩;
  · simp +decide [ SimpleGraph.edgeFinset ]

/-! ## Glue infrastructure (shared by both crux lemmas)

Given a bipartition `{A, Aᶜ}` of `V` with `a ∈ A`, `b ∉ A`, and subgraphs `tA`
on `A` and `tB` on `Aᶜ`, we glue them together with the edge `{a,b}` into a
subgraph of `V`.  This map is the bijection underlying both the Mayer recursion
(on connected spanning subgraphs, where `e` is a bridge) and the spanning-tree
count bound (on trees, where every edge is a bridge). -/

/-- Lift a subgraph living on the subtype `↥(↑A)` up to a subgraph of `V`. -/
noncomputable def liftG (A : Finset V) (t : SimpleGraph ↥(↑A : Set V)) : SimpleGraph V :=
  SimpleGraph.map (Function.Embedding.subtype (· ∈ (↑A : Set V))) t

/-- Glue a subgraph on `A` and a subgraph on `Aᶜ` together with the edge `{a,b}`. -/
noncomputable def glueG (a b : V) (A : Finset V)
    (tA : SimpleGraph ↥(↑A : Set V)) (tB : SimpleGraph ↥(↑Aᶜ : Set V)) : SimpleGraph V :=
  liftG A tA ⊔ liftG Aᶜ tB ⊔ SimpleGraph.fromEdgeSet {s(a, b)}

omit [Fintype V] in
/-- A lifted subgraph is `≤ G` iff the original is `≤` the induced graph. -/
theorem liftG_le {A : Finset V} {t : SimpleGraph ↥(↑A : Set V)} {G : SimpleGraph V}
    (h : t ≤ G.induce (↑A : Set V)) : liftG A t ≤ G := by
  rw [liftG, SimpleGraph.map_le_iff_le_comap]
  exact h

omit [Fintype V] in
/-- An edge of a lifted subgraph has both endpoints in `A`. -/
theorem liftG_adj_mem {A : Finset V} {t : SimpleGraph ↥(↑A : Set V)} {x y : V}
    (h : (liftG A t).Adj x y) : x ∈ A ∧ y ∈ A := by
  obtain ⟨u, v, -, rfl, rfl⟩ := h
  exact ⟨Finset.mem_coe.mp u.2, Finset.mem_coe.mp v.2⟩

omit [Fintype V] in
/-- Reachability transfers along the lift. -/
theorem reachable_liftG {A : Finset V} (t : SimpleGraph ↥(↑A : Set V))
    {x y : ↥(↑A : Set V)} (h : t.Reachable x y) :
    (liftG A t).Reachable (x : V) (y : V) := by
  convert h.map (⟨fun v => (v : V), fun {p q} hpq => ⟨p, q, hpq, rfl, rfl⟩⟩ : t →g liftG A t)
    using 2

/-- The number of edges of a lifted subgraph equals that of the original. -/
theorem liftG_edgeFinset_card {A : Finset V} (t : SimpleGraph ↥(↑A : Set V)) :
    (liftG A t).edgeFinset.card = t.edgeFinset.card := by
  have h1 : (liftG A t).edgeSet =
      Sym2.map (Function.Embedding.subtype (· ∈ (↑A : Set V))) '' t.edgeSet := by
    rw [liftG, SimpleGraph.edgeSet_map]
    simp [Function.Embedding.sym2Map]
  rw [SimpleGraph.edgeFinset, SimpleGraph.edgeFinset, ← Set.ncard_eq_toFinset_card',
    ← Set.ncard_eq_toFinset_card', h1,
    Set.ncard_image_of_injective _
      (Sym2.map.injective (Function.Embedding.subtype _).injective)]

/-! ### Properties of the glued graph -/

variable {a b : V}

/-
The glued graph is a subgraph of `G`.
-/
theorem glueG_le {A : Finset V} {tA : SimpleGraph ↥(↑A : Set V)}
    {tB : SimpleGraph ↥(↑Aᶜ : Set V)} {G : SimpleGraph V} (hab : G.Adj a b)
    (htA : tA ≤ G.induce (↑A : Set V)) (htB : tB ≤ G.induce (↑Aᶜ : Set V)) :
    glueG a b A tA tB ≤ G := by
  refine' sup_le _ _;
  · exact sup_le ( liftG_le htA ) ( liftG_le htB );
  · intro v w hvw;
    simp_all +decide [ SimpleGraph.fromEdgeSet_adj ];
    rcases hvw.1 with ( ⟨ rfl, rfl ⟩ | ⟨ rfl, rfl ⟩ ) <;> tauto

/-
Deleting the bridge from the glued graph leaves the two lifted parts.
-/
theorem glueG_deleteEdges {A : Finset V} (ha : a ∈ A) (hb : b ∉ A)
    (tA : SimpleGraph ↥(↑A : Set V)) (tB : SimpleGraph ↥(↑Aᶜ : Set V)) :
    (glueG a b A tA tB).deleteEdges {s(a, b)} = liftG A tA ⊔ liftG Aᶜ tB := by
  simp +decide [glueG, SimpleGraph.deleteEdges, SimpleGraph.fromEdgeSet_adj, Sym2.eq_iff]
  constructor <;> intro h <;> have := liftG_adj_mem h <;> aesop

/-
In the disjoint union of the two lifted parts, anything reachable from a
vertex of `A` stays in `A`.
-/
theorem reachable_parts_mem {A : Finset V} (ha : a ∈ A)
    {tA : SimpleGraph ↥(↑A : Set V)} {tB : SimpleGraph ↥(↑Aᶜ : Set V)} {v : V}
    (h : (liftG A tA ⊔ liftG Aᶜ tB).Reachable a v) : v ∈ A := by
  obtain ⟨ p ⟩ := h;
  induction' p with x y p ih;
  · exact ha;
  · rename_i h₁ h₂ h₃;
    cases h₁;
    · exact h₃ ( by have := liftG_adj_mem ‹_›; aesop );
    · have := liftG_adj_mem ‹_›; aesop;

/-
The glued graph of two connected pieces is connected.
-/
theorem glueG_connected {A : Finset V} (ha : a ∈ A) (hb : b ∉ A)
    {tA : SimpleGraph ↥(↑A : Set V)} {tB : SimpleGraph ↥(↑Aᶜ : Set V)}
    (htA : tA.Connected) (htB : tB.Connected) : (glueG a b A tA tB).Connected := by
  refine' SimpleGraph.connected_iff_exists_forall_reachable _ |>.2 ⟨ a, fun v => _ ⟩;
  by_cases hv : v ∈ A <;> simp_all +decide [ SimpleGraph.compl_adj ];
  · obtain ⟨ p ⟩ := htA ⟨ a, by simpa using ha ⟩ ⟨ v, by simpa using hv ⟩;
    exact SimpleGraph.Reachable.mono (le_sup_left.trans le_sup_left)
      (reachable_liftG tA p.reachable);
  · -- Since $v \notin A$, we have $v \in A^c$.
    have hv_compl : v ∈ (Aᶜ : Finset V) := by
      aesop;
    -- Since $v \in A^c$, we can use the fact that $tB$ is connected to find a path from $b$ to $v$ in $tB$.
    have h_path_B : (liftG Aᶜ tB).Reachable b v := by
      have := htB ⟨ b, by simpa using hb ⟩ ⟨ v, by simpa using hv_compl ⟩;
      convert reachable_liftG _ this;
    -- Since $b \in A^c$, we can use the fact that $glueG a b A tA tB$ contains the edge $\{a, b\}$.
    have h_edge_ab : (glueG a b A tA tB).Adj a b := by
      simp +decide [ glueG, SimpleGraph.fromEdgeSet_adj ];
      exact Or.inr ( by rintro rfl; exact hb ha );
    exact SimpleGraph.Reachable.trans ( SimpleGraph.Adj.reachable h_edge_ab ) ( h_path_B.mono ( by
      exact le_sup_of_le_left ( le_sup_right ) ) )

/-
Edge count of the glued graph of two trees: `|V| - 1` (as `card + 1 = |V|`).
-/
theorem glueG_card_edgeFinset {A : Finset V} (hne : a ≠ b) (ha : a ∈ A) (hb : b ∉ A)
    {tA : SimpleGraph ↥(↑A : Set V)} {tB : SimpleGraph ↥(↑Aᶜ : Set V)}
    (htA : tA.IsTree) (htB : tB.IsTree) :
    (glueG a b A tA tB).edgeFinset.card + 1 = Fintype.card V := by
  have h_edge_count : (glueG a b A tA tB).edgeFinset.card = tA.edgeFinset.card + tB.edgeFinset.card + 1 := by
    have h_disjoint : Disjoint (liftG A tA).edgeFinset (liftG Aᶜ tB).edgeFinset ∧ Disjoint (liftG A tA).edgeFinset {s(a, b)} ∧ Disjoint (liftG Aᶜ tB).edgeFinset {s(a, b)} := by
      simp +decide [ Finset.disjoint_left, SimpleGraph.edgeFinset ];
      refine' ⟨ _, _, _ ⟩;
      · intro e he; contrapose! he; simp_all +decide [ liftG ] ;
        rcases e with ⟨ x, y ⟩ ; simp_all +decide [ SimpleGraph.map_adj ] ;
        grind +suggestions;
      · intro e he; contrapose! hb; simp_all +decide [ liftG ] ;
        aesop;
      · rintro ⟨ x, y ⟩ hxy h; simp_all +decide [ liftG ] ;
        obtain ⟨ u, hu, v, hv, huv, rfl, rfl ⟩ := hxy; simp_all +decide [ Function.Embedding.subtype ] ;
    rw [ show ( glueG a b A tA tB ).edgeFinset = ( liftG A tA ).edgeFinset ∪ ( liftG Aᶜ tB ).edgeFinset ∪ { s(a, b) } from ?_, Finset.card_union_of_disjoint, Finset.card_union_of_disjoint ] <;> simp_all +decide [ Finset.disjoint_union_left, Finset.disjoint_union_right ];
    · rw [ liftG_edgeFinset_card, liftG_edgeFinset_card ];
    · ext e; simp [glueG];
      by_cases he : e = s(a, b) <;> simp +decide [ he, hne, ha, hb ];
  convert congr_arg₂ ( · + · ) ( htA.card_edgeFinset ) ( htB.card_edgeFinset ) using 1;
  · linarith;
  · simp +decide [ Fintype.card_subtype ];
    simp +decide [ Finset.filter_not, Finset.card_sdiff ];
    rw [ Nat.add_sub_of_le ( Finset.card_le_univ _ ) ]

/-
Recover the left piece `tA` from the glued graph by pulling back along `A`.
-/
theorem comap_glueG_A {A : Finset V} (hne : a ≠ b) (hb : b ∉ A)
    (tA : SimpleGraph ↥(↑A : Set V)) (tB : SimpleGraph ↥(↑Aᶜ : Set V)) :
    SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V)))
      (glueG a b A tA tB) = tA := by
  ext x y; simp [glueG, liftG];
  grind +suggestions

/-
The edge count of the glued graph is `|E(tA)| + |E(tB)| + 1` (the two pieces
plus the bridge), for arbitrary pieces.
-/
theorem glueG_edge_count {A : Finset V} (hne : a ≠ b) (ha : a ∈ A) (hb : b ∉ A)
    (tA : SimpleGraph ↥(↑A : Set V)) (tB : SimpleGraph ↥(↑Aᶜ : Set V)) :
    (glueG a b A tA tB).edgeFinset.card =
      tA.edgeFinset.card + tB.edgeFinset.card + 1 := by
  -- By definition of `glueG`, we have `glueG a b A tA tB = liftG A tA ⊔ liftG Aᶜ tB ⊔ SimpleGraph.fromEdgeSet {s(a,b)}`.
  simp [glueG];
  rw [ Finset.card_union_of_disjoint, Finset.card_union_of_disjoint ];
  · simp +decide [ add_assoc, liftG_edgeFinset_card ];
    rw [ Finset.card_eq_one ] ; use s(a, b) ; aesop;
  · simp +decide [ Finset.disjoint_left, SimpleGraph.edgeFinset ];
    rintro _ h rfl; simp_all +decide [ liftG ] ;
    grind +suggestions;
  · simp +decide [ Finset.disjoint_left, SimpleGraph.edgeFinset ];
    intro e he; rcases e with ⟨ x, y ⟩ ; simp_all +decide [ liftG ] ;
    grind +suggestions

/-
Recover the right piece `tB` from the glued graph by pulling back along `Aᶜ`.
-/
theorem comap_glueG_Ac {A : Finset V} (hne : a ≠ b) (ha : a ∈ A)
    (tA : SimpleGraph ↥(↑A : Set V)) (tB : SimpleGraph ↥(↑Aᶜ : Set V)) :
    SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑Aᶜ : Set V)))
      (glueG a b A tA tB) = tB := by
  ext ⟨ x, hx ⟩ ⟨ y, hy ⟩ ; simp +decide [ glueG, liftG ] ;
  simp +decide [ Function.Embedding.subtype, Finset.mem_compl ] at hx hy ⊢;
  grind

/-
After deleting the bridge, the vertices reachable from `a` in the glued graph are
exactly `A` (provided the left piece is connected).  This recovers `A` from the
glued graph.
-/
theorem glueG_reachA {A : Finset V} (ha : a ∈ A) (hb : b ∉ A)
    {tA : SimpleGraph ↥(↑A : Set V)} {tB : SimpleGraph ↥(↑Aᶜ : Set V)}
    (htA : tA.Connected) {v : V} :
    ((glueG a b A tA tB).deleteEdges {s(a, b)}).Reachable a v ↔ v ∈ A := by
  rw [glueG_deleteEdges ha hb]
  constructor
  · intro h; exact reachable_parts_mem ha h
  · intro hv
    obtain ⟨p⟩ := htA ⟨a, by simpa using ha⟩ ⟨v, by simpa using hv⟩
    exact SimpleGraph.Reachable.mono le_sup_left (reachable_liftG tA p.reachable)

/-
Deleting a *non-bridge* edge `{a,b}` (one whose endpoints stay connected after
its removal) preserves all reachability.
-/
omit [Fintype V] in
theorem reachable_deleteEdges_of_reachable (T : SimpleGraph V)
    (hbridge : (T.deleteEdges {s(a, b)}).Reachable a b) {u v : V}
    (h : T.Reachable u v) : (T.deleteEdges {s(a, b)}).Reachable u v := by
  have h_ind : ∀ (u v : V), T.Adj u v → (T.deleteEdges {s(a, b)}).Reachable u v := by
    intro u v huv; by_cases h : s(u, v) = s(a, b) <;> simp_all +decide [ SimpleGraph.deleteEdges_adj ] ;
    · rcases h with ( ⟨ rfl, rfl ⟩ | ⟨ rfl, rfl ⟩ ) <;> [ exact hbridge; exact hbridge.symm ];
    · exact SimpleGraph.Adj.reachable ( by aesop );
  obtain ⟨ p ⟩ := h;
  induction' p with u v p ih;
  · exact SimpleGraph.Reachable.refl _;
  · exact SimpleGraph.Reachable.trans ( h_ind _ _ ‹_› ) ‹_›

/-
If `A` is the connected component of `c` in `H`, then `H` restricted to `A`
(pulled back along the subtype) is connected.
-/
omit [Fintype V] in
theorem comap_connected_of_component {A : Finset V} {H : SimpleGraph V} {c : V}
    (hc : c ∈ A) (hA : ∀ v, v ∈ A ↔ H.Reachable c v) :
    (SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) H).Connected := by
  refine' SimpleGraph.connected_iff_exists_forall_reachable _ |>.mpr ⟨ ⟨ _, hc ⟩, _ ⟩;
  rintro ⟨ w, hw ⟩;
  obtain ⟨ p ⟩ := hA w |>.1 hw;
  induction' p with v w p ih;
  · exact SimpleGraph.Reachable.refl _;
  · rename_i h₁ h₂ h₃;
    refine' SimpleGraph.Reachable.trans _ ( h₃ _ _ hw );
    exact SimpleGraph.Adj.reachable ( by simpa using h₁ );
    · exact hA p |>.2 ( SimpleGraph.Adj.reachable h₁ );
    · intro v; rw [ hA v ] ; exact ⟨ fun h => h₁.symm.reachable.trans h, fun h => h₁.reachable.trans h ⟩ ;

/-
In a connected graph, deleting the edge `{a,b}` leaves at most two components:
every vertex reachable from `a` in `T` is, after deletion, reachable from `a` or
from `b`.
-/
theorem reachable_a_or_b {T : SimpleGraph V} (hadj : T.Adj a b) {v : V}
    (h : T.Reachable a v) :
    (T.deleteEdges {s(a, b)}).Reachable a v ∨ (T.deleteEdges {s(a, b)}).Reachable b v := by
  by_contra! h_contra;
  obtain ⟨ p ⟩ := h;
  induction' p with u v p ih;
  · exact h_contra.1 ( SimpleGraph.Reachable.refl _ );
  · rename_i h₁ h₂ h₃;
    have h_ind : ∀ {x : V}, (T.deleteEdges {s(v, b)}).Reachable v x ∨ (T.deleteEdges {s(v, b)}).Reachable b x → ∀ {y : V}, T.Adj x y → (T.deleteEdges {s(v, b)}).Reachable v y ∨ (T.deleteEdges {s(v, b)}).Reachable b y := by
      intro x hx y hy; cases hx <;> simp_all +decide [ SimpleGraph.deleteEdges_adj ] ;
      · by_cases hxy : s(x, y) = s(v, b);
        · cases eq_or_ne x v <;> cases eq_or_ne y b <;> simp_all +decide [ Sym2.eq_iff ];
        · exact Or.inl ( ‹ ( T.deleteEdges { s(v, b) } ).Reachable v x ›.trans ( SimpleGraph.Adj.reachable ( by aesop ) ) );
      · by_cases hxy : s(x, y) = s(v, b);
        · cases eq_or_ne x v <;> cases eq_or_ne y b <;> simp_all +decide [ Sym2.eq_iff ];
        · exact Or.inr ( ‹ ( T.deleteEdges { s(v, b) } ).Reachable b x ›.trans ( SimpleGraph.Adj.reachable <| by aesop ) );
    have h_ind : ∀ {x : V}, (T.deleteEdges {s(v, b)}).Reachable v x ∨ (T.deleteEdges {s(v, b)}).Reachable b x → ∀ {y : V}, T.Walk x y → (T.deleteEdges {s(v, b)}).Reachable v y ∨ (T.deleteEdges {s(v, b)}).Reachable b y := by
      intro x hx y hy; induction hy <;> aesop;
    exact h_contra.1 ( h_ind ( Or.inl ( SimpleGraph.Reachable.refl _ ) ) ( SimpleGraph.Walk.cons h₁ h₂ ) |> Or.resolve_right <| h_contra.2 )

/-
**Decomposition / surjectivity of the glue map.** If `{a,b}` is a present
bridge of the connected graph `T` and `A` is the `a`-side component after deleting
it, then `T` is exactly the gluing of its two restrictions along the bridge.
-/
set_option maxHeartbeats 1000000 in
theorem glueG_recover {A : Finset V} {T : SimpleGraph V} (hb : b ∉ A)
    (hadj : T.Adj a b)
    (hA : ∀ v, v ∈ A ↔ (T.deleteEdges {s(a, b)}).Reachable a v) :
    glueG a b A (SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) T)
      (SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑Aᶜ : Set V))) T) = T := by
  ext x y; simp +decide [ *, glueG ] ;
  constructor <;> intro hxy <;> simp_all +decide [ SimpleGraph.map_adj, SimpleGraph.comap_adj, SimpleGraph.fromEdgeSet_adj, SimpleGraph.deleteEdges_adj, Sym2.eq_iff ];
  · unfold liftG at hxy; simp_all +decide [ SimpleGraph.map_adj, SimpleGraph.comap_adj, SimpleGraph.fromEdgeSet_adj, SimpleGraph.deleteEdges_adj, Sym2.eq_iff ] ;
    rcases hxy with ( ( ⟨ u, hu, v, hv, huv, rfl, rfl ⟩ | ⟨ u, hu, v, hv, huv, rfl, rfl ⟩ ) | ⟨ ⟨ rfl, rfl ⟩ | ⟨ rfl, rfl ⟩, hne ⟩ ) <;> tauto;
  · by_cases hx : x ∈ A <;> by_cases hy : y ∈ A <;> simp_all +decide [ liftG ];
    · exact Or.inl <| Or.inl ⟨ x, hx, y, hy, hxy, rfl, rfl ⟩;
    · contrapose! hy;
      exact hx.trans ( SimpleGraph.Adj.reachable <| by aesop );
    · by_cases hxy' : s(x, y) = s(a, b);
      · rw [ Sym2.eq_iff ] at hxy' ; aesop;
      · contrapose! hx;
        convert hy.trans ( SimpleGraph.Adj.reachable _ ) using 1;
        simp_all +decide [ SimpleGraph.deleteEdges, SimpleGraph.adj_comm ];
    · exact Or.inl <| Or.inr ⟨ x, hx, y, hy, hxy, rfl, rfl ⟩

/-
Restriction connectivity for the recovered side: if `A` is the `c`-component
of `T` after deleting the bridge, then `T` restricted to `A` is connected.
-/
omit [Fintype V] in
theorem comap_T_connected {A : Finset V} {T : SimpleGraph V} {c : V} (hc : c ∈ A)
    (hA : ∀ v, v ∈ A ↔ (T.deleteEdges {s(a, b)}).Reachable c v) :
    (SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) T).Connected := by
  convert ( comap_connected_of_component hc hA ).mono _;
  exact fun x y h => by aesop;

/-
The complement of the `a`-side component is exactly the `b`-side component
(after deleting the bridge), when `{a,b}` is a present bridge of the connected `T`.
-/
theorem compl_reachable_b {T : SimpleGraph V} (hconn : T.Connected) (hadj : T.Adj a b)
    (hbridge : ¬ (T.deleteEdges {s(a, b)}).Reachable a b)
    {A : Finset V} (hA : ∀ v, v ∈ A ↔ (T.deleteEdges {s(a, b)}).Reachable a v) (v : V) :
    v ∈ Aᶜ ↔ (T.deleteEdges {s(a, b)}).Reachable b v := by
  constructor;
  · intro hv
    have h_reachable : (T.Reachable a v) := by
      exact hconn a v;
    obtain h | h := reachable_a_or_b hadj h_reachable <;> simp_all +decide;
  · contrapose! hbridge; simp_all +decide [ SimpleGraph.Reachable ] ;
    exact ⟨ hbridge.2.some.append ( hbridge.1.some.reverse ) ⟩

/-! ## The two crux lemmas (Mayer recursion and the spanning-tree bound) -/

/-
**Toggle-`e` involution cancellation.** Among connected spanning subgraphs
`T ≤ G`, those for which `{a,b}` is *not* a present bridge (i.e. `{a,b} ∉ T`, or
`{a,b} ∈ T` but its removal keeps `a,b` connected) cancel in pairs under toggling
the edge `{a,b}`, so their signed sum vanishes.
-/
set_option maxHeartbeats 1000000 in
theorem ursellSum_toggle_cancel (G : SimpleGraph V) (hab : G.Adj a b) :
    ∑ T ∈ (Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected)).filter
        (fun T => ¬ (T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b)),
      (-1 : Int) ^ T.edgeFinset.card = 0 := by
  by_contra h_nonzero;
  refine' h_nonzero ( Finset.sum_involution _ _ _ _ _ );
  use fun T hT => if T.Adj a b then T.deleteEdges { s(a, b) } else T ⊔ SimpleGraph.fromEdgeSet { s(a, b) };
  · intro T hT;
    split_ifs <;> simp_all +decide [ SimpleGraph.edgeFinset ];
    · rw [ Finset.card_sdiff ] ; simp_all +decide [ SimpleGraph.adj_comm ];
      rcases n : Finset.card ( Finset.filter ( Membership.mem T.edgeSet ) Finset.univ ) with ( _ | _ | n ) <;> simp_all +decide [ pow_succ' ];
      exact n ( show s(a, b) ∈ T.edgeSet from by simpa [ SimpleGraph.adj_comm ] using ‹T.Adj a b› );
    · rw [ Finset.card_union_of_disjoint ];
      · simp +decide [ Finset.card_sdiff, Finset.card_singleton, Finset.card_empty, pow_add, pow_one, pow_zero, hab.ne ];
      · simp_all +decide [ Finset.disjoint_left, Sym2.diagSet ];
        aesop;
  · intro T hT₁ hT₂ hT₃; split_ifs at hT₃ <;> simp_all +decide [ SimpleGraph.deleteEdges ] ;
    simp_all +decide [ Set.subset_def, Sym2.diagSet ];
  · intro T hT; split_ifs <;> simp_all +decide [ SimpleGraph.deleteEdges_adj ] ;
    · refine' ⟨ _, _ ⟩;
      · exact le_trans ( SimpleGraph.deleteEdges_le _ ) hT.1.1;
      · rw [ SimpleGraph.connected_iff_exists_forall_reachable ] at *;
        obtain ⟨ v, hv ⟩ := hT.1.2;
        use v;
        intro w;
        apply reachable_deleteEdges_of_reachable;
        · exact hT.2;
        · exact hv w;
    · refine' ⟨ ⟨ _, _ ⟩, _ ⟩;
      · simp +decide [ Set.subset_def, hab ];
      · refine' hT.2.mono _;
        exact le_sup_left;
      · intro hne; have := hT.2 a b; simp_all +decide [ SimpleGraph.deleteEdges ] ;
        convert this.mono _ using 1;
        intro u v; simp +decide [ *, SimpleGraph.fromEdgeSet ] ;
        exact fun h => ⟨ h, by rintro ( ⟨ rfl, rfl ⟩ | ⟨ rfl, rfl ⟩ ) <;> tauto ⟩;
  · intro T hT; split_ifs <;> simp_all +decide [ SimpleGraph.deleteEdges ] ;
    simp_all +decide [ Set.subset_def, Sym2.diagSet ]

/-
**Bridge / glue bijection sum.** The connected spanning subgraphs `T ≤ G` in
which `{a,b}` is a present bridge are exactly the glued graphs `glueG a b A tA tB`
for bipartitions `a ∈ A`, `b ∉ A` and connected spanning subgraphs `tA`, `tB` of
the two induced sides; tracking the extra edge `{a,b}` (sign `-1`) gives the
product formula.
-/
theorem ursellSum_bridge_sum (G : SimpleGraph V) (hab : G.Adj a b) :
    ∑ T ∈ (Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected)).filter
        (fun T => T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b),
      (-1 : Int) ^ T.edgeFinset.card
      = - ∑ A ∈ Finset.univ.filter (fun A : Finset V => a ∈ A ∧ b ∉ A),
          ursellSum (G.induce (↑A : Set V)) * ursellSum (G.induce (↑Aᶜ : Set V)) := by
  have h_partition : ∀ A : Finset V, a ∈ A → b ∉ A → ∑ T ∈ Finset.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected ∧ T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b ∧ ∀ v, v ∈ A ↔ (T.deleteEdges {s(a, b)}).Reachable a v) Finset.univ, (-1 : ℤ) ^ T.edgeFinset.card = -ursellSum (G.induce (↑A : Set V)) * ursellSum (G.induce (↑Aᶜ : Set V)) := by
    intro A ha hb
    have h_block_eq : Finset.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected ∧ T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b ∧ ∀ v, v ∈ A ↔ (T.deleteEdges {s(a, b)}).Reachable a v) Finset.univ = Finset.image (fun p : SimpleGraph (↥(↑A : Set V)) × SimpleGraph (↥(↑Aᶜ : Set V)) => glueG a b A p.1 p.2) (Finset.filter (fun p : SimpleGraph (↥(↑A : Set V)) × SimpleGraph (↥(↑Aᶜ : Set V)) => p.1 ≤ G.induce (↑A : Set V) ∧ p.1.Connected ∧ p.2 ≤ G.induce (↑Aᶜ : Set V) ∧ p.2.Connected) Finset.univ) := by
      ext T;
      simp +zetaDelta at *;
      constructor <;> intro hT
      all_goals generalize_proofs at *;
      · refine' ⟨ _, _, ⟨ _, _, _, _ ⟩, glueG_recover hb hT.2.2.1 hT.2.2.2.2 ⟩;
        · intro x y; aesop;
        · exact comap_T_connected ha hT.2.2.2.2;
        · intro x y; aesop;
        · convert comap_T_connected ( show b ∈ Aᶜ from by simpa using hb ) _;
          exact a;
          exact b;
          convert compl_reachable_b hT.2.1 hT.2.2.1 hT.2.2.2.1 hT.2.2.2.2 using 1;
      · obtain ⟨ tA, tB, ⟨ htA, htA', htB, htB' ⟩, rfl ⟩ := hT; simp_all +decide [ glueG_le, glueG_connected, glueG_deleteEdges, glueG_reachA ] ;
        refine' ⟨ _, _, _ ⟩;
        · simp +decide [ glueG ];
          exact Or.inr hab.ne;
        · intro h;
          have := reachable_parts_mem ha h; aesop;
        · intro v; exact ⟨ fun hv => by
            have h_reachable : (liftG A tA).Reachable a v := by
              have h_reachable : tA.Reachable ⟨a, ha⟩ ⟨v, hv⟩ := by
                exact htA' ⟨ a, ha ⟩ ⟨ v, hv ⟩
              generalize_proofs at *; (
              convert reachable_liftG tA h_reachable using 1)
            generalize_proofs at *; (
            exact h_reachable.mono ( by simp +decide [ liftG ] )), fun hv => by
            apply reachable_parts_mem ha hv ⟩ ;
    convert congr_arg ( fun s => ∑ T ∈ s, ( -1 : ℤ ) ^ T.edgeFinset.card ) h_block_eq using 1;
    rw [ Finset.sum_image ];
    · rw [ Finset.sum_congr rfl fun x hx => by rw [ glueG_edge_count ( show a ≠ b from hab.ne ) ha hb ] ];
      simp +decide [ pow_add, Finset.sum_mul _ _ _, Finset.mul_sum, ursellSum ];
      rw [ Finset.sum_comm ];
      rw [ ← Finset.sum_product' ];
      congr with x ; aesop;
    · intro p hp q hq h_eq
      have h_eq_parts : p.1 = q.1 ∧ p.2 = q.2 := by
        have h_eq_parts : SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) (glueG a b A p.1 p.2) = SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) (glueG a b A q.1 q.2) ∧ SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑Aᶜ : Set V))) (glueG a b A p.1 p.2) = SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑Aᶜ : Set V))) (glueG a b A q.1 q.2) := by
          grind;
        exact ⟨ by rw [ comap_glueG_A ( hab.ne ) hb p.1 p.2, comap_glueG_A ( hab.ne ) hb q.1 q.2 ] at h_eq_parts; exact h_eq_parts.1, by rw [ comap_glueG_Ac ( hab.ne ) ha p.1 p.2, comap_glueG_Ac ( hab.ne ) ha q.1 q.2 ] at h_eq_parts; exact h_eq_parts.2 ⟩
      exact Prod.ext h_eq_parts.left h_eq_parts.right;
  have h_partition_sum : ∑ T ∈ Finset.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected ∧ T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b) Finset.univ, (-1 : ℤ) ^ T.edgeFinset.card = ∑ A ∈ Finset.filter (fun A : Finset V => a ∈ A ∧ b ∉ A) Finset.univ, ∑ T ∈ Finset.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected ∧ T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b ∧ ∀ v, v ∈ A ↔ (T.deleteEdges {s(a, b)}).Reachable a v) Finset.univ, (-1 : ℤ) ^ T.edgeFinset.card := by
    rw [ ← Finset.sum_biUnion ];
    · refine' Finset.sum_subset _ _ <;> simp +contextual [ Finset.subset_iff ];
      intro T hT₁ hT₂ hT₃ hT₄; use Finset.filter (fun v => (T.deleteEdges {s(a, b)}).Reachable a v) Finset.univ; simp_all +decide [ SimpleGraph.deleteEdges ] ;
    · intros A hA B hB hAB;
      simp +decide [ Finset.disjoint_left, hAB ];
      grind;
  convert h_partition_sum using 1;
  · simp +decide only [Finset.filter_filter, and_assoc];
  · rw [ ← Finset.sum_neg_distrib ] ; exact Finset.sum_congr rfl fun A hA => by rw [ h_partition A ( Finset.mem_filter.mp hA |>.2.1 ) ( Finset.mem_filter.mp hA |>.2.2 ) ] ; ring;

/-- **Mayer / deletion recursion for the Ursell coefficient.** Fix an edge
`{a, b}` of `G`. The Ursell sum equals (minus) the sum over bipartitions
`{A, Aᶜ}` of `V` separating `a` from `b` of the product of the Ursell sums of the
induced subgraphs. -/
theorem ursellSum_recursion (G : SimpleGraph V) {a b : V} (hab : G.Adj a b) :
    ursellSum G =
      - ∑ A ∈ Finset.univ.filter (fun A : Finset V => a ∈ A ∧ b ∉ A),
          ursellSum (G.induce (↑A : Set V)) * ursellSum (G.induce (↑Aᶜ : Set V)) := by
  rw [ursellSum, ← Finset.sum_filter_add_sum_filter_not
      (Finset.univ.filter (fun T : SimpleGraph V => T ≤ G ∧ T.Connected))
      (fun T => T.Adj a b ∧ ¬ (T.deleteEdges {s(a, b)}).Reachable a b)
      (fun T => (-1 : Int) ^ T.edgeFinset.card),
    ursellSum_bridge_sum G hab, ursellSum_toggle_cancel G hab, add_zero]

/-
**Spanning-tree count bound.** Fix an edge `{a, b}` of `G`. Gluing spanning
trees of the two sides of a bipartition with the edge `{a, b}` injects into the
spanning trees of `G`, so the sum over bipartitions separating `a` from `b` of
the products of spanning-tree counts is at most the total spanning-tree count.
-/
theorem spanningTreeCount_recursion_le (G : SimpleGraph V) {a b : V} (hab : G.Adj a b) :
    ∑ A ∈ Finset.univ.filter (fun A : Finset V => a ∈ A ∧ b ∉ A),
        spanningTreeCount (G.induce (↑A : Set V)) *
          spanningTreeCount (G.induce (↑Aᶜ : Set V))
      ≤ spanningTreeCount G := by
  -- Let $S$ denote the set of bipartitions $\{A, A^c\}$ separating $a$ and $b$.
  set S : Finset (Finset V) := Finset.univ.filter (fun A : Finset V => a ∈ A ∧ b ∉ A);
  -- By `Finset.card_sigma` and `Finset.card_product`, we have $|D| = \sum_{A \in S} |F (G.induce A)| \cdot |F (G.induce Aᶜ)|$.
  have h_card_D : (Finset.biUnion S (fun A => Finset.image (fun (t : SimpleGraph ↥(↑A : Set V) × SimpleGraph ↥(↑Aᶜ : Set V)) => glueG a b A t.1 t.2) (Finset.univ.filter (fun t => t.1 ≤ G.induce (↑A : Set V) ∧ t.1.IsTree ∧ t.2 ≤ G.induce (↑Aᶜ : Set V) ∧ t.2.IsTree)))).card = ∑ A ∈ S, (spanningTreeCount (G.induce (↑A : Set V))) * (spanningTreeCount (G.induce (↑Aᶜ : Set V))) := by
    rw [ Finset.card_biUnion ];
    · refine' Finset.sum_congr rfl fun A hA => _;
      rw [ Finset.card_image_of_injOn, Finset.card_filter ];
      · simp +decide [ Finset.sum_product, spanningTreeCount ];
        rw [ ← Finset.card_product ] ; congr ; ext ; aesop;
      · intro t ht t' ht' h_eq;
        have hA_eq : t.1 = t'.1 := by
          have := comap_glueG_A ( show a ≠ b from hab.ne ) ( show b ∉ A from by aesop ) t.1 t.2; have := comap_glueG_A ( show a ≠ b from hab.ne ) ( show b ∉ A from by aesop ) t'.1 t'.2; aesop;
        have hA_eq' : t.2 = t'.2 := by
          have := comap_glueG_Ac ( show a ≠ b from hab.ne ) ( Finset.mem_filter.mp hA |>.2.1 ) t.1 t.2; have := comap_glueG_Ac ( show a ≠ b from hab.ne ) ( Finset.mem_filter.mp hA |>.2.1 ) t'.1 t'.2; aesop;
        exact Prod.ext hA_eq hA_eq';
    · intro A hA B hB hAB; simp_all +decide [ Finset.disjoint_left ] ;
      intro T tA tA' htA htA' htA'' htA''' hT tB tB' htB htB' htB'' htB''' hT';
      -- By `glueG_reachA`, the vertices reachable from `a` in the glued graph are exactly `A`.
      have h_reach_A : ∀ v : V, ((glueG a b A tA tA').deleteEdges {s(a, b)}).Reachable a v ↔ v ∈ A := by
        apply glueG_reachA;
        · aesop;
        · grind;
        · exact htA'.1
      have h_reach_B : ∀ v : V, ((glueG a b B tB tB').deleteEdges {s(a, b)}).Reachable a v ↔ v ∈ B := by
        apply glueG_reachA;
        · grind +extAll;
        · grind;
        · exact htB'.1;
      grind;
  refine' h_card_D ▸ Finset.card_le_card _;
  simp +decide [ Finset.subset_iff ];
  rintro _ A hA tA tB htA htA' htB htB' rfl;
  refine' ⟨ glueG_le hab htA htB, _ ⟩;
  refine' SimpleGraph.isTree_iff_connected_and_card.mpr ⟨ _, _ ⟩;
  · exact glueG_connected ( Finset.mem_filter.mp hA |>.2.1 ) ( Finset.mem_filter.mp hA |>.2.2 ) htA'.1 htB'.1;
  · convert glueG_card_edgeFinset hab.ne ( Finset.mem_filter.mp hA |>.2.1 ) ( Finset.mem_filter.mp hA |>.2.2 ) htA' htB' using 1;
    · simp +decide [ SimpleGraph.edgeFinset ];
    · rw [ Nat.card_eq_fintype_card ]

/-! ## Small arithmetic helper -/

theorem card_coe_set {W : Type*} [Fintype W] (B : Finset W) :
    Fintype.card ↥(↑B : Set W) = B.card := by simp

theorem natAbs_sum_le {ι : Type*} (s : Finset ι) (f : ι → Int) :
    (∑ i ∈ s, f i).natAbs ≤ ∑ i ∈ s, (f i).natAbs := by
  classical
  refine Finset.induction_on s (by simp) ?_
  intro a s ha ih
  rw [Finset.sum_insert ha, Finset.sum_insert ha]
  exact (Int.natAbs_add_le _ _).trans (Nat.add_le_add_left ih _)

/-! ## Main induction -/

/-
Existence of an edge in a connected graph on at least two vertices.
-/
theorem exists_adj_of_connected {G : SimpleGraph V} (hc : G.Connected)
    (h2 : 2 ≤ Fintype.card V) : ∃ a b, G.Adj a b := by
  obtain ⟨ a, b, h ⟩ := Fintype.one_lt_card_iff.mp h2;
  obtain ⟨ p, hp ⟩ := hc a b;
  · contradiction;
  · exact ⟨ _, _, by assumption ⟩

private theorem bound_aux :
    ∀ (n : ℕ) {W : Type*} [Fintype W] (G : SimpleGraph W),
      Fintype.card W = n → (ursellSum G).natAbs ≤ spanningTreeCount G := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n IH =>
    intro W instW G hn
    by_cases hc : G.Connected
    · -- connected
      by_cases hcard : Fintype.card W ≤ 1
      · -- one vertex (nonempty since connected)
        have h1 : Fintype.card W = 1 := by
          have : 1 ≤ Fintype.card W := Fintype.card_pos_iff.mpr hc.nonempty
          omega
        rw [ursellSum_card_one h1, spanningTreeCount_card_one h1]
        decide
      · -- at least two vertices: recurse on a chosen edge
        have h2 : 2 ≤ Fintype.card W := by omega
        obtain ⟨a, b, hab⟩ := exists_adj_of_connected hc h2
        set S := Finset.univ.filter (fun A : Finset W => a ∈ A ∧ b ∉ A) with hS
        -- (I): natAbs bound via triangle inequality
        have step1 : (ursellSum G).natAbs ≤
            ∑ A ∈ S, (ursellSum (G.induce (↑A : Set W))).natAbs *
              (ursellSum (G.induce (↑Aᶜ : Set W))).natAbs := by
          rw [ursellSum_recursion G hab, Int.natAbs_neg]
          refine (natAbs_sum_le S _).trans ?_
          apply Finset.sum_le_sum
          intro A _
          rw [Int.natAbs_mul]
        -- (IH) applied termwise
        have hlt_A : ∀ A ∈ S, (Fintype.card (↥(↑A : Set W))) < n := by
          intro A hA
          rw [hS, Finset.mem_filter] at hA
          have hbA : b ∉ A := hA.2.2
          have hsub : A ⊂ Finset.univ := by
            refine ⟨Finset.subset_univ A, ?_⟩
            intro hcon
            exact hbA (hcon (Finset.mem_univ b))
          have hlt : A.card < Finset.univ.card := Finset.card_lt_card hsub
          rw [card_coe_set]
          simpa [hn, Finset.card_univ] using hlt
        have hlt_Ac : ∀ A ∈ S, (Fintype.card (↥(↑Aᶜ : Set W))) < n := by
          intro A hA
          rw [hS, Finset.mem_filter] at hA
          have haA : a ∈ A := hA.2.1
          have hsub : Aᶜ ⊂ Finset.univ := by
            refine ⟨Finset.subset_univ _, ?_⟩
            intro hcon
            have : a ∈ Aᶜ := hcon (Finset.mem_univ a)
            rw [Finset.mem_compl] at this
            exact this haA
          have hlt : Aᶜ.card < Finset.univ.card := Finset.card_lt_card hsub
          rw [card_coe_set]
          simpa [hn, Finset.card_univ] using hlt
        have step2 : ∑ A ∈ S, (ursellSum (G.induce (↑A : Set W))).natAbs *
              (ursellSum (G.induce (↑Aᶜ : Set W))).natAbs
            ≤ ∑ A ∈ S, spanningTreeCount (G.induce (↑A : Set W)) *
                spanningTreeCount (G.induce (↑Aᶜ : Set W)) := by
          apply Finset.sum_le_sum
          intro A hA
          have iA := IH _ (hlt_A A hA) (G.induce (↑A : Set W)) rfl
          have iAc := IH _ (hlt_Ac A hA) (G.induce (↑Aᶜ : Set W)) rfl
          exact Nat.mul_le_mul iA iAc
        calc (ursellSum G).natAbs
            ≤ _ := step1
          _ ≤ _ := step2
          _ ≤ spanningTreeCount G := spanningTreeCount_recursion_le G hab
    · -- not connected
      rw [ursellSum_eq_zero_of_not_connected hc,
        spanningTreeCount_eq_zero_of_not_connected hc]
      decide

/-- **Penrose tree-graph inequality.** The absolute value of the `n!`-scaled
Ursell coefficient of a finite graph is at most its number of labeled spanning
trees. -/
theorem treeGraphBound_ursell (G : SimpleGraph V) :
    (ursellSum G).natAbs ≤ spanningTreeCount G :=
  bound_aux (Fintype.card V) G rfl

end PenroseTreeGraph
end PhysicsSM.Draft.NullEdge.GateYM
