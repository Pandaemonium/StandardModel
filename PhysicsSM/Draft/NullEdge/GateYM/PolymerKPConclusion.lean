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
cluster, and `rhs_forest_expand`, which expands the RHS partial exponential
into ordered child tuples.  It also includes
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

/-- Corrected C2 target.  Adding the standard self-incompatibility hypothesis
restores the route to the Kotecky-Preiss convergence bound: the `h = g` term
then appears in the KP sum and controls the single-polymer weight. -/
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
  /-
  Proof handoff:
  Prove the corrected KP tree-sum theorem using `hself`, `hKP`, and
  `D.treeGraphBound`.  The one-point counterexample above shows why `hself`
  is mathematically necessary.
  -/
  sorry

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

/-- Metric tail bound separated from bare KP by an explicit coercivity
hypothesis.

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
  /-
  Proof handoff:
  Combine `kp_convergence_bound_of_selfIncompatible` with `hcoerce` on every
  cluster counted by `ReachesFrom`.  Keep the metric/coercivity argument here,
  not in the bare KP theorem.
  -/
  sorry

end PolymerKPConclusion
end GateYM
end NullEdge
end Draft
end PhysicsSM
