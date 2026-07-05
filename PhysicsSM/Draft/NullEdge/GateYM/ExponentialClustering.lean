import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion

/-!
# Gate YM4/Q8: exponential clustering statement bridge

This module freezes the first Q8 observable-level bridge above the Q6
finite-polymer tail interface.  It is deliberately conditional: the hard Q6
metric tail estimate is passed in as an explicit hypothesis, and the local
observable-to-cluster-expansion comparison is passed in as an explicit
hypothesis.  The theorem proved here is only the clean final step:

`tail contribution bound + observable cluster bridge => exponential clustering`.

Draft-trust: statement bridge only.  No volume-uniform KP theorem, no concrete
plaquette geometry, and no transfer-Hilbert statement is claimed here.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ExponentialClustering

open scoped BigOperators
open PolymerKPCriterion
open PolymerKPConclusion

variable {Gamma Obs : Type*} [Fintype Gamma]

/-- Abstract data for a pairwise connected-correlator statement.

`anchor` chooses the polymer from which the cluster tail is measured,
`separation` is the observable-level distance, and `prefactor` absorbs the
local observable norms and finite support constants. -/
structure LocalObservableData (Gamma Obs : Type*) where
  anchor : Obs -> Gamma
  separation : Obs -> Obs -> Real
  separation_nonneg : forall A B, 0 <= separation A B
  connectedCorr : Obs -> Obs -> Complex
  prefactor : Obs -> Obs -> Real
  prefactor_nonneg : forall A B, 0 <= prefactor A B

/-- The Q6 metric-tail contribution that Q8 consumes. -/
def tailContribution
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (R : Real) : Real :=
  tsum (fun X : {X : Cluster M.toPolymerSystem //
      X.Connected M.toPolymerSystem hdec /\ X.ReachesFrom M g0 R} =>
    |D.coeff X.1| * X.1.absWeight M.toPolymerSystem)

/-- Exponential clustering for the abstract connected correlator. -/
def HasExponentialClustering
    (L : LocalObservableData Gamma Obs)
    (amplitude : Obs -> Obs -> Real) (m : Real) : Prop :=
  forall A B : Obs,
    ‖L.connectedCorr A B‖ <=
      amplitude A B * Real.exp (-(m * L.separation A B))

omit [Fintype Gamma] in
/-- A single-anchor clustering bound may be weakened by enlarging the
amplitude. -/
theorem hasExponentialClustering_of_amplitude_le
    (L : LocalObservableData Gamma Obs)
    {amplitude amplitude' : Obs -> Obs -> Real} {m : Real}
    (hAmp : forall A B : Obs, amplitude A B <= amplitude' A B)
    (hClust : HasExponentialClustering L amplitude m) :
    HasExponentialClustering L amplitude' m := by
  intro A B
  exact (hClust A B).trans
    (mul_le_mul_of_nonneg_right (hAmp A B)
      (le_of_lt (Real.exp_pos _)))

omit [Fintype Gamma] in
/-- A single-anchor clustering bound at rate `m` also holds at any weaker
rate `m' <= m`, provided the amplitude is nonnegative. -/
theorem hasExponentialClustering_of_rate_le
    (L : LocalObservableData Gamma Obs)
    {amplitude : Obs -> Obs -> Real} {m m' : Real}
    (hAmpNonneg : forall A B : Obs, 0 <= amplitude A B)
    (hm : m' <= m)
    (hClust : HasExponentialClustering L amplitude m) :
    HasExponentialClustering L amplitude m' := by
  intro A B
  have hSep : 0 <= L.separation A B := L.separation_nonneg A B
  have hMul : m' * L.separation A B <= m * L.separation A B :=
    mul_le_mul_of_nonneg_right hm hSep
  have hExp :
      Real.exp (-(m * L.separation A B)) <=
        Real.exp (-(m' * L.separation A B)) := by
    exact Real.exp_le_exp.mpr (neg_le_neg hMul)
  exact (hClust A B).trans
    (mul_le_mul_of_nonneg_left hExp (hAmpNonneg A B))

/-- Observable-level exponential clustering from an explicit Q6-style tail
bound and an observable-to-cluster bridge.

This is the named Q8 bridge lemma.  The hard work is isolated in `hTail`
(the Q6 metric tail estimate, eventually supplied by `kp_tail_bound`) and
`hBridge` (the expansion/locality comparison for the chosen loop observables).
-/
theorem hasExponentialClustering_of_tailContribution_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableData Gamma Obs)
    (m : Real)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          tailContribution M hdec D (L.anchor A) (L.separation A B)) :
    HasExponentialClustering L
      (fun A B => L.prefactor A B * M.energy (L.anchor A)) m := by
  intro A B
  have htail := hTail (L.anchor A) (L.separation A B)
    (L.separation_nonneg A B)
  calc
    ‖L.connectedCorr A B‖
        <= L.prefactor A B *
          tailContribution M hdec D (L.anchor A) (L.separation A B) :=
      hBridge A B
    _ <= L.prefactor A B *
        (M.energy (L.anchor A) * Real.exp (-(m * L.separation A B))) :=
      mul_le_mul_of_nonneg_left htail (L.prefactor_nonneg A B)
    _ = (L.prefactor A B * M.energy (L.anchor A)) *
        Real.exp (-(m * L.separation A B)) := by
      rw [mul_assoc]

/-!
## Finite-support generalization

The single-anchor `LocalObservableData` measures the cluster tail from one
polymer `anchor A`.  A local observable is more faithfully modeled by a finite
support set of polymers, with the cluster tail measured from every support
polymer.  The following support-set layer is the recommended API upgrade; the
single-anchor structure above is the special case `support A = {anchor A}`.

The support bridge below is proved with the same clean inequality chaining and
depends only on the explicit `hTail`/`hBridge` hypotheses, exactly like the
single-anchor bridge. -/

/-- Abstract data for a pairwise connected-correlator statement with finite
support sets.

`support` gives the finite set of polymers on which each observable lives,
`separation` is the observable-level distance, and `prefactor` absorbs the
local observable norms and finite support constants. -/
structure LocalObservableSupportData (Gamma Obs : Type*) where
  support : Obs -> Finset Gamma
  separation : Obs -> Obs -> Real
  separation_nonneg : forall A B, 0 <= separation A B
  connectedCorr : Obs -> Obs -> Complex
  prefactor : Obs -> Obs -> Real
  prefactor_nonneg : forall A B, 0 <= prefactor A B

namespace LocalObservableData

omit [Fintype Gamma] in
/-- View single-anchor observable data as finite-support observable data with
singleton support. -/
def toSupportData (L : LocalObservableData Gamma Obs) :
    LocalObservableSupportData Gamma Obs where
  support := fun A => {L.anchor A}
  separation := L.separation
  separation_nonneg := L.separation_nonneg
  connectedCorr := L.connectedCorr
  prefactor := L.prefactor
  prefactor_nonneg := L.prefactor_nonneg

end LocalObservableData

/-- The support-set tail: the metric-tail contribution summed over every
support polymer of the source observable. -/
def supportTail
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R : Real) : Real :=
  Finset.sum S (fun g0 => tailContribution M hdec D g0 R)

/-- The support-set tail of an empty observable support is zero. -/
theorem supportTail_empty
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (R : Real) :
    supportTail M hdec D ∅ R = 0 := by
  simp [supportTail]

/-- The finite-support tail reduces to the single-anchor tail on singleton
supports. -/
theorem supportTail_singleton
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (R : Real) :
    supportTail M hdec D ({g0} : Finset Gamma) R =
      tailContribution M hdec D g0 R := by
  simp [supportTail]

/-- The finite-support tail for a single-anchor observable is the original
anchored tail contribution. -/
theorem supportTail_toSupportData
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableData Gamma Obs) (A : Obs) (R : Real) :
    supportTail M hdec D ((LocalObservableData.toSupportData L).support A) R =
      tailContribution M hdec D (L.anchor A) R := by
  simp [LocalObservableData.toSupportData, supportTail_singleton]

/-- Each anchored tail contribution is nonnegative term-by-term. -/
theorem tailContribution_nonneg
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (R : Real) :
    0 <= tailContribution M hdec D g0 R := by
  apply tsum_nonneg
  intro X
  exact clusterCoeff_absWeight_nonneg M.toPolymerSystem hdec D X.1

/-- Finite support tails are nonnegative sums of nonnegative anchored tails. -/
theorem supportTail_nonneg
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R : Real) :
    0 <= supportTail M hdec D S R := by
  unfold supportTail
  exact Finset.sum_nonneg (fun g0 _ =>
    tailContribution_nonneg M hdec D g0 R)

/-- A finite support tail is zero exactly when every anchored tail in the
support is zero. -/
theorem supportTail_eq_zero_iff_forall_tailContribution_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R : Real) :
    supportTail M hdec D S R = 0 ↔
      forall g0 : Gamma, g0 ∈ S ->
        tailContribution M hdec D g0 R = 0 := by
  unfold supportTail
  exact Finset.sum_eq_zero_iff_of_nonneg
    (fun g0 _hg0 => tailContribution_nonneg M hdec D g0 R)

/-- If a finite support tail vanishes, every anchored tail in that support
vanishes. -/
theorem tailContribution_eq_zero_of_mem_of_supportTail_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    {S : Finset Gamma} {R : Real} {g0 : Gamma}
    (hTail : supportTail M hdec D S R = 0) (hg0 : g0 ∈ S) :
    tailContribution M hdec D g0 R = 0 :=
  (supportTail_eq_zero_iff_forall_tailContribution_eq_zero
    M hdec D S R).1 hTail g0 hg0

/-- Adding a fresh support polymer splits off its anchored tail. -/
theorem supportTail_insert [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (S : Finset Gamma) (R : Real)
    (hg0 : g0 ∉ S) :
    supportTail M hdec D (insert g0 S) R =
      tailContribution M hdec D g0 R + supportTail M hdec D S R := by
  simpa [supportTail] using
    (Finset.sum_insert hg0 :
      Finset.sum (insert g0 S)
          (fun g => tailContribution M hdec D g R) =
        tailContribution M hdec D g0 R +
          Finset.sum S (fun g => tailContribution M hdec D g R))

/-- The support tail is additive over disjoint finite support unions. -/
theorem supportTail_union [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real)
    (hdisj : Disjoint S T) :
    supportTail M hdec D (S ∪ T) R =
      supportTail M hdec D S R + supportTail M hdec D T R := by
  simpa [supportTail] using
    (Finset.sum_union hdisj :
      Finset.sum (S ∪ T)
          (fun g => tailContribution M hdec D g R) =
        Finset.sum S (fun g => tailContribution M hdec D g R) +
          Finset.sum T (fun g => tailContribution M hdec D g R))

/-- Exact finite inclusion-exclusion identity for support tails. -/
theorem supportTail_union_add_inter [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S ∪ T) R +
      supportTail M hdec D (S ∩ T) R =
        supportTail M hdec D S R + supportTail M hdec D T R := by
  simpa [supportTail] using
    (Finset.sum_union_inter (s₁ := S) (s₂ := T)
      (f := fun g => tailContribution M hdec D g R))

/-- Subtraction form of finite support-tail inclusion-exclusion. -/
theorem supportTail_union_eq_add_sub_inter [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S ∪ T) R =
      supportTail M hdec D S R + supportTail M hdec D T R -
        supportTail M hdec D (S ∩ T) R := by
  have h := supportTail_union_add_inter M hdec D S T R
  linarith

/-- Exact split of a support tail into the part outside `T` and the overlap
with `T`. -/
theorem supportTail_sdiff_add_inter [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S \ T) R +
      supportTail M hdec D (S ∩ T) R =
        supportTail M hdec D S R := by
  have hsum :
      Finset.sum (S \ T ∪ S ∩ T)
          (fun g => tailContribution M hdec D g R) =
        Finset.sum (S \ T) (fun g => tailContribution M hdec D g R) +
          Finset.sum (S ∩ T) (fun g => tailContribution M hdec D g R) :=
    Finset.sum_union (Finset.disjoint_sdiff_inter S T)
  rw [Finset.sdiff_union_inter] at hsum
  simpa [supportTail] using hsum.symm

/-- Subtraction form of the exact support-difference split. -/
theorem supportTail_sdiff_eq_sub_inter [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S \ T) R =
      supportTail M hdec D S R -
        supportTail M hdec D (S ∩ T) R := by
  have h := supportTail_sdiff_add_inter M hdec D S T R
  linarith

/-- Enlarging the observable support can only increase the support tail. -/
theorem supportTail_mono
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    {S T : Finset Gamma} (R : Real) (hST : S ⊆ T) :
    supportTail M hdec D S R <= supportTail M hdec D T R := by
  unfold supportTail
  exact Finset.sum_le_sum_of_subset_of_nonneg hST (by
    intro g _hgT _hgS
    exact tailContribution_nonneg M hdec D g R)

/-- The tail over an intersection is bounded by the left support tail. -/
theorem supportTail_inter_le_left [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S ∩ T) R <= supportTail M hdec D S R :=
  supportTail_mono M hdec D R Finset.inter_subset_left

/-- The tail over an intersection is bounded by the right support tail. -/
theorem supportTail_inter_le_right [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S ∩ T) R <= supportTail M hdec D T R :=
  supportTail_mono M hdec D R Finset.inter_subset_right

/-- The support tail is subadditive over arbitrary finite support unions.
Overlap is harmless: common anchors are overcounted on the right. -/
theorem supportTail_union_le [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S ∪ T) R
      <= supportTail M hdec D S R + supportTail M hdec D T R := by
  calc
    supportTail M hdec D (S ∪ T) R
        = supportTail M hdec D (S ∪ T \ S) R := by
          rw [Finset.union_sdiff_self_eq_union]
    _ = supportTail M hdec D S R + supportTail M hdec D (T \ S) R :=
          supportTail_union M hdec D S (T \ S) R Finset.disjoint_sdiff
    _ <= supportTail M hdec D S R + supportTail M hdec D T R := by
          exact add_le_add_right
            (supportTail_mono M hdec D R Finset.sdiff_subset)
            (supportTail M hdec D S R)

/-- The left support tail is bounded by the tail over a union. -/
theorem supportTail_le_union_left [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D S R <= supportTail M hdec D (S ∪ T) R :=
  supportTail_mono M hdec D R Finset.subset_union_left

/-- The right support tail is bounded by the tail over a union. -/
theorem supportTail_le_union_right [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D T R <= supportTail M hdec D (S ∪ T) R :=
  supportTail_mono M hdec D R Finset.subset_union_right

/-- Removing support points can only decrease the support tail. -/
theorem supportTail_sdiff_le [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S \ T) R <= supportTail M hdec D S R :=
  supportTail_mono M hdec D R Finset.sdiff_subset

/-- The outside piece and overlap piece together recover, hence are bounded by,
the original support tail. -/
theorem supportTail_sdiff_add_inter_le [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R : Real) :
    supportTail M hdec D (S \ T) R +
      supportTail M hdec D (S ∩ T) R <= supportTail M hdec D S R := by
  rw [supportTail_sdiff_add_inter M hdec D S T R]

/-- The support tail of a finite union of support pieces is bounded by the sum
of the individual support tails.  This is the finite-cover overcount form used
when an observable support is decomposed into local pieces. -/
theorem supportTail_biUnion_le [DecidableEq Gamma] {ι : Type*}
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (I : Finset ι) (S : ι -> Finset Gamma) (R : Real) :
    supportTail M hdec D (I.biUnion S) R
      <= I.sum (fun i => supportTail M hdec D (S i) R) := by
  classical
  refine Finset.induction_on I ?empty ?insert
  · simp [supportTail_empty]
  · intro i I hi hI
    calc
      supportTail M hdec D ((insert i I).biUnion S) R
          = supportTail M hdec D (S i ∪ I.biUnion S) R := by
            rw [Finset.biUnion_insert]
      _ <= supportTail M hdec D (S i) R +
          supportTail M hdec D (I.biUnion S) R :=
            supportTail_union_le M hdec D (S i) (I.biUnion S) R
      _ <= supportTail M hdec D (S i) R +
          I.sum (fun j => supportTail M hdec D (S j) R) := by
            exact add_le_add_right hI (supportTail M hdec D (S i) R)
      _ = (insert i I).sum (fun j => supportTail M hdec D (S j) R) := by
            rw [Finset.sum_insert hi]

/-- Uniform finite-cover bound for support tails.

If each local support piece in a finite cover has tail at most `B`, then the
tail of the union is bounded by the number of pieces times `B`. -/
theorem supportTail_biUnion_le_card_mul_bound [DecidableEq Gamma] {ι : Type*}
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (I : Finset ι) (S : ι -> Finset Gamma) (R B : Real)
    (hB : forall i : ι, i ∈ I -> supportTail M hdec D (S i) R <= B) :
    supportTail M hdec D (I.biUnion S) R <= (I.card : Real) * B := by
  calc
    supportTail M hdec D (I.biUnion S) R
        <= I.sum (fun i => supportTail M hdec D (S i) R) :=
          supportTail_biUnion_le M hdec D I S R
    _ <= I.sum (fun _i => B) := by
          exact Finset.sum_le_sum (fun i hi => hB i hi)
    _ = (I.card : Real) * B := by
          simp [Finset.sum_const, nsmul_eq_mul]

/-- Uniform finite-support bound for support tails.

If every anchor in one finite support has tail at most `B`, then the whole
support tail is bounded by the support cardinality times `B`. -/
theorem supportTail_le_card_mul_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R B : Real)
    (hB : forall g0 : Gamma, g0 ∈ S ->
      tailContribution M hdec D g0 R <= B) :
    supportTail M hdec D S R <= (S.card : Real) * B := by
  calc
    supportTail M hdec D S R
        <= S.sum (fun _g0 => B) := by
          unfold supportTail
          exact Finset.sum_le_sum (fun g0 hg0 => hB g0 hg0)
    _ = (S.card : Real) * B := by
          simp [Finset.sum_const, nsmul_eq_mul]

/-- Two-support cardinal overcount bound.

If every anchor in `S ∪ T` has tail at most `B`, then the tail over the union
is bounded by `(S.card + T.card) * B`.  This intentionally overcounts
overlaps, matching the finite-cover bookkeeping used for observable supports. -/
theorem supportTail_union_le_card_add_mul_bound [DecidableEq Gamma]
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S T : Finset Gamma) (R B : Real)
    (hB : forall g0 : Gamma, g0 ∈ S ∪ T ->
      tailContribution M hdec D g0 R <= B) :
    supportTail M hdec D (S ∪ T) R
      <= (((S.card + T.card : Nat) : Real) * B) := by
  have hS :
      supportTail M hdec D S R <= (S.card : Real) * B :=
    supportTail_le_card_mul_bound M hdec D S R B (by
      intro g0 hg0
      exact hB g0 (Finset.mem_union.mpr (Or.inl hg0)))
  have hT :
      supportTail M hdec D T R <= (T.card : Real) * B :=
    supportTail_le_card_mul_bound M hdec D T R B (by
      intro g0 hg0
      exact hB g0 (Finset.mem_union.mpr (Or.inr hg0)))
  calc
    supportTail M hdec D (S ∪ T) R
        <= supportTail M hdec D S R + supportTail M hdec D T R :=
          supportTail_union_le M hdec D S T R
    _ <= (S.card : Real) * B + (T.card : Real) * B :=
          add_le_add hS hT
    _ = (((S.card + T.card : Nat) : Real) * B) := by
          rw [Nat.cast_add]
          ring

/-- Finite-support tail bound obtained by summing the anchored Q6 metric-tail
estimate over the observable support.

This names the support-level estimate used by the finite-support clustering
bridge below.  It is still conditional on the explicit anchored tail bound
`hTail`; no Q6 tail theorem is claimed here. -/
theorem supportTail_le_energy_sum_mul_exp
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R m : Real)
    (hR : 0 <= R)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R))) :
    supportTail M hdec D S R
      <= Finset.sum S (fun g0 => M.energy g0) *
        Real.exp (-(m * R)) := by
  unfold supportTail
  rw [Finset.sum_mul]
  exact Finset.sum_le_sum (fun g0 _hg0 => hTail g0 R hR)

/-- A uniform per-support energy bound converts the support-tail estimate into
a cardinality-times-energy prefactor.

This is useful when the later observable bridge only knows a uniform energy
ceiling on the finite support of the source observable. -/
theorem supportTail_le_card_mul_energyBound_mul_exp
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R m E : Real)
    (hEnergy : forall g0 : Gamma, g0 ∈ S -> M.energy g0 <= E)
    (hR : 0 <= R)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R))) :
    supportTail M hdec D S R
      <= ((S.card : Real) * E) * Real.exp (-(m * R)) := by
  have hSupport :=
    supportTail_le_energy_sum_mul_exp M hdec D S R m hR hTail
  have hEnergySum :
      Finset.sum S (fun g0 => M.energy g0) <= (S.card : Real) * E := by
    calc
      Finset.sum S (fun g0 => M.energy g0)
          <= Finset.sum S (fun _g0 => E) := by
            exact Finset.sum_le_sum (fun g0 hg0 => hEnergy g0 hg0)
      _ = (S.card : Real) * E := by
            simp [Finset.sum_const, nsmul_eq_mul]
  exact hSupport.trans
    (mul_le_mul_of_nonneg_right hEnergySum (le_of_lt (Real.exp_pos _)))

/-- Exponential clustering for the support-indexed connected correlator. -/
def HasExponentialClusteringSupport
    (L : LocalObservableSupportData Gamma Obs)
    (amplitude : Obs -> Obs -> Real) (m : Real) : Prop :=
  forall A B : Obs,
    ‖L.connectedCorr A B‖ <=
      amplitude A B * Real.exp (-(m * L.separation A B))

omit [Fintype Gamma] in
/-- A finite-support clustering bound may be weakened by enlarging the
amplitude. -/
theorem hasExponentialClusteringSupport_of_amplitude_le
    (L : LocalObservableSupportData Gamma Obs)
    {amplitude amplitude' : Obs -> Obs -> Real} {m : Real}
    (hAmp : forall A B : Obs, amplitude A B <= amplitude' A B)
    (hClust : HasExponentialClusteringSupport L amplitude m) :
    HasExponentialClusteringSupport L amplitude' m := by
  intro A B
  exact (hClust A B).trans
    (mul_le_mul_of_nonneg_right (hAmp A B)
      (le_of_lt (Real.exp_pos _)))

omit [Fintype Gamma] in
/-- A finite-support clustering bound at rate `m` also holds at any weaker
rate `m' <= m`, provided the amplitude is nonnegative. -/
theorem hasExponentialClusteringSupport_of_rate_le
    (L : LocalObservableSupportData Gamma Obs)
    {amplitude : Obs -> Obs -> Real} {m m' : Real}
    (hAmpNonneg : forall A B : Obs, 0 <= amplitude A B)
    (hm : m' <= m)
    (hClust : HasExponentialClusteringSupport L amplitude m) :
    HasExponentialClusteringSupport L amplitude m' := by
  intro A B
  have hSep : 0 <= L.separation A B := L.separation_nonneg A B
  have hMul : m' * L.separation A B <= m * L.separation A B :=
    mul_le_mul_of_nonneg_right hm hSep
  have hExp :
      Real.exp (-(m * L.separation A B)) <=
        Real.exp (-(m' * L.separation A B)) := by
    exact Real.exp_le_exp.mpr (neg_le_neg hMul)
  exact (hClust A B).trans
    (mul_le_mul_of_nonneg_left hExp (hAmpNonneg A B))

omit [Fintype Gamma] in
/-- The finite-support clustering predicate reduces definitionally to the
single-anchor predicate for singleton-support data. -/
theorem hasExponentialClusteringSupport_toSupportData_iff
    (L : LocalObservableData Gamma Obs)
    (amplitude : Obs -> Obs -> Real) (m : Real) :
    HasExponentialClusteringSupport (LocalObservableData.toSupportData L)
        amplitude m ↔
      HasExponentialClustering L amplitude m := by
  rfl

/-- Support-set observable-level exponential clustering from the same explicit
Q6-style tail bound and an observable-to-cluster bridge summed over the source
support.

This is the recommended Q8 bridge lemma at finite-support granularity.  As
with the single-anchor version, the hard work is isolated in `hTail` (the Q6
metric tail estimate, eventually supplied by `kp_tail_bound`) and `hBridge`
(the expansion/locality comparison for the chosen loop observables).  The
resulting amplitude sums the KP energy over the source support. -/
theorem hasExponentialClusteringSupport_of_supportTail_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    (m : Real)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B)) :
    HasExponentialClusteringSupport L
      (fun A B => L.prefactor A B *
        Finset.sum (L.support A) (fun g0 => M.energy g0)) m := by
  intro A B
  have hstep :
      supportTail M hdec D (L.support A) (L.separation A B)
        <= Finset.sum (L.support A) (fun g0 => M.energy g0) *
            Real.exp (-(m * L.separation A B)) := by
    exact supportTail_le_energy_sum_mul_exp M hdec D (L.support A)
      (L.separation A B) m (L.separation_nonneg A B) hTail
  calc
    ‖L.connectedCorr A B‖
        <= L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B) :=
      hBridge A B
    _ <= L.prefactor A B *
        (Finset.sum (L.support A) (fun g0 => M.energy g0) *
          Real.exp (-(m * L.separation A B))) :=
      mul_le_mul_of_nonneg_left hstep (L.prefactor_nonneg A B)
    _ = (L.prefactor A B *
          Finset.sum (L.support A) (fun g0 => M.energy g0)) *
        Real.exp (-(m * L.separation A B)) := by
      rw [mul_assoc]

/-- If the source observable has empty polymer support, the support-tail bridge
forces its connected correlator to vanish.

This is a bookkeeping edge case for the finite-support API.  It uses only the
explicit bridge hypothesis and the definition of `supportTail`; it does not use
or claim the Q6 metric-tail theorem. -/
theorem connectedCorr_eq_zero_of_support_empty
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    {A B : Obs}
    (hSupport : L.support A = ∅)
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B)) :
    L.connectedCorr A B = 0 := by
  have hNorm :
      ‖L.connectedCorr A B‖ <= 0 := by
    calc
      ‖L.connectedCorr A B‖
          <= L.prefactor A B *
              supportTail M hdec D (L.support A) (L.separation A B) :=
            hBridge A B
      _ = 0 := by
            rw [hSupport, supportTail_empty, mul_zero]
  exact norm_eq_zero.mp (le_antisymm hNorm (norm_nonneg _))

/-- If the support-tail itself vanishes, the bridge hypothesis forces the
connected correlator to vanish.

This generalizes `connectedCorr_eq_zero_of_support_empty`: the support may be
nonempty, but every anchored tail in it has already been shown to contribute
zero in aggregate.  It is still only support-interface bookkeeping, not a Q6
metric-tail theorem or a concrete observable expansion. -/
theorem connectedCorr_eq_zero_of_supportTail_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    {A B : Obs}
    (hTailZero :
      supportTail M hdec D (L.support A) (L.separation A B) = 0)
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B)) :
    L.connectedCorr A B = 0 := by
  have hNorm :
      ‖L.connectedCorr A B‖ <= 0 := by
    calc
      ‖L.connectedCorr A B‖
          <= L.prefactor A B *
              supportTail M hdec D (L.support A) (L.separation A B) :=
            hBridge A B
      _ = 0 := by
            rw [hTailZero, mul_zero]
  exact norm_eq_zero.mp (le_antisymm hNorm (norm_nonneg _))

/-- If every anchored tail in the source observable support vanishes, the
support-tail bridge forces the connected correlator to vanish.

This is the pointwise form of `connectedCorr_eq_zero_of_supportTail_eq_zero`.
It is useful when a concrete observable bridge proves vanishing anchor by
anchor rather than first packaging the finite sum as zero. -/
theorem connectedCorr_eq_zero_of_forall_tailContribution_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    {A B : Obs}
    (hTailZero : forall g0 : Gamma, g0 ∈ L.support A ->
      tailContribution M hdec D g0 (L.separation A B) = 0)
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B)) :
    L.connectedCorr A B = 0 :=
  connectedCorr_eq_zero_of_supportTail_eq_zero M hdec D L
    ((supportTail_eq_zero_iff_forall_tailContribution_eq_zero M hdec D
      (L.support A) (L.separation A B)).2 hTailZero)
    hBridge

/-- Finite-support exponential clustering from a uniform per-anchor tail
estimate.

This is the cardinality-prefactor form of the Q8 bridge: if each support
polymer of the source observable has the same exponential tail bound `B`, then
the observable support contributes only its finite cardinality factor.  This is
still conditional on the explicit anchored tail estimate; no Q6 tail theorem or
concrete observable expansion is claimed here. -/
theorem hasExponentialClusteringSupport_of_uniform_anchor_tail_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    (m B : Real)
    (hTail : forall A Bobs : Obs, forall g0 : Gamma, g0 ∈ L.support A ->
      tailContribution M hdec D g0 (L.separation A Bobs) <=
        B * Real.exp (-(m * L.separation A Bobs)))
    (hBridge : forall A Bobs : Obs,
      ‖L.connectedCorr A Bobs‖ <=
        L.prefactor A Bobs *
          supportTail M hdec D (L.support A) (L.separation A Bobs)) :
    HasExponentialClusteringSupport L
      (fun A Bobs => L.prefactor A Bobs * ((L.support A).card : Real) * B) m := by
  intro A Bobs
  have hstep :
      supportTail M hdec D (L.support A) (L.separation A Bobs)
        <= ((L.support A).card : Real) *
            (B * Real.exp (-(m * L.separation A Bobs))) := by
    exact supportTail_le_card_mul_bound M hdec D (L.support A)
      (L.separation A Bobs) (B * Real.exp (-(m * L.separation A Bobs)))
      (hTail A Bobs)
  calc
    ‖L.connectedCorr A Bobs‖
        <= L.prefactor A Bobs *
          supportTail M hdec D (L.support A) (L.separation A Bobs) :=
      hBridge A Bobs
    _ <= L.prefactor A Bobs *
        (((L.support A).card : Real) *
          (B * Real.exp (-(m * L.separation A Bobs)))) := by
      exact mul_le_mul_of_nonneg_left hstep (L.prefactor_nonneg A Bobs)
    _ = (L.prefactor A Bobs * ((L.support A).card : Real) * B) *
        Real.exp (-(m * L.separation A Bobs)) := by
      ring

/-- Finite-support exponential clustering with a uniform energy ceiling on the
source observable support.

This packages the common case where all support polymers contributing to
observable `A` have energy at most `E`; the amplitude then carries the finite
support cardinality factor explicitly. -/
theorem hasExponentialClusteringSupport_of_uniform_energy_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    (m E : Real)
    (hEnergy : forall (A : Obs) (g0 : Gamma),
      g0 ∈ L.support A -> M.energy g0 <= E)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B)) :
    HasExponentialClusteringSupport L
      (fun A B => L.prefactor A B * ((L.support A).card : Real) * E) m := by
  intro A B
  have hstep :
      supportTail M hdec D (L.support A) (L.separation A B)
        <= (((L.support A).card : Real) * E) *
            Real.exp (-(m * L.separation A B)) := by
    exact supportTail_le_card_mul_energyBound_mul_exp M hdec D
      (L.support A) (L.separation A B) m E (hEnergy A)
      (L.separation_nonneg A B) hTail
  calc
    ‖L.connectedCorr A B‖
        <= L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B) :=
      hBridge A B
    _ <= L.prefactor A B *
        ((((L.support A).card : Real) * E) *
          Real.exp (-(m * L.separation A B))) := by
      exact mul_le_mul_of_nonneg_left hstep (L.prefactor_nonneg A B)
    _ = (L.prefactor A B * ((L.support A).card : Real) * E) *
        Real.exp (-(m * L.separation A B)) := by
      ring

end ExponentialClustering
end GateYM
end NullEdge
end Draft
end PhysicsSM
