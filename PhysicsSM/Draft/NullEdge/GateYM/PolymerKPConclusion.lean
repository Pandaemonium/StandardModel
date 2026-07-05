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
is now reduced, with a kernel-checked lemma DAG, to a single remaining
combinatorial inequality `boundedTouchSum_succ_le` (the labeled rooted-tree
exponential-generating-function formula).  In detail: the enlargement step
`sum_le_boundedTouchSum`, the base case `boundedTouchSum_zero_le`, the depth
induction `boundedTouchSum_le_kpPsi`, and the analytic bound `kpPsi_le_exp`
are all proved; `boundedTouchSum_succ_le` is the sole documented handoff on
that branch.  The two further handoffs
`kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` are untouched.
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

/-- Connected clusters admit at least one spanning-tree subgraph. -/
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

/-- The labeled rooted-tree exponential inequality, now the single remaining
combinatorial crux of Q6.

This is the only unproved statement on which `kp_tree_sum_bound` and
`kp_partial_sum_bound` depend.  Rooting a connected cluster touching `g` at a
slot carrying `g` and deleting that root should partition the remaining slots
into rooted subtree blocks, each rooted at a polymer incompatible with `g`.
The ordered `1/n!` normalization must then reconcile with the `1/k!` from
unordered child blocks and the subtree normalizations, giving the exponential
recursion.  Proving this is a finite labeled rooted-tree exponential-formula
problem, not a KP-statement ambiguity. -/
theorem boundedTouchSum_succ_le (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec (K + 1) g
      <= |S.weight g| *
          Real.exp (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) := by
  sorry

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
