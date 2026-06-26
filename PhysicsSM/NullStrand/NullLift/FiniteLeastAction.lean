import Mathlib
import PhysicsSM.NullStrand.Conventions
import PhysicsSM.NullStrand.Probability.Finite

/-!
# NullStrand.NullLift.FiniteLeastAction

Finite null-lift least-action statements for connected angular graphs.

These declarations are intentionally unweighted in this first trusted pass:
`weightedLaplacian` is an alias for `SimpleGraph.lapMatrix ℝ`, which already
packages the finite spectral facts needed for the current READY cluster.

Provenance:
- `Mathlib.Combinatorics.SimpleGraph.LapMatrix`
- `Mathlib.Combinatorics.SimpleGraph.Connectivity`
- NullStrand finite-graph scaffold.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullLift

open scoped BigOperators
open Matrix

open SimpleGraph

/-- Working alias used by the NullLift API. -/
abbrev weightedLaplacian {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] : Matrix Ω Ω ℝ :=
  G.lapMatrix ℝ

/-- The finite graph Laplacian is symmetric as a real matrix. -/
theorem weightedLaplacian_selfAdjoint {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] :
    (weightedLaplacian G).IsSymm := by
  simpa [weightedLaplacian] using (SimpleGraph.isSymm_lapMatrix (R := ℝ) (G := G))

/-- The finite graph Laplacian is positive semidefinite in its real form. -/
theorem weightedLaplacian_nonneg {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] :
    PosSemidef (weightedLaplacian G) := by
  simpa [weightedLaplacian] using
    (SimpleGraph.posSemidef_lapMatrix (R := ℝ) (G := G))

/-- Kernel characterization on a connected finite graph: only constants survive. -/
theorem weightedLaplacian_kernel_eq_constants
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj]
    (hconn : G.Connected) (f : Ω → ℝ) :
    weightedLaplacian G *ᵥ f = 0 ↔ ∃ c : ℝ, ∀ ω, f ω = c := by
  constructor
  · intro hker
    have hreach :
        ∀ i j : Ω, G.Reachable i j → f i = f j :=
      (SimpleGraph.lapMatrix_mulVec_eq_zero_iff_forall_reachable (G := G) (x := f)).1 hker
    let ω0 : Ω := Classical.choice hconn.nonempty
    refine ⟨f ω0, ?_⟩
    intro ω
    exact hreach ω ω0 (hconn ω ω0)
  · rintro ⟨c, hc⟩
    refine
      (SimpleGraph.lapMatrix_mulVec_eq_zero_iff_forall_reachable (G := G) (x := f)).2 ?_
    intro i j _hij
    rw [hc i, hc j]

/-- If two scalar fields have equal Laplacians on a connected finite graph,
then they differ by a constant. -/
theorem leastActionDrift_unique
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj]
    (hconn : G.Connected) {f1 f2 : Ω → ℝ}
    (hEq : weightedLaplacian G *ᵥ f1 = weightedLaplacian G *ᵥ f2) :
    ∃ c : ℝ, ∀ ω, f1 ω = f2 ω + c := by
  have hzero : weightedLaplacian G *ᵥ (fun ω => f1 ω - f2 ω) = 0 := by
    ext ω
    have hEqω : (weightedLaplacian G *ᵥ f1) ω =
        (weightedLaplacian G *ᵥ f2) ω := congrFun hEq ω
    calc
      (weightedLaplacian G *ᵥ (fun ω => f1 ω - f2 ω)) ω
          = ∑ ω' : Ω, weightedLaplacian G ω ω' * (f1 ω' - f2 ω') := by
            rfl
      _ = ∑ ω' : Ω,
            (weightedLaplacian G ω ω' * f1 ω' -
              weightedLaplacian G ω ω' * f2 ω') := by
            refine Finset.sum_congr rfl ?_
            intro ω' _hω'
            ring
      _ = (∑ ω' : Ω, weightedLaplacian G ω ω' * f1 ω') -
            (∑ ω' : Ω, weightedLaplacian G ω ω' * f2 ω') := by
            rw [Finset.sum_sub_distrib]
      _ = (weightedLaplacian G *ᵥ f1) ω - (weightedLaplacian G *ᵥ f2) ω := by
            rfl
      _ = 0 := by
            rw [hEqω]
            ring
  obtain ⟨c, hc⟩ :=
    (weightedLaplacian_kernel_eq_constants (G := G) hconn
      (fun ω => f1 ω - f2 ω)).1 hzero
  refine ⟨c, ?_⟩
  intro ω
  linarith [hc ω]

/-! ## Least-action current uniqueness (LA-003) -/

/-- LA-003. The least-action **current** (potential difference across each ordered
pair) is uniquely determined by the Laplacian source, even though the potential
itself is only determined up to an additive constant. -/
theorem leastActionCurrent_unique
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj]
    (hconn : G.Connected) {f1 f2 : Ω → ℝ}
    (hEq : weightedLaplacian G *ᵥ f1 = weightedLaplacian G *ᵥ f2) :
    ∀ i j, f1 i - f1 j = f2 i - f2 j := by
  obtain ⟨c, hc⟩ := leastActionDrift_unique (G := G) hconn hEq
  intro i j
  rw [hc i, hc j]; ring

/-- LA-003 (anchored form). Fixing the potential at a single basepoint removes the
remaining gauge freedom, so the least-action potential is then unique. -/
theorem leastActionPotential_unique_of_anchor
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj]
    (hconn : G.Connected) {f1 f2 : Ω → ℝ}
    (hEq : weightedLaplacian G *ᵥ f1 = weightedLaplacian G *ᵥ f2)
    (ω0 : Ω) (hanchor : f1 ω0 = f2 ω0) :
    f1 = f2 := by
  obtain ⟨c, hc⟩ := leastActionDrift_unique (G := G) hconn hEq
  have hc0 : c = 0 := by have := hc ω0; rw [hanchor] at this; linarith
  funext ω; rw [hc ω, hc0, add_zero]

/-! ## Weighted-Laplacian range facts (LA-002) -/

/-- The image of any field under the Laplacian has zero total sum: the Laplacian
is a discrete divergence, so its range lies in the zero-sum hyperplane. -/
theorem weightedLaplacian_mulVec_sum_zero
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (f : Ω → ℝ) :
    ∑ ω, (weightedLaplacian G *ᵥ f) ω = 0 := by
  have hsymm : (weightedLaplacian G).IsSymm := SimpleGraph.isSymm_lapMatrix G
  have hrow : ∀ ω', (∑ ω, weightedLaplacian G ω' ω) = 0 := by
    intro ω'
    have h := congrFun (SimpleGraph.lapMatrix_mulVec_const_eq_zero (R := ℝ) G) ω'
    simpa [Matrix.mulVec, dotProduct, weightedLaplacian] using h
  calc
    ∑ ω, (weightedLaplacian G *ᵥ f) ω
        = ∑ ω, ∑ ω', weightedLaplacian G ω ω' * f ω' := rfl
    _ = ∑ ω', ∑ ω, weightedLaplacian G ω ω' * f ω' := Finset.sum_comm
    _ = ∑ ω', (∑ ω, weightedLaplacian G ω ω') * f ω' := by
          refine Finset.sum_congr rfl ?_; intro ω' _; rw [Finset.sum_mul]
    _ = ∑ ω', (∑ ω, weightedLaplacian G ω' ω) * f ω' := by
          refine Finset.sum_congr rfl ?_; intro ω' _
          congr 1
          refine Finset.sum_congr rfl ?_; intro ω _
          have hentry : weightedLaplacian G ω ω' = weightedLaplacian G ω' ω := by
            have := congrFun (congrFun hsymm ω') ω
            simpa [Matrix.transpose_apply] using this
          rw [hentry]
    _ = 0 := by simp [hrow]

/-- LA-002 (range inclusion). The range of the Laplacian is contained in the
zero-sum hyperplane. -/
theorem weightedLaplacian_range_subset_zeroSum
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] :
    Set.range (fun f : Ω → ℝ => weightedLaplacian G *ᵥ f) ⊆ {g | ∑ ω, g ω = 0} := by
  rintro g ⟨f, rfl⟩
  exact weightedLaplacian_mulVec_sum_zero G f

/-- Linear functional summing all coordinates; its kernel is the zero-sum
hyperplane. -/
def sumLin (Ω : Type*) [Fintype Ω] : (Ω → ℝ) →ₗ[ℝ] ℝ where
  toFun f := ∑ ω, f ω
  map_add' f g := by simp [Finset.sum_add_distrib]
  map_smul' c f := by simp [Finset.mul_sum]

/-- LA-002 (full range characterization). On a connected finite graph the range of
the weighted Laplacian is **exactly** the zero-sum hyperplane: a source `g` admits
a least-action potential iff its total charge vanishes. The proof is a
rank-nullity / dimension count (`ker` is one-dimensional constants, the zero-sum
hyperplane has codimension one, and the range is contained in it). -/
theorem weightedLaplacian_range_eq_zeroSum
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (hconn : G.Connected) :
    Set.range (fun f : Ω → ℝ => weightedLaplacian G *ᵥ f) = {g : Ω → ℝ | ∑ ω, g ω = 0} := by
  haveI : Nonempty Ω := hconn.nonempty
  set L := (weightedLaplacian G).mulVecLin with hL
  have hker : Module.finrank ℝ (LinearMap.ker L) = 1 := by
    have hconst : LinearMap.ker L = Submodule.span ℝ {(Function.const Ω (1:ℝ))} := by
      ext f
      simp only [hL, LinearMap.mem_ker, Matrix.mulVecLin_apply, Submodule.mem_span_singleton]
      rw [weightedLaplacian_kernel_eq_constants G hconn]
      constructor
      · rintro ⟨c, hc⟩; exact ⟨c, by funext ω; simp [hc ω]⟩
      · rintro ⟨c, rfl⟩; exact ⟨c, by intro ω; simp⟩
    rw [hconst]
    have hne : (Function.const Ω (1:ℝ)) ≠ 0 := by
      obtain ⟨ω⟩ := (inferInstance : Nonempty Ω)
      intro h; have := congrFun h ω; simp at this
    exact finrank_span_singleton hne
  have hdim : Module.finrank ℝ (Ω → ℝ) = Fintype.card Ω := Module.finrank_fintype_fun_eq_card ℝ
  have hrnL := LinearMap.finrank_range_add_finrank_ker L
  have hsurj : Function.Surjective (sumLin Ω) := by
    intro a
    obtain ⟨ω0⟩ := (inferInstance : Nonempty Ω)
    refine ⟨fun ω => if ω = ω0 then a else 0, ?_⟩
    simp [sumLin]
  have hrangeTop : LinearMap.range (sumLin Ω) = ⊤ := LinearMap.range_eq_top.mpr hsurj
  have hrnS := LinearMap.finrank_range_add_finrank_ker (sumLin Ω)
  have hrangeS1 : Module.finrank ℝ (LinearMap.range (sumLin Ω)) = 1 := by
    rw [hrangeTop]
    simp [finrank_top, Module.finrank_self]
  have hle : LinearMap.range L ≤ LinearMap.ker (sumLin Ω) := by
    rintro g ⟨f, rfl⟩
    simp only [LinearMap.mem_ker, sumLin, LinearMap.coe_mk, AddHom.coe_mk]
    simpa [hL, Matrix.mulVecLin_apply] using weightedLaplacian_mulVec_sum_zero G f
  have hfeq : Module.finrank ℝ (LinearMap.range L)
      = Module.finrank ℝ (LinearMap.ker (sumLin Ω)) := by
    rw [hdim] at hrnL hrnS
    rw [hker] at hrnL
    rw [hrangeS1] at hrnS
    omega
  have hsub : LinearMap.range L = LinearMap.ker (sumLin Ω) :=
    Submodule.eq_of_le_of_finrank_eq hle hfeq
  have hr : Set.range (fun f : Ω → ℝ => weightedLaplacian G *ᵥ f)
      = (LinearMap.range L : Set (Ω → ℝ)) := by
    rw [LinearMap.coe_range]; rfl
  have hz : {g : Ω → ℝ | ∑ ω, g ω = 0} = (LinearMap.ker (sumLin Ω) : Set (Ω → ℝ)) := by
    ext g; simp [LinearMap.mem_ker, sumLin]
  rw [hr, hz, hsub]

/-! ## Equivariance of the selected dynamics (LA-004) -/

/-- LA-004 (entrywise). Every graph automorphism preserves the weighted Laplacian
matrix entrywise. -/
theorem weightedLaplacian_apply_aut
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (σ : G ≃g G) (a b : Ω) :
    weightedLaplacian G (σ a) (σ b) = weightedLaplacian G a b := by
  simp only [weightedLaplacian, SimpleGraph.lapMatrix, Matrix.sub_apply,
    SimpleGraph.adjMatrix_apply, SimpleGraph.degMatrix, Matrix.diagonal_apply,
    σ.injective.eq_iff, SimpleGraph.Iso.map_adj_iff, SimpleGraph.Iso.degree_eq]

/-- LA-004 (operator). The selected least-action dynamics is equivariant under
graph automorphisms: applying the Laplacian commutes with the relabelling
`f ↦ f ∘ σ`. -/
theorem weightedLaplacian_mulVec_equivariant
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (σ : G ≃g G) (f : Ω → ℝ) (a : Ω) :
    (weightedLaplacian G *ᵥ (fun x => f (σ x))) a = (weightedLaplacian G *ᵥ f) (σ a) := by
  show ∑ b, weightedLaplacian G a b * f (σ b) = ∑ c, weightedLaplacian G (σ a) c * f c
  rw [← Equiv.sum_comp σ.toEquiv (fun c => weightedLaplacian G (σ a) c * f c)]
  refine Finset.sum_congr rfl fun b _ => ?_
  show weightedLaplacian G a b * f (σ b) = weightedLaplacian G (σ a) (σ b) * f (σ b)
  rw [weightedLaplacian_apply_aut]

/-! ## Selected finite dynamics: least-action jump generator (LA-005)

This is the wave-5 assembly layer. The least-action **selector** is the weighted
graph Laplacian `L = D - A`. Its negation `-L = A - D` is a finite continuous-time
jump generator (`PhysicsSM.NullStrand.Probability.FiniteJumpGenerator`): the
off-diagonal entries are the nonnegative adjacency weights and every row sums to
zero, so the associated forward (master) equation conserves probability. Because
`L` is symmetric the column sums also vanish, hence the **uniform/constant law is
invariant** for the selected dynamics. This packages the least-action selector as
a finite kernel and exhibits an invariant law, and the generator inherits the
automorphism equivariance of `L`. -/

open PhysicsSM.NullStrand.Probability in
/-- LA-005. The least-action selector packaged as a finite continuous-time jump
generator: the negated weighted Laplacian `-L = A - D`. -/
def leastActionGenerator {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] :
    FiniteJumpGenerator Ω where
  rate i j := - weightedLaplacian G i j
  offdiag_nonneg := by
    intro i j h
    have hij : weightedLaplacian G i j = - (G.adjMatrix ℝ) i j := by
      simp [weightedLaplacian, SimpleGraph.lapMatrix, SimpleGraph.degMatrix, h]
    rw [hij, neg_neg, SimpleGraph.adjMatrix_apply]
    split <;> norm_num
  row_sum_zero := by
    intro i
    have hrow : ∑ j, weightedLaplacian G i j = 0 := by
      have := congrFun (SimpleGraph.lapMatrix_mulVec_const_eq_zero (R := ℝ) G) i
      simpa [weightedLaplacian, Matrix.mulVec, dotProduct] using this
    simp [weightedLaplacian, Finset.sum_neg_distrib, hrow]

/-- The generator's rate is the negated Laplacian, by definition. -/
theorem leastActionGenerator_rate {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (i j : Ω) :
    (leastActionGenerator G).rate i j = - weightedLaplacian G i j := rfl

/-- LA-005 (mass conservation). The forward master equation of the least-action
generator conserves total probability: `∑ i ṗ i = 0`. -/
theorem leastActionGenerator_mass_conserved {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (p : Ω → ℝ) :
    ∑ i, (∑ j, (leastActionGenerator G).rate j i * p j) = 0 :=
  PhysicsSM.NullStrand.Probability.masterEquation_mass_conserved
    (leastActionGenerator G) p

/-- The column sums of the least-action generator vanish (by symmetry of `L`).
This is the dual conservation law that makes the uniform law stationary. -/
theorem leastActionGenerator_col_sum_zero {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (i : Ω) :
    ∑ j, (leastActionGenerator G).rate j i = 0 := by
  have hsymm : (weightedLaplacian G).IsSymm := weightedLaplacian_selfAdjoint G
  have hrow : ∑ j, weightedLaplacian G i j = 0 := by
    have := congrFun (SimpleGraph.lapMatrix_mulVec_const_eq_zero (R := ℝ) G) i
    simpa [weightedLaplacian, Matrix.mulVec, dotProduct] using this
  calc
    ∑ j, (leastActionGenerator G).rate j i
        = ∑ j, - weightedLaplacian G i j := by
          refine Finset.sum_congr rfl ?_
          intro j _
          show - weightedLaplacian G j i = - weightedLaplacian G i j
          rw [hsymm.apply i j]
    _ = 0 := by simp [Finset.sum_neg_distrib, hrow]

/-- LA-005 (invariant law). The uniform/constant law `fun _ => c` is invariant for
the selected least-action dynamics: the forward master-equation rate of change of
each coordinate vanishes. This is the requested invariant-law preservation for the
finite least-action selector. -/
theorem leastActionGenerator_const_stationary {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (c : ℝ) (i : Ω) :
    ∑ j, (leastActionGenerator G).rate j i * c = 0 := by
  rw [← Finset.sum_mul, leastActionGenerator_col_sum_zero, zero_mul]

/-- LA-005 (equivariance). The least-action generator inherits the automorphism
equivariance of the Laplacian: relabelling by a graph automorphism preserves each
rate. -/
theorem leastActionGenerator_rate_equivariant {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (σ : G ≃g G) (a b : Ω) :
    (leastActionGenerator G).rate (σ a) (σ b) = (leastActionGenerator G).rate a b := by
  simp only [leastActionGenerator_rate, weightedLaplacian_apply_aut]

/-! ## Selected discrete-time step: least-action transition matrix (LA-006)

This is the wave-6 assembly layer. The continuous-time least-action generator
`leastActionGenerator G = -L` is turned into a *finite discrete-time* selected
dynamics step by a single explicit Euler update with step size `t`:

```text
leastActionStep G t = I + t • (leastActionGenerator G).rate = I - t • L.
```

Everything below is finite matrix algebra: no analytic limits, semigroups or
measure theory are used. The off-diagonal entries are `t · A_{ij} ≥ 0` whenever
`0 ≤ t`, and the diagonal entry of row `i` is `1 - t · deg(i)`, which is `≥ 0`
exactly when `t · deg(i) ≤ 1`. These two facts are the *exact* hypotheses needed
for the step to be a genuine (entrywise nonnegative, row-stochastic) transition
matrix. Because `L` is symmetric the matrix is in fact doubly stochastic, so the
uniform/constant law is invariant, and it inherits the automorphism equivariance
of `L`. -/

/-- The diagonal of the weighted Laplacian is the vertex degree. -/
theorem weightedLaplacian_diag {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (i : Ω) :
    weightedLaplacian G i i = (G.degree i : ℝ) := by
  simp [weightedLaplacian, SimpleGraph.lapMatrix, SimpleGraph.degMatrix,
    SimpleGraph.adjMatrix_apply]

/-- The diagonal of the least-action generator rate is minus the vertex degree. -/
theorem leastActionGenerator_rate_diag {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (i : Ω) :
    (leastActionGenerator G).rate i i = - (G.degree i : ℝ) := by
  rw [leastActionGenerator_rate, weightedLaplacian_diag]

/-- LA-006. The selected discrete-time dynamics step with step size `t`:
the explicit-Euler transition matrix `I + t • (leastActionGenerator G).rate`,
equal to `I - t • weightedLaplacian G`. -/
def leastActionStep {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) : Matrix Ω Ω ℝ :=
  fun i j => (1 : Matrix Ω Ω ℝ) i j + t * (leastActionGenerator G).rate i j

/-- Defining entrywise formula of the step matrix. -/
theorem leastActionStep_apply {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (i j : Ω) :
    leastActionStep G t i j
      = (1 : Matrix Ω Ω ℝ) i j + t * (leastActionGenerator G).rate i j := rfl

/-- LA-006 (Laplacian form). The step matrix is `I - t • L`. -/
theorem leastActionStep_eq_sub_laplacian {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) :
    leastActionStep G t = (1 : Matrix Ω Ω ℝ) - t • weightedLaplacian G := by
  ext i j
  simp only [leastActionStep, leastActionGenerator_rate, Matrix.sub_apply,
    Matrix.smul_apply, smul_eq_mul]
  ring

/-- The diagonal entry of the step matrix in row `i` is `1 - t · deg(i)`. -/
theorem leastActionStep_diag {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (i : Ω) :
    leastActionStep G t i i = 1 - t * (G.degree i : ℝ) := by
  rw [leastActionStep_apply, leastActionGenerator_rate_diag, Matrix.one_apply_eq]
  ring

/-- The off-diagonal entry of the step matrix is `t · A_{ij}` (a nonnegative
adjacency weight scaled by `t`). -/
theorem leastActionStep_offdiag {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) {i j : Ω} (h : i ≠ j) :
    leastActionStep G t i j = t * (G.adjMatrix ℝ) i j := by
  rw [leastActionStep_apply, Matrix.one_apply_ne h, zero_add,
    leastActionGenerator_rate]
  have hij : weightedLaplacian G i j = - (G.adjMatrix ℝ) i j := by
    simp [weightedLaplacian, SimpleGraph.lapMatrix, SimpleGraph.degMatrix, h]
  rw [hij]; ring

/-! ### Stochasticity -/

/-- LA-006 (row-sum one). Every row of the step matrix sums to `1`: it is a
row-stochastic transition matrix (no step-size hypothesis needed). -/
theorem leastActionStep_row_sum {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (i : Ω) :
    ∑ j, leastActionStep G t i j = 1 := by
  have hone : ∑ j, (1 : Matrix Ω Ω ℝ) i j = 1 := by
    simp [Matrix.one_apply]
  calc
    ∑ j, leastActionStep G t i j
        = (∑ j, (1 : Matrix Ω Ω ℝ) i j)
            + t * ∑ j, (leastActionGenerator G).rate i j := by
          rw [Finset.mul_sum, ← Finset.sum_add_distrib]
          rfl
    _ = 1 := by rw [hone, (leastActionGenerator G).row_sum_zero i]; ring

/-- LA-006 (column-sum one). Every column of the step matrix sums to `1`: by
symmetry of `L` the step is in fact doubly stochastic. -/
theorem leastActionStep_col_sum {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (j : Ω) :
    ∑ i, leastActionStep G t i j = 1 := by
  have hone : ∑ i, (1 : Matrix Ω Ω ℝ) i j = 1 := by
    simp [Matrix.one_apply]
  calc
    ∑ i, leastActionStep G t i j
        = (∑ i, (1 : Matrix Ω Ω ℝ) i j)
            + t * ∑ i, (leastActionGenerator G).rate i j := by
          rw [Finset.mul_sum, ← Finset.sum_add_distrib]
          rfl
    _ = 1 := by rw [hone, leastActionGenerator_col_sum_zero G j]; ring

/-- LA-006 (off-diagonal nonnegativity). With a nonnegative step size the
off-diagonal entries are nonnegative. -/
theorem leastActionStep_offdiag_nonneg {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] {t : ℝ} (ht : 0 ≤ t) {i j : Ω}
    (h : i ≠ j) : 0 ≤ leastActionStep G t i j := by
  rw [leastActionStep_apply, Matrix.one_apply_ne h, zero_add]
  exact mul_nonneg ht ((leastActionGenerator G).offdiag_nonneg i j h)

/-- LA-006 (nonnegativity). Under the *exact* step-size hypothesis
`0 ≤ t` and `∀ i, t · deg(i) ≤ 1` every entry of the step matrix is nonnegative.
Together with `leastActionStep_row_sum` this exhibits `leastActionStep G t` as a
genuine row-stochastic transition matrix. -/
theorem leastActionStep_nonneg {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] {t : ℝ} (ht0 : 0 ≤ t)
    (htdeg : ∀ i, t * (G.degree i : ℝ) ≤ 1) (i j : Ω) :
    0 ≤ leastActionStep G t i j := by
  rcases eq_or_ne i j with rfl | h
  · rw [leastActionStep_diag]; linarith [htdeg i]
  · exact leastActionStep_offdiag_nonneg G ht0 h

/-! ### Invariant law preservation -/

/-- Law-level pushforward `(ν P)_j = ∑_i ν_i P_{ij}` through the step matrix. -/
def leastActionPush {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (ν : Ω → ℝ) : Ω → ℝ :=
  fun j => ∑ i, ν i * leastActionStep G t i j

/-- LA-006 (constant/uniform stationary law). The constant law `fun _ => c` is
invariant under the step pushforward: this is the requested invariant-law
preservation, and it is a direct consequence of double stochasticity
(`leastActionStep_col_sum`). -/
theorem leastActionPush_const_invariant {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (c : ℝ) :
    leastActionPush G t (fun _ => c) = fun _ => c := by
  funext j
  simp only [leastActionPush]
  rw [← Finset.mul_sum, leastActionStep_col_sum, mul_one]

/-- The step pushforward preserves total mass (row-stochastic conservation law). -/
theorem leastActionPush_total_mass {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (ν : Ω → ℝ) :
    ∑ j, leastActionPush G t ν j = ∑ i, ν i := by
  simp only [leastActionPush]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro i _
  rw [← Finset.mul_sum, leastActionStep_row_sum, mul_one]

/-- The constant/uniform law is preserved along every finite iterate. -/
theorem leastActionPush_iterate_const_invariant {Ω : Type*} [Fintype Ω]
    [DecidableEq Ω] (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (c : ℝ)
    (n : ℕ) : (leastActionPush G t)^[n] (fun _ => c) = fun _ => c := by
  induction n with
  | zero => simp
  | succ n ih => rw [Function.iterate_succ_apply', ih, leastActionPush_const_invariant]

/-- LA-006 (uniform probability law). On a nonempty state space the uniform law
`fun _ => (card Ω)⁻¹` is a probability law that is invariant for the step. -/
theorem leastActionPush_uniform_invariant {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) :
    leastActionPush G t (fun _ => (Fintype.card Ω : ℝ)⁻¹)
      = fun _ => (Fintype.card Ω : ℝ)⁻¹ :=
  leastActionPush_const_invariant G t _

/-! ### Automorphism equivariance -/

/-- LA-006 (equivariance, entrywise). The step matrix inherits the automorphism
equivariance of `L`: relabelling by a graph automorphism preserves every entry. -/
theorem leastActionStep_apply_aut {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (σ : G ≃g G) (a b : Ω) :
    leastActionStep G t (σ a) (σ b) = leastActionStep G t a b := by
  rw [leastActionStep_apply, leastActionStep_apply,
    leastActionGenerator_rate_equivariant]
  congr 1
  by_cases h : a = b
  · subst h; simp [Matrix.one_apply_eq]
  · rw [Matrix.one_apply_ne h, Matrix.one_apply_ne (fun he => h (σ.injective he))]

/-- LA-006 (equivariance, operator). Applying the step matrix commutes with the
relabelling `f ↦ f ∘ σ` induced by a graph automorphism. -/
theorem leastActionStep_mulVec_equivariant {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    (G : SimpleGraph Ω) [DecidableRel G.Adj] (t : ℝ) (σ : G ≃g G) (f : Ω → ℝ)
    (a : Ω) :
    (leastActionStep G t *ᵥ (fun x => f (σ x))) a
      = (leastActionStep G t *ᵥ f) (σ a) := by
  show ∑ b, leastActionStep G t a b * f (σ b)
        = ∑ c, leastActionStep G t (σ a) c * f c
  rw [← Equiv.sum_comp σ.toEquiv (fun c => leastActionStep G t (σ a) c * f c)]
  refine Finset.sum_congr rfl fun b _ => ?_
  show leastActionStep G t a b * f (σ b)
        = leastActionStep G t (σ a) (σ b) * f (σ b)
  rw [leastActionStep_apply_aut]

end PhysicsSM.NullStrand.NullLift
