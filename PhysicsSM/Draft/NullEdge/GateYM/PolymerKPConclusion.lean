import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPCriterion
import PhysicsSM.Draft.NullEdge.GateYM.TreeGraphInequality

/-!
# Gate YM4: abstract KP conclusion statement freeze

This module is the Q6/T6 statement-freeze layer above
`PolymerKPCriterion`.  It records the finite cluster objects, the abstract
tree-graph coefficient interface, and the three KP conclusion targets selected
by the four-day run's `review:q6-kp-freeze` thread.

Scope discipline:

* `kp_cluster_summable` uses only the bare Kotecky-Preiss condition from
  `PolymerKPCriterion`, after reducing to the rooted partial-sum crux
  `kp_partial_sum_bound`.
* Aristotle project `071d1370` found a real blocker: the old bare C2 bound is
  false without self-incompatibility.  The module now contains the formal
  counterexample `kp_convergence_bound_false` and the corrected target
  `kp_convergence_bound_of_selfIncompatible`.
* `kp_tail_bound` adds metric data, self-incompatibility, and an explicit
  energy/distance coercivity hypothesis.  Distance is not folded into the base
  KP condition.
* `spanningTreeCount` and `ursellSum` use the direct finite-graph definitions
  recommended by Aristotle project `34d675b8`.
* The Penrose tree-graph inequality for the concrete Ursell coefficient is
  discharged by specializing the abstract finite-graph theorem from
  `TreeGraphInequality`.

Draft-trust: statement freeze plus one kernel-checked negative result and a
kernel-checked Penrose tree-graph bound.  The rooted KP partial-sum theorem
`kp_tree_sum_bound` (hence `kp_partial_sum_bound` and `kp_cluster_summable`)
is now reduced, with a kernel-checked lemma DAG, to the finite combinatorial
inequality `pairSum_le_expBound` through the sound touch-only reformulation
`touchOnlySum_le_expBound`.  The current checked DAG includes
`exists_canonical_root`, which chooses the least `g`-slot of a touching
cluster, `tree_root_child_mem_nbhd`, which sends a spanning-tree edge out of
that root slot into the KP neighborhood of `g`, `treeRootChildren`, which names
the finite set of root-adjacent children for later deletion, the
`treeRootChildren_card_add_one_le` arity bound, `treeRootDeletedGraph`, which
names the induced graph after deleting the root slot, `treeRootChildComponent`,
which names the deleted-graph connected component rooted at a child slot, and
`treeRootChildBlock`, which turns that component support into a finite block,
with `treeRootChildBlock_card_add_one_le` bounding its size and
`disjoint_treeRootChildBlock_of_component_ne` separating the easy
component-support disjointness argument from the remaining tree-specific
component-inequality proof, `root_child_forest_wf`, which packages the
child-forest well-formedness/`MapsTo` data needed by the next classification
map, and `rhs_forest_expand`, which expands the RHS partial exponential into
ordered child tuples.  It also includes
`factorial_mul_prod_factorial_le`, the arithmetic normalization for the future
multinomial fiber bound.  The remaining gap is the rooted-tree deletion, block
reindexing, weight-factorization, and the geometric fiber-count bound.  In
detail: the enlargement step
`sum_le_boundedTouchSum`, the base case `boundedTouchSum_zero_le`, the depth
induction `boundedTouchSum_le_kpPsi`, the analytic partial-sum-to-exponential
step `boundedTouchSum_succ_le`, and the analytic bound `kpPsi_le_exp` are all
proved.  The two further handoffs `kp_convergence_bound_of_selfIncompatible`
and `kp_tail_bound` are untouched.
Claim label: statement freeze / lemma DAG / formal counterexample / finite
identity.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PolymerKPConclusion

open scoped BigOperators
open PolymerKPCriterion

variable {Gamma : Type*} [Fintype Gamma]

/-- An ordered finite cluster over a polymer system.

The cluster is encoded by a natural number of slots and a map from those slots
to polymers.  This deliberately keeps repetitions and slot order visible; the
eventual Mayer/Ursell normalization must account for that ordered encoding. -/
structure Cluster (S : PolymerSystem Gamma) where
  n : Nat
  poly : Fin n -> Gamma

namespace Cluster

/-- The incompatibility graph on cluster slots.

Edges join distinct slots whose polymers are incompatible.  The explicit
`i != j` guard is necessary because `SimpleGraph` has no loops, while abstract
polymer incompatibility is normally self-incompatible. -/
def graph (S : PolymerSystem Gamma)
    (_hdec : forall g h, Decidable (S.incompatible g h)) (X : Cluster S) :
    SimpleGraph (Fin X.n) where
  Adj i j := i ≠ j /\ S.incompatible (X.poly i) (X.poly j)
  symm := by
    intro i j h
    exact ⟨Ne.symm h.1, S.incompatible_symm _ _ h.2⟩
  loopless := ⟨by
    intro i h
    exact h.1 rfl⟩

/-- The cluster is connected when its incompatibility graph is connected. -/
def Connected (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (X : Cluster S) :
    Prop :=
  (X.graph S hdec).Connected

/-- A cluster touches a polymer if one of its ordered slots is that polymer. -/
def Touches (S : PolymerSystem Gamma) (X : Cluster S) (g0 : Gamma) : Prop :=
  exists i : Fin X.n, X.poly i = g0

/-- Absolute product of the polymer weights over the ordered slots. -/
def absWeight (S : PolymerSystem Gamma) (X : Cluster S) : Real :=
  (Finset.univ : Finset (Fin X.n)).prod
    (fun i => |S.weight (X.poly i)|)

/-- Sum of the KP energy function over the ordered slots. -/
def energyOf (S : PolymerSystem Gamma) (X : Cluster S) : Real :=
  (Finset.univ : Finset (Fin X.n)).sum
    (fun i => S.energy (X.poly i))

/-- Cluster absolute weights are nonnegative. -/
theorem absWeight_nonneg (S : PolymerSystem Gamma) (X : Cluster S) :
    0 <= X.absWeight S := by
  exact Finset.prod_nonneg (fun i _hi => abs_nonneg (S.weight (X.poly i)))

/-- Cluster KP energies are nonnegative. -/
theorem energyOf_nonneg (S : PolymerSystem Gamma) (X : Cluster S) :
    0 <= X.energyOf S := by
  exact Finset.sum_nonneg (fun i _hi => S.energy_nonneg (X.poly i))

/-- The exponential energy factor is strictly positive. -/
theorem exp_energyOf_pos (S : PolymerSystem Gamma) (X : Cluster S) :
    0 < Real.exp (X.energyOf S) :=
  Real.exp_pos _

/-- The absolute-weight times exponential-energy factor is nonnegative. -/
theorem absWeight_mul_exp_energyOf_nonneg
    (S : PolymerSystem Gamma) (X : Cluster S) :
    0 <= X.absWeight S * Real.exp (X.energyOf S) := by
  exact mul_nonneg (X.absWeight_nonneg S) (le_of_lt (X.exp_energyOf_pos S))

end Cluster

/-- Number of labeled spanning trees of the cluster incompatibility graph.

This is the direct finite definition recommended by Aristotle project
`34d675b8`: filter the finite type of simple graphs on `Fin X.n` to those
subgraphs of the incompatibility graph that are trees.  No matrix-tree theorem
or Cayley formula is needed for the KP bound. -/
noncomputable def spanningTreeCount (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) : Nat := by
  classical
  exact PenroseTreeGraph.spanningTreeCount (X.graph S hdec)

/-- The unnormalized Mayer/Ursell alternating sum over connected spanning
subgraphs of the cluster incompatibility graph.

The genuine ordered-cluster Ursell coefficient is this integer divided by
`Nat.factorial X.n`.  The hard-core polymer setting makes every nonzero Mayer
edge factor equal to `-1`, so the concrete sum is unweighted apart from the
sign `(-1) ^ edge-count`. -/
noncomputable def ursellSum (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) : Int := by
  classical
  exact PenroseTreeGraph.ursellSum (X.graph S hdec)

/-- A tree subgraph of the cluster graph witnesses connectedness of the
cluster itself. -/
theorem connected_of_isTree_le (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) {T : SimpleGraph (Fin X.n)}
    (hTle : T <= X.graph S hdec) (hT : T.IsTree) :
    X.Connected S hdec := by
  exact hT.isConnected.mono hTle

/-- A connected subgraph of the cluster graph witnesses connectedness of the
cluster itself. -/
theorem connected_of_connected_le (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) {T : SimpleGraph (Fin X.n)}
    (hTle : T <= X.graph S hdec) (hT : T.Connected) :
    X.Connected S hdec := by
  exact hT.mono hTle

/-- Disconnected clusters have no spanning-tree subgraphs. -/
theorem spanningTreeCount_eq_zero_of_not_connected (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (hX : Not (X.Connected S hdec)) :
    spanningTreeCount S hdec X = 0 := by
  exact PenroseTreeGraph.spanningTreeCount_eq_zero_of_not_connected
    (G := X.graph S hdec) hX

/-- Connected clusters have at least one spanning-tree subgraph. -/
theorem spanningTreeCount_pos_of_connected (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (hX : X.Connected S hdec) :
    0 < spanningTreeCount S hdec X := by
  classical
  obtain ⟨T, hTle, hTtree⟩ := hX.exists_isTree_le
  unfold spanningTreeCount PenroseTreeGraph.spanningTreeCount
  exact Finset.card_pos.mpr
    ⟨T, by
      simp [hTle, hTtree]⟩

/-- Disconnected clusters have zero concrete Ursell sum. -/
theorem ursellSum_eq_zero_of_not_connected (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (hX : Not (X.Connected S hdec)) :
    ursellSum S hdec X = 0 := by
  exact PenroseTreeGraph.ursellSum_eq_zero_of_not_connected
    (G := X.graph S hdec) hX

/-- The Penrose tree-graph inequality for the concrete Ursell sum.

This specializes the abstract finite-graph theorem from Aristotle project
`e4458430` to the incompatibility graph of a concrete ordered cluster. -/
theorem treeGraphBound_ursell (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) :
    (ursellSum S hdec X).natAbs <= spanningTreeCount S hdec X := by
  exact PenroseTreeGraph.treeGraphBound_ursell (X.graph S hdec)

/-- Abstract coefficient data for the KP cluster expansion.

The concrete Mayer/Ursell coefficient is deferred.  The downstream KP
conclusion theorems may use only the two fields below: vanishing away from
connected clusters and the Penrose/Fernandez-Procacci tree-graph bound in the
ordered-cluster normalization. -/
structure ClusterCoeffData (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) where
  coeff : Cluster S -> Real
  coeff_disconnected :
    forall X : Cluster S, Not (X.Connected S hdec) -> coeff X = 0
  treeGraphBound :
    forall X : Cluster S,
      |coeff X| * (Nat.factorial X.n : Real)
        <= (spanningTreeCount S hdec X : Real)

/-- Coefficient-weight terms in the bare cluster sum are nonnegative. -/
theorem clusterCoeff_absWeight_nonneg (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec) (X : Cluster S) :
    0 <= |D.coeff X| * X.absWeight S := by
  exact mul_nonneg (abs_nonneg (D.coeff X)) (X.absWeight_nonneg S)

/-- Coefficient-weight-energy terms in the KP convergence sum are nonnegative. -/
theorem clusterCoeff_absWeight_exp_nonneg (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec) (X : Cluster S) :
    0 <= |D.coeff X| * X.absWeight S * Real.exp (X.energyOf S) := by
  exact mul_nonneg (clusterCoeff_absWeight_nonneg S hdec D X)
    (le_of_lt (X.exp_energyOf_pos S))

/-- Term-wise consequence of the tree-graph inequality: each
coefficient-weight term is dominated by the spanning-tree count divided by
`n!`, times the absolute weight.  This is the pointwise input to
`kp_partial_sum_bound`. -/
theorem coeff_absWeight_le_treeTerm (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec) (X : Cluster S) :
    |D.coeff X| * X.absWeight S
      <= (spanningTreeCount S hdec X : Real) / (Nat.factorial X.n : Real)
          * X.absWeight S := by
  have hfac : (0 : Real) < (Nat.factorial X.n : Real) := by
    exact_mod_cast Nat.factorial_pos X.n
  have hb := D.treeGraphBound X
  have hle : |D.coeff X|
      <= (spanningTreeCount S hdec X : Real) / (Nat.factorial X.n : Real) := by
    rw [le_div_iff₀ hfac]
    exact hb
  exact mul_le_mul_of_nonneg_right hle (X.absWeight_nonneg S)

/-- Incompatibility neighborhood of `g`: the finite set of polymers
incompatible with `g`.  This is exactly the index set of the KP sum. -/
def nbhd (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (g : Gamma) :
    Finset Gamma :=
  Finset.univ.filter (fun h => @Decidable.decide _ (hdec g h) = true)

/-- Truncated KP exponential-recursion bound.

`kpPsi K g` is the depth-`K` truncation of the self-consistent solution to
`psi g = |w g| * exp (sum_{h ~ g} psi h)`.  It is the analytic quantity that
the missing rooted tree-sum formula should compare with. -/
noncomputable def kpPsi (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) :
    Nat -> Gamma -> Real
  | 0, g => |S.weight g|
  | (K + 1), g =>
      |S.weight g| * Real.exp (∑ h ∈ nbhd S hdec g, kpPsi S hdec K h)

/-- `kpPsi` is nonnegative. -/
theorem kpPsi_nonneg (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat)
    (g : Gamma) :
    0 <= kpPsi S hdec K g := by
  cases K with
  | zero => exact abs_nonneg _
  | succ _ => exact mul_nonneg (abs_nonneg _) (le_of_lt (Real.exp_pos _))

/-- The analytic half of the KP estimate: every depth-`K` truncation of the
exponential recursion is bounded by `|w g| * exp (energy g)`, using only the
KP condition and nonnegativity of energy. -/
theorem kpPsi_le_exp (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hKP : KPCondition S hdec) (K : Nat) (g : Gamma) :
    kpPsi S hdec K g <= |S.weight g| * Real.exp (S.energy g) := by
  induction K generalizing g with
  | zero =>
      have h1 : (1 : Real) <= Real.exp (S.energy g) :=
        Real.one_le_exp (S.energy_nonneg g)
      calc
        kpPsi S hdec 0 g = |S.weight g| := rfl
        _ = |S.weight g| * 1 := by rw [mul_one]
        _ <= |S.weight g| * Real.exp (S.energy g) :=
          mul_le_mul_of_nonneg_left h1 (abs_nonneg _)
  | succ K ih =>
      have hsum : (∑ h ∈ nbhd S hdec g, kpPsi S hdec K h)
          <= ∑ h ∈ nbhd S hdec g,
              |S.weight h| * Real.exp (S.energy h) :=
        Finset.sum_le_sum (fun h _ => ih h)
      have hKPg : (∑ h ∈ nbhd S hdec g,
            |S.weight h| * Real.exp (S.energy h))
          <= S.energy g :=
        hKP g
      have hstep : (∑ h ∈ nbhd S hdec g, kpPsi S hdec K h)
          <= S.energy g :=
        le_trans hsum hKPg
      calc
        kpPsi S hdec (K + 1) g
            = |S.weight g| *
                Real.exp (∑ h ∈ nbhd S hdec g, kpPsi S hdec K h) := rfl
        _ <= |S.weight g| * Real.exp (S.energy g) :=
          mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hstep) (abs_nonneg _)

/-- The rooted tree-sum summand attached to a single ordered cluster: the
number of spanning trees of its incompatibility graph, normalized by `n!`,
times the absolute product weight.  This is exactly the summand of
`kp_tree_sum_bound`. -/
noncomputable def treeTerm (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (X : Cluster S) :
    Real :=
  (spanningTreeCount S hdec X : Real) / (Nat.factorial X.n : Real) *
    X.absWeight S

/-- Tree-sum summands are nonnegative. -/
theorem treeTerm_nonneg (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (X : Cluster S) :
    0 <= treeTerm S hdec X := by
  unfold treeTerm
  apply mul_nonneg
  · apply div_nonneg
    · exact_mod_cast Nat.zero_le _
    · exact_mod_cast Nat.zero_le _
  · exact X.absWeight_nonneg S

set_option maxHeartbeats 1000000 in
open Classical in
/-- `treeTerm` rewritten as an explicit sum over the spanning trees of the
cluster incompatibility graph.  This is the first step of the labeled
rooted-tree exponential-formula argument: it exposes the spanning tree `T` so
that the canonical-root deletion can be applied to `(X, T)` pairs.

Each spanning tree contributes the same weight `absWeight X / n!`; there are
`spanningTreeCount X` of them, so the sum equals `treeTerm X`. -/
lemma treeTerm_eq_tree_sum (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (X : Cluster S) :
    treeTerm S hdec X
      = ∑ _T ∈ (Finset.univ.filter
          (fun T : SimpleGraph (Fin X.n) => T ≤ X.graph S hdec ∧ T.IsTree)),
          X.absWeight S / (Nat.factorial X.n : Real) := by
  classical
  convert congr_arg _ ?_;
  rotate_left;
  exact X;
  · rfl;
  · simp +decide [ mul_comm ];
    rw [ show ( Finset.filter ( fun T => T ≤ Cluster.graph S hdec X ∧ T.IsTree ) Finset.univ ).card = spanningTreeCount S hdec X from ?_ ];
    · unfold treeTerm; ring;
    · convert Finset.card_bij ( fun T hT => T ) _ _ _ <;> simp +decide

/-- The finite family of all connected clusters touching `g` whose size is at
most `K + 1`, summed with the tree-sum summand.

This is the enlargement device: every finite family of connected clusters
touching `g0` embeds, by nonnegativity, into `boundedTouchSum` at a large
enough depth.  The depth parameter `K` is aligned with `kpPsi`: a rooted tree
of depth at most `K` has at most `K + 1` vertices. -/
noncomputable def boundedTouchSum (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    Real := by
  classical
  exact ∑ p : (Σ m : Fin (K + 2), (Fin m.val -> Gamma)),
    if (Cluster.Connected S hdec ⟨p.1.val, p.2⟩
        ∧ Cluster.Touches S ⟨p.1.val, p.2⟩ g)
    then treeTerm S hdec ⟨p.1.val, p.2⟩ else 0

/-- `boundedTouchSum` is nonnegative. -/
theorem boundedTouchSum_nonneg (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    0 <= boundedTouchSum S hdec K g := by
  classical
  unfold boundedTouchSum
  apply Finset.sum_nonneg
  intro p _
  split
  · exact treeTerm_nonneg S hdec _
  · exact le_refl 0

/-- Enlargement step: any finite family of connected clusters touching `g0` is
dominated by `boundedTouchSum` at depth equal to the largest cluster size in
the family.  This uses only nonnegativity of the summand and injectivity of the
underlying-cluster map on the subtype. -/
theorem sum_le_boundedTouchSum (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (g0 : Gamma)
    (s : Finset {X : Cluster S // X.Connected S hdec /\ X.Touches S g0}) :
    s.sum (fun X => treeTerm S hdec X.1)
      <= boundedTouchSum S hdec (s.sup (fun X => X.1.n)) g0 := by
  classical
  have hbound : forall X : {x // x ∈ s},
      X.1.1.n < (s.sup (fun X => X.1.n)) + 2 := by
    intro X
    have h : X.1.1.n <= s.sup (fun X => X.1.n) :=
      Finset.le_sup
        (f := fun Y : {X : Cluster S // X.Connected S hdec /\ X.Touches S g0} =>
          Y.1.n) X.2
    omega
  set i :
      {x // x ∈ s} ->
        (Σ m : Fin ((s.sup (fun X => X.1.n)) + 2), (Fin m.val -> Gamma)) :=
    fun X => ⟨⟨X.1.1.n, hbound X⟩, X.1.1.poly⟩ with hi
  set F :
      (Σ m : Fin ((s.sup (fun X => X.1.n)) + 2), (Fin m.val -> Gamma)) ->
        Real :=
    fun p => if (Cluster.Connected S hdec ⟨p.1.val, p.2⟩
        /\ Cluster.Touches S ⟨p.1.val, p.2⟩ g0)
      then treeTerm S hdec ⟨p.1.val, p.2⟩ else 0 with hF
  have hinj : Set.InjOn i ↑s.attach := by
    intro X _ Y _ h
    have h2 : X.1.1 = Y.1.1 :=
      congrArg (fun p => (⟨p.1.val, p.2⟩ : Cluster S)) h
    exact Subtype.ext (Subtype.ext h2)
  have hFnonneg : forall p, 0 <= F p := by
    intro p
    simp only [hF]
    split
    · exact treeTerm_nonneg S hdec _
    · exact le_refl 0
  have hsummand : forall X : {x // x ∈ s},
      treeTerm S hdec X.1.1 = F (i X) := by
    intro X
    simp only [hF, hi]
    rw [if_pos X.1.2]
  calc
    s.sum (fun X => treeTerm S hdec X.1)
        = ∑ X ∈ s.attach, treeTerm S hdec X.1.1 :=
          (Finset.sum_attach s (fun X => treeTerm S hdec X.1)).symm
    _ = ∑ X ∈ s.attach, F (i X) :=
          Finset.sum_congr rfl (fun X _ => hsummand X)
    _ = ∑ p ∈ s.attach.image i, F p := (Finset.sum_image hinj).symm
    _ <= ∑ p, F p :=
          Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _)
            (fun p _ _ => hFnonneg p)
    _ = boundedTouchSum S hdec (s.sup (fun X => X.1.n)) g0 := by
          rw [hF, boundedTouchSum]

/-- Base case of the exponential bound: at depth `0`, only single-slot
clusters survive, and the tree-sum is exactly bounded by `|weight g|`. -/
theorem boundedTouchSum_zero_le (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (g : Gamma) :
    boundedTouchSum S hdec 0 g <= |S.weight g| := by
  refine' le_of_eq _
  unfold boundedTouchSum
  rw [Finset.sum_eq_single ⟨1, fun _ => g⟩]
  · simp +decide [Cluster.Touches, Cluster.Connected]
    unfold treeTerm
    simp +decide [Cluster.graph]
    unfold spanningTreeCount
    simp +decide [Cluster.absWeight]
    unfold Cluster.graph
    simp +decide [SimpleGraph.connected_iff_exists_forall_reachable]
    convert congr_arg (fun x : Nat => (x : Real) * |S.weight g|)
      (PenroseTreeGraph.spanningTreeCount_card_one
        (show Fintype.card (Fin 1) = 1 from rfl)) using 1
    norm_num
  · rintro ⟨⟨n, hn⟩, p⟩ _ hne
    cases n with
    | zero =>
        simp +decide [Cluster.Touches]
    | succ n =>
        cases n with
        | zero =>
            by_cases hp : p = fun _ : Fin 1 => g
            · exfalso
              apply hne
              subst hp
              rfl
            · simp +decide [Cluster.Touches]
              intro _hconn hp0
              exfalso
              apply hp
              funext j
              fin_cases j
              exact hp0
        | succ n =>
            omega
  · simp +decide

open Classical in
/-- The connectedness guard in `boundedTouchSum` is redundant.

An ordered cluster whose incompatibility graph is disconnected has
`spanningTreeCount = 0`, hence `treeTerm = 0`, so it contributes nothing
whether or not the guard is present.  Thus `boundedTouchSum (K + 1) g` equals
the same sum carrying only the `Touches g` guard.  This is a sound
reformulation, not an overcount. -/
lemma boundedTouchSum_eq_touchOnly (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec (K + 1) g
      = ∑ p : (Σ m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
          (if Cluster.Touches S ⟨p.1.val, p.2⟩ g
            then treeTerm S hdec ⟨p.1.val, p.2⟩ else 0) := by
  unfold boundedTouchSum
  apply Finset.sum_congr rfl
  intro p _
  by_cases hT : Cluster.Touches S ⟨p.1.val, p.2⟩ g
  · by_cases hC : Cluster.Connected S hdec ⟨p.1.val, p.2⟩
    · rw [if_pos ⟨hC, hT⟩, if_pos hT]
    · rw [if_neg (fun h => hC h.1), if_pos hT]
      unfold treeTerm
      rw [spanningTreeCount_eq_zero_of_not_connected S hdec _ hC]
      simp
  · rw [if_neg (fun h => hT h.2), if_neg hT]

/-- A cluster touching `g` has a least slot carrying `g`.

This is the canonical root intended for the rooted-tree deletion proof of
`pairSum_le_expBound`. -/
lemma exists_canonical_root (S : PolymerSystem Gamma) (X : Cluster S) (g : Gamma)
    (h : X.Touches S g) :
    ∃ r : Fin X.n, X.poly r = g ∧ ∀ i : Fin X.n, X.poly i = g → r ≤ i := by
  classical
  obtain ⟨i0, hi0⟩ := h
  let roots : Finset (Fin X.n) := Finset.univ.filter (fun i => X.poly i = g)
  have hroots : roots.Nonempty := ⟨i0, by simp [roots, hi0]⟩
  refine ⟨roots.min' hroots, ?_, ?_⟩
  · have hmem := roots.min'_mem hroots
    simpa [roots] using hmem
  · intro i hi
    exact roots.min'_le i (by simp [roots, hi])

/-- A tree edge out of a slot carrying `g` lands in the KP neighborhood of
`g`.

This is the first local fact needed after canonical-root deletion: every
subtree block attached to the chosen root starts at a polymer incompatible
with the root polymer.  The later block-decomposition and fiber-count
construction remains open. -/
lemma tree_root_child_mem_nbhd (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (g : Gamma) {T : SimpleGraph (Fin X.n)}
    {r j : Fin X.n} (hTle : T ≤ X.graph S hdec)
    (hr : X.poly r = g) (hAdj : T.Adj r j) :
    X.poly j ∈ nbhd S hdec g := by
  have hgraph := hTle hAdj
  have hinc : S.incompatible g (X.poly j) := by
    simpa [Cluster.graph, hr] using hgraph.2
  simp [nbhd, hinc]

open Classical in
/-- Root-adjacent children of a chosen root in a tree subgraph.

This is the finite child-index set that a future canonical-root deletion proof
will use before splitting the deleted tree into child blocks. -/
noncomputable def treeRootChildren {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) : Finset (Fin n) :=
  Finset.univ.filter (fun j => T.Adj r j)

/-- Membership in `treeRootChildren` is exactly adjacency to the root. -/
lemma mem_treeRootChildren {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) :
    j ∈ treeRootChildren T r ↔ T.Adj r j := by
  simp [treeRootChildren]

/-- The root itself is not one of its tree children. -/
lemma root_not_mem_treeRootChildren {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) :
    r ∉ treeRootChildren T r := by
  simp [treeRootChildren]

/-- Root children are among the non-root slots. -/
lemma treeRootChildren_subset_erase {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) :
    treeRootChildren T r ⊆ Finset.univ.erase r := by
  intro j hj
  have hAdj : T.Adj r j := (mem_treeRootChildren T r j).mp hj
  simp [hAdj.ne.symm]

/-- A root in an `n`-slot tree has at most `n - 1` root-adjacent children.

This is the finite arity bound needed by the later child-forest truncation in
`pairSum_le_expBound`: after deleting the canonical root, every immediate
child is one of the remaining slots. -/
lemma treeRootChildren_card_add_one_le {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) :
    (treeRootChildren T r).card + 1 <= n := by
  have hcard := Finset.card_le_card (treeRootChildren_subset_erase T r)
  have hcard' :
      (treeRootChildren T r).card + 1 <= (Finset.univ.erase r).card + 1 := by
    exact Nat.succ_le_succ hcard
  have herase : (Finset.univ.erase r).card = n - 1 := by
    simp
  have hnpos : 0 < n := lt_of_le_of_lt (Nat.zero_le r.val) r.2
  have hle1 : 1 <= n := Nat.succ_le_of_lt hnpos
  have hpred : n - 1 + 1 = n := Nat.sub_add_cancel hle1
  rw [herase, hpred] at hcard'
  exact hcard'

/-- The tree subgraph after deleting the chosen root slot, as an induced graph
on non-root slots.

This is the ambient graph whose connected components will become the child
blocks in a later canonical-root deletion proof. -/
noncomputable def treeRootDeletedGraph {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) : SimpleGraph {j : Fin n // j ≠ r} :=
  T.induce {j : Fin n | j ≠ r}

/-- Adjacency in the root-deleted graph is exactly adjacency in the original
tree subgraph between the underlying non-root slots. -/
lemma treeRootDeletedGraph_adj {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (i j : {v : Fin n // v ≠ r}) :
    (treeRootDeletedGraph T r).Adj i j ↔ T.Adj i.1 j.1 := by
  rfl

/-- A root child, viewed as a vertex of the root-deleted graph. -/
noncomputable def treeRootChildAsDeleted {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (j : Fin n) (hj : j ∈ treeRootChildren T r) :
    {v : Fin n // v ≠ r} :=
  ⟨j, by
    have hAdj : T.Adj r j := (mem_treeRootChildren T r j).mp hj
    exact hAdj.ne.symm⟩

/-- Coercing a root child back from the root-deleted vertex type recovers the
original slot. -/
lemma treeRootChildAsDeleted_coe {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    (treeRootChildAsDeleted T r j hj : Fin n) = j := rfl

/-- The connected component of the root-deleted graph generated by a root
child.

This is the future child-block object for the canonical-root deletion proof. -/
noncomputable def treeRootChildComponent {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (j : Fin n) (hj : j ∈ treeRootChildren T r) :
    (treeRootDeletedGraph T r).ConnectedComponent :=
  (treeRootDeletedGraph T r).connectedComponentMk
    (treeRootChildAsDeleted T r j hj)

/-- A root child belongs to the deleted-graph component that it generates. -/
lemma treeRootChild_mem_component {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    treeRootChildAsDeleted T r j hj ∈
      (treeRootChildComponent T r j hj).supp := by
  exact SimpleGraph.ConnectedComponent.connectedComponentMk_mem

/-- Vertices in a root child's deleted-graph component are reachable from that
root child inside the root-deleted graph. -/
lemma treeRootChildComponent_reachable {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r)
    {v : {x : Fin n // x ≠ r}}
    (hv : v ∈ (treeRootChildComponent T r j hj).supp) :
    (treeRootDeletedGraph T r).Reachable
      (treeRootChildAsDeleted T r j hj) v := by
  exact SimpleGraph.ConnectedComponent.reachable_of_mem_supp
    (treeRootChildComponent T r j hj)
    (treeRootChild_mem_component T r j hj) hv

open Classical in
/-- The finite vertex block underlying a root child's deleted-graph component.

This packages the component support as a `Finset`, which is the shape needed
for later block reindexing and finite fiber counts. -/
noncomputable def treeRootChildBlock {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (j : Fin n) (hj : j ∈ treeRootChildren T r) :
    Finset {x : Fin n // x ≠ r} :=
  Finset.univ.filter (fun v => v ∈ (treeRootChildComponent T r j hj).supp)

/-- Membership in a child block is membership in the corresponding component
support. -/
lemma mem_treeRootChildBlock {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (j : Fin n) (hj : j ∈ treeRootChildren T r)
    (v : {x : Fin n // x ≠ r}) :
    v ∈ treeRootChildBlock T r j hj ↔
      v ∈ (treeRootChildComponent T r j hj).supp := by
  simp [treeRootChildBlock]

/-- The root child belongs to its finite child block. -/
lemma treeRootChild_mem_block {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    treeRootChildAsDeleted T r j hj ∈ treeRootChildBlock T r j hj := by
  simpa [mem_treeRootChildBlock]
    using treeRootChild_mem_component T r j hj

/-- Every finite-block vertex is reachable from the root child inside the
root-deleted graph. -/
lemma treeRootChildBlock_reachable {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r)
    {v : {x : Fin n // x ≠ r}}
    (hv : v ∈ treeRootChildBlock T r j hj) :
    (treeRootDeletedGraph T r).Reachable
      (treeRootChildAsDeleted T r j hj) v := by
  exact treeRootChildComponent_reachable T r j hj
    ((mem_treeRootChildBlock T r j hj v).mp hv)

/-- Membership in a root-child block is exactly reachability from that child
inside the root-deleted tree.  This packages the connected-component support
definition in the form needed to reindex child subtrees. -/
lemma treeRootChildBlock_mem_iff_reachable {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r)
    (v : {x : Fin n // x ≠ r}) :
    v ∈ treeRootChildBlock T r j hj ↔
      (treeRootDeletedGraph T r).Reachable
        (treeRootChildAsDeleted T r j hj) v := by
  constructor
  · exact treeRootChildBlock_reachable T r j hj
  · intro h
    rw [mem_treeRootChildBlock]
    rw [treeRootChildComponent]
    rw [SimpleGraph.ConnectedComponent.mem_supp_iff]
    rw [SimpleGraph.ConnectedComponent.eq]
    exact h.symm

/-- A root-child block is nonempty. -/
lemma treeRootChildBlock_nonempty {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    (treeRootChildBlock T r j hj).Nonempty :=
  ⟨treeRootChildAsDeleted T r j hj, treeRootChild_mem_block T r j hj⟩

/-- A root-child block has positive cardinality. -/
lemma treeRootChildBlock_card_pos {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    0 < (treeRootChildBlock T r j hj).card := by
  exact Finset.card_pos.mpr (treeRootChildBlock_nonempty T r j hj)

/-- A root-child block contains at most the non-root slots. -/
lemma treeRootChildBlock_card_add_one_le {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    (treeRootChildBlock T r j hj).card + 1 <= n := by
  have hle : (treeRootChildBlock T r j hj).card <=
      Fintype.card {x : Fin n // x ≠ r} := by
    simpa using Finset.card_le_univ (s := treeRootChildBlock T r j hj)
  have hsub : Fintype.card {x : Fin n // x ≠ r} = n - 1 := by
    haveI : Subsingleton {x : Fin n // x = r} :=
      ⟨fun a b => Subtype.ext (a.property.trans b.property.symm)⟩
    have hsingle : Fintype.card {x : Fin n // x = r} = 1 := by
      exact Fintype.card_ofSubsingleton ⟨r, rfl⟩
    have h := Fintype.card_subtype_compl (fun x : Fin n => x = r)
    rw [Fintype.card_fin, hsingle] at h
    exact h
  have hle' : (treeRootChildBlock T r j hj).card + 1 <= n - 1 + 1 := by
    exact Nat.succ_le_succ (by simpa [hsub] using hle)
  have hnpos : 0 < n := lt_of_le_of_lt (Nat.zero_le r.val) r.2
  have hle1 : 1 <= n := Nat.succ_le_of_lt hnpos
  have hpred : n - 1 + 1 = n := Nat.sub_add_cancel hle1
  rw [hpred] at hle'
  exact hle'

/-- Injective `comap`s of acyclic graphs are acyclic.

This is a small graph-transport helper for subtree reindexing: when vertices
are merely relabelled by an injective map, a cycle in the pulled-back graph
would map to a cycle upstairs. -/
lemma comap_isAcyclic_of_injective {V W : Type*} {G : SimpleGraph W}
    (f : V -> W) (hf : Function.Injective f) (hG : G.IsAcyclic) :
    (SimpleGraph.comap f G).IsAcyclic := by
  intro v c hc
  exact hG (c.map (SimpleGraph.Hom.comap f G)) (hc.map hf)

/-- Deleting the root from a tree leaves an acyclic graph. -/
lemma treeRootDeletedGraph_acyclic {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (hT : T.IsTree) :
    (treeRootDeletedGraph T r).IsAcyclic := by
  change (SimpleGraph.comap (fun v : {x : Fin n // x ≠ r} => (v : Fin n)) T).IsAcyclic
  exact comap_isAcyclic_of_injective
    (fun v : {x : Fin n // x ≠ r} => (v : Fin n))
    (fun _ _ h => Subtype.ext h) hT.2

/-- Connectedness of a component transported through the canonical
`Fin A.card` reindexing of a finite component support. -/
lemma comap_orderIso_connected_of_component {V : Type*} [LinearOrder V]
    (A : Finset V) {H : SimpleGraph V} {c : V}
    (hc : c ∈ A) (hA : ∀ v, v ∈ A ↔ H.Reachable c v) :
    (SimpleGraph.comap (fun i : Fin A.card => (A.orderIsoOfFin rfl i : V)) H).Connected := by
  classical
  have hconn :
      (SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) H).Connected :=
    PenroseTreeGraph.comap_connected_of_component hc (by
      intro v
      simpa using hA v)
  let e : {x : V // x ∈ (↑A : Set V)} ≃ Fin A.card :=
    (A.orderIsoOfFin rfl).toEquiv.symm
  let hom :
      SimpleGraph.comap (Function.Embedding.subtype (· ∈ (↑A : Set V))) H →g
        SimpleGraph.comap (fun i : Fin A.card => (A.orderIsoOfFin rfl i : V)) H :=
    { toFun := e
      map_rel' := by
        intro x y hxy
        change H.Adj ((A.orderIsoOfFin rfl (e x) : V))
          ((A.orderIsoOfFin rfl (e y) : V))
        simpa [e] using hxy }
  exact hconn.map hom (by simpa [hom] using e.surjective)

/-- The root-deleted graph restricted to one child block is connected after
the canonical `Fin card` reindexing. -/
lemma treeRootChildBlock_deletedGraph_connected {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hj : j ∈ treeRootChildren T r) :
    (SimpleGraph.comap
      (fun i : Fin (treeRootChildBlock T r j hj).card =>
        ((treeRootChildBlock T r j hj).orderIsoOfFin rfl i : {x : Fin n // x ≠ r}))
      (treeRootDeletedGraph T r)).Connected := by
  exact comap_orderIso_connected_of_component (treeRootChildBlock T r j hj)
    (treeRootChild_mem_block T r j hj)
    (fun v => treeRootChildBlock_mem_iff_reachable T r j hj v)

/-- The root-deleted graph restricted to one child block is itself a tree.

This is the first subtree-reindexing bridge needed by the final
canonical-root classification map: each component below the root is not merely
a finite block, but a canonically reindexed tree. -/
lemma treeRootChildBlock_deletedGraph_isTree {n : Nat} (T : SimpleGraph (Fin n))
    (r j : Fin n) (hT : T.IsTree) (hj : j ∈ treeRootChildren T r) :
    (SimpleGraph.comap
      (fun i : Fin (treeRootChildBlock T r j hj).card =>
        ((treeRootChildBlock T r j hj).orderIsoOfFin rfl i : {x : Fin n // x ≠ r}))
      (treeRootDeletedGraph T r)).IsTree := by
  refine ⟨treeRootChildBlock_deletedGraph_connected T r j hj, ?_⟩
  exact comap_isAcyclic_of_injective
    (fun i : Fin (treeRootChildBlock T r j hj).card =>
      ((treeRootChildBlock T r j hj).orderIsoOfFin rfl i : {x : Fin n // x ≠ r}))
    (fun _ _ h => (treeRootChildBlock T r j hj).orderIsoOfFin rfl |>.injective
      (Subtype.ext h))
    (treeRootDeletedGraph_acyclic T r hT)

/-- If two root-child components are unequal, then their finite child blocks
are disjoint.  The remaining tree-specific work is to prove this component
inequality from distinct root children in a tree. -/
lemma disjoint_treeRootChildBlock_of_component_ne {n : Nat}
    (T : SimpleGraph (Fin n)) (r j k : Fin n)
    (hj : j ∈ treeRootChildren T r) (hk : k ∈ treeRootChildren T r)
    (hne :
      treeRootChildComponent T r j hj ≠ treeRootChildComponent T r k hk) :
    Disjoint (treeRootChildBlock T r j hj) (treeRootChildBlock T r k hk) := by
  rw [Finset.disjoint_left]
  intro v hvj hvk
  have hvj' : v ∈ (treeRootChildComponent T r j hj).supp :=
    (mem_treeRootChildBlock T r j hj v).mp hvj
  have hvk' : v ∈ (treeRootChildComponent T r k hk).supp :=
    (mem_treeRootChildBlock T r k hk v).mp hvk
  exact hne (SimpleGraph.ConnectedComponent.eq_of_common_vertex hvj' hvk')

/-- Distinct root children of a tree lie in distinct components after deleting
the root. -/
lemma treeRootChildComponent_ne_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (r j k : Fin n) (hT : T.IsTree)
    (hj : j ∈ treeRootChildren T r) (hk : k ∈ treeRootChildren T r)
    (hjk : j ≠ k) :
    treeRootChildComponent T r j hj ≠ treeRootChildComponent T r k hk := by
  contrapose! hjk
  have hUnique := hT.existsUnique_path j k
  simp_all +decide
  obtain ⟨p, hp⟩ : ∃ p : T.Walk j k, p.IsPath ∧ ∀ v ∈ p.support, v ≠ r := by
    have hReachable :
        (treeRootDeletedGraph T r).Reachable
          (treeRootChildAsDeleted T r j hj)
          (treeRootChildAsDeleted T r k hk) := by
      exact SimpleGraph.ConnectedComponent.reachable_of_mem_supp _
        (treeRootChild_mem_component _ _ _ _)
        (hjk.symm ▸ treeRootChild_mem_component _ _ _ _)
    obtain ⟨p, hp⟩ := hReachable.exists_isPath
    refine ⟨p.map (SimpleGraph.Hom.comap _ _), ?_, ?_⟩ <;>
      simp_all +decide
    simp_all +decide [SimpleGraph.Walk.isPath_def]
    exact List.Nodup.map (fun _ _ => by aesop) hp
  have hAdjJ : T.Adj r j := (mem_treeRootChildren T r j).mp hj
  have hAdjK : T.Adj r k := (mem_treeRootChildren T r k).mp hk
  have hUniquePath : ∀ p q : T.Walk j k, p.IsPath → q.IsPath → p = q := by
    exact fun p q hp hq => by
      have := hUnique.unique hp hq
      aesop
  specialize hUniquePath p
    (SimpleGraph.Walk.cons hAdjJ.symm
      (SimpleGraph.Walk.cons hAdjK SimpleGraph.Walk.nil)) hp.1
  simp_all +decide [SimpleGraph.Walk.cons_isPath_iff]
  by_cases hrk : r = k <;> by_cases hjk' : j = k <;>
    simp_all +decide [SimpleGraph.Walk.cons_isPath_iff]
  exact absurd hrk (by
    rintro rfl
    exact hAdjK.ne rfl)

/-- Distinct root children of a tree give disjoint finite child blocks. -/
lemma disjoint_treeRootChildBlock_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (r j k : Fin n) (hT : T.IsTree)
    (hj : j ∈ treeRootChildren T r) (hk : k ∈ treeRootChildren T r)
    (hjk : j ≠ k) :
    Disjoint (treeRootChildBlock T r j hj) (treeRootChildBlock T r k hk) := by
  exact disjoint_treeRootChildBlock_of_component_ne T r j k hj hk
    (treeRootChildComponent_ne_of_ne T r j k hT hj hk hjk)

/-- Covering half of the partition: every non-root slot of a spanning tree
rooted at `r` lies in the child block of some root child.

Together with `disjoint_treeRootChildBlock_of_ne` this shows the child blocks
partition the non-root slots (`Fin n` minus `{r}`). -/
lemma exists_treeRootChildBlock_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (r : Fin n) (hT : T.IsTree) (v : {x : Fin n // x ≠ r}) :
    ∃ (j : Fin n) (hj : j ∈ treeRootChildren T r),
      v ∈ treeRootChildBlock T r j hj := by
  classical
  obtain ⟨w, hwne⟩ := v
  have hconn : T.Connected := hT.isConnected
  have hR : T.Reachable r w := hconn r w
  obtain ⟨p, hp⟩ := hR.exists_isPath
  cases p with
  | nil => exact (hwne rfl).elim
  | cons hadj q =>
    rename_i c
    have hc : c ∈ treeRootChildren T r := (mem_treeRootChildren T r c).mpr hadj
    rw [SimpleGraph.Walk.cons_isPath_iff] at hp
    obtain ⟨hqpath, hrnotin⟩ := hp
    have hw : ∀ x ∈ q.support, x ∈ {j : Fin n | j ≠ r} := by
      intro x hx
      simp only [Set.mem_setOf_eq]
      intro hxr
      exact hrnotin (hxr ▸ hx)
    refine ⟨c, hc, ?_⟩
    rw [mem_treeRootChildBlock]
    have hwalk : (treeRootDeletedGraph T r).Walk
        (treeRootChildAsDeleted T r c hc) ⟨w, hwne⟩ := by
      have hq := q.induce {j : Fin n | j ≠ r} hw
      exact hq.copy (by apply Subtype.ext; rfl) (by apply Subtype.ext; rfl)
    have hreach : (treeRootDeletedGraph T r).Reachable
        (treeRootChildAsDeleted T r c hc) ⟨w, hwne⟩ := ⟨hwalk⟩
    have : (treeRootChildComponent T r c hc)
        = (treeRootDeletedGraph T r).connectedComponentMk ⟨w, hwne⟩ := by
      rw [treeRootChildComponent]
      exact (SimpleGraph.ConnectedComponent.eq).mpr hreach
    rw [treeRootChildComponent] at this ⊢
    rw [SimpleGraph.ConnectedComponent.mem_supp_iff]
    exact this.symm

open Classical in
/-- Non-dependent child-block wrapper: the block of `j` if `j` is a root child,
otherwise empty.  This is the shape needed to sum block cardinalities. -/
noncomputable def childBlockOf {n : Nat} (T : SimpleGraph (Fin n)) (r : Fin n)
    (j : Fin n) : Finset {x : Fin n // x ≠ r} :=
  if hj : j ∈ treeRootChildren T r then treeRootChildBlock T r j hj else ∅

/-- The child blocks cover all non-root slots. -/
lemma biUnion_childBlockOf {n : Nat} (T : SimpleGraph (Fin n)) (r : Fin n)
    (hT : T.IsTree) :
    (treeRootChildren T r).biUnion (childBlockOf T r) = Finset.univ := by
  classical
  refine Finset.eq_univ_of_forall (fun v => ?_)
  obtain ⟨j, hj, hv⟩ := exists_treeRootChildBlock_of_ne T r hT v
  refine Finset.mem_biUnion.mpr ⟨j, hj, ?_⟩
  rw [childBlockOf, dif_pos hj]
  exact hv

/-- Distinct root children give disjoint non-dependent child blocks. -/
lemma disjoint_childBlockOf_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (r j k : Fin n) (hT : T.IsTree) (hjk : j ≠ k) :
    Disjoint (childBlockOf T r j) (childBlockOf T r k) := by
  classical
  by_cases hj : j ∈ treeRootChildren T r
  · by_cases hk : k ∈ treeRootChildren T r
    · simp only [childBlockOf, dif_pos hj, dif_pos hk]
      exact disjoint_treeRootChildBlock_of_ne T r j k hT hj hk hjk
    · simp only [childBlockOf, dif_neg hk]; exact Finset.disjoint_empty_right _
  · simp only [childBlockOf, dif_neg hj]; exact Finset.disjoint_empty_left _

/-- The child blocks partition the non-root slots: the sum of their
cardinalities is `n - 1`. -/
lemma sum_childBlockOf_card {n : Nat} (T : SimpleGraph (Fin n)) (r : Fin n)
    (hT : T.IsTree) :
    ∑ j ∈ treeRootChildren T r, (childBlockOf T r j).card = n - 1 := by
  classical
  have hcard : ((treeRootChildren T r).biUnion (childBlockOf T r)).card
      = ∑ j ∈ treeRootChildren T r, (childBlockOf T r j).card := by
    refine Finset.card_biUnion ?_
    intro j _ k _ hjk
    exact disjoint_childBlockOf_of_ne T r j k hT hjk
  rw [biUnion_childBlockOf T r hT] at hcard
  rw [← hcard]
  have hsub : Fintype.card {x : Fin n // x ≠ r} = n - 1 := by
    haveI : Subsingleton {x : Fin n // x = r} :=
      ⟨fun a b => Subtype.ext (a.property.trans b.property.symm)⟩
    have hsingle : Fintype.card {x : Fin n // x = r} = 1 :=
      Fintype.card_ofSubsingleton ⟨r, rfl⟩
    have h := Fintype.card_subtype_compl (fun x : Fin n => x = r)
    rw [Fintype.card_fin, hsingle] at h
    exact h
  simp [hsub]

/-- The ordered subcluster obtained by restricting a cluster to a finite set of
slots `B`, reindexed monotonically to `Fin B.card`.  This is the block
reindexing device for the canonical-root deletion argument. -/
noncomputable def restrictCluster (S : PolymerSystem Gamma) (X : Cluster S)
    (B : Finset (Fin X.n)) : Cluster S :=
  ⟨B.card, fun i => X.poly ((B.orderIsoOfFin rfl i : Fin X.n))⟩

/-- The absolute weight of a restricted subcluster is the product of the slot
weights over the block. -/
lemma absWeight_restrictCluster (S : PolymerSystem Gamma) (X : Cluster S)
    (B : Finset (Fin X.n)) :
    (restrictCluster S X B).absWeight S
      = ∏ v ∈ B, |S.weight (X.poly v)| := by
  unfold restrictCluster Cluster.absWeight
  rw [← Finset.prod_attach B (fun v => |S.weight (X.poly v)|)]
  exact Fintype.prod_equiv (B.orderIsoOfFin rfl).toEquiv _ _ (fun i => rfl)

/-- Restricting a tree/subgraph to a finite slot block preserves the
`≤ cluster.graph` relation after the canonical `Fin B.card` reindexing.

This is the graph-theoretic companion to `absWeight_restrictCluster`: once a
child subtree has been represented as a `comap` along the block order, this
lemma supplies the `T_j ≤ q_j.graph` half of the subtree-to-spanning-tree
handoff. -/
lemma restrictCluster_comap_le_graph (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (T : SimpleGraph (Fin X.n))
    (hTle : T <= X.graph S hdec) (B : Finset (Fin X.n)) :
    SimpleGraph.comap (fun i : Fin B.card => (B.orderIsoOfFin rfl i : Fin X.n)) T
      <= (restrictCluster S X B).graph S hdec := by
  intro i j hij
  simpa [Cluster.graph, restrictCluster] using hTle hij

/-- The child-block specialization of `restrictCluster_comap_le_graph`.

This isolates the exact subgraph relation needed by the future forest-atom
classification map: the original tree restricted to a root-child block lands
inside the incompatibility graph of the corresponding restricted subcluster. -/
lemma childBlock_comap_le_restrictCluster_graph (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r j : Fin X.n)
    (hTle : T <= X.graph S hdec) :
    SimpleGraph.comap
        (fun i : Fin (((childBlockOf T r j).image (fun v => v.1)).card) =>
          (((childBlockOf T r j).image (fun v => v.1)).orderIsoOfFin rfl i : Fin X.n))
        T
      <= (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).graph S hdec := by
  exact restrictCluster_comap_le_graph S hdec X T hTle
    ((childBlockOf T r j).image (fun v => v.1))

/-- The restricted child-cluster size is exactly the child-block cardinality.

This is the cardinal bookkeeping bridge between the future forest atom
`restrictCluster` and the block sizes used by the fixed-fiber factorial
normalization. -/
lemma restrictCluster_childBlock_n_eq (S : PolymerSystem Gamma)
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r j : Fin X.n) :
    (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).n =
      (childBlockOf T r j).card := by
  unfold restrictCluster
  exact Finset.card_image_of_injOn (by
    intro a _ha b _hb h
    exact Subtype.ext h)

/-- Child-cluster sizes sum to the non-root slot count. -/
lemma sum_restrictCluster_childBlock_n
    (S : PolymerSystem Gamma) (X : Cluster S) (T : SimpleGraph (Fin X.n))
    (r : Fin X.n) (hT : T.IsTree) :
    ∑ j ∈ treeRootChildren T r,
        (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).n =
      X.n - 1 := by
  rw [← sum_childBlockOf_card T r hT]
  apply Finset.sum_congr rfl
  intro j _hj
  exact restrictCluster_childBlock_n_eq S X T r j

/-- The restricted child-cluster weight is exactly the product over the
corresponding deleted-root child block. -/
lemma restrictCluster_childBlock_absWeight_eq (S : PolymerSystem Gamma)
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r j : Fin X.n) :
    (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).absWeight S
      = ∏ v ∈ childBlockOf T r j, |S.weight (X.poly v.1)| := by
  rw [absWeight_restrictCluster]
  rw [Finset.prod_image (fun a _ha b _hb h => Subtype.ext h)]

/-- Weight factorization across the canonical-root deletion: the absolute
weight of a cluster `X` with root slot `r` factors as the root weight times
the product of restricted-subcluster weights over the child blocks. -/
lemma absWeight_eq_root_mul_blocks (S : PolymerSystem Gamma)
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r : Fin X.n) (hT : T.IsTree) :
    X.absWeight S
      = |S.weight (X.poly r)| *
          ∏ j ∈ treeRootChildren T r,
            (restrictCluster S X
              ((childBlockOf T r j).image (fun v => v.1))).absWeight S := by
  classical
  -- rewrite each restricted block weight as a product over the subtype block
  have hblock : ∀ j ∈ treeRootChildren T r,
      (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).absWeight S
        = ∏ v ∈ childBlockOf T r j, |S.weight (X.poly v.1)| := by
    intro j _hj
    exact restrictCluster_childBlock_absWeight_eq S X T r j
  rw [Finset.prod_congr rfl hblock]
  -- product over children of product over blocks = product over biUnion (disjoint)
  rw [← Finset.prod_biUnion]
  · -- biUnion of blocks = univ of subtype, so product over subtype = product over erase r
    rw [biUnion_childBlockOf T r hT]
    -- ∏_{v : {x // x ≠ r}} |w (X.poly v.1)| = ∏_{v ∈ univ.erase r} |w (X.poly v)|
    have hsub : (∏ v : {x : Fin X.n // x ≠ r}, |S.weight (X.poly v.1)|)
        = ∏ v ∈ (Finset.univ.erase r), |S.weight (X.poly v)| := by
      rw [← Finset.prod_subtype (Finset.univ.erase r)
        (fun x => by simp [Finset.mem_erase, and_comm])
        (fun v => |S.weight (X.poly v)|)]
    rw [hsub]
    -- root times product over erase = full product
    rw [Cluster.absWeight,
      ← Finset.mul_prod_erase Finset.univ (fun v => |S.weight (X.poly v)|)
        (Finset.mem_univ r)]
  · intro j _ k _ hjk
    exact disjoint_childBlockOf_of_ne T r j k hT hjk

/-- Every root child in the tree subgraph carries a polymer in the KP
neighborhood of the root polymer. -/
lemma treeRootChildren_poly_mem_nbhd (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (g : Gamma) {T : SimpleGraph (Fin X.n)}
    {r j : Fin X.n} (hTle : T ≤ X.graph S hdec)
    (hr : X.poly r = g) (hj : j ∈ treeRootChildren T r) :
    X.poly j ∈ nbhd S hdec g := by
  exact tree_root_child_mem_nbhd S hdec X g hTle hr
    ((mem_treeRootChildren T r j).mp hj)

/-- Root-child arity is compatible with the `K + 3` forest truncation.

This is the first size component of the future child-forest classification map:
if the parent cluster is indexed by `Fin (K + 1 + 2)`, then the immediate
root-child set is a legal `Fin (K + 3)` arity. -/
lemma treeRootChildren_card_lt_of_cluster_bound (S : PolymerSystem Gamma) (K : Nat)
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r : Fin X.n)
    (hn : X.n < K + 1 + 2) :
    (treeRootChildren T r).card < K + 3 := by
  have hcard := treeRootChildren_card_add_one_le T r
  omega

/-- A root-child block restricts to a cluster small enough for
`boundedTouchSum K`.

This records the child-size half of the child-forest `MapsTo` proof.  The
argument uses only the already-proved child-block cardinality estimate and the
fact that the image from deleted-root vertices back to parent slots cannot
increase cardinality. -/
lemma restrictCluster_childBlock_n_lt_of_cluster_bound (S : PolymerSystem Gamma)
    (K : Nat) (X : Cluster S) (T : SimpleGraph (Fin X.n))
    (r j : Fin X.n) (hn : X.n < K + 1 + 2)
    (hj : j ∈ treeRootChildren T r) :
    (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).n < K + 2 := by
  unfold restrictCluster
  have himage :
      ((childBlockOf T r j).image (fun v => v.1)).card
        <= (childBlockOf T r j).card := by
    exact Finset.card_image_le
  have hblock : (childBlockOf T r j).card + 1 <= X.n := by
    simp [childBlockOf, hj, treeRootChildBlock_card_add_one_le T r j hj]
  change ((childBlockOf T r j).image (fun v => v.1)).card < K + 2
  omega

/-- A child block, reindexed as a restricted cluster, still touches the
polymer carried by its root child.

This is the touch-witness component of the future child-forest classification
map. -/
lemma restrictCluster_childBlock_touches_root_child (S : PolymerSystem Gamma)
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r j : Fin X.n)
    (hj : j ∈ treeRootChildren T r) :
    (restrictCluster S X ((childBlockOf T r j).image (fun v => v.1))).Touches
      S (X.poly j) := by
  classical
  let B : Finset (Fin X.n) := (childBlockOf T r j).image (fun v => v.1)
  have hblock : treeRootChildAsDeleted T r j hj ∈ childBlockOf T r j := by
    simpa [childBlockOf, hj] using treeRootChild_mem_block T r j hj
  have hjB : j ∈ B := by
    exact Finset.mem_image.mpr ⟨treeRootChildAsDeleted T r j hj, hblock, rfl⟩
  unfold Cluster.Touches restrictCluster
  refine ⟨(B.orderIsoOfFin rfl).symm ⟨j, hjB⟩, ?_⟩
  have hidx :
      B.orderIsoOfFin rfl ((B.orderIsoOfFin rfl).symm ⟨j, hjB⟩) = ⟨j, hjB⟩ := by
    exact (B.orderIsoOfFin rfl).apply_symm_apply ⟨j, hjB⟩
  exact congrArg (fun x : B => X.poly (x : Fin X.n)) hidx

open Classical in
/-- Well-formedness of the child forest obtained by deleting a root slot.

This is the `MapsTo` precursor for the future proof of
`pairSum_le_expBound`: each root child determines a bounded child cluster,
anchored in the KP neighborhood of the root polymer, touching its own root
child, with the original tree restricted to the child block landing inside the
child cluster's incompatibility graph.  The lemma is deliberately stronger than
the canonical-root use case: it works for any chosen root slot carrying `g`;
the least-root condition will only be needed when defining the classification
map and grouping fibers. -/
lemma root_child_forest_wf (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat)
    (X : Cluster S) (g : Gamma) (T : SimpleGraph (Fin X.n))
    (hTle : T ≤ X.graph S hdec) (r : Fin X.n)
    (hn : X.n < K + 1 + 2) (hr : X.poly r = g) :
    (treeRootChildren T r).card < K + 3 ∧
      ∀ j ∈ treeRootChildren T r,
        let B := (childBlockOf T r j).image (fun v => v.1)
        (restrictCluster S X B).n < K + 2 ∧
          X.poly j ∈ nbhd S hdec g ∧
          (restrictCluster S X B).Touches S (X.poly j) ∧
          SimpleGraph.comap
            (fun i : Fin B.card => (B.orderIsoOfFin rfl i : Fin X.n)) T
              ≤ (restrictCluster S X B).graph S hdec := by
  refine ⟨treeRootChildren_card_lt_of_cluster_bound S K X T r hn, ?_⟩
  intro j hj
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact restrictCluster_childBlock_n_lt_of_cluster_bound S K X T r j hn hj
  · exact treeRootChildren_poly_mem_nbhd S hdec X g hTle hr hj
  · exact restrictCluster_childBlock_touches_root_child S X T r j hj
  · exact childBlock_comap_le_restrictCluster_graph S hdec X T r j hTle

open Classical in
/-- Expand the right-hand exponential partial sum into ordered child tuples.

This is the finite ordered-forest shape expected after deleting the canonical
root in a future proof of `pairSum_le_expBound`. -/
lemma rhs_forest_expand (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    |S.weight g| *
        ∑ k ∈ Finset.range (K + 3),
          (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
            / (Nat.factorial k : Real)
      = |S.weight g| *
        ∑ k ∈ Finset.range (K + 3),
          (∑ φ ∈ Fintype.piFinset (fun _ : Fin k => nbhd S hdec g),
            ∏ i : Fin k, boundedTouchSum S hdec K (φ i))
            / (Nat.factorial k : Real) := by
  congr 1
  apply Finset.sum_congr rfl
  intro k _
  rw [Finset.sum_pow']

/-- A small ascending-factorial estimate used by the multinomial normalization
helper below.  It packages the elementary comparison
`a * t! <= (a + 1) * ... * (a + t)` for `t >= 1`. -/
lemma ascFactorial_bound_mul_factorial (a t : Nat) (ht : 1 <= t) :
    a * Nat.factorial t <= Nat.ascFactorial (a + 1) t := by
  induction t with
  | zero => omega
  | succ t ih =>
      cases t with
      | zero =>
          simp [Nat.ascFactorial_succ]
      | succ t =>
          have hih : a * Nat.factorial (t + 1)
              <= Nat.ascFactorial (a + 1) (t + 1) := by
            exact ih (by omega)
          calc
            a * Nat.factorial (t + 2)
                = (t + 2) * (a * Nat.factorial (t + 1)) := by
                    rw [Nat.factorial_succ]
                    ring
            _ <= (t + 2) * Nat.ascFactorial (a + 1) (t + 1) := by
                    exact Nat.mul_le_mul_left _ hih
            _ <= (a + 1 + (t + 1)) * Nat.ascFactorial (a + 1) (t + 1) := by
                    exact Nat.mul_le_mul_right _ (by omega)
            _ = Nat.ascFactorial (a + 1) (t + 2) := by
                    symm
                    rw [Nat.ascFactorial_succ]

/-- Arithmetic DAG step for `pairSum_le_expBound`: if each child block has
positive size, then the child-order normalization `k!` times the product of
block factorials fits inside the factorial of the total root-plus-block size.

This is only the arithmetic normalization.  The geometric fiber-count theorem
that supplies the relevant block sizes remains open. -/
lemma factorial_mul_prod_factorial_le (k : Nat) (m : Fin k -> Nat)
    (hm : forall j, 1 <= m j) :
    Nat.factorial k * (Finset.univ.prod fun j => Nat.factorial (m j))
      <= Nat.factorial (1 + Finset.univ.sum fun j => m j) := by
  induction k with
  | zero =>
      simp
  | succ k ih =>
      let old : Fin k -> Nat := fun j => m (Fin.castSucc j)
      let last : Nat := m (Fin.last k)
      have hold : forall j, 1 <= old j := by
        intro j
        exact hm (Fin.castSucc j)
      have hlast : 1 <= last := hm (Fin.last k)
      have hih :
          Nat.factorial k * (Finset.univ.prod fun j : Fin k => Nat.factorial (old j))
            <= Nat.factorial (1 + Finset.univ.sum fun j : Fin k => old j) :=
        ih old hold
      let s : Nat := Finset.univ.sum fun j : Fin k => old j
      have hk_le_s : k <= s := by
        have hsum : (Finset.univ.sum fun _j : Fin k => (1 : Nat))
            <= Finset.univ.sum fun j : Fin k => old j := by
          exact Finset.sum_le_sum (fun j _ => hold j)
        simpa [s] using hsum
      have hblock : (s + 1) * Nat.factorial (s + 1) * Nat.factorial last
          <= Nat.factorial (1 + s + last) := by
        have hasc := ascFactorial_bound_mul_factorial (s + 1) last hlast
        have hmul := Nat.mul_le_mul_left (Nat.factorial (s + 1)) hasc
        rw [Nat.factorial_mul_ascFactorial (s + 1) last] at hmul
        simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm, Nat.add_assoc,
          Nat.add_comm, Nat.add_left_comm] using hmul
      calc
        Nat.factorial (k + 1)
            * (Finset.univ.prod fun j : Fin (k + 1) => Nat.factorial (m j))
            = (k + 1)
                * (Nat.factorial k
                    * (Finset.univ.prod fun j : Fin k => Nat.factorial (old j)))
                * Nat.factorial last := by
                simp [old, last, Fin.prod_univ_castSucc, Nat.factorial_succ,
                  Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm]
        _ <= (k + 1) * Nat.factorial (1 + s) * Nat.factorial last := by
                exact Nat.mul_le_mul_right _ <|
                  Nat.mul_le_mul_left _ (by simpa [s] using hih)
        _ <= (s + 1) * Nat.factorial (s + 1) * Nat.factorial last := by
                have hkfac : (k + 1) * Nat.factorial (1 + s)
                    <= (s + 1) * Nat.factorial (s + 1) := by
                  rw [show 1 + s = s + 1 by omega]
                  exact Nat.mul_le_mul_right _ (by omega)
                exact Nat.mul_le_mul_right _ hkfac
        _ <= Nat.factorial (1 + s + last) := hblock
        _ = Nat.factorial (1 + Finset.univ.sum fun j : Fin (k + 1) => m j) := by
                simp [s, old, last, Fin.sum_univ_castSucc, Nat.add_comm,
                  Nat.add_left_comm]

/-
Finset form of the multinomial normalization `factorial_mul_prod_factorial_le`:
for any finite index set `s` whose block sizes `m j` are all positive, the
child-order normalization `s.card !` times the product of block factorials fits
inside the factorial of `1 + (total block size)`.  This is the shape needed for
the canonical-root deletion, where the children form the `Finset`
`treeRootChildren T r`.
-/
lemma factorial_mul_prod_factorial_le_finset {ι : Type _} (s : Finset ι)
    (m : ι -> Nat) (hm : ∀ j ∈ s, 1 <= m j) :
    Nat.factorial s.card * (∏ j ∈ s, Nat.factorial (m j))
      <= Nat.factorial (1 + ∑ j ∈ s, m j) := by
  obtain ⟨e, he⟩ : ∃ e : Fin s.card ≃ { x : ι // x ∈ s }, True := by
    exact ⟨ Fintype.equivOfCardEq ( by simp +decide ), trivial ⟩;
  convert factorial_mul_prod_factorial_le s.card ( fun i => m ( e i ) ) ( fun i => hm _ ( e i |>.2 ) ) using 1;
  · conv_lhs => rw [ ← Finset.prod_coe_sort ] ;
    conv_lhs => rw [ ← Equiv.prod_comp e ] ;
  · rw [ ← Finset.sum_coe_sort ];
    conv_lhs => rw [ ← Equiv.sum_comp e ] ;

/-
Per-pair weight bound (arithmetic core of `pairSum_le_expBound`).  For a
cluster `X` with a spanning tree `T` rooted at a canonical slot `r` carrying
`g`, the ordered `1/n!` normalized weight is bounded by the child-ordered
`1/k!` normalization times the product of the block-normalized subcluster
weights.  This packages `absWeight_eq_root_mul_blocks`,
`factorial_mul_prod_factorial_le_finset`, and `sum_childBlockOf_card`.
-/
lemma perPair_absWeight_bound (S : PolymerSystem Gamma)
    (X : Cluster S) (g : Gamma) (T : SimpleGraph (Fin X.n))
    (hT : T.IsTree) (r : Fin X.n) (hr : X.poly r = g) :
    X.absWeight S / (Nat.factorial X.n : Real)
      <= |S.weight g| / (Nat.factorial (treeRootChildren T r).card : Real)
          * ∏ j ∈ treeRootChildren T r,
              ((restrictCluster S X
                  ((childBlockOf T r j).image (fun v => v.1))).absWeight S
                / (Nat.factorial (childBlockOf T r j).card : Real)) := by
  rw [ absWeight_eq_root_mul_blocks S X T r hT, div_mul_eq_mul_div, Finset.prod_div_distrib ];
  rw [ ← mul_div_assoc, div_div, hr ];
  gcongr;
  · exact mul_nonneg ( abs_nonneg _ ) ( Finset.prod_nonneg fun _ _ => Cluster.absWeight_nonneg _ _ );
  · rw_mod_cast [ mul_comm ];
    convert factorial_mul_prod_factorial_le_finset ( treeRootChildren T r ) ( fun j => ( childBlockOf T r j ).card ) _ using 1;
    · rw [ add_comm, sum_childBlockOf_card T r hT ];
      rw [ Nat.sub_add_cancel ( Fin.pos r ) ];
    · intro j hj
      simp [childBlockOf];
      split_ifs ; exact ⟨ _, treeRootChild_mem_block _ _ _ _ ⟩

/-- Fiber-value arithmetic step for `pairSum_le_expBound`.  A fiber of the
canonical-root classification map has constant summand `wg * A / n!`, size `C`,
and the multinomial *integer* inequality `C * (k! * fm) <= n!` (where
`fm = ∏_j m_j!`) reduces the fiber sum to the right-hand atom value
`wg / k! * (A / fm)`.  This isolates the pure real arithmetic so the
remaining content is the integer fiber-count bound. -/
lemma fiber_value_bound (wg A : Real) (n k C fm : Nat)
    (hwg : 0 <= wg) (hA : 0 <= A) (hfm : 0 < fm)
    (hC : C * (Nat.factorial k * fm) <= Nat.factorial n) :
    (C : Real) * (wg * A / (Nat.factorial n : Real))
      <= wg / (Nat.factorial k : Real) * (A / (fm : Real)) := by
  have hnpos : (0 : Real) < (Nat.factorial n : Real) := by
    exact_mod_cast Nat.factorial_pos n
  have hkpos : (0 : Real) < (Nat.factorial k : Real) := by
    exact_mod_cast Nat.factorial_pos k
  have hfmpos : (0 : Real) < (fm : Real) := by exact_mod_cast hfm
  have hkfm : (0 : Real) < (Nat.factorial k : Real) * (fm : Real) :=
    mul_pos hkpos hfmpos
  have hCle : (C : Real) * ((Nat.factorial k : Real) * (fm : Real))
      <= (Nat.factorial n : Real) := by exact_mod_cast hC
  have hwgA : 0 <= wg * A := mul_nonneg hwg hA
  rw [show wg / (Nat.factorial k : Real) * (A / (fm : Real))
        = (wg * A) / ((Nat.factorial k : Real) * (fm : Real)) from by
          rw [div_mul_div_comm],
      show (C : Real) * (wg * A / (Nat.factorial n : Real))
        = ((C : Real) * (wg * A)) / (Nat.factorial n : Real) from by
          rw [mul_div_assoc']]
  rw [div_le_iff₀ hnpos, div_mul_eq_mul_div, le_div_iff₀ hkfm]
  calc ((C : Real) * (wg * A)) * ((Nat.factorial k : Real) * (fm : Real))
        = (wg * A) * ((C : Real) * ((Nat.factorial k : Real) * (fm : Real))) := by
            ring
    _ <= (wg * A) * (Nat.factorial n : Real) :=
          mul_le_mul_of_nonneg_left hCle hwgA

/-- Counting core of the fiber-count step of `pairSum_le_expBound` (step D of
the canonical-root deletion argument).

This packages the integer fiber-count inequality
`(#Φ⁻¹ e) * (k! * ∏_j m_j!) ≤ n!` in a `Φ`-free, reusable form: whenever the
fiber `Fib` (the preimage of a fixed forest target `e` under the
canonical-root classification map), paired with an ordering `Perm (Fin k)` of
its `k` child blocks and orderings `Perm (Fin (m j))` within each block,
injects into the orderings `Perm (Fin n)` of all `n` slots, the fiber
cardinality obeys `#Fib * (k! * ∏_j m_j!) ≤ n!`.

The cardinality bookkeeping is
`Fintype.card (Fib × Perm (Fin k) × ∏_j Perm (Fin (m j)))
  = #Fib * (k! * ∏_j m_j!) ≤ #(Perm (Fin n)) = n!`
via `Fintype.card_le_of_injective`, `Fintype.card_perm`, `Fintype.card_fin`,
and `Fintype.card_pi`.  This is exactly the hypothesis `hC` consumed by
`fiber_value_bound`; supplying the injection `F` for each forest target is the
remaining geometric content of the deletion argument. -/
lemma fiber_card_mul_le_factorial {n k : Nat} (m : Fin k -> Nat)
    (Fib : Type*) [Fintype Fib]
    (F : Fib × Equiv.Perm (Fin k) × (∀ j, Equiv.Perm (Fin (m j)))
          -> Equiv.Perm (Fin n))
    (hF : Function.Injective F) :
    Fintype.card Fib * (Nat.factorial k * ∏ j, Nat.factorial (m j))
      <= Nat.factorial n := by
  have hcard :
      Fintype.card (Fib × Equiv.Perm (Fin k) × (∀ j, Equiv.Perm (Fin (m j))))
        = Fintype.card Fib * (Nat.factorial k * ∏ j, Nat.factorial (m j)) := by
    rw [Fintype.card_prod, Fintype.card_prod, Fintype.card_perm, Fintype.card_fin,
        Fintype.card_pi]
    congr 1
    congr 1
    apply Finset.prod_congr rfl
    intro j _
    rw [Fintype.card_perm, Fintype.card_fin]
  have hle := Fintype.card_le_of_injective F hF
  rw [hcard] at hle
  rwa [Fintype.card_perm, Fintype.card_fin] at hle

open Classical in
/-- Expand the right-hand exponential partial sum into ordered child *forests*:
the `k`-th power becomes a sum over child-polymer tuples `φ`, and each factor
`boundedTouchSum` unfolds (by its definition) into a sum over child clusters
`Q i`, so the product distributes into a sum over cluster tuples `Q`. -/
lemma rhs_forest_expand2 (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    |S.weight g| *
        ∑ k ∈ Finset.range (K + 3),
          (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
            / (Nat.factorial k : Real)
      = |S.weight g| *
        ∑ k ∈ Finset.range (K + 3),
          (∑ φ ∈ Fintype.piFinset (fun _ : Fin k => nbhd S hdec g),
            ∑ Q : (Fin k → (Σ m : Fin (K + 2), (Fin m.val -> Gamma))),
              ∏ i : Fin k,
                (if Cluster.Connected S hdec ⟨(Q i).1.val, (Q i).2⟩
                    ∧ Cluster.Touches S ⟨(Q i).1.val, (Q i).2⟩ (φ i)
                  then treeTerm S hdec ⟨(Q i).1.val, (Q i).2⟩ else 0))
            / (Nat.factorial k : Real) := by
  rw [rhs_forest_expand]
  congr 1
  apply Finset.sum_congr rfl
  intro k _
  congr 1
  apply Finset.sum_congr rfl
  intro φ _
  have : ∀ i : Fin k, boundedTouchSum S hdec K (φ i)
      = ∑ q : (Σ m : Fin (K + 2), (Fin m.val -> Gamma)),
          (if Cluster.Connected S hdec ⟨q.1.val, q.2⟩
              ∧ Cluster.Touches S ⟨q.1.val, q.2⟩ (φ i)
            then treeTerm S hdec ⟨q.1.val, q.2⟩ else 0) := by
    intro i; rfl
  simp_rw [this]
  rw [Finset.prod_univ_sum, Fintype.piFinset_univ]

open Classical in
/-- The labeled rooted-tree exponential inequality, now the single remaining
combinatorial crux of Q6 (stated with only the `Touches g` guard, via
`boundedTouchSum_eq_touchOnly`).

This is the only unproved statement on which `kp_tree_sum_bound` and
`kp_partial_sum_bound` depend.  Rooting a connected cluster touching `g` at a
slot carrying `g` and deleting that root should partition the remaining slots
into rooted subtree blocks, each rooted at a polymer incompatible with `g`.
The ordered `1/n!` normalization must then reconcile with the `1/k!` from
unordered child blocks and the subtree normalizations, giving the exponential
recursion.  Proving this is a finite labeled rooted-tree exponential-formula
problem, not a KP-statement ambiguity.

CAUTION (verified 2026-07-05, numerically and by hand): the naive reduction
that first bounds `boundedTouchSum (K + 1) g` by the root-overcounted sum
`sum p, (#{r : poly r = g}) * treeTerm p` and then bounds that by the
right-hand side is unsound.  Overcounting by the number of `g`-slots turns the
unrooted Cayley `m^(m-2)` tree count into the rooted `m^(m-1)` count, which
for a single self-incompatible polymer of small weight `x` already exceeds the
right-hand side at order `x^3` once `K >= 1` (rooted
`~ x + x^2 + 1.5 * x^3` versus right-hand side `~ x + x^2 + x^3`).  A correct
proof must root at a single canonical `g`-slot, with multiplicity one; the
required slack over the exponential comes from the unrooted children
`boundedTouchSum K h` versus rooted children.

The analytic exponential has been split off (see `boundedTouchSum_succ_le`
below): it suffices to bound `boundedTouchSum (K + 1) g` by the finite partial
sum of the exponential series in the neighbor bounded-touch-sum, truncated at
`k <= K + 2` (a connected cluster touching `g` of size at most `K + 2` has a
root with at most `K + 1` children).  This
`boundedTouchSum_succ_le_finitePartial` statement is the purely finite labeled
rooted-tree species identity; no real-analytic input remains in it. -/
lemma pairSum_le_expBound (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    (∑ p : (Σ m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S ⟨p.1.val, p.2⟩ g
          then ∑ _T ∈ (Finset.univ.filter
              (fun T : SimpleGraph (Fin (⟨p.1.val, p.2⟩ : Cluster S).n) =>
                T ≤ (⟨p.1.val, p.2⟩ : Cluster S).graph S hdec ∧ T.IsTree)),
              (⟨p.1.val, p.2⟩ : Cluster S).absWeight S
                / (Nat.factorial (⟨p.1.val, p.2⟩ : Cluster S).n : Real)
          else 0))
      <= |S.weight g| *
          ∑ k ∈ Finset.range (K + 3),
            (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real) := by
  -- HANDOFF RESIDUAL.  The canonical-root deletion DAG is now scaffolded and
  -- the following structural pieces are fully proved above and available:
  --   * partition of the non-root slots into child blocks:
  --       `biUnion_childBlockOf`, `disjoint_childBlockOf_of_ne`,
  --       `sum_childBlockOf_card` (sum of block sizes = n - 1),
  --       `exists_treeRootChildBlock_of_ne` (covering);
  --   * block reindexing and weight factorization:
  --       `restrictCluster`, `absWeight_restrictCluster`,
  --       `absWeight_eq_root_mul_blocks`
  --       (absWeight p = |w (p r)| * ∏_j absWeight q_j);
  --   * canonical root `exists_canonical_root`, child polymers in `nbhd g`
  --       (`treeRootChildren_poly_mem_nbhd`), arity/size bounds, and the
  --       multinomial normalization `factorial_mul_prod_factorial_le` and its
  --       `Finset` form `factorial_mul_prod_factorial_le_finset`
  --       (k! ∏ m_j! ≤ n!), plus the RHS expansion `rhs_forest_expand`.
  --   * ARITHMETIC CORE now proved: `perPair_absWeight_bound` packages
  --       `absWeight_eq_root_mul_blocks` + `factorial_mul_prod_factorial_le_finset`
  --       + `sum_childBlockOf_card` into the single weight inequality
  --         absWeight p / n! ≤ |w g|/k! * ∏_j (absWeight q_j / m_j!).
  --       (Used NOT per pair, but inside the fiber-grouped regrouping below,
  --       where each fiber has a constant summand equal to absWeight p / n!.)
  -- REMAINING CRUX (the single combinatorial residual): regroup the LHS pair
  -- sum by the classification map
  --   Φ(p,T) = (k, φ = (X.poly j_i)_i, (q_i, T_i)_i)  [UNROOTED induced
  --   subtrees T_i; children j_i taken in increasing slot order],
  -- via `Finset.sum_fiberwise_of_maps_to`, then bound each fiber:
  --   `#Φ⁻¹(e) ≤ n! / (k! ∏_j m_j!)`.
  -- This fiber bound is the entire remaining content.  It has been checked to
  -- hold WITH SLACK on small cases (e.g. n=3: the k=1 fiber has size 2 ≤ 3,
  -- the slack absorbing the freedom in the root-connection vertex inside each
  -- unrooted block -- this IS the "unrooted vs rooted children" slack).  The
  -- proof needs an injection of the fiber into the ordered set-partition
  -- arrangements of the n-1 non-root labels; the canonical-least-root and
  -- increasing-children constraints only REMOVE possibilities.  Combined with
  -- `perPair_absWeight_bound`-style arithmetic and constancy of the summand on
  -- each fiber, then `Finset.sum_le_sum_of_subset_of_nonneg` against the full
  -- RHS atom index set (image ⊆ all atoms, every atom term ≥ 0), this closes
  -- the inequality.
  --
  -- TIGHTENED RESIDUAL (real arithmetic now discharged).  With the fiber-value
  -- lemma `fiber_value_bound` proved above, the per-fiber step reduces to the
  -- single *integer* fiber-count inequality
  --     (#Φ⁻¹ e) * (k! * ∏_j m_j!) ≤ n!,
  -- where the fiber summand is the constant `|w g| * (∏_j aw q_j) / n!` (by
  -- `absWeight_eq_root_mul_blocks`), and `fiber_value_bound` then yields the
  -- right-hand atom value `|w g|/k! * ∏_j (aw q_j / m_j!)`.  The integer
  -- inequality is provable by the injection
  --     ((p,T), σ : Perm (Fin k), (ρ_j : Perm (Fin m_j))) ↦ (ordering of Fin n)
  -- root-first then blocks in σ-order internally reordered by ρ_j, giving
  --     (#fiber) * k! * ∏_j m_j! ≤ #(Perm (Fin n)) = n!.
  -- The remaining formal content is: (i) the classification map Φ and its
  -- codomain Finset, (ii) `Set.MapsTo`, (iii) constancy on fibers, and
  -- (iv) the injection above; then `Finset.sum_fiberwise_of_maps_to` +
  -- `fiber_value_bound` + `Finset.sum_le_sum_of_subset_of_nonneg` assemble it.
  --
  -- ======================================================================
  -- CORRECTION (verified this session, by hand and by `#eval`): the per-fibre
  -- plan described above is UNSOUND, because the integer fibre bound it needs,
  --     (#Φ⁻¹ e) * (k! * ∏_j m_j!) ≤ n!,
  -- is FALSE.  Counterexample: a single self-incompatible polymer `g` (so the
  -- incompatibility graph on any cluster is complete), weight `w`, and
  -- `K ≥ 5`.  Take the size-7 cluster `[g,…,g]` (n = 7) and the atom
  --     e = (k = 2, φ = (g,g), q = ([g,g,g],[g,g,g]), fixed child trees).
  -- The fibre `Φ⁻¹ e` consists of the spanning trees whose canonical root has
  -- two children with size-3 components of the prescribed induced-tree shape;
  -- there are exactly `#Φ⁻¹ e = 90` of them
  --   (10 unordered 3|3 partitions of the 6 non-root slots × 3 root-connection
  --    choices per block), and
  --     90 * (2! * (3!)^2) = 90 * (2 * 36) = 6480 > 5040 = 7! .
  -- Equivalently the fibre summand sum `90 * |w|^7 / 7! = |w|^7 / 56` EXCEEDS
  -- the matching RHS atom value `|w|/2! * (|w|^3/3!)^2 = |w|^7 / 72`, so
  -- `fiber_value_bound` is simply not applicable here (its hypothesis fails).
  -- More strongly, even after summing over an entire `(k, child-size)` class the
  -- LHS can beat the RHS: for this system the `k = 2, sizes (3,3)` class gives
  -- LHS piece `9/56 · |w|^7 ≈ 0.161·|w|^7` versus RHS piece `1/8 · |w|^7 =
  -- 0.125·|w|^7`.  The full inequality nevertheless holds because it is GLOBAL:
  -- the total `|w|^7` coefficient is `2401/720 ≈ 3.34` on the left and `≈ 4.07`
  -- on the right, the surplus of the `(3,3)` class being absorbed by deficits
  -- of other `(k, sizes)` classes.  Hence `pairSum_le_expBound` is the
  -- truncated labelled-rooted-tree exponential-formula inequality and CANNOT be
  -- discharged fibre-by-fibre (nor pair-by-pair); a genuinely global argument
  -- (the tree-function / EGF composition bound `T - T^2/2 ≤ x·exp T`, or an
  -- induction on cluster size using the exponential formula for the unordered
  -- multiset of root subtrees) is required.  The RHS forest expansion
  -- `rhs_forest_expand2` proved above is a correct first step of such a global
  -- proof; the per-fibre helpers `fiber_value_bound`,
  -- `fiber_card_mul_le_factorial`, `perPair_absWeight_bound` are, by the
  -- counterexample above, insufficient on their own.
  -- ======================================================================
  sorry

open Classical in
/-- The labeled rooted-tree exponential inequality (crux of Q6), reduced to its
pairs form `pairSum_le_expBound` via `treeTerm_eq_tree_sum`: expanding the
spanning-tree count exposes the spanning tree `T`, which is the object the
canonical-root deletion acts on.  The residual combinatorial content is
carried entirely by `pairSum_le_expBound`. -/
lemma touchOnlySum_le_expBound (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    (∑ p : (Σ m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S ⟨p.1.val, p.2⟩ g
          then treeTerm S hdec ⟨p.1.val, p.2⟩ else 0))
      <= |S.weight g| *
          ∑ k ∈ Finset.range (K + 3),
            (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real) := by
  have hrw : (∑ p : (Σ m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S ⟨p.1.val, p.2⟩ g
          then treeTerm S hdec ⟨p.1.val, p.2⟩ else 0))
      = (∑ p : (Σ m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S ⟨p.1.val, p.2⟩ g
          then ∑ _T ∈ (Finset.univ.filter
              (fun T : SimpleGraph (Fin (⟨p.1.val, p.2⟩ : Cluster S).n) =>
                T ≤ (⟨p.1.val, p.2⟩ : Cluster S).graph S hdec ∧ T.IsTree)),
              (⟨p.1.val, p.2⟩ : Cluster S).absWeight S
                / (Nat.factorial (⟨p.1.val, p.2⟩ : Cluster S).n : Real)
          else 0)) := by
    refine Finset.sum_congr rfl (fun p _ => ?_)
    rw [treeTerm_eq_tree_sum]
  rw [hrw]
  exact pairSum_le_expBound S hdec K g

/-- The labeled rooted-tree exponential inequality.  Combines the sound
connectedness-guard reformulation `boundedTouchSum_eq_touchOnly` with the
finite exponential-formula core `touchOnlySum_le_expBound`. -/
theorem boundedTouchSum_succ_le_finitePartial (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec (K + 1) g
      <= |S.weight g| *
          ∑ k ∈ Finset.range (K + 3),
            (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real) := by
  rw [boundedTouchSum_eq_touchOnly]
  exact touchOnlySum_le_expBound S hdec K g

/-- The labeled rooted-tree exponential inequality.  It follows from the
finite partial-sum bound `boundedTouchSum_succ_le_finitePartial` and the
standard fact `Real.sum_le_exp_of_nonneg` that every partial sum of the
exponential series of a nonnegative real is at most its exponential. -/
theorem boundedTouchSum_succ_le (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec (K + 1) g
      <= |S.weight g| *
          Real.exp (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) := by
  have hx : (0 : Real) <= ∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h :=
    Finset.sum_nonneg (fun h _ => boundedTouchSum_nonneg S hdec K h)
  refine le_trans (boundedTouchSum_succ_le_finitePartial S hdec K g) ?_
  refine mul_le_mul_of_nonneg_left ?_ (abs_nonneg _)
  exact Real.sum_le_exp_of_nonneg hx (K + 3)

/-- The exponential recursion bound: `boundedTouchSum` at depth `K` is bounded
by the depth-`K` truncation `kpPsi`.  This is proved by induction on `K` from
the base case and `boundedTouchSum_succ_le`. -/
theorem boundedTouchSum_le_kpPsi (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec K g <= kpPsi S hdec K g := by
  induction K generalizing g with
  | zero =>
      have h := boundedTouchSum_zero_le S hdec g
      simpa [kpPsi] using h
  | succ K ih =>
      have hstep := boundedTouchSum_succ_le S hdec K g
      have hmono : (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h)
          <= ∑ h ∈ nbhd S hdec g, kpPsi S hdec K h :=
        Finset.sum_le_sum (fun h _ => ih h)
      calc
        boundedTouchSum S hdec (K + 1) g
            <= |S.weight g| *
                Real.exp (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) :=
              hstep
        _ <= |S.weight g| *
                Real.exp (∑ h ∈ nbhd S hdec g, kpPsi S hdec K h) :=
              mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hmono) (abs_nonneg _)
        _ = kpPsi S hdec (K + 1) g := rfl

/-- The genuine KP rooted tree-sum estimate, now isolated as the remaining
combinatorial crux.

For every finite family `s` of connected clusters touching `g0`, the sum of
normalized spanning-tree weights is bounded by `|weight g0| * exp (energy g0)`.
Aristotle project `9eb41a7c` proved `kp_partial_sum_bound` modulo exactly this
lemma and identified the missing work as a labeled rooted-tree exponential
formula, comparable in size to the already-integrated Penrose tree-graph
inequality. -/
theorem kp_tree_sum_bound
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hKP : KPCondition S hdec) (g0 : Gamma)
    (s : Finset {X : Cluster S // X.Connected S hdec /\ X.Touches S g0}) :
    (s.sum (fun X => (spanningTreeCount S hdec X.1 : Real)
        / (Nat.factorial X.1.n : Real) * X.1.absWeight S))
      <= |S.weight g0| * Real.exp (S.energy g0) := by
  set N := s.sup (fun X => X.1.n) with hN
  have hA : s.sum (fun X => treeTerm S hdec X.1)
      <= boundedTouchSum S hdec N g0 := sum_le_boundedTouchSum S hdec g0 s
  have hB : boundedTouchSum S hdec N g0 <= kpPsi S hdec N g0 :=
    boundedTouchSum_le_kpPsi S hdec N g0
  have hC : kpPsi S hdec N g0 <= |S.weight g0| * Real.exp (S.energy g0) :=
    kpPsi_le_exp S hdec hKP N g0
  have hgoal : s.sum (fun X => (spanningTreeCount S hdec X.1 : Real)
        / (Nat.factorial X.1.n : Real) * X.1.absWeight S)
      = s.sum (fun X => treeTerm S hdec X.1) := rfl
  rw [hgoal]
  exact le_trans hA (le_trans hB hC)

/-- The uniform Kotecky-Preiss partial-sum bound (crux of C1).

For every finite family `s` of connected clusters touching `g0`, the total
absolute cluster weight is bounded by `|weight g0| * exp (energy g0)`.

Aristotle project `071d1370` reduced C1 to this genuine KP estimate, and
project `9eb41a7c` reduced this theorem to the named combinatorial crux
`kp_tree_sum_bound` above. -/
theorem kp_partial_sum_bound
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma)
    (s : Finset {X : Cluster S // X.Connected S hdec /\ X.Touches S g0}) :
    (s.sum (fun X => |D.coeff X.1| * X.1.absWeight S))
      <= |S.weight g0| * Real.exp (S.energy g0) := by
  calc
    s.sum (fun X => |D.coeff X.1| * X.1.absWeight S)
        <= s.sum (fun X => (spanningTreeCount S hdec X.1 : Real)
              / (Nat.factorial X.1.n : Real) * X.1.absWeight S) :=
          Finset.sum_le_sum
            (fun X _ => coeff_absWeight_le_treeTerm S hdec D X.1)
    _ <= |S.weight g0| * Real.exp (S.energy g0) :=
          kp_tree_sum_bound S hdec hKP g0 s

/-- Bare-KP absolute summability of clusters touching a fixed polymer.

This is the C1 conclusion from the strategy report: no metric or distance tail
appears here.  Aristotle project `071d1370` proved the reduction from the
uniform finite partial-sum bound `kp_partial_sum_bound`. -/
theorem kp_cluster_summable
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    Summable (fun X : {X : Cluster S //
        X.Connected S hdec /\ X.Touches S g0} =>
      |D.coeff X.1| * X.1.absWeight S) :=
  summable_of_sum_le
    (fun X => clusterCoeff_absWeight_nonneg S hdec D X.1)
    (kp_partial_sum_bound S hdec D hKP g0)

/-!
## Blocker: the old bare C2 target was false

Aristotle project `071d1370` found and formalized the missing hypothesis.  The
bare `KPCondition` controls the weighted sum over polymers incompatible with a
base polymer `g`; it does not control the single-polymer weight `|weight g|`
unless `g` is incompatible with itself.  Therefore the old C2 statement
without self-incompatibility was false, not merely hard.
-/

/-- One-point counterexample system: a single polymer incompatible with
nothing, with unit weight and zero energy. -/
def cexSystem : PolymerSystem (Fin 1) where
  incompatible := fun _ _ => False
  incompatible_symm := by intro g h h'; exact h'.elim
  weight := fun _ => 1
  energy := fun _ => 0
  energy_nonneg := by intro g; exact le_refl 0

/-- Decidability of `cexSystem` incompatibility (always false). -/
def cexDec : forall g h, Decidable (cexSystem.incompatible g h) :=
  fun _ _ => isFalse (fun h => h)

/-- The incompatibility graph of any `cexSystem` cluster is the empty graph. -/
theorem cexSystem_graph_bot (X : Cluster cexSystem) :
    X.graph cexSystem cexDec = (⊥ : SimpleGraph (Fin X.n)) := by
  ext i j
  simp [Cluster.graph, cexSystem]

/-- A `cexSystem` cluster is connected iff it has exactly one slot. -/
theorem cexSystem_connected_iff (X : Cluster cexSystem) :
    X.Connected cexSystem cexDec <-> X.n = 1 := by
  unfold Cluster.Connected
  rw [cexSystem_graph_bot, SimpleGraph.connected_bot_iff]
  constructor
  · rintro ⟨hss, hne⟩
    have h1 : 0 < X.n := Fin.pos_iff_nonempty.mpr hne
    have h2 : X.n <= 1 := by
      by_contra h
      push_neg at h
      have hne2 : (⟨0, by omega⟩ : Fin X.n) ≠ (⟨1, by omega⟩ : Fin X.n) := by
        simp [Fin.ext_iff]
      exact hne2 (Subsingleton.elim _ _)
    omega
  · intro hn
    have h1 : Nonempty (Fin X.n) := by
      rw [hn]
      exact inferInstance
    have h2 : Subsingleton (Fin X.n) := by
      rw [hn]
      exact inferInstance
    exact ⟨h2, h1⟩

/-- Two one-slot `cexSystem` clusters are equal (the polymer map is forced). -/
theorem cexSystem_cluster_eq (X Y : Cluster cexSystem)
    (hX : X.n = 1) (hY : Y.n = 1) : X = Y := by
  obtain ⟨nX, pX⟩ := X
  obtain ⟨nY, pY⟩ := Y
  simp only at hX hY
  subst hX
  subst hY
  congr 1
  funext i
  exact Subsingleton.elim _ _

/-- The connected clusters of `cexSystem` touching `g0` form a subsingleton. -/
instance :
    Subsingleton {X : Cluster cexSystem //
      X.Connected cexSystem cexDec /\ X.Touches cexSystem 0} := by
  constructor
  rintro ⟨X, hX, _⟩ ⟨Y, hY, _⟩
  exact Subtype.ext (cexSystem_cluster_eq X Y
    ((cexSystem_connected_iff X).mp hX) ((cexSystem_connected_iff Y).mp hY))

/-- Maximal coefficient data on `cexSystem`: coefficient `1` on one-slot
clusters, `0` elsewhere.  This saturates the tree-graph bound on the
single-vertex cluster. -/
def cexCoeff : ClusterCoeffData cexSystem cexDec where
  coeff := fun X => if X.n = 1 then (1 : Real) else 0
  coeff_disconnected := by
    intro X hX
    have : X.n ≠ 1 := fun h => hX ((cexSystem_connected_iff X).mpr h)
    simp [this]
  treeGraphBound := by
    intro X
    by_cases h : X.n = 1
    · have hconn : X.Connected cexSystem cexDec :=
        (cexSystem_connected_iff X).mpr h
      have hpos : 0 < spanningTreeCount cexSystem cexDec X :=
        spanningTreeCount_pos_of_connected cexSystem cexDec X hconn
      rw [if_pos h, h]
      simp only [Nat.factorial_one, Nat.cast_one, abs_one, mul_one]
      exact_mod_cast hpos
    · simp only [if_neg h, abs_zero, zero_mul]
      exact Nat.cast_nonneg _

/-- `cexSystem` satisfies the bare Kotecky-Preiss condition vacuously: no
polymer is incompatible with anything. -/
theorem cexSystem_KP : KPCondition cexSystem cexDec := by
  intro g
  have hempty :
      (Finset.univ.filter
        (fun h => @Decidable.decide _ (cexDec g h) = true)) = (∅ : Finset (Fin 1)) := by
    apply Finset.filter_false_of_mem
    intro h _
    simp [cexSystem]
  rw [hempty]
  simp [cexSystem]

/-- The unique connected cluster touching `g0 = 0`: one slot holding `0`. -/
def cexWitness :
    {X : Cluster cexSystem // X.Connected cexSystem cexDec /\ X.Touches cexSystem 0} :=
  ⟨⟨1, fun _ => 0⟩, (cexSystem_connected_iff _).mpr rfl, ⟨0, rfl⟩⟩

/-- The witness cluster contributes exactly `1` to the old C2 sum. -/
theorem cexWitness_term :
    |cexCoeff.coeff cexWitness.1| * cexWitness.1.absWeight cexSystem
        * Real.exp (cexWitness.1.energyOf cexSystem) = 1 := by
  simp [cexWitness, cexCoeff, Cluster.absWeight, Cluster.energyOf, cexSystem]

/-- The old bare C2 statement is false without self-incompatibility. -/
theorem kp_convergence_bound_false :
    ¬ (∀ (G : Type) [Fintype G] (S : PolymerSystem G)
        (hdec : forall g h, Decidable (S.incompatible g h))
        (D : ClusterCoeffData S hdec)
        (_hKP : KPCondition S hdec) (g0 : G),
        (tsum (fun X : {X : Cluster S //
            X.Connected S hdec /\ X.Touches S g0} =>
          |D.coeff X.1| * X.1.absWeight S * Real.exp (X.1.energyOf S)))
            <= S.energy g0) := by
  intro H
  have hle := H (Fin 1) cexSystem cexDec cexCoeff cexSystem_KP 0
  have henergy : cexSystem.energy 0 = 0 := rfl
  rw [henergy] at hle
  have hsummable :
      Summable (fun X : {X : Cluster cexSystem //
          X.Connected cexSystem cexDec /\ X.Touches cexSystem 0} =>
        |cexCoeff.coeff X.1| * X.1.absWeight cexSystem
          * Real.exp (X.1.energyOf cexSystem)) :=
    Summable.of_finite
  have hnn : ∀ X : {X : Cluster cexSystem //
      X.Connected cexSystem cexDec /\ X.Touches cexSystem 0},
      0 <= |cexCoeff.coeff X.1| * X.1.absWeight cexSystem
        * Real.exp (X.1.energyOf cexSystem) :=
    fun X => clusterCoeff_absWeight_exp_nonneg cexSystem cexDec cexCoeff X.1
  have hterm := hsummable.le_tsum cexWitness (fun j _ => hnn j)
  rw [cexWitness_term] at hterm
  linarith

/-- **This statement is FALSE**, even with self-incompatibility.

The `exp(energyOf)`-weighted ("amplified") cluster sum is NOT controlled by
`S.energy g0` under the bare `KPCondition`, and adding `hself` does not rescue
it.  Self-incompatibility does make the `h = g` diagonal term enter the KP sum
(so the single-polymer weight `|w g0| exp(energy g0) ≤ energy g0` is controlled),
but it simultaneously makes *every repeated-slot cluster* `Kₙ` connected, and
those higher clusters add positive amplified mass that exceeds the budget.

A fully verified refutation is given below by
`SelfIncompatCex.selfIncompat_convergence_bound_false`: a single-polymer system
with `incompatible = True`, `weight = 3 e^{-3}`, `energy = 3` (so KP holds with
equality) and coefficient data `1/2` on the two-slot cluster already yields an
amplified contribution `|1/2| · (3e^{-3})² · e^{6} = 9/2 > 3 = energy`.

The *provable* Kotecky-Preiss convergence bound is the un-amplified
(plain-weight) sum; see `kp_convergence_bound_of_selfIncompatible_plain` below.

The original amplified statement is preserved verbatim (its `s o r r y` cannot be
honestly discharged because the statement is false), because it is consumed by
`StrongCouplingPolymerMap.plaquetteKP_convergence_bound_of_plaquetteKPBound`,
which must be revised in tandem. -/
theorem kp_convergence_bound_of_selfIncompatible
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hself : forall g, S.incompatible g g)
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    (tsum (fun X : {X : Cluster S //
        X.Connected S hdec /\ X.Touches S g0} =>
      |D.coeff X.1| * X.1.absWeight S * Real.exp (X.1.energyOf S)))
        <= S.energy g0 := by
  -- FALSE as stated: refuted by `SelfIncompatCex.selfIncompat_convergence_bound_false`.
  sorry

/-
The genuine Kotecky-Preiss convergence bound recovered from
self-incompatibility: the **plain** (un-amplified) absolute cluster sum over
clusters touching `g0` is bounded by `S.energy g0`.

This is the correct replacement for the false amplified statement
`kp_convergence_bound_of_selfIncompatible`: the `exp(energyOf)` weight is
dropped.  With `hself`, the diagonal `h = g0` term of `KPCondition` gives
`|weight g0| · exp(energy g0) ≤ energy g0`, and the partial-sum machinery
(`kp_partial_sum_bound`) bounds every finite subsum by
`|weight g0| · exp(energy g0)`; `tsum_le_of_sum_le'` then closes the tsum.
-/
theorem kp_convergence_bound_of_selfIncompatible_plain
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hself : forall g, S.incompatible g g)
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    (tsum (fun X : {X : Cluster S //
        X.Connected S hdec /\ X.Touches S g0} =>
      |D.coeff X.1| * X.1.absWeight S))
        <= S.energy g0 := by
  apply_rules [ tsum_le_of_sum_le' ];
  · exact S.energy_nonneg g0;
  · intro s
    apply le_trans (kp_partial_sum_bound S hdec D hKP g0 s) (by
    have := hKP g0;
    exact le_trans ( Finset.single_le_sum ( fun x _ => mul_nonneg ( abs_nonneg ( S.weight x ) ) ( Real.exp_nonneg ( S.energy x ) ) ) ( Finset.mem_filter.mpr ⟨ Finset.mem_univ _, by simpa using hself g0 ⟩ ) ) this)

/-- Metric enhancement of a finite polymer system, used only for distance
tail statements. -/
structure MetricPolymerSystem (Gamma : Type*) [Fintype Gamma]
    extends PolymerSystem Gamma where
  dist : Gamma -> Gamma -> Real
  dist_nonneg : forall g h, 0 <= dist g h
  dist_comm : forall g h, dist g h = dist h g
  dist_triangle : forall g h k, dist g k <= dist g h + dist h k

namespace Cluster

/-- A cluster touches `g0` and reaches distance at least `R` from it. -/
def ReachesFrom (M : MetricPolymerSystem Gamma)
    (X : Cluster M.toPolymerSystem) (g0 : Gamma) (R : Real) : Prop :=
  X.Touches M.toPolymerSystem g0 /\
    exists i : Fin X.n, R <= M.dist g0 (X.poly i)

end Cluster

/-- **This statement is FALSE**, even with self-incompatibility and the exact
coercivity hypothesis `hcoerce`.

The intended proof extracts the decay factor `exp(-(m R))` by dominating each
plain summand by its `exp(energyOf)`-amplified version and then invoking the
amplified convergence bound `kp_convergence_bound_of_selfIncompatible`.  But
that amplified bound is itself false (see the docstring there and
`SelfIncompatCex.selfIncompat_convergence_bound_false`), so the decay cannot be
obtained under the bare `KPCondition`.

A fully verified refutation is given below by `TailCex.tail_bound_false`: a
metric single-polymer system with `incompatible = True`, `weight = e^{-1}`,
`energy = 1`, unit distance, `m = R = 1`, and coefficient data `1` / `1/2` on
the one- and two-slot clusters.  All hypotheses (KP with equality, `hself`,
`hcoerce`) hold, yet the plain reaching-cluster sum is
`e^{-1} + (1/2) e^{-2} > e^{-1} = energy · exp(-(m R))`.

A true metric tail bound requires a strictly stronger hypothesis (extra
exponential room in `KPCondition`, e.g. bounding `∑ |w| e^{energy + m·dist}`),
not merely the coercivity bridge `hcoerce`.  The statement is preserved verbatim
(its `s o r r y` cannot be honestly discharged because it is false).

The hypothesis `hcoerce` is the named bridge from cluster energy to spatial
diameter/distance.  It is exactly the extra Q6/Q8 geometry layer flagged by the
day-1 strategy audit; it is not hidden inside `KPCondition`. -/
theorem kp_tail_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (hself : forall g, M.incompatible g g)
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (hKP : KPCondition M.toPolymerSystem hdec)
    (m : Real) (hm : 0 < m)
    (hcoerce : forall (X : Cluster M.toPolymerSystem),
        X.Connected M.toPolymerSystem hdec ->
        forall g0 : Gamma, X.Touches M.toPolymerSystem g0 ->
        forall i : Fin X.n, m * M.dist g0 (X.poly i)
          <= X.energyOf M.toPolymerSystem)
    (g0 : Gamma) (R : Real) (hR : 0 <= R) :
    (tsum (fun X : {X : Cluster M.toPolymerSystem //
        X.Connected M.toPolymerSystem hdec /\ X.ReachesFrom M g0 R} =>
      |D.coeff X.1| * X.1.absWeight M.toPolymerSystem))
        <= M.energy g0 * Real.exp (-(m * R)) := by
  -- FALSE as stated: refuted by `TailCex.tail_bound_false`.
  sorry

/-! ## Verified refutations of the two amplified Q6 conclusions

The two theorems above (`kp_convergence_bound_of_selfIncompatible` and
`kp_tail_bound`) are FALSE as stated, even with self-incompatibility.  The
namespaces below give fully verified (`s o r r y`-free) counterexamples. -/

namespace SelfIncompatCex

/-- Single-polymer system with self-incompatibility. -/
noncomputable def sys : PolymerSystem (Fin 1) where
  incompatible := fun _ _ => True
  incompatible_symm := by intro g h _; trivial
  weight := fun _ => 3 * Real.exp (-3)
  energy := fun _ => 3
  energy_nonneg := by intro g; positivity

def dec : forall g h, Decidable (sys.incompatible g h) :=
  fun _ _ => isTrue trivial

theorem sys_self : forall g, sys.incompatible g g := fun _ => trivial

/-- The incompatibility graph of any `sys` cluster is the complete graph:
distinct slots are always adjacent. -/
theorem sys_graph_adj (X : Cluster sys) (i j : Fin X.n) :
    (X.graph sys dec).Adj i j <-> i ≠ j := by
  simp [Cluster.graph, sys]

/-- Every `sys` cluster with at least one slot is connected (complete graph). -/
theorem sys_connected (X : Cluster sys) (h : 0 < X.n) :
    X.Connected sys dec := by
  obtain ⟨ i, hi ⟩ := X
  convert (SimpleGraph.connected_top)
  rotate_left
  exact Fin i
  · exact ⟨ ⟨ 0, h ⟩ ⟩
  · unfold Cluster.Connected
    congr! 2
    ext; simp [Cluster.graph, sys]

/-- Two `sys` clusters with the same slot count are equal (polymer map forced
into `Fin 1`). -/
theorem sys_cluster_eq (X Y : Cluster sys) (h : X.n = Y.n) : X = Y := by
  obtain ⟨nX, pX⟩ := X
  obtain ⟨nY, pY⟩ := Y
  simp only at h
  subst h
  congr 1
  funext i
  exact Subsingleton.elim _ _

/-- Coefficient data concentrated on two-slot clusters (saturating the
tree-graph bound there). -/
noncomputable def coeffData : ClusterCoeffData sys dec where
  coeff := fun X => if X.n = 2 then (1 / 2 : Real) else 0
  coeff_disconnected := by
    intro X hX
    have hn : X.n ≠ 2 := by
      intro h
      exact hX (sys_connected X (by omega))
    simp [hn]
  treeGraphBound := by
    intro X
    by_cases h : X.n = 2
    · have hconn : X.Connected sys dec := sys_connected X (by omega)
      have hpos : 0 < spanningTreeCount sys dec X :=
        spanningTreeCount_pos_of_connected sys dec X hconn
      rw [if_pos h, h]
      simp only [Nat.factorial_two, Nat.cast_ofNat]
      have : (1 : Real) <= (spanningTreeCount sys dec X : Real) := by
        exact_mod_cast hpos
      rw [abs_of_nonneg (by norm_num)]
      linarith
    · simp only [if_neg h, abs_zero, zero_mul]
      exact Nat.cast_nonneg _

theorem sys_KP : KPCondition sys dec := by
  intro g
  have hfilter :
      (Finset.univ.filter
        (fun h => @Decidable.decide _ (dec g h) = true)) = (Finset.univ : Finset (Fin 1)) := by
    apply Finset.filter_true_of_mem
    intro h _
    simp [sys]
  rw [hfilter]
  simp only [Finset.univ_unique, Finset.sum_singleton]
  show |sys.weight g| * Real.exp (sys.energy g) <= sys.energy g
  simp only [sys]
  rw [abs_of_nonneg (by positivity), mul_assoc, ← Real.exp_add]
  norm_num

/-- The two-slot witness cluster touching `0`. -/
def witness :
    {X : Cluster sys // X.Connected sys dec /\ X.Touches sys 0} :=
  ⟨⟨2, fun _ => 0⟩, sys_connected _ (by norm_num), ⟨0, rfl⟩⟩

/-- The witness contributes exactly `9/2` to the amplified sum. -/
theorem witness_term :
    |coeffData.coeff witness.1| * witness.1.absWeight sys
        * Real.exp (witness.1.energyOf sys) = 9 / 2 := by
  unfold witness coeffData Cluster.absWeight Cluster.energyOf sys
  norm_num [Fin.prod_univ_succ, Fin.sum_univ_succ]; ring; norm_num [Real.exp_neg, Real.exp_ne_zero]
  rw [← Real.exp_nat_mul, ← Real.exp_neg, ← Real.exp_add]; norm_num

/-- The amplified family has support in the single witness. -/
theorem summand_zero_of_ne (X : {X : Cluster sys // X.Connected sys dec /\ X.Touches sys 0})
    (hX : X ≠ witness) :
    |coeffData.coeff X.1| * X.1.absWeight sys * Real.exp (X.1.energyOf sys) = 0 := by
  have h_coeff_zero : coeffData.coeff X.1 = 0 := by
    by_cases h : X.val.n = 2 <;> simp_all +decide [coeffData]
    exact hX <| Subtype.ext <| sys_cluster_eq _ _ <| by aesop
  aesop

/-- The `_of_selfIncompatible` amplified KP convergence bound is FALSE: adding
`hself` does not rescue it.  This refutes the general principle over all
systems, and in particular the specific instance
`kp_convergence_bound_of_selfIncompatible`. -/
theorem selfIncompat_convergence_bound_false :
    ¬ (∀ (G : Type) [Fintype G] (S : PolymerSystem G)
        (hdec : forall g h, Decidable (S.incompatible g h))
        (_hself : forall g, S.incompatible g g)
        (D : ClusterCoeffData S hdec)
        (_hKP : KPCondition S hdec) (g0 : G),
        (tsum (fun X : {X : Cluster S //
            X.Connected S hdec /\ X.Touches S g0} =>
          |D.coeff X.1| * X.1.absWeight S * Real.exp (X.1.energyOf S)))
            <= S.energy g0) := by
  intro H
  have hle := H (Fin 1) sys dec sys_self coeffData sys_KP 0
  have hnn : ∀ X : {X : Cluster sys // X.Connected sys dec /\ X.Touches sys 0},
      0 <= |coeffData.coeff X.1| * X.1.absWeight sys * Real.exp (X.1.energyOf sys) :=
    fun X => clusterCoeff_absWeight_exp_nonneg sys dec coeffData X.1
  have hsummable :
      Summable (fun X : {X : Cluster sys // X.Connected sys dec /\ X.Touches sys 0} =>
        |coeffData.coeff X.1| * X.1.absWeight sys * Real.exp (X.1.energyOf sys)) := by
    apply summable_of_ne_finset_zero (s := {witness})
    intro X hX
    exact summand_zero_of_ne X (by simpa using hX)
  have hterm := hsummable.le_tsum witness (fun j _ => hnn j)
  rw [witness_term] at hterm
  have hE : sys.energy 0 = 3 := rfl
  rw [hE] at hle
  linarith

end SelfIncompatCex

namespace TailCex

/-- Metric single-polymer system with self-incompatibility, `energy = 1`,
`weight = e^{-1}` (so KP holds with equality), unit distance. -/
noncomputable def msys : MetricPolymerSystem (Fin 1) where
  incompatible := fun _ _ => True
  incompatible_symm := by intro g h _; trivial
  weight := fun _ => Real.exp (-1)
  energy := fun _ => 1
  energy_nonneg := by intro g; norm_num
  dist := fun _ _ => 1
  dist_nonneg := by intro g h; norm_num
  dist_comm := by intro g h; rfl
  dist_triangle := by intro g h k; norm_num

def dec : forall g h, Decidable (msys.toPolymerSystem.incompatible g h) :=
  fun _ _ => isTrue trivial

theorem msys_self : forall g, msys.toPolymerSystem.incompatible g g := fun _ => trivial

theorem msys_graph_adj (X : Cluster msys.toPolymerSystem) (i j : Fin X.n) :
    (X.graph msys.toPolymerSystem dec).Adj i j <-> i ≠ j := by
  simp [Cluster.graph, msys]

theorem msys_connected (X : Cluster msys.toPolymerSystem) (h : 0 < X.n) :
    X.Connected msys.toPolymerSystem dec := by
  obtain ⟨ i, hi ⟩ := X
  convert (SimpleGraph.connected_top)
  rotate_left
  exact Fin i
  · exact ⟨ ⟨ 0, h ⟩ ⟩
  · unfold Cluster.Connected
    congr! 2
    ext; simp [Cluster.graph, msys]

theorem msys_cluster_eq (X Y : Cluster msys.toPolymerSystem) (h : X.n = Y.n) : X = Y := by
  obtain ⟨nX, pX⟩ := X
  obtain ⟨nY, pY⟩ := Y
  simp only at h
  subst h
  congr 1
  funext i
  exact Subsingleton.elim _ _

/-- Coefficient data concentrated on one- and two-slot clusters. -/
noncomputable def coeffData2 : ClusterCoeffData msys.toPolymerSystem dec where
  coeff := fun X => if X.n = 1 then (1 : Real) else if X.n = 2 then (1 / 2 : Real) else 0
  coeff_disconnected := by
    intro X hX
    have hn1 : X.n ≠ 1 := fun h => hX (msys_connected X (by omega))
    have hn2 : X.n ≠ 2 := fun h => hX (msys_connected X (by omega))
    simp [hn1, hn2]
  treeGraphBound := by
    intro X
    by_cases h1 : X.n = 1
    · have hconn : X.Connected msys.toPolymerSystem dec := msys_connected X (by omega)
      have hpos : 0 < spanningTreeCount msys.toPolymerSystem dec X :=
        spanningTreeCount_pos_of_connected msys.toPolymerSystem dec X hconn
      rw [if_pos h1, h1]
      simp only [Nat.factorial_one, Nat.cast_one, abs_one, mul_one]
      exact_mod_cast hpos
    · by_cases h2 : X.n = 2
      · have hconn : X.Connected msys.toPolymerSystem dec := msys_connected X (by omega)
        have hpos : 0 < spanningTreeCount msys.toPolymerSystem dec X :=
          spanningTreeCount_pos_of_connected msys.toPolymerSystem dec X hconn
        rw [if_neg h1, if_pos h2, h2]
        simp only [Nat.factorial_two, Nat.cast_ofNat]
        rw [abs_of_nonneg (by norm_num)]
        have : (1 : Real) <= (spanningTreeCount msys.toPolymerSystem dec X : Real) := by
          exact_mod_cast hpos
        linarith
      · simp only [if_neg h1, if_neg h2, abs_zero, zero_mul]
        exact Nat.cast_nonneg _

theorem msys_KP : KPCondition msys.toPolymerSystem dec := by
  intro g
  have hfilter :
      (Finset.univ.filter
        (fun h => @Decidable.decide _ (dec g h) = true)) = (Finset.univ : Finset (Fin 1)) := by
    apply Finset.filter_true_of_mem
    intro h _
    simp [msys]
  rw [hfilter]
  simp only [Finset.univ_unique, Finset.sum_singleton]
  show |msys.toPolymerSystem.weight g| * Real.exp (msys.toPolymerSystem.energy g)
      <= msys.toPolymerSystem.energy g
  simp only [msys]
  rw [abs_of_nonneg (by positivity), ← Real.exp_add]
  norm_num

theorem msys_coerce (X : Cluster msys.toPolymerSystem)
    (_hX : X.Connected msys.toPolymerSystem dec)
    (g0 : Fin 1) (_hT : X.Touches msys.toPolymerSystem g0) (i : Fin X.n) :
    (1 : Real) * msys.dist g0 (X.poly i) <= X.energyOf msys.toPolymerSystem := by
  simp [Cluster.energyOf, msys]
  exact Fin.pos i

/-- One-slot witness (reaches distance 1). -/
def w1 :
    {X : Cluster msys.toPolymerSystem // X.Connected msys.toPolymerSystem dec /\ X.ReachesFrom msys 0 1} :=
  ⟨⟨1, fun _ => 0⟩, msys_connected _ (by norm_num), ⟨0, rfl⟩, ⟨0, by norm_num [msys]⟩⟩

/-- Two-slot witness (reaches distance 1). -/
def w2 :
    {X : Cluster msys.toPolymerSystem // X.Connected msys.toPolymerSystem dec /\ X.ReachesFrom msys 0 1} :=
  ⟨⟨2, fun _ => 0⟩, msys_connected _ (by norm_num), ⟨0, rfl⟩, ⟨0, by norm_num [msys]⟩⟩

theorem w1_ne_w2 : w1 ≠ w2 := by
  intro h
  have : (w1.1).n = (w2.1).n := by rw [h]
  simp [w1, w2] at this

theorem w1_term :
    |coeffData2.coeff w1.1| * w1.1.absWeight msys.toPolymerSystem = Real.exp (-1) := by
  unfold w1; norm_num [coeffData2, Cluster.absWeight, msys]

theorem w2_term :
    |coeffData2.coeff w2.1| * w2.1.absWeight msys.toPolymerSystem = (1 / 2) * Real.exp (-2) := by
  unfold w2; norm_num [coeffData2, Cluster.absWeight, msys]; ring
  norm_num [← Real.exp_nat_mul]

/-- The plain family (no amplification) has support in `{w1, w2}`. -/
theorem tail_summand_zero_of_ne
    (X : {X : Cluster msys.toPolymerSystem // X.Connected msys.toPolymerSystem dec /\ X.ReachesFrom msys 0 1})
    (h1 : X ≠ w1) (h2 : X ≠ w2) :
    |coeffData2.coeff X.1| * X.1.absWeight msys.toPolymerSystem = 0 := by
  by_cases h : X.val.n = 1 <;> by_cases h' : X.val.n = 2 <;> simp_all +decide [Cluster.absWeight, msys]
  · exact False.elim <| h1 <| Subtype.ext <| msys_cluster_eq _ _ <| by aesop
  · exact False.elim <| h2 <| Subtype.ext <| msys_cluster_eq _ _ <| by aesop
  · unfold coeffData2; aesop

/-- The metric tail bound `kp_tail_bound` is FALSE: with self-incompatibility
and the exact coercivity hypothesis, the plain reaching-cluster sum still
exceeds `energy · exp(-(m R))`.  The decay factor cannot be extracted because
the amplified convergence bound it relies on is itself false (see
`SelfIncompatCex.selfIncompat_convergence_bound_false`). -/
theorem tail_bound_false :
    ¬ (∀ (G : Type) [Fintype G] (M : MetricPolymerSystem G)
        (hdec : forall g h, Decidable (M.incompatible g h))
        (_hself : forall g, M.incompatible g g)
        (D : ClusterCoeffData M.toPolymerSystem hdec)
        (_hKP : KPCondition M.toPolymerSystem hdec)
        (m : Real) (_hm : 0 < m)
        (_hcoerce : forall (X : Cluster M.toPolymerSystem),
            X.Connected M.toPolymerSystem hdec ->
            forall g0 : G, X.Touches M.toPolymerSystem g0 ->
            forall i : Fin X.n, m * M.dist g0 (X.poly i)
              <= X.energyOf M.toPolymerSystem)
        (g0 : G) (R : Real) (_hR : 0 <= R),
        (tsum (fun X : {X : Cluster M.toPolymerSystem //
            X.Connected M.toPolymerSystem hdec /\ X.ReachesFrom M g0 R} =>
          |D.coeff X.1| * X.1.absWeight M.toPolymerSystem))
            <= M.energy g0 * Real.exp (-(m * R))) := by
  classical
  intro H
  have hle := H (Fin 1) msys dec msys_self coeffData2 msys_KP 1 (by norm_num)
    msys_coerce 0 1 (by norm_num)
  have hsupport : ∀ X : {X : Cluster msys.toPolymerSystem //
        X.Connected msys.toPolymerSystem dec /\ X.ReachesFrom msys 0 1},
      X ∉ ({w1, w2} : Finset {X : Cluster msys.toPolymerSystem //
        X.Connected msys.toPolymerSystem dec /\ X.ReachesFrom msys 0 1}) ->
      |coeffData2.coeff X.1| * X.1.absWeight msys.toPolymerSystem = 0 := by
    intro X hX
    rw [Finset.mem_insert, Finset.mem_singleton] at hX
    push_neg at hX
    exact tail_summand_zero_of_ne X hX.1 hX.2
  rw [tsum_eq_sum hsupport, Finset.sum_pair w1_ne_w2, w1_term, w2_term] at hle
  have hE : msys.energy 0 * Real.exp (-(1 * 1)) = Real.exp (-1) := by
    norm_num [msys]
  rw [hE] at hle
  have hpos := Real.exp_pos (-2)
  linarith

end TailCex

end PolymerKPConclusion
end GateYM
end NullEdge
end Draft
end PhysicsSM
