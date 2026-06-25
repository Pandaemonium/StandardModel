import Mathlib
import PhysicsSM.NullStrand.Conventions

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

end PhysicsSM.NullStrand.NullLift
